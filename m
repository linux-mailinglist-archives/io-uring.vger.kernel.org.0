Return-Path: <io-uring+bounces-1061-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD1487E133
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:15:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DEA21B217F7
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E756F4FB;
	Mon, 18 Mar 2024 00:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cWjymG9p"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2566EEB9
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 00:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710720940; cv=none; b=EH7zMof9BYkSUBAy8mElDH5bWJ/8V2/cacMmg5qN/vOj3CXO5rjj/eesONYmZKmCS7oqXk/6J9gVWAdWnpPVEpDmjuIcL2MMb5AvZdsDrpY8wnWWHFTyaWbOqoObUY+qA5t7vJyrAuzEvAkdrS5xJ/UOpP1mYYcH3DwMoQpxVw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710720940; c=relaxed/simple;
	bh=+G/dQ7yuWAv0ahkX0i8IM7SJf+VB6Vc9F96WuRoLw8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GOv/4IlGk98z5EjStvxxLsYtOug0fREOkDm/HU/GVufrA7IcJ3ekVme7bPsNO26kSc9q/89/WxtbZIIdB+4snc4Z6NrUFOnUrWHKoqyKgLjWiYAmMaIY/JQqC+xoSEHvn8I20Kdblbye0crYchwbgTvH9F4aoLhZP5Lx2w/szHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cWjymG9p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710720937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PqwaXJjYjcz/inqfowogBWtplAA1tSXC42/ejL1ujUQ=;
	b=cWjymG9p8LA3ztz+RW3IP7RyMMK83s30uwSBJKFGZ/pWMTcl/2kqZjAxvsMddgfVr9SVGv
	YBXNX+Y9SF/v1oZgVV99QdolzD+ULjlQOgalmLMLAnP9ZM/YdOf3RCx1vTK9js6FXg+Fso
	5YJ9w93O4hvQPB3Vrxz4DKLuozCYiLs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-Y3QkjVxEMrmoiujZfne_VA-1; Sun, 17 Mar 2024 20:15:33 -0400
X-MC-Unique: Y3QkjVxEMrmoiujZfne_VA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C83A58007A1;
	Mon, 18 Mar 2024 00:15:32 +0000 (UTC)
Received: from fedora (unknown [10.72.116.15])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D24F10F43;
	Mon, 18 Mar 2024 00:15:28 +0000 (UTC)
Date: Mon, 18 Mar 2024 08:15:20 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Message-ID: <ZfeHmNtoTo9nvTaV@fedora>
References: <ZfWk9Pp0zJ1i1JAE@fedora>
 <1132db8f-829f-4ea8-bdee-8f592b5e3c19@gmail.com>
 <e25412ba-916c-4de7-8ed2-18268f656731@kernel.dk>
 <d3beeb72-c4cf-4fad-80bc-10ca1f035fff@gmail.com>
 <4787bb12-bb89-490a-9d30-40b4f54a19ad@kernel.dk>
 <6dea0285-254d-4985-982b-39f3897bf064@gmail.com>
 <2091c056-d5ed-44e3-a163-b95680cece27@gmail.com>
 <d016a590-d7a9-405f-a2e4-d7c4ffa80fce@kernel.dk>
 <4c47f80f-df74-4b27-b1e7-ce30d5c959f9@kernel.dk>
 <4320d059-0308-42c3-b01f-18107885ffbd@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4320d059-0308-42c3-b01f-18107885ffbd@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Sun, Mar 17, 2024 at 04:24:07PM -0600, Jens Axboe wrote:
> On 3/17/24 4:07 PM, Jens Axboe wrote:
> > On 3/17/24 3:51 PM, Jens Axboe wrote:
> >> On 3/17/24 3:47 PM, Pavel Begunkov wrote:
> >>> On 3/17/24 21:34, Pavel Begunkov wrote:
> >>>> On 3/17/24 21:32, Jens Axboe wrote:
> >>>>> On 3/17/24 3:29 PM, Pavel Begunkov wrote:
> >>>>>> On 3/17/24 21:24, Jens Axboe wrote:
> >>>>>>> On 3/17/24 2:55 PM, Pavel Begunkov wrote:
> >>>>>>>> On 3/16/24 13:56, Ming Lei wrote:
> >>>>>>>>> On Sat, Mar 16, 2024 at 01:27:17PM +0000, Pavel Begunkov wrote:
> >>>>>>>>>> On 3/16/24 11:52, Ming Lei wrote:
> >>>>>>>>>>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
> >>>>>>>>>
> >>>>>>>>> ...
> >>>>>>>>>
> >>>>>>>>>>> The following two error can be triggered with this patchset
> >>>>>>>>>>> when running some ublk stress test(io vs. deletion). And not see
> >>>>>>>>>>> such failures after reverting the 11 patches.
> >>>>>>>>>>
> >>>>>>>>>> I suppose it's with the fix from yesterday. How can I
> >>>>>>>>>> reproduce it, blktests?
> >>>>>>>>>
> >>>>>>>>> Yeah, it needs yesterday's fix.
> >>>>>>>>>
> >>>>>>>>> You may need to run this test multiple times for triggering the problem:
> >>>>>>>>
> >>>>>>>> Thanks for all the testing. I've tried it, all ublk/generic tests hang
> >>>>>>>> in userspace waiting for CQEs but no complaints from the kernel.
> >>>>>>>> However, it seems the branch is buggy even without my patches, I
> >>>>>>>> consistently (5-15 minutes of running in a slow VM) hit page underflow
> >>>>>>>> by running liburing tests. Not sure what is that yet, but might also
> >>>>>>>> be the reason.
> >>>>>>>
> >>>>>>> Hmm odd, there's nothing in there but your series and then the
> >>>>>>> io_uring-6.9 bits pulled in. Maybe it hit an unfortunate point in the
> >>>>>>> merge window -git cycle? Does it happen with io_uring-6.9 as well? I
> >>>>>>> haven't seen anything odd.
> >>>>>>
> >>>>>> Need to test io_uring-6.9. I actually checked the branch twice, both
> >>>>>> with the issue, and by full recompilation and config prompts I assumed
> >>>>>> you pulled something in between (maybe not).
> >>>>>>
> >>>>>> And yeah, I can't confirm it's specifically an io_uring bug, the
> >>>>>> stack trace is usually some unmap or task exit, sometimes it only
> >>>>>> shows when you try to shutdown the VM after tests.
> >>>>>
> >>>>> Funky. I just ran a bunch of loops of liburing tests and Ming's ublksrv
> >>>>> test case as well on io_uring-6.9 and it all worked fine. Trying
> >>>>> liburing tests on for-6.10/io_uring as well now, but didn't see anything
> >>>>> the other times I ran it. In any case, once you repost I'll rebase and
> >>>>> then let's see if it hits again.
> >>>>>
> >>>>> Did you run with KASAN enabled
> >>>>
> >>>> Yes, it's a debug kernel, full on KASANs, lockdeps and so
> >>>
> >>> And another note, I triggered it once (IIRC on shutdown) with ublk
> >>> tests only w/o liburing/tests, likely limits it to either the core
> >>> io_uring infra or non-io_uring bugs.
> >>
> >> Been running on for-6.10/io_uring, and the only odd thing I see is that
> >> the test output tends to stall here:
> >>
> >> Running test read-before-exit.t
> >>
> >> which then either leads to a connection disconnect from my ssh into that
> >> vm, or just a long delay and then it picks up again. This did not happen
> >> with io_uring-6.9.
> >>
> >> Maybe related? At least it's something new. Just checked again, and yeah
> >> it seems to totally lock up the vm while that is running. Will try a
> >> quick bisect of that series.
> > 
> > Seems to be triggered by the top of branch patch in there, my poll and
> > timeout special casing. While the above test case runs with that commit,
> > it'll freeze the host.
> 
> Had a feeling this was the busy looping off cancelations, and flushing
> the fallback task_work seems to fix it. I'll check more tomorrow.
> 
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index a2cb8da3cc33..f1d3c5e065e9 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3242,6 +3242,8 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>  	ret |= io_kill_timeouts(ctx, task, cancel_all);
>  	if (task)
>  		ret |= io_run_task_work() > 0;
> +	else if (ret)
> +		flush_delayed_work(&ctx->fallback_work);
>  	return ret;
>  }

Still can trigger the warning with above patch:

[  446.275975] ------------[ cut here ]------------
[  446.276340] WARNING: CPU: 8 PID: 731 at kernel/fork.c:969 __put_task_struct+0x10c/0x180
[  446.276931] Modules linked in: isofs binfmt_misc xfs vfat fat raid0 iTCO_wdt intel_pmc_bxt iTCO_vendor_support virtio_net i2c_i801 net_fag
[  446.278608] CPU: 8 PID: 731 Comm: kworker/8:2 Not tainted 6.8.0_io_uring_6.10+ #20
[  446.279535] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc37 04/01/2014
[  446.280440] Workqueue: events io_fallback_req_func
[  446.280971] RIP: 0010:__put_task_struct+0x10c/0x180
[  446.281485] Code: 48 85 d2 74 05 f0 ff 0a 74 44 48 8b 3d b5 83 c7 02 48 89 ee e8 a5 f6 2e 00 eb ac be 03 00 00 00 48 89 ef e8 26 9f 72 002
[  446.282727] RSP: 0018:ffffb325c06bfdf8 EFLAGS: 00010246
[  446.283099] RAX: 0000000000000000 RBX: ffff92717cabaf40 RCX: 0000000000000000
[  446.283578] RDX: 0000000000000001 RSI: 0000000000000246 RDI: ffff92717cabaf40
[  446.284062] RBP: ffff92710cab4800 R08: 0000000000000000 R09: 0000000000000000
[  446.284545] R10: ffffb325c06bfdb0 R11: 0000000000000100 R12: ffff92717aedc580
[  446.285233] R13: ffff92717aedc580 R14: ffff927151ee5a00 R15: 0000000000000000
[  446.285840] FS:  0000000000000000(0000) GS:ffff927667c00000(0000) knlGS:0000000000000000
[  446.286412] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  446.286819] CR2: 00007feacac32000 CR3: 0000000618020002 CR4: 0000000000770ef0
[  446.287310] PKRU: 55555554
[  446.287534] Call Trace:
[  446.287752]  <TASK>
[  446.287941]  ? __warn+0x80/0x120
[  446.288206]  ? __put_task_struct+0x10c/0x180
[  446.288524]  ? report_bug+0x164/0x190
[  446.288816]  ? handle_bug+0x41/0x70
[  446.289098]  ? exc_invalid_op+0x17/0x70
[  446.289392]  ? asm_exc_invalid_op+0x1a/0x20
[  446.289715]  ? __put_task_struct+0x10c/0x180
[  446.290038]  ? io_put_task_remote+0x80/0x90
[  446.290372]  __io_submit_flush_completions+0x2d6/0x390
[  446.290761]  io_fallback_req_func+0xad/0x140
[  446.291088]  process_one_work+0x189/0x3b0
[  446.291403]  worker_thread+0x277/0x390
[  446.291700]  ? __pfx_worker_thread+0x10/0x10
[  446.292018]  kthread+0xcf/0x100
[  446.292278]  ? __pfx_kthread+0x10/0x10
[  446.292562]  ret_from_fork+0x31/0x50
[  446.292848]  ? __pfx_kthread+0x10/0x10
[  446.293143]  ret_from_fork_asm+0x1a/0x30
[  446.293576]  </TASK>
[  446.293919] ---[ end trace 0000000000000000 ]---
[  446.294460] ------------[ cut here ]------------
[  446.294808] WARNING: CPU: 8 PID: 731 at kernel/fork.c:601 free_task+0x61/0x70
[  446.295294] Modules linked in: isofs binfmt_misc xfs vfat fat raid0 iTCO_wdt intel_pmc_bxt iTCO_vendor_support virtio_net i2c_i801 net_fag
[  446.296901] CPU: 8 PID: 731 Comm: kworker/8:2 Tainted: G        W          6.8.0_io_uring_6.10+ #20
[  446.297521] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc37 04/01/2014
[  446.298110] Workqueue: events io_fallback_req_func
[  446.298455] RIP: 0010:free_task+0x61/0x70
[  446.298756] Code: f3 ff f6 43 2e 20 75 18 48 89 df e8 49 7b 20 00 48 8b 3d e2 84 c7 02 48 89 de 5b e9 c9 f7 2e 00 48 89 df e8 61 70 03 000
[  446.303360] RSP: 0018:ffffb325c06bfe00 EFLAGS: 00010202
[  446.303745] RAX: 0000000000000001 RBX: ffff92717cabaf40 RCX: 0000000009a40008
[  446.304226] RDX: 0000000009a3e008 RSI: 000000000003b060 RDI: 6810a90e7192ffff
[  446.304763] RBP: ffff92710cab4800 R08: 0000000000000000 R09: 00000000820001df
[  446.305288] R10: 00000000820001df R11: 000000000000000d R12: ffff92717aedc580
[  446.305769] R13: ffff92717aedc580 R14: ffff927151ee5a00 R15: 0000000000000000
[  446.306251] FS:  0000000000000000(0000) GS:ffff927667c00000(0000) knlGS:0000000000000000
[  446.306815] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  446.307220] CR2: 00007feacac32000 CR3: 0000000618020002 CR4: 0000000000770ef0
[  446.307702] PKRU: 55555554
[  446.307924] Call Trace:
[  446.308135]  <TASK>
[  446.308322]  ? __warn+0x80/0x120
[  446.308637]  ? free_task+0x61/0x70
[  446.308926]  ? report_bug+0x164/0x190
[  446.309207]  ? handle_bug+0x41/0x70
[  446.309474]  ? exc_invalid_op+0x17/0x70
[  446.309767]  ? asm_exc_invalid_op+0x1a/0x20
[  446.310076]  ? free_task+0x61/0x70
[  446.310340]  __io_submit_flush_completions+0x2d6/0x390
[  446.310711]  io_fallback_req_func+0xad/0x140
[  446.311067]  process_one_work+0x189/0x3b0
[  446.311492]  worker_thread+0x277/0x390
[  446.311881]  ? __pfx_worker_thread+0x10/0x10
[  446.312205]  kthread+0xcf/0x100
[  446.312457]  ? __pfx_kthread+0x10/0x10
[  446.312750]  ret_from_fork+0x31/0x50
[  446.313028]  ? __pfx_kthread+0x10/0x10
[  446.313320]  ret_from_fork_asm+0x1a/0x30
[  446.313616]  </TASK>
[  446.313812] ---[ end trace 0000000000000000 ]---
[  446.314171] BUG: kernel NULL pointer dereference, address: 0000000000000098
[  446.314184] ------------[ cut here ]------------
[  446.314495] #PF: supervisor read access in kernel mode
[  446.314747] kernel BUG at mm/slub.c:553!
[  446.314986] #PF: error_code(0x0000) - not-present page
[  446.316032] PGD 0 P4D 0
[  446.316253] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  446.316573] CPU: 8 PID: 9914 Comm: ublk Tainted: G        W          6.8.0_io_uring_6.10+ #20
[  446.317167] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc37 04/01/2014
[  446.317763] RIP: 0010:release_task+0x3b/0x560
[  446.318089] Code: 55 53 48 89 fb 48 83 ec 28 65 48 8b 04 25 28 00 00 00 48 89 44 24 20 31 c0 e8 d1 17 0b 00 e8 cc 17 0b 00 48 8b 83 b8 0bf
[  446.319301] RSP: 0018:ffffb325cdb2bca8 EFLAGS: 00010202
[  446.319672] RAX: 0000000000000000 RBX: ffff92717cabaf40 RCX: ffffb325cdb2bd18
[  446.320151] RDX: ffff92717cabaf40 RSI: ffff92717cabb948 RDI: ffff92717cabaf40
[  446.320628] RBP: ffffb325cdb2bd18 R08: ffffb325cdb2bd18 R09: 0000000000000000
[  446.321122] R10: 0000000000000001 R11: 0000000000000100 R12: ffffb325cdb2bd18
[  446.321706] R13: ffffb325cdb2b310 R14: ffffb325cdb2b310 R15: 0000000000000000
[  446.322188] FS:  0000000000000000(0000) GS:ffff927667c00000(0000) knlGS:0000000000000000
[  446.322742] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  446.323169] CR2: 0000000000000098 CR3: 0000000618020002 CR4: 0000000000770ef0
[  446.324013] PKRU: 55555554
[  446.324267] Call Trace:
[  446.324466]  <TASK>
[  446.324646]  ? __die+0x23/0x70
[  446.324881]  ? page_fault_oops+0x173/0x4f0
[  446.325175]  ? _raw_spin_unlock_irq+0xe/0x30
[  446.325475]  ? exc_page_fault+0x76/0x170
[  446.325752]  ? asm_exc_page_fault+0x26/0x30
[  446.326048]  ? release_task+0x3b/0x560
[  446.326321]  ? release_task+0x34/0x560
[  446.326589]  do_exit+0x6fd/0xad0
[  446.326832]  do_group_exit+0x30/0x80
[  446.327100]  get_signal+0x8de/0x8e0
[  446.327355]  arch_do_signal_or_restart+0x3e/0x240
[  446.327680]  syscall_exit_to_user_mode+0x167/0x210
[  446.328008]  do_syscall_64+0x96/0x170
[  446.328361]  ? syscall_exit_to_user_mode+0x60/0x210
[  446.328879]  ? do_syscall_64+0x96/0x170
[  446.329173]  entry_SYSCALL_64_after_hwframe+0x6c/0x74
[  446.329524] RIP: 0033:0x7feadc57e445
[  446.329796] Code: Unable to access opcode bytes at 0x7feadc57e41b.
[  446.330208] RSP: 002b:00007feadb3ffd38 EFLAGS: 00000202 ORIG_RAX: 00000000000001aa
[  446.330717] RAX: 0000000000000078 RBX: 0000000000000000 RCX: 00007feadc57e445
[  446.331184] RDX: 0000000000000001 RSI: 0000000000000078 RDI: 0000000000000000
[  446.331642] RBP: 00007feacc002ff8 R08: 00007feadb3ffd70 R09: 0000000000000018
[  446.332107] R10: 0000000000000019 R11: 0000000000000202 R12: 00007feadb3ffd90
[  446.332564] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000001aa
[  446.333022]  </TASK>
[  446.333208] Modules linked in: isofs binfmt_misc xfs vfat fat raid0 iTCO_wdt intel_pmc_bxt iTCO_vendor_support virtio_net i2c_i801 net_fag
[  446.334744] CR2: 0000000000000098
[  446.335008] ---[ end trace 0000000000000000 ]---



Thanks, 
Ming


