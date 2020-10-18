Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A54291698
	for <lists+io-uring@lfdr.de>; Sun, 18 Oct 2020 11:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgJRJUt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Oct 2020 05:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgJRJUs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Oct 2020 05:20:48 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93222C061755
        for <io-uring@vger.kernel.org>; Sun, 18 Oct 2020 02:20:48 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h7so8095590wre.4
        for <io-uring@vger.kernel.org>; Sun, 18 Oct 2020 02:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UNhUCo2rMuzvjyB/GCW1QnYbiXZVEemfm+BuYi2gV5g=;
        b=psTaUbss360a/Tt1zaVcCXb9S1WJFpv/FwLETkHPj0R4qxM+u1CAA9IB2eyiQu//u0
         QC4iNLx5O0kPdIH//4mNLgmdlWBhUV3uNYRiee1To5E7MdF8KpH6/myhl1VcPK8z3fwa
         t7+7XOKUqzayHcKO/b+iEf0mLOyYh1YoRspRiIHn++zjngk6X/lip2H5LMqXUxkPN7PQ
         iG1VBAtuJdKwg74N8sNDDJXK5WUByqQDIoDtF+2yhyaOF7cgkfyjuS5Bh6jl/Tc38EIX
         IVwALXL3FalwV0Z6Sb2BeRuvcueH9/SnLD5BSP1wQPdqdGOfXLmFGBcs01IWjLD13Ymz
         BAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UNhUCo2rMuzvjyB/GCW1QnYbiXZVEemfm+BuYi2gV5g=;
        b=Ea+Nbkbuh3qPhUDR6fZ2Ud6BuhnjNcNL8rkhf+D7iiT6r4tCQUb1NdFxohfC6SyDHL
         0E5ARr5T3fqIjPF1mF7CwfhEhqnxbNqAucfG6K4iYtPRpgOsFznsV+v9U9hvD1rN+3VK
         NneviEZWYi23e/OUI2RJhEC/RKz3DXZa0qkb0X4Y3nXuhg6x698oEaIJCTAEdbpG6xP1
         aABnsQ74p7VoJcXkF8aoU92FKyWdR8Af04dChlAqNkt2wXuXdUEDOjJmNEJhG0bszFmx
         qSyPNCYuohF2Q7e6NQ4PSAcQDzsDOAqmUKahuzzmIFW39IFrpeRa/SO0OKT/Y/9kA3Xi
         fSTw==
X-Gm-Message-State: AOAM530o56ixhFRIt4Ni4bCWqH7cvhGTg+hcNmS3ByMmEDzRXzG3Na29
        lYI6omU5zsMklO6MSWwXvmmaGL8ar0FmGA==
X-Google-Smtp-Source: ABdhPJzzQKOvCObEVjIFoCsmaUMOrR1uC7SkG3FrXfN2bJ2YdTpvKH+WflPTCYm93gNQRuEGjQpJyQ==
X-Received: by 2002:adf:f101:: with SMTP id r1mr14907756wro.392.1603012847370;
        Sun, 18 Oct 2020 02:20:47 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id w11sm12782984wrs.26.2020.10.18.02.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 02:20:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/7] io_uring: make cached_cq_overflow non atomic_t
Date:   Sun, 18 Oct 2020 10:17:40 +0100
Message-Id: <fe7201d945acd0174a178f75cd6d07c8315afb03.1603011899.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603011899.git.asml.silence@gmail.com>
References: <cover.1603011899.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ctx->cached_cq_overflow is changed only under completion_lock. Convert
it from atomic_t to just int, and mark all places when it's read without
lock with READ_ONCE, which guarantees atomicity (relaxed ordering).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 43c92a3088d8..c7ccd2500597 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -277,7 +277,7 @@ struct io_ring_ctx {
 		unsigned		sq_mask;
 		unsigned		sq_thread_idle;
 		unsigned		cached_sq_dropped;
-		atomic_t		cached_cq_overflow;
+		unsigned		cached_cq_overflow;
 		unsigned long		sq_check_overflow;
 
 		struct list_head	defer_list;
@@ -1179,7 +1179,7 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 		struct io_ring_ctx *ctx = req->ctx;
 
 		return seq != ctx->cached_cq_tail
-				+ atomic_read(&ctx->cached_cq_overflow);
+				+ READ_ONCE(ctx->cached_cq_overflow);
 	}
 
 	return false;
@@ -1624,8 +1624,9 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 			WRITE_ONCE(cqe->res, req->result);
 			WRITE_ONCE(cqe->flags, req->compl.cflags);
 		} else {
+			ctx->cached_cq_overflow++;
 			WRITE_ONCE(ctx->rings->cq_overflow,
-				atomic_inc_return(&ctx->cached_cq_overflow));
+				   ctx->cached_cq_overflow);
 		}
 	}
 
@@ -1667,8 +1668,8 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 		 * then we cannot store the request for later flushing, we need
 		 * to drop it on the floor.
 		 */
-		WRITE_ONCE(ctx->rings->cq_overflow,
-				atomic_inc_return(&ctx->cached_cq_overflow));
+		ctx->cached_cq_overflow++;
+		WRITE_ONCE(ctx->rings->cq_overflow, ctx->cached_cq_overflow);
 	} else {
 		if (list_empty(&ctx->cq_overflow_list)) {
 			set_bit(0, &ctx->sq_check_overflow);
-- 
2.24.0

