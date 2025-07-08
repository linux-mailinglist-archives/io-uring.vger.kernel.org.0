Return-Path: <io-uring+bounces-8619-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D591AAFD4D9
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 19:12:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA1D81889788
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 17:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAB22E49A8;
	Tue,  8 Jul 2025 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ChpgXjrT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD362DFF04
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994581; cv=none; b=iSHiTbhK0Pk/XnvEYxduJILWgZyVbcgZzvhsvTer6/HiXe2fpI6ZBpK0t3xyh4WmvnhPseVcHYOeMmqYBoNs7bNeDBhjpOd2uhsNL5q76Cf7MOyOWoF+jMtOHURFkd7DdgqKqikFvWROxn2xgcipi3R4+rcvmqoyOKCeFwviGQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994581; c=relaxed/simple;
	bh=faV15MfmlIdxVLJco81GESOng8jeEiipYPq7KIjfFr0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=KFLRgs2Wt1dF9RGM4sv8TWzZb7i/FjxkKHOeJGIgJt/VC/szogiGkcGm1WL6NTBIjen5U3og9LoLgkjB5Jz9ZkpSv3OeKUa+0ly0jGSYRpcRn0R61cl85CutqJDbi0tEvEWsaeGZ9JIcShCsgIFGxKfem5+NDuht3XfSEqOdABg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ChpgXjrT; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-8762a0866a3so102138439f.2
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 10:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751994577; x=1752599377; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVV+CVMuTfEIYsmAOqgA79niyyAfg9/ac2rHyVWYssA=;
        b=ChpgXjrTsjUzHfsI08hEu2bfgs9V7QNPVFcrQFOoBHtWCLf9E+aqGBSj3mYGlQmN40
         ieNhvP35jk0Dj7MeBBFKRMTXl5Y/ZAN4PEavsAkNOQIicJF0voUoPJblg95BK9OiiY6W
         AMQvs8v1I/t+7wn0WlZRMSQkjIM/8Q9/46XIuOMircLob2/bWFN2caYu8jbvyTlPB85J
         hM9xLlYc1pHGc63t7u+udx/4mF/QTIBMPArp0AM6fpB4V7mjwkQmGQ18m9OUuDSwzgYI
         qWd0P6WkPuk08BR89fWlaDb2vGGPJJmX8iTkxlQgqUVPTNH++aBzhjosS2Z8STw/LhXw
         Fi2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751994577; x=1752599377;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sVV+CVMuTfEIYsmAOqgA79niyyAfg9/ac2rHyVWYssA=;
        b=Ma7M4C/TlvpFMJRR9cH2EDQ+d2B8CuVDqUu7n+UUxGxXFknn15Y2ZWb53fvQ5lNald
         pqyZ12ywL62GZDpz0XS6AfSyg4aurriPISf1wk+xTTHjZbKbo2zJ1eMIMmju70CFSEiW
         iezvGpOQd98Fyk8uwhWUZuUTYwFpH+LXJ9i9VyFlxjpFSGf1r8J9UAm1HLRMbHXGCDwf
         meYtdkAar4vWA66gJI7O/F91FGGv7EjKE35fM11+T/CbenUPlwLqYYF2qd+WYLSXJ+kN
         z1j2Ok8Uz3qDY0fFYMQp9XHvgtMlPn/udpQAKdSW/fzHtTFMBquxRfuXK5oZLjARYUkL
         ZQHg==
X-Gm-Message-State: AOJu0YwNi4JZU4mQcrqev8ydY5hB7LEsCx0ZdTdIj1L4ulqqzRtguj85
	SjdQx3QfTI7QT7WvKI3yfvP7agj5WBDbxqlgdp6wB+bcxtCva84sQcDSHKeJCO9n8mlFJ3TgOeU
	dq2Er
X-Gm-Gg: ASbGncvWqvjBUmwpujf1xjQWVj3irYYQwPN5cGLrqbctAW/2MHqnuq98ZiQVKsEmzm3
	iXcnD1/17dX9C95OD61O2qijhKvRbCn89CWT9xa+m4VnJhBbGUR/BUF3GMLY+gY6KA0IPt6JabZ
	LL7QlR36SQiEWWcNRKHMsHLppyYlSV2GnEgxOscupnoClN848GWo/jyCcuE9isTCK00Z8/fDyq+
	kpwttNBdYI6qJ+Kt5RX9Pqg0YZLdsuRHb7jZFjPvjEy1kkE0LMPKXgb5dANljYqOVgR+PaFkvnt
	O/1P/wrnhuA8RJh+stys1LcBB/m2owxK4oqDzsej3iaO2e6nFStar6QiUw==
X-Google-Smtp-Source: AGHT+IG/4dy16MaUniUvzjwmYu7A4GAbPy9pdkyjWQSegovj/QPIlj4oBaxBk8t2y9WH5w4CTofYsw==
X-Received: by 2002:a05:6e02:b45:b0:3dc:8b57:b76c with SMTP id e9e14a558f8ab-3e16381868amr5452065ab.9.1751994576620;
        Tue, 08 Jul 2025 10:09:36 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-503b599ec2bsm2288095173.19.2025.07.08.10.09.35
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 10:09:36 -0700 (PDT)
Message-ID: <c4dd5328-611b-46a8-8570-6ff37f4d7da6@kernel.dk>
Date: Tue, 8 Jul 2025 11:09:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/msg_ring: ensure io_kiocb freeing is deferred for
 RCU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

syzbot reports that defer/local task_work adding via msg_ring can hit
a request that has been freed:

CPU: 1 UID: 0 PID: 19356 Comm: iou-wrk-19354 Not tainted 6.16.0-rc4-syzkaller-00108-g17bbde2e1716 #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xd2/0x2b0 mm/kasan/report.c:521
 kasan_report+0x118/0x150 mm/kasan/report.c:634
 io_req_local_work_add io_uring/io_uring.c:1184 [inline]
 __io_req_task_work_add+0x589/0x950 io_uring/io_uring.c:1252
 io_msg_remote_post io_uring/msg_ring.c:103 [inline]
 io_msg_data_remote io_uring/msg_ring.c:133 [inline]
 __io_msg_ring_data+0x820/0xaa0 io_uring/msg_ring.c:151
 io_msg_ring_data io_uring/msg_ring.c:173 [inline]
 io_msg_ring+0x134/0xa00 io_uring/msg_ring.c:314
 __io_issue_sqe+0x17e/0x4b0 io_uring/io_uring.c:1739
 io_issue_sqe+0x165/0xfd0 io_uring/io_uring.c:1762
 io_wq_submit_work+0x6e9/0xb90 io_uring/io_uring.c:1874
 io_worker_handle_work+0x7cd/0x1180 io_uring/io-wq.c:642
 io_wq_worker+0x42f/0xeb0 io_uring/io-wq.c:696
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

which is supposed to be safe with how requests are allocated. But msg
ring requests alloc and free on their own, and hence must defer freeing
to a sane time.

Add an rcu_head and use kfree_rcu() in both spots where requests are
freed. Only the one in io_msg_tw_complete() is strictly required as it
has been visible on the other ring, but use it consistently in the other
spot as well.

This should not cause any other issues outside of KASAN rightfully
complaining about it.

Link: https://lore.kernel.org/io-uring/686cd2ea.a00a0220.338033.0007.GAE@google.com/
Reported-by: syzbot+54cbbfb4db9145d26fc2@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Fixes: 0617bb500bfa ("io_uring/msg_ring: improve handling of target CQE posting")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 2922635986f5..a7efcec2e3d0 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -698,6 +698,8 @@ struct io_kiocb {
 		struct hlist_node	hash_node;
 		/* For IOPOLL setup queues, with hybrid polling */
 		u64                     iopoll_start;
+		/* for private io_kiocb freeing */
+		struct rcu_head		rcu_head;
 	};
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 71400d6cefc8..4c2578f2efcb 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -82,7 +82,7 @@ static void io_msg_tw_complete(struct io_kiocb *req, io_tw_token_t tw)
 		spin_unlock(&ctx->msg_lock);
 	}
 	if (req)
-		kmem_cache_free(req_cachep, req);
+		kfree_rcu(req, rcu_head);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -90,7 +90,7 @@ static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			      int res, u32 cflags, u64 user_data)
 {
 	if (!READ_ONCE(ctx->submitter_task)) {
-		kmem_cache_free(req_cachep, req);
+		kfree_rcu(req, rcu_head);
 		return -EOWNERDEAD;
 	}
 	req->opcode = IORING_OP_NOP;

-- 
Jens Axboe


