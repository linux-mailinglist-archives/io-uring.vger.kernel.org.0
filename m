Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5761030B419
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 01:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhBBA06 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 19:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbhBBA05 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 19:26:57 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404B4C06178A
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 16:25:43 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id v15so18596764wrx.4
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 16:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KppEcxR1Dgy1RomtmP0kbjXrXjwhrO1j6gwPiyk/r8c=;
        b=evRPBkd2FsDD0A+MOGeYqTkKz0WkqfMG397xwpoKoJvVDSdp69P4hsW8yudedXXTzV
         3IOmIMupjmoPM4tbj0HH9UnKFhy6RhhiLrAw+qDIbTp9cTjEdsDQUvSqpc4fQNzdQz55
         BQPx3uk2vFNB4k07rdK/LPS6bhb0+b9VLTWqhTx5DJhQats5UBlX0Jyiab6LQ04Myldm
         mA0KZfxtXEGluPVvl7EX+LkwoO33aen75FxJxCaL6vaixS3JR4b4XDxx5kW2DzLvPrAD
         I4yoM2KiXLBMH3a0ncOq4XmlnFyE1ZJ3lB2ImV2aAWl8PnuARhhDIwgMixuaj+NO2vMO
         RAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KppEcxR1Dgy1RomtmP0kbjXrXjwhrO1j6gwPiyk/r8c=;
        b=PcH9w9JWSnyETNJg7K56tJtLVnV4QGpBaYlUoxWA01huAnqgCOVk9e2DmxNnAhCjhW
         QHIPkrK0bHrKEbiQi4oNuPIUwLaR4H2endtbly/pyWCkBYWmxAKWC6VhoF47yxC14VSr
         iMp182uf4glMjuJQIlsa5vPNO0UNglX4+EXr/2xiz2vZZzfIis1Wo6aKrRB12S6uYo+/
         3ld4jXTP+LxerUkSbxD69VurAl7KxEBg6sY2wRyakI1NQTzyFpPAIfxTKCqZ/RyB9j7z
         qqMYdSUsjM6H/fiXwZunhV54mKofDuV+EwzWU6jTWE1p4UOrV8FPTnSQ+6t9o/Q6Iaw9
         myXA==
X-Gm-Message-State: AOAM530BXc/baJ2V9Ctb+f1Gd3czba9P/seiDbst7gQd2zOzaipruj41
        4cgIRpddpz2URNEfQ1QQKsMl1D78DbU=
X-Google-Smtp-Source: ABdhPJyu0ia6J2qCh6IsxudyJdnFX81De7jR8+uNb549Z/2JMoZjUnIhFe0ztg81Jwumu+Crz0yR4A==
X-Received: by 2002:a5d:5384:: with SMTP id d4mr19903621wrv.177.1612225542068;
        Mon, 01 Feb 2021 16:25:42 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id n187sm851740wmf.29.2021.02.01.16.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 16:25:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 7/8] io_uring: don't forget to adjust io_size
Date:   Tue,  2 Feb 2021 00:21:45 +0000
Message-Id: <cc24b33fc8b9a769ee35586f4ebadc3e805afce3.1612223954.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612223953.git.asml.silence@gmail.com>
References: <cover.1612223953.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have invariant in io_read() of how much we're trying to read spilled
into an iter and io_size variable. The last one controls decision making
about whether to do read-retries. However, io_size is modified only
after the first read attempt, so if we happen to go for a third retry in
a single call to io_read(), we will get io_size greater than in the
iterator, so may lead to various side effects up to live-locking.

Modify io_size each time.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f8492d62b6a1..3e648c0e6b8d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3551,13 +3551,10 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	} else if (ret <= 0 || ret == io_size) {
 		/* make sure -ERESTARTSYS -> -EINTR is done */
 		goto done;
-	} else {
+	} else if (!force_nonblock || (req->file->f_flags & O_NONBLOCK) ||
+		   !(req->flags & REQ_F_ISREG)) {
 		/* we did blocking attempt. no retry. */
-		if (!force_nonblock || (req->file->f_flags & O_NONBLOCK) ||
-		    !(req->flags & REQ_F_ISREG))
-			goto done;
-
-		io_size -= ret;
+		goto done;
 	}
 
 	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
@@ -3570,6 +3567,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	/* now use our persistent iterator, if we aren't already */
 	iter = &rw->iter;
 retry:
+	io_size -= ret;
 	rw->bytes_done += ret;
 	/* if we can retry, do so with the callbacks armed */
 	if (!io_rw_should_retry(req)) {
-- 
2.24.0

