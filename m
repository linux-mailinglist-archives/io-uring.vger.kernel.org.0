Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BC751608A
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 22:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245090AbiD3Uzi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Apr 2022 16:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245115AbiD3Uxw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Apr 2022 16:53:52 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E5A13F40
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:30 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id t13so8989226pgn.8
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ir1zQDZM6EBwJtIyTARxfUt8cxorOdhcKE02hweV0WQ=;
        b=n40XryvDnPNfo/MG2Lah+8FSfqd4qW4AN1MWV9/1Dy3fsxwTfkpz0oYqptGVdlY2Ie
         L/CnEDALUOjjuBsimdgnFb8lQV1XyMtt98Ubh7U6dYNvlGAanO9w3Bp9v1IvnsOrtWbk
         le2LdSTvjPzC9cXgP8yoV0qh/bwqKkHLUipc9/WHDfs8Pyv6nEH/Vcwmk2rYk2+VlmzJ
         mA8SRbBy7CfOQ82cVFlOrME07z388SL+pG9w6/aiB9MFKjKwoKA1KLkbrKBBnd6swDoA
         bwMcnxX/ML2VXu5PcvJsD1WuKbVi58gLwDeQznvchBIopEFOA/BDMZ1hiWEcFbyFMqOw
         hJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ir1zQDZM6EBwJtIyTARxfUt8cxorOdhcKE02hweV0WQ=;
        b=yZWp92e675obBQGwxllPAuHjhgsAvSZyYTOuVQZobDSm7QxE2WTjNTrsusjKfFl4Tg
         NJyZOtY4YSDkNLIoWtj7zSypoC46CgGU6tDv/1iq6iSiLD7l0pT6RAiW1dET98Y2kKj6
         HXZ+DfAuKUobHA7vRlO4BsIxScaZDEa5s7Jf1tJ1k63IPGjZe4oUcIi+t2ZATqwB+Qsq
         GJzEzxi27u31trS2IS1CPKF2wVF2WBrD/O/yaMsab7rgok1aN/MSXKNJS8tJnd7A4L8u
         lp5gQD+GI32YfQLqJh0RqVbv7VGAbeKfVM9wMKUqrJDho2k8NwewG4bib3jAefBHCRd9
         ao4Q==
X-Gm-Message-State: AOAM530M7PvG8+rAu9j6qGv7oIGRJra9eTTdRuEzcx/fw+YdaBxgkMuV
        G0OESsedN8JrctDzA7xZppcQiKSd/iLEt8bC
X-Google-Smtp-Source: ABdhPJw/klYJVCahJ487pbt0LK1YmOMjlVYJIvXNRiJMe3HFG5VTswHxciiEThqrZNHnd5bbfZDkIQ==
X-Received: by 2002:a63:8ac1:0:b0:3ab:199:cbdf with SMTP id y184-20020a638ac1000000b003ab0199cbdfmr4080434pgd.466.1651351829238;
        Sat, 30 Apr 2022 13:50:29 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0015e8d4eb1c4sm1854066pld.14.2022.04.30.13.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 13:50:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/12] io_uring: kill io_rw_buffer_select() wrapper
Date:   Sat, 30 Apr 2022 14:50:13 -0600
Message-Id: <20220430205022.324902-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220430205022.324902-1-axboe@kernel.dk>
References: <20220430205022.324902-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After the recent changes, this is direct call to io_buffer_select()
anyway. With this change, there are no wrappers left for provided
buffer selection.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 19dfa974ebcf..cdb23f9861c5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3599,12 +3599,6 @@ static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	return ERR_PTR(-ENOBUFS);
 }
 
-static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
-					unsigned int issue_flags)
-{
-	return io_buffer_select(req, len, req->buf_index, issue_flags);
-}
-
 #ifdef CONFIG_COMPAT
 static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 				unsigned int issue_flags)
@@ -3612,7 +3606,7 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 	struct compat_iovec __user *uiov;
 	compat_ssize_t clen;
 	void __user *buf;
-	ssize_t len;
+	size_t len;
 
 	uiov = u64_to_user_ptr(req->rw.addr);
 	if (!access_ok(uiov, sizeof(*uiov)))
@@ -3623,7 +3617,7 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 		return -EINVAL;
 
 	len = clen;
-	buf = io_rw_buffer_select(req, &len, issue_flags);
+	buf = io_buffer_select(req, &len, req->buf_index, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	iov[0].iov_base = buf;
@@ -3645,7 +3639,7 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	len = iov[0].iov_len;
 	if (len < 0)
 		return -EINVAL;
-	buf = io_rw_buffer_select(req, &len, issue_flags);
+	buf = io_buffer_select(req, &len, req->buf_index, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	iov[0].iov_base = buf;
@@ -3701,7 +3695,8 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
 		if (req->flags & REQ_F_BUFFER_SELECT) {
-			buf = io_rw_buffer_select(req, &sqe_len, issue_flags);
+			buf = io_buffer_select(req, &sqe_len, req->buf_index,
+						issue_flags);
 			if (IS_ERR(buf))
 				return ERR_CAST(buf);
 			req->rw.len = sqe_len;
-- 
2.35.1

