Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE0E20C753
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 11:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgF1Jy1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 05:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1Jy0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 05:54:26 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F862C061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:26 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g20so9975946edm.4
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eayvvBwR5MNZ9A1MlatOHUQWDtMamsprZ5GEumnt7sY=;
        b=dFtnmwuz4JLJpV61QCOEWJqhfOM+wpWW2FM80BWtRgBLOzgART9SBjsOVZwezAdCgo
         /jXzE9ClV+4UAhlgM1tcS+BL8KnybgRkJIXm1xs3vFbqi/NAhtNW77oWzzVhJcXeOO30
         YI6RTz7LGwP/aAmuLCdWwYIjHTttBqs25JuIHwaqLE8IfqvRJl40pz8l1ljfnE2uxuqY
         ZEchrlCOYjE7BrXFgSGpgoNncDCbfXAFG2WPkgTd2sNk7dtborVJ8sh/grnXkABjzq9X
         kZTtyLZkJV9tvTdUVemVnN1taconvfwtSS04woHyyPdN8UPdEazp9VhQRXhnGNpCf2bB
         H+FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eayvvBwR5MNZ9A1MlatOHUQWDtMamsprZ5GEumnt7sY=;
        b=YS9eBfuskQ9+yT/Y4tkho45DngI30G8kFkpUJJ9ADeUlQM9cD1eOXVJFSfPwEhcsti
         qYtrSYWosk2p+G9MSw5zqCNu82riO2Tz8pQEAUW/S/ouGBMQPmmQo7SUCONBX8ZhhalB
         oyUH/cFXVYLkA5lyBya92llXkR1UrrbKL3Vs+0bQRi4MWTF23UU+kXmV/QMD4n9myq9V
         HZrNANSurC/qqEIiO2VG8OAlTg2rLjX6QtiosYTgBCNYVvbe3Ad1AhwxFWZ2s021UyEb
         BuSk6+1OdnwQ5/52VK+XJ6lkW2M5SrJAnCLfWFoV8TVCbl78FMuSAYvdLm76TUTeC0Xi
         K9Jg==
X-Gm-Message-State: AOAM533eiznXEutiljYU/pol43FHnmlO9KmfKFfwWD44B5Kgi4wRjVRT
        tJSH3IzGkAOVl4LWZvn2uKAgBdW6
X-Google-Smtp-Source: ABdhPJy+8j8wKf1c2/c07wlv07T8GTAJMQ07IeuW0AuntJSphrKFdytOUh629LHYQNza60Ph8PTHxQ==
X-Received: by 2002:a05:6402:b4c:: with SMTP id bx12mr11873389edb.117.1593338065110;
        Sun, 28 Jun 2020 02:54:25 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w15sm10089490ejk.103.2020.06.28.02.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 02:54:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/10] io_uring: clean up req->result setting by rw
Date:   Sun, 28 Jun 2020 12:52:35 +0300
Message-Id: <3b244ef0940e172f51b411275453eb76f13d720e.1593337097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593337097.git.asml.silence@gmail.com>
References: <cover.1593337097.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Assign req->result to io_size early in io_{read,write}(),
it's enough and makes it more straightforward.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b9f44c6b32f1..5e0196393c4f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2384,7 +2384,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
-		req->result = 0;
 		req->iopoll_completed = 0;
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
@@ -2957,10 +2956,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	if (!force_nonblock)
 		kiocb->ki_flags &= ~IOCB_NOWAIT;
 
-	req->result = 0;
 	io_size = ret;
-	if (req->flags & REQ_F_LINK_HEAD)
-		req->result = io_size;
+	req->result = io_size;
 
 	/* If the file doesn't support async, just async punt */
 	if (force_nonblock && !io_file_supports_async(req->file, READ))
@@ -3054,10 +3051,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	if (!force_nonblock)
 		req->rw.kiocb.ki_flags &= ~IOCB_NOWAIT;
 
-	req->result = 0;
 	io_size = ret;
-	if (req->flags & REQ_F_LINK_HEAD)
-		req->result = io_size;
+	req->result = io_size;
 
 	/* If the file doesn't support async, just async punt */
 	if (force_nonblock && !io_file_supports_async(req->file, WRITE))
-- 
2.24.0

