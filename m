Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B6F245576
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 04:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgHPCaX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 22:30:23 -0400
Received: from mail.cmpwn.com ([45.56.77.53]:57572 "EHLO mail.cmpwn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgHPCaW (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 15 Aug 2020 22:30:22 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Aug 2020 22:30:21 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cmpwn.com; s=cmpwn;
        t=1597544421; bh=rwqZKVXGe5ZnblXp3Lha5hh9S9hcwBD7hB1C9ycX8DA=;
        h=Subject:From:To:Date;
        b=JHU8vMBFFaF/FwsyVSUY0rwQeVtg5HTwS5tNxrnHrMS0AbDAuZG9TCpAzvoc8rLfM
         LtBIeGbu7nsQP7XLgGS+9MzUqSz3XTJbYxAke5RL4wAd6i3hQaem2AQfnA5hvkLFrg
         ukJvcO/8w7i6+IfjOiwVU1vJA1aUmglOAOx4PGJo=
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Subject: Consistently reproducible deadlock with simple io_uring program
From:   "Drew DeVault" <sir@cmpwn.com>
To:     <io-uring@vger.kernel.org>
Date:   Sat, 15 Aug 2020 22:12:28 -0400
Message-Id: <C4Y22EC7RW97.3K03685KXYM5S@homura>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kernel 5.7.12-arch1-1 x86_64, Arch Linux.

I'm working on a new implementation of the userspace end of io_uring for
a new programming language under design. The program is pretty simple:
it sets up an io_uring with flags set to zero, obtains an SQE, prepares
it to read 1024 bytes from stdin, and then calls io_uring_enter with
submit and min_complete both set to 1.

The code is set up to grab the CQE and interpret the data in the buffer
after this, but I'm not sure if this side ever gets run in userspace,
because my kernel immediately locks up after I press enter on the
controlling terminal to submit some data to stdin.

I have uploaded a binary which reproduces the problem here:

https://yukari.sr.ht/io_uring-crashme

If you want to reproduce it from source, reach out to me out of band; it
will be a challenge. This new programming langauge is technically GPL'd,
but it hasn't been released to the public, YMMV getting it set up on
localhost, and it doesn't generate DWARF symbols so you're going to be
debugging assembly no matter what.

Here's the dmesg from the point of failure:

general protection fault, probably for non-canonical address 0xf9c24bfaaad4=
2e48: 0000 [#1] PREEMPT SMP PTI
CPU: 6 PID: 2187 Comm: example Not tainted 5.7.12-arch1-1 #1
Hardware name: System manufacturer System Product Name/SABERTOOTH Z77, BIOS=
 1805 12/19/2012
RIP: 0010:io_poll_double_wake+0x12/0xc0
Code: 70 ff ff ff e8 4d 94 cc ff e9 66 ff ff ff 66 2e 0f 1f 84 00 00 00 00 =
00 0f 1f 44 00 00 41 55 41 54 49 89 cc 55 53 48 8b 5f 08 <48> 8b 83 e0 00 0=
0 00 48 8b 68 40 85 c9 74 08 45 31 ed 85 4d 10 74
RSP: 0018:ffff94f381e83d90 EFLAGS: 00010046
RAX: ffffffff9273b570 RBX: f9c24bfaaad42e48 RCX: 0000000000000004
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8a8713698e18
RBP: 0000000000000000 R08: 0000000000000004 R09: ffff94f381e83e08
R10: 000000000000eae3 R11: 000000000000edb8 R12: 0000000000000004
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000004
FS:  0000000000000000(0000) GS:ffff8a874ed80000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f71cfc23008 CR3: 00000003d89fe005 CR4: 00000000001606e0
Call Trace:
 __wake_up_common+0x7a/0x140
 __wake_up_common_lock+0x7d/0xc0
 tty_write+0x1f5/0x2d0
 vfs_write+0xb6/0x1a0
 ksys_write+0x67/0xe0
 do_syscall_64+0x49/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x405c3a
Code: c3 48 89 f8 0f 05 c3 48 89 f8 48 89 f7 0f 05 c3 48 89 f8 48 89 f7 48 =
89 d6 0f 05 c3 48 89 f8 48 89 f7 48 89 d6 48 89 ca 0f 05 <c3> 48 89 f8 4d 8=
9 c2 48 89 f7 48 89 d6 48 89 ca 0f 05 c3 48 89 f8
RSP: 002b:00007fffcc5e4088 EFLAGS: 00000206 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f71cfb24010 RCX: 0000000000405c3a
RDX: 000000000000000d RSI: 00007f71cfb24018 RDI: 0000000000000001
RBP: 00007fffcc5e4090 R08: 0000000000007ffe R09: 0000000000000000
R10: 0000000000000022 R11: 0000000000000206 R12: 000000000000000d
R13: 000000000000000d R14: 0000000000000000 R15: 0000000000000000
Modules linked in: fuse tcp_bbr xt_conntrack xt_MASQUERADE nf_conntrack_net=
link nfnetlink xfrm_user xfrm_algo xt_addrtype iptable_filter iptable_nat n=
f_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge tun ov=
erlay cfg80211 8021q garp mrp stp llc btrfs blake2b_generic xor raid6_pq nl=
s_iso8859_1 nls_cp437 libcrc32c vfat fat intel_rapl_msr intel_rapl_common x=
86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek loop sn=
d_hda_codec_generic ledtrig_audio kvm_intel snd_hda_codec_hdmi uvcvideo snd=
_hda_intel iTCO_wdt eeepc_wmi videobuf2_vmalloc snd_intel_dspcfg videobuf2_=
memops iTCO_vendor_support mei_hdcp kvm ir_rc5_decoder snd_usb_audio snd_hd=
a_codec asus_wmi videobuf2_v4l2 snd_hda_core snd_usbmidi_lib videobuf2_comm=
on battery irqbypass snd_rawmidi sparse_keymap rapl rfkill wmi_bmof mxm_wmi=
 snd_seq_device intel_cstate joydev videodev snd_hwdep rc_streamzap intel_u=
ncore streamzap snd_pcm mc xpad input_leds mousedev ff_memless i2c_i801 pcs=
pkr snd_timer
 lpc_ich evdev e1000e snd mei_me mei soundcore ie31200_edac mac_hid wmi sg =
crypto_user ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 usb_s=
torage dm_crypt hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid d=
m_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_=
intel crypto_simd cryptd glue_helper sr_mod cdrom xhci_pci xhci_hcd ehci_pc=
i ehci_hcd amdgpu gpu_sched i2c_algo_bit ttm drm_kms_helper syscopyarea sys=
fillrect sysimgblt fb_sys_fops cec rc_core drm agpgart
---[ end trace ab3ac727daf5393c ]---
RIP: 0010:io_poll_double_wake+0x12/0xc0
Code: 70 ff ff ff e8 4d 94 cc ff e9 66 ff ff ff 66 2e 0f 1f 84 00 00 00 00 =
00 0f 1f 44 00 00 41 55 41 54 49 89 cc 55 53 48 8b 5f 08 <48> 8b 83 e0 00 0=
0 00 48 8b 68 40 85 c9 74 08 45 31 ed 85 4d 10 74
RSP: 0018:ffff94f381e83d90 EFLAGS: 00010046
RAX: ffffffff9273b570 RBX: f9c24bfaaad42e48 RCX: 0000000000000004
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8a8713698e18
RBP: 0000000000000000 R08: 0000000000000004 R09: ffff94f381e83e08
R10: 000000000000eae3 R11: 000000000000edb8 R12: 0000000000000004
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000004
FS:  0000000000000000(0000) GS:ffff8a874ed80000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f71cfc23008 CR3: 00000003d89fe005 CR4: 00000000001606e0
note: example[2187] exited with preempt_count 1
[drm] Fence fallback timer expired on ring gfx
[drm] Fence fallback timer expired on ring gfx
logitech-hidpp-device 0003:046D:4086.0007: HID++ 4.2 device connected.
[drm:amdgpu_dm_atomic_commit_tail [amdgpu]] *ERROR* Waiting for fences time=
d out!
[drm:amdgpu_dm_atomic_commit_tail [amdgpu]] *ERROR* Waiting for fences time=
d out!
[drm:amdgpu_dm_atomic_commit_tail [amdgpu]] *ERROR* Waiting for fences time=
d out!
[drm:drm_atomic_helper_wait_for_flip_done [drm_kms_helper]] *ERROR* [CRTC:5=
3:crtc-3] flip_done timed out
[drm:drm_atomic_helper_wait_for_flip_done [drm_kms_helper]] *ERROR* [CRTC:4=
9:crtc-1] flip_done timed out
[drm:drm_atomic_helper_wait_for_flip_done [drm_kms_helper]] *ERROR* [CRTC:4=
7:crtc-0] flip_done timed out
[drm:drm_atomic_helper_wait_for_flip_done [drm_kms_helper]] *ERROR* [CRTC:5=
1:crtc-2] flip_done timed out
l[623]: 2020/08/15 21:54:41 Disconnected TCP: 200:67bf:6b04:3787:d0b6:7f11:=
af29:f2f6@fe80::d10e:85b7:16d7:64d3%eno1, source fe80::b820:25cb:2b61:c156%=
eno1; error: message error: EOF
watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [sshd:2215]
Modules linked in: fuse tcp_bbr xt_conntrack xt_MASQUERADE nf_conntrack_net=
link nfnetlink xfrm_user xfrm_algo xt_addrtype iptable_filter iptable_nat n=
f_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge tun ov=
erlay cfg80211 8021q garp mrp stp llc btrfs blake2b_generic xor raid6_pq nl=
s_iso8859_1 nls_cp437 libcrc32c vfat fat intel_rapl_msr intel_rapl_common x=
86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek loop sn=
d_hda_codec_generic ledtrig_audio kvm_intel snd_hda_codec_hdmi uvcvideo snd=
_hda_intel iTCO_wdt eeepc_wmi videobuf2_vmalloc snd_intel_dspcfg videobuf2_=
memops iTCO_vendor_support mei_hdcp kvm ir_rc5_decoder snd_usb_audio snd_hd=
a_codec asus_wmi videobuf2_v4l2 snd_hda_core snd_usbmidi_lib videobuf2_comm=
on battery irqbypass snd_rawmidi sparse_keymap rapl rfkill wmi_bmof mxm_wmi=
 snd_seq_device intel_cstate joydev videodev snd_hwdep rc_streamzap intel_u=
ncore streamzap snd_pcm mc xpad input_leds mousedev ff_memless i2c_i801 pcs=
pkr snd_timer
 lpc_ich evdev e1000e snd mei_me mei soundcore ie31200_edac mac_hid wmi sg =
crypto_user ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 usb_s=
torage dm_crypt hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid d=
m_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_=
intel crypto_simd cryptd glue_helper sr_mod cdrom xhci_pci xhci_hcd ehci_pc=
i ehci_hcd amdgpu gpu_sched i2c_algo_bit ttm drm_kms_helper syscopyarea sys=
fillrect sysimgblt fb_sys_fops cec rc_core drm agpgart
CPU: 5 PID: 2215 Comm: sshd Tainted: G      D           5.7.12-arch1-1 #1
Hardware name: System manufacturer System Product Name/SABERTOOTH Z77, BIOS=
 1805 12/19/2012
RIP: 0010:smp_call_function_many_cond+0x2a6/0x2f0
Code: 00 3b 05 91 3d 62 01 89 c7 0f 83 f4 fd ff ff 48 63 c7 49 8b 55 00 48 =
03 14 c5 40 49 61 93 8b 42 18 a8 01 74 09 f3 90 8b 42 18 <a8> 01 75 f7 eb c=
9 48 c7 c2 20 4c b6 93 48 89 ee 44 89 ff e8 b2 63
RSP: 0018:ffff94f381e3fba0 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000003 RBX: 0000000000000000 RCX: 0000000000000002
RDX: ffff8a874ecb43c0 RSI: 0000000000000000 RDI: 0000000000000002
RBP: 0000000000000007 R08: 0000000000000000 R09: 0000000000000002
R10: 0000000000000005 R11: 0000000000000005 R12: 0000000000000000
R13: ffff8a874ed6df40 R14: 0000000000000140 R15: ffff8a874ed6df48
FS:  00007fbdd188e780(0000) GS:ffff8a874ed40000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d2322e10d0 CR3: 00000003da81a003 CR4: 00000000001606e0
Call Trace:
 ? insert_vmap_area.constprop.0+0x93/0xd0
 ? load_new_mm_cr3+0x110/0x110
 ? load_new_mm_cr3+0x110/0x110
 on_each_cpu+0x43/0xb0
 __purge_vmap_area_lazy+0x6d/0x6e0
 _vm_unmap_aliases.part.0+0x110/0x140
 change_page_attr_set_clr+0xc4/0x1f0
 set_memory_ro+0x26/0x30
 bpf_int_jit_compile+0x3e2/0x40b
 bpf_prog_select_runtime+0x101/0x1a0
 bpf_migrate_filter+0x130/0x180
 bpf_prog_create_from_user+0x178/0x1f0
 do_seccomp+0x2d4/0x9f0
 __do_sys_prctl+0x4bc/0x640
 do_syscall_64+0x49/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fbdd1a52421
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 08 00 00 00 48 89 44 =
24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff f=
f 77 17 48 8b 4c 24 18 64 48 2b 0c 25 28 00 00 00
RSP: 002b:00007fff42a7eef0 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbdd1a52421
RDX: 000055d23232a0a0 RSI: 0000000000000002 RDI: 0000000000000016
RBP: 00007fff42a7ef50 R08: 0000000000000000 R09: 00007fff42a7e5f0
R10: 0000000000000000 R11: 0000000000000246 R12: 000055d2324be200
R13: 00007fff42a7f0a0 R14: 000055d2324beca0 R15: 000055d2324cf630
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu:         3-...0: (2 GPs behind) idle=3D5b2/1/0x4000000000000000 softirq=
=3D8426/8427 fqs=3D5771 last_accelerate: 60ae/a6ff dyntick_enabled: 1
        (detected by 0, t=3D18003 jiffies, g=3D22689, q=3D114787)
Sending NMI from CPU 0 to CPUs 3:
NMI watchdog: Watchdog detected hard LOCKUP on cpu 2
Modules linked in: fuse tcp_bbr xt_conntrack xt_MASQUERADE nf_conntrack_net=
link nfnetlink xfrm_user xfrm_algo xt_addrtype iptable_filter iptable_nat n=
f_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge tun ov=
erlay cfg80211 8021q garp mrp stp llc btrfs blake2b_generic xor raid6_pq nl=
s_iso8859_1 nls_cp437 libcrc32c vfat fat intel_rapl_msr intel_rapl_common x=
86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek loop sn=
d_hda_codec_generic ledtrig_audio kvm_intel snd_hda_codec_hdmi uvcvideo snd=
_hda_intel iTCO_wdt eeepc_wmi videobuf2_vmalloc snd_intel_dspcfg videobuf2_=
memops iTCO_vendor_support mei_hdcp kvm ir_rc5_decoder snd_usb_audio snd_hd=
a_codec asus_wmi videobuf2_v4l2 snd_hda_core snd_usbmidi_lib videobuf2_comm=
on battery irqbypass snd_rawmidi sparse_keymap rapl rfkill wmi_bmof mxm_wmi=
 snd_seq_device intel_cstate joydev videodev snd_hwdep rc_streamzap intel_u=
ncore streamzap snd_pcm mc xpad input_leds mousedev ff_memless i2c_i801 pcs=
pkr snd_timer
 lpc_ich evdev e1000e snd mei_me mei soundcore ie31200_edac mac_hid wmi sg =
crypto_user ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 usb_s=
torage dm_crypt hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid d=
m_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_=
intel crypto_simd cryptd glue_helper sr_mod cdrom xhci_pci xhci_hcd ehci_pc=
i ehci_hcd amdgpu gpu_sched i2c_algo_bit ttm drm_kms_helper syscopyarea sys=
fillrect sysimgblt fb_sys_fops cec rc_core drm agpgart
CPU: 2 PID: 1649 Comm: fish Tainted: G      D           5.7.12-arch1-1 #1
Hardware name: System manufacturer System Product Name/SABERTOOTH Z77, BIOS=
 1805 12/19/2012
RIP: 0010:native_queued_spin_lock_slowpath+0x1a7/0x220
Code: 0c f5 40 49 61 93 48 89 11 8b 4a 08 85 c9 75 09 f3 90 8b 4a 08 85 c9 =
74 f7 48 8b 32 48 85 f6 74 3a 0f 18 0e eb 02 f3 90 8b 0b <66> 85 c9 75 f7 8=
9 cf 66 31 ff 39 c7 74 4e c6 03 01 48 85 f6 74 0e
RSP: 0018:ffff94f381d97d90 EFLAGS: 00000002
RAX: 00000000000c0000 RBX: ffff8a871407da08 RCX: 00000000000c0101
RDX: ffff8a874ecadcc0 RSI: 0000000000000000 RDI: ffff8a871407da08
RBP: ffff8a874ecadcc0 R08: 0000000000000001 R09: 0000000040000000
R10: 0000000000000400 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8a8713c90400 R14: 0000000000000001 R15: ffff8a871407d800
FS:  00007f379527ad00(0000) GS:ffff8a874ec80000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffda6be1fb8 CR3: 00000003d5416006 CR4: 00000000001606e0
Call Trace:
 _raw_spin_lock_irqsave+0x44/0x50
 add_wait_queue+0x15/0x40
 n_tty_write+0xc2/0x4d0
 ? __wake_up_sync_key+0x20/0x20
 tty_write+0x19b/0x2d0
 ? n_tty_receive_char_lnext+0x190/0x190
 vfs_write+0xb6/0x1a0
 ksys_write+0x67/0xe0
 do_syscall_64+0x49/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f3795386b8f
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 a9 54 f9 ff 48 8b 54 24 18 =
48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff f=
f 77 31 44 89 c7 48 89 44 24 08 e8 dc 54 f9 ff 48
RSP: 002b:00007ffda6be2310 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f3795386b8f
RDX: 0000000000000001 RSI: 00007ffda6be23f0 RDI: 0000000000000001
RBP: 00007ffda6be23f0 R08: 0000000000000000 R09: 00007ffda6be2358
R10: 0000000000000004 R11: 0000000000000293 R12: 0000000000000001
R13: 00007f3795457500 R14: 0000000000000001 R15: 00007f3795457700
NMI watchdog: Watchdog detected hard LOCKUP on cpu 3
Modules linked in: fuse tcp_bbr xt_conntrack xt_MASQUERADE nf_conntrack_net=
link nfnetlink xfrm_user xfrm_algo xt_addrtype iptable_filter iptable_nat n=
f_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge tun ov=
erlay cfg80211 8021q garp mrp stp llc btrfs blake2b_generic xor raid6_pq nl=
s_iso8859_1 nls_cp437 libcrc32c vfat fat intel_rapl_msr intel_rapl_common x=
86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek loop sn=
d_hda_codec_generic ledtrig_audio kvm_intel snd_hda_codec_hdmi uvcvideo snd=
_hda_intel iTCO_wdt eeepc_wmi videobuf2_vmalloc snd_intel_dspcfg videobuf2_=
memops iTCO_vendor_support mei_hdcp kvm ir_rc5_decoder snd_usb_audio snd_hd=
a_codec asus_wmi videobuf2_v4l2 snd_hda_core snd_usbmidi_lib videobuf2_comm=
on battery irqbypass snd_rawmidi sparse_keymap rapl rfkill wmi_bmof mxm_wmi=
 snd_seq_device intel_cstate joydev videodev snd_hwdep rc_streamzap intel_u=
ncore streamzap snd_pcm mc xpad input_leds mousedev ff_memless i2c_i801 pcs=
pkr snd_timer
 lpc_ich evdev e1000e snd mei_me mei soundcore ie31200_edac mac_hid wmi sg =
crypto_user ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 usb_s=
torage dm_crypt hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid d=
m_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_=
intel crypto_simd cryptd glue_helper sr_mod cdrom xhci_pci xhci_hcd ehci_pc=
i ehci_hcd amdgpu gpu_sched i2c_algo_bit ttm drm_kms_helper syscopyarea sys=
fillrect sysimgblt fb_sys_fops cec rc_core drm agpgart
CPU: 3 PID: 1652 Comm: PTY reader Tainted: G      D           5.7.12-arch1-=
1 #1
Hardware name: System manufacturer System Product Name/SABERTOOTH Z77, BIOS=
 1805 12/19/2012
RIP: 0010:native_queued_spin_lock_slowpath+0x66/0x220
Code: 79 f0 0f ba 2b 08 0f 92 c0 0f b6 c0 c1 e0 08 89 c2 8b 03 30 e4 09 d0 =
a9 00 01 ff ff 75 53 85 c0 74 0e 8b 03 84 c0 74 08 f3 90 <8b> 03 84 c0 75 f=
8 b8 01 00 00 00 66 89 03 5b 65 48 ff 05 9b 45 b2
RSP: 0018:ffff94f381ecbcf0 EFLAGS: 00000002
RAX: 00000000000c0101 RBX: ffff8a871407da08 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8a871407da08
RBP: 7fffffffffffffff R08: 0000000000000004 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000246
R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f6cb0b77700(0000) GS:ffff8a874ecc0000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffa622c0710 CR3: 00000003ff000003 CR4: 00000000001606e0
Call Trace:
 _raw_spin_lock_irqsave+0x44/0x50
 __wake_up_common_lock+0x63/0xc0
 n_tty_read+0x48a/0x9c0
 ? preempt_count_add+0x68/0xa0
 ? ep_read_events_proc+0xd0/0xd0
 ? _raw_write_lock_irq+0x1a/0x40
 ? _raw_write_unlock_irq+0x19/0x30
 ? ep_scan_ready_list.constprop.0+0x17c/0x190
 ? __wake_up_sync_key+0x20/0x20
 tty_read+0x86/0x100
 vfs_read+0x9d/0x150
 ksys_read+0x67/0xe0
 do_syscall_64+0x49/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f6ce3e5d87c
Code: ec 28 48 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 89 fc ff ff 48 8b =
54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 31 c0 0f 05 <48> 3d 00 f0 ff f=
f 77 34 44 89 c7 48 89 44 24 08 e8 bf fc ff ff 48
RSP: 002b:00007f6cb0b65940 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6ce3e5d87c
RDX: 0000000000010000 RSI: 00007f6cb0b661c8 RDI: 000000000000000f
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000510
R10: 00000000ffffffff R11: 0000000000000246 R12: 000000000000000b
R13: 00007f6cb0b65a60 R14: 00007f6cb0b65ef0 R15: 00007f6cb0b65980
NMI backtrace for cpu 3
CPU: 3 PID: 1652 Comm: PTY reader Tainted: G      D      L    5.7.12-arch1-=
1 #1
Hardware name: System manufacturer System Product Name/SABERTOOTH Z77, BIOS=
 1805 12/19/2012
RIP: 0010:native_queued_spin_lock_slowpath+0x66/0x220
Code: 79 f0 0f ba 2b 08 0f 92 c0 0f b6 c0 c1 e0 08 89 c2 8b 03 30 e4 09 d0 =
a9 00 01 ff ff 75 53 85 c0 74 0e 8b 03 84 c0 74 08 f3 90 <8b> 03 84 c0 75 f=
8 b8 01 00 00 00 66 89 03 5b 65 48 ff 05 9b 45 b2
RSP: 0018:ffff94f381ecbcf0 EFLAGS: 00000002
RAX: 00000000000c0101 RBX: ffff8a871407da08 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8a871407da08
RBP: 7fffffffffffffff R08: 0000000000000004 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000246
R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f6cb0b77700(0000) GS:ffff8a874ecc0000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffa622c0710 CR3: 00000003ff000003 CR4: 00000000001606e0
Call Trace:
 _raw_spin_lock_irqsave+0x44/0x50
 __wake_up_common_lock+0x63/0xc0
 n_tty_read+0x48a/0x9c0
 ? preempt_count_add+0x68/0xa0
 ? ep_read_events_proc+0xd0/0xd0
 ? _raw_write_lock_irq+0x1a/0x40
 ? _raw_write_unlock_irq+0x19/0x30
 ? ep_scan_ready_list.constprop.0+0x17c/0x190
 ? __wake_up_sync_key+0x20/0x20
 tty_read+0x86/0x100
 vfs_read+0x9d/0x150
 ksys_read+0x67/0xe0
 do_syscall_64+0x49/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f6ce3e5d87c
Code: ec 28 48 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 89 fc ff ff 48 8b =
54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 31 c0 0f 05 <48> 3d 00 f0 ff f=
f 77 34 44 89 c7 48 89 44 24 08 e8 bf fc ff ff 48
RSP: 002b:00007f6cb0b65940 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6ce3e5d87c
RDX: 0000000000010000 RSI: 00007f6cb0b661c8 RDI: 000000000000000f
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000510
R10: 00000000ffffffff R11: 0000000000000246 R12: 000000000000000b
R13: 00007f6cb0b65a60 R14: 00007f6cb0b65ef0 R15: 00007f6cb0b65980
watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [kworker/0:2:166]
Modules linked in: fuse tcp_bbr xt_conntrack xt_MASQUERADE nf_conntrack_net=
link nfnetlink xfrm_user xfrm_algo xt_addrtype iptable_filter iptable_nat n=
f_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge tun ov=
erlay cfg80211 8021q garp mrp stp llc btrfs blake2b_generic xor raid6_pq nl=
s_iso8859_1 nls_cp437 libcrc32c vfat fat intel_rapl_msr intel_rapl_common x=
86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek loop sn=
d_hda_codec_generic ledtrig_audio kvm_intel snd_hda_codec_hdmi uvcvideo snd=
_hda_intel iTCO_wdt eeepc_wmi videobuf2_vmalloc snd_intel_dspcfg videobuf2_=
memops iTCO_vendor_support mei_hdcp kvm ir_rc5_decoder snd_usb_audio snd_hd=
a_codec asus_wmi videobuf2_v4l2 snd_hda_core snd_usbmidi_lib videobuf2_comm=
on battery irqbypass snd_rawmidi sparse_keymap rapl rfkill wmi_bmof mxm_wmi=
 snd_seq_device intel_cstate joydev videodev snd_hwdep rc_streamzap intel_u=
ncore streamzap snd_pcm mc xpad input_leds mousedev ff_memless i2c_i801 pcs=
pkr snd_timer
 lpc_ich evdev e1000e snd mei_me mei soundcore ie31200_edac mac_hid wmi sg =
crypto_user ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 usb_s=
torage dm_crypt hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid d=
m_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_=
intel crypto_simd cryptd glue_helper sr_mod cdrom xhci_pci xhci_hcd ehci_pc=
i ehci_hcd amdgpu gpu_sched i2c_algo_bit ttm drm_kms_helper syscopyarea sys=
fillrect sysimgblt fb_sys_fops cec rc_core drm agpgart
CPU: 0 PID: 166 Comm: kworker/0:2 Tainted: G      D      L    5.7.12-arch1-=
1 #1
Hardware name: System manufacturer System Product Name/SABERTOOTH Z77, BIOS=
 1805 12/19/2012
Workqueue: events netstamp_clear
RIP: 0010:smp_call_function_many_cond+0x2a3/0x2f0
Code: 23 63 3b 00 3b 05 91 3d 62 01 89 c7 0f 83 f4 fd ff ff 48 63 c7 49 8b =
55 00 48 03 14 c5 40 49 61 93 8b 42 18 a8 01 74 09 f3 90 <8b> 42 18 a8 01 7=
5 f7 eb c9 48 c7 c2 20 4c b6 93 48 89 ee 44 89 ff
RSP: 0018:ffff94f380463d90 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000003 RBX: 0000000000000000 RCX: 0000000000000002
RDX: ffff8a874ecb30a0 RSI: 0000000000000000 RDI: 0000000000000002
RBP: 0000000000000007 R08: 0000000000000000 R09: 0000000000000002
R10: 0000000000000005 R11: 0000000000000005 R12: 0000000000000000
R13: ffff8a874ec2df40 R14: 0000000000000140 R15: ffff8a874ec2df48
FS:  0000000000000000(0000) GS:ffff8a874ec00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c509b63000 CR3: 000000040b506005 CR4: 00000000001606f0
Call Trace:
 ? _raw_spin_unlock+0x16/0x30
 ? poke_int3_handler+0x110/0x110
 ? poke_int3_handler+0x110/0x110
 ? rescuer_thread+0x3f0/0x3f0
 on_each_cpu+0x43/0xb0
 text_poke_bp_batch+0x9f/0x190
 text_poke_finish+0x1b/0x26
 arch_jump_label_transform_apply+0x16/0x30
 static_key_enable_cpuslocked+0x57/0x90
 static_key_enable+0x16/0x20
 process_one_work+0x1da/0x3d0
 ? rescuer_thread+0x3f0/0x3f0
 worker_thread+0x4d/0x3e0
 ? rescuer_thread+0x3f0/0x3f0
 kthread+0x13e/0x160
 ? __kthread_bind_mask+0x60/0x60
 ret_from_fork+0x35/0x40
watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [sshd:2215]
