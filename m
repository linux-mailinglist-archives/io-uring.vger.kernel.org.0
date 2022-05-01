Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973275167E6
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238355AbiEAVA3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354820AbiEAVA1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:27 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486911A04A
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:01 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id i17so1969804pla.10
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+HMHm3yFZ2+0KrzlYra5brnoZBUnimSrhvp6PMGMNcI=;
        b=bIeUIzLp5EQcaF71rtyJWP2O4YJq+xdksWcpxxDU0+wn/BqCPYWPuclthpZvLbe5Xz
         zvChz1/lj3xyw0+W/hUs4+o4PR+Mub/BZ1vbHNd5+cArgIgfEuPBnhINlzTfXsZQTP/x
         yG1OSG+k92I1xQyi/DAh1OhIi5e8AFjnOs00QeZZ1t09L7tE2JL6j3kM+X3Zga0ticQW
         6SoypFwlmG86efTO9/p8moupPZ2/MMX+0dCZEhQ7odj/EaaaqNCGFi8CT3rYIVvrdM/7
         hhsRD4zOnePJgCkbUG4hYMBzxPFeb2w4haskHV4bWnMr0Y6NRTe1wkjiqhJLtTr91sBQ
         LsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+HMHm3yFZ2+0KrzlYra5brnoZBUnimSrhvp6PMGMNcI=;
        b=hx1s51vFRjbhzk7tGyvwoovc7nAfsuQ7lM3bdHDjs64FjIdKB9imhVk3kNytBk4H4K
         37WTsfn3+BhH/uXlXDkeKjKJIkgeosvW7LbSI7wTwWhNMYmol2tSBx9wvb+EO2pTsuZH
         pr4qlPNHd5jBrS7MDORFrv+KQUWp18srmVzXfqeSqU+YkWok89RN5Wtj8dHJd0tqrjQf
         ZhZyDWABjgLklUlo859/oy1Q2ofzYutDL8VO1KR1d3vqGuu8Z/YgPssX8NtKMSqN4Tls
         gYKqPZsAPRBtN/ETm+dSwDqLa+wUJ6QhFaSUwO6GmRjtJzhOxSpC4gz1BNpTAmoJrxl8
         a8iA==
X-Gm-Message-State: AOAM531W/gSrzeEXN5tmqYP5Uiw5tNb7DLTDjqidFJOaOh2/qUaNweiT
        JRya+Q62hwKbR94YNAfAaIVjyBEoUcnFCA==
X-Google-Smtp-Source: ABdhPJz1ezjo0Sd37twCB9BW2Pd+xHpDwL217CHnsDuCsbqwa++et/c+z1PoozffTCfZyFlpMLbjUg==
X-Received: by 2002:a17:902:9f97:b0:15d:1b87:6164 with SMTP id g23-20020a1709029f9700b0015d1b876164mr8659747plq.71.1651438620563;
        Sun, 01 May 2022 13:57:00 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:57:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/16] io_uring: kill io_rw_buffer_select() wrapper
Date:   Sun,  1 May 2022 14:56:41 -0600
Message-Id: <20220501205653.15775-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220501205653.15775-1-axboe@kernel.dk>
References: <20220501205653.15775-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index d9c9eb5e4bab..fc8755f5ff86 100644
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

