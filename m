Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AF94FC7FC
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 01:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiDKXLl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Apr 2022 19:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiDKXLk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Apr 2022 19:11:40 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABDB12ACD
        for <io-uring@vger.kernel.org>; Mon, 11 Apr 2022 16:09:25 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s137so12748250pgs.5
        for <io-uring@vger.kernel.org>; Mon, 11 Apr 2022 16:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CO+Eg0RRARhS0rafb9XlSLMpmgYUU0YC8ZMOiYWsyL4=;
        b=u/hHxjiMVvMkqcHxNw0EXaXpL3s3K27FZiOmbVTQj/fOf69cWc89OblArzFy3GiWFb
         urKQNivfV2j7sJSiJ6T+xUzZFUBUz03nbOPlvwa/Y6s/1wye9vFGuiUnxy060vM4Q72v
         uTKiKpWKLgI68DslnmNa8FHR8ROLIUylhvg6nlDSTrLZ/DVI+hB/39NhQI3LKNfmKep1
         vKQu5N+NuFvm6fotALI61vwzPfVnAKzKNC3P//EoWapkWglp51hpBpSqt4ymoO/IFF4B
         zVoEjx0k7govr/JDTAqvtf0kxdvAB76JoYxpAc5z/b061vSONGtRwXPW+ntlge2PzBYk
         MfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CO+Eg0RRARhS0rafb9XlSLMpmgYUU0YC8ZMOiYWsyL4=;
        b=L2cnQ5GHkwBCupIJq9Cs/PdEUmZmnREn5x6niMhJVCEE2RTCfC/I9OLWoj0ZZHF7/B
         MbRp6NtNmmIKw5fN8edeJdqZevGtsWqHd4JsDFJjYv4KoRofMijgA0U7e3/H++jrBRfA
         QO8JoAY+qnQUDBUtocWahCRAWV73KFdMFOf41QZPive6/HYTehHhhupEIPmSuJ0J2uzQ
         UpO1lo44JuaIh3wZNFGBQhdg0aUUszIjADpZatHBreDwCZziNFKLjhlwra95L96+mtN1
         Zmm33+/CyzBFt8Uv2enELtOCB6umZ08HNKj3X0JA3Hh1HptY9RX0S1HaGdzO2pQf8+E+
         Yd/Q==
X-Gm-Message-State: AOAM530e3a3fee7RexDqQR9cz8Rvd/cMuuWHuXhRiowIErGU8+bVI1yK
        Q0RPe1FYIKRA9jL2n9WXxCRHpNot4Y2nZg==
X-Google-Smtp-Source: ABdhPJxozc5dFwBW7WVTe8SKeeGh1QDHbRlBnyMDz1zKHO3mnPyz7+EbL2HEwjiaUpdqiDx6zLzVzQ==
X-Received: by 2002:a63:ed45:0:b0:399:5116:312a with SMTP id m5-20020a63ed45000000b003995116312amr27454129pgk.611.1649718564892;
        Mon, 11 Apr 2022 16:09:24 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5-20020a631045000000b0039d942d18f0sm191614pgq.48.2022.04.11.16.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 16:09:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: io_kiocb_update_pos() should not touch file for non -1 offset
Date:   Mon, 11 Apr 2022 17:09:13 -0600
Message-Id: <20220411230915.252477-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411230915.252477-1-axboe@kernel.dk>
References: <20220411230915.252477-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-1 tells use to use the current position, but we check if the file is
a stream regardless of that. Fix up io_kiocb_update_pos() to only
dip into file if we need to. This is both more efficient and also drops
12 bytes of text on aarch64 and 64 bytes on x86-64.

Fixes: b4aec4001595 ("io_uring: do not recalculate ppos unnecessarily")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f060ad018ba4..b4a5e2a6aa9c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3183,19 +3183,18 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 {
 	struct kiocb *kiocb = &req->rw.kiocb;
-	bool is_stream = req->file->f_mode & FMODE_STREAM;
 
-	if (kiocb->ki_pos == -1) {
-		if (!is_stream) {
-			req->flags |= REQ_F_CUR_POS;
-			kiocb->ki_pos = req->file->f_pos;
-			return &kiocb->ki_pos;
-		} else {
-			kiocb->ki_pos = 0;
-			return NULL;
-		}
+	if (kiocb->ki_pos != -1)
+		return &kiocb->ki_pos;
+
+	if (!(req->file->f_mode & FMODE_STREAM)) {
+		req->flags |= REQ_F_CUR_POS;
+		kiocb->ki_pos = req->file->f_pos;
+		return &kiocb->ki_pos;
 	}
-	return is_stream ? NULL : &kiocb->ki_pos;
+
+	kiocb->ki_pos = 0;
+	return NULL;
 }
 
 static void kiocb_done(struct io_kiocb *req, ssize_t ret,
-- 
2.35.1

