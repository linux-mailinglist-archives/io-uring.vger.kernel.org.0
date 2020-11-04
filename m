Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFD72A6565
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 14:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgKDNml (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 08:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729794AbgKDNml (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 08:42:41 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B200C0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 05:42:40 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id p1so2934962wrf.12
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 05:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=klZXo297+DvfAF2+SYx+b3OGsYgUr6o9sDAAn7EBAgM=;
        b=HZbiP/6SI+lieKKlcG09qkZNL2TSNzo3rCsLH1+ieTLRbkqqKqLw0OiHoFuExoZIfh
         nitqk5UjHAVB72lW6CkiL6wK6/MsD4pGZeZtdxTrVGSnUeF8+/+TnPaemapoFTTfmZK9
         R6egnOiJD1OVQuZeYdnW77D5rGErory6yIM5qDvnr2QRUTPHOrK4AmZDW7SaSWFE8t0J
         BRdlVvKfKYJIA/29QmmVLuIVrzGgmDtuAUTSWis+x/5MVwQb4wjRCoxRmcedpCp+gxI8
         q0uG6nKcR+XRdNAi3d2eVLHilYoDSSc9A9taYBYFgGo92QSILHa8s3WkSb+zU5ikE1k5
         ssmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=klZXo297+DvfAF2+SYx+b3OGsYgUr6o9sDAAn7EBAgM=;
        b=IOSoEKMnlYZRhAvWH+TTomcZz52dCLEmkPwQHawPqoyYtZ8HvrhDk3L5wTSCQeWwIl
         8nPHfy/0avls2UIhCwpdRvv/UA4YqMQTAlebz6sOHB77O0ClIR6molriSyJVMPSxyHru
         8CgxtJY1dSpDmJZv/+wPry6MUUPHYalRAt5avG75npbRJyvIXeJreR2cHs8EKrTlVOTv
         kGH/rc5wtUJQP9aMR9ZDSlL05EtcxduP4Z47w/tlyDocHCLnHzCRXzO7eay/rIVPL6b8
         w8qZpZM4J1XdkAzpmBGQZbj5f7xN2kTHRNyJbakFHz0CoiJN7OciqW8yLSRZ/zVRAr/1
         0esA==
X-Gm-Message-State: AOAM531uIR2TPrqeLMYQrunfOK8W+qMPITli9m9Ea8wuUfLpkNbp4FhM
        /k48NXRwSN3GUCkOPt0BwnUFTcgz0S6nnw==
X-Google-Smtp-Source: ABdhPJzl1m0wqQfZcRp6HNH7f/1+kmFUK7svPDXvPZsPqnCJhBJAoWeDMEkBy6Sa4ZfW/srIaHYQJQ==
X-Received: by 2002:a5d:4dce:: with SMTP id f14mr16855293wru.396.1604497359394;
        Wed, 04 Nov 2020 05:42:39 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id y187sm2263738wmg.33.2020.11.04.05.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 05:42:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.10] io_uring: fix overflowed cancel w/ linked ->files
Date:   Wed,  4 Nov 2020 13:39:31 +0000
Message-Id: <9d97c12a0833617f7adff44f16dc543242d9a1f7.1604496692.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Current io_match_files() check in io_cqring_overflow_flush() is useless
because requests drop ->files before going to the overflow list, however
linked to it request do not, and we don't check them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Jens, there will be conflicts with 5.11 patches, I'd appreciate if you
could ping me when/if you merge it into 5.11

 fs/io_uring.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 09369bc0317e..984cc961871f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1593,14 +1593,29 @@ static void io_cqring_mark_overflow(struct io_ring_ctx *ctx)
 	}
 }
 
-static inline bool io_match_files(struct io_kiocb *req,
-				       struct files_struct *files)
+static inline bool __io_match_files(struct io_kiocb *req,
+				    struct files_struct *files)
 {
+	return ((req->flags & REQ_F_WORK_INITIALIZED) &&
+	        (req->work.flags & IO_WQ_WORK_FILES)) &&
+		req->work.identity->files == files;
+}
+
+static bool io_match_files(struct io_kiocb *req,
+			   struct files_struct *files)
+{
+	struct io_kiocb *link;
+
 	if (!files)
 		return true;
-	if ((req->flags & REQ_F_WORK_INITIALIZED) &&
-	    (req->work.flags & IO_WQ_WORK_FILES))
-		return req->work.identity->files == files;
+	if (__io_match_files(req, files))
+		return true;
+	if (req->flags & REQ_F_LINK_HEAD) {
+		list_for_each_entry(link, &req->link_list, link_list) {
+			if (__io_match_files(link, files))
+				return true;
+		}
+	}
 	return false;
 }
 
@@ -8405,22 +8420,6 @@ static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
 	return false;
 }
 
-static bool io_match_link_files(struct io_kiocb *req,
-				struct files_struct *files)
-{
-	struct io_kiocb *link;
-
-	if (io_match_files(req, files))
-		return true;
-	if (req->flags & REQ_F_LINK_HEAD) {
-		list_for_each_entry(link, &req->link_list, link_list) {
-			if (io_match_files(link, files))
-				return true;
-		}
-	}
-	return false;
-}
-
 /*
  * We're looking to cancel 'req' because it's holding on to our files, but
  * 'req' could be a link to another request. See if it is, and cancel that
@@ -8503,7 +8502,7 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_match_link_files(de->req, files)) {
+		if (io_match_files(de->req, files)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
-- 
2.24.0

