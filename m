Return-Path: <io-uring+bounces-10873-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7A5C991D8
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 22:00:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E5393A3C23
	for <lists+io-uring@lfdr.de>; Mon,  1 Dec 2025 21:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6563E27FD5A;
	Mon,  1 Dec 2025 21:00:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6302620E5
	for <io-uring@vger.kernel.org>; Mon,  1 Dec 2025 21:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764622806; cv=none; b=NXuFYzew6LjdtkafewiWtFdWhqMHTCKrUnd4so12il1pklrDN5eZjfyyKXLGrQZPlbJIEFp1DYmi69FrpUJvCUHezv/PDCFbjrmD0U15oDwqLNuoTKxLQ0VL2hwDbkKu1iP4OLrnl3DSwX462uOQmK7CerB0Y7V1c5QZ2KxnX1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764622806; c=relaxed/simple;
	bh=zb+EHJAydDhu+4qGRS/5mWsdHqTlBEX6LmhyeUloRKY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=V4cpMAC2y0il/3ScRYDKS19Wvp2GaUVBGP/QCvnEbVuLHH9w2ajuasFh5unakeOohinSONbcO2xhtwy5gpngLC58a5AwYnrHyn87qMa3ScO69pV+xVTrBpWZY/cjnzE4Ok2a8LUS9ct8W7T7ob+hiGkyKVnlB1cyl9GUMfHjSWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7c754daf77fso6131583a34.1
        for <io-uring@vger.kernel.org>; Mon, 01 Dec 2025 13:00:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764622803; x=1765227603;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=slbvYkDj3vulwfsXI0a+jPW3kg4QgckpqlKofx55bFM=;
        b=NPXY9NfJ70/tm/y7vncymIqiXajNvf0s6E/iTSIgLwZ4eDTR0ULeLR+VrVd6QXo8He
         sAcKmuw2cbuOUv0FwqjcRj3bDrxgZi8YBALNQIeuuJp+NzwATmfwfSuKcSa6j5gAsMYY
         RYmHch4ob4gvF/nsX9BfCAD8CXII070blQw3SOrlYpd72CLuR+KaTcZV7YElDwDrSSW5
         Fo4Z2KuwPvUZT9A9WD6Pnm3F3N1xAWCRyovPq3BGpA17jKnx7Ogkit/46U5rryeL9qZa
         LJ5RjxkjgD5baXvXmzOyLTpYINHY7ukklIJYyauZXB8rRBf2atB+cuR6uaxQhHhWDKDv
         y4JQ==
X-Forwarded-Encrypted: i=1; AJvYcCXY7AGBZ4UI5w1LG2FpObEmLfubwXEW+ZOyX0/UhukFLq5xFdlAmjiJfoe64UhZgpabAKPxb0EAPQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoOk7z08bkBumpcYCtjrpAPz/V3Xw0gYuymtnI7S77ElzkHgLH
	IUxLFUB0QChSwbW4joTHjYL0yxYk+hPHNgRTYNCmuHXhtQgQGHl+DntgHi1ZKgPnpp7rYbj4fjW
	4jAQspfe3xiyoHySmZnWb8ERdrFpqN/COLWthJ6swL0aZz0fIHplIpMdL0h4=
X-Google-Smtp-Source: AGHT+IFBqsV1XB87Ixi/jFJ+HT3p1cE3JugVvOk1WZfaltXDl1OG2I2+D/mVjpZQr7yPkgSvdCcFWTBaLwfmtxYjSSzdKsNQ7HsD
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:151f:b0:450:c16b:7ade with SMTP id
 5614622812f47-45101ed206dmr17338343b6e.28.1764622803503; Mon, 01 Dec 2025
 13:00:03 -0800 (PST)
Date: Mon, 01 Dec 2025 13:00:03 -0800
In-Reply-To: <6fcfa902-5d59-4d2a-9fa6-ea59529f6710@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692e01d3.a70a0220.2ea503.00ba.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] memory leak in io_submit_sqes (5)
From: syzbot <syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

SYZFAIL: failed to recv rpc

SYZFAIL: failed to recv rpc
fd=3D3 want=3D4 recv=3D0 n=3D0 (errno 9: Bad file descriptor)


Warning: Permanently added '10.128.1.13' (ED25519) to the list of known hos=
ts.
2025/12/01 20:59:35 parsed 1 programs
[   45.094356][ T5813] cgroup: Unknown subsys name 'net'
[   45.202443][ T5813] cgroup: Unknown subsys name 'cpuset'
[   45.208862][ T5813] cgroup: Unknown subsys name 'rlimit'
Setting up swapspace version 1, size =3D 127995904 bytes
[   53.863046][ T5813] Adding 124996k swap on ./swap-file.  Priority:0 exte=
nts:1 across:124996k=20
[   55.317007][ T5825] soft_limit_in_bytes is deprecated and will be remove=
d. Please report your usecase to linux-mm@kvack.org if you depend on this f=
unctionality.
[   55.448849][ T5830] chnl_net:caif_netlink_parms(): no params data found
[   55.468796][ T5830] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[   55.476764][ T5830] bridge0: port 1(bridge_slave_0) entered disabled sta=
te
[   55.484104][ T5830] bridge_slave_0: entered allmulticast mode
[   55.490494][ T5830] bridge_slave_0: entered promiscuous mode
[   55.497389][ T5830] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[   55.504651][ T5830] bridge0: port 2(bridge_slave_1) entered disabled sta=
te
[   55.511920][ T5830] bridge_slave_1: entered allmulticast mode
[   55.518298][ T5830] bridge_slave_1: entered promiscuous mode
[   55.530562][ T5830] bond0: (slave bond_slave_0): Enslaving as an active =
interface with an up link
[   55.540621][ T5830] bond0: (slave bond_slave_1): Enslaving as an active =
interface with an up link
[   55.555225][ T5830] team0: Port device team_slave_0 added
[   55.561419][ T5830] team0: Port device team_slave_1 added
[   55.571641][ T5830] batman_adv: batadv0: Adding interface: batadv_slave_=
0
[   55.578610][ T5830] batman_adv: batadv0: The MTU of interface batadv_sla=
ve_0 is too small (1500) to handle the transport of batman-adv packets. Pac=
kets going over this interface will be fragmented on layer2 which could imp=
act the performance. Setting the MTU to 1532 would solve the problem.
[   55.604931][ T5830] batman_adv: batadv0: Not using interface batadv_slav=
e_0 (retrying later): interface not active
[   55.616342][ T5830] batman_adv: batadv0: Adding interface: batadv_slave_=
1
[   55.623586][ T5830] batman_adv: batadv0: The MTU of interface batadv_sla=
ve_1 is too small (1500) to handle the transport of batman-adv packets. Pac=
kets going over this interface will be fragmented on layer2 which could imp=
act the performance. Setting the MTU to 1532 would solve the problem.
[   55.649758][ T5830] batman_adv: batadv0: Not using interface batadv_slav=
e_1 (retrying later): interface not active
[   55.667015][ T5830] hsr_slave_0: entered promiscuous mode
[   55.672837][ T5830] hsr_slave_1: entered promiscuous mode
[   55.702718][ T5830] netdevsim netdevsim0 netdevsim0: renamed from eth0
[   55.710523][ T5830] netdevsim netdevsim0 netdevsim1: renamed from eth1
[   55.718180][ T5830] netdevsim netdevsim0 netdevsim2: renamed from eth2
[   55.726058][ T5830] netdevsim netdevsim0 netdevsim3: renamed from eth3
[   55.738320][ T5830] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[   55.745549][ T5830] bridge0: port 2(bridge_slave_1) entered forwarding s=
tate
[   55.752892][ T5830] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[   55.759930][ T5830] bridge0: port 1(bridge_slave_0) entered forwarding s=
tate
[   55.777110][ T5830] 8021q: adding VLAN 0 to HW filter on device bond0
[   55.786285][   T12] bridge0: port 1(bridge_slave_0) entered disabled sta=
te
[   55.793904][   T12] bridge0: port 2(bridge_slave_1) entered disabled sta=
te
[   55.803960][ T5830] 8021q: adding VLAN 0 to HW filter on device team0
[   55.812453][   T59] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[   55.819693][   T59] bridge0: port 1(bridge_slave_0) entered forwarding s=
tate
[   55.831755][   T59] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[   55.838825][   T59] bridge0: port 2(bridge_slave_1) entered forwarding s=
tate
[   55.879152][ T5830] 8021q: adding VLAN 0 to HW filter on device batadv0
[   55.894511][ T5830] veth0_vlan: entered promiscuous mode
[   55.901971][ T5830] veth1_vlan: entered promiscuous mode
[   55.913067][ T5830] veth0_macvtap: entered promiscuous mode
[   55.919675][ T5830] veth1_macvtap: entered promiscuous mode
[   55.928894][ T5830] batman_adv: batadv0: Interface activated: batadv_sla=
ve_0
[   55.938300][ T5830] batman_adv: batadv0: Interface activated: batadv_sla=
ve_1
[   55.947580][   T12] netdevsim netdevsim0 netdevsim0: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   55.956434][   T12] netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   55.965897][   T12] netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   55.974873][   T12] netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   56.025363][   T58] netdevsim netdevsim0 netdevsim3 (unregistering): uns=
et [1, 0] type 2 family 0 port 6081 - 0
[   56.088083][   T58] netdevsim netdevsim0 netdevsim2 (unregistering): uns=
et [1, 0] type 2 family 0 port 6081 - 0
[   56.134632][   T58] netdevsim netdevsim0 netdevsim1 (unregistering): uns=
et [1, 0] type 2 family 0 port 6081 - 0
[   56.183062][   T58] netdevsim netdevsim0 netdevsim0 (unregistering): uns=
et [1, 0] type 2 family 0 port 6081 - 0
[   56.198760][   T12] wlan0: Created IBSS using preconfigured BSSID 50:50:=
50:50:50:50
[   56.207701][   T12] wlan0: Creating new IBSS network, BSSID 50:50:50:50:=
50:50
[   56.218293][   T12] wlan1: Created IBSS using preconfigured BSSID 50:50:=
50:50:50:50
[   56.226287][   T12] wlan1: Creating new IBSS network, BSSID 50:50:50:50:=
50:50
[   56.343504][ T5892] Bluetooth: hci0: unexpected cc 0x0c03 length: 249 > =
1
[   56.350743][ T5892] Bluetooth: hci0: unexpected cc 0x1003 length: 249 > =
9
[   56.358165][ T5892] Bluetooth: hci0: unexpected cc 0x1001 length: 249 > =
9
[   56.365814][ T5892] Bluetooth: hci0: unexpected cc 0x0c23 length: 249 > =
4
[   56.373433][ T5892] Bluetooth: hci0: unexpected cc 0x0c38 length: 249 > =
2
2025/12/01 20:59:49 executed programs: 0
[   59.121698][   T58] bridge_slave_1: left allmulticast mode
[   59.127497][   T58] bridge_slave_1: left promiscuous mode
[   59.134848][   T58] bridge0: port 2(bridge_slave_1) entered disabled sta=
te
[   59.142486][   T58] bridge_slave_0: left allmulticast mode
[   59.148220][   T58] bridge_slave_0: left promiscuous mode
[   59.154181][   T58] bridge0: port 1(bridge_slave_0) entered disabled sta=
te
[   59.203736][   T58] bond0 (unregistering): (slave bond_slave_0): Releasi=
ng backup interface
[   59.213014][   T58] bond0 (unregistering): (slave bond_slave_1): Releasi=
ng backup interface
[   59.222011][   T58] bond0 (unregistering): Released all slaves
[   59.313631][   T58] hsr_slave_0: left promiscuous mode
[   59.319216][   T58] hsr_slave_1: left promiscuous mode
[   59.324844][   T58] batman_adv: batadv0: Interface deactivated: batadv_s=
lave_0
[   59.332334][   T58] batman_adv: batadv0: Removing interface: batadv_slav=
e_0
[   59.339764][   T58] batman_adv: batadv0: Interface deactivated: batadv_s=
lave_1
[   59.347198][   T58] batman_adv: batadv0: Removing interface: batadv_slav=
e_1
[   59.355640][   T58] veth1_macvtap: left promiscuous mode
[   59.361130][   T58] veth0_macvtap: left promiscuous mode
[   59.366742][   T58] veth1_vlan: left promiscuous mode
[   59.372040][   T58] veth0_vlan: left promiscuous mode
[   59.399875][   T58] team0 (unregistering): Port device team_slave_1 remo=
ved
[   59.408653][   T58] team0 (unregistering): Port device team_slave_0 remo=
ved
[   62.564840][ T5134] Bluetooth: hci0: unexpected cc 0x0c03 length: 249 > =
1
[   62.572035][ T5134] Bluetooth: hci0: unexpected cc 0x1003 length: 249 > =
9
[   62.579170][ T5134] Bluetooth: hci0: unexpected cc 0x1001 length: 249 > =
9
[   62.586644][ T5134] Bluetooth: hci0: unexpected cc 0x0c23 length: 249 > =
4
[   62.594085][ T5134] Bluetooth: hci0: unexpected cc 0x0c38 length: 249 > =
2
[   62.632210][ T5983] chnl_net:caif_netlink_parms(): no params data found
[   62.651514][ T5983] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[   62.658706][ T5983] bridge0: port 1(bridge_slave_0) entered disabled sta=
te
[   62.666137][ T5983] bridge_slave_0: entered allmulticast mode
[   62.672389][ T5983] bridge_slave_0: entered promiscuous mode
[   62.678796][ T5983] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[   62.686192][ T5983] bridge0: port 2(bridge_slave_1) entered disabled sta=
te
[   62.693313][ T5983] bridge_slave_1: entered allmulticast mode
[   62.699554][ T5983] bridge_slave_1: entered promiscuous mode
[   62.711639][ T5983] bond0: (slave bond_slave_0): Enslaving as an active =
interface with an up link
[   62.721580][ T5983] bond0: (slave bond_slave_1): Enslaving as an active =
interface with an up link
[   62.735611][ T5983] team0: Port device team_slave_0 added
[   62.742046][ T5983] team0: Port device team_slave_1 added
[   62.752167][ T5983] batman_adv: batadv0: Adding interface: batadv_slave_=
0
[   62.759107][ T5983] batman_adv: batadv0: The MTU of interface batadv_sla=
ve_0 is too small (1500) to handle the transport of batman-adv packets. Pac=
kets going over this interface will be fragmented on layer2 which could imp=
act the performance. Setting the MTU to 1532 would solve the problem.
[   62.785244][ T5983] batman_adv: batadv0: Not using interface batadv_slav=
e_0 (retrying later): interface not active
[   62.796357][ T5983] batman_adv: batadv0: Adding interface: batadv_slave_=
1
[   62.803353][ T5983] batman_adv: batadv0: The MTU of interface batadv_sla=
ve_1 is too small (1500) to handle the transport of batman-adv packets. Pac=
kets going over this interface will be fragmented on layer2 which could imp=
act the performance. Setting the MTU to 1532 would solve the problem.
[   62.829487][ T5983] batman_adv: batadv0: Not using interface batadv_slav=
e_1 (retrying later): interface not active
[   62.847117][ T5983] hsr_slave_0: entered promiscuous mode
[   62.852936][ T5983] hsr_slave_1: entered promiscuous mode
[   63.036253][ T5983] netdevsim netdevsim0 netdevsim0: renamed from eth0
[   63.045375][ T5983] netdevsim netdevsim0 netdevsim1: renamed from eth1
[   63.053519][ T5983] netdevsim netdevsim0 netdevsim2: renamed from eth2
[   63.061789][ T5983] netdevsim netdevsim0 netdevsim3: renamed from eth3
[   63.075975][ T5983] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[   63.083083][ T5983] bridge0: port 2(bridge_slave_1) entered forwarding s=
tate
[   63.090673][ T5983] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[   63.097877][ T5983] bridge0: port 1(bridge_slave_0) entered forwarding s=
tate
[   63.122294][ T5983] 8021q: adding VLAN 0 to HW filter on device bond0
[   63.132914][   T58] bridge0: port 1(bridge_slave_0) entered disabled sta=
te
[   63.140548][   T58] bridge0: port 2(bridge_slave_1) entered disabled sta=
te
[   63.152272][ T5983] 8021q: adding VLAN 0 to HW filter on device team0
[   63.162216][   T79] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[   63.169296][   T79] bridge0: port 1(bridge_slave_0) entered forwarding s=
tate
[   63.178607][   T58] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[   63.185727][   T58] bridge0: port 2(bridge_slave_1) entered forwarding s=
tate
[   63.247759][ T5983] 8021q: adding VLAN 0 to HW filter on device batadv0
[   63.268232][ T5983] veth0_vlan: entered promiscuous mode
[   63.276325][ T5983] veth1_vlan: entered promiscuous mode
[   63.296850][ T5983] veth0_macvtap: entered promiscuous mode
[   63.304290][ T5983] veth1_macvtap: entered promiscuous mode
[   63.314925][ T5983] batman_adv: batadv0: Interface activated: batadv_sla=
ve_0
[   63.334416][ T5983] batman_adv: batadv0: Interface activated: batadv_sla=
ve_1
[   63.344953][   T12] netdevsim netdevsim0 netdevsim0: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   63.354046][   T79] netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   63.363838][   T79] netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   63.383838][   T79] netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 f=
amily 0 port 6081 - 0
SYZFAIL: failed to recv rpc
fd=3D3 want=3D4 recv=3D0 n=3D0 (errno 9: Bad file descriptor)
[   63.428886][   T79] wlan0: Created IBSS using preconfigured BSSID 50:50:=
50:50:50:50
[   63.440292][   T79] wlan0: Creating new IBSS network, BSSID 50:50:50:50:=
50:50
[   63.451963][   T12] wlan1: Created IBSS using preconfigured BSSID 50:50:=
50:50:50:50
[   63.463029][   T12] wlan1: Creating new IBSS network, BSSID 50:50:50:50:=
50:50


syzkaller build log:
go env (err=3D<nil>)
AR=3D'ar'
CC=3D'gcc'
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_ENABLED=3D'1'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
CXX=3D'g++'
GCCGO=3D'gccgo'
GO111MODULE=3D'auto'
GOAMD64=3D'v1'
GOARCH=3D'amd64'
GOAUTH=3D'netrc'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOCACHEPROG=3D''
GODEBUG=3D''
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFIPS140=3D'off'
GOFLAGS=3D''
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build1359059719=3D/tmp/go-build -gno-record-gc=
c-switches'
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMOD=3D'/syzkaller/jobs-2/linux/gopath/src/github.com/google/syzkaller/go.=
mod'
GOMODCACHE=3D'/syzkaller/jobs-2/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs-2/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/usr/local/go'
GOSUMDB=3D'sum.golang.org'
GOTELEMETRY=3D'local'
GOTELEMETRYDIR=3D'/syzkaller/.config/go/telemetry'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/usr/local/go/pkg/tool/linux_amd64'
GOVCS=3D''
GOVERSION=3D'go1.24.4'
GOWORK=3D''
PKG_CONFIG=3D'pkg-config'

git status (err=3D<nil>)
HEAD detached at d6526ea3e
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' -ldflags=3D"-s -w -X github.com/google/syzkaller/pr=
og.GitRevision=3Dd6526ea3e6ad9081c902859bbb80f9f840377cb4 -X github.com/goo=
gle/syzkaller/prog.gitRevisionDate=3D20251126-113115"  ./sys/syz-sysgen | g=
rep -q false || go install -ldflags=3D"-s -w -X github.com/google/syzkaller=
/prog.GitRevision=3Dd6526ea3e6ad9081c902859bbb80f9f840377cb4 -X github.com/=
google/syzkaller/prog.gitRevisionDate=3D20251126-113115"  ./sys/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build -ldflags=3D"-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3Dd6526ea3e6ad9081c902859bbb80f9f840377cb4 -X g=
ithub.com/google/syzkaller/prog.gitRevisionDate=3D20251126-113115"  -o ./bi=
n/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_amd64
g++ -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -std=3Dc++17 -I. -Iexecutor/_include   -DGOOS_linux=3D1 -DGOARCH=
_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"d6526ea3e6ad9081c902859bbb80f9f840=
377cb4\"
/usr/bin/ld: /tmp/ccZ4MFua.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x104): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking
./tools/check-syzos.sh 2>/dev/null



Tested on:

commit:         7d0a66e4 Linux 6.18
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linu=
x.git v6.18
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Df30cc590c4f6da4=
4
dashboard link: https://syzkaller.appspot.com/bug?extid=3D641eec6b7af1f62f2=
b99
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils=
 for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=3D136885125800=
00


