Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD1822B4A8
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgGWRTW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 13:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgGWRTV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 13:19:21 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C711C0619DC
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 10:19:21 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id z18so2346527wrm.12
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 10:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6vnlILE0QeheBa+OdXQ2mMuDNFHRmUJzX4rvnN0OjKs=;
        b=tc2fx2YnzT5Lff6DqFE9m8QrEeFyBD1YivsFKpHJC4pa7DrGqkZJ/McE4aNZ9CHQKu
         0E/RK2EXYSzQ/1eGv21vNP6Sk6VEv8/KpwU6wjiEHk8lWtQfs9eDCulciP8riWtWfs+i
         tzwmyOgCusl00uN/Bd2COFKQ2opXsIzAg6adGgHehzWAa1fOPg9XBH8jbDI33ZjvKLf7
         CcKdTZD1sw3aY3VOpdszQUCHupb1Tsrl8YdxTYwPDzR3MJtOCf2erWAhGUP0dX1qrLDW
         ceGtMxmv1f/6P29RXu3ufBgp5mVKLlCl1uZalj/J7cnV4FSyD2G+sd8A96WEmwCmTqC1
         rjSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6vnlILE0QeheBa+OdXQ2mMuDNFHRmUJzX4rvnN0OjKs=;
        b=rAj7OCMuzBbFiGOFPldYnDFPfY3W1zYs2fcyDqH1XB8BHmzySM5IjWoWcEkX2yt2mZ
         Xlz4gjwYqq7KCXy+7ExSIMNKpHwIra7G9QnAx8uV1552Xpk8yrtnKgl4AZtFyRzsUFDC
         qszkQmihnBU2dVwVtKk6Mht81rViuEWgD3o/roCe8tOau5cTnliWjxjFm+0KPGFZYE4C
         RZWwf8UUkuCIP5rGwHclEjJd8lFApp6WTNRL1C82ULgWpIPvCGIVErRXlb/g2Cws3iWK
         KwJoN0zDz7qppLq/HJeVOtU4TadJoZa2iPH5rvObVQ0qTvPkYojEZJivwsxq5oX385a9
         4Pyw==
X-Gm-Message-State: AOAM532znrWxeCt2r7I2riF3v+Ct0Esr3QvxCcBhlm3Opq9HTTbBToGk
        SYwZ5NJqbQo1X95LEycOTuYt/VvX
X-Google-Smtp-Source: ABdhPJx5Vbn/rm586V6ma8KD1LSiPq74Nh6bNFdGhHY9MCVyuGA0nFDQa1pHTy3XM3QfSRvD3D5eSQ==
X-Received: by 2002:a05:6000:1290:: with SMTP id f16mr5347337wrx.66.1595524759748;
        Thu, 23 Jul 2020 10:19:19 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id r11sm4063369wmh.1.2020.07.23.10.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 10:19:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.8] io_uring: missed req_init_async() for IOSQE_ASYNC
Date:   Thu, 23 Jul 2020 20:17:20 +0300
Message-Id: <fded2ef29b36bcdba4e9faf2de6a1ef2097c6bbb.1595441706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IOSQE_ASYNC branch of io_queue_sqe() is another place where an
unitialised req->work can be accessed (i.e. prior io_req_init_async()).
Nothing really bad though, it just looses IO_WQ_WORK_CONCURRENT flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d99802ac166f..32b0064f806e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5730,6 +5730,7 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		 * Never try inline submit of IOSQE_ASYNC is set, go straight
 		 * to async execution.
 		 */
+		io_req_init_async(req);
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 		io_queue_async_work(req);
 	} else {
-- 
2.24.0

