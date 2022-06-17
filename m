Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D3354F387
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 10:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380735AbiFQItp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 04:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381085AbiFQIto (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 04:49:44 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5C069495
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:43 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id hj18so6864680ejb.0
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TZWswOpcOw8YqJ6VKxs3ktcKrk9XoKJUSc0tGrWrMuk=;
        b=jddoO+YjKzSMdRVCcMZywpVoag2xsDD7hdjZx4+78A0uiHetcKiCDy8MdrYLoUJy7v
         9IPHdglvdYY2pV96KMhdosJQx6GfmH76SMhH00DMgUEQqOd/bBSWG5gxb2OYjxC0rPcn
         cLI/EQ+cHrld1D8B5CqVSd4twjSfY6BUUt9L6mH+DuwwmSgi6JmLz85ecoeUEiNSpsss
         zfpmlL8tmvdCFcEZVkmV7otzY9YhO761WkpAMU+ZZnMRCvjPt6gk9fb3891Usam8iDBF
         +XNl/wmrC4egHwhpbFlW3JqxpUVqsejbI+/rML7UCjVLzeP/BQx/lGHRMMRIxwjX2FYt
         qUHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TZWswOpcOw8YqJ6VKxs3ktcKrk9XoKJUSc0tGrWrMuk=;
        b=LkAr+oon3+Xt2beCvNNo84EELWRBVbaja/P8GrYXwXXSuupIegIowOlCKbaJC+2/cm
         TKUpicBceEPAdmT9Hvjun6E+QjiQp76q2QFZHEkYGfAMXt8oPPtANbfPKmZRSe9gySpm
         aKGXv0cQy73+aExVVuefqLOqamumvxphq4Y3hBrGhMP38XilCX06qALxIHzmJUgsMguD
         4b5SEUJ/EwkbEOoM9SGzl6UoW7OQaFsSP5Zgr8NEacwH1f+H3UVngiuoDb4NVBeIUfku
         gi/+dEGfu2uAqUtUr8lrqNK8/vB+0V1nSKnQSch4jUN8lXMCf4HLOghDsgInjAkj8QGN
         SH4w==
X-Gm-Message-State: AJIora9jSUPziNmD9a/zSzJ981X03EYPBq9HXPFQPp30wyzJlkLEjn9a
        DvslLGdhWvCSCSO3JOjrXxMQpixiAT7eAg==
X-Google-Smtp-Source: AGRyM1tJw0BXDFxySkmF8VRr1ukcIPoamdncJiI/MFS6lywerLeq1+oWajnnzWkN3YJMNn+pFlGwBQ==
X-Received: by 2002:a17:907:2da6:b0:711:d86d:ccab with SMTP id gt38-20020a1709072da600b00711d86dccabmr8182381ejc.356.1655455782001;
        Fri, 17 Jun 2022 01:49:42 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:b65a])
        by smtp.gmail.com with ESMTPSA id u17-20020a1709060b1100b006ff52dfccf3sm1851895ejg.211.2022.06.17.01.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 01:49:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/6] io_uring: introduce io_req_cqe_overflow()
Date:   Fri, 17 Jun 2022 09:48:02 +0100
Message-Id: <048b9fbcce56814d77a1a540409c98c3d383edcb.1655455613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655455613.git.asml.silence@gmail.com>
References: <cover.1655455613.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_fill_cqe_req() is hot and inlined, we want it to be as small as
possible. Add io_req_cqe_overflow() accepting only a request and doing
all overflow accounting, and replace with it two calls to 6 argument
io_cqring_event_overflow().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 15 +++++++++++++--
 io_uring/io_uring.h | 12 ++----------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a3b1339335c5..263d7e4f1b41 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -640,8 +640,8 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 	}
 }
 
-bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data, s32 res,
-			      u32 cflags, u64 extra1, u64 extra2)
+static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
+				     s32 res, u32 cflags, u64 extra1, u64 extra2)
 {
 	struct io_overflow_cqe *ocqe;
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
@@ -678,6 +678,17 @@ bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return true;
 }
 
+bool io_req_cqe_overflow(struct io_kiocb *req)
+{
+	if (!(req->flags & REQ_F_CQE32_INIT)) {
+		req->extra1 = 0;
+		req->extra2 = 0;
+	}
+	return io_cqring_event_overflow(req->ctx, req->cqe.user_data,
+					req->cqe.res, req->cqe.flags,
+					req->extra1, req->extra2);
+}
+
 /*
  * writes to the cq entry need to come after reading head; the
  * control dependency is enough as we're using WRITE_ONCE to
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 51032a494aec..668fff18d3cc 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -17,8 +17,7 @@ enum {
 };
 
 struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx);
-bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data, s32 res,
-			      u32 cflags, u64 extra1, u64 extra2);
+bool io_req_cqe_overflow(struct io_kiocb *req);
 
 static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 {
@@ -58,10 +57,6 @@ static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 			memcpy(cqe, &req->cqe, sizeof(*cqe));
 			return true;
 		}
-
-		return io_cqring_event_overflow(ctx, req->cqe.user_data,
-						req->cqe.res, req->cqe.flags,
-						0, 0);
 	} else {
 		u64 extra1 = 0, extra2 = 0;
 
@@ -85,11 +80,8 @@ static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 			WRITE_ONCE(cqe->big_cqe[1], extra2);
 			return true;
 		}
-
-		return io_cqring_event_overflow(ctx, req->cqe.user_data,
-				req->cqe.res, req->cqe.flags,
-				extra1, extra2);
 	}
+	return io_req_cqe_overflow(req);
 }
 
 static inline void req_set_fail(struct io_kiocb *req)
-- 
2.36.1

