Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E205167E3
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354797AbiEAVAZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238355AbiEAVAY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E4B1839E
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:56:57 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o69so9873693pjo.3
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i7TIG4NztsbSAuiosqi2uXAolv1e4wOynyZFPMuUeV8=;
        b=cXUMRPe6dV1nlXTOEqQltrlT0VExd6UBFcOU0FFBtuaJ6c/sHjV+sMQu0T3Z89P8RT
         oM+jKfXtqOmKV4aCT8erZ5UIx2Kc6BPvherQsJ1QEwXe+Tw1MWfKHm9TsplihwwJtBKg
         tgHJbMT6UGhheh7mBv8Cs0+xXzzz1K+Dicd1V8+dhucwqCBLgZZjZmOPEZUBvWejHkR6
         +1ROkn/4G/RI6f5Sesrj97Xl1yExNhrjwW4F81rfSOb/4Ad4l5NUE/uRV1eplfk56t1c
         8GQwHHCKq1i5Jr1TiDnOsYrGKUCBxGDEFRbugsYFWxDsSR7Mz1876ZHSKnC0or3KuTtz
         0peg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i7TIG4NztsbSAuiosqi2uXAolv1e4wOynyZFPMuUeV8=;
        b=uoTzJW55Q8e4T1+aT0T0p/852sZPKuevpERYZ4/0nIPcS6N2EA4B9+CbTW40JUGpaI
         vD1Pza3ak1ojSq/hxLeA9zrZ6k8ToodBAh9hPt9Bq5etN9RLhkQh/DJkPZGHsyWxFdLh
         haLrbS7/cOU2WUHF94tmyfULELAU36+jCD0oG1/mnniYmXAyO4YjXi1GW14fPAKsu2o2
         YVj7+5d2uZizJdmBFnGpwC+jSOwlSOGjHYwJz/Yqrzj/xP8BLiO/CKp1e5OuRAXP7FvG
         6iny/ic/7eFzXdkOyzcZUlyf1Zx0Gntz73b8oUzGm65RobCqS8NEMaWscLkDFrW1u7XO
         9SEg==
X-Gm-Message-State: AOAM532cxc6fOLmQsY/Z0GwTuAttB7QGVbxE3o0UgMBP/L/0hL2h/Myy
        eI4hjiu66EaPk5d24J3ejDwECUIKfWbcEA==
X-Google-Smtp-Source: ABdhPJxdQlEeuYw97T/dhWWqeqworKQof+TWNDV7lclUPMSeAjOymcQCJ6QioCFCPQPM1Z1RPcanPQ==
X-Received: by 2002:a17:902:f605:b0:14d:9e11:c864 with SMTP id n5-20020a170902f60500b0014d9e11c864mr8702694plg.54.1651438617224;
        Sun, 01 May 2022 13:56:57 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:56:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/16] io_uring: kill io_recv_buffer_select() wrapper
Date:   Sun,  1 May 2022 14:56:38 -0600
Message-Id: <20220501205653.15775-2-axboe@kernel.dk>
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

