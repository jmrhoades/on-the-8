//
//  PGMidi.m
//  PGMidi
//
#import "PGMidi.h"

#import "PGArc.h"

// For some reason, this is nut pulled in by the umbrella header
#import <CoreMIDI/MIDINetworkSession.h>

/// A helper that NSLogs an error message if "c" is an error code
#define NSLogError(c,str) do{if (c) NSLog(@"Error (%@): %ld:%@", str, (long)c,[NSError errorWithDomain:NSMachErrorDomain code:c userInfo:nil]);}while(false)

NSString * PGMidiSourceAddedNotification = @"PGMidiSourceAddedNotification";
NSString * PGMidiSourceRemovedNotification = @"PGMidiSourceRemovedNotification";
NSString * PGMidiDestinationAddedNotification = @"PGMidiDestinationAddedNotification";
NSString * PGMidiDestinationRemovedNotification = @"PGMidiDestinationRemovedNotification";
NSString * PGMidiSetupChangedNotification = @"PGMidiSetupChangedNotification";

NSString * kPGMidiConnectionKey = @"connection";

//==============================================================================

static void PGMIDINotifyProc(const MIDINotification *message, void *refCon);
static void PGMIDIReadProc(const MIDIPacketList *pktlist, void *readProcRefCon, void *srcConnRefCon);

@interface PGMidi ()
- (void) scanExistingDevices;
- (MIDIPortRef) outputPort;
@end

//==============================================================================

static
NSString *NameOfEndpoint(MIDIEndpointRef ref)
{
    NSString *string = nil;

    MIDIEntityRef entity = 0;
    MIDIEndpointGetEntity(ref, &entity);

    CFPropertyListRef properties = nil;
    OSStatus s = MIDIObjectGetProperties(entity, &properties, true);
    if (s)
    {
        string = @"Unknown name";
    }
    else
    {
        //NSLog(@"Properties = %@", properties);
        NSDictionary *dictionary = arc_cast<NSDictionary>(properties);
        string = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"name"]];
        CFRelease(properties);
    }

    return string;
}

static
BOOL IsNetworkSession(MIDIEndpointRef ref)
{
    MIDIEntityRef entity = 0;
    MIDIEndpointGetEntity(ref, &entity);

    BOOL hasMidiRtpKey = NO;
    CFPropertyListRef properties = nil;
    OSStatus s = MIDIObjectGetProperties(entity, &properties, true);
    if (!s)
    {
        NSDictionary *dictionary = arc_cast<NSDictionary>(properties);
        hasMidiRtpKey = [dictionary valueForKey:@"apple.midirtp.session"] != nil;
        CFRelease(properties);
    }

    return hasMidiRtpKey;
}

//==============================================================================

@implementation PGMidiConnection

@synthesize midi;
@synthesize endpoint;
@synthesize name;
@synthesize isNetworkSession;

- (id) initWithMidi:(PGMidi*)m endpoint:(MIDIEndpointRef)e
{
    if ((self = [super init]))
    {
        midi                = m;
        endpoint            = e;
        name                = NameOfEndpoint(e);
        isNetworkSession    = IsNetworkSession(e);
    }
    return self;
}

@end

//==============================================================================

@implementation PGMidiSource

@synthesize delegate;

- (id) initWithMidi:(PGMidi*)m endpoint:(MIDIEndpointRef)e
{
    if ((self = [super initWithMidi:m endpoint:e]))
    {
    }
    return self;
}

// NOTE: Called on a separate high-priority thread, not the main runloop
- (void) midiRead:(const MIDIPacketList *)pktlist
{
    [delegate midiSource:self midiReceived:pktlist];
}

static
void PGMIDIReadProc(const MIDIPacketList *pktlist, void *readProcRefCon, void *srcConnRefCon)
{
    PGMidiSource *self = arc_cast<PGMidiSource>(srcConnRefCon);
    [self midiRead:pktlist];
}

@end

//==============================================================================

@implementation PGMidiDestination

- (id) initWithMidi:(PGMidi*)m endpoint:(MIDIEndpointRef)e
{
    if ((self = [super initWithMidi:m endpoint:e]))
    {
        midi     = m;
        endpoint = e;
    }
    return self;
}

- (void) sendBytes:(const UInt8*)bytes size:(UInt32)size
{
    //NSLog(@"%s(%u bytes to core MIDI)", __func__, unsigned(size));
    assert(size < 65536);
    Byte packetBuffer[size+100];
    MIDIPacketList *packetList = (MIDIPacketList*)packetBuffer;
    MIDIPacket     *packet     = MIDIPacketListInit(packetList);
    packet = MIDIPacketListAdd(packetList, sizeof(packetBuffer), packet, 0, size, bytes);

    [self sendPacketList:packetList];
}

- (void) sendPacketList:(const MIDIPacketList *)packetList
{
    // Send it
    OSStatus s = MIDISend(midi.outputPort, endpoint, packetList);
    NSLogError(s, @"Sending MIDI");
}

@end

//==============================================================================

@implementation PGMidi

@synthesize delegate;
@synthesize sources,destinations;
@synthesize automaticSourceDelegate;
@synthesize services;
@synthesize browser;

- (id) init
{
    if ((self = [super init]))
    {
        sources      = [NSMutableArray new];
        destinations = [NSMutableArray new];
        services     = [[NSMutableDictionary alloc] initWithCapacity:16];

        OSStatus s = MIDIClientCreate((CFStringRef)@"Onthe8 MIDI Client", PGMIDINotifyProc, arc_cast<void>(self), &client);
        NSLogError(s, @"Onthe8 MIDI client");

        /*
        s = MIDIOutputPortCreate(client, (CFStringRef)@"MidiMonitor Output Port", &outputPort);
        NSLogError(s, @"Create output MIDI port");
         */

        s = MIDIInputPortCreate(client, (CFStringRef)@"Onthe8 Input Port", PGMIDIReadProc, arc_cast<void>(self), &inputPort);
        NSLogError(s, @"Onthe8 input MIDI port");
        
        
        browser = [[NSNetServiceBrowser alloc] init];
        browser.delegate = self;
        [browser searchForServicesOfType:MIDINetworkBonjourServiceType /* i.e. @"_apple-midi._udp"*/
                                inDomain:@""];

        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(midiNetworkSessionUpdated:)
                                                     name:MIDINetworkNotificationSessionDidChange
                                                   object:[MIDINetworkSession defaultSession]];

        
        
        [self scanExistingDevices];
    }

    return self;
}

- (void) dealloc
{
    if (outputPort)
    {
        OSStatus s = MIDIPortDispose(outputPort);
        NSLogError(s, @"Dispose MIDI port");
    }

    if (inputPort)
    {
        OSStatus s = MIDIPortDispose(inputPort);
        NSLogError(s, @"Dispose MIDI port");
    }

    if (client)
    {
        OSStatus s = MIDIClientDispose(client);
        NSLogError(s, @"Dispose MIDI client");
    }

    browser = nil;
    services = nil;
}

- (NSUInteger) numberOfConnections
{
    return sources.count + destinations.count;
}

- (MIDIPortRef) outputPort
{
    return outputPort;
}

- (void) enableNetwork:(BOOL)enabled
{
    MIDINetworkSession* session = [MIDINetworkSession defaultSession];
    session.enabled = YES;
    session.connectionPolicy = MIDINetworkConnectionPolicy_Anyone;
}

//==============================================================================
#pragma mark Connect/disconnect

- (void) midiNetworkSessionUpdated:(NSNotification*) notification {
    //NSLog(@"PGMIDI: Session updated: %@", notification);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PGMidiSourceAddedNotification object:self];
}

- (PGMidiSource*) getSource:(MIDIEndpointRef)source
{
    for (PGMidiSource *s in sources)
    {
        if (s.endpoint == source) return s;
    }
    return nil;
}

- (PGMidiDestination*) getDestination:(MIDIEndpointRef)destination
{
    for (PGMidiDestination *d in destinations)
    {
        if (d.endpoint == destination) return d;
    }
    return nil;
}

- (void) connectSource:(MIDIEndpointRef)endpoint
{
    //NSLog(@"PGMIDI: connectSource MIDIEndpointRef: %@", NameOfEndpoint(endpoint));

    PGMidiSource *source = [[PGMidiSource alloc] initWithMidi:self endpoint:endpoint];
    [sources addObject:source];
	
	//Attach it to the automaticSourceDelegate as soon as its connected (could be nil)
	source.delegate = automaticSourceDelegate;

    [delegate midi:self sourceAdded:source];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PGMidiSourceAddedNotification
                                                        object:self 
                                                      userInfo:[NSDictionary dictionaryWithObject:source 
                                                                                           forKey:kPGMidiConnectionKey]];
    
    OSStatus s = MIDIPortConnectSource(inputPort, endpoint, arc_cast<void>(source));
    NSLogError(s, @"Connecting to MIDI source");
}

- (void) disconnectSource:(MIDIEndpointRef)endpoint
{
    PGMidiSource *source = [self getSource:endpoint];

    if (source)
    {
        //NSLog(@"PGMIDI: disconnectSource");

        OSStatus s = MIDIPortDisconnectSource(inputPort, endpoint);
        NSLogError(s, @"Disconnecting from MIDI source");
        [sources removeObject:source];
        
        [delegate midi:self sourceRemoved:source];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PGMidiSourceRemovedNotification
                                                            object:self 
                                                          userInfo:[NSDictionary dictionaryWithObject:source 
                                                                                               forKey:kPGMidiConnectionKey]];

    }

}

- (void) connectDestination:(MIDIEndpointRef)endpoint
{
    //NSLog(@"PGMIDI: connectDestination");

    PGMidiDestination *destination = [[PGMidiDestination alloc] initWithMidi:self endpoint:endpoint];
    [destinations addObject:destination];
    [delegate midi:self destinationAdded:destination];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PGMidiDestinationAddedNotification
                                                        object:self 
                                                      userInfo:[NSDictionary dictionaryWithObject:destination 
                                                                                           forKey:kPGMidiConnectionKey]];
}

- (void) disconnectDestination:(MIDIEndpointRef)endpoint
{
    PGMidiDestination *destination = [self getDestination:endpoint];

    if (destination)
    {
        //NSLog(@"PGMIDI: disconnectDestination");

        
        [destinations removeObject:destination];
        
        [delegate midi:self destinationRemoved:destination];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PGMidiDestinationRemovedNotification
                                                            object:self 
                                                          userInfo:[NSDictionary dictionaryWithObject:destination 
                                                                                               forKey:kPGMidiConnectionKey]];

    }

}

- (void) scanExistingDevices
{
    //const ItemCount numberOfDestinations = MIDIGetNumberOfDestinations();
    
    const ItemCount numberOfSources      = MIDIGetNumberOfSources();
    
    /*
    for (ItemCount index = 0; index < numberOfDestinations; ++index)
        [self connectDestination:MIDIGetDestination(index)];
    */
    
    for (ItemCount index = 0; index < numberOfSources; ++index) {
        [self connectSource:MIDIGetSource(index)];
    }
}

- (void) setAutomaticSourceDelegate:(id<PGMidiSourceDelegate>)asd
{
	automaticSourceDelegate = asd;
	for (PGMidiSource *source in sources)
	{
		source.delegate = asd;
	}
}

- (BOOL) isMidiConnected {
    
    //NSLog(@"PGMIDI: isMidiConnected");
    
    int c = 0;
    const ItemCount numberOfSources = MIDIGetNumberOfSources();
    for (ItemCount index = 0; index < numberOfSources; ++index) {
        c++;
    }
    NSUInteger c2 = [[MIDINetworkSession defaultSession] connections].count;
    
    //NSNetService *service = [services allValues][0];
    //for (MIDINetworkConnection* connection in [[MIDINetworkSession defaultSession] connections]) {
        //NSLog(@"Name: %@ net service name: %@ service name: %@", [[connection host] name], [[connection host] netServiceName], [service name]);
    //}
    
    if (c2 > 0 || c > 1) {
        //NSLog(@"YES");
        return YES;
    }
    
    return NO;
}

//==============================================================================
#pragma mark Notifications

- (void) midiNotifyAdd:(const MIDIObjectAddRemoveNotification *)notification
{
    //NSLog(@"PGMIDI: midiNotifyAdd");

    if (notification->childType == kMIDIObjectType_Destination)
        [self connectDestination:(MIDIEndpointRef)notification->child];
    else if (notification->childType == kMIDIObjectType_Source)
        [self connectSource:(MIDIEndpointRef)notification->child];
}

- (void) midiNotifyRemove:(const MIDIObjectAddRemoveNotification *)notification
{
    //NSLog(@"PGMIDI: midiNotifyRemove");

    if (notification->childType == kMIDIObjectType_Destination)
        [self disconnectDestination:(MIDIEndpointRef)notification->child];
    else if (notification->childType == kMIDIObjectType_Source)
        [self disconnectSource:(MIDIEndpointRef)notification->child];
}

- (void) midiPropertyChanged:(const MIDIObjectPropertyChangeNotification *)notification
{
    //NSLog(@"PGMIDI: midiPropertyChanged %@", notification->propertyName);
    
    int c = 0;
    const ItemCount numberOfSources = MIDIGetNumberOfSources();
    for (ItemCount index = 0; index < numberOfSources; ++index) {
        c++;
    }

    //int c2 = [[MIDINetworkSession defaultSession] connections].count;
    
    
    
    /*
    NSNetService *service = [services allValues][0];
    for (MIDINetworkConnection* connection in [[MIDINetworkSession defaultSession] connections]) {
        NSString *cM = [NSString stringWithFormat:@"Name: %@ net service name: %@ service name: %@", [[connection host] name], [[connection host] netServiceName], [service name]];
        message = [message stringByAppendingString:cM];
    }
     */
    
    
    //NSString *message = [NSString stringWithFormat:@"PGMIDI sources.count: %d \n\n", c];
    //message = [message stringByAppendingString:[NSString stringWithFormat:@"MIDINetworkSession connections: %d", c2]];
    
    //NSLog(@"PGMIDI sources.count: %d network session count %d", c, c2);
    /*
    NSNetService *service = [services allValues][0];
    for (MIDINetworkConnection* connection in [[MIDINetworkSession defaultSession] connections]) {
        NSString *cM = [NSString stringWithFormat:@"Name: %@ net service name: %@ service name: %@", [[connection host] name], [[connection host] netServiceName], [service name]];
        message = [message stringByAppendingString:cM];
    }
    */
    /*
    [[NSNotificationCenter defaultCenter] postNotificationName:PGMidiSetupChangedNotification
                                                        object:self
                                                      userInfo:@{@"message":message}];
    */
}

- (void) midiNotify:(const MIDINotification*)notification
{
    //NSLog(@"PGMIDI: midiNotify");
    
    switch (notification->messageID)
    {
        case kMIDIMsgObjectAdded:
            //NSLog(@"kMIDIMsgObjectAdded");

            [self midiNotifyAdd:(const MIDIObjectAddRemoveNotification *)notification];
            break;
        case kMIDIMsgObjectRemoved:
            //NSLog(@"kMIDIMsgObjectRemoved");

            [self midiNotifyRemove:(const MIDIObjectAddRemoveNotification *)notification];
            break;
        case kMIDIMsgSetupChanged:
            //NSLog(@"kMIDIMsgSetupChanged");
            [self midiPropertyChanged:(const MIDIObjectPropertyChangeNotification *)notification];
           
            break;

        case kMIDIMsgPropertyChanged:
            //NSLog(@"kMIDIMsgPropertyChanged");
            //[self midiPropertyChanged:(const MIDIObjectPropertyChangeNotification *)notification];
            break;

        case kMIDIMsgThruConnectionsChanged:
            //NSLog(@"kMIDIMsgThruConnectionsChanged");
            break;

        case kMIDIMsgSerialPortOwnerChanged:
            //NSLog(@"kMIDIMsgSerialPortOwnerChanged");
            break;

        case kMIDIMsgIOError:
            //NSLog(@"kMIDIMsgIOError");

            break;
    }
}

void PGMIDINotifyProc(const MIDINotification *message, void *refCon)
{
    PGMidi *self = arc_cast<PGMidi>(refCon);
    [self midiNotify:message];
}

//==============================================================================
#pragma mark MIDI Output

- (void) sendPacketList:(const MIDIPacketList *)packetList
{
    for (ItemCount index = 0; index < MIDIGetNumberOfDestinations(); ++index)
    {
        MIDIEndpointRef outputEndpoint = MIDIGetDestination(index);
        if (outputEndpoint)
        {
            // Send it
            OSStatus s = MIDISend(outputPort, outputEndpoint, packetList);
            NSLogError(s, @"Sending MIDI");
        }
    }
}

- (void) sendBytes:(const UInt8*)data size:(UInt32)size
{
    //NSLog(@"%s(%u bytes to core MIDI)", __func__, unsigned(size));
    assert(size < 65536);
    Byte packetBuffer[size+100];
    MIDIPacketList *packetList = (MIDIPacketList*)packetBuffer;
    MIDIPacket     *packet     = MIDIPacketListInit(packetList);

    packet = MIDIPacketListAdd(packetList, sizeof(packetBuffer), packet, 0, size, data);

    [self sendPacketList:packetList];
}

- (void) sendBytes:(const UInt8*)data size:(UInt32)size withTime:(MIDITimeStamp)time
{
    //NSLog(@"%s(%u bytes to core MIDI)", __func__, unsigned(size));
    assert(size < 65536);
    Byte packetBuffer[size+100];
    MIDIPacketList *packetList = (MIDIPacketList*)packetBuffer;
    MIDIPacket     *packet     = MIDIPacketListInit(packetList);
    
    packet = MIDIPacketListAdd(packetList, sizeof(packetBuffer), packet, time, size, data);
    
    [self sendPacketList:packetList];
}

#pragma mark - NSNetServiceBrowserDelegate

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more {
    //NSLog(@"PGMIDI NSNetServiceBrowserDelegate: Found service %@ on %@", [aService name], [aService hostName]);
    
    // Filter out local services
    if (![[aService name] isEqualToString:[[UIDevice currentDevice] name]]) {
        [services setValue:aService forKey:[aService name]];
    }
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didRemoveService:(NSNetService *)aService moreComing:(BOOL)more {
    //NSLog(@"PGMIDI NSNetServiceBrowserDelegate: Removing service %@", [aService name]);
    [services removeObjectForKey:[aService name]];
}

- (void) netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
   //NSLog(@"PGMIDI NSNetServiceBrowserDelegate: Browser stopped.");
}

#pragma mark - NSNetServiceDelegate

-(void)netServiceDidResolveAddress:(NSNetService *)service {
    [service setDelegate:nil];
    //NSLog(@"PGMIDI NSNetServiceBrowserDelegate: Resolved service name: %@ host name: %@", [service name], [service hostName]);
    //[self connectToService:service];
}

-(void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict {
    [service setDelegate:nil];
    //NSLog(@"PGMIDI NSNetServiceBrowserDelegate: Could not resolve: %@", errorDict);
}

- (void)netServiceDidStop:(NSNetService *)service {
    [service setDelegate:nil];
    //NSLog(@"PGMIDI NSNetServiceBrowserDelegate: Service stopped: %@", [service name]);
}


@end
