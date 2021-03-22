Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986AC34366A
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 02:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhCVBua (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 21:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCVBuL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 21:50:11 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AC6C061756
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 18:50:09 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id x16so14984142wrn.4
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 18:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fO2ujsDOBsfPR18MOLZf1FHyNYoGOBorzZoY5SulvNY=;
        b=CrFT7dsCkOxY+uYelpRolGAkg2lxjwiAwFtSWw2hFNeduDIDpvryjX3Z9grOAZ2WcO
         mIaf2iLqvpX0eFR80tNd4IVBeMnY9ifW1BNvNrgNTCR4WK5XP5dhWQJrIYa+B1TJLETI
         AT6/cAF5WbPycahZqp/8viwLnHVvxVxgpiChyfh5YgLdIaMAQW3IiHzBF7Anw/9umB/I
         Gejrl7FspobLHIK+09GD/Viva8yPCidA1octIknO9wKF4PmMn4YceH7Y8PBFzGpnXJ7Q
         Yp+rwtMAilVeNWBpsecA2vh/UGEEUHVgTe06RmBwULL6favSoQWAN6CEjQbckT3Cp33i
         FpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fO2ujsDOBsfPR18MOLZf1FHyNYoGOBorzZoY5SulvNY=;
        b=iN0pwE5XCnSsd/Gar6VphYyAErKmVBi8/p7Wt8l1TFRbHaAUi9Ri5yT1+/kovuvWGa
         LkbrqHqiEEOpe9PjMSJc55UFdSWEcE5p3EwpQ8Svea0+8oIU0E1IY7aoXCEuFxTKpa6D
         UsRJmC4/PtjlVYbXn2M9yFf7/lKGoXuFv/+uNrmGLEVmnWz9MTu2yW2n5Y1GnE9vHWdr
         OPZhbX9KPHny0+R1xpvYzBqk00By3ZdNzeixf6UVkmsz8+/O3gyfahsIAsLZ7oGcb+x7
         TZZydegyoRVjRHUTM0xToU7iOTFJOzAWdMOPtiodvQRU0Lvkd8SVGGfO5PkUvI/5xo/R
         i1bQ==
X-Gm-Message-State: AOAM532eZTxKe4O31jSkG39FkrQLbrGSSwzX7jRSHpnB0gFtuASkv2Jg
        lrA9epuMCM0fFA8zWuRKZmE=
X-Google-Smtp-Source: ABdhPJwh3WoEJBgJBX+8e3y4zGIBdKmpqgIcEhkmEam1nw46cOgjjVufoLBLZt2bLlu2t9nJgIWmVw==
X-Received: by 2002:a5d:43cc:: with SMTP id v12mr15513788wrr.287.1616377807957;
        Sun, 21 Mar 2021 18:50:07 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id x13sm17653138wrt.75.2021.03.21.18.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 18:50:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: correct io_queue_async_work() traces
Date:   Mon, 22 Mar 2021 01:45:58 +0000
Message-Id: <709c9f872f4d2e198c7aed9c49019ca7095dd24d.1616366969.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616366969.git.asml.silence@gmail.com>
References: <cover.1616366969.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Request's io-wq work is hashed in io_prep_async_link(), so
as trace_io_uring_queue_async_work() looks at it should follow after
prep has been done.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ea2d3e120555..7f52fe924a11 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1239,10 +1239,10 @@ static void io_queue_async_work(struct io_kiocb *req)
 	BUG_ON(!tctx);
 	BUG_ON(!tctx->io_wq);
 
-	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
-					&req->work, req->flags);
 	/* init ->work of the whole link before punting */
 	io_prep_async_link(req);
+	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
+					&req->work, req->flags);
 	io_wq_enqueue(tctx->io_wq, &req->work);
 	if (link)
 		io_queue_linked_timeout(link);
-- 
2.24.0

