Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327A138080F
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 13:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhENLIL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 07:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhENLIK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 May 2021 07:08:10 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7F4C061574
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 04:06:58 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n2so29737172wrm.0
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 04:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C7HA2mxb1CmfsNPe9TxX16VXUrE+YBOYQdbQwETx7hg=;
        b=icHuuyn26JyzUefekoCpoCAkAZht8q2O8t4p5droiupFJnuIAO1aKTEsPOQK0kbFJ9
         D+FDcxOQdlCAv5EWV+Y8jTb/i949OJL2ZZ5CuunVovZfbqEA/bDB1h5KfCGLk7aubQwQ
         /ODhbIA3fouHipHTo928dDISzgPGI2oAlTTvg9g3PhHqwm/w8oy1UtlPoQx4QDdVS2NV
         hYrPhSW3NrHfV0yAIJ9wGvuGGTxZzJ8X/GT9jid8Oj98P06UOjmzW8/LZMjAFVsnAihs
         zN5iKquy07BfSrp3jpFBUu2FX3vMwWM25HdzRC3uT/PCfBTwSdqGNiHmm80mwbgBN1x3
         NFTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C7HA2mxb1CmfsNPe9TxX16VXUrE+YBOYQdbQwETx7hg=;
        b=I8G4A+7xN1EOlRXhFQtB9RaMhl3QQ+9BZfpQkJDGiGOe9sXkCbOATL4YskLyCTI9np
         mxkNJcyKLpFKwyFnFjG9Kwo2boe+rGrllVwBTGnBuWdE2NGtb1yrypbOR/IAqTofdsTz
         fOBQVyJoVpTP0tVoJKrUDki9/Z5rHdXivCm9R8yOeq6yROBCnUAdpybbwHhJAfaHSvMA
         hVefKo0PWtUFRtCteB03baAW6Cp1D4GNLjF+5Wd0dme5l+oUkAN59ebfklKbNqN9Lsyq
         +mt9AfkAmTUKxhRPNw6mjkKFqnPSkk470GsI6/XpupIbp0EDKkoH+PkoKaIVGOEGuhg0
         qmLQ==
X-Gm-Message-State: AOAM532TDZ0AptPuYs/LFSyhpytxXxdigNouwU3PemYwuZhVts/zJ6Bv
        gpWSY1FNNPU8CBSG6nSB+dg=
X-Google-Smtp-Source: ABdhPJyg4dySDLYPomzD1RGSxDd0XtM8ycTGLsuVjuS+1SSezdxySE7pYAssgL7ffmEvjyPp52P+Pg==
X-Received: by 2002:a5d:64c7:: with SMTP id f7mr56945122wri.257.1620990417001;
        Fri, 14 May 2021 04:06:57 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.196])
        by smtp.gmail.com with ESMTPSA id n2sm6007326wmb.32.2021.05.14.04.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 04:06:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: increase max number of reg buffers
Date:   Fri, 14 May 2021 12:06:44 +0100
Message-Id: <d3dee1da37f46da416aa96a16bf9e5094e10584d.1620990371.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since recent changes instead of storing a large array of struct
io_mapped_ubuf, we store pointers to them, that is 4 times slimmer and
we should not to so worry about restricting max number of registererd
buffer slots, increase the limit 4 times.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9ac5e278a91e..8f718d26f01c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -100,6 +100,8 @@
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
+#define IORING_MAX_REG_BUFFERS	(1U << 14)
+
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
 				IOSQE_BUFFER_SELECT)
@@ -8390,7 +8392,7 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	if (ctx->user_bufs)
 		return -EBUSY;
-	if (!nr_args || nr_args > UIO_MAXIOV)
+	if (!nr_args || nr_args > IORING_MAX_REG_BUFFERS)
 		return -EINVAL;
 	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
-- 
2.31.1

