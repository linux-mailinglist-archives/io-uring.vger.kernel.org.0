Return-Path: <io-uring+bounces-1010-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A11487D935
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 08:41:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A24E11C20880
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 07:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09C31DDAD;
	Sat, 16 Mar 2024 07:41:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C324C6D
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 07:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710574864; cv=none; b=HZwGLHgIAaDa3GI33nspRVphT+tNEJme6cJTeuOkgGaHSRR7bWBsbNEYAx5C50WqW5fyaUTmoUe4bmtMI+fOzdUlZ0KGIbhiZtVpeWR2LuPTzFKtAu0K48tMkicGa9JeD+hvoSay6qqctglZRtdakgWVisq/JEoED0ppV100IWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710574864; c=relaxed/simple;
	bh=cRn5vzhDO/ZK9hUfqAHjO1+0WamgDKE2ee/F1r7EMro=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=eXGtoYkIhpK13UPAeB+CFYrCD5P7spw6s637Kux/ntp5lhJpqXCPgA3gFgJl7QmZnJ8Oa/PlFYRjL2Z75U375dlRjONzKf4K8j43ukB+yfatOeaCkCPpeir+gud8rWB+JIFuUXj0h/j73mBF5FmiVUlFxmfulHNn2Gxj5x8GPl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7cbdcfcd458so165128039f.1
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 00:41:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710574862; x=1711179662;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eSECJROptgX706vJZRxsDokHtx1dol2JZwCLmUOn6qQ=;
        b=WDNhkUan03MkRWEFdJ/nUC94K/I9EIECxNxf831clcJ3B/HeOiVaRg+ZMnrmnIRTBx
         OtiBrlXFCu1B9RCd7k3EVgK0tmIXmZ4NPNLh2gEWdv4asmViVUCaAAnFNUFpYFcRaneJ
         jr1PbWu1AJGS3hNOAKpwCzUE/PBfOWOGRVSMad8lkr9ir2czDRXWffJgs0lF4Tzp6W9d
         J16/yFYF03Zv8a1nhX3Z9KW+0IaKHXrdrmf6g9hz7UDJUijIC/gg7MhOXwXYZ9sF0Oyf
         zEvnGCdQa1zWFM0+VrlW9ZmHcQ8hCm8cummXm/0NDRaSyGrDqagr/kvZzwzfoEncyuCf
         DgkA==
X-Forwarded-Encrypted: i=1; AJvYcCXYMsr40lqfDBOUasQQ6a9kopx56OKGCR/70iADmNLRjahWyFZ1cOgQ55jgbqyexrqm3SLRo9my64zUa/H3jShzLbhk5jFkCB8=
X-Gm-Message-State: AOJu0Yys6q/5X9UNE4U+szBvTgFNLejpQjs/X7fZWFRHUWB7G0HWTMkL
	eru/id2IUovunWOLeyF1kgNlyNky7+2Gj3t1ZugfaQewTt4iG2+o6njI/KtQxTMAbHQlAHYd/CI
	OrTcbb9VwIArlP5ehddnjVSU308qVskKcrVTIVuCfmhz+5s+snALcgD0=
X-Google-Smtp-Source: AGHT+IEqIVvfCndIGjEevwMEHwsGo5rhcb9ILcAUMd7f9hpr/XcH6Oezx80DQxlJ41P37fK6FbBGYXG4OqAzGOxWox3sHrHObGKC
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:62a7:b0:476:ed02:e2da with SMTP id
 fh39-20020a05663862a700b00476ed02e2damr399536jab.5.1710574862157; Sat, 16 Mar
 2024 00:41:02 -0700 (PDT)
Date: Sat, 16 Mar 2024 00:41:02 -0700
In-Reply-To: <b090c928-6c42-4735-9758-e8a137832607@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000568df0613c23f45@google.com>
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_sendrecv_fail
From: syzbot <syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

w interface driver emi26 - firmware loader
[    4.930123][    T1] usbcore: registered new interface driver emi62 - fir=
mware loader
[    4.933583][    T1] usbcore: registered new interface driver idmouse
[    4.936138][    T1] usbcore: registered new interface driver iowarrior
[    4.938260][    T1] usbcore: registered new interface driver isight_firm=
ware
[    4.941539][    T1] usbcore: registered new interface driver usblcd
[    4.944208][    T1] usbcore: registered new interface driver ldusb
[    4.946236][    T1] usbcore: registered new interface driver legousbtowe=
r
[    4.948760][    T1] usbcore: registered new interface driver usbtest
[    4.951336][    T1] usbcore: registered new interface driver usb_ehset_t=
est
[    4.953754][    T1] usbcore: registered new interface driver trancevibra=
tor
[    4.956657][    T1] usbcore: registered new interface driver uss720
[    4.958553][    T1] uss720: USB Parport Cable driver for Cables using th=
e Lucent Technologies USS720 Chip
[    4.961696][    T1] uss720: NOTE: this is a special purpose driver to al=
low nonstandard
[    4.965815][    T1] uss720: protocols (eg. bitbang) over USS720 usb to p=
arallel cables
[    4.968828][    T1] uss720: If you just want to connect to a printer, us=
e usblp instead
[    4.971404][    T1] usbcore: registered new interface driver usbsevseg
[    4.973400][    T1] usbcore: registered new interface driver yurex
[    4.975425][    T1] usbcore: registered new interface driver chaoskey
[    4.977627][    T1] usbcore: registered new interface driver sisusb
[    4.979915][    T1] usbcore: registered new interface driver lvs
[    4.981851][    T1] usbcore: registered new interface driver cxacru
[    4.983985][    T1] usbcore: registered new interface driver speedtch
[    4.985950][    T1] usbcore: registered new interface driver ueagle-atm
[    4.988079][    T1] xusbatm: malformed module parameters
[    4.990267][    T1] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, dri=
ver 02 May 2005
[    4.992631][    T1] dummy_hcd dummy_hcd.0: Dummy host controller
[    4.994246][    T1] dummy_hcd dummy_hcd.0: new USB bus registered, assig=
ned bus number 1
[    4.996646][    T1] usb usb1: New USB device found, idVendor=3D1d6b, idP=
roduct=3D0002, bcdDevice=3D 6.00
[    4.999972][    T1] usb usb1: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
[    5.002339][    T1] usb usb1: Product: Dummy host controller
[    5.004170][    T1] usb usb1: Manufacturer: Linux 6.0.0-rc1-syzkaller-00=
033-gd59bd748db0a dummy_hcd
[    5.006694][    T1] usb usb1: SerialNumber: dummy_hcd.0
[    5.008294][    T1] hub 1-0:1.0: USB hub found
[    5.009512][    T1] hub 1-0:1.0: 1 port detected
[    5.011319][    T1] dummy_hcd dummy_hcd.1: USB Host+Gadget Emulator, dri=
ver 02 May 2005
[    5.013887][    T1] dummy_hcd dummy_hcd.1: Dummy host controller
[    5.016176][    T1] dummy_hcd dummy_hcd.1: new USB bus registered, assig=
ned bus number 2
[    5.018574][    T1] usb usb2: New USB device found, idVendor=3D1d6b, idP=
roduct=3D0002, bcdDevice=3D 6.00
[    5.020979][    T1] usb usb2: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
[    5.022687][    T1] usb usb2: Product: Dummy host controller
[    5.024450][    T1] usb usb2: Manufacturer: Linux 6.0.0-rc1-syzkaller-00=
033-gd59bd748db0a dummy_hcd
[    5.027608][    T1] usb usb2: SerialNumber: dummy_hcd.1
[    5.029702][    T1] hub 2-0:1.0: USB hub found
[    5.031266][    T1] hub 2-0:1.0: 1 port detected
[    5.032936][    T1] dummy_hcd dummy_hcd.2: USB Host+Gadget Emulator, dri=
ver 02 May 2005
[    5.035475][    T1] dummy_hcd dummy_hcd.2: Dummy host controller
[    5.037713][    T1] dummy_hcd dummy_hcd.2: new USB bus registered, assig=
ned bus number 3
[    5.040503][    T1] usb usb3: New USB device found, idVendor=3D1d6b, idP=
roduct=3D0002, bcdDevice=3D 6.00
[    5.043261][    T1] usb usb3: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
[    5.045104][    T1] usb usb3: Product: Dummy host controller
[    5.046289][    T1] usb usb3: Manufacturer: Linux 6.0.0-rc1-syzkaller-00=
033-gd59bd748db0a dummy_hcd
[    5.048827][    T1] usb usb3: SerialNumber: dummy_hcd.2
[    5.050576][    T1] hub 3-0:1.0: USB hub found
[    5.051876][    T1] hub 3-0:1.0: 1 port detected
[    5.053553][    T1] dummy_hcd dummy_hcd.3: USB Host+Gadget Emulator, dri=
ver 02 May 2005
[    5.055781][    T1] dummy_hcd dummy_hcd.3: Dummy host controller
[    5.057706][    T1] dummy_hcd dummy_hcd.3: new USB bus registered, assig=
ned bus number 4
[    5.060296][    T1] usb usb4: New USB device found, idVendor=3D1d6b, idP=
roduct=3D0002, bcdDevice=3D 6.00
[    5.062797][    T1] usb usb4: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
[    5.064685][    T1] usb usb4: Product: Dummy host controller
[    5.066160][    T1] usb usb4: Manufacturer: Linux 6.0.0-rc1-syzkaller-00=
033-gd59bd748db0a dummy_hcd
[    5.068499][    T1] usb usb4: SerialNumber: dummy_hcd.3
[    5.070209][    T1] hub 4-0:1.0: USB hub found
[    5.071787][    T1] hub 4-0:1.0: 1 port detected
[    5.073440][    T1] dummy_hcd dummy_hcd.4: USB Host+Gadget Emulator, dri=
ver 02 May 2005
[    5.075182][    T1] dummy_hcd dummy_hcd.4: Dummy host controller
[    5.076592][    T1] dummy_hcd dummy_hcd.4: new USB bus registered, assig=
ned bus number 5
[    5.078624][    T1] usb usb5: New USB device found, idVendor=3D1d6b, idP=
roduct=3D0002, bcdDevice=3D 6.00
[    5.080862][    T1] usb usb5: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
[    5.083013][    T1] usb usb5: Product: Dummy host controller
[    5.084611][    T1] usb usb5: Manufacturer: Linux 6.0.0-rc1-syzkaller-00=
033-gd59bd748db0a dummy_hcd
[    5.087050][    T1] usb usb5: SerialNumber: dummy_hcd.4
[    5.088518][    T1] hub 5-0:1.0: USB hub found
[    5.089972][    T1] hub 5-0:1.0: 1 port detected
[    5.091603][    T1] dummy_hcd dummy_hcd.5: USB Host+Gadget Emulator, dri=
ver 02 May 2005
[    5.094464][    T1] dummy_hcd dummy_hcd.5: Dummy host controller
[    5.096179][    T1] dummy_hcd dummy_hcd.5: new USB bus registered, assig=
ned bus number 6
[    5.098245][    T1] usb usb6: New USB device found, idVendor=3D1d6b, idP=
roduct=3D0002, bcdDevice=3D 6.00
[    5.100696][    T1] usb usb6: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
[    5.102751][    T1] usb usb6: Product: Dummy host controller
[    5.104243][    T1] usb usb6: Manufacturer: Linux 6.0.0-rc1-syzkaller-00=
033-gd59bd748db0a dummy_hcd
[    5.106248][    T1] usb usb6: SerialNumber: dummy_hcd.5
[    5.107854][    T1] hub 6-0:1.0: USB hub found
[    5.109089][    T1] hub 6-0:1.0: 1 port detected
[    5.110733][    T1] dummy_hcd dummy_hcd.6: USB Host+Gadget Emulator, dri=
ver 02 May 2005
[    5.112657][    T1] dummy_hcd dummy_hcd.6: Dummy host controller
[    5.113957][    T1] dummy_hcd dummy_hcd.6: new USB bus registered, assig=
ned bus number 7
[    5.115878][    T1] usb usb7: New USB device found, idVendor=3D1d6b, idP=
roduct=3D0002, bcdDevice=3D 6.00
[    5.117770][    T1] usb usb7: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
[    5.119911][    T1] usb usb7: Product: Dummy host controller
[    5.121564][    T1] usb usb7: Manufacturer: Linux 6.0.0-rc1-syzkaller-00=
033-gd59bd748db0a dummy_hcd
[    5.123794][    T1] usb usb7: SerialNumber: dummy_hcd.6
[    5.125643][    T1] hub 7-0:1.0: USB hub found
[    5.128371][    T1] hub 7-0:1.0: 1 port detected
[    5.130464][    T1] dummy_hcd dummy_hcd.7: USB Host+Gadget Emulator, dri=
ver 02 May 2005
[    5.132874][    T1] dummy_hcd dummy_hcd.7: Dummy host controller
[    5.134563][    T1] dummy_hcd dummy_hcd.7: new USB bus registered, assig=
ned bus number 8
[    5.136921][    T1] usb usb8: New USB device found, idVendor=3D1d6b, idP=
roduct=3D0002, bcdDevice=3D 6.00
[    5.139796][    T1] usb usb8: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
[    5.142568][    T1] usb usb8: Product: Dummy host controller
[    5.144170][    T1] usb usb8: Manufacturer: Linux 6.0.0-rc1-syzkaller-00=
033-gd59bd748db0a dummy_hcd
[    5.146630][    T1] usb usb8: SerialNumber: dummy_hcd.7
[    5.148441][    T1] hub 8-0:1.0: USB hub found
[    5.150215][    T1] hub 8-0:1.0: 1 port detected
[    5.153433][    T1] general protection fault, probably for non-canonical=
 address 0xffff000000000800: 0000 [#1] PREEMPT SMP
[    5.157506][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc1-=
syzkaller-00033-gd59bd748db0a #0
[    5.159433][    T1] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 02/29/2024
[    5.160818][    T1] RIP: 0010:kmem_cache_alloc_trace+0x6a/0x1e0
[    5.161856][    T1] Code: 48 85 c0 74 7e 49 89 c7 49 8b 07 65 48 03 05 4=
d 31 af 7e 48 8b 50 08 48 8b 38 48 85 ff 74 7d 48 83 78 10 00 74 76 41 8b 4=
7 28 <48> 8b 1c 07 48 8d 4a 08 4d 8b 07 48 89 f8 65 49 0f c7 08 0f 94 c0
[    5.162052][    T1] RSP: 0000:ffff8881001af8a0 EFLAGS: 00010286
[    5.162052][    T1] RAX: 0000000000000800 RBX: 0000000000000000 RCX: 000=
0000000000000
[    5.162052][    T1] RDX: 0000000000009e48 RSI: 0000000000000dc0 RDI: fff=
f000000000000
[    5.162052][    T1] RBP: ffff8881001af8e0 R08: 0000000000000dc0 R09: fff=
fffff82992c5d
[    5.162052][    T1] R10: 0000000000000004 R11: ffff8881001e8000 R12: fff=
f888100041d00
[    5.162052][    T1] R13: ffffffff823e1d01 R14: 0000000000000dc0 R15: fff=
f888100041d00
[    5.162052][    T1] FS:  0000000000000000(0000) GS:ffff88813bc00000(0000=
) knlGS:0000000000000000
[    5.162052][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.162052][    T1] CR2: ffff88823ffff000 CR3: 0000000005c29000 CR4: 000=
00000003506f0
[    5.162052][    T1] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
[    5.162052][    T1] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000=
0000000000400
[    5.162052][    T1] Call Trace:
[    5.162052][    T1]  <TASK>
[    5.162052][    T1]  kobject_uevent_env+0x151/0x4c0
[    5.162052][    T1]  ? device_links_driver_bound+0x596/0x5b0
[    5.162052][    T1]  kobject_uevent+0x23/0x30
[    5.162052][    T1]  driver_bound+0x1da/0x200
[    5.162052][    T1]  ? platform_uevent+0x90/0x90
[    5.162052][    T1]  really_probe+0x424/0x4c0
[    5.162052][    T1]  ? __driver_probe_device+0xeb/0x140
[    5.162052][    T1]  __driver_probe_device+0xf6/0x140
[    5.162052][    T1]  driver_probe_device+0x31/0x210
[    5.162052][    T1]  __device_attach_driver+0x1e1/0x250
[    5.162052][    T1]  ? coredump_store+0x50/0x50
[    5.162052][    T1]  bus_for_each_drv+0xae/0x100
[    5.162052][    T1]  __device_attach+0x13d/0x220
[    5.162052][    T1]  device_initial_probe+0x1e/0x30
[    5.162052][    T1]  bus_probe_device+0x62/0xf0
[    5.162052][    T1]  device_add+0x655/0x7b0
[    5.162052][    T1]  platform_device_add+0x22f/0x330
[    5.162052][    T1]  dummy_hcd_init+0x4ce/0x6dc
[    5.162052][    T1]  ? configfs_register_subsystem+0x228/0x240
[    5.162052][    T1]  ? usb_udc_init+0x9d/0x9d
[    5.162052][    T1]  do_one_initcall+0xa8/0x390
[    5.162052][    T1]  ? skip_spaces+0x2c/0x40
[    5.162052][    T1]  ? next_arg+0x266/0x280
[    5.162052][    T1]  ? parse_args+0x577/0x5b0
[    5.162052][    T1]  do_initcall_level+0x94/0x171
[    5.162052][    T1]  do_initcalls+0x4e/0x89
[    5.162052][    T1]  do_basic_setup+0x1d/0x1f
[    5.200701][    T1]  kernel_init_freeable+0x113/0x189
[    5.200701][    T1]  ? rest_init+0xd0/0xd0
[    5.200701][    T1]  kernel_init+0x1f/0x2a0
[    5.200701][    T1]  ? rest_init+0xd0/0xd0
[    5.200701][    T1]  ret_from_fork+0x1f/0x30
[    5.200701][    T1]  </TASK>
[    5.200701][    T1] Modules linked in:
[    5.210897][    C0] vkms_vblank_simulate: vblank timer overrun
[    5.212396][    T1] ---[ end trace 0000000000000000 ]---
[    5.213702][    T1] RIP: 0010:kmem_cache_alloc_trace+0x6a/0x1e0
[    5.215084][    T1] Code: 48 85 c0 74 7e 49 89 c7 49 8b 07 65 48 03 05 4=
d 31 af 7e 48 8b 50 08 48 8b 38 48 85 ff 74 7d 48 83 78 10 00 74 76 41 8b 4=
7 28 <48> 8b 1c 07 48 8d 4a 08 4d 8b 07 48 89 f8 65 49 0f c7 08 0f 94 c0
[    5.220767][    T1] RSP: 0000:ffff8881001af8a0 EFLAGS: 00010286
[    5.222164][    T1] RAX: 0000000000000800 RBX: 0000000000000000 RCX: 000=
0000000000000
[    5.224220][    T1] RDX: 0000000000009e48 RSI: 0000000000000dc0 RDI: fff=
f000000000000
[    5.226644][    T1] RBP: ffff8881001af8e0 R08: 0000000000000dc0 R09: fff=
fffff82992c5d
[    5.229009][    T1] R10: 0000000000000004 R11: ffff8881001e8000 R12: fff=
f888100041d00
[    5.231225][    T1] R13: ffffffff823e1d01 R14: 0000000000000dc0 R15: fff=
f888100041d00
[    5.233220][    T1] FS:  0000000000000000(0000) GS:ffff88813bc00000(0000=
) knlGS:0000000000000000
[    5.235486][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.237106][    T1] CR2: ffff88823ffff000 CR3: 0000000005c29000 CR4: 000=
00000003506f0
[    5.238923][    T1] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
[    5.240518][    T1] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000=
0000000000400
[    5.242066][    T1] Kernel panic - not syncing: Fatal exception
[    5.244082][    T1] Kernel Offset: disabled
[    5.245268][    T1] Rebooting in 86400 seconds..


syzkaller build log:
go env (err=3D<nil>)
GO111MODULE=3D'auto'
GOARCH=3D'amd64'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFLAGS=3D''
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMODCACHE=3D'/syzkaller/jobs-2/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs-2/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/usr/local/go'
GOSUMDB=3D'sum.golang.org'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/usr/local/go/pkg/tool/linux_amd64'
GOVCS=3D''
GOVERSION=3D'go1.21.4'
GCCGO=3D'gccgo'
GOAMD64=3D'v1'
AR=3D'ar'
CC=3D'gcc'
CXX=3D'g++'
CGO_ENABLED=3D'1'
GOMOD=3D'/syzkaller/jobs-2/linux/gopath/src/github.com/google/syzkaller/go.=
mod'
GOWORK=3D''
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
PKG_CONFIG=3D'pkg-config'
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build3912001592=3D/tmp/go-build -gno-record-gc=
c-switches'

git status (err=3D<nil>)
HEAD detached at 6ee49f2e6
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' ./sys/syz-sysgen | grep -q false || go install ./sy=
s/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build "-ldflags=3D-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D6ee49f2e61b06b3d64c676dd2232a5ac362902a6 -X '=
github.com/google/syzkaller/prog.gitRevisionDate=3D20240308-214706'" "-tags=
=3Dsyz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-fuzzer=
 github.com/google/syzkaller/syz-fuzzer
GOOS=3Dlinux GOARCH=3Damd64 go build "-ldflags=3D-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D6ee49f2e61b06b3d64c676dd2232a5ac362902a6 -X '=
github.com/google/syzkaller/prog.gitRevisionDate=3D20240308-214706'" "-tags=
=3Dsyz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-execpr=
og github.com/google/syzkaller/tools/syz-execprog
GOOS=3Dlinux GOARCH=3Damd64 go build "-ldflags=3D-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D6ee49f2e61b06b3d64c676dd2232a5ac362902a6 -X '=
github.com/google/syzkaller/prog.gitRevisionDate=3D20240308-214706'" "-tags=
=3Dsyz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-stress=
 github.com/google/syzkaller/tools/syz-stress
mkdir -p ./bin/linux_amd64
gcc -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -fpermissive -w -DGOOS_linux=3D1 -DGOARCH_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"6ee49f2e61b06b3d64c676dd2232a5ac36=
2902a6\"


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D146d8aa5180000


Tested on:

commit:         d59bd748 io_uring/poll: disable level triggered poll
git tree:       git://git.kernel.dk/linux.git io_uring-6.0
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D7646c61aacfb37b=
5
dashboard link: https://syzkaller.appspot.com/bug?extid=3Df8e9a371388aa62ec=
ab4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Note: no patches were applied.

