Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB6D30B002
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 20:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhBATFT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 14:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhBATEh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 14:04:37 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCC5C0613ED
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 11:03:51 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a1so17840745wrq.6
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 11:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PlAFb8pBDeyKJxfU87K3+CbzhuYhkWzNkKfESAXpbaw=;
        b=DhVPgBAQ7x+ND0oJGmxAevcKgen2++4Nb5FownEca0K7bT027hv0gp5iuQ/rtBCBVC
         rA3+wvX+q216y2lE2xj0Ltc8h/jScbgJbJrEiPoFR+WjxEJSnMBDrkAt9H/fcEby2NWc
         80521serQhB8ySFOAWDFH5vyDgY1E+Zu/Y1c5BOlx9if0hcvHa2cflUwHuoDAqIeMhZ5
         3Ey4VvPxXnzol3R+b2SHD4kZ5eDCt0aZ1ffx6xRlDf1qZMKTCWqHFtNNsj1nFPMn9vpw
         GjCt2yFwAO/DIHFOGGw2gsTIk3wLMpHFvI79/V39v8BIl8G/LohTz2zv/po5VqPcMJTQ
         RpLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PlAFb8pBDeyKJxfU87K3+CbzhuYhkWzNkKfESAXpbaw=;
        b=nnT6pR4pDLE+YykSBUn84fxhyLJWUnCq6ol9KWHS2jrqKJryA3Ik3+wFfXIPjX9mtQ
         vxmkHvnH2kl0bFOdcag3CnvpEkuo9QKdHqBBKEWYXuiY2dkWSz1TGe79wy4IgbIr2a7H
         DnSsbonIpj0CR0D7r9L6osDgaOukg74Op6SjGKZxIekBkIYGzu9yc4I1cc44JYvotLuC
         eKbb1BomtA1tB7WHSsHSy2h40+wCKolMr3hgYSivXlhwR6dxOtjL8rH851HAzdiJUbB2
         uqP/L4SgYrBlkzDdJ3df0XHx/HOFQcMjT2nfmbgWtsHRCfuhcMTh02oXJZo5HLO8Ab9F
         R9og==
X-Gm-Message-State: AOAM531N/7RACDWfHJfme354nmPnGF1S9pCsioxtOuDKPtf89vTlA0U8
        uc8XGpEYgbSdEnbDjD4koD8=
X-Google-Smtp-Source: ABdhPJxRo6yuAi/DQ0ju+48DcVyIOLik8v6R5135Zo5WJP8/htvkdGMJ0U4DXMLwnR2q1ZrsFUbdzQ==
X-Received: by 2002:a05:6000:1374:: with SMTP id q20mr19064695wrz.44.1612206230548;
        Mon, 01 Feb 2021 11:03:50 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id h14sm182728wmq.45.2021.02.01.11.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 11:03:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/6] io_uring: remove work flags after cleanup
Date:   Mon,  1 Feb 2021 18:59:54 +0000
Message-Id: <9329c4fd29793aeb05910f92625d8c62dd7d3312.1612205712.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612205712.git.asml.silence@gmail.com>
References: <cover.1612205712.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Shouldn't be a problem now, but it's better to clean
REQ_F_WORK_INITIALIZED and work->flags only after relevant resources are
killed, so cancellation see them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0ee452d43817..7dc3d4260158 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1374,22 +1374,14 @@ static void io_req_clean_work(struct io_kiocb *req)
 	if (!(req->flags & REQ_F_WORK_INITIALIZED))
 		return;
 
-	req->flags &= ~REQ_F_WORK_INITIALIZED;
-
-	if (req->work.flags & IO_WQ_WORK_MM) {
+	if (req->work.flags & IO_WQ_WORK_MM)
 		mmdrop(req->work.identity->mm);
-		req->work.flags &= ~IO_WQ_WORK_MM;
-	}
 #ifdef CONFIG_BLK_CGROUP
-	if (req->work.flags & IO_WQ_WORK_BLKCG) {
+	if (req->work.flags & IO_WQ_WORK_BLKCG)
 		css_put(req->work.identity->blkcg_css);
-		req->work.flags &= ~IO_WQ_WORK_BLKCG;
-	}
 #endif
-	if (req->work.flags & IO_WQ_WORK_CREDS) {
+	if (req->work.flags & IO_WQ_WORK_CREDS)
 		put_cred(req->work.identity->creds);
-		req->work.flags &= ~IO_WQ_WORK_CREDS;
-	}
 	if (req->work.flags & IO_WQ_WORK_FS) {
 		struct fs_struct *fs = req->work.identity->fs;
 
@@ -1399,12 +1391,10 @@ static void io_req_clean_work(struct io_kiocb *req)
 		spin_unlock(&req->work.identity->fs->lock);
 		if (fs)
 			free_fs_struct(fs);
-		req->work.flags &= ~IO_WQ_WORK_FS;
 	}
 	if (req->work.flags & IO_WQ_WORK_FILES) {
 		put_files_struct(req->work.identity->files);
 		put_nsproxy(req->work.identity->nsproxy);
-		req->work.flags &= ~IO_WQ_WORK_FILES;
 	}
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
@@ -1419,6 +1409,9 @@ static void io_req_clean_work(struct io_kiocb *req)
 			wake_up(&tctx->wait);
 	}
 
+	req->flags &= ~REQ_F_WORK_INITIALIZED;
+	req->work.flags &= ~(IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG | IO_WQ_WORK_FS |
+			     IO_WQ_WORK_CREDS | IO_WQ_WORK_FILES);
 	io_put_identity(req->task->io_uring, req);
 }
 
-- 
2.24.0

