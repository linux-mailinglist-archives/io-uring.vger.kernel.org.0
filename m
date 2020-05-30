Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5601E90C4
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 13:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgE3LUq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 07:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgE3LUq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 07:20:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C3EC03E969;
        Sat, 30 May 2020 04:20:45 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e1so6739632wrt.5;
        Sat, 30 May 2020 04:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vXWn47TE90eGiLxqQk3ONlisC+zbjCcIk4mwisteZWs=;
        b=RUMlm3wSLWy2c6Q+QSeNgrNkeOn4nEkxFlevJESeOso872u09RMqIfp90xSqc3d2k2
         VDTXjH74cJPAZ9rcpAfxMWTtE0IO0zT5+T3Y8dyG3WnRYAR/7AV/iuNXswzFZROzosvN
         cPvL5SxhbfITCiZzXBJ2kOH9zOCnElwQjqNoIw11bkuEPHbeMy26iSXL6N9JkTeBlIz1
         Pj34BJYTZ/vi64SeYPrRIDjptGYxCJnrVzEm4X9zjYq9Et2SN0ttHyV/eEuBnqcNmJWO
         vancTiBdtMYyIdFpvc2cj4pXBcQyPdT94klQVZx+o0HxlFujTa3j1e0BOIqvTxtsNftD
         Mzig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vXWn47TE90eGiLxqQk3ONlisC+zbjCcIk4mwisteZWs=;
        b=AlTuurqk5FkupZa+hJ+VENBBsTgU5s7SJMwTLyfr3oiC/HSJW3hhBkTKY88l7CE6Zu
         nIG358eDGbYJehNH2VSNjuFR4WfysmoEodejIDIGbuFPMC66sd0IVnXPCIZKY5cBKJzx
         rRiD5KY5Eo+aSijcUuJQbfj5eE4d36KtME5qEO7H1vyda5kEAVSFHmcGjsVgN8UsVL7q
         guJibqDMLv94QSFvXdHu71t5xysLYUjZfHImDdOZtK7CnQot9EPRgohuwzjfwW2EWxyb
         f4IJjyiCAGV5Ynw9MEAjCE4MbrSM8nt+IMsh+Z6LiJfCURAvuvSAyq6VvMkC9hHgxbDE
         1EEw==
X-Gm-Message-State: AOAM532BqebcCBgxr6ciZHeQBLBFW9Twgyk7YlbzL/pn9NdNrVTs1NK9
        weaHMIQX8t4wYW6K6NGBTmcOi8yH
X-Google-Smtp-Source: ABdhPJxMg54pdr5IG6e4D0jqmnGC8oWGOw/Pkt/1HrSIGsvHSU7vbZZxOtngcI7dNDKn5KL8mVnnog==
X-Received: by 2002:a05:6000:10d2:: with SMTP id b18mr12894992wrx.366.1590837644353;
        Sat, 30 May 2020 04:20:44 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id d16sm2982825wmd.42.2020.05.30.04.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:20:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] io_uring: fix overflowed reqs cancellation
Date:   Sat, 30 May 2020 14:19:15 +0300
Message-Id: <955c64413e6f3883646d8fdaefbf97438f56acca.1590832472.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Overflowed requests in io_uring_cancel_files() should be shed only of
inflight and overflowed refs. All other left references are owned by
someone else.

If refcount_sub_and_test() fails, it will go further and put put extra
ref, don't do that. Also, don't need to do io_wq_cancel_work()
for overflowed reqs, they will be let go shortly anyway.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: don't schedule() if requests is already freed

 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bc5117ee6ce3..b1c30284efbf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7447,10 +7447,11 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				finish_wait(&ctx->inflight_wait, &wait);
 				continue;
 			}
+		} else {
+			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
+			io_put_req(cancel_req);
 		}
 
-		io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
-		io_put_req(cancel_req);
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
-- 
2.24.0

