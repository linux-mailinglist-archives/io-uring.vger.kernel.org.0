Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2114A88E6
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 17:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbiBCQpJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 11:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352214AbiBCQpI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 11:45:08 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3224EC06173E
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 08:45:08 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id l25so6114914wrb.13
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 08:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m/kvsV2Fw6mBqvpDjxp3WYmDCchAjKBAAZ5SIZ3OfkM=;
        b=TpJ71uRiEcpohrFxrNmCbljUwaOTD+Kmc+G+3Nzu3r2xGhvjUYCKulLZGZx2QnaJo5
         mdeK1bKmrPd5RwgLPK5qMM1PlgFV/wmJAPWzxQjZm/TDfCn4vVJLJp0gylfTFRr8QBSW
         ApHNp90a1BIz24xD2lLuwtO8p1u3VCle46xvXffAy5YDAkFwCGTt0vaXJMaAE/KaPoaw
         i9d2ITJfkD4Sn42ob8o0b1l7w+xCKuryTd83VRZbcRnx9LnT1iU32kalQYqHwI58taMw
         4aDBQBaE77SNtDCawE6ftrLI7nQ6/w6akHpU+aNbOB+1gfy4nTI5gC2OJRujQowcGDvP
         VUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m/kvsV2Fw6mBqvpDjxp3WYmDCchAjKBAAZ5SIZ3OfkM=;
        b=kQdKgbUIQmGToy4iJ1pFUHdCNUZ+kQj89GgcjNYWyGvU6zy73UGQbO8OuAhMuETq+h
         1A/OXFPS+0+Ws3iHsPqQ0O1dVqbqalvhAxauOxNDiUig5L8747UiiJJVCfsohlPDV46d
         oUx2nnOhxaUqibgKqmD5OXqmkRGuhgu8Lt7DiMt3mKSUTF1dlWD6VJuDACsldNE4XISD
         +epyEWJY9LgV8bTZ42yrmcWxoaKwHe7QumwIVFQauug6gE1L822kkVEAP5kImEFYt35O
         ULXZizIBqgiFp770cNsZyn3Ld+tc+azA341MDkSAh8yFXdd2Rp2EL+Nq/+kMAQgI9Vma
         nydA==
X-Gm-Message-State: AOAM530CQOeoKoofFD0GPwZE9dL9FzR0nU5IVW73hUyslz4mgYMQWxEu
        bOfAtXv9/a4H7qc5v6o0tDnM33/99M/A+w==
X-Google-Smtp-Source: ABdhPJyrgX5d0YA9/YSpggnjjJrDZRSzSNvZW9tVt0J0vgBrvCTUYxETA6MH9IEyJyb4HAPYYP+YKA==
X-Received: by 2002:a5d:6d03:: with SMTP id e3mr29538181wrq.41.1643906706737;
        Thu, 03 Feb 2022 08:45:06 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id n14sm21412831wri.80.2022.02.03.08.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 08:45:06 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v2 1/3] io_uring: remove trace for eventfd
Date:   Thu,  3 Feb 2022 16:45:01 +0000
Message-Id: <20220203164503.641574-2-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203164503.641574-1-usama.arif@bytedance.com>
References: <20220203164503.641574-1-usama.arif@bytedance.com>
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

