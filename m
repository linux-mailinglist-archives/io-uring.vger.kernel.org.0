Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85543F7CE0
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 21:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242502AbhHYTxI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 15:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbhHYTxI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 15:53:08 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F075C061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 12:52:22 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id f5so1003941wrm.13
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 12:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=face/B+7v7Z3wEwcfdi9Umqk1XXZSzt0loSGBikFleQ=;
        b=pDHS66O1ZotvwoX/ldinK8fnq5fSW3734qFk0cIJ4OqGX6uksy5LENBOamvQObuOwi
         A+0XSM5z+5/2LtwUPuInP+AFwgmF2/I0mY4WZRlrSYp2PYb+dyPo+dD9J3a6+Pf2UKtd
         XJ0BbTkKEkCA/YOPbetcUG2FsN5Cbjud35D4c781nQvicUpTfjpN3qR6fgKMapPo2F59
         ffm5X6PS21Ms/CfYgamuXhLq9FgCL6DWEmaqzAx2e8OSHhRm0D/X79rauHRwDmvy4OoR
         AjTelZfU4GCfcLI1hpWFbBXXZYVP51XvmoVFZTWiXJWwub5JsdcJnCOrZcGuKTonl7Ru
         xquQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=face/B+7v7Z3wEwcfdi9Umqk1XXZSzt0loSGBikFleQ=;
        b=MYwOtsD96XT3i0X4imv1J+kcXTPwXiUygFepivBapDttOnTuI/UbWK74mGPY4mRsnZ
         TCkboN5r0TpdDY6CCRav1+fb/E86Jaqx8x3eQIbtjNoadC7YjVsupjNbcjqHYxm/0ANO
         /f2b0HYoBv0EJNT0dFA1BSMVuw5s9NLpTow7udK4rDe1Bszh0i8oo6oOHIj7J9QDnTrS
         QIrh0h5l5tZQeXzPyP0jTHYwmQObrEskUbqJkTkS+5rCkc0ziHiz1HOsG9fJLx/WwKcg
         oOtVY1SXMB7hqzQ8UnmiId9LU1ggibiKG+Otv5xAOvUYwX1vhfqqGK6RJVS7Rs2YznQc
         NKjA==
X-Gm-Message-State: AOAM531weiv+9uLecMGKQP3Jjhdl13Ne7FBBtv/IXPpcbrLSUxut+Smc
        nSK7vwez33Ik3BTgAuOHdOg=
X-Google-Smtp-Source: ABdhPJyuNO/PLAPb6io94hFo+J8fD+JY1Nm/PnofXMQVIMOBDye/fOGehu/kRjtUoRZE+RDZbPW/Yg==
X-Received: by 2002:adf:c381:: with SMTP id p1mr89857wrf.64.1629921140819;
        Wed, 25 Aug 2021 12:52:20 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id m12sm820386wrq.29.2021.08.25.12.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 12:52:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: add build check for buf_index overflows
Date:   Wed, 25 Aug 2021 20:51:40 +0100
Message-Id: <787e8e1a17cea51ca6301426b1c4c4887b8bd676.1629920396.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629920396.git.asml.silence@gmail.com>
References: <cover.1629920396.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->buf_index is u16 and so we rely on registered buffers indexes
fitting into it. Add a build check, so when the upper limit for the
number of buffers is lifted we get a compliation fail but not lurking
problems.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 712605fd04c2..6112318a770c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10450,6 +10450,10 @@ static int __init io_uring_init(void)
 		     sizeof(struct io_uring_rsrc_update));
 	BUILD_BUG_ON(sizeof(struct io_uring_rsrc_update) >
 		     sizeof(struct io_uring_rsrc_update2));
+
+	/* ->buf_index is u16 */
+	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
+
 	/* should fit into one byte */
 	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
 
-- 
2.32.0

