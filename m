Return-Path: <io-uring+bounces-1012-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1FD87DA05
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 12:53:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 176E21F217D5
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 11:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3391DEAE5;
	Sat, 16 Mar 2024 11:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D9SC2W59"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A30E17BA9
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 11:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710589994; cv=none; b=ZR/YXYuhqILVuklccTeF0ViHeKWlR+AqourMrSeXfT5F8nO1JbRbZ5r2hveL0P+KJ3qpSZRlmwko/170TWFxNXtrzJniviTD4W+DnYYHJResn1d451Vhi+Uwi2MoJeMTrReneprf1u0VUXvcxhunNWwTVuDIU5qXcCKBzdUcgCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710589994; c=relaxed/simple;
	bh=sBiI5u6isAPoROqL+vLkXFol7n68sQT+kFrvlfw9Ycg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EIS6zbbjCYrdEBKZltvOGzHye6mMuVhDcBa4GcTz22/puiTTrH59fWfQvV3HeaN0i0mSGgEg0DVdeqrqfuWh0ysVVeE6Y/v0D8BvlkVDpo09fp5ZmKV5JtgrZBwyXt+SNqlDrKgYUIVOyFuh/XexF9mDua/plJslUK1E92LesTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D9SC2W59; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710589990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jUFVmY04vNVnzUU0YWfMaDxa1zRlNCjNzXpAi0DS6Po=;
	b=D9SC2W59duj48FG0O1613Dfur42fcAoqXYP2YI+qfvy+cwK5aT61sp2m6SiRd6JTQi4bM3
	AWvI64/fkBhdGbudIK9VkBzW0tSLQjvu4u9USGK46o/GNaD+vTndODyPyKGyz32SZwZxzT
	XQB1VJkw8QbaN6kJ2E+VUU/rKpJMn30=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-5IVDoheOOOqJR7_gT56wbw-1; Sat, 16 Mar 2024 07:53:05 -0400
X-MC-Unique: 5IVDoheOOOqJR7_gT56wbw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B935185A786;
	Sat, 16 Mar 2024 11:53:05 +0000 (UTC)
Received: from fedora (unknown [10.72.116.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B6BF492BC6;
	Sat, 16 Mar 2024 11:53:00 +0000 (UTC)
Date: Sat, 16 Mar 2024 19:52:52 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Message-ID: <ZfWIFOkN/X9uyJJe@fedora>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
> 
> On Fri, 15 Mar 2024 15:29:50 +0000, Pavel Begunkov wrote:
> > Patch 1 is a fix.
> > 
> > Patches 2-7 are cleanups mainly dealing with issue_flags conversions,
> > misundertsandings of the flags and of the tw state. It'd be great to have
> > even without even w/o the rest.
> > 
> > 8-11 mandate ctx locking for task_work and finally removes the CQE
> > caches, instead we post directly into the CQ. Note that the cache is
> > used by multishot auxiliary completions.
> > 
> > [...]
> 
> Applied, thanks!
> 
> [02/11] io_uring/cmd: kill one issue_flags to tw conversion
>         commit: 31ab0342cf6434e1e2879d12f0526830ce97365d
> [03/11] io_uring/cmd: fix tw <-> issue_flags conversion
>         commit: b48f3e29b89055894b3f50c657658c325b5b49fd
> [04/11] io_uring/cmd: introduce io_uring_cmd_complete
>         commit: c5b4c92ca69215c0af17e4e9d8c84c8942f3257d
> [05/11] ublk: don't hard code IO_URING_F_UNLOCKED
>         commit: c54cfb81fe1774231fca952eff928389bfc3b2e3
> [06/11] nvme/io_uring: don't hard code IO_URING_F_UNLOCKED
>         commit: 800a90681f3c3383660a8e3e2d279e0f056afaee
> [07/11] io_uring/rw: avoid punting to io-wq directly
>         commit: 56d565d54373c17b7620fc605c899c41968e48d0
> [08/11] io_uring: force tw ctx locking
>         commit: f087cdd065af0418ffc8a9ed39eadc93347efdd5
> [09/11] io_uring: remove struct io_tw_state::locked
>         commit: 339f8d66e996ec52b47221448ff4b3534cc9a58d
> [10/11] io_uring: refactor io_fill_cqe_req_aux
>         commit: 7b31c3964b769a6a16c4e414baa8094b441e498e
> [11/11] io_uring: get rid of intermediate aux cqe caches
>         commit: 5a475a1f47412a44ed184aac04b9ff0aeaa31d65

Hi Jens and Pavel,

The following two error can be triggered with this patchset
when running some ublk stress test(io vs. deletion). And not see
such failures after reverting the 11 patches.

1) error 1

[  318.843517] ------------[ cut here ]------------
[  318.843937] kernel BUG at mm/slub.c:553!
[  318.844235] invalid opcode: 0000 [#1] SMP NOPTI
[  318.844580] CPU: 7 PID: 1475 Comm: kworker/u48:13 Not tainted 6.8.0_io_uring_6.10+ #14
[  318.845133] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc37 04/01/2014
[  318.845732] Workqueue: events_unbound io_ring_exit_work
[  318.846104] RIP: 0010:__slab_free+0x152/0x2f0
[  318.846434] Code: 00 4c 89 ff e8 ef 41 bc 00 48 8b 14 24 48 8b 4c 24 20 48 89 44 24 08 48 8b 03 48 c1 e8 09 83 e0 01 88 44 24 13 e9 71 ff4
[  318.851192] RSP: 0018:ffffb490411abcb0 EFLAGS: 00010246
[  318.851574] RAX: ffff8b0e871e44f0 RBX: fffff113841c7900 RCX: 0000000000200010
[  318.852032] RDX: ffff8b0e871e4400 RSI: fffff113841c7900 RDI: ffffb490411abd20
[  318.852521] RBP: ffffb490411abd50 R08: 0000000000000001 R09: ffffffffa17e4deb
[  318.852981] R10: 0000000000200010 R11: 0000000000000024 R12: ffff8b0e80292c00
[  318.853472] R13: ffff8b0e871e4400 R14: ffff8b0e80292c00 R15: ffffffffa17e4deb
[  318.853911] FS:  0000000000000000(0000) GS:ffff8b13e7b80000(0000) knlGS:0000000000000000
[  318.854448] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  318.854831] CR2: 00007fbce5249298 CR3: 0000000363020002 CR4: 0000000000770ef0
[  318.855291] PKRU: 55555554
[  318.855533] Call Trace:
[  318.855724]  <TASK>
[  318.855898]  ? die+0x36/0x90
[  318.856121]  ? do_trap+0xdd/0x100
[  318.856389]  ? __slab_free+0x152/0x2f0
[  318.856674]  ? do_error_trap+0x6a/0x90
[  318.856939]  ? __slab_free+0x152/0x2f0
[  318.857202]  ? exc_invalid_op+0x50/0x70
[  318.857505]  ? __slab_free+0x152/0x2f0
[  318.857770]  ? asm_exc_invalid_op+0x1a/0x20
[  318.858056]  ? io_req_caches_free+0x9b/0x100
[  318.858439]  ? io_req_caches_free+0x9b/0x100
[  318.858961]  ? __slab_free+0x152/0x2f0
[  318.859466]  ? __memcg_slab_free_hook+0xd9/0x130
[  318.859941]  ? io_req_caches_free+0x9b/0x100
[  318.860395]  kmem_cache_free+0x2eb/0x3b0
[  318.860826]  io_req_caches_free+0x9b/0x100
[  318.861190]  io_ring_exit_work+0x105/0x5c0
[  318.861496]  ? __schedule+0x3d4/0x1510
[  318.861761]  process_one_work+0x181/0x350
[  318.862042]  worker_thread+0x27e/0x390
[  318.862307]  ? __pfx_worker_thread+0x10/0x10
[  318.862621]  kthread+0xbb/0xf0
[  318.862854]  ? __pfx_kthread+0x10/0x10
[  318.863124]  ret_from_fork+0x31/0x50
[  318.863397]  ? __pfx_kthread+0x10/0x10
[  318.863665]  ret_from_fork_asm+0x1a/0x30
[  318.863943]  </TASK>
[  318.864122] Modules linked in: isofs binfmt_misc xfs vfat fat raid0 iTCO_wdt intel_pmc_bxt iTCO_vendor_support virtio_net net_failover i2g
[  318.865638] ---[ end trace 0000000000000000 ]---
[  318.865966] RIP: 0010:__slab_free+0x152/0x2f0
[  318.866267] Code: 00 4c 89 ff e8 ef 41 bc 00 48 8b 14 24 48 8b 4c 24 20 48 89 44 24 08 48 8b 03 48 c1 e8 09 83 e0 01 88 44 24 13 e9 71 ff4
[  318.867622] RSP: 0018:ffffb490411abcb0 EFLAGS: 00010246
[  318.868103] RAX: ffff8b0e871e44f0 RBX: fffff113841c7900 RCX: 0000000000200010
[  318.868602] RDX: ffff8b0e871e4400 RSI: fffff113841c7900 RDI: ffffb490411abd20
[  318.869051] RBP: ffffb490411abd50 R08: 0000000000000001 R09: ffffffffa17e4deb
[  318.869544] R10: 0000000000200010 R11: 0000000000000024 R12: ffff8b0e80292c00
[  318.870028] R13: ffff8b0e871e4400 R14: ffff8b0e80292c00 R15: ffffffffa17e4deb
[  318.870550] FS:  0000000000000000(0000) GS:ffff8b13e7b80000(0000) knlGS:0000000000000000
[  318.871080] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  318.871509] CR2: 00007fbce5249298 CR3: 0000000363020002 CR4: 0000000000770ef0
[  318.871974] PKRU: 55555554

2) error 2

[ 2833.161174] ------------[ cut here ]------------
[ 2833.161527] WARNING: CPU: 11 PID: 22867 at kernel/fork.c:969 __put_task_struct+0x10c/0x180
[ 2833.162114] Modules linked in: isofs binfmt_misc vfat fat xfs raid0 iTCO_wdt intel_pmc_bxt iTCO_vendor_support i2c_i801 virtio_net i2c_smbus net_failover failover lpc_ich ublk_drv loop zram nvme nvme_core usb_storage crc32c_intel virtio_scsi virtio_blk fuse qemu_fw_cfg
[ 2833.163650] CPU: 11 PID: 22867 Comm: kworker/11:0 Tainted: G      D W          6.8.0_io_uring_6.10+ #14
[ 2833.164289] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc37 04/01/2014
[ 2833.164860] Workqueue: events io_fallback_req_func
[ 2833.165224] RIP: 0010:__put_task_struct+0x10c/0x180
[ 2833.165586] Code: 48 85 d2 74 05 f0 ff 0a 74 44 48 8b 3d d5 b6 c7 02 48 89 ee e8 65 b7 2d 00 eb ac be 03 00 00 00 48 89 ef e8 36 82 70 00 eb 9d <0f> 0b 8b 43 28 85 c0 0f 84 0e ff ff ff 0f 0b 65 48 3b 1d 5d d2 f2
[ 2833.166819] RSP: 0018:ffffb89da07a7df8 EFLAGS: 00010246
[ 2833.167210] RAX: 0000000000000000 RBX: ffff97d7d9332ec0 RCX: 0000000000000000
[ 2833.167685] RDX: 0000000000000001 RSI: 0000000000000246 RDI: ffff97d7d9332ec0
[ 2833.168167] RBP: ffff97d6cd9cc000 R08: 0000000000000000 R09: 0000000000000000
[ 2833.168664] R10: ffffb89da07a7db0 R11: 0000000000000100 R12: ffff97d7dee497f0
[ 2833.169161] R13: ffff97d7dee497f0 R14: ffff97d7400e9d00 R15: ffff97d6cd9cc410
[ 2833.169621] FS:  0000000000000000(0000) GS:ffff97dc27d80000(0000) knlGS:0000000000000000
[ 2833.170196] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2833.170578] CR2: 00007fa731cfe648 CR3: 0000000220b30004 CR4: 0000000000770ef0
[ 2833.171158] PKRU: 55555554
[ 2833.171394] Call Trace:
[ 2833.171596]  <TASK>
[ 2833.171779]  ? __warn+0x80/0x110
[ 2833.172044]  ? __put_task_struct+0x10c/0x180
[ 2833.172367]  ? report_bug+0x150/0x170
[ 2833.172637]  ? handle_bug+0x41/0x70
[ 2833.172899]  ? exc_invalid_op+0x17/0x70
[ 2833.173203]  ? asm_exc_invalid_op+0x1a/0x20
[ 2833.173522]  ? __put_task_struct+0x10c/0x180
[ 2833.173826]  ? io_put_task_remote+0x80/0x90
[ 2833.174153]  __io_submit_flush_completions+0x2bd/0x380
[ 2833.174509]  io_fallback_req_func+0xa3/0x130
[ 2833.174806]  process_one_work+0x181/0x350
[ 2833.175105]  worker_thread+0x27e/0x390
[ 2833.175394]  ? __pfx_worker_thread+0x10/0x10
[ 2833.175690]  kthread+0xbb/0xf0
[ 2833.175920]  ? __pfx_kthread+0x10/0x10
[ 2833.176226]  ret_from_fork+0x31/0x50
[ 2833.176485]  ? __pfx_kthread+0x10/0x10
[ 2833.176751]  ret_from_fork_asm+0x1a/0x30
[ 2833.177044]  </TASK>
[ 2833.177256] ---[ end trace 0000000000000000 ]---
[ 2833.177586] BUG: kernel NULL pointer dereference, address: 00000000000000e8
[ 2833.178054] #PF: supervisor read access in kernel mode
[ 2833.178424] #PF: error_code(0x0000) - not-present page
[ 2833.178776] PGD 21f4f9067 P4D 21f4f9067 PUD 21f4fa067 PMD 0
[ 2833.179182] Oops: 0000 [#3] SMP NOPTI
[ 2833.179464] CPU: 11 PID: 22867 Comm: kworker/11:0 Tainted: G      D W          6.8.0_io_uring_6.10+ #14
[ 2833.180110] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc37 04/01/2014
[ 2833.180692] Workqueue: events io_fallback_req_func
[ 2833.181042] RIP: 0010:percpu_counter_add_batch+0x19/0x80
[ 2833.181430] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 41 55 41 54 55 53 9c 58 0f 1f 40 00 49 89 c5 fa 0f 1f 44 00 00 <48> 8b 4f 20 48 63 d2 65 48 63 19 49 89 dc 48 01 f3 48 89 d8 48 f7
[ 2833.182623] RSP: 0018:ffffb89da07a7dd0 EFLAGS: 00010006
[ 2833.186362] RAX: 0000000000000206 RBX: ffff97d7d9332ec0 RCX: 0000000000000000
[ 2833.186825] RDX: 0000000000000020 RSI: ffffffffffffffff RDI: 00000000000000c8
[ 2833.187326] RBP: 0000000000000000 R08: 0000000000000246 R09: 0000000000020001
[ 2833.187783] R10: 0000000000020001 R11: 0000000000000032 R12: ffff97d7dee497f0
[ 2833.188284] R13: 0000000000000206 R14: ffff97d7400e9d00 R15: ffff97d6cd9cc410
[ 2833.188741] FS:  0000000000000000(0000) GS:ffff97dc27d80000(0000) knlGS:0000000000000000
[ 2833.189310] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2833.189709] CR2: 00000000000000e8 CR3: 0000000220b30004 CR4: 0000000000770ef0
[ 2833.190205] PKRU: 55555554
[ 2833.190418] Call Trace:
[ 2833.190615]  <TASK>
[ 2833.190795]  ? __die+0x23/0x70
[ 2833.191053]  ? page_fault_oops+0x173/0x4f0
[ 2833.191362]  ? exc_page_fault+0x76/0x150
[ 2833.191654]  ? asm_exc_page_fault+0x26/0x30
[ 2833.191968]  ? percpu_counter_add_batch+0x19/0x80
[ 2833.192313]  io_put_task_remote+0x2a/0x90
[ 2833.192594]  __io_submit_flush_completions+0x2bd/0x380
[ 2833.192944]  io_fallback_req_func+0xa3/0x130
[ 2833.193273]  process_one_work+0x181/0x350
[ 2833.193550]  worker_thread+0x27e/0x390
[ 2833.193813]  ? __pfx_worker_thread+0x10/0x10
[ 2833.194123]  kthread+0xbb/0xf0
[ 2833.194369]  ? __pfx_kthread+0x10/0x10
[ 2833.194638]  ret_from_fork+0x31/0x50
[ 2833.194899]  ? __pfx_kthread+0x10/0x10
[ 2833.195213]  ret_from_fork_asm+0x1a/0x30
[ 2833.195484]  </TASK>
[ 2833.195661] Modules linked in: isofs binfmt_misc vfat fat xfs raid0 iTCO_wdt intel_pmc_bxt iTCO_vendor_support i2c_i801 virtio_net i2c_smbus net_failover failover lpc_ich ublk_drv loop zram nvme nvme_core usb_storage crc32c_intel virtio_scsi virtio_blk fuse qemu_fw_cfg
[ 2833.197148] CR2: 00000000000000e8
[ 2833.197400] ---[ end trace 0000000000000000 ]---
[ 2833.197714] RIP: 0010:percpu_counter_add_batch+0x19/0x80
[ 2833.198078] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 41 55 41 54 55 53 9c 58 0f 1f 40 00 49 89 c5 fa 0f 1f 44 00 00 <48> 8b 4f 20 48 63 d2 65 48 63 19 49 89 dc 48 01 f3 48 89 d8 48 f7
[ 2833.199261] RSP: 0018:ffffb89d8b0f7dd0 EFLAGS: 00010006
[ 2833.199599] RAX: 0000000000000206 RBX: ffff97d77b830000 RCX: 0000000080020001
[ 2833.200051] RDX: 0000000000000020 RSI: ffffffffffffffff RDI: 00000000000000c8
[ 2833.200515] RBP: 0000000000000000 R08: ffff97d77b830000 R09: 0000000080020001
[ 2833.200956] R10: 0000000080020001 R11: 0000000000000016 R12: ffff97d75210c6c0
[ 2833.201439] R13: 0000000000000206 R14: ffff97d7518f3800 R15: ffff97d6c304bc10
[ 2833.201894] FS:  0000000000000000(0000) GS:ffff97dc27d80000(0000) knlGS:0000000000000000
[ 2833.202455] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2833.202832] CR2: 00000000000000e8 CR3: 0000000220b30004 CR4: 0000000000770ef0
[ 2833.203316] PKRU: 55555554
[ 2833.203524] note: kworker/11:0[22867] exited with irqs disabled


Thanks, 
Ming


