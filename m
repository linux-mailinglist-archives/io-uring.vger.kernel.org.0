Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24BE1EEFD5
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2020 05:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgFEDUg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 23:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgFEDUf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 23:20:35 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3FBC08C5C0
        for <io-uring@vger.kernel.org>; Thu,  4 Jun 2020 20:20:35 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b5so4241500pfp.9
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2020 20:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bmTZJfXN0S47aLbdOaJc24Hl/qaRP1qmpwQE0UY9/A8=;
        b=Pl6ab81iNpHkXoH0D18smveOlSNumU0E0c5hYZHonhm6y19cOBXCT1pt+q6a22ieeL
         DR0VH/i4t1NnQSKmXyNxMRDwMav85+w91a+3ECHBfWSNu+GVgyxjHTM2DfzdvWR34Ch7
         JLgelGZ+8VCnsrC2Ivl9hCUy1VHuUsoNOIOhIzsj73bj33cboMp6nX7BdKKUaP2yFL0K
         ldAF6Y7vzJjeqenOvZSLYPH1laL4/yIZPeTSwttpVBNJTSrNFocFrucpLSwMXx/HY7bq
         enFnxVGbSGF+Wv/Gx76ZW3yeFf6NB7sr5WU6/tBbVOnvi6S/ld3/3dxA1oVy+ATfAFKh
         1kGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bmTZJfXN0S47aLbdOaJc24Hl/qaRP1qmpwQE0UY9/A8=;
        b=BCc0U3x2cTWafpgLKCZt+ypj7KHIt9spYjbzTwJNoc3emzk63hNS6UJn6C2jBvPexH
         2cpeRytvo2Phorhoq1Bl6a38enZ61P4KP6NwOb2g1hApDFEMH3UeVgpEqBCg6RQFwb58
         YdQGxsXcdmD1eakJpyP/CTykgVJZeE/CsErEvuznAnZteTFBUVKMrt2qDZ1DWHvsKqIs
         rp+UmNm5ELdqG7AZ4YBgqQVHdzSC/tK6TaPCwzVorW7rOOrSEkhwTQbdlKUcSTCaf0Ct
         qnrbd2QKZqCuS3iKfvW/qdlCPJwV/PnsvUKq370du3nvBv6QBk3f2tLIcGHPtCpFH+UW
         W6pg==
X-Gm-Message-State: AOAM532Y2/mzvwlTpdDucsq110Pse0R7cYInlB3io/7hbYhdnvbTHKxf
        DBNZfqvvCZsvLUt/Ou6kkuEvt/ARhoieyg==
X-Google-Smtp-Source: ABdhPJyfChCLj5NAPXK2tGBLJyFPaDlJE+X/eeEalNZEXtHSOBHg1xF//pS7p/9cnyLtLsQ7lZaCSg==
X-Received: by 2002:a62:6042:: with SMTP id u63mr7904102pfb.79.1591327234404;
        Thu, 04 Jun 2020 20:20:34 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n3sm5118529pgq.30.2020.06.04.20.20.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 20:20:33 -0700 (PDT)
Subject: [PATCH v2] io_uring: re-issue plug based block requests that failed
To:     io-uring <io-uring@vger.kernel.org>
References: <20200604174832.12905-1-axboe@kernel.dk>
 <20200604174832.12905-5-axboe@kernel.dk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d16186db-0f72-daad-2839-86025c6197f5@kernel.dk>
Date:   Thu, 4 Jun 2020 21:20:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200604174832.12905-5-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Mark the plug with nowait == true, which will cause requests to avoid
blocking on request allocation. If they do, we catch them and add them
to the plug list. Once we finish the plug, re-issue requests that got
caught.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Since v1:
- Properly re-prep on resubmit
- Sanity check for io_wq_current_is_worker()
- Sanity check we're just doing read/write for re-issue
- Ensure iov state is sane for resubmit

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 625578715d37..942984bda2f8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1947,12 +1947,31 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 	__io_cqring_add_event(req, res, cflags);
 }
 
+static bool io_rw_reissue(struct io_kiocb *req, long res)
+{
+#ifdef CONFIG_BLOCK
+	struct blk_plug *plug;
+
+	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
+		return false;
+
+	plug = current->plug;
+	if (plug && plug->nowait) {
+		list_add_tail(&req->list, &plug->nowait_list);
+		return true;
+	}
+#endif
+	return false;
+}
+
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
-	io_complete_rw_common(kiocb, res);
-	io_put_req(req);
+	if (!io_rw_reissue(req, res)) {
+		io_complete_rw_common(kiocb, res);
+		io_put_req(req);
+	}
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
@@ -2629,6 +2648,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	iov_count = iov_iter_count(&iter);
 	ret = rw_verify_area(READ, req->file, &kiocb->ki_pos, iov_count);
 	if (!ret) {
+		unsigned long nr_segs = iter.nr_segs;
 		ssize_t ret2 = 0;
 
 		if (req->file->f_op->read_iter)
@@ -2640,6 +2660,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 		if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
 			kiocb_done(kiocb, ret2);
 		} else {
+			iter.count = iov_count;
+			iter.nr_segs = nr_segs;
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
 						inline_vecs, &iter);
@@ -2726,6 +2748,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 	iov_count = iov_iter_count(&iter);
 	ret = rw_verify_area(WRITE, req->file, &kiocb->ki_pos, iov_count);
 	if (!ret) {
+		unsigned long nr_segs = iter.nr_segs;
 		ssize_t ret2;
 
 		/*
@@ -2763,6 +2786,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		if (!force_nonblock || ret2 != -EAGAIN) {
 			kiocb_done(kiocb, ret2);
 		} else {
+			iter.count = iov_count;
+			iter.nr_segs = nr_segs;
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
 						inline_vecs, &iter);
@@ -5789,12 +5814,70 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
+#ifdef CONFIG_BLOCK
+static bool io_resubmit_prep(struct io_kiocb *req)
+{
+	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct iov_iter iter;
+	ssize_t ret;
+	int rw;
+
+	switch (req->opcode) {
+	case IORING_OP_READV:
+	case IORING_OP_READ_FIXED:
+	case IORING_OP_READ:
+		rw = READ;
+		break;
+	case IORING_OP_WRITEV:
+	case IORING_OP_WRITE_FIXED:
+	case IORING_OP_WRITE:
+		rw = WRITE;
+		break;
+	default:
+		printk_once(KERN_WARNING "io_uring: bad opcode in resubmit %d\n",
+				req->opcode);
+		goto end_req;
+	}
+
+	ret = io_import_iovec(rw, req, &iovec, &iter, false);
+	if (ret < 0)
+		goto end_req;
+	ret = io_setup_async_rw(req, ret, iovec, inline_vecs, &iter);
+	if (!ret)
+		return true;
+	kfree(iovec);
+end_req:
+	io_cqring_add_event(req, ret);
+	req_set_fail_links(req);
+	io_put_req(req);
+	return false;
+}
+
+static void io_resubmit_rw(struct list_head *list)
+{
+	struct io_kiocb *req;
+
+	while (!list_empty(list)) {
+		req = list_first_entry(list, struct io_kiocb, list);
+		list_del(&req->list);
+		if (io_resubmit_prep(req)) {
+			refcount_inc(&req->refs);
+			io_queue_async_work(req);
+		}
+	}
+}
+#endif
+
 /*
  * Batched submission is done, ensure local IO is flushed out.
  */
 static void io_submit_state_end(struct io_submit_state *state)
 {
 	blk_finish_plug(&state->plug);
+#ifdef CONFIG_BLOCK
+	if (unlikely(!list_empty(&state->plug.nowait_list)))
+		io_resubmit_rw(&state->plug.nowait_list);
+#endif
 	io_state_file_put(state);
 	if (state->free_reqs)
 		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
@@ -5807,6 +5890,10 @@ static void io_submit_state_start(struct io_submit_state *state,
 				  unsigned int max_ios)
 {
 	blk_start_plug(&state->plug);
+#ifdef CONFIG_BLOCK
+	INIT_LIST_HEAD(&state->plug.nowait_list);
+	state->plug.nowait = true;
+#endif
 	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;

-- 
Jens Axboe

