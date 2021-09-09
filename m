Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA064058F0
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 16:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345828AbhIIOZV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 10:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbhIIOZP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 10:25:15 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5230EC12487E
        for <io-uring@vger.kernel.org>; Thu,  9 Sep 2021 05:57:08 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id y132so1293906wmc.1
        for <io-uring@vger.kernel.org>; Thu, 09 Sep 2021 05:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W6jz/AypMJxUR1Yp8u3LUs8XEBm3Z+rNfeD6ki4vajo=;
        b=qL2rEyZX5JwIr5HGolKiU0IANiUtA7/1MWdm5RMPA51N9MGbGlzIG+A251/MugDWzB
         hC6NJIO21lX/c4pxGP07U5HX2OHDhe7xaSRaaMIb+mE5SSMg0yKATBjbVWgDcmGqQePA
         Me++ZB4L7ZY2MbNY9u/vHWyd4u+N/dBbVWVxnOV9/UGi1XUDnm/D69KEbmwLtCsMbeWZ
         iv4A7R0y8rW2uTKxl+AuaV2AVFrz5WHqPwYZmOjOoryIZDEk+fBf5m4XOeUi5mTE+y/J
         HrO1QDw12qA4PPEtdVV/GiZO1GDv0D1Lkx9D3dv7KIqK6xuV6S2zT2UVURzqz2FWvdFW
         rBPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W6jz/AypMJxUR1Yp8u3LUs8XEBm3Z+rNfeD6ki4vajo=;
        b=dc5Ib9ahGmu3u98KlW32lDko5JAq8mp1Cw/wAEhL8gA2/UUEgyYOIEQluICg7/8V3r
         +v8w+HQ8E53gPoSbUVRyvU6tAkyBmn5KeUzhjofV0dfGbkponcpEvlA/nEMzY5iy97TG
         8LkvWo+ltYesNrV0bqMx9p+w/xuURcAMtGMxMfFQABIti19qJ/hD+rOHLz7IDan3Qu4u
         uWZVMJZIiya6qdehlxqQgbeuNGw08Xaai8/1zvl2uYkrpexr39ibm8avAnZFyQvuO5i5
         k1RevAcW6OmkdVNhwMnz2UhGO84UCYVYtYXKNMXvyPkCpywWFUUSDavOhhECredgwgpC
         T3sQ==
X-Gm-Message-State: AOAM530nTAikfro2pGnMThCDaKpabzRCmgJrUHSTBryApbVKqeb0IWG4
        GG+f7gzf0/ZclnCoix/fEeM=
X-Google-Smtp-Source: ABdhPJwf9wHu/IIG17WuA0ywWRxrUC3FvAKnxB76XRW3/slFN+pC7xDB3hJM+4ALdxDQGJ2VWfJ9jg==
X-Received: by 2002:a7b:c762:: with SMTP id x2mr2908330wmk.11.1631192226974;
        Thu, 09 Sep 2021 05:57:06 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.167])
        by smtp.gmail.com with ESMTPSA id h11sm2022718wrx.9.2021.09.09.05.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 05:57:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH] io_uring: fail links of cancelled timeouts
Date:   Thu,  9 Sep 2021 13:56:27 +0100
Message-Id: <fff625b44eeced3a5cae79f60e6acf3fbdf8f990.1631192135.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we cancel a timeout we should mark it with REQ_F_FAIL, so
linked requests are cancelled as well, but not queued for further
execution.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aabc2b489831..e6ccdae189b0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1486,6 +1486,8 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 	struct io_timeout_data *io = req->async_data;
 
 	if (hrtimer_try_to_cancel(&io->timer) != -1) {
+		if (status)
+			req_set_fail(req);
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-- 
2.33.0

