Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5888550DDA
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 02:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbiFTA0l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 20:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237232AbiFTA0k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 20:26:40 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8551AAE41
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:39 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i10so8720910wrc.0
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4FSyTbDneLGtKugI2soK8tzPgcBp91PZCjoYIRrzazk=;
        b=MXiiBWS4uKk2H6d7W8ljaf5ypZWzgVIzjqueK9bIfCSUH+Iz/WPIPQtMm8YRJCIEJh
         IkBIAguhN+LPXVCgxIA9jHd8eZ2df9X04Ty5D/NGdJBhteCzkgAHnwyZ6kG62CV+VrqY
         he9LwHHcmlh8BV08h4Llb8JyqZyCp00zBzbAp+T6Y/SEA1x18PTJ7u2BCZsY07txsLxZ
         maN2YeItyy54DTFm7ib7XL8VYaAvUkuwPbAzVlWSq67xK/jesaf13LL9VirPbC5XzQu9
         GNxqHvLLP/YdT1Hvaa71avjiljJrhtTw24lgpZoKzY7etS4hYbc9DOCkXKGY3SYC65QF
         r+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4FSyTbDneLGtKugI2soK8tzPgcBp91PZCjoYIRrzazk=;
        b=BOTpZQAWhoxAYSDTJlKYNK/lZU1cEIvyo4E1OEpCzy7FRMdL1FwZqDjUwUnleCKeKM
         li5vkYW0eV+P1zD36mkHaEJ998+eLYixgzg9h9c7GekDbIn+SfP50gjRP7MzwZ2u7EBW
         qub+YDqdFy6kH3q/Kd9U6nzdsPlK9TagLdTre9NQpLLGP/20/a/sO3vgCaNGwVV29V5H
         lUqhv7iCUFcd8X6qhOXT30BNlmUxCQOASUypDuXayLZ9zvtKp9QVy7dg9dzpSIU4GnQQ
         8hrIqreUKD8VoUXWzdCIMhTw8uo3KMuC5sSKEHUFrkCCaowN3JYwUoqOvDn29Dm3lJbK
         fhFw==
X-Gm-Message-State: AJIora+li1/+s4Vbt+LQCWVUMJJFgv+qY9J16guETRhEhPzBFnZw/1/l
        jxZzwyOiFe/8h51T0aiT2tTf7QJB87Gq2A==
X-Google-Smtp-Source: AGRyM1u4aciiEIp+lUnUpUTHhh2OyZufDPbR0jnh0eRQNqEC7BNNSdPmwB3DSUmeJVdhTpbNdYQHiw==
X-Received: by 2002:a05:6000:1e1b:b0:219:e32d:cbe8 with SMTP id bj27-20020a0560001e1b00b00219e32dcbe8mr20549779wrb.129.1655684797851;
        Sun, 19 Jun 2022 17:26:37 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002167efdd549sm11543807wrq.38.2022.06.19.17.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 17:26:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 07/10] io_uring: opcode independent fixed buf import
Date:   Mon, 20 Jun 2022 01:25:58 +0100
Message-Id: <b1e765c8a1c2c913a05a28d2399fc53e1d3cf37a.1655684496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655684496.git.asml.silence@gmail.com>
References: <cover.1655684496.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fixed buffers are generic infrastructure, make io_import_fixed() opcode
agnostic.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 5660b1c95641..4e5d96040cdc 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -273,14 +273,15 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
 
-static int __io_import_fixed(struct io_kiocb *req, int ddir,
-			     struct iov_iter *iter, struct io_mapped_ubuf *imu)
+static int io_import_fixed(int ddir, struct iov_iter *iter,
+			   struct io_mapped_ubuf *imu,
+			   u64 buf_addr, size_t len)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req);
-	size_t len = rw->len;
-	u64 buf_end, buf_addr = rw->addr;
+	u64 buf_end;
 	size_t offset;
 
+	if (WARN_ON_ONCE(!imu))
+		return -EFAULT;
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
 		return -EFAULT;
 	/* not inside the mapped region */
@@ -332,14 +333,6 @@ static int __io_import_fixed(struct io_kiocb *req, int ddir,
 	return 0;
 }
 
-static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
-			   unsigned int issue_flags)
-{
-	if (WARN_ON_ONCE(!req->imu))
-		return -EFAULT;
-	return __io_import_fixed(req, rw, iter, req->imu);
-}
-
 #ifdef CONFIG_COMPAT
 static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 				unsigned int issue_flags)
@@ -426,7 +419,7 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
 	ssize_t ret;
 
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
-		ret = io_import_fixed(req, ddir, iter, issue_flags);
+		ret = io_import_fixed(ddir, iter, req->imu, rw->addr, rw->len);
 		if (ret)
 			return ERR_PTR(ret);
 		return NULL;
-- 
2.36.1

