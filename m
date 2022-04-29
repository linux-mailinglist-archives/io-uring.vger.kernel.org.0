Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B785851493F
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 14:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359117AbiD2Mbd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 08:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359010AbiD2Mbd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 08:31:33 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D3FC90CB
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:09 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id bd19-20020a17090b0b9300b001d98af6dcd1so10358375pjb.4
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i7TIG4NztsbSAuiosqi2uXAolv1e4wOynyZFPMuUeV8=;
        b=7a34Km2I5IJ+3mBpL1TA3laU5QYM72SJMlNdf/BExH9Jtfdng9mhDMlWXcJJw0hgKj
         wIZ7Iin3iWr35i7qfSXDsDyWejzBosORm6qOg66xHABEbaLSf7EgAO5tvLy93fLuICCm
         E/cRBpFcDj6TNy7tQM/lBTRdyE7rcddU858264B2kz77cOIHnQEWMWXWqiJQ9VtrNIRT
         F9em5c4nsjsgxtgeMfHXQtR6AbStraM6rgLktfpwRyhsGQBJDJ79yzIG02Wr2RekaHXd
         0VhPTr2eypHk5+HvTu7anMW6A68sNsYwG1WPM81do6vlheUjXNE+HogR60Jjj/tAI53l
         TtWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i7TIG4NztsbSAuiosqi2uXAolv1e4wOynyZFPMuUeV8=;
        b=ekBUnhTZSVVbxnf2R/v8dMFjH6m+nOkkUYRlbhrPDPkumCV37DjzCSIG0qFqe+YkEK
         OisasAE090rjGgF5/X2BjGH8B9PpR3PrPf0FWHkX02a7wSibSP8S7ZYBrQbWNKRVWjA+
         GIXaRwhxdETNB9qyCcPmWePgQWYKsJP29ycxfxXtE8tSg821vOnJgUpJzBEj1MUL1vK+
         icamlJYzpPiVzNNXw4UIj7UOj2AqorFE+SzdlQ2rc9wvgXRNjF14ShR8e8XB5+wLOwYi
         jsv4Ua/rQpA65/icAXPJhhAR3gvprhQJCB1Ih6iZ71nnDlrOIV+EKvIYyhSeFs2jJAY5
         izoQ==
X-Gm-Message-State: AOAM530PPuB3Fn6xP3BQmabtxcWXbnoiU7iY/xN4/zKXDTI77LaAXAhM
        O8TyJN46EgojvpHNj1vh2woJ9KPYqQJPAlf7
X-Google-Smtp-Source: ABdhPJw9BffY43+WGw3EEE4ksXISo7eEGVnarzXsCoKjfD2d5xKmW2YXHbsCAGEsRhNDD3ZyHjnv8Q==
X-Received: by 2002:a17:902:8b8a:b0:158:983d:2689 with SMTP id ay10-20020a1709028b8a00b00158983d2689mr37737409plb.173.1651235289119;
        Fri, 29 Apr 2022 05:28:09 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o26-20020a629a1a000000b0050d5d7a02b8sm2895837pfe.192.2022.04.29.05.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:28:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/10] io_uring: kill io_recv_buffer_select() wrapper
Date:   Fri, 29 Apr 2022 06:27:54 -0600
Message-Id: <20220429122803.41101-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429122803.41101-1-axboe@kernel.dk>
References: <20220429122803.41101-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's just a thin wrapper around io_buffer_select(), get rid of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dfebbf3a272a..12f61ce429dc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5897,14 +5897,6 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	return __io_recvmsg_copy_hdr(req, iomsg);
 }
 
-static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
-					       unsigned int issue_flags)
-{
-	struct io_sr_msg *sr = &req->sr_msg;
-
-	return io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
-}
-
 static int io_recvmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
@@ -5961,7 +5953,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_recv_buffer_select(req, issue_flags);
+		kbuf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
 		if (IS_ERR(kbuf))
 			return PTR_ERR(kbuf);
 		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
@@ -6022,7 +6014,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		return -ENOTSOCK;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_recv_buffer_select(req, issue_flags);
+		kbuf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
 		if (IS_ERR(kbuf))
 			return PTR_ERR(kbuf);
 		buf = u64_to_user_ptr(kbuf->addr);
-- 
2.35.1

