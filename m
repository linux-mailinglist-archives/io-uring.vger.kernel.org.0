Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0EB32FBE0
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 17:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhCFQ0Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 11:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhCFQZ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 11:25:29 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643AFC06174A
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 08:25:29 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n10so3478532pgl.10
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 08:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rm635SpkGSUVHgxbqNHdfyq6j2luo26U7Mb8pfiWIwM=;
        b=BUbFW+MMBrQ1XcvmNXKBeSYzbx/jwMOZIgJIZbDLEFpqSUB3Qd/4HqDBl/CCRAuKNQ
         bwKZd/+yPoIbrKbB8OE9LVrc2hudrqAzbrQTmwuem6OWVgVGsYD+WLV8ZRCu/e1bbWuX
         KK/vzvllf3xoM7EQ1L/FNppLqpqXJnOfdtoqIwOPgJAqyUqZZz0HvepCmy/qqpTCQyeE
         vIuqcuHwuMUqEQnznkb4L3uMCjVKgg11xBG9edKiPCP0KZNWCiPUyhdcwXL30IspLM09
         e3P2PVAOWe09AI5MII14WKIisLRHczDsH1tUDYT1BNOg4WWvjYPiqG+5XwJXZ/pRvQ1c
         K82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rm635SpkGSUVHgxbqNHdfyq6j2luo26U7Mb8pfiWIwM=;
        b=tUbuQixMzKB0/I6eUY5316DtL6+q73bHE24VA1mTRYkx0eYpBzG3Cmb92jO8s1VDc8
         UWu6UoGVgbA312B5dd1qocuHX35uXjlStNPegmK86CUv5Lqlx70pQbAoaqKW4rVDThwe
         z20gcjiCV98GlPRG1aXLy2sdw8ED9x5HVRTujvmU9shC4HBc3YZvqaTyiaZZgo0lQU7e
         52BV6qxs1NcFg3q6tKGPde6BBH6SAIfPsFQSLwK6CdasKDaUYjynQnkZimHVGpchKTu/
         jnQKcWcb7aHxwJhcORfoURte9cU38+wfkeYuLBcqjtuU0L25ie4+FAtE8vDE9niwZjjd
         +RQg==
X-Gm-Message-State: AOAM530408Peic7CyyjOB3SBeFGnfF9+a7Lo4WfphhcGQhbKWxZwZgYO
        Yfv9sp2eyKUx7AoXfNZctZM/b0u8T/mBiQ==
X-Google-Smtp-Source: ABdhPJzqp3RN8Pcd1Km1E1qkaCyciNVD6Pzsz79Fxkzf3b3OTpdC7CmQgSy1wFI7HjJG8tx3PSJuSw==
X-Received: by 2002:a63:d618:: with SMTP id q24mr13246607pgg.283.1615047928534;
        Sat, 06 Mar 2021 08:25:28 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y8sm6183715pfe.36.2021.03.06.08.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Mar 2021 08:25:27 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc2
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <88ef6732-3800-a563-868d-8c1e5545c8fa@kernel.dk>
 <CAHk-=wjAASE-FhpGqrDoa-u5gktgW0=4q2V9+i7B93HTEf3cbg@mail.gmail.com>
 <7018071c-6f63-1e8c-3874-8ad643bad155@kernel.dk>
 <CAHk-=whjh_cow+gCQMCnS0NdxTqumtCgEDth+QLTjpYpOaOETQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <31785b03-93dd-d204-dcf6-dd6b6546cbb6@kernel.dk>
Date:   Sat, 6 Mar 2021 09:25:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whjh_cow+gCQMCnS0NdxTqumtCgEDth+QLTjpYpOaOETQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/5/21 4:03 PM, Linus Torvalds wrote:
> On Fri, Mar 5, 2021 at 1:58 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> But it pertains to the problem in general, which is how do we handle
>> when the original task sets up a ring and then goes and does
>> unshare(FILES) or whatever. It then submits a new request that just
>> happens to go async, which is oblivious to this fact. Same thing that
>> would happen in userspace if you created a thread pool and then did
>> unshare, and then had your existing threads handle work for you. Except
>> here it just kind of happens implicitly, and I can see how that would be
>> confusing or even problematic.
> 
> Honestly, I'd aim for a "keep a cred per request".  And if that means
> that then the async worker thread has to check that it matches the
> cred it already has, then so be it.

Agree, which is actually not that bad and can be done without having
io-wq deal with it. See below.

> Otherwise, you'll always have odd situations where "synchronous
> completion gets different results than something that was kicked off
> to an async thread".

Exactly, that was my main concern. It violates the principle of least
surprise, and I didn't like it.

> But I don't think this has anything to do with unshare() per se. I
> think this is a generic "hey, the process can change creds between
> ring creation - and thread creation - and submission of an io_ring
> command".
> 
> No? Or am I misunderstanding what you're thinking of?

You're not, but creds is just one part of it. But I think we're OK
saying "If you do unshare(CLONE_FILES) or CLONE_FS, then it's not
going to impact async offload for your io_uring". IOW, you really
should do that before setting up your ring(s).


commit 6169c4a517317ff729553b66d55957bf03912dc4
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sat Mar 6 09:22:27 2021 -0700

    io-wq: always track creds for async issue
    
    If we go async with a request, grab the creds that the task currently has
    assigned and make sure that the async side switches to them. This is
    handled in the same way that we do for registered personalities.
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 5fbf7997149e..1ac2f3248088 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -79,8 +79,8 @@ static inline void wq_list_del(struct io_wq_work_list *list,
 
 struct io_wq_work {
 	struct io_wq_work_node list;
+	const struct cred *creds;
 	unsigned flags;
-	unsigned short personality;
 };
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 92c25b5f1349..d51c6ba9268b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1183,6 +1183,9 @@ static void io_prep_async_work(struct io_kiocb *req)
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (!req->work.creds)
+		req->work.creds = get_current_cred();
+
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
@@ -1648,6 +1651,10 @@ static void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
+	if (req->work.creds) {
+		put_cred(req->work.creds);
+		req->work.creds = NULL;
+	}
 
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
@@ -5916,18 +5923,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	const struct cred *creds = NULL;
 	int ret;
 
-	if (req->work.personality) {
-		const struct cred *new_creds;
-
-		if (!(issue_flags & IO_URING_F_NONBLOCK))
-			mutex_lock(&ctx->uring_lock);
-		new_creds = idr_find(&ctx->personality_idr, req->work.personality);
-		if (!(issue_flags & IO_URING_F_NONBLOCK))
-			mutex_unlock(&ctx->uring_lock);
-		if (!new_creds)
-			return -EINVAL;
-		creds = override_creds(new_creds);
-	}
+	if (req->work.creds && req->work.creds != current_cred())
+		creds = override_creds(req->work.creds);
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
@@ -6291,7 +6288,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 {
 	struct io_submit_state *state;
 	unsigned int sqe_flags;
-	int ret = 0;
+	int personality, ret = 0;
 
 	req->opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
@@ -6324,8 +6321,16 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return -EOPNOTSUPP;
 
 	req->work.list.next = NULL;
+	personality = READ_ONCE(sqe->personality);
+	if (personality) {
+		req->work.creds = idr_find(&ctx->personality_idr, personality);
+		if (!req->work.creds)
+			return -EINVAL;
+		get_cred(req->work.creds);
+	} else {
+		req->work.creds = NULL;
+	}
 	req->work.flags = 0;
-	req->work.personality = READ_ONCE(sqe->personality);
 	state = &ctx->submit_state;
 
 	/*

-- 
Jens Axboe

