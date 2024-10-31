Return-Path: <io-uring+bounces-4267-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15A1B9B7C31
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 14:54:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57851B20EEE
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 13:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3518219DF4A;
	Thu, 31 Oct 2024 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2cnny9S1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D7B19C56F
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 13:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730382865; cv=none; b=lwat+havS8pVba7KJiNbI9ZLu/xQ80rI0PpveaTS5maTMYVnAFnIxAe1KqwmgkTGKDWzdFLSwg1cFAiWN8TlAMbXGycnd2GBl8Rxq8k/V1FmbJXAm0IlVw9n8jAwbeBCoUsjP/BIoLGAlhsVyZe2YlTAe7W8HmqhfSBfRu9SLVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730382865; c=relaxed/simple;
	bh=BcdNO+B1i6XayXfKbuKMWxEl8nqfUbzJtp9PX/+EK4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ADZr+hKVn9wy+ZvaQXRmJnd7rwuCzLHbq0l5e9ZeN+/Z/o9YN0Oe5zkHpYHsVHY7Gno557wdmj4eNRIk6NJXZZ5usvlFJWiT6rMiifsHmxyG5AIlJ6UzCRl7on4l50uFqxTPT3pcNN9TvwuLgj/AcyM0E7wgWRdHcPnS1ZeK1bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2cnny9S1; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83aac75fcceso32048139f.0
        for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 06:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730382861; x=1730987661; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Ozykn063MQ6cJTxtGABB4doGntoFAE1h7Gboqv1VRo=;
        b=2cnny9S1+XNOUNPgLurEed2hf6J+QYatCfm8qHForxudHC+CIe4PZd+elq1sDbwn8j
         V2EoIANu2FjPlIhkHJqyT00y41pM1vl44kp+5h0b3hJgAhEKcYdmNX2+E0ewY8WrAGel
         PTNPAkGRE9IhwmR3+C2BIyHy8biCLWv4hFutOfmJE747vZWJJr/2H/hbpX1BNyoujxt+
         tIgKASCGbz46HFP0d9RCkbSYfe1G4uanLLcsehwgg605Q4gSR/3+xuUMyZybNTDmpe1I
         8nbQMKB6cER23hoqXMdlrLIJo/YSjRtFr8HaHyqR3cTl2aiO/w5HEuou0ImoEIUSefyC
         Zb5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730382861; x=1730987661;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Ozykn063MQ6cJTxtGABB4doGntoFAE1h7Gboqv1VRo=;
        b=mvzKimoxxgBniY/bHG3r8drKUkXEWbxDqQ5si7az1kkNNqH75JbrtJBAfwAOp9yd8v
         iRDTsBKLdmBfXwNsJTWAYrgeQpY4d1efS0APvDh+d7MLHBukEcYyZR9X5dhRfPTbF1sI
         PRyqLdPEIcjAR3BrGbFY6qhacf2TYcldf+vmB6TRrFcI3ayi3WEuG1GsfxbxyyH+4X4J
         xvwo7cLAsgFGd8GTeVa9FFrfeaMSJ5MoDdpQkkjvbkKnRaXmkNKXRozMoKoKGJhjrUpk
         /PzRv72JR/r2sCWIyEc0nczO8xmF8S/egmfVX2anpaTNvnnn9svnv3E2eGYloXS7oXyi
         qKtQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6DkwYsrX4BrNURTwBaqxjIe2jILlOcSLDpx6cPe0UllbBKnKdl+sko1PCru+/EZLcrqhz4ScOaQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YygJeptfiXP4JDF9uG5WJOPUGDfi4CQKg7ZwuJiuga2c+2fPiPP
	b6p+e8XR2MXs6RUv7JByXeMCXtdcyHftAeuJNC3juBudJqL0pFYk2jCRO03YFkLIsIg+PrJFYSf
	iZgg=
X-Google-Smtp-Source: AGHT+IHuIgNYM1EOIIqsTsyCyOpwGGFkgec5hrXe4ft8QGwRusQ1c+GSIyG5htAvlVjSSjfxjH4EhQ==
X-Received: by 2002:a05:6602:2c10:b0:83a:bd82:77f with SMTP id ca18e2360f4ac-83b1c468599mr2219510939f.8.1730382860527;
        Thu, 31 Oct 2024 06:54:20 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de049ba80asm287603173.156.2024.10.31.06.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 06:54:19 -0700 (PDT)
Message-ID: <a9dec476-59ec-49c3-a3bd-8f05ccc61b19@kernel.dk>
Date: Thu, 31 Oct 2024 07:54:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring: fsfreeze deadlocks when performing
 O_DIRECT writes
To: Peter Mann <peter.mann@sh.cz>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org
References: <38c94aec-81c9-4f62-b44e-1d87f5597644@sh.cz>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <38c94aec-81c9-4f62-b44e-1d87f5597644@sh.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/31/24 5:20 AM, Peter Mann wrote:
> Hello,
> 
> it appears that there is a high probability of a deadlock occuring when performing fsfreeze on a filesystem which is currently performing multiple io_uring O_DIRECT writes.
> 
> Steps to reproduce:
> 1. Mount xfs or ext4 filesystem on /mnt
> 
> 2. Start writing to the filesystem. Must use io_uring, direct io and iodepth>1 to reproduce:
> fio --ioengine=io_uring --direct=1 --bs=4k --size=100M --rw=randwrite --loops=100000 --iodepth=32 --name=test --filename=/mnt/fio_test
> 
> 3. Run this in another shell. For me it deadlocks almost immediately:
> while true; do fsfreeze -f /mnt/; echo froze; fsfreeze -u /mnt/; echo unfroze; done
> 
> 4. Fsfreeze and all tasks attempting to write /mnt get stuck:
> At this point all stuck processes cannot be killed by SIGKILL and they are stuck in uninterruptible sleep.
> If you try 'touch /mnt/a' for example, the new process gets stuck in the exact same way as well.
> 
> This gets printed when running 6.11.4 with some debug options enabled:
> [  539.586122] Showing all locks held in the system:
> [  539.612972] 1 lock held by khungtaskd/35:
> [  539.626204]  #0: ffffffffb3b1c100 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x32/0x1e0
> [  539.640561] 1 lock held by dmesg/640:
> [  539.654282]  #0: ffff9fd541a8e0e0 (&user->lock){+.+.}-{3:3}, at: devkmsg_read+0x74/0x2d0
> [  539.669220] 2 locks held by fio/647:
> [  539.684253]  #0: ffff9fd54fe720b0 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x5c2/0x820
> [  539.699565]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: io_issue_sqe+0x9c/0x780
> [  539.715587] 2 locks held by fio/648:
> [  539.732293]  #0: ffff9fd54fe710b0 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x5c2/0x820
> [  539.749121]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: io_issue_sqe+0x9c/0x780
> [  539.765484] 2 locks held by fio/649:
> [  539.781483]  #0: ffff9fd541a8f0b0 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x5c2/0x820
> [  539.798785]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: io_issue_sqe+0x9c/0x780
> [  539.815466] 2 locks held by fio/650:
> [  539.831966]  #0: ffff9fd54fe740b0 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x5c2/0x820
> [  539.849527]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: io_issue_sqe+0x9c/0x780
> [  539.867469] 1 lock held by fsfreeze/696:
> [  539.884565]  #0: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: freeze_super+0x20a/0x600
> 
> I reproduced this bug on nvme, sata ssd, virtio disks and lvm logical volumes.
> It deadlocks on all kernels that I tried (all on amd64):
> 6.12-rc5 (compiled from kernel.org)
> 6.11.4 (compiled from kernel.org)
> 6.10.11-1~bpo12+1 (debian)
> 6.1.0-23 (debian)
> 5.14.0-427.40.1.el9_4.x86_64 (rocky linux)
> 5.10.0-33-amd64 (debian)
> 
> I tried to compile some older ones to check if it's a regression, but
> those either didn't compile or didn't boot in my VM, sorry about that.
> If you have anything specific for me to try, I'm happy to help.
> 
> Found this issue as well, so it seems like it's not just me:
> https://gitlab.com/qemu-project/qemu/-/issues/881
> Note that mariadb 10.6 adds support for io_uring, and that proxmox backups perform fsfreeze in the guest VM.
> 
> Originally I discovered this after a scheduled lvm snapshot of mariadb
> got stuck. It appears that lvm calls dm_suspend, which then calls
> freeze_super, so it looks like the same bug to me. I discovered the
> simpler fsfreeze/fio reproduction method when I tried to find a
> workaround.

Thanks for the report! I'm pretty sure this is due to the freezing not
allowing task_work to run, which prevents completions from being run.
Hence you run into a situation where freezing isn't running the very IO
completions that will free up the rwsem, with IO issue being stuck on
the freeze having started.

I'll take a look...

-- 
Jens Axboe

