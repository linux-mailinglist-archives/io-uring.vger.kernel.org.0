Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3949E3499FA
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 20:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhCYTJ7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 15:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhCYTJZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 15:09:25 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7671C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:09:23 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o16so3445284wrn.0
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JU1UCVRwebI2nrbAqb8os48RraG5AF25uL54kxq2c9U=;
        b=SKkSceC47htLWxH9FNc6uKH81kIv3pXfcv0i0jnnioagncqWOji1NgtddG7He6fMIe
         aY1jZuTVZMITcYVO0rU0IlZ12PX4fOyQ2adUiY4NHtwiAITsG8nmv6ux1TuWPY31HZpk
         YIS+zBANE4+J9Ctg4ZTio0vPC3jaCwv8f2cLvCYBzSlSwayY51cS46WyxOz2NoZtS/3M
         ZGZBJPWub8SHu7jHMKTdwoX5Or6iuuCzvxns7SlgEGRUumeN4MnVCPJHhOBHvVZF7TU7
         O9Dh/SytWEczI68Ehu80Ny8cIvrWxd7NNTGhzVSggNkArcEji4rBfcOpfbRVtKvZEqn8
         8Byw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JU1UCVRwebI2nrbAqb8os48RraG5AF25uL54kxq2c9U=;
        b=MYGq9nJ+Ij4Ld6hHNcQgXd9jCbHYQSog1quT7WXMWwZHYv2jjzd/PJj4g34a8ourwX
         q/FWAHjxPH3pfZPkjVVh2fwMOIDL+XBA5Qd6Wo/DMB2Du3flerAvYKA4npBQZIYoW036
         FIWK+6j0sqYk7XaCOTPc18zSSmyqO/aNZAGhaSYZ5TqIRqGQqiDnF1BXvgx7LJvicLeb
         VxEr5B6ztK568zQWrbHOmv4xyyATj8gFk255/i/4Wxtj6h4UNEUvO0PDsMctLuJdiX5W
         11rNy91OHx/Vy+30Ozd58PZIhzH/lqahIMO92HycJuo+HbNoXFp/P5P3xMUDzdohfpwY
         17/g==
X-Gm-Message-State: AOAM532MKES0IsqxbRqQIqrUSgB0bN+fp0MD7QehYCrh2UX0C0mZXIjk
        fV5Z4ohb6a1Nm0YRpE/mclt441lDksQvIA==
X-Google-Smtp-Source: ABdhPJzVp7d2KcYzzv9zMr2BjKGRs0es1GL5wDvq5IOtSIu0Y+wCVb+g166BFazgwf4slC/bw525cg==
X-Received: by 2002:a05:6000:2c4:: with SMTP id o4mr10546614wry.190.1616699362660;
        Thu, 25 Mar 2021 12:09:22 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id n7sm4106814wrv.71.2021.03.25.12.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 12:09:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 5.12] io_uring: maintain CQE order of a failed link
Date:   Thu, 25 Mar 2021 19:05:14 +0000
Message-Id: <b7a96b05832e7ab23ad55f84092a2548c4a888b0.1616699075.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Arguably we want CQEs of linked requests be in a strict order of
submission as it always was. Now if init of a request fails its CQE may
be posted before all prior linked requests including the head of the
link. Fix it by failing it last.

Fixes: de59bc104c24f ("io_uring: fail links more in io_submit_sqe()")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: expand commit description

 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f8df982017fa..947c9524c53a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6459,8 +6459,6 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	ret = io_init_req(ctx, req, sqe);
 	if (unlikely(ret)) {
 fail_req:
-		io_put_req(req);
-		io_req_complete(req, ret);
 		if (link->head) {
 			/* fail even hard links since we don't submit */
 			link->head->flags |= REQ_F_FAIL_LINK;
@@ -6468,6 +6466,8 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			io_req_complete(link->head, -ECANCELED);
 			link->head = NULL;
 		}
+		io_put_req(req);
+		io_req_complete(req, ret);
 		return ret;
 	}
 	ret = io_req_prep(req, sqe);
-- 
2.24.0

