Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3AA121EE4
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 00:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfLPXWv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Dec 2019 18:22:51 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41609 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbfLPXWu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Dec 2019 18:22:50 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so9298139wrw.8;
        Mon, 16 Dec 2019 15:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PfoekJF33vEArsslh1MwtUuiY2wZfRR4fcKoCsE44HI=;
        b=TayNDd3kgfRhq7/GYpaErGcGi3IiSFNBVtVBMna7SEyVceDaieNqN9qmc+UwsHT7Tu
         RiOLdYegTIYwrV7/c6/u47X4sFUwYY7X8ClB3GSzG4o6YSodxocw+8vbPs2pDadmALKy
         /zKYd9ZWGlED3Ecfmglh0vsjIxOuO4SA7Q04n7VgAY3dgWQ8BbaUVTDBnfZz4EUq0roQ
         Oe1K2H1atpUEaZoktUqnhortZr3BYtlEcwSRX0bXOFDC04OFVwPAWjwILUy6GWodAylX
         0trqF6ZnhqmL/GKDUngmjxFR5pK0dKpq44hCXSdUk6XM1Vf3nBSinO82ui+53tKBv+mb
         FGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PfoekJF33vEArsslh1MwtUuiY2wZfRR4fcKoCsE44HI=;
        b=j7u+KGW4+Z/s2VXfukpK0RY6vJxL36i3P8Tg0OIZOETjsrMbAm0UFdjvDdsqr4H85K
         B1NhhEPl7ZYldAyiqoqtAj6JUkmSAQ4fK2NVfHJhEQ23LSdTHdAxmAvQD2pNzn+P3Jzm
         TkJ0+cvnDWf6yX2q2x3c1pRwd0GgVLkott+Py1/YSMYhff4WOSfLt+0g1Do6uH5cF8Gt
         WpmQPs79yrBorzCEQsBVat3q92bN39z0SWuQqJ4inHz43Xe+0803JaqskOwnrVCI1IZR
         icT+jWAMt0+hI+DVSUJg/WGG0OKya8Q4smw84xYzFtQQSVKGujxHxLeK8c1FlMZ1z78i
         D0qA==
X-Gm-Message-State: APjAAAXIwo7C/+RDammk4NGQIIKfjEUpO+M2tKZQgfxf8W+/VFd3Wagq
        vqIEPFMMu9aeq6ief7NCmb0=
X-Google-Smtp-Source: APXvYqxUlnm16B49wgvC/qV6Z9yOzm2SiT+gQoVWwff9hbKN6irp4X908nmSHDcA7hBenj/Bf8u8Bw==
X-Received: by 2002:adf:82f3:: with SMTP id 106mr33953977wrc.69.1576538568583;
        Mon, 16 Dec 2019 15:22:48 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id 5sm23526167wrh.5.2019.12.16.15.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 15:22:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] io_uring: rename prev to head
Date:   Tue, 17 Dec 2019 02:22:07 +0300
Message-Id: <13d9584a55d8ff902650678a480021b7109c153d.1576538176.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576538176.git.asml.silence@gmail.com>
References: <cover.1576538176.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Calling "prev" a head of a link is a bit misleading. Rename it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 339b57aac5ca..96ddfc52cb0f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3399,10 +3399,10 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 	 * conditions are true (normal request), then just queue it.
 	 */
 	if (*link) {
-		struct io_kiocb *prev = *link;
+		struct io_kiocb *head = *link;
 
 		if (req->sqe->flags & IOSQE_IO_DRAIN)
-			(*link)->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
+			head->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
 
 		if (req->sqe->flags & IOSQE_IO_HARDLINK)
 			req->flags |= REQ_F_HARDLINK;
@@ -3415,11 +3415,11 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 		ret = io_req_defer_prep(req);
 		if (ret) {
 			/* fail even hard links since we don't submit */
-			prev->flags |= REQ_F_FAIL_LINK;
+			head->flags |= REQ_F_FAIL_LINK;
 			goto err_req;
 		}
-		trace_io_uring_link(ctx, req, prev);
-		list_add_tail(&req->link_list, &prev->link_list);
+		trace_io_uring_link(ctx, req, head);
+		list_add_tail(&req->link_list, &head->link_list);
 	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
 		req->flags |= REQ_F_LINK;
 		if (req->sqe->flags & IOSQE_IO_HARDLINK)
-- 
2.24.0

