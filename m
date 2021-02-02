Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D049530B418
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 01:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhBBA05 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 19:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhBBA05 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 19:26:57 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422CEC061788
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 16:25:42 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 190so864651wmz.0
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 16:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JB0IOJWfPu6SroqQQAZj0gnju13uZnG6xqmiYRTuRYY=;
        b=D/g3f0v7TcD2sI5BE0mTDCzatJ7iZZcfTOf4YTvNEp7PM86ZGvmnauCUZwy6ugJh6n
         iHeYd9ePZujrG9JCm3YeXWQTkAPJkH6sDIO6di9HfuxdLA5bt5Ovsneok1X+E5N7w8LW
         EwG0M8kEr7koAzyS4uADMQ7N2DnonCfCD7E8w6T8H1+8ayUzPYkvMnLYVI3Kq7R7nga3
         p9df4MgSsVGu7VqvyYbuP4zUDvAszCtlvVi09QK9iYyVEH2SSC7M74gnarPX87EkIi2w
         aasedMkfLuLUlMK0+N3laQ4pKEcM5HLc/1VsIcnC25gO6jGLUR1XNNOfu67LZwiwpP9G
         68DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JB0IOJWfPu6SroqQQAZj0gnju13uZnG6xqmiYRTuRYY=;
        b=F6cGBhGCWBVLlYyDazSBPIWvbFQM5nAK8CIGtpSCfmF5Y4xeNeJaf/ewiFJQzibTdt
         cAF7xjs/mGcIR434wX/YshwMEyluzFfgVnT6hn0+uidsoR+2/ew8MKFYhrZivwilnoU4
         pGuPft7XD/b7N3YkW6TF8jOIh42g4PVy3MBVYybDDVAiiJaJ1Et9+EIkjl7DE/kzDOL0
         252oTZf4gnTU8oMlMgWdjOMflFzJS7V1Z7DVVpiS+wc0VnPF+zM8dBjZB8wUMRnVg0AV
         Js+q3mwr5yqZZ306iKfeyKT2LVmqfUFE04mpGGOLIKWt4M7dj8wR8T8R0l+N32pFlDq5
         SRIw==
X-Gm-Message-State: AOAM532+u5+dIP9soud4a69ifWELl4tkqIiCqQpKMXodDL2tAQ0ozChP
        S1I5S5ztqocPxkrGmPCpMSlNUPNSfmA=
X-Google-Smtp-Source: ABdhPJzjSuaU4FqH7aXWyKDojwXhkBZJRqCiQSKlQ4Tk0fqbMx61e+pxN28Mxq3xGvqDZMTjmXGUfQ==
X-Received: by 2002:a1c:bc46:: with SMTP id m67mr1176264wmf.82.1612225540973;
        Mon, 01 Feb 2021 16:25:40 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id n187sm851740wmf.29.2021.02.01.16.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 16:25:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/8] io_uring: let io_setup_async_rw take care of iovec
Date:   Tue,  2 Feb 2021 00:21:44 +0000
Message-Id: <2f596c51fd9d2de53db7ee202df5c8c7537a4f5f.1612223954.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612223953.git.asml.silence@gmail.com>
References: <cover.1612223953.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now we give out ownership of iovec into io_setup_async_rw(), so it
either sets request's context right or frees the iovec on error itself.
Makes our life a bit easier at call sites.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1d1fa1f77332..f8492d62b6a1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2721,11 +2721,7 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 	ret = io_import_iovec(rw, req, &iovec, &iter, false);
 	if (ret < 0)
 		return false;
-	ret = io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
-	if (!ret)
-		return true;
-	kfree(iovec);
-	return false;
+	return !io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
 }
 #endif
 
@@ -3366,8 +3362,10 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 	if (!force && !io_op_defs[req->opcode].needs_async_data)
 		return 0;
 	if (!req->async_data) {
-		if (__io_alloc_async_data(req))
+		if (__io_alloc_async_data(req)) {
+			kfree(iovec);
 			return -ENOMEM;
+		}
 
 		io_req_map_rw(req, iovec, fast_iov, iter);
 	}
@@ -3528,9 +3526,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	/* If the file doesn't support async, just async punt */
 	if (force_nonblock && !io_file_supports_async(req->file, READ)) {
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
-		if (!ret)
-			return -EAGAIN;
-		goto out_free;
+		return ret ?: -EAGAIN;
 	}
 
 	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), io_size);
@@ -3565,10 +3561,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	}
 
 	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
-	if (ret2) {
-		ret = ret2;
-		goto out_free;
-	}
+	if (ret2)
+		return ret2;
+
 	rw = req->async_data;
 	/* it's copied and will be cleaned with ->io */
 	iovec = NULL;
@@ -3703,8 +3698,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
-		if (!ret)
-			return -EAGAIN;
+		return ret ?: -EAGAIN;
 	}
 out_free:
 	/* it's reportedly faster than delegating the null check to kfree() */
-- 
2.24.0

