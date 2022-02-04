Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180B14A9B73
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 15:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359468AbiBDOvY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Feb 2022 09:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359462AbiBDOvY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Feb 2022 09:51:24 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89C5C06173D
        for <io-uring@vger.kernel.org>; Fri,  4 Feb 2022 06:51:23 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id f17so11859105wrx.1
        for <io-uring@vger.kernel.org>; Fri, 04 Feb 2022 06:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m/kvsV2Fw6mBqvpDjxp3WYmDCchAjKBAAZ5SIZ3OfkM=;
        b=U8a5uvKULW29WgDNmVvh+nRbtIswUa3SQ4qySlVWMlW+aM61ecXxU2MT53lkUDGd8B
         cpMe5Ij5Waf7VTrsXJxP/zGPxYc8DqKobZnVksXUBU3Yo6bifO4BB6y2ZgyCzSlVy2Q/
         wG12GqYgNHGvWzv1GnKm6Y1hRAMRDEvqJ680XT9wfCkl9o0wCuyCU1AN8RMT4fsapznY
         00lOVJ0uYH74taLHib0BFSxJgeTkv84lQSRLqjxRxX864gT//OLxQZyFBaCwrKO9y6eD
         VPfjmzAbQfU3JUkO+kHl7qOOtsXTlJIpmlekpDVQ4WhU92rWZYF8GAPAud300cptu8Jr
         rl0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m/kvsV2Fw6mBqvpDjxp3WYmDCchAjKBAAZ5SIZ3OfkM=;
        b=oW1K+fWpRRy0fKpts4bdiMUMWprkQrnnVV36rCTUMUjyucYaIXeeL6zDnaQAEVThy7
         eSjTB0H3Kg9jfbRJW2tiFr2x6bQ60CH3k9Qdwesy/dlX4IAj7HIuYgY70OdIwxb+Rtyt
         3Kc5SJmLX7yJhiuOa4jtk26MTBSUjfRwitY9M/qdf4kc1npsPTksF0Awzm+1SlTggRt2
         saSMT+2LHvsXIq5XN7csIrchvtEup4t/gDOnL794B6qeb0wRmNZ9CbCG5oYKXK5ccVJa
         F86A+IzkC9CUEerzScvKUjV/ZmdNBJo4Jg/TP4x+I+/Eceguw2rfTgvABknByRJeCZri
         pyrA==
X-Gm-Message-State: AOAM532oCh1ve7+2sf2CSqJjr+/eIzWyn4xxDlSznJ7vp7xgO02XK97E
        5EPxMcjOJExU42hwFlGKsYPYEcgmhMNTMg==
X-Google-Smtp-Source: ABdhPJycijml2DzFeokJ4zrRH7pCBK74aSNf5O9gpSPx9wDfcLqCAh87qk99xXm3hqOr/UuaYTPnCg==
X-Received: by 2002:a5d:5049:: with SMTP id h9mr2781950wrt.502.1643986282275;
        Fri, 04 Feb 2022 06:51:22 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:e94c:d0f2:1084:a0d3])
        by smtp.gmail.com with ESMTPSA id c11sm2552898wri.43.2022.02.04.06.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 06:51:22 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v6 1/5] io_uring: remove trace for eventfd
Date:   Fri,  4 Feb 2022 14:51:13 +0000
Message-Id: <20220204145117.1186568-2-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220204145117.1186568-1-usama.arif@bytedance.com>
References: <20220204145117.1186568-1-usama.arif@bytedance.com>
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

