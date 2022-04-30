Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC3D51606A
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 22:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244371AbiD3UyI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Apr 2022 16:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245104AbiD3Uxu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Apr 2022 16:53:50 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42D6140EA
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:27 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r83so9012526pgr.2
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i7TIG4NztsbSAuiosqi2uXAolv1e4wOynyZFPMuUeV8=;
        b=j6gDxinPrNYI2Veibbe/FHBHyevT2WXpJfuF5pNfrs2rKB48kreNIqlcOIOW2wWKOc
         Xo7aGtszp2IeUaRdiWXXK3AIfMF4aQrj8pykosyD5w5HSIuXed7pZL8V6/T9AKA1n1cJ
         oJqXYekAkEhXfhJpjaauUCO0z1TnRaO62Eq2suNVXGdA6rpSzXEu9H1bQV08CHQR5hfo
         ubMUwQG8rs/Q6qbNHSGqdnw7O+ItfUMr7uZG75d/6e3/O8lsEYyS5/Tdr9+ZXgTcG25y
         NQzn+cRo1iElEGR2M6WVZ7HR2pk8Pu0V9vB0LIr7+RXfZzdqN7UysHCPC4BazkJSL3Of
         jqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i7TIG4NztsbSAuiosqi2uXAolv1e4wOynyZFPMuUeV8=;
        b=mkan0lcUMVl9oGySqaOcTKCST6d4Qg1ke+ENyPoWUQ9OJDH0lnyQ0JHsa/EHMFL+Dq
         MryzwK9DtUVNDdnBHt0oSbdr0bKBAOGHgqR/hn4DkmCxxmakMLuX56NrHFTL2jhZt6Ve
         SDXrv/2EVqiSLih7RH7ce8F7XCVMbzXhBBaehBfewZdOngJItGCdUfo9JXAvSizHfRlA
         t7mbf2dKGciU1Ea5nitMbZztPnbmMs23ql+OeOTCERmKCC7EfN9sc578CWnGqndsybNt
         wIwZJ6uKl/2PEIPAvLZVU5S+y4r3dy/duODUfBZkAw64FfTHbf2MuoEiXRrFJE9i9vx6
         o+hA==
X-Gm-Message-State: AOAM533iHjWFa+G9PYchi2jYfzA7GrV2i41E5k5amAO/vfMJvhhQnefa
        DpJIMtEmRT49tuKnuqaHTQHU+0pFqLTwjoOE
X-Google-Smtp-Source: ABdhPJz9YolU7oXa7ksSvOs2ih6CvU6EZpBcqIvpP/9rlj4QCnvaKXqLuaVpmXUOL3mDmbnyC8EjPg==
X-Received: by 2002:a05:6a02:18b:b0:399:365e:f09c with SMTP id bj11-20020a056a02018b00b00399365ef09cmr4248923pgb.238.1651351826845;
        Sat, 30 Apr 2022 13:50:26 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0015e8d4eb1c4sm1854066pld.14.2022.04.30.13.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 13:50:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/12] io_uring: kill io_recv_buffer_select() wrapper
Date:   Sat, 30 Apr 2022 14:50:11 -0600
Message-Id: <20220430205022.324902-2-axboe@kernel.dk>
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

