Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A39D30F46F
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbhBDN74 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236488AbhBDN45 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:56:57 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB033C0613ED
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:05 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id g10so3636579wrx.1
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qIoqyE4Fpaf6vuFNVJumhbJQpn+cWb3TqLJpyRoKHzs=;
        b=lqKHJZOQcNLOnqdiHg6z/2U6Yp0yypEVm13XbVRdYwqmy/xk6kYCuTDyUBLr3XyvWx
         RvyNlcANuQHxNzFRRB6xYuR9ihaWc+LB4UT8pXIJo8G80ncw5LrZ20f8qAQWfpScq0sk
         dJzb4nCfZxFjz+hiyiahxViJ9ikVQlhl4GLBMacI5JYlbA2iuHng6OMBruARDML3ZNRD
         8bRSgiGhD0Fc1NzF9A3OHWdCObi01G02snvSinfNG5GS/u78yRNAybD/qHwediG6BPzJ
         s4DKx9eIJZisthkHNCt/cJdhU1ZLvZ0aFSW2ni2/y0/R33zltgiMMzkeijUF1c/8UnXg
         Pf/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIoqyE4Fpaf6vuFNVJumhbJQpn+cWb3TqLJpyRoKHzs=;
        b=AAqpeEvvXM4CnE1Zc5vRtNhKv/Wo9W6OSdNRnki/mpiwgywIbc3Bq+ptVWR/R2tBhT
         xL1bmbi1z+XdFlUjXf0lxU315ZIck147LyveS3BDfeDj9vT8LDV/tU8uKOWkOMPG/B0K
         0uic6n6PuthGwZQHLfn/z0wYhD+9zVRTMX5+oMEr5diCFyi7UCBVhFxNI5nfivaT5jxJ
         QykXu3imurLLYa/kDdBEMlV3Q+HFLiq7vcJrH6Ib4cYNBvu375QpzldxEzkylBQa7apR
         eO+V/i+EIpSXH9kjozs6mWokoYkeMcC6QahCLaZGJOcgIcS7CzsTi1JggbC7b8rpN6Zw
         wWXQ==
X-Gm-Message-State: AOAM530jizHdQhE9GRDl1ofCBB+1G31m0RbQkTRMhUovBjevtMQnTx/3
        k0OM7J+MqdY6sxYZhSBHXJmiO/2PRg9x9A==
X-Google-Smtp-Source: ABdhPJyF6phh1ujb09DlqxAF8TvUqTT2xLTn8LQul6Nrlt/7+/j9rL1t6NZfQUFFxE8zp0q1B/dIfg==
X-Received: by 2002:a5d:4c4f:: with SMTP id n15mr9621998wrt.124.1612446964786;
        Thu, 04 Feb 2021 05:56:04 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:56:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 05/13] io_uring: further simplify do_read error parsing
Date:   Thu,  4 Feb 2021 13:52:00 +0000
Message-Id: <332f7a77b6790ded4df47b28cd9e60ba849b7de3.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First, instead of checking iov_iter_count(iter) for 0 to find out that
all needed bytes were read, just compare returned code against io_size.
It's more reliable and arguably cleaner.

Also, place the half-read case into an else branch and delete an extra
label.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 866e0ea83dbe..1d1fa1f77332 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3552,19 +3552,18 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
-		goto copy_iov;
-	} else if (ret <= 0) {
+	} else if (ret <= 0 || ret == io_size) {
 		/* make sure -ERESTARTSYS -> -EINTR is done */
 		goto done;
-	}
+	} else {
+		/* we did blocking attempt. no retry. */
+		if (!force_nonblock || (req->file->f_flags & O_NONBLOCK) ||
+		    !(req->flags & REQ_F_ISREG))
+			goto done;
 
-	/* read it all, or we did blocking attempt. no retry. */
-	if (!iov_iter_count(iter) || !force_nonblock ||
-	    (req->file->f_flags & O_NONBLOCK) || !(req->flags & REQ_F_ISREG))
-		goto done;
+		io_size -= ret;
+	}
 
-	io_size -= ret;
-copy_iov:
 	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 	if (ret2) {
 		ret = ret2;
-- 
2.24.0

