Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C63B36172B
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 03:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbhDPBZ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 21:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236090AbhDPBZz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 21:25:55 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30779C06175F
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 18:25:30 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id p67so12327447pfp.10
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 18:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OtaAlLd049P6eFcJ2nT5D877je7FAgaVRpSGLucJ42E=;
        b=wM7VXBJWrWiZ/rRB2QBcSBB6h0DnKZciP20MxW9lFCZT03xCaAwESn1txRAetYvuUk
         /6scz9ZT0gOyq088yYHEPDm2Tg611zYAw2CV+A4ZXjysO4blKrIW4AUv8NZQ4yjyrL81
         11Fv2DVVuCHX0oCVGyeYPRudnqsfnvC4vfh96+/emRcTwCnblX7UtFUYWqaloMyvk5eY
         4bhiimE8NcSsTzjW8KXNGekcCf3ZDzDZOfJ71ZnOD8EwTC/ZYVRuHwp5rvo6N7172LvN
         JZEg7R8R+fZS7E0i1KgWOknklb5Aze/YKITuWjQ21pG1CFYso/kfgeOWlA+dNpJITaA6
         Xvuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OtaAlLd049P6eFcJ2nT5D877je7FAgaVRpSGLucJ42E=;
        b=OozX/ZgSOFljZsS8Jh0NUyBRpAd1fld5NJN7R4QyftiCoT1rYhlZmu6ry5RH9SN0ih
         ug1FThstEtWoBaZtlUvmf+9qchlVTk9S3SkdB65ldDO3NO8TgsuXeVQkQ8rKTDZRNRS8
         U4L/8n9cqrHT7KhGEx5ChdlGgppbrult5Q1kDt81RStIRMDbzE3kQkot6LL/PpwKd9RX
         4179dIBgVuk0NraM22FcXkxHD88f6sJrD1v3wMaEdbORSkM2b0Xv/TZroRCXa71ZWR6u
         p9T7SyGeBFkcrtepTQBItdG9JEuqllQTtNsy4mEHosCbLGn8uOktwHCR16W8ilsbFK6p
         GeAw==
X-Gm-Message-State: AOAM532CrJfPh5NHpIMseP18b4h6OwmRZV7eOWbCpYrulzwX+U3x8wRw
        xKUNsNKOZMwbRsk22/LBLgWvVz2R+uTz6A==
X-Google-Smtp-Source: ABdhPJyq6t7GJ25ZJBSl0eyoEj9WlTUBI9Mo4wVboZ/D2p0YFf+QQDxm6k0BsyTK8qYtBasFeE3fZA==
X-Received: by 2002:a62:ab11:0:b029:242:4c58:d46b with SMTP id p17-20020a62ab110000b02902424c58d46bmr5525743pff.15.1618536329488;
        Thu, 15 Apr 2021 18:25:29 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g17sm3502039pji.40.2021.04.15.18.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 18:25:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: put flag checking for needing req cleanup in one spot
Date:   Thu, 15 Apr 2021 19:25:22 -0600
Message-Id: <20210416012523.724073-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210416012523.724073-1-axboe@kernel.dk>
References: <20210416012523.724073-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have this in two spots right now, which is a bit fragile. In
preparation for moving REQ_F_POLLED cleanup into the same spot, move
the check into io_clean_op() itself so we only have it once.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 87ce3dbcd4ca..a668d6a3319c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1601,8 +1601,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 static void io_req_complete_state(struct io_kiocb *req, long res,
 				  unsigned int cflags)
 {
-	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
-		io_clean_op(req);
+	io_clean_op(req);
 	req->result = res;
 	req->compl.cflags = cflags;
 	req->flags |= REQ_F_COMPLETE_INLINE;
@@ -1713,16 +1712,12 @@ static void io_dismantle_req(struct io_kiocb *req)
 
 	if (!(flags & REQ_F_FIXED_FILE))
 		io_put_file(req->file);
-	if (flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
-		     REQ_F_INFLIGHT)) {
-		io_clean_op(req);
+	io_clean_op(req);
+	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_uring_task *tctx = req->task->io_uring;
 
-		if (req->flags & REQ_F_INFLIGHT) {
-			struct io_uring_task *tctx = req->task->io_uring;
-
-			atomic_dec(&tctx->inflight_tracked);
-			req->flags &= ~REQ_F_INFLIGHT;
-		}
+		atomic_dec(&tctx->inflight_tracked);
+		req->flags &= ~REQ_F_INFLIGHT;
 	}
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
@@ -5995,6 +5990,8 @@ static int io_req_defer(struct io_kiocb *req)
 
 static void io_clean_op(struct io_kiocb *req)
 {
+	if (!(req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP)))
+		return;
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
 		switch (req->opcode) {
 		case IORING_OP_READV:
-- 
2.31.1

