Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E299D20D23C
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 20:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgF2Sru (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 14:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729362AbgF2Srq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 14:47:46 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90DBC030F0D
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:20:29 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z13so17135846wrw.5
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WePRqNsgOkg77G2Yj0rJgh/Ry2K5wVAZYffTpZAhBIA=;
        b=fJE4ZKoQ3iJUud7QL7SZbN+NVbnQmFuAMw6lPdjshltiNFqYvr6nFveDK34bDHSgI2
         vCaxSZ4nxBcmhduTi7r2SkVzDHbutTqsssWndumXgVMa+x5VJ2MDsO5Ax8UHk4ttOe2Y
         om2xvY9WVO+7HBPmUw8U0qShg6ICF7C1SeQWG3ycvAN0DvYKhGxHkIr1W/GHHWG1w3E+
         szm8/6uIAF0A8/cbZeKqdQT6m6sMBwjs+rhO4B1hfd+yNNirpk8wzX/F8MBVZcLQpqA/
         NuMNGNXxKuU5SkM1DHXBWMK6avHoZnp0AXI0ilI0hPi9EOyxWIhW7VSC1YtlPVg2hHBE
         PVrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WePRqNsgOkg77G2Yj0rJgh/Ry2K5wVAZYffTpZAhBIA=;
        b=tLHvA4M//8zDWPm/pvYlOERgKONRf8wGFNrMSXU0+fg6SMoWtagJNe5UoOKqXww8rh
         ySahfAO/xk29bstiXsJGnof2bhXryvRnApVNsNJrk/tmqKQJEwVRwtJWD2y5WXm5U8Si
         kubyVvT5LCo/6nzlQY5TKWEeX+U38pmzjHMSbxI9MbghHMx9P3S79rt1tlJYoysiXw/C
         brP6UA+XkcvCvWsmC7eby6WxwdEnS6pNdrcOmTHWJzii7n+ewX2TGJHmw7IttrEjNcQr
         aQGSkl0VlM6W4nKTBMVA63ni/a3rwZNLeTneps+rAcnKJVXTE2LggRAy0SEi/Y1Iz82A
         XIUg==
X-Gm-Message-State: AOAM533rnVI8Yc97kfSFCTQMR6PG+TTswjlvRxtLxs+i8CWtODXfkMGQ
        8LVr9e0upexekS2GpqK9roE=
X-Google-Smtp-Source: ABdhPJwkR0o1R7HqJCRbRGOxAh4HEvF8wj0fv3O/NkGuGqPVfYElT3Qp4EjiXCQxQKZGnE2xjZcwlg==
X-Received: by 2002:a5d:51ce:: with SMTP id n14mr17749425wrv.155.1593447628483;
        Mon, 29 Jun 2020 09:20:28 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id 2sm282333wmo.44.2020.06.29.09.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 09:20:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: do init work in grab_env()
Date:   Mon, 29 Jun 2020 19:18:41 +0300
Message-Id: <52a5a51aef07842c09f64f3e251feba8903015ef.1593446892.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593446892.git.asml.silence@gmail.com>
References: <cover.1593446892.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Place io_req_init_async() in io_req_work_grab_env() so it won't be
forgotten.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ecee44a97c29..4a05bc519134 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1105,6 +1105,8 @@ static inline void io_req_work_grab_env(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 
+	io_req_init_async(req);
+
 	if (!req->work.mm && def->needs_mm) {
 		mmgrab(current->mm);
 		req->work.mm = current->mm;
@@ -1161,9 +1163,7 @@ static inline void io_prep_async_work(struct io_kiocb *req,
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
 
-	io_req_init_async(req);
 	io_req_work_grab_env(req);
-
 	*link = io_prep_linked_timeout(req);
 }
 
@@ -5231,10 +5231,8 @@ static int io_req_defer_prep(struct io_kiocb *req,
 			return ret;
 	}
 
-	if (for_async || (req->flags & REQ_F_WORK_INITIALIZED)) {
-		io_req_init_async(req);
+	if (for_async || (req->flags & REQ_F_WORK_INITIALIZED))
 		io_req_work_grab_env(req);
-	}
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
-- 
2.24.0

