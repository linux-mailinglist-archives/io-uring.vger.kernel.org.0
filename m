Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FB93B3101
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 16:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhFXOMw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 10:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFXOMw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 10:12:52 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52148C061574
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:29 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l21-20020a05600c1d15b02901e7513b02dbso961054wms.2
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cjgElNgawrClU7y/s/5xJzOxB0JG8v+6jrlwX38+o9s=;
        b=qvE3Ck4rK0MBfx0oUqhP7huBLif7Bm9AyWUT47/k8hy63+tBHgzV4reENsT8J8gvEu
         p+SggcnXxFC+ujimTDtUQ15N1BtD65J68MbrVGLWiZTemkLrK1W3iWFt4GYdnLmH7S7j
         eQ+8PVwicRgA+Y1KSX9GcV1aT/HmZEk4zlp+lWvdqhHZzOIa0y9ToxmPKGZqb4MFNbTZ
         1acPfWF5tcloH1rF6qynNLhmpwpqrRcDDJYlbYM9btNABvtsCX4D1FfkezEswW388Ete
         wX9yGu12KWIQgtktrB7D4D9UhIE/aHhY/BkhmdWJMWiTKwPL0wtYeVQAsFd6uIthoK1p
         Bi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cjgElNgawrClU7y/s/5xJzOxB0JG8v+6jrlwX38+o9s=;
        b=aF5ZX61ay6iWEzjTUITBKYSsDzP/42v2MzFWTe6dy8wndagiVbnzNDIr6d3GcXDSfn
         +k/qfwls9uB+bhT9cvf9xC278b8PzK/Ajv5MBzUfX0Cn8TvJkvD64/dLdD4rh2clQIzc
         bu0TCQXZkMpJV+L33DBdhrAVsY4xRxhL0bDx7UUzDHSu1qcx7xyiodoEh3MIK+lJV7R8
         Wzr5EXZ9CJqKbqmzdTdnG9EVM+6UbnMzhlObMnOfBZ2bgUu/gBBfBhQdQuilGZAGycxF
         C1ygMxg0LpwXkIFKvvYztMPH94WdsFFOgzbqzBDEsWI2Bb81A6tVE8l6mwII+TdTGGXZ
         v2vw==
X-Gm-Message-State: AOAM533AcjZdWPPsBBtyHiNHRzL0jmXn25LLnCwRGt6X229b86kp6Zau
        58JSZUW6M+R7FEhpnEOdsaQ=
X-Google-Smtp-Source: ABdhPJyWmcXgAm1JpUhdBRk7LEqrw3QrFP4l37VzklSt9lG0yi6NmlZyijBvB7atBWoRFOiqw4hikA==
X-Received: by 2002:a7b:cb8d:: with SMTP id m13mr4557575wmi.8.1624543827982;
        Thu, 24 Jun 2021 07:10:27 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id w2sm3408428wrp.14.2021.06.24.07.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:10:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/6] io_uring: refactor io_openat2()
Date:   Thu, 24 Jun 2021 15:10:00 +0100
Message-Id: <f4c84d25c049d0af2adc19c703bbfef607200209.1624543113.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624543113.git.asml.silence@gmail.com>
References: <cover.1624543113.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Put do_filp_open() fail path of io_openat2() under a single if,
deduplicating put_unused_fd(), making it look better and helping
the hot path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c382182573d5..b0dea0b39ea1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4021,27 +4021,26 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 		goto err;
 
 	file = do_filp_open(req->open.dfd, req->open.filename, &op);
-	/* only retry if RESOLVE_CACHED wasn't already set by application */
-	if ((!resolve_nonblock && (issue_flags & IO_URING_F_NONBLOCK)) &&
-	    file == ERR_PTR(-EAGAIN)) {
+	if (IS_ERR(file)) {
 		/*
-		 * We could hang on to this 'fd', but seems like marginal
-		 * gain for something that is now known to be a slower path.
-		 * So just put it, and we'll get a new one when we retry.
+		 * We could hang on to this 'fd' on retrying, but seems like
+		 * marginal gain for something that is now known to be a slower
+		 * path. So just put it, and we'll get a new one when we retry.
 		 */
 		put_unused_fd(ret);
-		return -EAGAIN;
-	}
 
-	if (IS_ERR(file)) {
-		put_unused_fd(ret);
 		ret = PTR_ERR(file);
-	} else {
-		if ((issue_flags & IO_URING_F_NONBLOCK) && !nonblock_set)
-			file->f_flags &= ~O_NONBLOCK;
-		fsnotify_open(file);
-		fd_install(ret, file);
+		/* only retry if RESOLVE_CACHED wasn't already set by application */
+		if (ret == -EAGAIN &&
+		    (!resolve_nonblock && (issue_flags & IO_URING_F_NONBLOCK)))
+			return -EAGAIN;
+		goto err;
 	}
+
+	if ((issue_flags & IO_URING_F_NONBLOCK) && !nonblock_set)
+		file->f_flags &= ~O_NONBLOCK;
+	fsnotify_open(file);
+	fd_install(ret, file);
 err:
 	putname(req->open.filename);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-- 
2.32.0

