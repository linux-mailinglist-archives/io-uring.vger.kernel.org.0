Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FE833F58C
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 17:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhCQQaS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 12:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbhCQQaB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 12:30:01 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F56EC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:50 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id r8so2075418ilo.8
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jfpct5RnzckZc5wcRLuLI82jDmlQYS7sOuE+ex7y4xQ=;
        b=nKxNdEcC/aMX2kfkPzrel1ZHFdNR4eHJxl8KBiFSlSH6tW0Ra5+Z9y0D2HkfueTd89
         gMNico83MDBNmjhuT/Eo8BSYaNbnt9dyQoLPKij6gZIdw6AeTtHHJVCy5c4IOSS2XO8+
         nUeqwUEPboMKgUCQ7lBrulwLEIrDrLro0fUP+fDIyb2hFguxNw5nfSgtXTTNPfuDdlnG
         X9VkiYW+N+VaxaiYj8wWrpPxfVJGOTp/B8LYE+agwcqHJFIMA02NBY0023d13AV7rHVQ
         SvDvTBcTcJr9OiURQCNWTLXMCi0rkrKeK/YEYcSS8ZgOk8f31Ul26uXO/vyx/ewCktVr
         Hd2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jfpct5RnzckZc5wcRLuLI82jDmlQYS7sOuE+ex7y4xQ=;
        b=gjTaRGcqIXknDwUMpqRIEs7aObGqsbDUewd0TJNudI4ENam9BJqJ9Dg6NEb/wAI6c8
         8npqzRxssB2/979bpIgvi3/1rmv+VFLTe8KK9KgHDWLcszHWCibcFNwhdWk7ObYurc6P
         OAn4g+AD6/vZ9tOKr0Olw64cMHAavN0GKcCuFL3yiP5yQlgZSCy/EV+M/bhmYF+krZWQ
         CreyXr1hF6u5ZNdKQbpasfjIbPMo9xxIn1x/ycKvrKQgqb5cgbZDIFdYa2wNRD8Nn+Hx
         GWN1Exnnl9Qib/Ffc2BLcXPWlNxoNZa7nOCc+n2i9aJhkPzfnXh1Fxt2qkvvenOSB9dM
         unxg==
X-Gm-Message-State: AOAM531RIDR1oiVaT+0L38x5+rSUHYYyvMmtlE2ITFEunQH8qjNsqXBc
        /WV/3qY9XRcwTfGpnxz1jJbJ2KF2+lxE5A==
X-Google-Smtp-Source: ABdhPJw/Av2DHPay+dfbsL492upGE//ss2pxbRQ3cVKJ4hIlyZ6CJe03sFrYh+lpWA3ksvihcq1ExQ==
X-Received: by 2002:a92:ce02:: with SMTP id b2mr8730879ilo.182.1615998589452;
        Wed, 17 Mar 2021 09:29:49 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h1sm11164271ilo.64.2021.03.17.09.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:29:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/9] io_uring: abstract out helper for removing poll waitqs/hashes
Date:   Wed, 17 Mar 2021 10:29:40 -0600
Message-Id: <20210317162943.173837-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317162943.173837-1-axboe@kernel.dk>
References: <20210317162943.173837-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No functional changes in this patch, just preparation for kill multishot
poll on CQ overflow.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c3d6f28a9147..e4a3fa8b1863 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5228,7 +5228,7 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 	return do_complete;
 }
 
-static bool io_poll_remove_one(struct io_kiocb *req)
+static bool io_poll_remove_waitqs(struct io_kiocb *req)
 {
 	bool do_complete;
 
@@ -5248,6 +5248,14 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		}
 	}
 
+	return do_complete;
+}
+
+static bool io_poll_remove_one(struct io_kiocb *req)
+{
+	bool do_complete;
+
+	do_complete = io_poll_remove_waitqs(req);
 	if (do_complete) {
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(req->ctx);
-- 
2.31.0

