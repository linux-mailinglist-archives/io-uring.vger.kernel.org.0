Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F3217428D
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 23:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgB1WyQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 17:54:16 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36761 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgB1WyQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 17:54:16 -0500
Received: by mail-wr1-f65.google.com with SMTP id j16so4980318wrt.3;
        Fri, 28 Feb 2020 14:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Q5HM9keuf32jT5qBaPGGPz3nGNokU75QXhCCJ4A7QH4=;
        b=cRAEuxkjavIK0kjAvCHpFJQmU6+rogcW8K9+3Ty30zOZxVTCRxJjs+7IXBnx+CapfI
         gy0KJK2bI9rhStY82JpYS0yaffZZWgEmLPkIVXnd+8NL1+dY0TO3A2tEoEJYVICqAvG3
         PX7DJ5sFRP3FrAYRPuYLl/+/2VNUT1vINFrv5XjDbeO6pfNXY3g3Api7R5T/MC4lpXeW
         lmlSfNT67k9hVbTkswJWbEuE2PwxwgHYkwrT2W+J+zqqKXC4/KR4FSIZrRxD3Phpb8UZ
         e67AEC1TMlSYFdheMlOtH/r5ibEC8aDEiq4s2zYeBVXT+UV/cyE4laO9U76M3CWd5qx7
         Yd8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q5HM9keuf32jT5qBaPGGPz3nGNokU75QXhCCJ4A7QH4=;
        b=uHK3feIufi3uJ8nhuC/ZFQtoQP6MZ/AyiyZXs5LPz0JBkgjLlNx2HuaHmwbPfM07qc
         Vw9jv9v8dHe8XiG9c+R8RwDHPWak1qZdRvhtpD1wmfdE5erB0em9Q4Kx5dFe33/35Mwe
         XiKmAg9BYmXkU7cS8ozKLu/QxxgTI+vTPIEIzhK7BkosG9Fgs61Y6YSu28K/9G8kfCu/
         kft1zGoWO15IxwCt/8ukk0thD+r8ffiYX1RfpwAx4PiTW+JuUQuwzjdXDCOrVBTxzq14
         wx8Ty6wifikRpD/evGk+Mar9qZHzPp6NymByhLvGvFFPi4MK67Cvd6ON1jIkq1UjYazk
         qMNw==
X-Gm-Message-State: APjAAAWEJXaXtaZiBhamun++yLkqdEHUwaLV6FF8TWxbM0TbVrT14/Bx
        JXN2xHebmrfdqLC3GY5Duc1bRFY7
X-Google-Smtp-Source: APXvYqw/7SobmQG3UUX8rWTXHpy6ZfsVKyTrEgD7oZRSPOYM+0VIjf4vw/0IQDS3LiUzhimU4V6BrA==
X-Received: by 2002:a5d:4f8b:: with SMTP id d11mr6453317wru.87.1582930454025;
        Fri, 28 Feb 2020 14:54:14 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id f1sm14603773wro.85.2020.02.28.14.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:54:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] io_uring: remove io_prep_next_work()
Date:   Sat, 29 Feb 2020 01:53:11 +0300
Message-Id: <adc0dc18e4ac8f35d3fb5cb333feee89dbb4d7cc.1582929017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582929017.git.asml.silence@gmail.com>
References: <cover.1582929017.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq about IO_WQ_WORK_UNBOUND flag only while enqueueing, so it's
useless setting it for a next req of a link. Thet only useful thing
there is io_prep_linked_timeout(). Inline it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3017db9088cd..00039545bfa3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -974,17 +974,6 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 	}
 }
 
-static inline void io_prep_next_work(struct io_kiocb *req,
-				     struct io_kiocb **link)
-{
-	const struct io_op_def *def = &io_op_defs[req->opcode];
-
-	if (!(req->flags & REQ_F_ISREG) && def->unbound_nonreg_file)
-		req->work.flags |= IO_WQ_WORK_UNBOUND;
-
-	*link = io_prep_linked_timeout(req);
-}
-
 static inline bool io_prep_async_work(struct io_kiocb *req,
 				      struct io_kiocb **link)
 {
@@ -5951,8 +5940,8 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *req)
 {
 	struct io_kiocb *link;
 
-	io_prep_next_work(req, &link);
 	*workptr = &req->work;
+	link = io_prep_linked_timeout(req);
 	if (link) {
 		req->work.func = io_link_work_cb;
 		req->work.data = link;
-- 
2.24.0

