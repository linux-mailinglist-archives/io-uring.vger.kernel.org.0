Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D28C38080E
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 13:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbhENLHM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 07:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhENLHM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 May 2021 07:07:12 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C50C061574
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 04:06:00 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v12so29633374wrq.6
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 04:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=INUTrNpE5jXCCrKhlSEgQK1TEjrhzIvq+JT6ZuRtUwQ=;
        b=XLlVT8vD2/EabgktEtLpPv1J4YdvyZkHscsRrAWRyYzizX0Umn3EOxHDVBpHj0Pcb9
         VF6yERWqew+CpC8potj8z5d99Uty1mm+N4CtVjIG+ZEnnRT4sbmGv5DBKbAlGUNCsIqB
         NvuAU3cZ2wXz41z1iTAekGoFrtmBcirQKjRjbKh2wnD2TN+oPg3S4+sCDqncZ9KgQPmo
         pTi/bCosRGSj17yH7rp4na4KijXonkMY436LEPesbXMyfeggzEImr0AARpUIzW9g+1N3
         nsaLtQ6WDIUv7eY4ANWHXztsWB1FF+r2f9apa2VrvZnJbDmpxMp3luH8XhWAM6hGk65I
         vxsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=INUTrNpE5jXCCrKhlSEgQK1TEjrhzIvq+JT6ZuRtUwQ=;
        b=ghGWl9Q6izvhB/ymtzUO/gSnGikAXm65vKVBxYfmPDydamBdEERTYyuzRAi7BiRUsk
         broXny+NALfqUkrYoXTMlJgj6x8DLaH9yAnB6O9ZkQQKzbQZKIAMUHqT2X2Gm5GQGxpc
         Yl2O+SifqNM37RW68aIaCxtQBaLfSiWBZk3W2x6OPKe2XjcMCcbjmCdqUFmovyG2aHJF
         +Dldl6ZTTwmC8bugHc5zGOTq+XxL+wqpx1710NGpnu1q1EmfpqM5KYLHRCljRX+eR4Qb
         ep+Ngmff5g0ayQOEE3Xg8S69zqCY08Li7m0VIGNCdqB3zBIzjMelxcgP9A0S1YpMlcKi
         +u4Q==
X-Gm-Message-State: AOAM5335qsLW5YQK+aYLmBfmeOCgpKE3rlbOsFIkfHM76KBeUNfGqXKt
        yg3qeNEFqplTf6GS39sYbvw=
X-Google-Smtp-Source: ABdhPJxI5aKSUO9EzZJQ7jUHlAr3axvM7U4wLUSMlcnmIfwPa+HBZeowSCir8KJ+p5+ziFKk0ybePQ==
X-Received: by 2002:a05:6000:186a:: with SMTP id d10mr59090349wri.41.1620990358796;
        Fri, 14 May 2021 04:05:58 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.196])
        by smtp.gmail.com with ESMTPSA id v18sm7205114wro.18.2021.05.14.04.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 04:05:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: further remove sqpoll limits on opcodes
Date:   Fri, 14 May 2021 12:05:46 +0100
Message-Id: <909b52d70c45636d8d7897582474ea5aab5eed34.1620990306.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are three types of requests that left disabled for sqpoll, namely
epoll ctx, statx, and resources update. Since SQPOLL task is now closely
mimics a userspace thread, remove the restrictions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8f718d26f01c..981c0f86e054 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4037,7 +4037,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #if defined(CONFIG_EPOLL)
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
-	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL)))
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
 	req->epoll.epfd = READ_ONCE(sqe->fd);
@@ -4152,7 +4152,7 @@ static int io_fadvise(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL)))
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
@@ -5829,8 +5829,6 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 static int io_rsrc_update_prep(struct io_kiocb *req,
 				const struct io_uring_sqe *sqe)
 {
-	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
-		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->rw_flags)
-- 
2.31.1

