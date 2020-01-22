Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC94B145CE6
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 21:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgAVUKe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 15:10:34 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39601 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVUKd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 15:10:33 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so464990wrt.6;
        Wed, 22 Jan 2020 12:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hcH8umdVIE2TtHHLAnmoCtzkhig9VpAjEEvADfZ26RY=;
        b=Q25Hz6GQv/7lUw2ybU3ObDg0msOsR9Te4br75QFKWGPB15jKi6yKGh7ObcO6Jk9X4L
         fUMYHREY7S8/TCj/eezx8jIZoe++KfZT3g+DhGFNbRXqPbbUgBkM3md4wYx04cQYHMpj
         KJEfgHHx5AY0R6VgyddvkV9PqVXdrCtdgziQLtaeILHWa5L1WoDgwscihGBhImB2TyQ2
         cHdnSBkj/3hkn04+hraCZIkScAQkn7+MzOK5xjYMkYnpZJmecJ/0Zes6PSy5fB9q2O1i
         sfY9tsJQ9GXxfUcSXkJNrDC2eOmS2Uor2foxPr+v2LJgBL8EUsr0ZxTFOrmauaTmCyA4
         GwVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hcH8umdVIE2TtHHLAnmoCtzkhig9VpAjEEvADfZ26RY=;
        b=osJGFleXhF3b0W1eygx6x20+HYQFyKGdy9hVmC/uopHx7s+7cPDjMbUIeK+xuqKZb2
         Rm4juam93G/6YGkilw+dtxIxnDuWbCp84w5sEYbpnREPjzahIpCRHe80rFPCOhniYacr
         8/2jhFe9UDUellXW4XTUkH0TxJ0WxpJ2Cdo5P757rRdpLfN++65LKYP7cOSWzP3ag5TO
         a86Sme3XfzdpaOQEbVkSY9QFolQ91F/2oWg0wWZnbZbTREmlf8xdlLYXl/jUqgl27Fci
         jTqBS3dl2ag9XUjgP4cvx15Ql6UMkG/jq3wwxXJtbVa/TeD/Y5YBSYBRp6DUuKQrwZPz
         Yz1Q==
X-Gm-Message-State: APjAAAXkj8ZEwfp7ihOTiv1w6+txXQSGmTzGCjUWOPyTGEHF1YWrsuj2
        sA4kJxBFHtfHGN81Uihomqk=
X-Google-Smtp-Source: APXvYqwarkclAwysywh+NrobAmEO0FL9LXl2LaIDX7hegIfak2WVIEylImm6j6nTxYuKXo4+JAgf+Q==
X-Received: by 2002:adf:fa12:: with SMTP id m18mr12808699wrr.309.1579723831548;
        Wed, 22 Jan 2020 12:10:31 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id b16sm5058310wmj.39.2020.01.22.12.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 12:10:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] io_uring: prep req when do IOSQE_ASYNC
Date:   Wed, 22 Jan 2020 23:09:35 +0300
Message-Id: <278b05e5245d6b7878e105b5de0ad78ceab8c87b.1579723710.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579723710.git.asml.silence@gmail.com>
References: <cover.1579723710.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Whenever IOSQE_ASYNC is set, requests will be punted to async without
getting into io_issue_req() and without proper preparation done (e.g.
io_req_defer_prep()). Hence they will be left uninitialised.

Prepare them before punting.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 09503d1e9e45..cdbc711ae5fd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4558,11 +4558,15 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	ret = io_req_defer(req, sqe);
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
+fail_req:
 			io_cqring_add_event(req, ret);
 			req_set_fail_links(req);
 			io_double_put_req(req);
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
+		ret = io_req_defer_prep(req, sqe);
+		if (unlikely(ret < 0))
+			goto fail_req;
 		/*
 		 * Never try inline submit of IOSQE_ASYNC is set, go straight
 		 * to async execution.
-- 
2.24.0

