Return-Path: <io-uring+bounces-1016-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33DE687DA48
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 14:29:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54E6E1C20BF6
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 13:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3EE7179BD;
	Sat, 16 Mar 2024 13:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKgH7R9U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B849017BAF;
	Sat, 16 Mar 2024 13:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710595740; cv=none; b=J4AIv86UJ1oqMSMf1ZW7B8HQt1TtEAVXhMYVnHTju96WQMTpC+BgJWytbZezbLKYS2Bfvqb2r8Dg/ztif/xii3MOsJ91vcM9jTJ6sG6WPv2px/u//NMMFNbS7bcyvspYuw8J6zWhT5luVs2cATeuwHLGTu/SeOyeKbFa0LRnG1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710595740; c=relaxed/simple;
	bh=39yh2qWTVZCXVSkKjFQt6+Y1LyQsXfk8//IsHvpccN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dvj+/Nczi1nFvvCq3uAm79wpJOK262oxCX5d3B2LCp0du10fFUYM/nXEvzPwdIbuNCSXeU+1GpBkEEQikdpb1BdzT1VmRxjZISXDJ+TtvGmFyi7RisskenaMJ6uHzbwxbNcrkFbbEeu+gxCSpYhxNMjfPAGMFMy8Ma3o62NSgfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bKgH7R9U; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-413f76fcf41so19629725e9.3;
        Sat, 16 Mar 2024 06:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710595737; x=1711200537; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tkfuwQJtyl5WSWOB8B5TFrjFeHkERgg7M2pJEZ0gc7Y=;
        b=bKgH7R9U5VBvzlu8OtPbiAAHfxuFBAgfC6xPi5cY19nioNitxHCg5WyaWQuwpwlzOw
         MldGDDZBhjYuZ5skHrO580pwCFmks3EIGLNxtgglZUp8TEYxKMK8Kpgqyhrybw34sXH9
         6rb81QU5gGXPyau3gAQjBnyKzIT/LRGix5pkPh4j3yZa6YPtOxQ3ke9twJL+7U6Df8CX
         pACmla2cpn7Gt2FZv1TlZjtLduCYzKJ4z6KcmSh1uhV05pIVzlcvjsEK2lH98UgsfE2L
         pyNrwJiYJh2Wz2v1CB4cX72mJb04t3A2QG/4jrq9NmsygKIbOh4EFGlRn2x+TkH/X3Ty
         uqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710595737; x=1711200537;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tkfuwQJtyl5WSWOB8B5TFrjFeHkERgg7M2pJEZ0gc7Y=;
        b=Sz+kTyQ+Z+QrnwUF1lCAfHzp1toFgmR6K8WZQbLOpq6ARHHcqnr8q1lcp9wK/2rcdC
         AgDM4G9HmCPjb1r/W2HCBjA8zsnaYuI31ZJOwmnKlDZQQtw1RzPLpLr5YeqaVM5FjE1R
         x6dD8sdYEFafmX9ig0A9ib+v6TMRE3AMFK03mwcNjwFwB3cA2SIFQpPW/4Aj1cc3++vh
         Vmr28wmMZd6pp+eG9eodJiW2oq47Ck9Uwk2hH1TdmkcSwMyUZSl/XbT73PiEnBrb4VsD
         rwMvRNheqBGQMuO6PWJ6VbEQxFqOR01RB+5UXFvyy13e4zsnxIEGwrxR7rX7Ug3KaRzz
         dlbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXr9btficVq8nNVZAUqChYrHaL2sYKW18ZQB3SNjkt6S7NtJKvA51vhcZpr/zW5x9EUgJkFM3y0RwAHe+Mh5czQBVnoumddhD5l24U=
X-Gm-Message-State: AOJu0YzHgK5ZEsozdxkjbE3JnW/eFHb1r37BSLAsXCCpTfv17OBEMDyt
	mUuaT07/JFhzOuEwuyKW7ApcgFFNuD2TjrHn7/uqq16ImE6XElPI
X-Google-Smtp-Source: AGHT+IGaUoNN7sImrX6Zjx4BuFUrPQCga45GOIhqRYYqU/g7A4vjIX9YP6zdbcMOYsNRd61hFPYy7w==
X-Received: by 2002:a05:600c:4ec7:b0:413:f1c0:49a8 with SMTP id g7-20020a05600c4ec700b00413f1c049a8mr6090691wmq.9.1710595736696;
        Sat, 16 Mar 2024 06:28:56 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id fc6-20020a05600c524600b00413ee7921b4sm9769609wmb.15.2024.03.16.06.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 06:28:56 -0700 (PDT)
Message-ID: <29b950aa-d3c3-4237-a146-c6abd7b68b8f@gmail.com>
Date: Sat, 16 Mar 2024 13:27:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfWIFOkN/X9uyJJe@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZfWIFOkN/X9uyJJe@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/24 11:52, Ming Lei wrote:
> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
>>
>> On Fri, 15 Mar 2024 15:29:50 +0000, Pavel Begunkov wrote:
>>> Patch 1 is a fix.
>>>
>>> Patches 2-7 are cleanups mainly dealing with issue_flags conversions,
>>> misundertsandings of the flags and of the tw state. It'd be great to have
>>> even without even w/o the rest.
>>>
>>> 8-11 mandate ctx locking for task_work and finally removes the CQE
>>> caches, instead we post directly into the CQ. Note that the cache is
>>> used by multishot auxiliary completions.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [02/11] io_uring/cmd: kill one issue_flags to tw conversion
>>          commit: 31ab0342cf6434e1e2879d12f0526830ce97365d
>> [03/11] io_uring/cmd: fix tw <-> issue_flags conversion
>>          commit: b48f3e29b89055894b3f50c657658c325b5b49fd
>> [04/11] io_uring/cmd: introduce io_uring_cmd_complete
>>          commit: c5b4c92ca69215c0af17e4e9d8c84c8942f3257d
>> [05/11] ublk: don't hard code IO_URING_F_UNLOCKED
>>          commit: c54cfb81fe1774231fca952eff928389bfc3b2e3
>> [06/11] nvme/io_uring: don't hard code IO_URING_F_UNLOCKED
>>          commit: 800a90681f3c3383660a8e3e2d279e0f056afaee
>> [07/11] io_uring/rw: avoid punting to io-wq directly
>>          commit: 56d565d54373c17b7620fc605c899c41968e48d0
>> [08/11] io_uring: force tw ctx locking
>>          commit: f087cdd065af0418ffc8a9ed39eadc93347efdd5
>> [09/11] io_uring: remove struct io_tw_state::locked
>>          commit: 339f8d66e996ec52b47221448ff4b3534cc9a58d
>> [10/11] io_uring: refactor io_fill_cqe_req_aux
>>          commit: 7b31c3964b769a6a16c4e414baa8094b441e498e
>> [11/11] io_uring: get rid of intermediate aux cqe caches
>>          commit: 5a475a1f47412a44ed184aac04b9ff0aeaa31d65
> 
> Hi Jens and Pavel,

Jens, I hope you already dropped the series for now, right?

> 
> The following two error can be triggered with this patchset
> when running some ublk stress test(io vs. deletion). And not see
> such failures after reverting the 11 patches.

I suppose it's with the fix from yesterday. How can I
reproduce it, blktests?



> 1) error 1
> 
> [  318.843517] ------------[ cut here ]------------
> [  318.843937] kernel BUG at mm/slub.c:553!
> [  318.844235] invalid opcode: 0000 [#1] SMP NOPTI
> [  318.844580] CPU: 7 PID: 1475 Comm: kworker/u48:13 Not tainted 6.8.0_io_uring_6.10+ #14
> [  318.845133] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc37 04/01/2014
> [  318.845732] Workqueue: events_unbound io_ring_exit_work
> [  318.846104] RIP: 0010:__slab_free+0x152/0x2f0
> [  318.846434] Code: 00 4c 89 ff e8 ef 41 bc 00 48 8b 14 24 48 8b 4c 24 20 48 89 44 24 08 48 8b 03 48 c1 e8 09 83 e0 01 88 44 24 13 e9 71 ff4
> [  318.851192] RSP: 0018:ffffb490411abcb0 EFLAGS: 00010246
> [  318.851574] RAX: ffff8b0e871e44f0 RBX: fffff113841c7900 RCX: 0000000000200010
> [  318.852032] RDX: ffff8b0e871e4400 RSI: fffff113841c7900 RDI: ffffb490411abd20
> [  318.852521] RBP: ffffb490411abd50 R08: 0000000000000001 R09: ffffffffa17e4deb
> [  318.852981] R10: 0000000000200010 R11: 0000000000000024 R12: ffff8b0e80292c00
> [  318.853472] R13: ffff8b0e871e4400 R14: ffff8b0e80292c00 R15: ffffffffa17e4deb
> [  318.853911] FS:  0000000000000000(0000) GS:ffff8b13e7b80000(0000) knlGS:0000000000000000
> [  318.854448] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  318.854831] CR2: 00007fbce5249298 CR3: 0000000363020002 CR4: 0000000000770ef0
> [  318.855291] PKRU: 55555554
> [  318.855533] Call Trace:
> [  318.855724]  <TASK>
> [  318.855898]  ? die+0x36/0x90
> [  318.856121]  ? do_trap+0xdd/0x100
> [  318.856389]  ? __slab_free+0x152/0x2f0
> [  318.856674]  ? do_error_trap+0x6a/0x90
> [  318.856939]  ? __slab_free+0x152/0x2f0
> [  318.857202]  ? exc_invalid_op+0x50/0x70
> [  318.857505]  ? __slab_free+0x152/0x2f0
> [  318.857770]  ? asm_exc_invalid_op+0x1a/0x20
> [  318.858056]  ? io_req_caches_free+0x9b/0x100
> [  318.858439]  ? io_req_caches_free+0x9b/0x100
> [  318.858961]  ? __slab_free+0x152/0x2f0
> [  318.859466]  ? __memcg_slab_free_hook+0xd9/0x130
> [  318.859941]  ? io_req_caches_free+0x9b/0x100
> [  318.860395]  kmem_cache_free+0x2eb/0x3b0
> [  318.860826]  io_req_caches_free+0x9b/0x100
> [  318.861190]  io_ring_exit_work+0x105/0x5c0
> [  318.861496]  ? __schedule+0x3d4/0x1510
> [  318.861761]  process_one_work+0x181/0x350
> [  318.862042]  worker_thread+0x27e/0x390
> [  318.862307]  ? __pfx_worker_thread+0x10/0x10
> [  318.862621]  kthread+0xbb/0xf0
> [  318.862854]  ? __pfx_kthread+0x10/0x10
> [  318.863124]  ret_from_fork+0x31/0x50
> [  318.863397]  ? __pfx_kthread+0x10/0x10
> [  318.863665]  ret_from_fork_asm+0x1a/0x30
> [  318.863943]  </TASK>
> [  318.864122] Modules linked in: isofs binfmt_misc xfs vfat fat raid0 iTCO_wdt intel_pmc_bxt iTCO_vendor_support virtio_net net_failover i2g
> [  318.865638] ---[ end trace 0000000000000000 ]---
> [  318.865966] RIP: 0010:__slab_free+0x152/0x2f0
> [  318.866267] Code: 00 4c 89 ff e8 ef 41 bc 00 48 8b 14 24 48 8b 4c 24 20 48 89 44 24 08 48 8b 03 48 c1 e8 09 83 e0 01 88 44 24 13 e9 71 ff4
> [  318.867622] RSP: 0018:ffffb490411abcb0 EFLAGS: 00010246
> [  318.868103] RAX: ffff8b0e871e44f0 RBX: fffff113841c7900 RCX: 0000000000200010
> [  318.868602] RDX: ffff8b0e871e4400 RSI: fffff113841c7900 RDI: ffffb490411abd20
> [  318.869051] RBP: ffffb490411abd50 R08: 0000000000000001 R09: ffffffffa17e4deb
> [  318.869544] R10: 0000000000200010 R11: 0000000000000024 R12: ffff8b0e80292c00
> [  318.870028] R13: ffff8b0e871e4400 R14: ffff8b0e80292c00 R15: ffffffffa17e4deb
> [  318.870550] FS:  0000000000000000(0000) GS:ffff8b13e7b80000(0000) knlGS:0000000000000000
> [  318.871080] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  318.871509] CR2: 00007fbce5249298 CR3: 0000000363020002 CR4: 0000000000770ef0
> [  318.871974] PKRU: 55555554
> 
> 2) error 2
> 
> [ 2833.161174] ------------[ cut here ]------------
> [ 2833.161527] WARNING: CPU: 11 PID: 22867 at kernel/fork.c:969 __put_task_struct+0x10c/0x180
> [ 2833.162114] Modules linked in: isofs binfmt_misc vfat fat xfs raid0 iTCO_wdt intel_pmc_bxt iTCO_vendor_support i2c_i801 virtio_net i2c_smbus net_failover failover lpc_ich ublk_drv loop zram nvme nvme_core usb_storage crc32c_intel virtio_scsi virtio_blk fuse qemu_fw_cfg
> [ 2833.163650] CPU: 11 PID: 22867 Comm: kworker/11:0 Tainted: G      D W          6.8.0_io_uring_6.10+ #14
> [ 2833.164289] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc37 04/01/2014
> [ 2833.164860] Workqueue: events io_fallback_req_func
> [ 2833.165224] RIP: 0010:__put_task_struct+0x10c/0x180
> [ 2833.165586] Code: 48 85 d2 74 05 f0 ff 0a 74 44 48 8b 3d d5 b6 c7 02 48 89 ee e8 65 b7 2d 00 eb ac be 03 00 00 00 48 89 ef e8 36 82 70 00 eb 9d <0f> 0b 8b 43 28 85 c0 0f 84 0e ff ff ff 0f 0b 65 48 3b 1d 5d d2 f2
> [ 2833.166819] RSP: 0018:ffffb89da07a7df8 EFLAGS: 00010246
> [ 2833.167210] RAX: 0000000000000000 RBX: ffff97d7d9332ec0 RCX: 0000000000000000
> [ 2833.167685] RDX: 0000000000000001 RSI: 0000000000000246 RDI: ffff97d7d9332ec0
> [ 2833.168167] RBP: ffff97d6cd9cc000 R08: 0000000000000000 R09: 0000000000000000
> [ 2833.168664] R10: ffffb89da07a7db0 R11: 0000000000000100 R12: ffff97d7dee497f0
> [ 2833.169161] R13: ffff97d7dee497f0 R14: ffff97d7400e9d00 R15: ffff97d6cd9cc410
> [ 2833.169621] FS:  0000000000000000(0000) GS:ffff97dc27d80000(0000) knlGS:0000000000000000
> [ 2833.170196] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2833.170578] CR2: 00007fa731cfe648 CR3: 0000000220b30004 CR4: 0000000000770ef0
> [ 2833.171158] PKRU: 55555554
> [ 2833.171394] Call Trace:
> [ 2833.171596]  <TASK>
> [ 2833.171779]  ? __warn+0x80/0x110
> [ 2833.172044]  ? __put_task_struct+0x10c/0x180
> [ 2833.172367]  ? report_bug+0x150/0x170
> [ 2833.172637]  ? handle_bug+0x41/0x70
> [ 2833.172899]  ? exc_invalid_op+0x17/0x70
> [ 2833.173203]  ? asm_exc_invalid_op+0x1a/0x20
> [ 2833.173522]  ? __put_task_struct+0x10c/0x180
> [ 2833.173826]  ? io_put_task_remote+0x80/0x90
> [ 2833.174153]  __io_submit_flush_completions+0x2bd/0x380
> [ 2833.174509]  io_fallback_req_func+0xa3/0x130
> [ 2833.174806]  process_one_work+0x181/0x350
> [ 2833.175105]  worker_thread+0x27e/0x390
> [ 2833.175394]  ? __pfx_worker_thread+0x10/0x10
> [ 2833.175690]  kthread+0xbb/0xf0
> [ 2833.175920]  ? __pfx_kthread+0x10/0x10
> [ 2833.176226]  ret_from_fork+0x31/0x50
> [ 2833.176485]  ? __pfx_kthread+0x10/0x10
> [ 2833.176751]  ret_from_fork_asm+0x1a/0x30
> [ 2833.177044]  </TASK>
> [ 2833.177256] ---[ end trace 0000000000000000 ]---
> [ 2833.177586] BUG: kernel NULL pointer dereference, address: 00000000000000e8
> [ 2833.178054] #PF: supervisor read access in kernel mode
> [ 2833.178424] #PF: error_code(0x0000) - not-present page
> [ 2833.178776] PGD 21f4f9067 P4D 21f4f9067 PUD 21f4fa067 PMD 0
> [ 2833.179182] Oops: 0000 [#3] SMP NOPTI
> [ 2833.179464] CPU: 11 PID: 22867 Comm: kworker/11:0 Tainted: G      D W          6.8.0_io_uring_6.10+ #14
> [ 2833.180110] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc37 04/01/2014
> [ 2833.180692] Workqueue: events io_fallback_req_func
> [ 2833.181042] RIP: 0010:percpu_counter_add_batch+0x19/0x80
> [ 2833.181430] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 41 55 41 54 55 53 9c 58 0f 1f 40 00 49 89 c5 fa 0f 1f 44 00 00 <48> 8b 4f 20 48 63 d2 65 48 63 19 49 89 dc 48 01 f3 48 89 d8 48 f7
> [ 2833.182623] RSP: 0018:ffffb89da07a7dd0 EFLAGS: 00010006
> [ 2833.186362] RAX: 0000000000000206 RBX: ffff97d7d9332ec0 RCX: 0000000000000000
> [ 2833.186825] RDX: 0000000000000020 RSI: ffffffffffffffff RDI: 00000000000000c8
> [ 2833.187326] RBP: 0000000000000000 R08: 0000000000000246 R09: 0000000000020001
> [ 2833.187783] R10: 0000000000020001 R11: 0000000000000032 R12: ffff97d7dee497f0
> [ 2833.188284] R13: 0000000000000206 R14: ffff97d7400e9d00 R15: ffff97d6cd9cc410
> [ 2833.188741] FS:  0000000000000000(0000) GS:ffff97dc27d80000(0000) knlGS:0000000000000000
> [ 2833.189310] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2833.189709] CR2: 00000000000000e8 CR3: 0000000220b30004 CR4: 0000000000770ef0
> [ 2833.190205] PKRU: 55555554
> [ 2833.190418] Call Trace:
> [ 2833.190615]  <TASK>
> [ 2833.190795]  ? __die+0x23/0x70
> [ 2833.191053]  ? page_fault_oops+0x173/0x4f0
> [ 2833.191362]  ? exc_page_fault+0x76/0x150
> [ 2833.191654]  ? asm_exc_page_fault+0x26/0x30
> [ 2833.191968]  ? percpu_counter_add_batch+0x19/0x80
> [ 2833.192313]  io_put_task_remote+0x2a/0x90
> [ 2833.192594]  __io_submit_flush_completions+0x2bd/0x380
> [ 2833.192944]  io_fallback_req_func+0xa3/0x130
> [ 2833.193273]  process_one_work+0x181/0x350
> [ 2833.193550]  worker_thread+0x27e/0x390
> [ 2833.193813]  ? __pfx_worker_thread+0x10/0x10
> [ 2833.194123]  kthread+0xbb/0xf0
> [ 2833.194369]  ? __pfx_kthread+0x10/0x10
> [ 2833.194638]  ret_from_fork+0x31/0x50
> [ 2833.194899]  ? __pfx_kthread+0x10/0x10
> [ 2833.195213]  ret_from_fork_asm+0x1a/0x30
> [ 2833.195484]  </TASK>
> [ 2833.195661] Modules linked in: isofs binfmt_misc vfat fat xfs raid0 iTCO_wdt intel_pmc_bxt iTCO_vendor_support i2c_i801 virtio_net i2c_smbus net_failover failover lpc_ich ublk_drv loop zram nvme nvme_core usb_storage crc32c_intel virtio_scsi virtio_blk fuse qemu_fw_cfg
> [ 2833.197148] CR2: 00000000000000e8
> [ 2833.197400] ---[ end trace 0000000000000000 ]---
> [ 2833.197714] RIP: 0010:percpu_counter_add_batch+0x19/0x80
> [ 2833.198078] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 41 55 41 54 55 53 9c 58 0f 1f 40 00 49 89 c5 fa 0f 1f 44 00 00 <48> 8b 4f 20 48 63 d2 65 48 63 19 49 89 dc 48 01 f3 48 89 d8 48 f7
> [ 2833.199261] RSP: 0018:ffffb89d8b0f7dd0 EFLAGS: 00010006
> [ 2833.199599] RAX: 0000000000000206 RBX: ffff97d77b830000 RCX: 0000000080020001
> [ 2833.200051] RDX: 0000000000000020 RSI: ffffffffffffffff RDI: 00000000000000c8
> [ 2833.200515] RBP: 0000000000000000 R08: ffff97d77b830000 R09: 0000000080020001
> [ 2833.200956] R10: 0000000080020001 R11: 0000000000000016 R12: ffff97d75210c6c0
> [ 2833.201439] R13: 0000000000000206 R14: ffff97d7518f3800 R15: ffff97d6c304bc10
> [ 2833.201894] FS:  0000000000000000(0000) GS:ffff97dc27d80000(0000) knlGS:0000000000000000
> [ 2833.202455] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2833.202832] CR2: 00000000000000e8 CR3: 0000000220b30004 CR4: 0000000000770ef0
> [ 2833.203316] PKRU: 55555554
> [ 2833.203524] note: kworker/11:0[22867] exited with irqs disabled
> 
> 
> Thanks,
> Ming
> 

-- 
Pavel Begunkov

