Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077121E2F6A
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 21:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgEZTwL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 15:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389111AbgEZTvi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 15:51:38 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF35C03E979
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:38 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 131so2261083pfv.13
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LpuXvU/PwSGQGjarIP5I58hv7Zj24N1R3UNEgL0jNDI=;
        b=rFyVjlx1z2FAJn581hW2m8bZ9qQeVyi56a/pWp00XB5VUt4lek5ugSoCmtZrlde+kL
         tqa+1PfUl7M2/e9l+7pKHpZQtgFYG4+bog1h7E0GzkngfisOv6OenkOwIP49E+Nby6+f
         n3A60kLcYP3f42QbUwlhziWKSrx9XE0R68EGvyIxzXWOUrQT6B0FfWHTWWDCwdxgu/93
         ZQMy6v5XLA5PHMfQ8913VJLQtb5tlNTD/giDskk7TgQrwjFvlPGLsUSQCT2W4wbP22Be
         mdo47Iq7BMkJzVco7I1VX/a7oWaZcUGsobhAzz8Kq1gdvewllJ0BMVepmGsBwrX++cOp
         OxHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LpuXvU/PwSGQGjarIP5I58hv7Zj24N1R3UNEgL0jNDI=;
        b=k8EdjdVD9TGXDLlJAdnUk4goAosWhEiFES4iLoVUbx22hx3JTnqhCg6z3Kfp/So8gI
         8uSvGPqhdi6ZGkv8uZ/8AeFPO7oYnzPYOIGjaYmeDF0gazVjVHUqIopVAzhnPcHqdmK/
         H2FBLVLcRMSe/MTAwn/H4YrUyCfM9zxZoGuoCcXj8gFwk6YDrajoePvOND6f/7mi967O
         VK/z5DtMeijxXZ3iKZ3K+YZ9LyuOhraxe6g398rsSX7uo2zElbhxYGCJ6uDiLdAPBtnp
         QpXxWSmZpPrwh5BGo2IQrq/aKPH9IsqJNRStqXXQ2WCzLFWaCmCqLPSvZyqAaQm4DLds
         OVqg==
X-Gm-Message-State: AOAM532rJRWfna6azGzrx3DK6AL+2BI2+kkC3C/n7ogW4MKxLle8WalI
        ZTFCjsRXHxQBuUG3XHvcw4J7C+ML4jVMTg==
X-Google-Smtp-Source: ABdhPJxpwoTNNsMNmh/v14vfI6qih++e4eczlzPNldN5B/zhIcZmJK8bBxIbqtxwi5eARBPbplx1tw==
X-Received: by 2002:a62:e408:: with SMTP id r8mr392923pfh.213.1590522697426;
        Tue, 26 May 2020 12:51:37 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:94bb:59d2:caf6:70e1])
        by smtp.gmail.com with ESMTPSA id c184sm313943pfc.57.2020.05.26.12.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 12:51:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/12] block: flag block devices as supporting IOCB_WAITQ
Date:   Tue, 26 May 2020 13:51:19 -0600
Message-Id: <20200526195123.29053-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526195123.29053-1-axboe@kernel.dk>
References: <20200526195123.29053-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/block_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index d1e08bba925a..980cfce01c9a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1851,7 +1851,7 @@ static int blkdev_open(struct inode * inode, struct file * filp)
 	 */
 	filp->f_flags |= O_LARGEFILE;
 
-	filp->f_mode |= FMODE_NOWAIT;
+	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
 
 	if (filp->f_flags & O_NDELAY)
 		filp->f_mode |= FMODE_NDELAY;
-- 
2.26.2

