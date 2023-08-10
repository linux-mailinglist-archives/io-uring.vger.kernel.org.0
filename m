Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0190777E22
	for <lists+io-uring@lfdr.de>; Thu, 10 Aug 2023 18:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbjHJQX5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Aug 2023 12:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbjHJQX4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Aug 2023 12:23:56 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFD8270A
        for <io-uring@vger.kernel.org>; Thu, 10 Aug 2023 09:23:54 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-7748ca56133so14341639f.0
        for <io-uring@vger.kernel.org>; Thu, 10 Aug 2023 09:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691684633; x=1692289433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/UoasOhdcT9+eZAvIQMPYP5p+87o/o7IGoeDljwITU4=;
        b=Czq8TDFSJAswQGP12EU5ZmSCOfZ3asfmNyLm/AEpPuFq9NNcWlAxjr+W0XqajGVasD
         WclhtZBicaia02qvrXvWEhjZCw8bglPncm1GymYZFlvruTVhSuHvz2kA3WUGZnFJnqFB
         qvjB0JAEc9w1YNAlpoDhBVX5ikgJTNU2GS9ytXqQJfpDcFftOwrwLF13N8youzAuSvap
         T44ef+hxnAEvKjCscVYzFyMHUbrwScQeWfwiwAohqs5ZF7K6Jn+r3t379X3la9FPM4uY
         4JJsYgzK+C7uwfV7IKC11WjbMbaRMv4s7G4xYb44UvG9yh0ykqrcOnhpwXRnOr5RiveU
         +FTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691684633; x=1692289433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/UoasOhdcT9+eZAvIQMPYP5p+87o/o7IGoeDljwITU4=;
        b=eVewqvaQwAqfYaSxNA9X7Y6X4Fqw1cMJuoYhdeOS21nTwpY0NzOX6a5V3m7oji5ZGA
         JK8jih5JZfUwfFjSzp5RP0euzpO2fl3iTN1vjJWbFgI5gf4sCkTbed/SWCeVJS6RqTSb
         4M9W9spv212/ZTIQBI323TAMzsqdhFWC/i6V5mRuTGgHckYmTv8hPdBf1dq6Fya5okLE
         cXLKzkRjvY6eFZJJaBssorep2VjYk1w6VMT1FtSKU3H6L3jcrzyZLEYHa1Q62Z1JaMwG
         SBRrMjGwqPlII53sPE3Icfc2yidjNJZ6LS2KtQlqtLY3GpxczcRd3+gVwSXvC0nj0Q+i
         OO+A==
X-Gm-Message-State: AOJu0YxMLgxuOZXacL4KAfqSKs+0M2AvGaQhEQP4Ma1UR5f1ypBHohdd
        CGrpyvLoBTJHh7bzkX3463n+FwZGMHHsggEocCU=
X-Google-Smtp-Source: AGHT+IF4ZqppbNKboQ9OsTCD0Rq+MW16YT9XWotEA1Lxf0J7zATPippDPhaVw81r+7wnMEyQ4P7N+g==
X-Received: by 2002:a6b:c8c5:0:b0:787:16ec:2699 with SMTP id y188-20020a6bc8c5000000b0078716ec2699mr4768199iof.2.1691684633718;
        Thu, 10 Aug 2023 09:23:53 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j5-20020a02cb05000000b0042ad887f705sm491941jap.143.2023.08.10.09.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 09:23:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: have io_file_put() take an io_kiocb rather than the file
Date:   Thu, 10 Aug 2023 10:23:46 -0600
Message-Id: <20230810162346.54872-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230810162346.54872-1-axboe@kernel.dk>
References: <20230810162346.54872-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No functional changes in this patch, just a prep patch for needing the
request in io_file_put().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 4 ++--
 io_uring/io_uring.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3da26171599b..138635e66d44 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1004,7 +1004,7 @@ static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 		if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
 			io_clean_op(req);
 		if (!(req->flags & REQ_F_FIXED_FILE))
-			io_put_file(req->file);
+			io_put_file(req);
 
 		rsrc_node = req->rsrc_node;
 		/*
@@ -1539,7 +1539,7 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 				io_clean_op(req);
 		}
 		if (!(req->flags & REQ_F_FIXED_FILE))
-			io_put_file(req->file);
+			io_put_file(req);
 
 		io_req_put_rsrc_locked(req, ctx);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 12769bad5cee..46643bc9f3c5 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -196,10 +196,10 @@ static inline bool req_has_async_data(struct io_kiocb *req)
 	return req->flags & REQ_F_ASYNC_DATA;
 }
 
-static inline void io_put_file(struct file *file)
+static inline void io_put_file(struct io_kiocb *req)
 {
-	if (file)
-		fput(file);
+	if (req->file)
+		fput(req->file);
 }
 
 static inline void io_ring_submit_unlock(struct io_ring_ctx *ctx,
-- 
2.40.1

