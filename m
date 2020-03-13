Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3454B184F4B
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 20:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgCMTaY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 15:30:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51488 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgCMTaY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Mar 2020 15:30:24 -0400
Received: by mail-wm1-f65.google.com with SMTP id a132so11195775wme.1;
        Fri, 13 Mar 2020 12:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KcsY0IV1sP/7qBN1VFa+WaefRq9MQnPVE3Mte6T07pA=;
        b=p8q/aLOKq+SDtU7gs0SQ3iV0ryXyTLHR7KoFeG+vBJpqMavDqnSVcEQhiCXnPja3xj
         aKAiglpdMvsgG/LuS7TFJE4r1mY6ACeNTTwl8EjQCzLOTVovdVuOuouHO6BwdDp7DjKl
         6BdDqqJfxkV2nY3YQ04ytISJIaxRT1V+Xq0NwCBweZf2uYGx3iZMoQh0C74Nh61kZ7Jz
         IbLzrsn7wWmhEUvkWNAYxd5YtYs4sHeUGd0m4BlK+UC2kvBqZHHnLGem4qPXPEMgqIb1
         jSoMDI5BvG4wSEZSmb6hVzbEcl86Nitcj5XblZk/X/RWzq2jRA+12sgxV7CFLdQddSHT
         cAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KcsY0IV1sP/7qBN1VFa+WaefRq9MQnPVE3Mte6T07pA=;
        b=rM2K8n+CBfKXy4RkUPPQQS0Xt1tZyDGa7c8xwYNl0dcsNAm1f9KNDa/OaxMk8BxibZ
         WcSzf+PIJA478cQPPIjX0oPmL4Tiko1rRFdnTCdaR7aKSBLGtqEuI+lmL0rHTjQjroEz
         4m7QxsKLoyBmU8BixF6SsPk9TnlBXFa2wPJLqObHv4RTBOvwlWp/3AUZRNIFQ7O1vk32
         tRpJtTol1SDIBYBOa5Xs3F3KL2ECRR1uj+ruRqxzs2HIW+HhLtGVoLk1XnieLEytsLSk
         quupKKWudzX/Y0ZsfNnhZl0UmFRzI4nAMyzZM4R8M15hcsSjed2EHO/4h1PV6+TD6LDi
         3KgQ==
X-Gm-Message-State: ANhLgQ0RU1PO2rVnFU4q3N1lzbCadZh5olToGoTc3aOsLWB89VOOGmxi
        xJ/3o39bJQGqrHae5SIy6W/p2T//
X-Google-Smtp-Source: ADFU+vthOnXM8Td//ugCZU/NeSyoaJZyZ4oUo3Bz3BhiZRiwPe7o5EKUej5ZRMqHkQ9M5jTkx+zfag==
X-Received: by 2002:a7b:c950:: with SMTP id i16mr12008809wml.97.1584127822662;
        Fri, 13 Mar 2020 12:30:22 -0700 (PDT)
Received: from localhost.localdomain ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id l83sm18538969wmf.43.2020.03.13.12.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 12:30:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.6] io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}
Date:   Fri, 13 Mar 2020 22:29:14 +0300
Message-Id: <3fff749b19ae1c3c2d59e88462a8a5bfc9e6689f.1584127615.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Processing links, io_submit_sqe() prepares requests, drops sqes, and
passes them with sqe=NULL to io_queue_sqe(). There IOSQE_DRAIN and/or
IOSQE_ASYNC requests will go through the same prep, which doesn't expect
sqe=NULL and fail with NULL pointer deference.

Always do full prepare including io_alloc_async_ctx() for linked
requests, and then it can skip the second preparation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 55afae6f0cf4..9d43efbec960 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4813,6 +4813,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 {
 	ssize_t ret = 0;
 
+	if (!sqe)
+		return 0;
+
 	if (io_op_defs[req->opcode].file_table) {
 		ret = io_grab_files(req);
 		if (unlikely(ret))
@@ -5655,6 +5658,11 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
 			req->flags |= REQ_F_LINK;
 			INIT_LIST_HEAD(&req->link_list);
+
+			if (io_alloc_async_ctx(req)) {
+				ret = -EAGAIN;
+				goto err_req;
+			}
 			ret = io_req_defer_prep(req, sqe);
 			if (ret)
 				req->flags |= REQ_F_FAIL_LINK;
-- 
2.24.0

