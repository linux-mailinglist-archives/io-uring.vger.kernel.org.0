Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE8774F922
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 22:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjGKUdi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 16:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjGKUdg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 16:33:36 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66891710
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:33:35 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-682eef7d752so840245b3a.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689107615; x=1689712415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rd5q4QGxS59bSAw+JDmQ90OVbkUJjAQIgvePrWiPffo=;
        b=GDFBVXHrRbHPsPVU4DCmRN6oNIWp52f4jpnmeWVWuO5m92w0TVuR59FJTTN+ga1vtS
         CDq7NW98kbb95PEhjGTPtMyAZ00nxb4mMve2wzye7sZ2Rgos0LiFLINEeUtipY7/lT3C
         zxQJbjNL29IIqWIaMbK/uCju3tUA3gmNKiaaQABjaNlVJO/0oCvZA3bDCqBk8h+J9iTC
         8w2MnI3/l08WbdKv5OTadqfBMma7qlYKK+n7F5Yzrs/rLEOPJPjW/ZMJngZ8uS64+h6m
         9Zv8jBnVRjjg6+bDrfwAd5q4S7p/RFoLs2h4rymbI22cMnbzzvS/A+hx4fdBQ/1hm/1r
         Uy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689107615; x=1689712415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rd5q4QGxS59bSAw+JDmQ90OVbkUJjAQIgvePrWiPffo=;
        b=Vvn8RP1wMTZ8pyHqFXsBwxnSlRgwL+yejt6H8CiNB/6KQ3oFkPcFo9QKXqsmy440Rb
         817nByME2jHKSGWvupQl7yyWd6ihvvKymuUchsGYKgOnmsDFVuV+OYaqX6Dq9MUkYFN3
         1dZI6hgcGJygma4Xqcc1wx9S9gLa00D4374C2UrAkevgc1FH+lv9DLjuwU942L2l/jSl
         GSOt+A4xtrFbuTu7HD2DEWVs8kApYpNyWJwB42BjvlgfVSS7ODemPze5TWKRWPpfuTzR
         h2Oo2x7u9sk1pguDBK0BzYf5qFPSR/ivbLRX3TwFDuVoKyYr2Fip9S51Ic4X4bYzJqsK
         1Mxw==
X-Gm-Message-State: ABy/qLYkFsMM3y5U0EIBzKGsvspWQlsucYfLana4plMJ5+rw+QP9/Rwf
        F63eLkJE3Xjc5+NL+rBk6YNscpp/DmT7FK1DAvs=
X-Google-Smtp-Source: APBJJlHh4R8H8y0q7l/+iJSpHFtPMwjZxdkfJxKb3+C34QPTz5vRIWajkTtepebKwCc5RmqimcURtw==
X-Received: by 2002:a05:6a20:7da6:b0:12f:dce2:b381 with SMTP id v38-20020a056a207da600b0012fdce2b381mr20396148pzj.3.1689107614789;
        Tue, 11 Jul 2023 13:33:34 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fk13-20020a056a003a8d00b0067903510abbsm2108081pfb.163.2023.07.11.13.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:33:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring/rw: add write support for IOCB_DIO_DEFER
Date:   Tue, 11 Jul 2023 14:33:23 -0600
Message-Id: <20230711203325.208957-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230711203325.208957-1-axboe@kernel.dk>
References: <20230711203325.208957-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the filesystem dio handler understands IOCB_DIO_DEFER, we'll get
a kiocb->ki_complete() callback with kiocb->dio_complete set. In that
case, rather than complete the IO directly through task_work, queue
up an intermediate task_work handler that first processes this
callback and then immediately completes the request.

For XFS, this avoids a punt through a workqueue, which is a lot less
efficient and adds latency to lower queue depth (or sync) O_DIRECT
writes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1bce2208b65c..4ed378c70249 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -285,6 +285,14 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 
 void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+	if (rw->kiocb.dio_complete) {
+		long res = rw->kiocb.dio_complete(rw->kiocb.private);
+
+		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
+	}
+
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
@@ -300,9 +308,11 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
-	if (__io_complete_rw_common(req, res))
-		return;
-	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
+	if (!rw->kiocb.dio_complete) {
+		if (__io_complete_rw_common(req, res))
+			return;
+		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
+	}
 	req->io_task_work.func = io_req_rw_complete;
 	__io_req_task_work_add(req, IOU_F_TWQ_LAZY_WAKE);
 }
@@ -914,7 +924,13 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		__sb_writers_release(file_inode(req->file)->i_sb,
 					SB_FREEZE_WRITE);
 	}
-	kiocb->ki_flags |= IOCB_WRITE;
+
+	/*
+	 * Set IOCB_DIO_DEFER, stating that our handler groks deferring the
+	 * completion to task context.
+	 */
+	kiocb->ki_flags |= IOCB_WRITE | IOCB_DIO_DEFER;
+	kiocb->dio_complete = NULL;
 
 	if (likely(req->file->f_op->write_iter))
 		ret2 = call_write_iter(req->file, kiocb, &s->iter);
-- 
2.40.1

