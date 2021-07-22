Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669943D2FEF
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 00:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhGVWCu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jul 2021 18:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbhGVWCt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jul 2021 18:02:49 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74947C061575;
        Thu, 22 Jul 2021 15:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:To:From;
        bh=0qiF+g7/qXn3CGURipLLSWxk7rYsRrrOgCpVuM62U7I=; b=SS1eFayGCJ6wIk6IT7+ObomzHf
        kKe7ErPF6HiMYcUQ7eRQC3mb+KLgOTswPfiQ7oMoCyYoysh3RP0xMTAl/hxzFEuTaIgy4xMjL+V98
        pcp2YlnQ6xXcz3rzFbYoivfqccPXb4V3svJZmaLKmwmcBUAzfP5scg0CN/hnznk/BkcgM1naocAxp
        5GB8GL810PYFQx7n2XpsjPc7wY8WT1mxp6VjeTlX+Tma9ban2t3JkuOCUM1tZ7GIn7zJG8cuDWuAI
        rYwPh018DFbLg/mG/wTf8crTdUCSGbx3m6fOM5tXjcCY4cN0mg+lgqRcLygqxp0GMBxNI1MHVySzI
        Uo7SC+mBJ/pPTJCRVBvRvUH0WdyXUWfXC8xyU0uW3AsuSC4cMiOOC1e6sMroxeY8jWlaGXo2Rlif0
        a+tFvYPGsEQRnxg5lxjLlO8rWki6Fw+FEKQD5DFVyC+Kd+r5XDKqeZwAF2kL0eLSbQOZYiiyxXH45
        8CzgMgQ/sG9V1/ggWcx7Br+H;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1m6hPT-0008C1-EX; Thu, 22 Jul 2021 22:43:19 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
 <20210504092404.6b12aba4@gandalf.local.home>
 <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
 <20210504093550.5719d4bd@gandalf.local.home>
 <f351bdfa-5223-e457-0396-a24ffa09d6b5@samba.org>
 <8bb757fb-a83b-0ed5-5247-8273be3925c5@samba.org>
 <90c806a0-8a2f-1257-7337-6761100217c9@samba.org>
Subject: sched_waking vs. set_event_pid crash (Re: Tracing busy
 processes/threads freezes/stalls the whole machine)
Message-ID: <4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org>
Date:   Fri, 23 Jul 2021 00:43:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <90c806a0-8a2f-1257-7337-6761100217c9@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="E8bmDsSmoPzt7EDiGHAtjhForEWYUEqNs"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--E8bmDsSmoPzt7EDiGHAtjhForEWYUEqNs
Content-Type: multipart/mixed; boundary="cF57DJ4BI2bdTfgNuunzL3STrLL4goJkT";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
 io-uring <io-uring@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org>
Subject: sched_waking vs. set_event_pid crash (Re: Tracing busy
 processes/threads freezes/stalls the whole machine)
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
 <20210504092404.6b12aba4@gandalf.local.home>
 <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
 <20210504093550.5719d4bd@gandalf.local.home>
 <f351bdfa-5223-e457-0396-a24ffa09d6b5@samba.org>
 <8bb757fb-a83b-0ed5-5247-8273be3925c5@samba.org>
 <90c806a0-8a2f-1257-7337-6761100217c9@samba.org>
In-Reply-To: <90c806a0-8a2f-1257-7337-6761100217c9@samba.org>

--cF57DJ4BI2bdTfgNuunzL3STrLL4goJkT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


Hi Steve,

After some days of training:
https://training.linuxfoundation.org/training/linux-kernel-debugging-and-=
security/
I was able to get much closer to the problem :-)

In order to reproduce it and get reliable kexec crash dumps,
I needed to give the VM at least 3 cores.

While running './io-uring_cp-forever link-cp.c file' (from:
https://github.com/metze-samba/liburing/commits/io_uring-cp-forever )
in one window, the following simple sequence triggered the problem in mos=
t cases:

echo 1 > /sys/kernel/tracing/events/sched/sched_waking/enable
echo 1 > /sys/kernel/tracing/set_event_pid

It triggered the following:

> [  192.924023] ------------[ cut here ]------------
> [  192.924026] WARNING: CPU: 2 PID: 1696 at arch/x86/include/asm/kfence=
=2Eh:44 kfence_protect_page+0x33/0xc0
> [  192.924034] Modules linked in: vboxsf intel_rapl_msr intel_rapl_comm=
on crct10dif_pclmul ghash_clmulni_intel aesni_intel crypto_simd cryptd ra=
pl vboxvideo drm_vr
> am_helper drm_ttm_helper ttm snd_intel8x0 input_leds snd_ac97_codec joy=
dev ac97_bus serio_raw snd_pcm drm_kms_helper cec mac_hid vboxguest snd_t=
imer rc_core snd fb
> _sys_fops syscopyarea sysfillrect soundcore sysimgblt kvm_intel kvm sch=
_fq_codel drm sunrpc ip_tables x_tables autofs4 hid_generic usbhid hid cr=
c32_pclmul psmouse=20
> ahci libahci e1000 i2c_piix4 pata_acpi video
> [  192.924068] CPU: 2 PID: 1696 Comm: io_uring-cp-for Kdump: loaded Not=
 tainted 5.13.0-1007-oem #7-Ubuntu
> [  192.924071] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS =
VirtualBox 12/01/2006
> [  192.924072] RIP: 0010:kfence_protect_page+0x33/0xc0
> [  192.924075] Code: 53 89 f3 48 8d 75 e4 48 83 ec 10 65 48 8b 04 25 28=
 00 00 00 48 89 45 e8 31 c0 e8 98 1f da ff 48 85 c0 74 06 83 7d e4 01 74 =
06 <0f> 0b 31 c0 eb 39 48 8b 38 48 89 c2 84 db 75 47 48 89 f8 0f 1f 40
> [  192.924077] RSP: 0018:ffff980c0077f918 EFLAGS: 00010046
> [  192.924079] RAX: 0000000000000000 RBX: 0000000000000000 RCX: fffffff=
fbcc10000
> [  192.924080] RDX: ffff980c0077f91c RSI: 0000000000032000 RDI: 0000000=
000000000
> [  192.924082] RBP: ffff980c0077f938 R08: 0000000000000000 R09: 0000000=
000000000
> [  192.924083] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000=
000032000
> [  192.924084] R13: 0000000000000000 R14: ffff980c0077fb58 R15: 0000000=
000000000
> [  192.924085] FS:  00007f2491207540(0000) GS:ffff8ccb5bd00000(0000) kn=
lGS:0000000000000000
> [  192.924087] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  192.924088] CR2: 00000000000325f8 CR3: 0000000102572005 CR4: 0000000=
0000706e0
> [  192.924091] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> [  192.924092] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> [  192.924093] Call Trace:
> [  192.924096]  kfence_unprotect+0x17/0x30
> [  192.924099]  kfence_handle_page_fault+0x97/0x250
> [  192.924102]  ? cmp_ex_sort+0x30/0x30
> [  192.924104]  page_fault_oops+0xa0/0x2a0
> [  192.924106]  ? trace_event_buffer_reserve+0x22/0xb0
> [  192.924110]  ? search_exception_tables+0x5b/0x60
> [  192.924113]  kernelmode_fixup_or_oops+0x92/0xf0
> [  192.924115]  __bad_area_nosemaphore+0x14d/0x190
> [  192.924116]  __bad_area+0x5f/0x80
> [  192.924118]  bad_area+0x16/0x20
> [  192.924119]  do_user_addr_fault+0x368/0x640> [  192.924121]  ? aa_fi=
le_perm+0x11d/0x470
> [  192.924123]  exc_page_fault+0x7d/0x170
> [  192.924127]  asm_exc_page_fault+0x1e/0x30
> [  192.924129] RIP: 0010:trace_event_buffer_reserve+0x22/0xb0
> [  192.924132] Code: 00 00 00 00 0f 1f 40 00 55 48 89 e5 41 56 41 55 49=
 89 d5 41 54 49 89 f4 53 48 89 fb 4c 8b 76 10 f6 46 49 02 74 29 48 8b 46 =
28 <48> 8b 88 b8 00 00 00 48 8b 90 c0 00 00 00 48 09 d1 74 12 48 8b 40
> [  192.924134] RSP: 0018:ffff980c0077fc00 EFLAGS: 00010002
> [  192.924135] RAX: 0000000000032540 RBX: ffff980c0077fc38 RCX: 0000000=
000000002
> [  192.924136] RDX: 0000000000000028 RSI: ffffffffbcdb7e80 RDI: ffff980=
c0077fc38
> [  192.924137] RBP: ffff980c0077fc20 R08: ffff8ccb46814cb8 R09: 0000000=
000000010
> [  192.924138] R10: 000000007ffff000 R11: 0000000000000000 R12: fffffff=
fbcdb7e80
> [  192.924140] R13: 0000000000000028 R14: 0000000000000000 R15: ffff8cc=
b49b6ed0c
> [  192.924142]  trace_event_raw_event_sched_wakeup_template+0x63/0xf0
> [  192.924146]  try_to_wake_up+0x285/0x570
> [  192.924148]  wake_up_process+0x15/0x20
> [  192.924149]  io_wqe_activate_free_worker+0x5b/0x70
> [  192.924152]  io_wqe_enqueue+0xfb/0x190
> [  192.924154]  io_wq_enqueue+0x1e/0x20
> [  192.924156]  io_queue_async_work+0xa0/0x120
> [  192.924158]  __io_queue_sqe+0x17e/0x360
> [  192.924160]  ? io_req_free_batch_finish+0x8d/0xf0
> [  192.924162]  io_queue_sqe+0x199/0x2a0
> [  192.924164]  io_submit_sqes+0x70d/0x7f0
> [  192.924166]  __x64_sys_io_uring_enter+0x1b8/0x3d0
> [  192.924168]  do_syscall_64+0x40/0xb0
> [  192.924170]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  192.924172] RIP: 0033:0x7f249112f89d
> [  192.924174] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa=
 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f =
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 f5 0c 00 f7 d8 64 89 01 48
> [  192.924179] RSP: 002b:00007fff56c491c8 EFLAGS: 00000216 ORIG_RAX: 00=
000000000001aa
> [  192.924180] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2=
49112f89d
> [  192.924182] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000=
000000005
> [  192.924182] RBP: 00007fff56c49200 R08: 0000000000000000 R09: 0000000=
000000008
> [  192.924183] R10: 0000000000000000 R11: 0000000000000216 R12: 0000000=
000000000
> [  192.924184] R13: 00007fff56c49380 R14: 0000000000000dcf R15: 000055c=
533b6f2a0
> [  192.924186] ---[ end trace d1211902aae73d20 ]---

The problem seems to happen in this line of trace_event_ignore_this_pid()=
:

pid_list =3D rcu_dereference_raw(tr->filtered_pids);

It seems it got inlined within trace_event_buffer_reserve()

There strangest things I found so far is this:

crash> sym global_trace
ffffffffbcdb7e80 (d) global_trace
crash> list ftrace_trace_arrays
ffffffffbcdb7e70
ffffffffbcdb7e80

trace_array has size 7672, but ffffffffbcdb7e70 is only 16 bytes away fro=
m
ffffffffbcdb7e80.

Also this:

crash> struct trace_array.events -o global_trace
struct trace_array {
  [ffffffffbcdb9be0] struct list_head events;
}
crash> list -s trace_event_file.tr -o trace_event_file.list ffffffffbcdb9=
be0
ffffffffbcdb9be0
  tr =3D 0xffffffffbcdb7b20
ffff8ccb45cdfb00
  tr =3D 0xffffffffbcdb7e80
ffff8ccb45cdf580
  tr =3D 0xffffffffbcdb7e80
ffff8ccb45cdfe18
  tr =3D 0xffffffffbcdb7e80
=2E..
  tr =3D 0xffffffffbcdb7e80

The first one 0xffffffffbcdb7b20 is only 864 bytes away from 0xffffffffbc=
db7e80

Additional information can be found here:
https://www.samba.org/~metze/202107221802.reproduce-freeze-05-first-time.=
v3-pid1/
-rw-r--r-- 1 metze metze 37250108 Jul 22 18:02 dump.202107221802
-rw-r--r-- 1 metze metze    63075 Jul 22 18:02 dmesg.202107221802
-rw-r--r-- 1 metze metze     8820 Jul 22 18:13 crash-bt-a-s.txt
-rw-r--r-- 1 metze metze    36586 Jul 22 18:14 crash-bt-a-l-FF-s.txt
-rw-r--r-- 1 metze metze     4798 Jul 22 23:49 crash-bt-p.txt
-rw-r--r-- 1 metze metze      946 Jul 23 00:13 strange-things.txt
-rw-r--r-- 1 metze metze      482 Jul 23 00:24 code-and-vmlinux.txt

The code can be found here:
https://kernel.ubuntu.com/git/kernel-ppa/mirror/ubuntu-oem-5.10-focal.git=
/tag/?h=3DUbuntu-oem-5.13-5.13.0-1007.7

And the /usr/lib/debug/boot/vmlinux-5.13.0-1007-oem file can be extracted=
 from here:
http://ddebs.ubuntu.com/pool/main/l/linux-oem-5.13/linux-image-unsigned-5=
=2E13.0-1007-oem-dbgsym_5.13.0-1007.7_amd64.ddeb

Also also needed the latest code from https://github.com/crash-utility/cr=
ash.git
(at commit f53b73e8380bca054cebd2b61ff118c46609429b)

It would be really great if you (or anyone else on the lists) could have =
a closer look
in order to get the problem fixed :-)

I've learned a lot this week and tried hard to find the problem myself,
but I have to move back to other work for now.

Thanks!
metze


--cF57DJ4BI2bdTfgNuunzL3STrLL4goJkT--

--E8bmDsSmoPzt7EDiGHAtjhForEWYUEqNs
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAmD59IEACgkQDbX1YShp
vVbj6w/8D9NidPTegu+hah/gLUIUYqEi4RN+4YR6gcsE9oTt81EDcZB9q9aDmuL+
YAl/Q2D6K5Fdgl2FaXePhQdaAC2xpTP8Xgxb1HgbJk47eWYVtB2T/iBMduDB8nBj
KpuvvVTg0p5Uw3ggQoFirKxYs6CXXscdaumcQulxA2dxLTEHPl6ptZ5KvLNQEtIy
qROzpqEicmhqZ9RzFp4+MW5dKsbRLxvnPrKLFxsQsVDn5Pb6J1Z4cvhmwabvt8OR
gK94M61EPkr54DxRMHFqQGTmvH64ySKkcXqM7jenKprhbUZt7j45OeidiYG27PM0
2aYliI0wigeV3o09MRk+rCzrNxaYBfoV+3dJl9XohdW2gD5/EyZ1lTbVCQgWG4ZF
IKbE35TvTyP09zKGmhMSjOmbe9LEUaAUfH8VteDGAbV/4Alc02QCnQN+jjx9j3IP
PfE9eqTyEFI1erhJlHDoFBTod0jh0cwptT1AtxchbvcJ0YdRCD4f1nwRjcZ65m5h
fatqXOPK0P97WTG66Hh2BAQ9RoS79jNF2Z+UScqjyGR87Zz2boaKxMXzWseYudMV
lOAhCCXXnkJ7aP2FQq7aQZiMYEGWN/Zc5GIf66fFjk8aSuejukaz3fYiirdjQHLk
S/35io5O3ESzihb50e6q4RJnphOhWmHkIRz/ZkpSr5KVEC+MzNw=
=x6IL
-----END PGP SIGNATURE-----

--E8bmDsSmoPzt7EDiGHAtjhForEWYUEqNs--
