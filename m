Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5B96D0B60
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 18:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjC3Qd7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 12:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjC3Qd6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 12:33:58 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03905CA1D
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 09:33:51 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id v5so7523396ilj.4
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 09:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680194030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SjVQ/bG02tsB8OqOC7OyHQuyMXW82HwVXzlna4p/ebk=;
        b=bZAm7OCCB4x3XZbQ8xWIQYh/10DFjxMgsEeK+t0uY4PIrKh5HjJ0hpM8DIbbOzN/V+
         PufrnnF3sQLjnh/QeLyWNIHeN16mKddxhEue3pqXGGxgrjhz/oJnNPMO52RfokO+sabQ
         V5N2oH2bkyAxneRBdOIq+jx4VcSARiMN/xnwao/vSbeUIga8zTpuRsGkUCrAjvBvAcgZ
         XkCURIEFuha0xIZCtp1AUATvokJ7FHA2BZxVIF3W+Gsh9XhoEjmSY0r4MP2HdWzDs5YC
         sEv204DGKoaOZeOXw4aOPTxuhgDr6AMahuLrJmXlgGEoohp4/O/oQR+33UqcDr76NSOA
         ee2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680194030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SjVQ/bG02tsB8OqOC7OyHQuyMXW82HwVXzlna4p/ebk=;
        b=htHApZi7ljA6DmqoOKG6ZHm24W5eC86TmCAb5rVbo95WAY1+Amx1ZT7w5SyuR0o+c4
         ko/6wElqcSF+WZ+I+Gyn9uF2J8MqmOtrwHrXXUfn3Oi1vnaeXVEMjo9w/0wyXhbVC8/f
         tcYlZm3lW0BdSD/iGZ1vrVS3e99rSs8qhRx0+9eALI50y18bm+Uew85bjbZKzh5IN7zz
         xVd4fsbUGxFNuebkvf3NPLO9OvFclErmTsnZ2INROZOgaD+w6n4niY4aX7sdw3uj4rCz
         CFIiVdgBtGf65j5hPJgk2z/uIV4kpWn3uxwafIEyvJMW+RYxJsCC9AOCeAtYlzzATxPr
         3arg==
X-Gm-Message-State: AAQBX9dYMOnekeHztn4eV5ItVgfH8pq4azV3mvvw8Gf70RqLa3KqueUD
        2H0x2Rv6prlk78WdqjmF9ftqS9G4xPb+mvoHrpUM9w==
X-Google-Smtp-Source: AKy350asoztkNR6UrMijTPN7ZKGFqYig4Z19Ua2yxAGwdQttaEpacWdTWSF8X+FmizUtuHkagEzbBA==
X-Received: by 2002:a05:6e02:156b:b0:326:218d:6c14 with SMTP id k11-20020a056e02156b00b00326218d6c14mr1809518ilu.1.1680194029866;
        Thu, 30 Mar 2023 09:33:49 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h21-20020a056638339500b003ff471861a4sm19099jav.90.2023.03.30.09.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 09:33:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: rename trace_io_uring_submit_sqe() tracepoint
Date:   Thu, 30 Mar 2023 10:33:45 -0600
Message-Id: <20230330163347.1645578-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230330163347.1645578-1-axboe@kernel.dk>
References: <20230330163347.1645578-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It has nothing to do with the SQE at this point, it's a request
submission. While in there, get rid of the 'force_nonblock' argument
which is also dead, as we only pass in true.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/trace/events/io_uring.h | 15 ++++++---------
 io_uring/io_uring.c             |  3 +--
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 936fd41bf147..69454f1f98b0 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -360,19 +360,18 @@ TRACE_EVENT(io_uring_complete,
 );
 
 /**
- * io_uring_submit_sqe - called before submitting one SQE
+ * io_uring_submit_req - called before submitting a request
  *
  * @req:		pointer to a submitted request
- * @force_nonblock:	whether a context blocking or not
  *
  * Allows to track SQE submitting, to understand what was the source of it, SQ
  * thread or io_uring_enter call.
  */
-TRACE_EVENT(io_uring_submit_sqe,
+TRACE_EVENT(io_uring_submit_req,
 
-	TP_PROTO(struct io_kiocb *req, bool force_nonblock),
+	TP_PROTO(struct io_kiocb *req),
 
-	TP_ARGS(req, force_nonblock),
+	TP_ARGS(req),
 
 	TP_STRUCT__entry (
 		__field(  void *,		ctx		)
@@ -380,7 +379,6 @@ TRACE_EVENT(io_uring_submit_sqe,
 		__field(  unsigned long long,	user_data	)
 		__field(  u8,			opcode		)
 		__field(  u32,			flags		)
-		__field(  bool,			force_nonblock	)
 		__field(  bool,			sq_thread	)
 
 		__string( op_str, io_uring_get_opcode(req->opcode) )
@@ -392,16 +390,15 @@ TRACE_EVENT(io_uring_submit_sqe,
 		__entry->user_data	= req->cqe.user_data;
 		__entry->opcode		= req->opcode;
 		__entry->flags		= req->flags;
-		__entry->force_nonblock	= force_nonblock;
 		__entry->sq_thread	= req->ctx->flags & IORING_SETUP_SQPOLL;
 
 		__assign_str(op_str, io_uring_get_opcode(req->opcode));
 	),
 
 	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, flags 0x%x, "
-		  "non block %d, sq_thread %d", __entry->ctx, __entry->req,
+		  "sq_thread %d", __entry->ctx, __entry->req,
 		  __entry->user_data, __get_str(op_str),
-		  __entry->flags, __entry->force_nonblock, __entry->sq_thread)
+		  __entry->flags, __entry->sq_thread)
 );
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 536940675c67..775b53730c2f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2305,8 +2305,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(ret))
 		return io_submit_fail_init(sqe, req, ret);
 
-	/* don't need @sqe from now on */
-	trace_io_uring_submit_sqe(req, true);
+	trace_io_uring_submit_req(req);
 
 	/*
 	 * If we already have a head request, queue this one for async
-- 
2.39.2

