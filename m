Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D184A9131
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 00:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356010AbiBCXep (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 18:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356007AbiBCXeo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 18:34:44 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564CBC06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 15:34:44 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id k18so8020610wrg.11
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 15:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m/kvsV2Fw6mBqvpDjxp3WYmDCchAjKBAAZ5SIZ3OfkM=;
        b=mVTIDSi/HCz5S+C4wI3cpowSR+XnVC1Iy3k/8hB7zPVs1EYiOggQF7HGdU0z5aWBmA
         kAoLNuQTMowykTBSGVN0yNNKEbFQyb1MwTP/MyFHMza6Jk+J8AYM059yNc3NsZuy7QF6
         /TE0umdu8aM/OJlafGSO2/bh8Ig+RWXClWYEcS8w6+SOJZZ6vRXDpxBHUmvK3rhDXgrW
         6dODn6ASZUImiHxAkcQHOdSVbHqtC8UoVHCCq9aluIjSNMkuX7F+bkNjHEuSLf0Ic3BB
         ZKyNBf/qMiCmDL0ZmXwl1Xt7k9JnI354RDENmEqfqjmKAYi1dF+7FEzJOZYiWx+wkWLY
         8pDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m/kvsV2Fw6mBqvpDjxp3WYmDCchAjKBAAZ5SIZ3OfkM=;
        b=afaQqQh/Hrk364CbVf1REYOUGhkN8Ka1KVa5Etz3D5XpD6FuBgJ0xyC8bk146QCHoQ
         CdVk8u79e7FXK+dp9RovH9sDfkpPu99YaUAJ1acS3jEbNI8skQQtH8/apITFuUkwKYvr
         uTdZE8g15+nwaiNSeMjthA3U+WMEzwMFvYzbpFa40ACUPamTLmo7QqD1WcDxEm6FqJ6b
         u7CMk3eu8tEPerGhBNpZ76+wn4cRdjRca1k3TFk2fZViBGpLyz//PqoUPaSBbKQPCPoP
         TtdH/2VCetsQ43kGaFF2gbhxORVQ4tb2nZXpFtl6wRaXSXLhjHQbcSpjCHMcEPGXchcu
         5JKw==
X-Gm-Message-State: AOAM533+E/FJH+kgpgurADKCnI7HlHwZVJH2StX8iFc8IoGNTGBqnOe8
        ssZDv8M2WZYI6O7pYut7dd7/Xxst8FlnpA==
X-Google-Smtp-Source: ABdhPJwCqoELBg5vuld6JA93Tu8jpMKQ+Gr+88N9P/mvn7C3jz2EpvjIKmRVJ0xclo3weA98HjTMVw==
X-Received: by 2002:adf:e750:: with SMTP id c16mr179327wrn.431.1643931282795;
        Thu, 03 Feb 2022 15:34:42 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id j15sm148494wmq.19.2022.02.03.15.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 15:34:42 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v5 1/4] io_uring: remove trace for eventfd
Date:   Thu,  3 Feb 2022 23:34:36 +0000
Message-Id: <20220203233439.845408-2-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203233439.845408-1-usama.arif@bytedance.com>
References: <20220203233439.845408-1-usama.arif@bytedance.com>
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

