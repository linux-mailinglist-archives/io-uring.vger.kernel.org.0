Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1A6343682
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhCVCDW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhCVCCx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:02:53 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A519C061756
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:52 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x13so14998937wrs.9
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vMMd91PYOtnROWXcWYUQZQzXa3epe1bIuPvlsvAfxxQ=;
        b=Uf17Qu/oguQGCBK0bMkca5zNEck7NHe8UwONHhwbb1Qv4DPm5pMl8QYpAr5iTT0WPA
         u7OZX75uuWamBC7P+UklaMq3YY4yBHB/0VJV+D7tPc2zVebJfmekva3lMJWjW/NuRsMr
         MW2OZp835M5wMYcxrazg46w06Tbtkbsvpg7Vk0IdOV6GtJGRWf94MHcWxdLOGTSCBcOp
         x2IXad7f51Nf2ULWR/+79jHKu/JT1EOjv3qxLcMHYv+03oKNmPSKept8Jp2kx11qXecg
         WCfOdbhL3esDgVV/ysM9gzPm1GeABTxucn0TaA/WiU2j3EUGBCl8G9vd7DpPG61oD7fT
         2EFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vMMd91PYOtnROWXcWYUQZQzXa3epe1bIuPvlsvAfxxQ=;
        b=aMI0I1O/jBr+Ws2WtnA3XI00ykzPDq+MITKtwnnpetR8REqrNuBM38DGfBcn7YOmEJ
         ZttfgUvc+DYLaY5JuPMhHYjNvt5Im0iFU7sRpJj2cQVJL1tTMAPxUJMc0Zdw9NeNrjJ9
         wmwmIfSGGi4Gp57ormi1jjiVWsrIzJgzp5yZAZDkDXoTH2UGgIspU2WW/j9ClwjEiyOd
         jaJMPg4lNhM8CYW3J2ndgylzur5dYph1kc3lC9x12S2EJUYsYHGtg32+E5JQ0QQR/Fue
         UCp3FzUwK6S8CO2ktSmjrNXOHE629s/wwmUIwF+iXTs46pL4quBf4b+trlUPHcYji3J8
         TSjw==
X-Gm-Message-State: AOAM532Ryi56LoI/4R2uT7+FRsrNMUM0HNG/CyICe/5FMt020asENuoF
        3T/47mwWG1hOW8kmxKPkCgPhlVv6xZAE8g==
X-Google-Smtp-Source: ABdhPJxa6GffuTshEvOrQxurBYckFC/ht7EN6pfrZaxpcqQWAjMd+BbaiOV/TVxBD8co5q2cwBGNLw==
X-Received: by 2002:adf:e391:: with SMTP id e17mr15673603wrm.285.1616378571147;
        Sun, 21 Mar 2021 19:02:51 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id i8sm15066695wmi.6.2021.03.21.19.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:02:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/11] io_uring: optimise rw complete error handling
Date:   Mon, 22 Mar 2021 01:58:34 +0000
Message-Id: <d2c892c8e1220976d590584c2070d0a4d0f71277.1616378197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
References: <cover.1616378197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Expect read/write to succeed and create a hot path for this case, in
particular hide all error handling with resubmission under a single
check with the desired result.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 775139e9d00f..481da674c9bf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2530,10 +2530,11 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 
 	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
-	if ((res == -EAGAIN || res == -EOPNOTSUPP) && io_rw_reissue(req))
-		return;
-	if (res != req->result)
+	if (unlikely(res != req->result)) {
+		if ((res == -EAGAIN || res == -EOPNOTSUPP) && io_rw_reissue(req))
+			return;
 		req_set_fail_links(req);
+	}
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_rw_kbuf(req);
 	__io_req_complete(req, issue_flags, res, cflags);
@@ -2550,19 +2551,20 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
-#ifdef CONFIG_BLOCK
-	if (res == -EAGAIN && io_rw_should_reissue(req)) {
-		if (!io_resubmit_prep(req))
-			req->flags |= REQ_F_DONT_REISSUE;
-	}
-#endif
-
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
+	if (unlikely(res != req->result)) {
+		bool fail = true;
 
-	if (res != -EAGAIN && res != req->result) {
-		req->flags |= REQ_F_DONT_REISSUE;
-		req_set_fail_links(req);
+#ifdef CONFIG_BLOCK
+		if (res == -EAGAIN && io_rw_should_reissue(req) &&
+		    io_resubmit_prep(req))
+			fail = false;
+#endif
+		if (fail) {
+			req_set_fail_links(req);
+			req->flags |= REQ_F_DONT_REISSUE;
+		}
 	}
 
 	WRITE_ONCE(req->result, res);
-- 
2.24.0

