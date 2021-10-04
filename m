Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003934216EA
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbhJDTFl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbhJDTFk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:40 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9C3C061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:03:51 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id z20so17359499edc.13
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OlSzEC78b2hKJX0lfVQGwxCCk4SLfQdCTbcrSgeGu1k=;
        b=OW0AWfDo0mUGiptRjElzKihbTVC39ohgNH7lyr3tGaz6qylpw26su9kBNQDowske0M
         SJdIIfyEmaFzKBinGXTJ3+se14B7PAgAlRKBbxNuaMS8gAC2dp9SF4rTatndXy51Jgep
         CPuZkIU8r5In/pczOQaiyPcsycif6ztWUGey6ALVgMc1QfW3QqxY/L4jljwFJmklXLVu
         coN7BMd9Vc6FtHWtqkolePOJ5XYny78LAjkVIUXIRes+Wr2AiG9TyIwoYw0TTe4CftFv
         qbMVafP/+HpzP7cMLisirQRSREHA9890DFyK4yzxothb+V72AR7YmHzxMjSZl9xx3O/6
         iC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OlSzEC78b2hKJX0lfVQGwxCCk4SLfQdCTbcrSgeGu1k=;
        b=UScZHtMsZlxzfp5wdQeazjdFjmmGRGUFSFEGer6rbe81XMphaIMi2jDahe2qK6GPCG
         2bno+471//vIba25mc2Whg6E27thR7XMD+TizOpFSFwOI8xRKG7aczyByoaAdtfsGQx6
         jIZi/IQeNisNc+xB3yG1eStZoo+6PbLzUMOMbpxw+s96Qc3NWetfEjGsw2QIzIjdyKHQ
         dxS8cJ0Gnm11choNK5Cx55ZxFq2uM4kxoUZ5/TKUQrdqK+yf0jm+fxVKIIcShKp+4XhW
         6vT6Y0HtDo+1qda2jioYg9evf1UH7WDl6fKDQ68yIneHKBg4BYvvgWh2K37VT6hoTu12
         NcYg==
X-Gm-Message-State: AOAM532FPi3gTQ2/Tibn0rvJ4Uzupv2CkfaBwqk8TrmOSiBpBpaWk7AJ
        vOhRfjMwR3H+IoS8lAydLYeAWpW34s8=
X-Google-Smtp-Source: ABdhPJx/vd+q4ybrymc1PSwn7e2sH7hcelmr7LJo+zznU9DTM615STHqN29ESaFhWFAllSjIpehdPQ==
X-Received: by 2002:a50:cd87:: with SMTP id p7mr20097580edi.294.1633374228641;
        Mon, 04 Oct 2021 12:03:48 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 02/16] io_uring: add more likely/unlikely() annotations
Date:   Mon,  4 Oct 2021 20:02:47 +0100
Message-Id: <88e087afe657e7660194353aada9b00f11d480f9.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add two extra unlikely() in io_submit_sqes() and one around
io_req_needs_clean() to help the compiler to avoid extra jumps
in hot paths.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 970535071564..b09b267247f5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1957,7 +1957,7 @@ static inline void io_dismantle_req(struct io_kiocb *req)
 {
 	unsigned int flags = req->flags;
 
-	if (io_req_needs_clean(req))
+	if (unlikely(io_req_needs_clean(req)))
 		io_clean_op(req);
 	if (!(flags & REQ_F_FIXED_FILE))
 		io_put_file(req->file);
@@ -7201,11 +7201,11 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	unsigned int entries = io_sqring_entries(ctx);
 	int submitted = 0;
 
-	if (!entries)
+	if (unlikely(!entries))
 		return 0;
 	/* make sure SQ entry isn't read before tail */
 	nr = min3(nr, ctx->sq_entries, entries);
-	if (!percpu_ref_tryget_many(&ctx->refs, nr))
+	if (unlikely(!percpu_ref_tryget_many(&ctx->refs, nr)))
 		return -EAGAIN;
 	io_get_task_refs(nr);
 
-- 
2.33.0

