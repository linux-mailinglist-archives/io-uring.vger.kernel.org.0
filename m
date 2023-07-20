Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2862075B646
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 20:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjGTSN1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 14:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjGTSN0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 14:13:26 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016842712
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:24 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-34637e55d9dso1179245ab.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689876803; x=1690481603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Rz0NMHvZQNALkINTruLCMRwh4c7Tji4y7FPdIx8g4g=;
        b=pC3mUm4RVW6tBqU5UJQyCuZiTop8FqYLfUfiOaIDZ920FVRqxCGgm6MU8r0yEoguGw
         dywBShB6sVkhWu7D9pHri/wY+jOZ7w+m0tEAymA35MnsiaYYQ+bl6hDigGzUFnKFBuSN
         wtocR8b6OzHEgeb3Gbs3Qaj5C1yutuCYZUTB4hORCsdq1wdovSOhXHt9U8kmnVPpe5WG
         kvOhXLYFrlz+oAomG+rQX+RqBZMjDJSVMkpmi4ZaVelzk/t08XsS4yG+BuJi/6oVbGQS
         CTqPyL67wiFK3FHgDUP2m0umwWyMpW0N54FGolmXK5t+C38uKHjkAfV/7N68q3RvyZBw
         u1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689876803; x=1690481603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Rz0NMHvZQNALkINTruLCMRwh4c7Tji4y7FPdIx8g4g=;
        b=YOfFbBBGTFTxKjkb7XZZEezYzwZfJtJmR89vZU89p3RRVOR4d/zysuVcTYsKToaIs5
         1l53gUr/3WBahApMy932x6PaG8XSIHPqM2cybjp0TljUhiCobzUfDFez80i2O8KIblMs
         rD6OPG95YLj3tEyfVXfd13+PKF9fYzXCi49eg2kaZCM81cHq8fJJ86mKti87GGgfOEj/
         Hvt5mZITeMeyFUGf+dTZg8yl1MjVKBQmuM1+LCKRZUCWa/S86y17Y4BCQS93BHK4LyS0
         ofxlCg8LkPd/5P93Pze5ctuMHN/lDKK3oCDQb+pDNc8x6afcq7RNSMQm+k4ufJkHCv1L
         eE4w==
X-Gm-Message-State: ABy/qLbCiY80GkVdsdGRkrJmHJBrJAjMI3SUsJPCiyNQrUVFuC76UMbQ
        3WBWhXBep+Khr1tSdjqV0ZINAd5EVqm5+KMkH+g=
X-Google-Smtp-Source: APBJJlG3tfXHp5O7/DHLO/fhFJiSIsSJYxb7x8KI1mhJgfwWdkVNGtjtcnQdJxiX2OOGG55ww6XAkw==
X-Received: by 2002:a05:6e02:17c8:b0:346:4eb9:9081 with SMTP id z8-20020a056e0217c800b003464eb99081mr12451859ilu.3.1689876803715;
        Thu, 20 Jul 2023 11:13:23 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v6-20020a92c6c6000000b003457e1daba8sm419171ilm.8.2023.07.20.11.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 11:13:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] io_uring/rw: add write support for IOCB_DIO_DEFER
Date:   Thu, 20 Jul 2023 12:13:09 -0600
Message-Id: <20230720181310.71589-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720181310.71589-1-axboe@kernel.dk>
References: <20230720181310.71589-1-axboe@kernel.dk>
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

Only do this for non-polled IO, as polled IO doesn't need this kind
of deferral as it always completes within the task itself. This then
avoids a check for deferral in the polled IO completion handler.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1bce2208b65c..f4f700383b4e 100644
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
@@ -916,6 +926,17 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	kiocb->ki_flags |= IOCB_WRITE;
 
+	/*
+	 * For non-polled IO, set IOCB_DIO_DEFER, stating that our handler
+	 * groks deferring the completion to task context. This isn't
+	 * necessary and useful for polled IO as that can always complete
+	 * directly.
+	 */
+	if (!(kiocb->ki_flags & IOCB_HIPRI)) {
+		kiocb->ki_flags |= IOCB_DIO_DEFER;
+		kiocb->dio_complete = NULL;
+	}
+
 	if (likely(req->file->f_op->write_iter))
 		ret2 = call_write_iter(req->file, kiocb, &s->iter);
 	else if (req->file->f_op->write)
-- 
2.40.1

