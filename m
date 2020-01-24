Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBED414905A
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgAXVlf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:41:35 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39553 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAXVlf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:41:35 -0500
Received: by mail-wm1-f66.google.com with SMTP id c84so874085wme.4;
        Fri, 24 Jan 2020 13:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Zv+vOrgLNOpe53IoSaSlxj+x4kwfy4SyFSHKSK5A8PI=;
        b=Dvf5EScZHSJyaeOEsZuZ2QAvcWQU26U96bwlt+O18D0BOdF8e5rNsP59ixrt2jQvcG
         ahGz/PCxm6cC5rGU1EJSKE1R9G8W6sME4rmJYu9PegoopSWaQ5jkHyChdj7JcpSjd3LK
         Buu4UqCl8xX0KBj39++m81xat4TOSGmmlbl8vBtp43vPiTedeQiEF3xk45ahU8jwWIsY
         qPsxKF3bqJiI0Ts5i2zgsgcSYRP+7FkmSVgDWhTU0HEf14FYMmNDJLqIiVaseGz5viZq
         MV8Sa6DYOc8ofoSz/HfnmAH3ioWNQEN9ikqYJ/0jWKE8iMtmEVQ3yx4ElqPEi45MS8MQ
         /EHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zv+vOrgLNOpe53IoSaSlxj+x4kwfy4SyFSHKSK5A8PI=;
        b=iDfOvP0zslbmUD1VzgKH8TT8ZA1QNBJrXhWSzyk3KglQYB2QSg/AIXqzfCsFPdldAF
         +TKbjsm2Ua1wvU/MFx2mvGGDUksKfZX4dntSyQJiNb/2eG285u/D6W2KnlywViXb6Z6f
         0Uu1DjBFTPTN5y6A3SFfqd7Yb9pvUfM7hNVGE21LissH52wxherq9TpvZZrswzYMBaD/
         8XrD1YUJ05k/sTd36g/VVU/249PPyr8qf9ovjG33Nd7OkWNk5o+WrK90x8nOv/ColTnL
         YvFSxTKym5sqhigLYrbzmk1N17uJKf7AkD49UOKGdD6EGR9vsS0pjG8rA5GtFPIRJpB4
         0Njg==
X-Gm-Message-State: APjAAAUlI+Q9Z1yhggC1QW1I+gw09bLP1RNYtPS808PdNbD4duYZ3AeF
        CsnPx/CRsBqhO97AfX0XF0kHTBbg
X-Google-Smtp-Source: APXvYqxGeizgVz5Jc9R5i2DlKhSyhQ2SQkVUv4EjdskqsXV7d+nN0kEOUtQCHidO1b8UsEow4Chq7w==
X-Received: by 2002:a05:600c:2c7:: with SMTP id 7mr1025647wmn.87.1579902093346;
        Fri, 24 Jan 2020 13:41:33 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id f16sm9203055wrm.65.2020.01.24.13.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:41:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] io_uring: add comment for drain_next
Date:   Sat, 25 Jan 2020 00:40:24 +0300
Message-Id: <3f1a011cf07e6a100270ceebd24e53e305f5ae23.1579901866.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579901866.git.asml.silence@gmail.com>
References: <cover.1579901866.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Draining the middle of a link is tricky, so leave a comment there

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 25f29ef81698..c7b38e5f72a1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4702,6 +4702,13 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (*link) {
 		struct io_kiocb *head = *link;
 
+		/*
+		 * Taking sequential execution of a link, draining both sides
+		 * of the link also fullfils IOSQE_IO_DRAIN semantics for all
+		 * requests in the link. So, it drains the head and the
+		 * next after the link request. The last one is done via
+		 * drain_next flag to persist the effect across calls.
+		 */
 		if (sqe_flags & IOSQE_IO_DRAIN) {
 			head->flags |= REQ_F_IO_DRAIN;
 			ctx->drain_next = 1;
-- 
2.24.0

