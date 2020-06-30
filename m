Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F3D20F482
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 14:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387627AbgF3MWn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 08:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733305AbgF3MWm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 08:22:42 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162D7C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:42 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g20so15737766edm.4
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=h6Ve2s7TO4CX8sSdo7A9+OtharQEjdZrYtxhyqDQ8aE=;
        b=WHs2ZtbsbCa8IxfX/MdWDT+lfO66NYHlwIRl6uQo7DDoEcwsleSIyYgxTM3M8xpcav
         4ndudeiuoosH0PXiJ9wLlwSw+c8//tyEpYzIhPR8TL7gsdPpVSG+9c5oJFCsP5xJIDX4
         lWSzFXs4C7h+azhoFcj9DdfvS8gI3WiUlEKNUWp4DxaOYNIhJqy5KmkUXA2RpgVS41YB
         2tK3aqIhdH5ux5Gz+NFKAkcmtVHvtsifsoyxovfhbb7/ZLB5VcMGLBwi1c1/AfPt4uE+
         f75ftKiRWos4b8y1TOp5q59HPtOUe2nkKOaXOaNtiQqrTeAukvA/M2g63WVy3lO5PqLK
         tsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h6Ve2s7TO4CX8sSdo7A9+OtharQEjdZrYtxhyqDQ8aE=;
        b=MCoco2ahukZptPBL6dQg075RvR1xGuqezAPxnuMZjbDdojUs4bfXrNwCUq2pF4jQJP
         2zSu63JvZkPILSr7k3uti3NswTPnHURUTHYlqdEySo1ftWLI6JFLNPQLdnbX9Gylmc+v
         ASu+gXiY3yRk/d3+FzfBhh22R1DmN+5BdnzLNhZyOl5bpSSavgHACePxWP5sIPn9DDE8
         4TXGeS1zTzf+2NP7PkfuwFgdT9Jt7jcAuImDmYQkIokldZMCLT9IQgzQl7EyMEQ+9dab
         ZgKRPvphEFEr5aprOoJ6ykBbFAQc8vz1eZ+1SCI7sgKcpPNMZBU5gXvwFVTSujsyXqNw
         b1Bg==
X-Gm-Message-State: AOAM531yXSj7Etvazy0IE8Jwcq3KMPNAEBbneQx+CpdzY+vsHZVdnIPq
        Vdt0V93JO/LVGEhbSTdVYOU=
X-Google-Smtp-Source: ABdhPJzuiBwufI9mRvVVwuVaQ5Wc5C/NDDy5UbUWUVly+2mkxoAE6jsgFaxeaNJZ9euVjZZKfNqwSQ==
X-Received: by 2002:a05:6402:94f:: with SMTP id h15mr23019492edz.313.1593519760863;
        Tue, 30 Jun 2020 05:22:40 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id y2sm2820069eda.85.2020.06.30.05.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:22:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 8/8] io_uring: optimise io_req_find_next() fast check
Date:   Tue, 30 Jun 2020 15:20:43 +0300
Message-Id: <79bf871cc697106b6f914a2c64f957a1de06e5d3.1593519186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593519186.git.asml.silence@gmail.com>
References: <cover.1593519186.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

gcc 9.2.0 compiles io_req_find_next() as a separate function leaving
the first REQ_F_LINK_HEAD fast check not inlined. Help it by splitting
out the check from the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 68dcc29c5dc5..8cac266b4674 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1643,12 +1643,9 @@ static void io_fail_links(struct io_kiocb *req)
 	io_cqring_ev_posted(ctx);
 }
 
-static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
+static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 {
-	if (likely(!(req->flags & REQ_F_LINK_HEAD)))
-		return NULL;
 	req->flags &= ~REQ_F_LINK_HEAD;
-
 	if (req->flags & REQ_F_LINK_TIMEOUT)
 		io_kill_linked_timeout(req);
 
@@ -1664,6 +1661,13 @@ static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	return NULL;
 }
 
+static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
+{
+	if (likely(!(req->flags & REQ_F_LINK_HEAD)))
+		return NULL;
+	return __io_req_find_next(req);
+}
+
 static void __io_req_task_cancel(struct io_kiocb *req, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-- 
2.24.0

