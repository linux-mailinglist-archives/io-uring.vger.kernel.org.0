Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0092AA54D
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 14:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgKGNTk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 08:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgKGNTj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 08:19:39 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C72C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 05:19:39 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id p8so3305979wrx.5
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 05:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BnfWkPrM2WCZsGtqmyL4AZX62AJtwrhXKuGMF/TuQzg=;
        b=iDtTe+GXu7wo9EtDYoHEJYh6PVEawlspfv6Su0XfSTmWRXjBY11Sb2QDAAh2TrJwx8
         glA8GC9Dqoeie0wKCGzDoNFFcRaS7eRli6H9e1gzRVRSBvta3zH2n01XDgPnY6FPiGaq
         wcRyq4YlZJqUG1M2Xux9nh50O/EiV40bUrOfVLlo6pVgMIgf/0MFC8y+DdTpmm6r+E/k
         YjIntJpHZTRwXOtKKVNAMAW4OFCJhqeVrj/p0KuySu+cCva2rvUAEGbZmpoykbDuE6bR
         sqOiBf3WIrwARou1cvJkjWUcsnDquPLHG15MLBIciVuU6jOSGsCrpWG4qS8sjK0UuBuM
         bhmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BnfWkPrM2WCZsGtqmyL4AZX62AJtwrhXKuGMF/TuQzg=;
        b=ZP2XXRaIcA2fO17McHEWki3bcptbgkuzwXZM59on+OGQfFwL+2QCYR2ZmMBngoTWAV
         09sUnZK+TuAqGHpmpSaA0ttLQlAMph1CSDfi4KJlKA2jO9hY5zV0gY5w5yDDbRGbwJrI
         tNxCRQL5ycDbaEqTmuP6RtjfQcOI5DnUBHiyYeqlt+oC1v0LvK8SQmpAg5woW5wFmQsy
         srglFPPNM/YAwaUg5kc/FliaBZbKocPWiYdjllFdNqqZIjal0Ozm98sVyPVTkvQk7/p9
         rEbNd+liywEZsbiDs/I3kB5wWxJaECm/ObtaWV1HI150TzZLEy/pIC8fwhtKKWpCUuOA
         imMg==
X-Gm-Message-State: AOAM530umkvkD1lmviyqVDoCb/CeW7W9d+ccLJhMpLJWjrNTuQ9C2PQC
        3zW3g3ay9oyCocyCbDUJYnY=
X-Google-Smtp-Source: ABdhPJyq4vIPtN9O1f6cfw9jWavkbXpMiEoaxoqVDXtJsGGLYBAkCZJsXsw/T9RKA6BGsmbvFpk5UQ==
X-Received: by 2002:adf:9069:: with SMTP id h96mr8384186wrh.358.1604755177531;
        Sat, 07 Nov 2020 05:19:37 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id f1sm6411810wmj.3.2020.11.07.05.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 05:19:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>
Cc:     David Laight <david.laight@aculab.com>
Subject: [PATCH 1/3] fs/io_uring Don't use the return value from import_iovec().
Date:   Sat,  7 Nov 2020 13:16:25 +0000
Message-Id: <0e06794001237fc33a71c5f3349bb83937d9c8c6.1604754823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1604754823.git.asml.silence@gmail.com>
References: <cover.1604754823.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>

This is the only code that relies on import_iovec() returning
iter.count on success.
This allows a better interface to import_iovec().

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Laight <david.laight@aculab.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a4146b1f50ef..e72f9a3fd8b5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3164,7 +3164,7 @@ static ssize_t __io_import_iovec(int rw, struct io_kiocb *req,
 
 		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
 		*iovec = NULL;
-		return ret < 0 ? ret : sqe_len;
+		return ret;
 	}
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
@@ -3190,7 +3190,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	if (!iorw)
 		return __io_import_iovec(rw, req, iovec, iter, needs_lock);
 	*iovec = NULL;
-	return iov_iter_count(&iorw->iter);
+	return 0;
 }
 
 static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
@@ -3459,7 +3459,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	if (ret < 0)
 		return ret;
 	iov_count = iov_iter_count(iter);
-	io_size = ret;
+	io_size = iov_count;
 	req->result = io_size;
 	ret = 0;
 
@@ -3587,7 +3587,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	if (ret < 0)
 		return ret;
 	iov_count = iov_iter_count(iter);
-	io_size = ret;
+	io_size = iov_count;
 	req->result = io_size;
 
 	/* Ensure we clear previously set non-block flag */
-- 
2.24.0

