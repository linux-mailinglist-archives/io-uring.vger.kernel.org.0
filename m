Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F06C015CEF8
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 01:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgBNART (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Feb 2020 19:17:19 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:39876 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbgBNART (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Feb 2020 19:17:19 -0500
Received: by mail-pj1-f53.google.com with SMTP id e9so3140716pjr.4
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2020 16:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=fXptIJ+UGtoxtJxkgz8RWzleo7TMXDZ9Zk9nhDDFjmc=;
        b=h88rdIcmnROgV+ZPvLJVyfMmgyHQn+mS8NaaqInwQu5ug/Md/2QbWwLlWZcwcYHM+5
         +L2mj0+HV/KJ9BoSPqoSqKKZuLZDvBUcYP/i7DfKIz3tKUVfp5FZUKKjC5WL69Lbwu3W
         TinzXml/M7q3q24kGCup6ss3jkr/oGLx7W22wxoVOECdbsSUH8K2N4SXFuVxGBdki4Hu
         uQqgvoWN5UHhoXwAWJOP5qZXkI7vmGWfCMpNooTpod6NV32mPDIjRMUaGb3hKGXzFodh
         k4uo7ZliIDw+lsxDbyC1vILGrXxlEmdBb93p0kBcR7X+pLEFq2YcV1DbgMS2usgI5WC/
         pHlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=fXptIJ+UGtoxtJxkgz8RWzleo7TMXDZ9Zk9nhDDFjmc=;
        b=Cx0QN+pg93ZsbcCKqIMov6rC/WBoBTJtvklPxH5pyK6FM11s1GGMwnNtinwqj15jUo
         hhMYuVhYKYJl8WSzIwN9jPxXA8AGFlBD+9pQNZZNiZo0DTNQoA/uuCYXUai6RP0q2llB
         fE0cRhI3yBSHwCckpsNNhtgFgKaTqrS6fG+weq4B3B+aKmnbss6YhUx+5EWN3d7/bNDE
         yfcCGqgIo3WUsfhLh/o6D9JHe/Mflg0dFZNFUqXkFt70NPOiHymhaWSLe739gk+e/SUV
         S0aWVbnDJuE0mHRDymxTSBWaKfYdOj47XXXc3Ik6KVD7uErNdAcVvtk5dVSO8Bzjy38j
         FDMg==
X-Gm-Message-State: APjAAAV3DXDE9f1A+4kIo8p7tAZvuGUpPiw37YLJzntq41rY6SpZHA+0
        e/rC8mRHfUe/ChrCmTgrZaSrc6HyBT0=
X-Google-Smtp-Source: APXvYqx5XN/eYI/YAwrbH08+d4SoYz1yBLS+wvDNNwTPKlG5utIfdlaNw0k83Pz4EihqV1I/gHbMyQ==
X-Received: by 2002:a17:902:724a:: with SMTP id c10mr484540pll.307.1581639436862;
        Thu, 13 Feb 2020 16:17:16 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id ep2sm3744810pjb.31.2020.02.13.16.17.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 16:17:16 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>,
        =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: prune request from overflow list on flush
Message-ID: <01ae4ae7-0cbb-389b-8ee9-f561b3df1d6a@kernel.dk>
Date:   Thu, 13 Feb 2020 17:17:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Carter reported an issue where he could produce a stall on ring exit,
when we're cleaning up requests that match the given file table. For
this particular test case, a combination of a few things caused the
issue:

- The cq ring was overflown
- The request being canceled was in the overflow list

The combination of the above means that the cq overflow list holds a
reference to the request. The request is canceled correctly, but since
the overflow list holds a reference to it, the final put won't happen.
Since the final put doesn't happen, the request remains in the inflight.
Hence we never finish the cancelation flush.

Fix this by removing requests from the overflow list if we're canceling
them.

Reported-by: Carter Li 李通洲 <carter.li@eoitek.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9f00f30e1790..d967a17c5923 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -481,6 +481,7 @@ enum {
 	REQ_F_TIMEOUT_NOSEQ_BIT,
 	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
+	REQ_F_OVERFLOW_BIT,
 };
 
 enum {
@@ -521,6 +522,8 @@ enum {
 	REQ_F_COMP_LOCKED	= BIT(REQ_F_COMP_LOCKED_BIT),
 	/* needs cleanup */
 	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
+	/* in overflow list */
+	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
 };
 
 /*
@@ -1103,6 +1106,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		req = list_first_entry(&ctx->cq_overflow_list, struct io_kiocb,
 						list);
 		list_move(&req->list, &list);
+		req->flags &= ~REQ_F_OVERFLOW;
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
 			WRITE_ONCE(cqe->res, req->result);
@@ -1155,6 +1159,7 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 			set_bit(0, &ctx->sq_check_overflow);
 			set_bit(0, &ctx->cq_check_overflow);
 		}
+		req->flags |= REQ_F_OVERFLOW;
 		refcount_inc(&req->refs);
 		req->result = res;
 		list_add_tail(&req->list, &ctx->cq_overflow_list);
@@ -6536,6 +6541,26 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		if (!cancel_req)
 			break;
 
+		if (cancel_req->flags & REQ_F_OVERFLOW) {
+			spin_lock_irq(&ctx->completion_lock);
+			list_del(&cancel_req->list);
+			cancel_req->flags &= ~REQ_F_OVERFLOW;
+			if (list_empty(&ctx->cq_overflow_list)) {
+				clear_bit(0, &ctx->sq_check_overflow);
+				clear_bit(0, &ctx->cq_check_overflow);
+			}
+			spin_unlock_irq(&ctx->completion_lock);
+
+			/*
+			 * Put inflight ref and overflow ref. If that's
+			 * all we had, then we're done with this request.
+			 */
+			if (refcount_sub_and_test(2, &cancel_req->refs)) {
+				io_put_req(cancel_req);
+				continue;
+			}
+		}
+
 		io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
 		io_put_req(cancel_req);
 		schedule();

-- 
Jens Axboe

