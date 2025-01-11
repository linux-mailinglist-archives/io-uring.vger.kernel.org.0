Return-Path: <io-uring+bounces-5826-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A45C7A0A4FD
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 18:13:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C77F07A3FFD
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 17:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6A782899;
	Sat, 11 Jan 2025 17:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="x2Hhs0WN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C997D1B0434
	for <io-uring@vger.kernel.org>; Sat, 11 Jan 2025 17:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736615613; cv=none; b=l/nEsvbdSYvojcRdDmWsdHVzhvR4OKpota/qgnoTEPNsuSUptiMtgV3hAMTfu3a41eUCpmZBLBRACo/+vNQUU4a4owC6dHuv95z1KEa46HW3SSDW5fplSav525qiAdcpAXpqni3r+0bKj9TSZiTDCCdyT5l9dHrfx3wciO1GrPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736615613; c=relaxed/simple;
	bh=Y5I5xriQYkNGu1XOEpx/Wlt2HL8e217AlkrDQV88ru0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PJdvTwZBPlF0yc24BvvX1EN8/P8KxNqxv7IMh8efeXSbb86nR+I6csin77uUxRS21SS+RXcxZPDBQaaKI/xL/EOhzZ+o18Smn/Pzlsi0KxuJDXHavgoj2Wrp5ll3XABaSC5WewHe5tos++mbhfb3dZBzS/Zutant/iy7CEbH0BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=x2Hhs0WN; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a7d7db4d89so8158235ab.1
        for <io-uring@vger.kernel.org>; Sat, 11 Jan 2025 09:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736615610; x=1737220410; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=13wRVL7KEosFoUltuJxgalOKpK0wh1iDPfX2pTWsuFU=;
        b=x2Hhs0WNXHCsVl7aaFH40dswKxsh6rAIyxo/h8+g6112aw9gHBLwPrBknEARZC/2CC
         im3yVFPMEKp5pcQV6waoR257AG1cQiwOge9lWdvqmCRhUEI5vo4kFGvUjyEICMj+nkLs
         k36RTG7dSPfBMZgnCQigweclgZ9bNAxR6DSnHSyKfrE+viGX9iV7OuVu0XlPG4KesDIQ
         Bh+QChO7wE1N1/OHqix/4h50z6cPs3CIvBqB7gH12yzl73RQe6qYOxXAchg/88gpmbtW
         zZ70KmVXWW838KGhdahowZ2r6GNzRY96ZFRjbb0KWwNOaLjEE7adJvVdCV9QGQLus9zM
         0fyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736615610; x=1737220410;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=13wRVL7KEosFoUltuJxgalOKpK0wh1iDPfX2pTWsuFU=;
        b=m8VtQFRj3Nl99cyujiF7yGlDKVVCp3D3R4VLLSjRCgSGfcTncED4JBpwbH81RjkIOx
         uTxT0abkwnJfV1leQbmlj7Ng3/UIPWrNjqwL9Zv0wmrBx1hgitBZRz/6QaZPqcrwlMYm
         bett9vgvL5v52mqWkscsY1NNEH0tM0nPUqrNu/hfTyw0pS6TB2Iq12vzLNHgjtWg//AU
         6Y6Tyozola0OuTwwusUXYHxCXsynScDB942O8VHhszMtOv+uoMqU8GqJ0E2ubNrJ6dI9
         GkSKE6BG2H7qUj4BwafETJ1IfOkbJrWNuWNGizmoyAJwKFR5AFeP99AvxbRwUAfSkJg4
         0zPg==
X-Forwarded-Encrypted: i=1; AJvYcCU8DhNzpAB2Ued5bA86b03+OxsZziIMT3EUllCLSg1wDTayWOZ4/uEYiAys/YJ9Jig1wGOAqnKuDg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwazFCDSiTmbbbYYLxdeL9pzyu3c1MvFOhECFB5wGAnxY0bB62x
	iinod7AL2Nj5Na8E0oSwkalneBNnSVtKImPy6B1XCWgK1M7b5WUidnmvlvJClX0=
X-Gm-Gg: ASbGncvrSFY6BKnDz+9Dbpkh+FDeyJLQk+fUL5imhGr8djjawiC0bDu0IOvL/PmMieF
	GLZaItlPG1t5QIl0lNHEjHkHABwivMytulcfLpWWBupdrecaCBuijmyb6zKJrvY/xbTzxiHY1HT
	Eys10t586UySAoYrOX8ruWAAG2tnTNnbc1rnl+qZnhmQygbqBRAlVcCJPKGbQ5x3lDipwwlqmMN
	td1TEDi4L7772PJP0m4yHfUY+8d6awRrahA9Cp689/lPE/3Vr8gyA==
X-Google-Smtp-Source: AGHT+IHP/+hGbJNpPnxlx015MgPQiN8BfKT/LG9q9pupep1bill8Yff4SsXTHFlg640r51IYmFiraA==
X-Received: by 2002:a05:6e02:1353:b0:3ce:647f:82b2 with SMTP id e9e14a558f8ab-3ce647f8622mr15829615ab.16.1736615609886;
        Sat, 11 Jan 2025 09:13:29 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce4af565cdsm16382015ab.59.2025.01.11.09.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2025 09:13:29 -0800 (PST)
Message-ID: <98125b67-7b63-427f-b822-a12779d50a13@kernel.dk>
Date: Sat, 11 Jan 2025 10:13:28 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: KASAN reported an error while executing accept-reust.t testcase
To: lizetao <lizetao1@huawei.com>, io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <ec2a6ca08c614c10853fbb1270296ac4@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ec2a6ca08c614c10853fbb1270296ac4@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/11/25 7:07 AM, lizetao wrote:
> Hi all,
> 
> When I run the testcase liburing/accept-reust.t with CONFIG_KASAN=y and CONFIG_KASAN_EXTRA_INFO=y, I got
> a error reported by KASAN:

Looks more like you get KASAN crashing...

> Unable to handle kernel paging request at virtual address 00000c6455008008
> Mem abort info:
>   ESR = 0x0000000096000004
>   EC = 0x25: DABT (current EL), IL = 32 bits
>   SET = 0, FnV = 0
>   EA = 0, S1PTW = 0
>   FSC = 0x04: level 0 translation fault
> Data abort info:
>   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
>   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> user pgtable: 4k pages, 48-bit VAs, pgdp=00000001104c5000
> [00000c6455008008] pgd=0000000000000000, p4d=0000000000000000
> Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 6 UID: 0 PID: 352 Comm: kworker/u128:5 Not tainted 6.13.0-rc6-g0a2cb793507d #5
> Hardware name: linux,dummy-virt (DT)
> Workqueue: iou_exit io_ring_exit_work
> pstate: 10000005 (nzcV daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __kasan_mempool_unpoison_object+0x38/0x170
> lr : io_netmsg_cache_free+0x8c/0x180
> sp : ffff800083297a90
> x29: ffff800083297a90 x28: ffffd4d7f67e88e4 x27: 0000000000000003
> x26: 1fffe5958011502e x25: ffff2cabff976c18 x24: 1fffe5957ff2ed83
> x23: ffff2cabff976c10 x22: 00000c6455008000 x21: 0002992540200001
> x20: 0000000000000000 x19: 00000c6455008000 x18: 00000000489683f8
> x17: ffffd4d7f68006ac x16: ffffd4d7f67eb3e0 x15: ffffd4d7f67e88e4
> x14: ffffd4d7f766deac x13: ffffd4d7f6619030 x12: ffff7a9b012e3e26
> x11: 1ffffa9b012e3e25 x10: ffff7a9b012e3e25 x9 : ffffd4d7f766debc
> x8 : ffffd4d80971f128 x7 : 0000000000000001 x6 : 00008564fed1c1db
> x5 : ffffd4d80971f128 x4 : ffff7a9b012e3e26 x3 : ffff2cabff976c00
> x2 : ffffc1ffc0000000 x1 : 0000000000000000 x0 : 0002992540200001
> Call trace:
>  __kasan_mempool_unpoison_object+0x38/0x170 (P)
>  io_netmsg_cache_free+0x8c/0x180
>  io_ring_exit_work+0xd4c/0x13a0
>  process_one_work+0x52c/0x1000
>  worker_thread+0x830/0xdc0
>  kthread+0x2bc/0x348
>  ret_from_fork+0x10/0x20
> Code: aa0003f5 aa0103f4 8b131853 aa1303f6 (f9400662) 
> ---[ end trace 0000000000000000 ]---
> 
> 
> I preliminary analyzed the accept and connect code logic. In the
> accept-reuse.t testcase, kmsg->free_iov is not used, so when calling
> io_netmsg_cache_free(), the
> kasan_mempool_unpoison_object(kmsg->free_iov...) path should not be
> executed.
> 
> 
> I used the hardware watchpoint to capture the first scene of modifying kmsg->free_iov:
> 
> Thread 3 hit Hardware watchpoint 7: *0xffff0000ebfc5410
> Old value = 0
> New value = -211812350
> kasan_set_track (stack=<optimized out>, track=<optimized out>) at ./arch/arm64/include/asm/current.h:21
> 21		return (struct task_struct *)sp_el0;
> 
> # bt
> kasan_set_track
> kasan_save_track
> kasan_save_free_info
> poison_slab_object
> __kasan_mempool_poison_object
> kasan_mempool_poison_object
> io_alloc_cache_put
> io_netmsg_recycle
> io_req_msg_cleanup
> io_connect
> io_issue_sqe
> io_queue_sqe
> io_req_task_submit
> ...
> 
> 
> It's a bit strange. It was modified by KASAN. I can't understand this.
> Maybe I missed something? Please let me know. Thanks.

Looks like KASAN with the extra info ends up writing to
io_async_msghdr->free_iov somehow. No idea... For the test case in
question, ->free_iov should be NULL when initially allocated, and the
io_uring code isn't storing to it. Yet it's non-NULL when you later go
and free it, after calling kasan_mempool_poison_object().

-- 
Jens Axboe

