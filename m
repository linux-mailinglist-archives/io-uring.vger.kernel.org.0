Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFD13D320D
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 04:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhGWCKy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jul 2021 22:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233222AbhGWCKx (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 22 Jul 2021 22:10:53 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BDD960EBD;
        Fri, 23 Jul 2021 02:51:26 +0000 (UTC)
Date:   Thu, 22 Jul 2021 22:51:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sched_waking vs. set_event_pid crash (Re: Tracing busy
 processes/threads freezes/stalls the whole machine)
Message-ID: <20210722225124.6d7d7153@rorschach.local.home>
In-Reply-To: <4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org>
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
        <20210504092404.6b12aba4@gandalf.local.home>
        <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
        <20210504093550.5719d4bd@gandalf.local.home>
        <f351bdfa-5223-e457-0396-a24ffa09d6b5@samba.org>
        <8bb757fb-a83b-0ed5-5247-8273be3925c5@samba.org>
        <90c806a0-8a2f-1257-7337-6761100217c9@samba.org>
        <4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 23 Jul 2021 00:43:13 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> Hi Steve,
> 
> After some days of training:
> https://training.linuxfoundation.org/training/linux-kernel-debugging-and-security/
> I was able to get much closer to the problem :-)

Well, knowing what to look for was not going to be easy. And I'm sure
you were shocked to see what I posted as a fix ;-)

Assuming this does fix your issue, I sent out a real patch with the
explanation of what happened in the change log, so that you can see why
that change was your issue.

> 
> In order to reproduce it and get reliable kexec crash dumps,
> I needed to give the VM at least 3 cores.

Yes, it did require having this run on multiple CPUs to have a race
condition trigger, and two cores would have been hard to hit it. I ran
it on 8 cores and it triggered rather easily.

> 
> While running './io-uring_cp-forever link-cp.c file' (from:
> https://github.com/metze-samba/liburing/commits/io_uring-cp-forever )
> in one window, the following simple sequence triggered the problem in most cases:
> 
> echo 1 > /sys/kernel/tracing/events/sched/sched_waking/enable
> echo 1 > /sys/kernel/tracing/set_event_pid

All it took was something busy that did a lot of wakeups while setting
the set_event_pid, to be able to hit the race easily. As I stated, I
triggered it with running hackbench instead of the io-uring code. In
fact, this bug had nothing to do with io-uring, and you were only
triggering it because you were making enough of a load on the system to
make the race happen often.

> 
> It triggered the following:
> 
> > [  192.924023] ------------[ cut here ]------------
> > [  192.924026] WARNING: CPU: 2 PID: 1696 at arch/x86/include/asm/kfence.h:44 kfence_protect_page+0x33/0xc0
> > [  192.924034] Modules linked in: vboxsf intel_rapl_msr intel_rapl_common crct10dif_pclmul ghash_clmulni_intel aesni_intel crypto_simd cryptd rapl vboxvideo drm_vr
> > am_helper drm_ttm_helper ttm snd_intel8x0 input_leds snd_ac97_codec joydev ac97_bus serio_raw snd_pcm drm_kms_helper cec mac_hid vboxguest snd_timer rc_core snd fb
> > _sys_fops syscopyarea sysfillrect soundcore sysimgblt kvm_intel kvm sch_fq_codel drm sunrpc ip_tables x_tables autofs4 hid_generic usbhid hid crc32_pclmul psmouse 
> > ahci libahci e1000 i2c_piix4 pata_acpi video
> > [  192.924068] CPU: 2 PID: 1696 Comm: io_uring-cp-for Kdump: loaded Not tainted 5.13.0-1007-oem #7-Ubuntu
> > [  192.924071] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> > [  192.924072] RIP: 0010:kfence_protect_page+0x33/0xc0
> > [  192.924075] Code: 53 89 f3 48 8d 75 e4 48 83 ec 10 65 48 8b 04 25 28 00 00 00 48 89 45 e8 31 c0 e8 98 1f da ff 48 85 c0 74 06 83 7d e4 01 74 06 <0f> 0b 31 c0 eb 39 48 8b 38 48 89 c2 84 db 75 47 48 89 f8 0f 1f 40
> > [  192.924077] RSP: 0018:ffff980c0077f918 EFLAGS: 00010046
> > [  192.924079] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffbcc10000
> > [  192.924080] RDX: ffff980c0077f91c RSI: 0000000000032000 RDI: 0000000000000000
> > [  192.924082] RBP: ffff980c0077f938 R08: 0000000000000000 R09: 0000000000000000
> > [  192.924083] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000032000
> > [  192.924084] R13: 0000000000000000 R14: ffff980c0077fb58 R15: 0000000000000000
> > [  192.924085] FS:  00007f2491207540(0000) GS:ffff8ccb5bd00000(0000) knlGS:0000000000000000
> > [  192.924087] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  192.924088] CR2: 00000000000325f8 CR3: 0000000102572005 CR4: 00000000000706e0
> > [  192.924091] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  192.924092] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [  192.924093] Call Trace:
> > [  192.924096]  kfence_unprotect+0x17/0x30
> > [  192.924099]  kfence_handle_page_fault+0x97/0x250
> > [  192.924102]  ? cmp_ex_sort+0x30/0x30
> > [  192.924104]  page_fault_oops+0xa0/0x2a0
> > [  192.924106]  ? trace_event_buffer_reserve+0x22/0xb0
> > [  192.924110]  ? search_exception_tables+0x5b/0x60
> > [  192.924113]  kernelmode_fixup_or_oops+0x92/0xf0
> > [  192.924115]  __bad_area_nosemaphore+0x14d/0x190
> > [  192.924116]  __bad_area+0x5f/0x80
> > [  192.924118]  bad_area+0x16/0x20
> > [  192.924119]  do_user_addr_fault+0x368/0x640> [  192.924121]  ? aa_file_perm+0x11d/0x470
> > [  192.924123]  exc_page_fault+0x7d/0x170
> > [  192.924127]  asm_exc_page_fault+0x1e/0x30
> > [  192.924129] RIP: 0010:trace_event_buffer_reserve+0x22/0xb0
> > [  192.924132] Code: 00 00 00 00 0f 1f 40 00 55 48 89 e5 41 56 41 55 49 89 d5 41 54 49 89 f4 53 48 89 fb 4c 8b 76 10 f6 46 49 02 74 29 48 8b 46 28 <48> 8b 88 b8 00 00 00 48 8b 90 c0 00 00 00 48 09 d1 74 12 48 8b 40
> > [  192.924134] RSP: 0018:ffff980c0077fc00 EFLAGS: 00010002
> > [  192.924135] RAX: 0000000000032540 RBX: ffff980c0077fc38 RCX: 0000000000000002
> > [  192.924136] RDX: 0000000000000028 RSI: ffffffffbcdb7e80 RDI: ffff980c0077fc38
> > [  192.924137] RBP: ffff980c0077fc20 R08: ffff8ccb46814cb8 R09: 0000000000000010
> > [  192.924138] R10: 000000007ffff000 R11: 0000000000000000 R12: ffffffffbcdb7e80
> > [  192.924140] R13: 0000000000000028 R14: 0000000000000000 R15: ffff8ccb49b6ed0c
> > [  192.924142]  trace_event_raw_event_sched_wakeup_template+0x63/0xf0
> > [  192.924146]  try_to_wake_up+0x285/0x570
> > [  192.924148]  wake_up_process+0x15/0x20
> > [  192.924149]  io_wqe_activate_free_worker+0x5b/0x70
> > [  192.924152]  io_wqe_enqueue+0xfb/0x190
> > [  192.924154]  io_wq_enqueue+0x1e/0x20
> > [  192.924156]  io_queue_async_work+0xa0/0x120
> > [  192.924158]  __io_queue_sqe+0x17e/0x360
> > [  192.924160]  ? io_req_free_batch_finish+0x8d/0xf0
> > [  192.924162]  io_queue_sqe+0x199/0x2a0
> > [  192.924164]  io_submit_sqes+0x70d/0x7f0
> > [  192.924166]  __x64_sys_io_uring_enter+0x1b8/0x3d0
> > [  192.924168]  do_syscall_64+0x40/0xb0
> > [  192.924170]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [  192.924172] RIP: 0033:0x7f249112f89d
> > [  192.924174] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 f5 0c 00 f7 d8 64 89 01 48
> > [  192.924179] RSP: 002b:00007fff56c491c8 EFLAGS: 00000216 ORIG_RAX: 00000000000001aa
> > [  192.924180] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f249112f89d
> > [  192.924182] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000005
> > [  192.924182] RBP: 00007fff56c49200 R08: 0000000000000000 R09: 0000000000000008
> > [  192.924183] R10: 0000000000000000 R11: 0000000000000216 R12: 0000000000000000
> > [  192.924184] R13: 00007fff56c49380 R14: 0000000000000dcf R15: 000055c533b6f2a0
> > [  192.924186] ---[ end trace d1211902aae73d20 ]---  
> 
> The problem seems to happen in this line of trace_event_ignore_this_pid():
> 
> pid_list = rcu_dereference_raw(tr->filtered_pids);

That "tr" comes from the trace_event_file that is passed in by the
"data" field of the callback. Hence, this callback got the data field
of the event_filter_pid_sched_wakeup_probe_pre() callback that is
called before all events when the set_event_pid file is set. That
means, the "tr" being dereferened was not the "tr" you were looking for.

> 
> It seems it got inlined within trace_event_buffer_reserve()
> 
> There strangest things I found so far is this:
> 
> crash> sym global_trace  
> ffffffffbcdb7e80 (d) global_trace
> crash> list ftrace_trace_arrays  
> ffffffffbcdb7e70
> ffffffffbcdb7e80
> 
> trace_array has size 7672, but ffffffffbcdb7e70 is only 16 bytes away from
> ffffffffbcdb7e80.

ftrace_trace_arrays is a list_head, and I doubt you created any
instances, thus the list head has only one instance, and that is
global_trace. Hence, it points to global_trace and itself. It just so
happens that a list_head is 16 bytes.


> 
> Also this:
> 
> crash> struct trace_array.events -o global_trace  
> struct trace_array {
>   [ffffffffbcdb9be0] struct list_head events;
> }
> crash> list -s trace_event_file.tr -o trace_event_file.list ffffffffbcdb9be0  
> ffffffffbcdb9be0
>   tr = 0xffffffffbcdb7b20
> ffff8ccb45cdfb00
>   tr = 0xffffffffbcdb7e80
> ffff8ccb45cdf580
>   tr = 0xffffffffbcdb7e80
> ffff8ccb45cdfe18
>   tr = 0xffffffffbcdb7e80
> ...
>   tr = 0xffffffffbcdb7e80
> 
> The first one 0xffffffffbcdb7b20 is only 864 bytes away from 0xffffffffbcdb7e80

I'm thinking it is confused by hitting the ftrace_trace_arrays
list_head itself.

> 
> Additional information can be found here:
> https://www.samba.org/~metze/202107221802.reproduce-freeze-05-first-time.v3-pid1/
> -rw-r--r-- 1 metze metze 37250108 Jul 22 18:02 dump.202107221802
> -rw-r--r-- 1 metze metze    63075 Jul 22 18:02 dmesg.202107221802
> -rw-r--r-- 1 metze metze     8820 Jul 22 18:13 crash-bt-a-s.txt
> -rw-r--r-- 1 metze metze    36586 Jul 22 18:14 crash-bt-a-l-FF-s.txt
> -rw-r--r-- 1 metze metze     4798 Jul 22 23:49 crash-bt-p.txt
> -rw-r--r-- 1 metze metze      946 Jul 23 00:13 strange-things.txt
> -rw-r--r-- 1 metze metze      482 Jul 23 00:24 code-and-vmlinux.txt
> 
> The code can be found here:
> https://kernel.ubuntu.com/git/kernel-ppa/mirror/ubuntu-oem-5.10-focal.git/tag/?h=Ubuntu-oem-5.13-5.13.0-1007.7
> 
> And the /usr/lib/debug/boot/vmlinux-5.13.0-1007-oem file can be extracted from here:
> http://ddebs.ubuntu.com/pool/main/l/linux-oem-5.13/linux-image-unsigned-5.13.0-1007-oem-dbgsym_5.13.0-1007.7_amd64.ddeb
> 
> Also also needed the latest code from https://github.com/crash-utility/crash.git
> (at commit f53b73e8380bca054cebd2b61ff118c46609429b)
> 
> It would be really great if you (or anyone else on the lists) could have a closer look
> in order to get the problem fixed :-)

Once I triggered it and started looking at what was happening, it
didn't take me to long to figure out where the culprit was.

> 
> I've learned a lot this week and tried hard to find the problem myself,
> but I have to move back to other work for now.
> 

I'm glad you learned a lot. There's a lot of complex code in there, and
its getting more complex, as you can see with the static_calls.

This is because tracing tries hard to avoid the heisenbug effect. You
know, you see a bug, turn on tracing, and then that bug goes away!

Thus it pulls out all the tricks it can to be as least intrusive on the
system as it can be. And that causes things to get complex really quick.

Cheers, and thanks for keeping up on this bug!

-- Steve
