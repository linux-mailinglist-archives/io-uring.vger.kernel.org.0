Return-Path: <io-uring+bounces-3922-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 048719AB4CA
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 19:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00FF51C20ED6
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 17:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F1051B654C;
	Tue, 22 Oct 2024 17:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="sUBIDoJR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C543D1BC091
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 17:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729617138; cv=none; b=Pj3JhpjonXm6CZR0Sm6WMdvJd/OppdH++IQQNMWHflIcysmXPZWXFUndPneeZFJhvYP+ZV/3Sak1ZTp0Db2Oi1NOztgHBJrYlDlo8PbAGnVL6WsOGHA0C395W7VjWqLsNvo2foQ3KI80k43tflDrNPih2d/kxNMRPIMdrbS1xuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729617138; c=relaxed/simple;
	bh=CD/215fp71e1dRUdVo+gmQyjkD3aM/yAOZ0utXmpn1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MTgEd/7p3ZxadnkeUhKhn3pwW0sOVLD4nv6jtvcFChz2EDvwJOsuphgSJWvd2084g0sraUc8kYHmE/2vNSJ+zm8ZCiWQZEGhYahxdqTZk8eTwsuPTRGsI9+035jU7XfUDb6TWN6TJG03BzhNS6Js6FzK+UDlqC6HdFmz/Owzsxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=sUBIDoJR; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2e2cc469c62so3970466a91.2
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 10:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729617136; x=1730221936; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Iveg826umfqXx6X66tbF1qMeKncDOTOcDxqr2aRdlsY=;
        b=sUBIDoJRBTzQf0oJnykuSsoHHR5DehRpQGyKI29Sdbu1VZkh3xNSmMRdrc/JHZ7CEg
         nh0Nfjw+ch8Y1iMiA0BngoqNXfOriqAD3onlkteiVAy/Lgs9/WVG/ZwreH/1uaeIQHnl
         r5gWdgTT/nJXTrhvia80ByhtMiHJbzR8Ynn4a2Hy6yKdrZTXJBDlNTfXQJhEz9hCbO94
         5eUynWtpSytcCUJiULVRctkzQoi39tRfgGlJYGBlHai8aeJI7heCkPmlNm6pNy0EQaxM
         CFaxs+zlY2IyFyHvxKCC4VZvIKQz4Wbb59opQ0GAg5eMyRoysyQVLe9uTeSgcFiyQtZf
         0x4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729617136; x=1730221936;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iveg826umfqXx6X66tbF1qMeKncDOTOcDxqr2aRdlsY=;
        b=XeZGHSw5bxmwMHrZ7IFWJeiS6E7Lh9hV/UuEK2rZGtrb8RYCpZEPd6B2GgSiivZJmd
         xCLV8ERaddF9l6BSd/w0ES1xCApy7R9xWJ72OwHTngRWqpkP5LGSVcb4G3VSC0MObnA+
         fkBjtTOBVVROsemwS1ot8LpRgXoba3N03cLd8IGAL0xRWY+uPJep8Ib9cpKoJVqWHgJI
         hnScKd5W05d4pAN2o/mpLyljEOCsJFKd+Yk2bPUqye2UCDIarRxeRVVvzB8nt5Cw+gJ0
         WgkXcZQarY5op7x8lV1pvO/0FX/DdEzb8IPm7ZTqNlxrEgppvBehyVIt4jxtFSJT9ea0
         NGyA==
X-Forwarded-Encrypted: i=1; AJvYcCVAI2Jmsf8ANbINWkzF15X85w2TsSvf+5yzqqy3XJDtQbm+xvd6eS2FkQvx/OcgmO3LZu28eL6j1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWF2tVFjykEDIXFwl1ogSthC3VbIyrJujjoPE2QPwTcb2bJ0FU
	tkfeGkpE5iR5iGnKRi63fLVymh/xlFShoprTz0v674oi4B3fYO/4n8rrv6XPG1Q=
X-Google-Smtp-Source: AGHT+IHFVVrVfIn/32dSsBAfnazoR2rmz+9x5yDJyKq5R3X53SMLPVGxTxa32e8kDXdpRSgtQD5ZEQ==
X-Received: by 2002:a17:90b:4c07:b0:2e2:d3ab:2d77 with SMTP id 98e67ed59e1d1-2e6f721f721mr167703a91.39.1729617135976;
        Tue, 22 Oct 2024 10:12:15 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::4:56f4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad517450sm6430573a91.51.2024.10.22.10.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 10:12:15 -0700 (PDT)
Message-ID: <ab2cab77-b5b9-463c-8f0a-5e298ca2767a@davidwei.uk>
Date: Tue, 22 Oct 2024 10:12:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 00/15] fuse: fuse-over-io-uring
Content-Language: en-GB
To: Bernd Schubert <bernd.schubert@fastmail.fm>,
 Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <38c76d27-1657-4f8c-9875-43839c8bbe80@davidwei.uk>
 <ed03c267-92c1-4431-85b2-d58fd45807be@fastmail.fm>
 <11032431-e58b-4f75-a8b5-cf978ffbfa50@davidwei.uk>
 <baf09fb5-60a6-4aa9-9a6f-0d94ccce6ba4@fastmail.fm>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <baf09fb5-60a6-4aa9-9a6f-0d94ccce6ba4@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024-10-22 03:24, Bernd Schubert wrote:
> 
> 
> On 10/21/24 22:57, David Wei wrote:
>> On 2024-10-21 04:47, Bernd Schubert wrote:
>>> Hi David,
>>>
>>> On 10/21/24 06:06, David Wei wrote:
>>>> [You don't often get email from dw@davidwei.uk. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>>>>
>>>> On 2024-10-15 17:05, Bernd Schubert wrote:
>>>> [...]
>>>>>
>>>
>>> ...
>>>
>>>> Hi Bernd, I applied this patchset to io_uring-6.12 branch with some
>>>> minor conflicts. I'm running the following command:
>>>>
>>>> $ sudo ./build/example/passthrough_hp -o allow_other --debug-fuse --nopassthrough \
>>>> --uring --uring-per-core-queue --uring-fg-depth=1 --uring-bg-depth=1 \
>>>> /home/vmuser/scratch/source /home/vmuser/scratch/dest
>>>> FUSE library version: 3.17.0
>>>> Creating ring per-core-queue=1 sync-depth=1 async-depth=1 arglen=1052672
>>>> dev unique: 2, opcode: INIT (26), nodeid: 0, insize: 104, pid: 0
>>>> INIT: 7.40
>>>> flags=0x73fffffb
>>>> max_readahead=0x00020000
>>>>      INIT: 7.40
>>>>      flags=0x4041f429
>>>>      max_readahead=0x00020000
>>>>      max_write=0x00100000
>>>>      max_background=0
>>>>      congestion_threshold=0
>>>>      time_gran=1
>>>>      unique: 2, success, outsize: 80
>>>>
>>>> I created the source and dest folders which are both empty.
>>>>
>>>> I see the following in dmesg:
>>>>
>>>> [ 2453.197510] uring is disabled
>>>> [ 2453.198525] uring is disabled
>>>> [ 2453.198749] uring is disabled
>>>> ...
>>>>
>>>> If I then try to list the directory /home/vmuser/scratch:
>>>>
>>>> $ ls -l /home/vmuser/scratch
>>>> ls: cannot access 'dest': Software caused connection abort
>>>>
>>>> And passthrough_hp terminates.
>>>>
>>>> My kconfig:
>>>>
>>>> CONFIG_FUSE_FS=m
>>>> CONFIG_FUSE_PASSTHROUGH=y
>>>> CONFIG_FUSE_IO_URING=y
>>>>
>>>> I'll look into it next week but, do you see anything obviously wrong?
>>>
>>>
>>> thanks for testing it! I just pushed a fix to my libfuse branches to
>>> avoid the abort for -EOPNOTSUPP. It will gracefully fall back to
>>> /dev/fuse IO now.
>>>
>>> Could you please use the rfcv4 branch, as the plain uring
>>> branch will soon get incompatible updates for rfc5?
>>>
>>> https://github.com/bsbernd/libfuse/tree/uring-for-rfcv4
>>>
>>>
>>> The short answer to let you enable fuse-io-uring:
>>>
>>> echo 1 >/sys/module/fuse/parameters/enable_uring
>>>
>>>
>>> (With that the "uring is disabled" should be fixed.)
>>
>> Thanks, using this branch fixed the issue and now I can see the dest
>> folder mirroring that of the source folder. There are two issues I
>> noticed:
>>
>> [63490.068211] ---[ end trace 0000000000000000 ]---
>> [64010.242963] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:330
>> [64010.243531] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 11057, name: fuse-ring-1
>> [64010.244092] preempt_count: 1, expected: 0
>> [64010.244346] RCU nest depth: 0, expected: 0
>> [64010.244599] 2 locks held by fuse-ring-1/11057:
>> [64010.244886]  #0: ffff888105db20a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x900/0xd80
>> [64010.245476]  #1: ffff88810f941818 (&fc->lock){+.+.}-{2:2}, at: fuse_uring_cmd+0x83e/0x1890 [fuse]
>> [64010.246031] CPU: 1 UID: 0 PID: 11057 Comm: fuse-ring-1 Tainted: G        W          6.11.0-10089-g0d2090ccdbbe #2
>> [64010.246655] Tainted: [W]=WARN
>> [64010.246853] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
>> [64010.247542] Call Trace:
>> [64010.247705]  <TASK>
>> [64010.247860]  dump_stack_lvl+0xb0/0xd0
>> [64010.248090]  __might_resched+0x2f8/0x510
>> [64010.248338]  __kmalloc_cache_noprof+0x2aa/0x390
>> [64010.248614]  ? lockdep_init_map_type+0x2cb/0x7b0
>> [64010.248923]  ? fuse_uring_cmd+0xcc2/0x1890 [fuse]
>> [64010.249215]  fuse_uring_cmd+0xcc2/0x1890 [fuse]
>> [64010.249506]  io_uring_cmd+0x214/0x500
>> [64010.249745]  io_issue_sqe+0x588/0x1810
>> [64010.249999]  ? __pfx_io_issue_sqe+0x10/0x10
>> [64010.250254]  ? io_alloc_async_data+0x88/0x120
>> [64010.250516]  ? io_alloc_async_data+0x88/0x120
>> [64010.250811]  ? io_uring_cmd_prep+0x2eb/0x9f0
>> [64010.251103]  io_submit_sqes+0x796/0x1f80
>> [64010.251387]  __do_sys_io_uring_enter+0x90a/0xd80
>> [64010.251696]  ? do_user_addr_fault+0x26f/0xb60
>> [64010.251991]  ? __pfx___do_sys_io_uring_enter+0x10/0x10
>> [64010.252333]  ? __up_read+0x3ba/0x750
>> [64010.252565]  ? __pfx___up_read+0x10/0x10
>> [64010.252868]  do_syscall_64+0x68/0x140
>> [64010.253121]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>> [64010.253444] RIP: 0033:0x7f03a03fb7af
>> [64010.253679] Code: 45 0f b6 90 d0 00 00 00 41 8b b8 cc 00 00 00 45 31 c0 41 b9 08 00 00 00 41 83 e2 01 41 c1 e2 04 41 09 c2 b8 aa 01 00 00 0f 05 <c3> a8 02 74 cc f0 48 83 0c 24 00 49 8b 40 20 8b 00 a8 01 74 bc b8
>> [64010.254801] RSP: 002b:00007f039f3ffd08 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
>> [64010.255261] RAX: ffffffffffffffda RBX: 0000561ab7c1ced0 RCX: 00007f03a03fb7af
>> [64010.255695] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000009
>> [64010.256127] RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000008
>> [64010.256556] R10: 0000000000000000 R11: 0000000000000246 R12: 0000561ab7c1d7a8
>> [64010.256990] R13: 0000561ab7c1da00 R14: 0000561ab7c1d520 R15: 0000000000000001
>> [64010.257442]  </TASK>
> 
> Regarding issue one, does this patch solve it?
> 
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index e518d4379aa1..304919bc12fb 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -168,6 +168,12 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>         queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
>         if (!queue)
>                 return ERR_PTR(-ENOMEM);
> +       pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
> +       if (!pq) {
> +               kfree(queue);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
>         spin_lock(&fc->lock);
>         if (ring->queues[qid]) {
>                 spin_unlock(&fc->lock);
> @@ -186,11 +192,6 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>         INIT_LIST_HEAD(&queue->ent_in_userspace);
>         INIT_LIST_HEAD(&queue->fuse_req_queue);
> 
> -       pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
> -       if (!pq) {
> -               kfree(queue);
> -               return ERR_PTR(-ENOMEM);
> -       }
>         queue->fpq.processing = pq;
>         fuse_pqueue_init(&queue->fpq);
> 
> 
> I think we don't need GFP_ATOMIC, but can do allocations before taking
> the lock. This pq allocation is new in v4 and I forgot to put it into
> the right place and it slipped through my very basic testing (I'm
> concentrating on the design changes for now - testing will come back
> with v6).

Thanks, this patch fixed it for me.

> 
>>
>> If I am already in dest when I do the mount using passthrough_hp and
>> then e.g. ls, it hangs indefinitely even if I kill passthrough_hp.
> 
> I'm going to check in a bit. I hope it is not a recursion issue.
> 
> 
> Thanks,
> Bernd

