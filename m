Return-Path: <io-uring+bounces-11867-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sM9TIrErcWl1fAAAu9opvQ
	(envelope-from <io-uring+bounces-11867-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 20:40:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BD035C5D3
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 20:40:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BAE1758CEA0
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 19:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1AD267AF6;
	Wed, 21 Jan 2026 19:30:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E25227B352
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 19:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769023807; cv=none; b=gOrDDpssRDEys+gQPQELs7fQyT7DWe/XGhseWuMenMhs/7xdMVUc5yQbHvxcZgs5mQqRZjKes8BGG/ZRLRZ0sg0xDT5SZaXwprxUKx6eWTqYP0tmlizdHlboYnN9o4hUwz+5xseDP3dj+IMPJ87x5s/fcZs6VFPYX6ROaj+EiFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769023807; c=relaxed/simple;
	bh=FVcK+BKwdALfIDPTgoXt66TQ3+UlYW7Fux+edzuy1qc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=u8GdESPlZo59bNo50aC3Dx+oo6OG5UDN5w4WQJTnFPFMbAG4SNxeLYvAHyVKkubRSMLgIZ/mCDbIpavZhaXtsK1kAmD3Rp/ha7F632Kqj0y/NPd9dZ/WVBtn23m192chDxisFQk0zXtD6mdRQfTnWGSQmSqZHig+l6QKvx+uEkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7cfcc8890d2so3283441a34.0
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 11:30:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769023803; x=1769628603;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muT8Dto0tDED6DTfzwkBleL/ypAjLBVavxsWMdBNF4A=;
        b=IDzJTbOu93RhYME97LK1kRlxbZ99ptthwyQmE8BiXKHoGQ2s5x+JBdOZ8hIIdOfUpd
         P8tWch+x73X3TD8/KafnkATdgFUhqxU361Ve+BZ/V4fpUuTulQRUNRPLRrAJlF/S8QW5
         Gv6P7+SDhG26VDTMqICEqr7/73Zi5+QhsTdracnUEP5LrQbBxyndJUz5uFi+A/Z0IAOw
         KE5ixm3ry7tAfFHL9TwGXWB0u8BXPgyOGtjS1Pi2ZzmVdcBrTXfRgZT+CYY3zOliX+Ld
         AWxsf+h20fLUSEbga1tWohzYkn2cZHPs12rke4YbSzPzvs0SoXoxJHbmld7kOIFf+zLZ
         6BGw==
X-Forwarded-Encrypted: i=1; AJvYcCUQ/qsCAreGOvphap+gdLXoddcCA+7mdyHrj9HYS/UdFW8VlGae9Hj8lvC5WSVvALK37nwBIZUqmQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfyenDSIs/xTXGnue2dZM/mHWU7Q4FcxrUKA3MYSV0wdwlPZ9y
	cHMfHMKbz9qtIiIinwzGv5QXusj6GDGiBnmU9C44vwosKvLWEqKI+8H2LEUb1BPNZ6x1GnJXMN9
	p0XxtCBGHlhRUinvvD1GIkiESDdLBwKi0cZXoXX2Z8QlcxcvPHRML8Lc3zsc=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4a8e:b0:661:8a3:ad19 with SMTP id
 006d021491bc7-662c1c0844emr257482eaf.30.1769023802932; Wed, 21 Jan 2026
 11:30:02 -0800 (PST)
Date: Wed, 21 Jan 2026 11:30:02 -0800
In-Reply-To: <b5482f88-8bd6-4683-bc1e-31eb3995ce26@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6971293a.050a0220.706b.0016.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (6)
From: syzbot <syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=8f75eb998b5774eb];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : No valid SPF, No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-11867-lists,io-uring=lfdr.de,4eb282331cab6d5b6588];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	R_DKIM_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kvack.org:email,golang.org:url,syzkaller.appspot.com:url,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 3BD035C5D3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

text=3Dsystem_u:object_r:binfmt_misc_fs_t tclass=3Ddir permissive=3D1
Setting up swapspace version 1, size =3D 127995904 bytes
[   74.071984][   T30] audit: type=3D1400 audit(1769023732.299:71): avc:  d=
enied  { mount } for  pid=3D5816 comm=3D"syz-executor" name=3D"/" dev=3D"bi=
nfmt_misc" ino=3D1 scontext=3Droot:sysadm_r:sysadm_t tcontext=3Dsystem_u:ob=
ject_r:binfmt_misc_fs_t tclass=3Dfilesystem permissive=3D1
[   75.027540][ T5816] Adding 124996k swap on ./swap-file.  Priority:0 exte=
nts:1 across:124996k=20
[   77.035760][   T30] kauditd_printk_skb: 4 callbacks suppressed
[   77.035777][   T30] audit: type=3D1400 audit(1769023735.389:76): avc:  d=
enied  { execmem } for  pid=3D5827 comm=3D"syz-executor" scontext=3Droot:sy=
sadm_r:sysadm_t tcontext=3Droot:sysadm_r:sysadm_t tclass=3Dprocess permissi=
ve=3D1
[   77.115776][   T30] audit: type=3D1400 audit(1769023735.469:77): avc:  d=
enied  { read } for  pid=3D5832 comm=3D"syz-executor" dev=3D"nsfs" ino=3D40=
26531833 scontext=3Droot:sysadm_r:sysadm_t tcontext=3Dsystem_u:object_r:nsf=
s_t tclass=3Dfile permissive=3D1
[   77.197863][   T30] audit: type=3D1400 audit(1769023735.469:78): avc:  d=
enied  { open } for  pid=3D5832 comm=3D"syz-executor" path=3D"net:[40265318=
33]" dev=3D"nsfs" ino=3D4026531833 scontext=3Droot:sysadm_r:sysadm_t tconte=
xt=3Dsystem_u:object_r:nsfs_t tclass=3Dfile permissive=3D1
[   77.256106][   T30] audit: type=3D1400 audit(1769023735.469:79): avc:  d=
enied  { mounton } for  pid=3D5832 comm=3D"syz-executor" path=3D"/" dev=3D"=
sda1" ino=3D2 scontext=3Droot:sysadm_r:sysadm_t tcontext=3Dsystem_u:object_=
r:root_t tclass=3Ddir permissive=3D1
[   77.376461][   T30] audit: type=3D1400 audit(1769023735.749:80): avc:  d=
enied  { mounton } for  pid=3D5832 comm=3D"syz-executor" path=3D"/root/syzk=
aller.ODDuwd/syz-tmp" dev=3D"sda1" ino=3D2042 scontext=3Droot:sysadm_r:sysa=
dm_t tcontext=3Droot:object_r:user_home_t tclass=3Ddir permissive=3D1
[   77.426222][   T30] audit: type=3D1400 audit(1769023735.769:81): avc:  d=
enied  { mount } for  pid=3D5832 comm=3D"syz-executor" name=3D"/" dev=3D"tm=
pfs" ino=3D1 scontext=3Droot:sysadm_r:sysadm_t tcontext=3Dsystem_u:object_r=
:tmpfs_t tclass=3Dfilesystem permissive=3D1
[   77.455015][   T30] audit: type=3D1400 audit(1769023735.769:82): avc:  d=
enied  { mounton } for  pid=3D5832 comm=3D"syz-executor" path=3D"/root/syzk=
aller.ODDuwd/syz-tmp/newroot/dev" dev=3D"tmpfs" ino=3D3 scontext=3Droot:sys=
adm_r:sysadm_t tcontext=3Droot:object_r:user_tmpfs_t tclass=3Ddir permissiv=
e=3D1
[   77.480585][   T30] audit: type=3D1400 audit(1769023735.769:83): avc:  d=
enied  { mount } for  pid=3D5832 comm=3D"syz-executor" name=3D"/" dev=3D"pr=
oc" ino=3D1 scontext=3Droot:sysadm_r:sysadm_t tcontext=3Dsystem_u:object_r:=
proc_t tclass=3Dfilesystem permissive=3D1
[   77.502555][   T30] audit: type=3D1400 audit(1769023735.779:84): avc:  d=
enied  { mounton } for  pid=3D5832 comm=3D"syz-executor" path=3D"/root/syzk=
aller.ODDuwd/syz-tmp/newroot/sys/kernel/debug" dev=3D"debugfs" ino=3D1 scon=
text=3Droot:sysadm_r:sysadm_t tcontext=3Dsystem_u:object_r:debugfs_t tclass=
=3Ddir permissive=3D1
[   77.530216][   T30] audit: type=3D1400 audit(1769023735.779:85): avc:  d=
enied  { mounton } for  pid=3D5832 comm=3D"syz-executor" path=3D"/root/syzk=
aller.ODDuwd/syz-tmp/newroot/proc/sys/fs/binfmt_misc" dev=3D"proc" ino=3D47=
68 scontext=3Droot:sysadm_r:sysadm_t tcontext=3Dsystem_u:object_r:sysctl_fs=
_t tclass=3Ddir permissive=3D1
[   77.582717][ T5832] soft_limit_in_bytes is deprecated and will be remove=
d. Please report your usecase to linux-mm@kvack.org if you depend on this f=
unctionality.
[   78.317095][ T5137] Bluetooth: hci0: unexpected cc 0x0c03 length: 249 > =
1
[   78.335937][ T5137] Bluetooth: hci0: unexpected cc 0x1003 length: 249 > =
9
[   78.343994][ T5137] Bluetooth: hci0: unexpected cc 0x1001 length: 249 > =
9
[   78.352415][ T5137] Bluetooth: hci0: unexpected cc 0x0c23 length: 249 > =
4
[   78.359995][ T5137] Bluetooth: hci0: unexpected cc 0x0c38 length: 249 > =
2
[   79.466468][   T60] wlan0: Created IBSS using preconfigured BSSID 50:50:=
50:50:50:50
[   79.475648][   T60] wlan0: Creating new IBSS network, BSSID 50:50:50:50:=
50:50
[   79.626085][   T60] wlan1: Created IBSS using preconfigured BSSID 50:50:=
50:50:50:50
[   79.633927][   T60] wlan1: Creating new IBSS network, BSSID 50:50:50:50:=
50:50
[   80.241478][ T5888] chnl_net:caif_netlink_parms(): no params data found
[   80.459107][ T5888] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[   80.470259][ T5888] bridge0: port 1(bridge_slave_0) entered disabled sta=
te
[   80.477785][ T5888] bridge_slave_0: entered allmulticast mode
[   80.484650][ T5888] bridge_slave_0: entered promiscuous mode
[   80.494287][ T5888] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[   80.501686][ T5888] bridge0: port 2(bridge_slave_1) entered disabled sta=
te
[   80.509461][ T5888] bridge_slave_1: entered allmulticast mode
[   80.516827][ T5888] bridge_slave_1: entered promiscuous mode
[   80.549445][ T5888] bond0: (slave bond_slave_0): Enslaving as an active =
interface with an up link
[   80.562530][ T5888] bond0: (slave bond_slave_1): Enslaving as an active =
interface with an up link
[   80.602734][ T5888] team0: Port device team_slave_0 added
[   80.611369][ T5888] team0: Port device team_slave_1 added
[   80.637661][ T5888] batman_adv: batadv0: Adding interface: batadv_slave_=
0
[   80.644602][ T5888] batman_adv: batadv0: The MTU of interface batadv_sla=
ve_0 is too small (1500) to handle the transport of batman-adv packets. Pac=
kets going over this interface will be fragmented on layer2 which could imp=
act the performance. Setting the MTU to 1532 would solve the problem.
[   80.670855][ T5888] batman_adv: batadv0: Not using interface batadv_slav=
e_0 (retrying later): interface not active
[   80.685512][ T5888] batman_adv: batadv0: Adding interface: batadv_slave_=
1
[   80.692580][ T5888] batman_adv: batadv0: The MTU of interface batadv_sla=
ve_1 is too small (1500) to handle the transport of batman-adv packets. Pac=
kets going over this interface will be fragmented on layer2 which could imp=
act the performance. Setting the MTU to 1532 would solve the problem.
[   80.719042][ T5888] batman_adv: batadv0: Not using interface batadv_slav=
e_1 (retrying later): interface not active
[   80.754334][ T5888] hsr_slave_0: entered promiscuous mode
[   80.760681][ T5888] hsr_slave_1: entered promiscuous mode
[   80.873414][ T5888] netdevsim netdevsim2 netdevsim0: renamed from eth0
[   80.885521][ T5888] netdevsim netdevsim2 netdevsim1: renamed from eth1
[   80.895484][ T5888] netdevsim netdevsim2 netdevsim2: renamed from eth2
[   80.905604][ T5888] netdevsim netdevsim2 netdevsim3: renamed from eth3
[   80.931341][ T5888] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[   80.938615][ T5888] bridge0: port 2(bridge_slave_1) entered forwarding s=
tate
[   80.947289][ T5888] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[   80.954444][ T5888] bridge0: port 1(bridge_slave_0) entered forwarding s=
tate
[   80.998830][ T5888] 8021q: adding VLAN 0 to HW filter on device bond0
[   81.015302][   T60] bridge0: port 1(bridge_slave_0) entered disabled sta=
te
[   81.024604][   T60] bridge0: port 2(bridge_slave_1) entered disabled sta=
te
[   81.041085][ T5888] 8021q: adding VLAN 0 to HW filter on device team0
[   81.052143][   T12] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[   81.059263][   T12] bridge0: port 1(bridge_slave_0) entered forwarding s=
tate
[   81.071460][   T60] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[   81.078564][   T60] bridge0: port 2(bridge_slave_1) entered forwarding s=
tate
[   81.211172][ T5888] 8021q: adding VLAN 0 to HW filter on device batadv0
[   81.248210][ T5888] veth0_vlan: entered promiscuous mode
[   81.259263][ T5888] veth1_vlan: entered promiscuous mode
[   81.283687][ T5888] veth0_macvtap: entered promiscuous mode
[   81.292476][ T5888] veth1_macvtap: entered promiscuous mode
[   81.308568][ T5888] batman_adv: batadv0: Interface activated: batadv_sla=
ve_0
[   81.321101][ T5888] batman_adv: batadv0: Interface activated: batadv_sla=
ve_1
[   81.336539][   T60] netdevsim netdevsim2 netdevsim0: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   81.348097][   T60] netdevsim netdevsim2 netdevsim1: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   81.357060][   T60] netdevsim netdevsim2 netdevsim2: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   81.367258][   T60] netdevsim netdevsim2 netdevsim3: set [1, 0] type 2 f=
amily 0 port 6081 - 0
2026/01/21 19:28:59 executed programs: 0
[   81.507631][   T90] cfg80211: failed to load regulatory.db
[   81.536157][   T52] Bluetooth: hci0: unexpected cc 0x0c03 length: 249 > =
1
[   81.544946][   T52] Bluetooth: hci0: unexpected cc 0x1003 length: 249 > =
9
[   81.553349][   T52] Bluetooth: hci0: unexpected cc 0x1001 length: 249 > =
9
[   81.564963][   T52] Bluetooth: hci0: unexpected cc 0x0c23 length: 249 > =
4
[   81.584394][   T52] Bluetooth: hci0: unexpected cc 0x0c38 length: 249 > =
2
[   81.880379][ T5930] chnl_net:caif_netlink_parms(): no params data found
[   81.938870][ T5930] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[   81.946021][ T5930] bridge0: port 1(bridge_slave_0) entered disabled sta=
te
[   81.953134][ T5930] bridge_slave_0: entered allmulticast mode
[   81.960371][ T5930] bridge_slave_0: entered promiscuous mode
[   81.969459][ T5930] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[   81.976697][ T5930] bridge0: port 2(bridge_slave_1) entered disabled sta=
te
[   81.983848][ T5930] bridge_slave_1: entered allmulticast mode
[   81.991570][ T5930] bridge_slave_1: entered promiscuous mode
[   82.025152][ T5930] bond0: (slave bond_slave_0): Enslaving as an active =
interface with an up link
[   82.037968][ T5930] bond0: (slave bond_slave_1): Enslaving as an active =
interface with an up link
[   82.063977][ T5930] team0: Port device team_slave_0 added
[   82.073260][ T5930] team0: Port device team_slave_1 added
[   82.096729][ T5930] batman_adv: batadv0: Adding interface: batadv_slave_=
0
[   82.103675][ T5930] batman_adv: batadv0: The MTU of interface batadv_sla=
ve_0 is too small (1500) to handle the transport of batman-adv packets. Pac=
kets going over this interface will be fragmented on layer2 which could imp=
act the performance. Setting the MTU to 1532 would solve the problem.
[   82.129911][ T5930] batman_adv: batadv0: Not using interface batadv_slav=
e_0 (retrying later): interface not active
[   82.141687][ T5930] batman_adv: batadv0: Adding interface: batadv_slave_=
1
[   82.148881][ T5930] batman_adv: batadv0: The MTU of interface batadv_sla=
ve_1 is too small (1500) to handle the transport of batman-adv packets. Pac=
kets going over this interface will be fragmented on layer2 which could imp=
act the performance. Setting the MTU to 1532 would solve the problem.
[   82.175166][ T5930] batman_adv: batadv0: Not using interface batadv_slav=
e_1 (retrying later): interface not active
[   82.213049][ T5930] hsr_slave_0: entered promiscuous mode
[   82.219381][ T5930] hsr_slave_1: entered promiscuous mode
[   82.225304][ T5930] debugfs: 'hsr0' already exists in 'hsr'
[   82.231462][ T5930] Cannot create hsr debugfs directory
[   82.338888][ T5930] netdevsim netdevsim0 netdevsim0: renamed from eth0
[   82.349132][ T5930] netdevsim netdevsim0 netdevsim1: renamed from eth1
[   82.359560][ T5930] netdevsim netdevsim0 netdevsim2: renamed from eth2
[   82.369490][ T5930] netdevsim netdevsim0 netdevsim3: renamed from eth3
[   82.431937][ T5930] 8021q: adding VLAN 0 to HW filter on device bond0
[   82.451444][ T5930] 8021q: adding VLAN 0 to HW filter on device team0
[   82.462384][   T60] bridge0: port 1(bridge_slave_0) entered blocking sta=
te
[   82.469488][   T60] bridge0: port 1(bridge_slave_0) entered forwarding s=
tate
[   82.488405][   T60] bridge0: port 2(bridge_slave_1) entered blocking sta=
te
[   82.495478][   T60] bridge0: port 2(bridge_slave_1) entered forwarding s=
tate
[   82.634014][ T5930] 8021q: adding VLAN 0 to HW filter on device batadv0
[   82.669589][ T5930] veth0_vlan: entered promiscuous mode
[   82.679859][ T5930] veth1_vlan: entered promiscuous mode
[   82.704326][ T5930] veth0_macvtap: entered promiscuous mode
[   82.715368][ T5930] veth1_macvtap: entered promiscuous mode
[   82.734887][ T5930] batman_adv: batadv0: Interface activated: batadv_sla=
ve_0
[   82.750652][ T5930] batman_adv: batadv0: Interface activated: batadv_sla=
ve_1
[   82.762618][   T60] netdevsim netdevsim0 netdevsim0: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   82.772242][   T60] netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   82.782190][   T60] netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   82.793148][   T60] netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 f=
amily 0 port 6081 - 0
[   82.852368][   T12] wlan0: Created IBSS using preconfigured BSSID 50:50:=
50:50:50:50
[   82.860711][   T12] wlan0: Creating new IBSS network, BSSID 50:50:50:50:=
50:50
[   82.885601][   T60] wlan1: Created IBSS using preconfigured BSSID 50:50:=
50:50:50:50
[   82.893556][   T60] wlan1: Creating new IBSS network, BSSID 50:50:50:50:=
50:50
SYZFAIL: failed to recv rpc
[   83.392967][   T60] netdevsim netdevsim2 netdevsim3 (unregistering): uns=
et [1, 0] type 2 family 0 port 6081 - 0


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
 -ffile-prefix-map=3D/tmp/go-build277648876=3D/tmp/go-build -gno-record-gcc=
-switches'
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMOD=3D'/syzkaller/jobs/linux/gopath/src/github.com/google/syzkaller/go.mo=
d'
GOMODCACHE=3D'/syzkaller/jobs/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs/linux/gopath'
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
HEAD detached at d6526ea3e6
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
/usr/bin/ld: /tmp/cc0bwYtF.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x386): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking
./tools/check-syzos.sh 2>/dev/null


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D131087fc580000


Tested on:

commit:         994089e6 io_uring/io-wq: don't trigger hung task for s..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.g=
it syztest
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8f75eb998b5774e=
b
dashboard link: https://syzkaller.appspot.com/bug?extid=3D4eb282331cab6d5b6=
588
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Deb=
ian) 2.44

Note: no patches were applied.

