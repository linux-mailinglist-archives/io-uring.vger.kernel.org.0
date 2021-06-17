Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7993ABA5D
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 19:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhFQRQr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 13:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbhFQRQr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 13:16:47 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9CBC061760
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:39 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d11so5247011wrm.0
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jR7jrqrmhQjCTxWrZy6lLZyCVj7ixO/+DWtCqkGa4Jk=;
        b=RMELBrY7ecRIXo5RSmuo+OOISwBa/9HjQwN8bm69Hn6CPPzJ0GoUNNyPn26gbEmtZJ
         6MAev1tIZZlQQ73Plfgy0APKcNPpWiHwlN8X24/h9+CXiJXcHdK13liMpr/lNsDgN+8I
         doW/O+92RGPiOLH2xA6svMzoC0MTD/pOYHKy5tkOnoIYLyt0F6Gv6TC2mX2CshkD/3WU
         Cf1S7nwyLGtRbEWhcnV+egQoHLqbBLWlxvqujHkWoyiXz+8x+SdAMjIleWD/jE0rK+3n
         ptLPhSXUZ5N3NryQNn1IlydCio+W3MIIJ18dHO9202MsqGQE9dKqXZFBGNGiq+7gRews
         koQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jR7jrqrmhQjCTxWrZy6lLZyCVj7ixO/+DWtCqkGa4Jk=;
        b=TbJFszuZOD2R6bGk83zSFri96WBqhZyFODp5BsEMXiKRoZy3M3nDAnGsYwxHxyLXye
         y+w8mQDMY/yPss4NkIYISHUdtdGIRzyGpG9K5LkyQBoi/udRM0bFkkLp2ghhYpidludB
         vYqGudOsKOtV3nPKXaxFB331tDe/qZ6ikqrKhpRcESUjdKog356RKlzQpEB5N20mnTNV
         nP+jSf+Jqdf+mkXXsNKIPVeC3iMzYOPMpnUlHcPaoFNYdpKX3JkgSDa/QqWs6if2onqJ
         WAGLBCa0fS5GCL8bHtzLZDowcbGgWiLET8syN1aCARPx1+NH+tSsDKl8rp4iqA2h+XQ0
         N9GA==
X-Gm-Message-State: AOAM530qZ07TZWz4N2lumzwQfQUFMp6HljRzkKnTTNiKfhiSjN2KvfpU
        YV7Pv+3bMxexN97aKJxdWLA=
X-Google-Smtp-Source: ABdhPJxRa0HyWKfd01DcMsa9r6HWhXwhTtmRx3c4Ydn0/lb6d13e6azYn8xxQUucG5uoSydGwREoLg==
X-Received: by 2002:adf:f28b:: with SMTP id k11mr6893047wro.89.1623950077829;
        Thu, 17 Jun 2021 10:14:37 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g17sm6208033wrp.61.2021.06.17.10.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:14:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/12] io_uring: simplify iovec freeing in io_clean_op()
Date:   Thu, 17 Jun 2021 18:14:03 +0100
Message-Id: <a233dc655d3d45bd4f69b73d55a61de46d914415.1623949695.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623949695.git.asml.silence@gmail.com>
References: <cover.1623949695.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't get REQ_F_NEED_CLEANUP for rw unless there is ->free_iovec set,
so remove the optimisation of NULL checking it inline, kfree() will take
care if that would ever be the case.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d0d56243c135..5f92fcc9a41b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6092,8 +6092,8 @@ static void io_clean_op(struct io_kiocb *req)
 		case IORING_OP_WRITE_FIXED:
 		case IORING_OP_WRITE: {
 			struct io_async_rw *io = req->async_data;
-			if (io->free_iovec)
-				kfree(io->free_iovec);
+
+			kfree(io->free_iovec);
 			break;
 			}
 		case IORING_OP_RECVMSG:
-- 
2.31.1

