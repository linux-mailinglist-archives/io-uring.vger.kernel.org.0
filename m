Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD4D351B41
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhDASHE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236572AbhDASCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:02:41 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C80EC061797
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 04:23:00 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id o16so1478006wrn.0
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 04:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a3Ap4GWo0s8Kh06mIvQLPBPMXhF9Ofj6fc1qjeAPf7A=;
        b=FuKdrzSBUrMn7vTCRBk0PhOc1v8n5Oftv5+6TjHplMSinShb/rRcsM3L9JiWWwzSDk
         5motFJAlKPELBGQAtbwzrS3TohKhqa/W1S4XFQ8kzTofqCTTRtFJsJxjFZ6uL6pA0knK
         xgHC4jWUYF7WJypJYG7aZptl5EttL+7IbkqHNG5wffsYQfHZ/mKWKY4ipVtU63FZ6Jjj
         VSs9hBn79PqCoWie5qMNblONIBic7fft8frgW25mGg3+ZdFElvEKV2RdJv/KXlfZhFxf
         IcmAZAXrYUqnvm11r3AWf49GQET3PN+FpP/d4G8eP0SElhSabMXDNROAOBAiicox9G1k
         hcwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a3Ap4GWo0s8Kh06mIvQLPBPMXhF9Ofj6fc1qjeAPf7A=;
        b=JL6X3ukTjz7gki84vvzcD2g1yKsWV+zhcq/a71LhriYurf1LjhdnoajcuwuyJ81USl
         sEQa1q6cfYUzb7SlyRmfbuSzNQP3mP7BXqtmrfdQgVYGdXVZ6b1ITxkEW2m7s/YEvi4m
         saCVdC0I3YPv2yn5DP7VYgpGk6s8wOSrX845hkvx+xfOjkU1h8jSo6d6Wvjfk5YqScQ5
         0p25HTYJRGw0PnX030GTRlvn7UUtANdJOtNggJGIa2hIPESTm3eCHO8u9cXkW8mkajKz
         AxMVlxgC+aa8VqsTm7kA6n5BJdaFK7EFUFivApRixk4GdyPygrYd+Qp779EmO2Po3ica
         bOSg==
X-Gm-Message-State: AOAM531h6JXdSI5eKkFbOs8KNfmkJ7gU/KEL3R4JFpwwdC4K8T4enQ86
        FsylOFqLyvfvwObQ3rJtXbM=
X-Google-Smtp-Source: ABdhPJwnTDXPWkesWaKtu9IvgbhT0/NNOJBQ6OKapDKRYM8hMX5VXbVpGcWCnBTGs+8d+C5RjJWbdQ==
X-Received: by 2002:adf:c40b:: with SMTP id v11mr8972391wrf.320.1617276179317;
        Thu, 01 Apr 2021 04:22:59 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id s9sm8600673wmh.31.2021.04.01.04.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 04:22:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12] io_uring: fix EIOCBQUEUED iter revert
Date:   Thu,  1 Apr 2021 12:18:48 +0100
Message-Id: <9d5b65f57375f80c771e286a33db5105f216e36f.1617275847.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

iov_iter_revert() is done in completion handlers that happensf before
read/write returns -EIOCBQUEUED, no need to repeat reverting afterwards.
Moreover, even though it may appear being just a no-op, it's actually
races with 1) user forging a new iovec of a different size 2) reissue,
that is done via io-wq continues completely asynchronously.

Fixes: 3e6a0d3c7571c ("io_uring: fix -EAGAIN retry with IOPOLL")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

p.s. same is already done for-5.13 as a part of a larger patch,
should be trivial to merge.

 fs/io_uring.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c8ceb5ef66a7..3cd8bfe554e2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3284,8 +3284,6 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_iter_do_read(req, iter);
 
 	if (ret == -EIOCBQUEUED) {
-		if (req->async_data)
-			iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		goto out_free;
 	} else if (ret == -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
@@ -3418,8 +3416,6 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	/* no retry on NONBLOCK nor RWF_NOWAIT */
 	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
 		goto done;
-	if (ret2 == -EIOCBQUEUED && req->async_data)
-		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 	if (!force_nonblock || ret2 != -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
 		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
-- 
2.24.0

