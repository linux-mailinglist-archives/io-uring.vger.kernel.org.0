Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAE11C0675
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2020 21:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgD3TcZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Apr 2020 15:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3TcY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Apr 2020 15:32:24 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A21C035494;
        Thu, 30 Apr 2020 12:32:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g13so8542146wrb.8;
        Thu, 30 Apr 2020 12:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QcBQNnLnyfj2W1OL9YAi9BO15udOCD9PeBtZqYsr33w=;
        b=Q9EnKGcrPoDiOIdwDsTHlbPZvTAt0RYYYiBqmwhvUkREl5rOQyn0ociVNFzDoG+Vy5
         mlqdr1gawzaULE1plfXcVRpnzuh/YwThbNl/cImH0WOBJrGbTTzU9j/i1CJ3s8hApX7G
         gsMIFSFZgXnjt/ddeUG9nsqjFBYz10w7byw9v2/k26TkAPvZ27R0KJ1Tye7KfukJsOl4
         ycVBmK57fL4XNyYTnNeV+sLyf/cWR+oOLRejJlxSC9y7jYiNCj26hGvx7AfnjDmHkDLP
         Y57r/scurFuavstkE7k6bXZ+ly0jkprJ2A15kH0irtjDiqYxHXVIClNhswKT5B3xPwQr
         BTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QcBQNnLnyfj2W1OL9YAi9BO15udOCD9PeBtZqYsr33w=;
        b=nbce7Rlkz89ZLft595YV9MGqkGt7wciDgVPobIYf+MIa+QOqOyThnFKbSu9hHMvifL
         +ZqijmqUvcQaeVqDZhRpDgkQQVuzAYgxjNackip2JvCPhaRg4+xFnGk0F86wBFpu57SS
         iUdEKPHsAHz8ziOW3LUNFcqoq2eVkdMMxmyZFNx2cfZd2b7I/Qtzye/9DSVGOTanFqzs
         rjoqyDNuQE7Wz33FNXgp7NBVrEApJRz7+qvBiVKoIAQGN1UuSXU3TapeLWu/zsI8NYb4
         zDbHDSylAaERS5iqs4MmRxZk3teuf1fR8dZ8xM9zyOTdht+tNjgACJn18nudcaaLuVKP
         19sg==
X-Gm-Message-State: AGi0Pubig+wAEskNAjoDvuJedrdG63EHsG5Qi94p2NnlZc4kdj8DHKxb
        lbhvHH1HB+nNcWuM/ekwwMJDa97T
X-Google-Smtp-Source: APiQypIy5bfAADQda2QgCOoXStl9irHpMNpLn6TT/5oQO/V8h/ElihkjDH4IYX516RLs3ryKNgGRFA==
X-Received: by 2002:adf:e541:: with SMTP id z1mr143463wrm.218.1588275142679;
        Thu, 30 Apr 2020 12:32:22 -0700 (PDT)
Received: from localhost.localdomain ([109.126.131.64])
        by smtp.gmail.com with ESMTPSA id h188sm917002wme.8.2020.04.30.12.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 12:32:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] io_uring: check non-sync defer_list carefully
Date:   Thu, 30 Apr 2020 22:31:06 +0300
Message-Id: <af42fafe8b979917404b7ff17c446c262cc097d8.1588253029.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588253029.git.asml.silence@gmail.com>
References: <cover.1588253029.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_defer() do double-checked locking. Use proper helpers for that,
i.e. list_empty_careful().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8ee7b4f72b8f..6b4d3d8a6941 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4974,7 +4974,7 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	int ret;
 
 	/* Still need defer if there is pending req in defer list. */
-	if (!req_need_defer(req) && list_empty(&ctx->defer_list))
+	if (!req_need_defer(req) && list_empty_careful(&ctx->defer_list))
 		return 0;
 
 	if (!req->io && io_alloc_async_ctx(req))
-- 
2.24.0

