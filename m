Return-Path: <io-uring+bounces-4268-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BBE99B7C45
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 15:02:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B640B20FEF
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 14:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B69635A4C1;
	Thu, 31 Oct 2024 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Noiahi4J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4BA7483
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 14:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730383333; cv=none; b=OvcDqP9szRM3KGfEm59XJMDpLhhV2u1bFyTrtf3jFJdmgR6+vyYBHSvdB9qPRfIoTLDzHNqSVZrTyY1wf0Kwtpv/A7unSwj3qEQY+Z/OCACaNQVEMTxg0RGQeVy/ZJmcHe/TZ4W0QjT7xo9AkLt/xHNjEZ71jD3vH6sFZq8ilZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730383333; c=relaxed/simple;
	bh=iqIucFPBSmpYcbWVsWQxpZn2q4iqZ3jrpjfFEMlgvQg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Zem1ztTqMjCoQ2bMmPyH9NHnEOCoe6gQSH/xlDT7iMBk4KzBoz65pRj+aaJljERRpZKogzJhSSRPq4lAtlNDAWZCRiCAy5WVlhWBMeY/lxSYCMbzsS/8hzbFUR8dDSHf6TB6cxv75LRpSEEZW5SfRH0gokEEHmakLOD3QpJJx/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Noiahi4J; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3a4e5e574b6so3147695ab.0
        for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 07:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730383328; x=1730988128; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lXykJ3n6Tbslm8cjmmOvJ7f2O2zxtrTW1k45GJRYKf4=;
        b=Noiahi4Jaf10jazZweMnK7xdVI4Hqq/GmCKKo+amuaqKAuDV95JIsJ99MVCOb2GiGE
         NxM2L1gDaCRDorm5A5WiW3jevKY8cSaQQwaOvMcn5B2qKvuBK/HDlTbdk95xd2jPVJgk
         FnN2lAgY3ur+8qjPqriiMQ+4Ds8VkMuRvkbpV0iSHEnHE40som+M6b8jNSDyhfNZxlJI
         x3RMWH1+oltsotNiwDndOaLFi1f9/6tkk8diXqSYvi9dKA2/hSiQSU8guNSqa2ww8JOv
         +Lw8BGX2DzcFBWOaFyrD9h2j/5qUVBNpGAykt1R/9RhcsqDmRqym5PWxDlLYu2RE88R4
         bOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730383328; x=1730988128;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lXykJ3n6Tbslm8cjmmOvJ7f2O2zxtrTW1k45GJRYKf4=;
        b=ENpkPi7roByT3L0t66i7CCSj99UK5n1X+b0JzecvSF0ws9DBWo7VEBYLbZRgM4cW1E
         FaJTWCl/JoR6oXGfBiP/96QE+J2hFzl9Sr2GMcyP0yvSAOBEZ2ppTN1zi+GtkaIXKH3Q
         ikuxHYiz2FR0eql6kUkvJghBWyM7TLLw10gkgebAhmNQicViI8JR9Htu6tWDn3eoDP7R
         I9rU/WOTJhm87d/VhGkTNNIl4jRVZAqgmmsOTzcX1VpuHTCli9fTf6NmIYWpFIU3K7mm
         U1iT5gREzLeY0hBnyw8XFey7wwjivMto998KLbTqiOFumepRES/VqLI7gJSMI2ITfH0o
         Drqw==
X-Forwarded-Encrypted: i=1; AJvYcCV9GDtvQHT4KokOdbiRh4RHchuhUUm0BJ0ooNlBAtmGZYverEbLp0D17qDkWIIledIPx9TiTKEw5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzsu2+CfABEPg99nuKPylA3p4w6fLHhcH+3frg17bVUSFhTcbwo
	LRemPDtgbmFlRFcMGkzK0N+F17N7o2IFVVGTR9zKDP6bDloVKCp/pMGJShh88oP/fvdNPDdhtXG
	qnbs=
X-Google-Smtp-Source: AGHT+IGxiceUmr4mOPKm2yz+T//zzL8s/3UBGKyIeG7LwgZsMpZ0Ep84dfa7bwRaXv3QBfO8MJa38w==
X-Received: by 2002:a05:6e02:1387:b0:3a0:c8b8:1b0f with SMTP id e9e14a558f8ab-3a6afeb07f8mr814265ab.2.1730383328023;
        Thu, 31 Oct 2024 07:02:08 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de048881b6sm305279173.4.2024.10.31.07.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 07:02:07 -0700 (PDT)
Message-ID: <3c27875c-f58b-4beb-b24a-7d248292280b@kernel.dk>
Date: Thu, 31 Oct 2024 08:02:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring: fsfreeze deadlocks when performing
 O_DIRECT writes
From: Jens Axboe <axboe@kernel.dk>
To: Peter Mann <peter.mann@sh.cz>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org
References: <38c94aec-81c9-4f62-b44e-1d87f5597644@sh.cz>
 <a9dec476-59ec-49c3-a3bd-8f05ccc61b19@kernel.dk>
Content-Language: en-US
In-Reply-To: <a9dec476-59ec-49c3-a3bd-8f05ccc61b19@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/31/24 7:54 AM, Jens Axboe wrote:
> On 10/31/24 5:20 AM, Peter Mann wrote:
>> Hello,
>>
>> it appears that there is a high probability of a deadlock occuring when performing fsfreeze on a filesystem which is currently performing multiple io_uring O_DIRECT writes.
>>
>> Steps to reproduce:
>> 1. Mount xfs or ext4 filesystem on /mnt
>>
>> 2. Start writing to the filesystem. Must use io_uring, direct io and iodepth>1 to reproduce:
>> fio --ioengine=io_uring --direct=1 --bs=4k --size=100M --rw=randwrite --loops=100000 --iodepth=32 --name=test --filename=/mnt/fio_test
>>
>> 3. Run this in another shell. For me it deadlocks almost immediately:
>> while true; do fsfreeze -f /mnt/; echo froze; fsfreeze -u /mnt/; echo unfroze; done
>>
>> 4. Fsfreeze and all tasks attempting to write /mnt get stuck:
>> At this point all stuck processes cannot be killed by SIGKILL and they are stuck in uninterruptible sleep.
>> If you try 'touch /mnt/a' for example, the new process gets stuck in the exact same way as well.
>>
>> This gets printed when running 6.11.4 with some debug options enabled:
>> [  539.586122] Showing all locks held in the system:
>> [  539.612972] 1 lock held by khungtaskd/35:
>> [  539.626204]  #0: ffffffffb3b1c100 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x32/0x1e0
>> [  539.640561] 1 lock held by dmesg/640:
>> [  539.654282]  #0: ffff9fd541a8e0e0 (&user->lock){+.+.}-{3:3}, at: devkmsg_read+0x74/0x2d0
>> [  539.669220] 2 locks held by fio/647:
>> [  539.684253]  #0: ffff9fd54fe720b0 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x5c2/0x820
>> [  539.699565]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: io_issue_sqe+0x9c/0x780
>> [  539.715587] 2 locks held by fio/648:
>> [  539.732293]  #0: ffff9fd54fe710b0 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x5c2/0x820
>> [  539.749121]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: io_issue_sqe+0x9c/0x780
>> [  539.765484] 2 locks held by fio/649:
>> [  539.781483]  #0: ffff9fd541a8f0b0 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x5c2/0x820
>> [  539.798785]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: io_issue_sqe+0x9c/0x780
>> [  539.815466] 2 locks held by fio/650:
>> [  539.831966]  #0: ffff9fd54fe740b0 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x5c2/0x820
>> [  539.849527]  #1: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: io_issue_sqe+0x9c/0x780
>> [  539.867469] 1 lock held by fsfreeze/696:
>> [  539.884565]  #0: ffff9fd541a8d450 (sb_writers#15){++++}-{0:0}, at: freeze_super+0x20a/0x600
>>
>> I reproduced this bug on nvme, sata ssd, virtio disks and lvm logical volumes.
>> It deadlocks on all kernels that I tried (all on amd64):
>> 6.12-rc5 (compiled from kernel.org)
>> 6.11.4 (compiled from kernel.org)
>> 6.10.11-1~bpo12+1 (debian)
>> 6.1.0-23 (debian)
>> 5.14.0-427.40.1.el9_4.x86_64 (rocky linux)
>> 5.10.0-33-amd64 (debian)
>>
>> I tried to compile some older ones to check if it's a regression, but
>> those either didn't compile or didn't boot in my VM, sorry about that.
>> If you have anything specific for me to try, I'm happy to help.
>>
>> Found this issue as well, so it seems like it's not just me:
>> https://gitlab.com/qemu-project/qemu/-/issues/881
>> Note that mariadb 10.6 adds support for io_uring, and that proxmox backups perform fsfreeze in the guest VM.
>>
>> Originally I discovered this after a scheduled lvm snapshot of mariadb
>> got stuck. It appears that lvm calls dm_suspend, which then calls
>> freeze_super, so it looks like the same bug to me. I discovered the
>> simpler fsfreeze/fio reproduction method when I tried to find a
>> workaround.
> 
> Thanks for the report! I'm pretty sure this is due to the freezing not
> allowing task_work to run, which prevents completions from being run.
> Hence you run into a situation where freezing isn't running the very IO
> completions that will free up the rwsem, with IO issue being stuck on
> the freeze having started.
> 
> I'll take a look...

Can you try the below? Probably easiest on 6.12-rc5 as you already
tested that and should apply directly.

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 30448f343c7f..ea057ec4365f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1013,6 +1013,18 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+static bool io_kiocb_start_write(struct io_kiocb *req, struct kiocb *kiocb)
+{
+	if (!(req->flags & REQ_F_ISREG))
+		return true;
+	if (!(kiocb->ki_flags & IOCB_NOWAIT)) {
+		kiocb_start_write(kiocb);
+		return true;
+	}
+
+	return sb_start_write_trylock(file_inode(kiocb->ki_filp)->i_sb);
+}
+
 int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@ -1050,8 +1062,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	if (req->flags & REQ_F_ISREG)
-		kiocb_start_write(kiocb);
+	if (unlikely(!io_kiocb_start_write(req, kiocb)))
+		return -EAGAIN;
 	kiocb->ki_flags |= IOCB_WRITE;
 
 	if (likely(req->file->f_op->write_iter))

-- 
Jens Axboe

