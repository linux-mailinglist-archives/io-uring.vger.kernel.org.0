Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF51020F47F
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 14:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387624AbgF3MWi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 08:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733305AbgF3MWi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 08:22:38 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45EBC061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:37 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e15so15973803edr.2
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wenUZZgiWBD3yJVME3aOxYEsv4HKfJajktwukZ0uKR4=;
        b=Z4JoGs18P/1i1SVxjk50Xb33rasZLe+L5SkpnaAZ7xZGcSUX564VCtR3kNVbcmj0ct
         lVAFHhkkivy6/GjMUOcqJg/F+JphV5DMf1zy0r4pyBHzKYCYt52nAyxLoLO66v3jZ++q
         mKoeC4qbXqOL6F1ih7YrFX0M4zeZaJOdJ0NzzsIY2TJOg4H4Bv/RbqNlNrshoEL22oi8
         EqmQ7ExKGTsOtGHjsAN1GLzjQT1Wi0guPHccrmPr+CdJYs9VZ+5hHpPgiT4pC4wEotiM
         5TEF03VcW1TlKFfINfAdOjd06nwAKgU/3iYNqm6Ji58bRhOs2A3E01Q0xFSe4q+sTl4Z
         85pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wenUZZgiWBD3yJVME3aOxYEsv4HKfJajktwukZ0uKR4=;
        b=cJRQeVdQSQdR6OEp+X0N8/i8PFTltgIY3EVATzO57CFdGSunrFH6Ir7dcvsu0GA0C9
         O9yDdmRd4GN5OZCcJuGl1Fw+lYs51pjE2mx+GE/nxWxQHQ7olnEU4Jg2G/GKSkHNaPMP
         fv1qNdj4wweiXLC5etHMHRPTYHP0j6Rgbzifoo8UpA1fXbwDlCUyyOy53Jk4+3NmaB2u
         gaG8DQtYlBUCCEjFDWxde7UEiQdqnXanuVgxKlCwocv5Mt3JDRVHaupwxyplnNpnyqPL
         nJRuTghPWU7keOtOGkftazJ1oFjQDt1HjxW0EZ+PjqqTgJh2yySKIv0KS8uNPvoTAaLr
         WHHQ==
X-Gm-Message-State: AOAM530/7ZAyHchKj4B8ivBNEu816F7AUomR4nOY6FG2n+7XsNxyS7Ww
        Z+5DhmK4Y9Iiwbh4VOf48w8=
X-Google-Smtp-Source: ABdhPJz2Y6uOphABuy2qsgO0Iq0NdcC+RSuv1b+GYwxlCdc5ZNfThu9Khqy1r/bXiIEHk4etw0NXHA==
X-Received: by 2002:aa7:c1d8:: with SMTP id d24mr23064397edp.178.1593519756634;
        Tue, 30 Jun 2020 05:22:36 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id y2sm2820069eda.85.2020.06.30.05.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:22:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/8] io_uring: don't fail iopoll requeue without ->mm
Date:   Tue, 30 Jun 2020 15:20:40 +0300
Message-Id: <077f8e268ecf1af22434cb2d23a5892f3d509530.1593519186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593519186.git.asml.silence@gmail.com>
References: <cover.1593519186.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Actually, io_iopoll_queue() may have NULL ->mm, that's if SQ thread
didn't grabbed mm before doing iopoll. Don't fail reqs there, as after
recent changes it won't be punted directly but rather through task_work.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c7986c27272e..589cc157e29c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1881,9 +1881,7 @@ static void io_iopoll_queue(struct list_head *again)
 	do {
 		req = list_first_entry(again, struct io_kiocb, list);
 		list_del(&req->list);
-
-		/* should have ->mm unless io_uring is dying, kill reqs then */
-		if (unlikely(!current->mm) || !io_rw_reissue(req, -EAGAIN))
+		if (!io_rw_reissue(req, -EAGAIN))
 			io_complete_rw_common(&req->rw.kiocb, -EAGAIN, NULL);
 	} while (!list_empty(again));
 }
-- 
2.24.0

