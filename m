Return-Path: <io-uring+bounces-8218-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5D8ACE21E
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 18:23:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E31601749CD
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 16:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F04118DB0D;
	Wed,  4 Jun 2025 16:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jacUaG1T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A43339A1
	for <io-uring@vger.kernel.org>; Wed,  4 Jun 2025 16:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749054184; cv=none; b=Q3iN3z5QlSdPyORxRD0IXz/GTrFVyOFR8G+r4zgLbNLRrrjghAbKjpp1x7tqG7ibNORx7swbyxhLis7/v+y8asLDQVXkdJfyY45zrJ6MquzSq7I+BoSgU5lbasCHGGUFQQ+6QuXqFPOe+3dF0NeURT+N37IaAZEsKnT0mafDWhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749054184; c=relaxed/simple;
	bh=G8XnbaULPLcDjOyVHPeJKzp/IS+ID1Su416mQKqW7W0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=nkVl084OBG++Isr35N6rfUMxO/YWwYzkE4n0ZCWqMqRPdxX8neoo+Ab/ThBc1DXROVbOImSj8B7zDMbdwS+HiHY5vU4uW0vykgWW0igMkcd8A9MnkDlIJ9PKT2iAHpgDHrJw+FsyJA3oXKSL7+fjgVmXT6zwcwWepszzpa6XCRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jacUaG1T; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-86d0bd7ebb5so98895939f.0
        for <io-uring@vger.kernel.org>; Wed, 04 Jun 2025 09:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749054180; x=1749658980; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XyhIZjH3unPDui+KeHV33K37nxqpfBPoYqjsFZR8JX8=;
        b=jacUaG1T5jV2AHkVd0aVKR+dyP5wPW0UFVk33MpALB/4Tu3TN10qXarAP0mjDvX6h4
         AKzCk5l04rTcKDgvTQO6L0boex2FTcD7XOfEd5q9gF1vQ26ln9wvo0Y7F8vfOa5eETyq
         lJ9sWgIJDPfR4ufabAZiNbSYIuYAmrdeBx0q+bgXNf/IDs49e0gJqGStEBYp4n98dBq4
         75BaNakhpBxN8b+POqBLmsuatTChesAKF1/W6kdw8Wl4yIk4zbHGFM1GhAFdI8/Lajbq
         i83hRYeXR7a7IRhTzXxeiTdwTJpJJnngN/iY8rApGejlg4d6oUP8YlWVOHTLARx0hpCe
         mvCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749054180; x=1749658980;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XyhIZjH3unPDui+KeHV33K37nxqpfBPoYqjsFZR8JX8=;
        b=NOsDJSzAmHeefvXvMMFn103Gl/DGV2kUhq6O2ri1C+VqnsoeKh6uLoNgygauogYSEg
         xiq3vtY23ik57p9mJJFtuOgzr7yGjCAyTn0Yu9dyMjXybRV98CayXIrn9/lao4PAxyWQ
         sVnnXW3FhWMrXmdIqZxHzq8XRTDrvhSb8h6W55iiIRD3C3i37pN8jtNHGVcG1TJnEW2G
         JKNluUAatqmCbtmFxXNLMPZvtJyRftli6qts3xComR0Un86f8NDDk+0N+tzbb+PGhFqg
         DLjfIWI+GaA5AZMDtKHc8TihHyuAWndnAIsLFbO5CJeNGlV2Fs5XDtj3bTxADTOuJ4b8
         y0Iw==
X-Forwarded-Encrypted: i=1; AJvYcCWZqHyTjFFk9NQC58ae+2y6ajDvzK/ViX9oz8lGGsNPosJrhK+hpamFOpNXZ43YOC5WES9JH/X9JQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzcruUpEeSA4ORPIwfFsj3yhHj2z099qOkE1sp8o4Y/8bhl4Na+
	r3FVYe5u+xqHlZuo+thnC9fSR6bQB2pjTsTQ8MnXEeK0SxMQqWnb+MVPySuHGnIgHZ6//2tXKfJ
	LZ/w+
X-Gm-Gg: ASbGncuHmCMYQzaobzJSQpJC78VC52ulwfa1S0+EgD3T/vPkfJF17f0PSoH1zg/+da9
	XZKZb9FsNzan3luiO1BN8PUMamjPubXAgafTbfjr6agVwRbuhYXNLgqJcMIeIt83LHNFXvVpMTo
	WNEi/Jg6F7iOtcBxR195TB2GYFyGwIiYldhzRytEdec/PErOUyQrvJ1Km34mo+qOqjnvmHiQE3n
	8AiGTaajc43I5Cq6qGXpO1vI7VUmyL4tFVa9MAzOk5yAV2xkuJxnagm+ZkgkLvYfmfqPbiQEhi9
	loPIXpjTYpk82bCc/buSkrhOPnk9uPD29/MTtEQfWSNlqW8=
X-Google-Smtp-Source: AGHT+IEeW++KBiAGsLPKE+7TlkP5jKjZdBC0hfRWiZg2lDDnNdULaJYHOYOwjNyrMkf5wreZqo7f5Q==
X-Received: by 2002:a05:6602:3787:b0:86d:71:d9a with SMTP id ca18e2360f4ac-8731c4e6870mr467014739f.2.1749054179775;
        Wed, 04 Jun 2025 09:22:59 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7f22014sm2817370173.136.2025.06.04.09.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 09:22:59 -0700 (PDT)
Message-ID: <6b5b368b-310b-41ca-9ce8-cb54e6c5b8f3@kernel.dk>
Date: Wed, 4 Jun 2025 10:22:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: use-after-free if killed while in IORING_OP_FUTEX_WAIT
From: Jens Axboe <axboe@kernel.dk>
To: rtm@csail.mit.edu, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
References: <38053.1749045482@localhost>
 <83793604-3f0e-4496-a7c2-75f318219bee@kernel.dk>
Content-Language: en-US
In-Reply-To: <83793604-3f0e-4496-a7c2-75f318219bee@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/4/25 8:12 AM, Jens Axboe wrote:
> On 6/4/25 7:58 AM, rtm@csail.mit.edu wrote:
>> If a process is killed while in IORING_OP_FUTEX_WAIT, do_exit()'s call
>> to exit_mm() causes the futex_private_hash to be freed, along with its
>> buckets' locks, while the iouring request still exists. When (a little
>> later in do_exit()) the iouring fd is fput(), the resulting
>> futex_unqueue() tries to use the freed memory that
>> req->async_data->lock_ptr points to.
>>
>> I've attached a demo:
>>
>> # cc uring46b.c
>> # ./a.out
>> killing child
>> BUG: spinlock bad magic on CPU#0, kworker/u4:1/26
>> Unable to handle kernel paging request at virtual address 6b6b6b6b6b6b711b
>> Current kworker/u4:1 pgtable: 4K pagesize, 39-bit VAs, pgdp=0x000000008202a000
>> [6b6b6b6b6b6b711b] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
>> Oops [#1]
>> Modules linked in:
>> CPU: 0 UID: 0 PID: 26 Comm: kworker/u4:1 Not tainted 6.15.0-11192-ga82d78bc13a8 #553 NONE 
>> Hardware name: riscv-virtio,qemu (DT)
>> Workqueue: iou_exit io_ring_exit_work
>> epc : spin_dump+0x38/0x6e
>>  ra : spin_dump+0x30/0x6e
>> epc : ffffffff80003354 ra : ffffffff8000334c sp : ffffffc600113b60
>> ...
>> status: 0000000200000120 badaddr: 6b6b6b6b6b6b711b cause: 000000000000000d
>> [<ffffffff80003354>] spin_dump+0x38/0x6e
>> [<ffffffff8009b78a>] do_raw_spin_lock+0x10a/0x126
>> [<ffffffff811e6552>] _raw_spin_lock+0x1a/0x22
>> [<ffffffff800eb80c>] futex_unqueue+0x2a/0x76
>> [<ffffffff8069e366>] __io_futex_cancel+0x72/0x88
>> [<ffffffff806982fe>] io_cancel_remove_all+0x50/0x74
>> [<ffffffff8069e4ac>] io_futex_remove_all+0x1a/0x22
>> [<ffffffff80010a7e>] io_uring_try_cancel_requests+0x2e2/0x36e
>> [<ffffffff80010bf6>] io_ring_exit_work+0xec/0x3f0
>> [<ffffffff80057f0a>] process_one_work+0x132/0x2fe
>> [<ffffffff8005888c>] worker_thread+0x21e/0x2fe
>> [<ffffffff80060428>] kthread+0xe8/0x1ba
>> [<ffffffff80022fb0>] ret_from_fork_kernel+0xe/0x5e
>> [<ffffffff811e8566>] ret_from_fork_kernel_asm+0x16/0x18
>> Code: 4517 018b 0513 ca05 00ef 3b60 2603 0049 2601 c491 (a703) 5b04 
>> ---[ end trace 0000000000000000 ]---
>> Kernel panic - not syncing: Fatal exception
>> ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> Thanks, I'll take a look!

I think this would be the least intrusive fix, and also avoid fiddling
with mmget() for the PRIVATE case. I'll write a test case for this and
send it out as a real patch.


diff --git a/io_uring/futex.c b/io_uring/futex.c
index 383e0d99ad27..246bfb862db9 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -148,6 +148,8 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	    !futex_validate_input(iof->futex_flags, iof->futex_mask))
 		return -EINVAL;
 
+	/* Mark as inflight, so file exit cancelation will find it */
+	io_req_track_inflight(req);
 	return 0;
 }
 
@@ -194,6 +196,8 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 	}
 
+	/* Mark as inflight, so file exit cancelation will find it */
+	io_req_track_inflight(req);
 	iof->futexv_unqueued = 0;
 	req->flags |= REQ_F_ASYNC_DATA;
 	req->async_data = ifd;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c7a9cecf528e..cf759c172083 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -408,7 +408,12 @@ static void io_clean_op(struct io_kiocb *req)
 	req->flags &= ~IO_REQ_CLEAN_FLAGS;
 }
 
-static inline void io_req_track_inflight(struct io_kiocb *req)
+/*
+ * Mark the request as inflight, so that file cancelation will find it.
+ * Can be used if the file is an io_uring instance, or if the request itself
+ * relies on ->mm being alive for the duration of the request.
+ */
+inline void io_req_track_inflight(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_INFLIGHT)) {
 		req->flags |= REQ_F_INFLIGHT;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0ea7a435d1de..d59c12277d58 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -83,6 +83,7 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
+void io_req_track_inflight(struct io_kiocb *req);
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);

-- 
Jens Axboe

