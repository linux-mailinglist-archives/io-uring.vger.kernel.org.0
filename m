Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0200A247D30
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 06:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgHREMv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Aug 2020 00:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgHREMt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Aug 2020 00:12:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46460C061389
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 21:12:49 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k13so8588483plk.13
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 21:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=FF1luMLwILdO+hBkT/uURzAq/eAoqD6iKf8nVWmi3xw=;
        b=IAmYecNA2FKgu1l57poGKouPHmXcchqwfp0UKxYRhADQgrEI82mi1zsyZxtxqlUwCY
         H6rlBIUzYJsuJPvV7foaTmvjXeRQbc6yNtUWbTO/Z4vv2AHmWNjDtErngYnoDjydqd07
         MDx/gpw7nbqEk9jgrpO0JIdIH9ipTd4F3V+WG0hLGgEcDGaHLq2yIAPuuiTS3FUR788Z
         s5egfTVdYel83So/9N9VmEu5Jv2PWtKyNHkRqJQEtuhUa08gN5efWbiLyPxh8w/zkX8X
         /cd5qcY+kpbClTcegbsmVUyF7YdeEOhsdhxHheDV635StthM1jk3kItgyyWydAZt2pQm
         e6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=FF1luMLwILdO+hBkT/uURzAq/eAoqD6iKf8nVWmi3xw=;
        b=CpkogrosiuAgEfj1e3KBLY+5BrYtfJX5bqrsyw9eadciXbPRYf6c9IfESeYgu1UqlV
         WvlPwlqbq4bkUWFqditD8rSrjBZzMrJW6I3+WjCGwyOAx02ZNl1NeCplWPrMgbItlqix
         jso32igi1mC5fYsMWNyf3tNX20b97DA+gyYOdUpBy+5pAo4SO/vICU2/Rh/031Ll/aH4
         O7yY+qyPhltvm5HNJXTxE4B06iYhf/oh0PCif6DHhHXXsQQtPVGkY+FpLOIKZ90trp+C
         Jrj1iQNwcq4PjdwiGpnMUeMk6p5F1TQBrus2Xs0uIb622KXsp/inNz6StkPcMifGgq8v
         X9SA==
X-Gm-Message-State: AOAM5320LYKoPL6G9P7Jr4ejTkY8fwrxMAI+C/cwBaVpJCbRYfbv6CKJ
        KwTUsgqK/oeffBuydkyND/fqLE3NDH5cOJtWRFc=
X-Google-Smtp-Source: ABdhPJyRBzp8r0qDOy/Uj0Gt8AwelxVax4EuZ32xq5MzcaTSIgYD7IT0SFZLCJFoXZXN9Nu5HrPD5A==
X-Received: by 2002:a17:90a:25a9:: with SMTP id k38mr14943207pje.103.1597723968717;
        Mon, 17 Aug 2020 21:12:48 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:cef9:e56c:5fb2:d956? ([2605:e000:100e:8c61:cef9:e56c:5fb2:d956])
        by smtp.gmail.com with ESMTPSA id a19sm22326707pfn.10.2020.08.17.21.12.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 21:12:47 -0700 (PDT)
Subject: Re: [PATCHSET v2 0/2] io_uring: handle short reads internally
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     david@fromorbit.com, jmoyer@redhat.com
References: <20200814195449.533153-1-axboe@kernel.dk>
 <4c79f6b2-552c-f404-8298-33beaceb9768@samba.org>
 <8beb2687-5cc3-a76a-0f31-dcfa9fc4b84b@kernel.dk>
Message-ID: <97c2c3ab-d25b-e6bb-e8aa-a551edecc7b5@kernel.dk>
Date:   Mon, 17 Aug 2020 21:12:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8beb2687-5cc3-a76a-0f31-dcfa9fc4b84b@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------1F1AEF70B20F832BA30218F2"
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------1F1AEF70B20F832BA30218F2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 8/17/20 8:29 PM, Jens Axboe wrote:
> On 8/17/20 2:25 AM, Stefan Metzmacher wrote:
>> Hi Jens,
>>
>>> Since we've had a few cases of applications not dealing with this
>>> appopriately, I believe the safest course of action is to ensure that
>>> we don't return short reads when we really don't have to.
>>>
>>> The first patch is just a prep patch that retains iov_iter state over
>>> retries, while the second one actually enables just doing retries if
>>> we get a short read back.
>>>
>>> This passes all my testing, both liburing regression tests but also
>>> tests that explicitly trigger internal short reads and hence retry
>>> based on current state. No short reads are passed back to the
>>> application.
>>
>> Thanks! I was going to ask about exactly that :-)
>>
>> It wasn't clear why returning short reads were justified by resulting
>> in better performance... As it means the application needs to do
>> a lot more work and syscalls.
> 
> It mostly boils down to figuring out a good way to do it. With the
> task_work based retry, the async buffered reads, we're almost there and
> the prep patch adds the last remaining bits to retain the iov_iter state
> across issues.
> 
>> Will this be backported?
> 
> I can, but not really in an efficient manner. It depends on the async
> buffered work to make progress, and the task_work handling retry. The
> latter means it's 5.7+, while the former is only in 5.9+...
> 
> We can make it work for earlier kernels by just using the thread offload
> for that, and that may be worth doing. That would enable it in
> 5.7-stable and 5.8-stable. For that, you just need these two patches.
> Patch 1 would work as-is, while patch 2 would need a small bit of
> massaging since io_read() doesn't have the retry parts.
> 
> I'll give it a whirl just out of curiosity, then we can debate it after
> that.

Here are the two patches against latest 5.7-stable (the rc branch, as
we had quite a few queued up after 5.9-rc1). Totally untested, just
wanted to see if it was doable.

First patch is mostly just applied, with various bits removed that we
don't have in 5.7. The second patch just does -EAGAIN punt for the
short read case, which will queue the remainder with io-wq for
async execution.

Obviously needs quite a bit of testing before it can go anywhere else,
but wanted to throw this out there in case you were interested in
giving it a go...

-- 
Jens Axboe


--------------1F1AEF70B20F832BA30218F2
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-internally-retry-short-reads.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-io_uring-internally-retry-short-reads.patch"

From 14333b5b72f2d9f9e12d2abe72bda4ee6cc3e45c Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 17 Aug 2020 21:03:27 -0700
Subject: [PATCH 2/2] io_uring: internally retry short reads

We've had a few application cases of not handling short reads properly,
and it is understandable as short reads aren't really expected if the
application isn't doing non-blocking IO.

Now that we retain the iov_iter over retries, we can implement internal
retry pretty trivially. This ensures that we don't return a short read,
even for buffered reads on page cache conflicts.

Cleanup the deep nesting and hard to read nature of io_read() as well,
it's much more straight forward now to read and understand. Added a
few comments explaining the logic as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 61 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bdb88146b285..618a4ca29159 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -487,6 +487,7 @@ struct io_async_rw {
 	struct iovec			fast_iov[UIO_FASTIOV];
 	const struct iovec		*free_iovec;
 	struct iov_iter			iter;
+	size_t				bytes_done;
 };
 
 struct io_async_ctx {
@@ -2160,6 +2161,14 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
+	/* add previously done IO, if any */
+	if (req->io && req->io->rw.bytes_done > 0) {
+		if (ret < 0)
+			ret = req->io->rw.bytes_done;
+		else
+			ret += req->io->rw.bytes_done;
+	}
+
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
 	if (ret >= 0 && kiocb->ki_complete == io_complete_rw)
@@ -2507,6 +2516,7 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 
 	memcpy(&rw->iter, iter, sizeof(*iter));
 	rw->free_iovec = NULL;
+	rw->bytes_done = 0;
 	/* can only be fixed buffers, no need to do anything */
 	if (iter->type == ITER_BVEC)
 		return;
@@ -2543,9 +2553,9 @@ static int io_alloc_async_ctx(struct io_kiocb *req)
 
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
-			     struct iov_iter *iter)
+			     struct iov_iter *iter, bool force)
 {
-	if (!io_op_defs[req->opcode].async_ctx)
+	if (!force && !io_op_defs[req->opcode].async_ctx)
 		return 0;
 	if (!req->io) {
 		if (__io_alloc_async_ctx(req))
@@ -2608,6 +2618,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 
 	req->result = 0;
 	io_size = ret;
+	ret = 0;
 	if (req->flags & REQ_F_LINK_HEAD)
 		req->result = io_size;
 
@@ -2630,21 +2641,39 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 		else
 			ret2 = -EINVAL;
 
-		/* Catch -EAGAIN return for forced non-blocking submission */
-		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2);
-		} else {
-copy_iov:
-			ret = io_setup_async_rw(req, iovec, inline_vecs, iter);
-			if (ret)
-				goto out_free;
-			/* any defer here is final, must blocking retry */
-			if (!(req->flags & REQ_F_NOWAIT) &&
-			    !file_can_poll(req->file))
-				req->flags |= REQ_F_MUST_PUNT;
-			return -EAGAIN;
+		if (!ret2) {
+			goto done;
+		} else if (ret2 == -EIOCBQUEUED) {
+			ret = 0;
+			goto out_free;
+		} else if (ret2 == -EAGAIN) {
+			ret2 = 0;
+			goto copy_iov;
+		} else if (ret2 < 0) {
+			ret = ret2;
+			goto out_free;
+		}
+
+		/* read it all, or we did blocking attempt. no retry. */
+		if (!iov_iter_count(iter) || !force_nonblock) {
+			ret = ret2;
+			goto done;
 		}
+
+copy_iov:
+		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
+		if (ret)
+			goto out_free;
+		req->io->rw.bytes_done += ret2;
+		/* any defer here is final, must blocking retry */
+		if (!(req->flags & REQ_F_NOWAIT) &&
+		    !file_can_poll(req->file))
+			req->flags |= REQ_F_MUST_PUNT;
+		return -EAGAIN;
 	}
+done:
+	kiocb_done(kiocb, ret);
+	ret = 0;
 out_free:
 	if (!(req->flags & REQ_F_NEED_CLEANUP))
 		kfree(iovec);
@@ -2762,7 +2791,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:
-			ret = io_setup_async_rw(req, iovec, inline_vecs, iter);
+			ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 			if (ret)
 				goto out_free;
 			/* any defer here is final, must blocking retry */
-- 
2.28.0


--------------1F1AEF70B20F832BA30218F2
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-retain-iov_iter-state-over-io_read-io_write.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-retain-iov_iter-state-over-io_read-io_write.pa";
 filename*1="tch"

From a8f27d6bdc9d5eb3e0180c0389c61bba35474ef5 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 17 Aug 2020 20:55:27 -0700
Subject: [PATCH 1/2] io_uring: retain iov_iter state over io_read/io_write
 calls

Instead of maintaining (and setting/remembering) iov_iter size and
segment counts, just put the iov_iter in the async part of the IO
structure.

This is mostly a preparation patch for doing appropriate internal retries
for short reads, but it also cleans up the state handling nicely and
simplifies it quite a bit.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 123 +++++++++++++++++++++++++++-----------------------
 1 file changed, 67 insertions(+), 56 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e7cbe61f64c..bdb88146b285 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -485,9 +485,8 @@ struct io_async_msghdr {
 
 struct io_async_rw {
 	struct iovec			fast_iov[UIO_FASTIOV];
-	struct iovec			*iov;
-	ssize_t				nr_segs;
-	ssize_t				size;
+	const struct iovec		*free_iovec;
+	struct iov_iter			iter;
 };
 
 struct io_async_ctx {
@@ -2392,6 +2391,13 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	ssize_t ret;
 	u8 opcode;
 
+	if (req->io) {
+		struct io_async_rw *iorw = &req->io->rw;
+
+		*iovec = NULL;
+		return iov_iter_count(&iorw->iter);
+	}
+
 	opcode = req->opcode;
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
 		*iovec = NULL;
@@ -2417,16 +2423,6 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 		return ret < 0 ? ret : sqe_len;
 	}
 
-	if (req->io) {
-		struct io_async_rw *iorw = &req->io->rw;
-
-		*iovec = iorw->iov;
-		iov_iter_init(iter, rw, *iovec, iorw->nr_segs, iorw->size);
-		if (iorw->iov == iorw->fast_iov)
-			*iovec = NULL;
-		return iorw->size;
-	}
-
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		ret = io_iov_buffer_select(req, *iovec, needs_lock);
 		if (!ret) {
@@ -2504,19 +2500,29 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 	return ret;
 }
 
-static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
-			  struct iovec *iovec, struct iovec *fast_iov,
-			  struct iov_iter *iter)
+static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
+			  const struct iovec *fast_iov, struct iov_iter *iter)
 {
-	req->io->rw.nr_segs = iter->nr_segs;
-	req->io->rw.size = io_size;
-	req->io->rw.iov = iovec;
-	if (!req->io->rw.iov) {
-		req->io->rw.iov = req->io->rw.fast_iov;
-		if (req->io->rw.iov != fast_iov)
-			memcpy(req->io->rw.iov, fast_iov,
+	struct io_async_rw *rw = &req->io->rw;
+
+	memcpy(&rw->iter, iter, sizeof(*iter));
+	rw->free_iovec = NULL;
+	/* can only be fixed buffers, no need to do anything */
+	if (iter->type == ITER_BVEC)
+		return;
+	if (!iovec) {
+		unsigned iov_off = 0;
+
+		rw->iter.iov = rw->fast_iov;
+		if (iter->iov != fast_iov) {
+			iov_off = iter->iov - fast_iov;
+			rw->iter.iov += iov_off;
+		}
+		if (rw->fast_iov != fast_iov)
+			memcpy(rw->fast_iov + iov_off, fast_iov + iov_off,
 			       sizeof(struct iovec) * iter->nr_segs);
 	} else {
+		rw->free_iovec = iovec;
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 }
@@ -2535,8 +2541,8 @@ static int io_alloc_async_ctx(struct io_kiocb *req)
 	return  __io_alloc_async_ctx(req);
 }
 
-static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
-			     struct iovec *iovec, struct iovec *fast_iov,
+static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
+			     const struct iovec *fast_iov,
 			     struct iov_iter *iter)
 {
 	if (!io_op_defs[req->opcode].async_ctx)
@@ -2545,7 +2551,7 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 		if (__io_alloc_async_ctx(req))
 			return -ENOMEM;
 
-		io_req_map_rw(req, io_size, iovec, fast_iov, iter);
+		io_req_map_rw(req, iovec, fast_iov, iter);
 	}
 	return 0;
 }
@@ -2553,8 +2559,7 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			bool force_nonblock)
 {
-	struct io_async_ctx *io;
-	struct iov_iter iter;
+	struct io_async_rw *iorw = &req->io->rw;
 	ssize_t ret;
 
 	ret = io_prep_rw(req, sqe, force_nonblock);
@@ -2568,15 +2573,17 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
-	io = req->io;
-	io->rw.iov = io->rw.fast_iov;
+	iorw = &req->io->rw;
+	iorw->iter.iov = iorw->fast_iov;
+	/* reset ->io around the iovec import, we don't want to use it */
 	req->io = NULL;
-	ret = io_import_iovec(READ, req, &io->rw.iov, &iter, !force_nonblock);
-	req->io = io;
+	ret = io_import_iovec(READ, req, (struct iovec **) &iorw->iter.iov,
+				&iorw->iter, !force_nonblock);
+	req->io = container_of(iorw, struct io_async_ctx, rw);
 	if (ret < 0)
 		return ret;
 
-	io_req_map_rw(req, ret, io->rw.iov, io->rw.fast_iov, &iter);
+	io_req_map_rw(req, iorw->iter.iov, iorw->fast_iov, &iorw->iter);
 	return 0;
 }
 
@@ -2584,11 +2591,14 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
-	struct iov_iter iter;
+	struct iov_iter __iter, *iter = &__iter;
 	size_t iov_count;
 	ssize_t io_size, ret;
 
-	ret = io_import_iovec(READ, req, &iovec, &iter, !force_nonblock);
+	if (req->io)
+		iter = &req->io->rw.iter;
+
+	ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
 
@@ -2608,15 +2618,15 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	if (force_nonblock && !io_file_supports_async(req->file, READ))
 		goto copy_iov;
 
-	iov_count = iov_iter_count(&iter);
+	iov_count = iov_iter_count(iter);
 	ret = rw_verify_area(READ, req->file, &kiocb->ki_pos, iov_count);
 	if (!ret) {
 		ssize_t ret2;
 
 		if (req->file->f_op->read_iter)
-			ret2 = call_read_iter(req->file, kiocb, &iter);
+			ret2 = call_read_iter(req->file, kiocb, iter);
 		else if (req->file->f_op->read)
-			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
+			ret2 = loop_rw_iter(READ, req->file, kiocb, iter);
 		else
 			ret2 = -EINVAL;
 
@@ -2625,8 +2635,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:
-			ret = io_setup_async_rw(req, io_size, iovec,
-						inline_vecs, &iter);
+			ret = io_setup_async_rw(req, iovec, inline_vecs, iter);
 			if (ret)
 				goto out_free;
 			/* any defer here is final, must blocking retry */
@@ -2645,8 +2654,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			 bool force_nonblock)
 {
-	struct io_async_ctx *io;
-	struct iov_iter iter;
+	struct io_async_rw *iorw = &req->io->rw;
 	ssize_t ret;
 
 	ret = io_prep_rw(req, sqe, force_nonblock);
@@ -2662,15 +2670,16 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
-	io = req->io;
-	io->rw.iov = io->rw.fast_iov;
+	iorw = &req->io->rw;
+	iorw->iter.iov = iorw->fast_iov;
 	req->io = NULL;
-	ret = io_import_iovec(WRITE, req, &io->rw.iov, &iter, !force_nonblock);
-	req->io = io;
+	ret = io_import_iovec(WRITE, req, (struct iovec **) &iorw->iter.iov,
+				&iorw->iter, !force_nonblock);
+	req->io = container_of(iorw, struct io_async_ctx, rw);
 	if (ret < 0)
 		return ret;
 
-	io_req_map_rw(req, ret, io->rw.iov, io->rw.fast_iov, &iter);
+	io_req_map_rw(req, iorw->iter.iov, iorw->fast_iov, &iorw->iter);
 	return 0;
 }
 
@@ -2678,11 +2687,14 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
-	struct iov_iter iter;
+	struct iov_iter __iter, *iter = &__iter;
 	size_t iov_count;
 	ssize_t ret, io_size;
 
-	ret = io_import_iovec(WRITE, req, &iovec, &iter, !force_nonblock);
+	if (req->io)
+		iter = &req->io->rw.iter;
+
+	ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
 
@@ -2707,7 +2719,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
-	iov_count = iov_iter_count(&iter);
+	iov_count = iov_iter_count(iter);
 	ret = rw_verify_area(WRITE, req->file, &kiocb->ki_pos, iov_count);
 	if (!ret) {
 		ssize_t ret2;
@@ -2731,9 +2743,9 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
 
 		if (req->file->f_op->write_iter)
-			ret2 = call_write_iter(req->file, kiocb, &iter);
+			ret2 = call_write_iter(req->file, kiocb, iter);
 		else if (req->file->f_op->write)
-			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
+			ret2 = loop_rw_iter(WRITE, req->file, kiocb, iter);
 		else
 			ret2 = -EINVAL;
 
@@ -2750,8 +2762,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:
-			ret = io_setup_async_rw(req, io_size, iovec,
-						inline_vecs, &iter);
+			ret = io_setup_async_rw(req, iovec, inline_vecs, iter);
 			if (ret)
 				goto out_free;
 			/* any defer here is final, must blocking retry */
@@ -5276,8 +5287,8 @@ static void io_cleanup_req(struct io_kiocb *req)
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
-		if (io->rw.iov != io->rw.fast_iov)
-			kfree(io->rw.iov);
+		if (io->rw.free_iovec)
+			kfree(io->rw.free_iovec);
 		break;
 	case IORING_OP_RECVMSG:
 		if (req->flags & REQ_F_BUFFER_SELECTED)
-- 
2.28.0


--------------1F1AEF70B20F832BA30218F2--
