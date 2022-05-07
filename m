Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E664B51E7CF
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 16:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbiEGOeY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 10:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352506AbiEGOeX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 10:34:23 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63611582D
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 07:30:36 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id v11so8587410pff.6
        for <io-uring@vger.kernel.org>; Sat, 07 May 2022 07:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RvQ0Od73rlc6DodE1rZhJePXq4Ikq2/INgC0EIZyYtw=;
        b=Y5mlt4LmlZyxz9C+YeFIkXU34XXDMJTLB+M3PgQsPmZOpC6f7K9OEh1ePEFqjSAxeU
         c0oYGOMWOZc3qwX4OGphhXxTecG41Jz6mA7k08ZlX5j8YYZeZP4KGjuVUJhKsi8gTDbT
         WnWNGvsc/Wp6NF4Dr4tTdwAEbyHAmMNev3TfamYWZUcnwTGezXwaZroIT8R0Jy3FYAdx
         AwOlxnbQYHoaTm+x6jaUKX2OyiHGUIquAadO288/60b9m53G496hE2jF++cbJ7DKDTtm
         quJJjM4xJc726IQde8DWjTlBJfKAAUhkiYptcpfItjN8/7CJnfczxjQnMrjx4xbPtcMi
         xOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RvQ0Od73rlc6DodE1rZhJePXq4Ikq2/INgC0EIZyYtw=;
        b=BWuyT6YkVYEbNS3LTrFOBSeMdIhCnLOVhbeahY2+RgyU6QfPctRyIXMr6C0YALKFny
         iMSQClf7vlQ1UZXmrVvsmktGaXSODPv4YgAoWnA8mrJfAL09F4pY5bPG5sn1+INfZptN
         M+fBbVY5kjnydTPwoaQVwIukbbwlhKAsZUmWTt8VahS0LDt/UwHy5i0AklLfflvZGdN0
         jD0kusJjXfDu/ogccvleaTXZVjLPco2JYgGXpfwHzOP69dua6/Ln880AH0kh9z08SZ8h
         bJ0mNTouJqCEwUCvUv5wHgLw6KFl+Z8CoM3ZtYMgqeH07z08BPyC18SHVjMTJAQGyidW
         A94g==
X-Gm-Message-State: AOAM530rRTTaCYxjf9KCauOYSXEJxFM9qX5XFg7cHKUp1+G4wluM8V8z
        X1aXkrEJUboMvW9C0GoOcz3oiYuCgZIwWA==
X-Google-Smtp-Source: ABdhPJznq2KyzFIxXLG2mCSAJOQr6itgJNqLTbV6LrhVo82fAVYt9iUGhWrD7j3ex6jvZj09mkkmxw==
X-Received: by 2002:a63:5746:0:b0:3c2:363b:a88d with SMTP id h6-20020a635746000000b003c2363ba88dmr6638859pgm.17.1651933835679;
        Sat, 07 May 2022 07:30:35 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id h7-20020aa796c7000000b0050dc76281e3sm5332936pfq.189.2022.05.07.07.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 07:30:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: add buffer selection support to IORING_OP_NOP
Date:   Sat,  7 May 2022 08:30:29 -0600
Message-Id: <20220507143031.48321-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220507143031.48321-1-axboe@kernel.dk>
References: <20220507143031.48321-1-axboe@kernel.dk>
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

Obviously not really useful since it's not transferring data, but it
is helpful in benchmarking overhead of provided buffers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b6d491c9a25f..667bb96cec98 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1051,6 +1051,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_NOP] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
+		.buffer_select		= 1,
 	},
 	[IORING_OP_READV] = {
 		.needs_file		= 1,
@@ -4527,7 +4528,17 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
  */
 static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 {
-	__io_req_complete(req, issue_flags, 0, 0);
+	void __user *buf;
+
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		size_t len = 1;
+
+		buf = io_buffer_select(req, &len, issue_flags);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
+	}
+
+	__io_req_complete(req, issue_flags, 0, io_put_kbuf(req, issue_flags));
 	return 0;
 }
 
-- 
2.35.1

