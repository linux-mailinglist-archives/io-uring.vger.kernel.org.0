Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478033274EF
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhB1Wkp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbhB1Wkm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:40:42 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AC9C061794
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:27 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o7-20020a05600c4fc7b029010a0247d5f0so2130977wmq.1
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zCcKSnH68GNCr/+NSo8aQ/MKkHptWepZPz3tOfX/YzE=;
        b=vEK7RTsFdNH71hTbxnTJHsTVe+fxlDtEXoUcCVQg7/bnyGy3wlhBaGrXqlAB9p8ovF
         iMaXdbY/I0p+ZhogAv3g0HmUVaRHTmT30y2cA3oh+gYgGB9slqm5pcW5B/FcNMGdqIwc
         rCIvwqUSmaeVNV4pm7JQVc9+Wew4p3vYmwodxCjVtrbCGRftIybx9Ahd9Bid7ct2aZom
         6/+O9WJ/YB12pR9mRb35jlBxVLope0KMfp2bxx9erioezmd3PVsv9fI2lZGf04ox3BRq
         C6tDoMhSYbX/y8aS4GYojunz2bAh5C2iEeK6tJpm5WtZeMvL6lYopYtHix5y9p0bURWH
         O+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zCcKSnH68GNCr/+NSo8aQ/MKkHptWepZPz3tOfX/YzE=;
        b=FViKox4StCYdV5HYEGpsSfaOjGR7+PTQDX1H/8zNsg21e8B4bvXISJ+PdR1mwKeTD7
         Z50riQwUaZj1SvCF6mKcNnS3qskNAH1hC0Kms0yeiYzuJxRB6OVv8GlDTk6i5EOlmlc/
         aJJIU11AdXSH1/0Bb8DtM0W9oLzmXOlp4qBvJtAitu/TQW9S0dKKiM5h5lMnnYaC+3KK
         en98Gim29UrmfRc9Ybhb4qn2O8b3uYLZmFX7zqCwPETqAKRIf6BUWRqZePtDJIhHqrkI
         NJ5P/e7ZctfA62upLEOvUwsZuu7+AApFh8zLvE0ay2yLE/D0S0Asq+XJpOZd/Hs+u2/e
         V0VA==
X-Gm-Message-State: AOAM531nS53hTC5iUbYIN3ZTRerTibCYnsyH7XsM8ERTRW5mNj6w/xbI
        tpAFZlJYXcB5xr18+1tuuxbLzryT+mIdzA==
X-Google-Smtp-Source: ABdhPJwRMDaU5nTnGvaBbXYWPbA96wj5q91UtjPzV2mjybUq0HA0bwVAPG5nVHdWtPAa56ufESBwyw==
X-Received: by 2002:a7b:c0c4:: with SMTP id s4mr3532604wmh.9.1614551965878;
        Sun, 28 Feb 2021 14:39:25 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id y62sm22832576wmy.9.2021.02.28.14.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:39:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/12] io_uring: refactor out send/recv async setup
Date:   Sun, 28 Feb 2021 22:35:16 +0000
Message-Id: <0f9c07bdaaba57ee4b77eb8e406ddd9547b8b088.1614551467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614551467.git.asml.silence@gmail.com>
References: <cover.1614551467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_[SEND,RECV] don't need async setup neither will get into
io_req_prep_async(). Remove them from io_req_prep_async() and remove
needs_async_data checks from the related setup functions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 049a8fbd7792..6fb2baf8bd26 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4281,8 +4281,6 @@ static int io_sendmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
 
-	if (!io_op_defs[req->opcode].needs_async_data)
-		return 0;
 	ret = io_sendmsg_copy_hdr(req, req->async_data);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
@@ -4502,8 +4500,6 @@ static int io_recvmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
 
-	if (!io_op_defs[req->opcode].needs_async_data)
-		return 0;
 	ret = io_recvmsg_copy_hdr(req, req->async_data);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
@@ -5758,10 +5754,8 @@ static int io_req_prep_async(struct io_kiocb *req)
 	case IORING_OP_WRITE:
 		return io_rw_prep_async(req, WRITE);
 	case IORING_OP_SENDMSG:
-	case IORING_OP_SEND:
 		return io_sendmsg_prep_async(req);
 	case IORING_OP_RECVMSG:
-	case IORING_OP_RECV:
 		return io_recvmsg_prep_async(req);
 	case IORING_OP_CONNECT:
 		return io_connect_prep_async(req);
-- 
2.24.0

