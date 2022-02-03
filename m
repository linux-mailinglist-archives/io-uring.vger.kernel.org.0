Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570044A8B8C
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 19:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353452AbiBCSYs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 13:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236996AbiBCSYq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 13:24:46 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60306C06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 10:24:46 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id l25so6640686wrb.13
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 10:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m/kvsV2Fw6mBqvpDjxp3WYmDCchAjKBAAZ5SIZ3OfkM=;
        b=66N4tAnImIxy+NlELi2dsVP1q3BoPC3FBsRayVINw1iV1gn3jyQb/nnEeBx8tYerW1
         qfo/nhQCtq0YiimNVcNgBTNmacq2XaGjneq1FGX9x1dd3i7KdFTNzl5bbk+YymP8OWhH
         +6LvXt39ZCF0ciyN04sZtY8FFCmJpArQrkGsLNHvQwRgvjeugUrxqnFJjvTozitgFvbf
         UQEWK8pmQT4DYn5pgUsknZE9KKx2uHG4hpyWoek1n/9xHfo4xXbWN2id99moPZCsEria
         qAjZ9cRmRcQapkQdYKmQgAjEGN6xxNOPkruyKAx4iN6otFHJi7wzXEAYgGf9QLrMxxDJ
         3RUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m/kvsV2Fw6mBqvpDjxp3WYmDCchAjKBAAZ5SIZ3OfkM=;
        b=QO9+LWsgbnRDvXussO8avFyF6DcYUyzQ6OJ9Zb30bX3nwzjmreNtkGXE5842myc38b
         KyOMMLsrYBSP02FwbyRmjlYS446fWHWm+HEziPfhU/t+s4qSQg+XYbV+fYeUz3pd7iuD
         ht21gm9WHztyxrMtQR/U9KnNSxAajXvnETb/Rt/1gZTeYyzzq0WcslXQEngjntMRo8C7
         vRt1nfEoKrmGranf1AZ2KTsgJZOTX/5Qgv3pa9hLHv0Kn6biQdU2ACnqbG4kGNxi4fUA
         H1Ty9aYw3ZPY2N8NO49B00iu780DSQ/oqYaQvks2o4WypPOzcJ5iG0zDfk3xvJls76oN
         LJVg==
X-Gm-Message-State: AOAM533hSYQSjXF/fO3qfvfcbOh4Q/LqHj/yg6QaXbZL9ARHFhBHYyae
        Um+vFa1UJrx01YNlmrg7xsjDSw8TX0yLfg==
X-Google-Smtp-Source: ABdhPJxz13ks1JrRWqeu3h079pyf4S696ocGGUkjgRzLTsXit0psjiM2uwnCICw2aFzxwjT4mD0pew==
X-Received: by 2002:adf:e408:: with SMTP id g8mr20681027wrm.288.1643912684895;
        Thu, 03 Feb 2022 10:24:44 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id h18sm3540056wro.9.2022.02.03.10.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 10:24:44 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v4 1/3] io_uring: remove trace for eventfd
Date:   Thu,  3 Feb 2022 18:24:39 +0000
Message-Id: <20220203182441.692354-2-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203182441.692354-1-usama.arif@bytedance.com>
References: <20220203182441.692354-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The information on whether eventfd is registered is not very useful
and would result in the tracepoint being enclosed in an rcu_readlock
in a later patch that tries to avoid ring quiesce for registering
eventfd.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c                   |  3 +--
 include/trace/events/io_uring.h | 13 +++++--------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e04f718319d..21531609a9c6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11171,8 +11171,7 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	mutex_lock(&ctx->uring_lock);
 	ret = __io_uring_register(ctx, opcode, arg, nr_args);
 	mutex_unlock(&ctx->uring_lock);
-	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs,
-							ctx->cq_ev_fd != NULL, ret);
+	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs, ret);
 out_fput:
 	fdput(f);
 	return ret;
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 7346f0164cf4..098beda7601a 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -57,10 +57,9 @@ TRACE_EVENT(io_uring_create,
  * @opcode:		describes which operation to perform
  * @nr_user_files:	number of registered files
  * @nr_user_bufs:	number of registered buffers
- * @cq_ev_fd:		whether eventfs registered or not
  * @ret:		return code
  *
- * Allows to trace fixed files/buffers/eventfds, that could be registered to
+ * Allows to trace fixed files/buffers, that could be registered to
  * avoid an overhead of getting references to them for every operation. This
  * event, together with io_uring_file_get, can provide a full picture of how
  * much overhead one can reduce via fixing.
@@ -68,16 +67,15 @@ TRACE_EVENT(io_uring_create,
 TRACE_EVENT(io_uring_register,
 
 	TP_PROTO(void *ctx, unsigned opcode, unsigned nr_files,
-			 unsigned nr_bufs, bool eventfd, long ret),
+			 unsigned nr_bufs, long ret),
 
-	TP_ARGS(ctx, opcode, nr_files, nr_bufs, eventfd, ret),
+	TP_ARGS(ctx, opcode, nr_files, nr_bufs, ret),
 
 	TP_STRUCT__entry (
 		__field(  void *,	ctx			)
 		__field(  unsigned,	opcode		)
 		__field(  unsigned,	nr_files	)
 		__field(  unsigned,	nr_bufs		)
-		__field(  bool,		eventfd		)
 		__field(  long,		ret			)
 	),
 
@@ -86,14 +84,13 @@ TRACE_EVENT(io_uring_register,
 		__entry->opcode		= opcode;
 		__entry->nr_files	= nr_files;
 		__entry->nr_bufs	= nr_bufs;
-		__entry->eventfd	= eventfd;
 		__entry->ret		= ret;
 	),
 
 	TP_printk("ring %p, opcode %d, nr_user_files %d, nr_user_bufs %d, "
-			  "eventfd %d, ret %ld",
+			  "ret %ld",
 			  __entry->ctx, __entry->opcode, __entry->nr_files,
-			  __entry->nr_bufs, __entry->eventfd, __entry->ret)
+			  __entry->nr_bufs, __entry->ret)
 );
 
 /**
-- 
2.25.1

