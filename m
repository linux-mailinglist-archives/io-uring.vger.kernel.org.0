Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BB12055A1
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 17:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732781AbgFWPQq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 11:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732909AbgFWPQm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 11:16:42 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F6FC061573
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 08:16:41 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id p11so2077709ilp.11
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 08:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZPLvgiMcws8wormKWikstBbELlh7wIW3pOV09wS0CDY=;
        b=dvLhWcjaxVtqTJuS8cgIMk5AFzZLzmShfmQ2wVpxzC+cpwfIooFmPTX94bCTPdWPBA
         wv/UoJ/pKyYiGccsTqyu+WGY2gs+h1Cv8twmmYo4qH/JRulCCZwNoq/ScXWqJFBLEiYz
         p3wx8k11ob/hFoe31PyitWG7En/IRYvzKb1s3O9prGFip8JZ8hvUMqoeW4HoywvowxJq
         DNMGDc1G4CAAjFg9qxYZq4KTQ5Cq7Iw6eZK3lovjumcEcN7XR7ayr5opHUzarbX32FlF
         9L3HbibVvxfSvF4woKigV/SZPnBpbR9paRtBylc4PsvQ+TGG6Kp28PuHSqhjZ4JdvLml
         dylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZPLvgiMcws8wormKWikstBbELlh7wIW3pOV09wS0CDY=;
        b=WGZqxHEXXdEXkgldGPsBRMVGmpAC8t+iy5jQo3nYxcSV/uCbNgo5XQ21Awe2h+cfG8
         fxbbyaJbxjxGcEduARQYgSkPNqtrUY7kYov055IJ3jn1KJ9kHaI/laMhGyMuokpIcuD3
         XKAe8YMXfdptBcbrT7HZ6uBLUsR+QorRPpWKNQTXZcjjrSSGoU1m9dpPJHZRfsMI18EC
         bd+8bXfHAFOkBtAku3i71Fzas3bZwwEB8SBEwZAgHPpqE1A8Sj+4xO4QryO50gD1MHEJ
         LZXz9YGUVfVKymjjaFBnVf+6P4hfddqVHiBXISNR/QXordBNfRPOE/S7V3aOFvt6IgEh
         bQDA==
X-Gm-Message-State: AOAM532IsXe/EwpEIG5ObQlk8GVrYn8QCBovA6suZFTXwKrG53fYV8um
        bXLQZEAkhYU8dhtW3y6aLZwge3bnspI=
X-Google-Smtp-Source: ABdhPJw31jaGOZOOfFtj9ZhqVuCiG8krtL4SUXzvxjLiScIApTyXuc5+yCIMrwlbkEhnRHJIv/kllg==
X-Received: by 2002:a92:7792:: with SMTP id s140mr13906868ilc.66.1592925400190;
        Tue, 23 Jun 2020 08:16:40 -0700 (PDT)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k1sm4275180ilr.35.2020.06.23.08.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 08:16:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     xuanzhuo@linux.alibaba.com, Dust.li@linux.alibaba.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: enable READ/WRITE to use deferred completions
Date:   Tue, 23 Jun 2020 09:16:29 -0600
Message-Id: <20200623151629.17197-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623151629.17197-1-axboe@kernel.dk>
References: <20200623151629.17197-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A bit more surgery required here, as completions are generally done
through the kiocb->ki_complete() callback, even if they complete inline.
This enables the regular read/write path to use the io_comp_state
logic to batch inline completions.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0939f5c1a681..a4936b94988c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2019,7 +2019,8 @@ static inline void req_set_fail_links(struct io_kiocb *req)
 		req->flags |= REQ_F_FAIL_LINK;
 }
 
-static void io_complete_rw_common(struct kiocb *kiocb, long res)
+static void io_complete_rw_common(struct kiocb *kiocb, long res,
+				  struct io_comp_state *cs)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 	int cflags = 0;
@@ -2031,7 +2032,7 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 		req_set_fail_links(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_kbuf(req);
-	io_cqring_add_event(req, res, cflags);
+	__io_req_complete(req, res, cflags, cs);
 }
 
 static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
@@ -2134,14 +2135,18 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 	return false;
 }
 
+static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
+			     struct io_comp_state *cs)
+{
+	if (!io_rw_reissue(req, res))
+		io_complete_rw_common(&req->rw.kiocb, res, cs);
+}
+
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
-	if (!io_rw_reissue(req, res)) {
-		io_complete_rw_common(kiocb, res);
-		io_put_req(req);
-	}
+	__io_complete_rw(req, res, res2, NULL);
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
@@ -2375,14 +2380,15 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
-static void kiocb_done(struct kiocb *kiocb, ssize_t ret)
+static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
+		       struct io_comp_state *cs)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
 	if (ret >= 0 && kiocb->ki_complete == io_complete_rw)
-		io_complete_rw(kiocb, ret, 0);
+		__io_complete_rw(req, ret, 0, cs);
 	else
 		io_rw_done(kiocb, ret);
 }
@@ -2918,7 +2924,8 @@ static int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
 	return loop_rw_iter(READ, req->file, &req->rw.kiocb, iter);
 }
 
-static int io_read(struct io_kiocb *req, bool force_nonblock)
+static int io_read(struct io_kiocb *req, bool force_nonblock,
+		   struct io_comp_state *cs)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2953,7 +2960,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
-			kiocb_done(kiocb, ret2);
+			kiocb_done(kiocb, ret2, cs);
 		} else {
 			iter.count = iov_count;
 			iter.nr_segs = nr_segs;
@@ -2968,7 +2975,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 				if (ret2 == -EIOCBQUEUED) {
 					goto out_free;
 				} else if (ret2 != -EAGAIN) {
-					kiocb_done(kiocb, ret2);
+					kiocb_done(kiocb, ret2, cs);
 					goto out_free;
 				}
 			}
@@ -3014,7 +3021,8 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static int io_write(struct io_kiocb *req, bool force_nonblock)
+static int io_write(struct io_kiocb *req, bool force_nonblock,
+		    struct io_comp_state *cs)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -3083,7 +3091,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 			ret2 = -EAGAIN;
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2);
+			kiocb_done(kiocb, ret2, cs);
 		} else {
 			iter.count = iov_count;
 			iter.nr_segs = nr_segs;
@@ -5409,7 +5417,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_read(req, force_nonblock);
+		ret = io_read(req, force_nonblock, cs);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
@@ -5419,7 +5427,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_write(req, force_nonblock);
+		ret = io_write(req, force_nonblock, cs);
 		break;
 	case IORING_OP_FSYNC:
 		if (sqe) {
-- 
2.27.0

