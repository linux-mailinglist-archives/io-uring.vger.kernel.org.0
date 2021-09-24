Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABB4417CB5
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346564AbhIXVCn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348467AbhIXVCi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:38 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F87C061760
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:04 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id y12so4721398edo.9
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Vj1PaydSJKh+TY/Aws6krSj4m27DCkbPMTf1+t+Bb1g=;
        b=kMU81SAmvCiyB5PzHv53630l/v2G/tOXttdZOx1wDqywYzbktLWDafRk1kGg4TzGBy
         QfEhPDNqywUilfw9XLOXbe4t4MqWTukIy65cA/UeAUP4Ok6odwOiNEHnekWIP6GbRsed
         XZ36VE+9pR1ECcLyXyzal5rS0OxaxDYMbThBuDwX0Y8IpQS/9zuDUNFWV7l3VlGxi9Uk
         YY/a5q+nsj283X5uZGkaFpjFgjsrAi9sUzrXJ3RiSphbmTUiRR9KBLz2JrnWljcbYbH9
         5UTL+XCQMAeNe9cTERVvcwKw6guO561wO/bBlnlk3kD2i5bV4/mEIrbJRRz0rlIjutwy
         3MPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vj1PaydSJKh+TY/Aws6krSj4m27DCkbPMTf1+t+Bb1g=;
        b=KNjz0vatPUdj3KY65jUiUPkWEUtO8GDIbhWr61KaQkk2mpYwF7Wl872DTwv8n6z8be
         1CpBcsfGUEhaXROPqFvzEI3dYfh4fEqtpyhZbYRLBqWzCj+5EhOqJjBtswUE3eeMDvTX
         wl/AdRAbbBWuSRIq5E9wTOlMDykk0txx/kUn7I3lUGMMcaglGAUA8aA5mIVZJHU1yeH3
         sfP5Vwhmv3aO16ZsDxpJT/PFOYh/6unFcKNMiqUFNZPF1pJsVj9RsbVzEYiGlzlnrOMK
         jSA4Jh9vtPxHgppfjS6t7J5bIJXuTG7QgreZa8ENyjRP9zQgGNSu3YHRmqN1k5MsEliS
         pCtg==
X-Gm-Message-State: AOAM531mN3qyySocBxL/MD2cbclDXNeldhASm+TA6y5AMLDMl7U8UL6X
        v7hK8fPzyjKaB/HPo5qWY0FMtk/LgJ4=
X-Google-Smtp-Source: ABdhPJyIqJZclM/s9RxUBE55APPXp0QuyhpHlxcs2FKx3B3ta3bNQQFw79Lwo2LNjyxzUoSEwnHFeA==
X-Received: by 2002:a17:906:3c56:: with SMTP id i22mr13880082ejg.287.1632517262911;
        Fri, 24 Sep 2021 14:01:02 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:01:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 16/24] io_uring: deduplicate io_queue_sqe() call sites
Date:   Fri, 24 Sep 2021 21:59:56 +0100
Message-Id: <506124b8e767f0a4576f7a459f6aea3d13fb4dda.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are two call sites of io_queue_sqe() in io_submit_sqe(), combine
them into one, because io_queue_sqe() is inline and we don't want to
bloat binary, and will become even bigger

   text    data     bss     dec     hex filename
  92126   13986       8  106120   19e88 ./fs/io_uring.o
  91966   13986       8  105960   19de8 ./fs/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bc2a5cd80f07..271d921508f8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7125,20 +7125,18 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		link->last->link = req;
 		link->last = req;
 
+		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
+			return 0;
 		/* last request of a link, enqueue the link */
-		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
-			link->head = NULL;
-			io_queue_sqe(head);
-		}
-	} else {
-		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
-			link->head = req;
-			link->last = req;
-		} else {
-			io_queue_sqe(req);
-		}
+		link->head = NULL;
+		req = head;
+	} else if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
+		link->head = req;
+		link->last = req;
+		return 0;
 	}
 
+	io_queue_sqe(req);
 	return 0;
 }
 
-- 
2.33.0

