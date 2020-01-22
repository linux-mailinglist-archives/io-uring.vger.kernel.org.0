Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBE7145CE7
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 21:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgAVUKg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 15:10:36 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38653 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgAVUKf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 15:10:35 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so469528wrh.5;
        Wed, 22 Jan 2020 12:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=97hUDGomP5N2F4tWBg0p6EMPWjoatVCKWy5V+71jKVI=;
        b=K1VBWcQ54ctNAav5rbBF3Y8q1MQv4jxSE7ibg7+E8cGfIGv1A6UtuzU9jHagkpvZBU
         gY/R+ptVQFD9ttvF7dmrkZqlMPCl3y+8cGs2o9kZSe7P05dHOLFs7m/YUumCxYvFC46v
         8AOYPZQItSekyROeoAjAJOrLLjjJW4ugV3n0Jz/5Xk14Hut5Or6hYl3Pv/BCSKPm4Aig
         b1MZOlTx+ISNfUpaF/xn+C9EvVA7O01EYLvOPuaJggYgiu35NrekyVwSbuIxsjIE2D6d
         DvsjWvkEnu7x/m7imhTGc4jymFKl41qwDymBB8xEMN7q7tNb+r0uNsxuwkCvQgSxjseW
         98YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=97hUDGomP5N2F4tWBg0p6EMPWjoatVCKWy5V+71jKVI=;
        b=qUKxuYrJzRSalJlD1C0UHHFRl2nEyNK5cFMWpp6V1MDTP7YSqDriDA5eJZQ5pTzfB2
         Fh1JMXSFctjjlLNtrkU+bQpD1DCFA2ETaErzcc9K6cbaGiazMJGp8jeVJYBAfoHp+dLJ
         sKy4EmdshGXd0WmW/ddTYkpcPfllhwGkHErDcvswsJT/vZ9PlJHtB8nLBwHHyKfyuAUG
         msS9eUNEP1qXC3LuvEo6Hh74rMPMC6ETGQgIfFbUSJ7jrNuFqJbQWo6FwBdDT2yeQLfM
         KQeXSThVaPKc5OVwbZE0cwKtA2KzanggE7O+WVvdvXj0dlt/5IR1yAI8BODjoXqunNd3
         oBiw==
X-Gm-Message-State: APjAAAWslWx+FQvCIzo/8wR6zzK0+y1pT4Q/UbabB2j3MvVMUJRWNq3q
        i0JyHvP3/9Bvk3iO6uuv+iU=
X-Google-Smtp-Source: APXvYqwtJFFMpINcfHwpkFhT7k0WB5DiNhDnxIYDISVer1aDFDsDWr60weA9N9lSGv5e67Uns/U4pQ==
X-Received: by 2002:adf:f244:: with SMTP id b4mr12517664wrp.88.1579723833351;
        Wed, 22 Jan 2020 12:10:33 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id b16sm5058310wmj.39.2020.01.22.12.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 12:10:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] io_uring: honor IOSQE_ASYNC for linked reqs
Date:   Wed, 22 Jan 2020 23:09:36 +0300
Message-Id: <202e6bdfee3fce1ebeedcff447afc14d3eb57898.1579723710.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579723710.git.asml.silence@gmail.com>
References: <cover.1579723710.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

REQ_F_FORCE_ASYNC is checked only for the head of a link. Fix it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cdbc711ae5fd..9f73586dcfb8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4512,6 +4512,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	 */
 	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
 	    (req->flags & REQ_F_MUST_PUNT))) {
+punt:
 		if (req->work.flags & IO_WQ_WORK_NEEDS_FILES) {
 			ret = io_grab_files(req);
 			if (ret)
@@ -4547,6 +4548,9 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (nxt) {
 		req = nxt;
 		nxt = NULL;
+
+		if (req->flags & REQ_F_FORCE_ASYNC)
+			goto punt;
 		goto again;
 	}
 }
-- 
2.24.0

