Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230B85B3618
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 13:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiIILOA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 07:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiIILN5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 07:13:57 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1807E129C70
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 04:13:55 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id n17-20020a05600c3b9100b003b3235574dbso1050921wms.2
        for <io-uring@vger.kernel.org>; Fri, 09 Sep 2022 04:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=JmeqzBQ2HK7QFUn0X6iaRb/b0wFKIR1YqJfN7j630qQ=;
        b=faEZ+T6K2RrRI4AwWwRBsP/qnB2rqTglyms5m0dVSqU4lUc4WkfeK26U0b5+tDvbIR
         eBZL/xray3VOYS9qmkuZRAIpbAnqO+MoBje1d18gIPDBIOOYdIhSwNiyv8aMXxjwEQ8n
         5AbnEzdG/BhLTNLknIZAr+NpI8684ocPCcBF4oG/f9xXfKSV/46/W5K2yKehbGXLKGz9
         dSuam+qXIvnVBjwk+sS7DwotHpbX1G+83cWoEPB+ipIsfxoRjb2XQxf/EdwYekKW7zu9
         vd+zmpxK9BgpPLFDRovA+IC0hLKDOuM6cXtKPJX2IEH4T9Id/JV2x2QakR/oUAbJFQie
         x2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=JmeqzBQ2HK7QFUn0X6iaRb/b0wFKIR1YqJfN7j630qQ=;
        b=hmJ3veMdELsqA1m+j7CbtZm/3WEEKfWC9v07++e91fyKoncNGR9rbZm9XKSpL5Wxez
         +BEKE8IIJvH4lWowYger2hjo5zaQovYVfQzYsvNVQcBO2GtXZdgWX6CL0PsiQUsRAbou
         yXSPS0sIhzYMOBu5798OSn91iaJxHnRzD9MBXNlvWm5tMXCR8ZOWRFznV/otlrEOGbJp
         MLY8rYXXT8T7afjPoNO0QvhJ+CMlDPchJs4Eiu5l3uUrbSnpJjplIZ016GjEkmUSaXGM
         3dqqqqJ3LCEAEEac5z8w6U4DWpWpUR+FIWnSkBUeztxX9lgT/mysPOM+SC0GiYB1Sz2+
         3K3Q==
X-Gm-Message-State: ACgBeo0iqpgp5nbHJKY+RCE3Yc30gw1vSz6oaMnsTGKStTfqSNk30kis
        /U/jPThwazsrMfbeJF74gvoXfWNoM4k=
X-Google-Smtp-Source: AA6agR40yyV1/13Pa4XcW69mz0SugDTLtwbtyni4Yv3yMzogSDZ4dOoQD0iRykeOuWJTiQLL/o74gw==
X-Received: by 2002:a05:600c:1d12:b0:3a5:eb79:edc3 with SMTP id l18-20020a05600c1d1200b003a5eb79edc3mr5124320wms.136.1662722034009;
        Fri, 09 Sep 2022 04:13:54 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-228-197.dab.02.net. [82.132.228.197])
        by smtp.gmail.com with ESMTPSA id m6-20020a5d6a06000000b0021badf3cb26sm315170wru.63.2022.09.09.04.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 04:13:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.0] io_uring/rw: fix short rw error handling
Date:   Fri,  9 Sep 2022 12:11:49 +0100
Message-Id: <89473c1a9205760c4fa6d158058da7b594a815f0.1662721607.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

We have a couple of problems, first reports of unexpected link breakage
for reads when cqe->res indicates that the IO was done in full. The
reason here is partial IO with retries.

TL;DR; we compare the result in __io_complete_rw_common() against
req->cqe.res, but req->cqe.res doesn't store the full length but rather
the length left to be done. So, when we pass the full corrected result
via kiocb_done() -> __io_complete_rw_common(), it fails.

The second problem is that we don't try to correct res in
io_complete_rw(), which, for instance, might be a problem for O_DIRECT
but when a prefix of data was cached in the page cache. We also
definitely don't want to pass a corrected result into io_rw_done().

The fix here is to leave __io_complete_rw_common() alone, always pass
not corrected result into it and fix it up as the last step just before
actually finishing the I/O.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1babd77da79c..1e18a44adcf5 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -206,6 +206,20 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
+static inline unsigned io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+{
+	struct io_async_rw *io = req->async_data;
+
+	/* add previously done IO, if any */
+	if (req_has_async_data(req) && io->bytes_done > 0) {
+		if (res < 0)
+			res = io->bytes_done;
+		else
+			res += io->bytes_done;
+	}
+	return res;
+}
+
 static void io_complete_rw(struct kiocb *kiocb, long res)
 {
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
@@ -213,7 +227,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 
 	if (__io_complete_rw_common(req, res))
 		return;
-	io_req_set_res(req, res, 0);
+	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	req->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(req);
 }
@@ -240,22 +254,14 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		       unsigned int issue_flags)
 {
-	struct io_async_rw *io = req->async_data;
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-
-	/* add previously done IO, if any */
-	if (req_has_async_data(req) && io->bytes_done > 0) {
-		if (ret < 0)
-			ret = io->bytes_done;
-		else
-			ret += io->bytes_done;
-	}
+	unsigned final_ret = io_fixup_rw_res(req, ret);
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = rw->kiocb.ki_pos;
 	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
 		if (!__io_complete_rw_common(req, ret)) {
-			io_req_set_res(req, req->cqe.res,
+			io_req_set_res(req, final_ret,
 				       io_put_kbuf(req, issue_flags));
 			return IOU_OK;
 		}
@@ -268,7 +274,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		if (io_resubmit_prep(req))
 			io_req_task_queue_reissue(req);
 		else
-			io_req_task_queue_fail(req, ret);
+			io_req_task_queue_fail(req, final_ret);
 	}
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
-- 
2.37.2

