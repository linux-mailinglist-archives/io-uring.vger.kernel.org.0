Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6328D3BEEA2
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 20:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhGGS1b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 14:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhGGS1b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 14:27:31 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D7BC061760
        for <io-uring@vger.kernel.org>; Wed,  7 Jul 2021 11:24:50 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id h18-20020a05600c3512b029020e4ceb9588so4984140wmq.5
        for <io-uring@vger.kernel.org>; Wed, 07 Jul 2021 11:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+HYX85l9YOSXM0enYLzYwDeNAUAO5v7uBwqFqgIsPbM=;
        b=tZ9u3hVBHKbjpm0bVLyW9RDtddu3pSEJn245H+O1rdQXGBDvf2AncEET7/E7AavLO7
         mT7j886r5EbWoa/RoH5u2lgQQTfZ6vsz5t4qurTh1+iX9c44Dv/UnLAuLrWkh5H11afv
         2KNhhPvD3gfxeuYSwmNNX8QKx7dc24A9lJrCKSUrLeZQNHXL8q7kK3Ottir62/Lq1b3a
         eIyGE2adh26lhQ5wPm7VXVC7eHF+04ONI01HCaY8g/bgAimo6GdKGk52SLUd0Wp8oKMq
         f5OywFy1oIc3im7bzoX9yPxzLMxN0hFx/O9eOxLP6ioRuGLbdHBJrBRx+AQ0CtfS4MS0
         uuHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+HYX85l9YOSXM0enYLzYwDeNAUAO5v7uBwqFqgIsPbM=;
        b=ksAbGekfBh1h6eaE5d6O2/PRkjGbAf+pwImUmCaefNdLxvPirIgLBntrsl79RzU7h4
         WxopdYFZlFtKwKbLczgmdJOQzTgMNEmr8vik7wMe78K520D9vFoHIVQ3Xy77iEUPjTFd
         maaIobfD+8PVXYrXAowKaMPP7ewv5Bb9bLDYk5ciTPSYTg3ogxBvicRg7ia03hV4AX3v
         vKiPQNpsWzccImQHG1id4qwo6kJumwEcoWEn93nT+r1wBGvidablutwygDQ8F4fDLRSt
         bbcA0OL3eQGCxlbiY1b+nSbd+dqknxU73/hCscBRBfK/+h+mplaUKHhlysCDDCsz6M2T
         xN+g==
X-Gm-Message-State: AOAM531rubTeZmUVAQvD0id219JF9EXdlMbPRnqfLhDrJhOqS6fU7a+n
        3CHIheKQB+KKLfps2IeUJjw=
X-Google-Smtp-Source: ABdhPJzUJxcInBrm6etQJmAlvidSRoTE6CH55gw7FJ37+NwZ3JIOa1fALfu7VfqqtHwXA9RZzTfuCA==
X-Received: by 2002:a7b:c218:: with SMTP id x24mr385385wmi.177.1625682289127;
        Wed, 07 Jul 2021 11:24:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.206])
        by smtp.gmail.com with ESMTPSA id l2sm19490405wms.20.2021.07.07.11.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:24:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: fix drain alloc fail return code
Date:   Wed,  7 Jul 2021 19:24:24 +0100
Message-Id: <e068110ac4293e0c56cfc4d280d0f22b9303ec08.1625682153.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After a recent change io_drain_req() started to fail requests with
result=0 in case of allocation failure, where it should be and have
been -ENOMEM.

Fixes: 76cc33d79175a ("io_uring: refactor io_req_defer()")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 881856088990..8f2a66903f5a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6019,7 +6019,7 @@ static bool io_drain_req(struct io_kiocb *req)
 	io_prep_async_link(req);
 	de = kmalloc(sizeof(*de), GFP_KERNEL);
 	if (!de) {
-		io_req_complete_failed(req, ret);
+		io_req_complete_failed(req, -ENOMEM);
 		return true;
 	}
 
-- 
2.32.0

