Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3669932C9A8
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238233AbhCDBKD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351898AbhCDAdA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:33:00 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E581C0613E6
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:21 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u11so15027757plg.13
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MoQbMk5USwjTLblR0eZ/SAdjmFdciURqXY/rz4nuNGM=;
        b=ZcnEm/VHIAHn9zHwIa4wwMBExBaGiLQYAAfMdlviOy1Cj3jCGoepELv8ENanVl40Mh
         OMwuYxyL8p66wLXljoLb/alHBzkIHD3o4ww2stwP7W61/boWoK9UNzO1wpoVDniSGQcu
         +xc32JqZGrMj+/qzvRPnvyLI+qvCw2ukfjm6Z1Fou5ZNr2cJMGz2q9sz2ZEOFgO5HrvK
         W+T8ywwJLdflUfWpo6i00psEdOTLL+WR7n6KHdl9In0+eiuP6Z8WzUQ7qtyRZnq4p6ek
         kteEim+5M+S/7iF8UQiiPr548MP8XwsY8xaRyQ6KCHhM20TTe3L02j6gwrivpNMuUK4R
         68Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MoQbMk5USwjTLblR0eZ/SAdjmFdciURqXY/rz4nuNGM=;
        b=FoMQgzld6kNMtqiDkWWE/3QooV9ipz9XGLNm+Wc4uZLC5Rqlr3yqURiEzFgaHd8E+P
         rWNrSF3KgOLiNpXOzrIV116TNai7EXTQ7neUX+L/eXuP2MOETLfgPxRXNGt9qnlSlXce
         LVltIenzLt8/QqMsXh8l7ZEm88SI0AP7t17wmDMlD5/gwWQuo9D1m8PGCryN6ZBGfZNx
         GH/x8wWsjgzIl4SFjsWcvMph8B3ChrnKZNKQV5cic/5DVQlHlF3OSgrSggw6tAPzyf91
         PKD9ojlhblFULEYtbmGSNWiDYwj6H1TbwumMWGVxSE2rEqKdkLEpaemjo8r+8Uoejo+S
         STcg==
X-Gm-Message-State: AOAM531+6Jb8QawhmL9EiqH57incDgframZW9mcScxnCNBDD3Bf9I+/H
        ITxYm1B5j79QoM/vocWi21L9dJ42zt1wfOXl
X-Google-Smtp-Source: ABdhPJx5BZUtLGPSmIjnehvl15XzaqmmbOuJzrz6lLp17AaIfdDDxF6r7lRpbMIQ8MFkLxcNYmrveQ==
X-Received: by 2002:a17:90b:116:: with SMTP id p22mr1579866pjz.161.1614817640977;
        Wed, 03 Mar 2021 16:27:20 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:20 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 13/33] io_uring: warn on not destroyed io-wq
Date:   Wed,  3 Mar 2021 17:26:40 -0700
Message-Id: <20210304002700.374417-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Make sure that we killed an io-wq by the time a task is dead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f89d7375a7c3..d495735de2d9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7843,6 +7843,8 @@ void __io_uring_free(struct task_struct *tsk)
 	struct io_uring_task *tctx = tsk->io_uring;
 
 	WARN_ON_ONCE(!xa_empty(&tctx->xa));
+	WARN_ON_ONCE(tctx->io_wq);
+
 	percpu_counter_destroy(&tctx->inflight);
 	kfree(tctx);
 	tsk->io_uring = NULL;
-- 
2.30.1

