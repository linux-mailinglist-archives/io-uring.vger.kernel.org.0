Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7729C5BFCD6
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiIULUq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIULUo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:20:44 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E9670E44
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:43 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id az6so4189153wmb.4
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=uEeWCm94KOo7VZwDqBvTmmSVgBJlmWvoPwkZEcEjcrA=;
        b=LpZu15pMAJiR5RNtbYdbI9TV53fr3/sLz7AauD1Fcmnk0irl3SntbXOepAzoVHpzqc
         I65U69Q/32rx5PUAz5mgFuHRuYZFIDWThIvSBWTDmqF/y7XB/bNZKy5tbXKeUSWbSEQ+
         1Os47wgsjyTjxhk0EZFLSrNYiA/sO+OZ8VNcGLu0QCcr1k6nw5uEs34G5/Q2YWwnrBzJ
         u6sphbD0A2wJWJuTIQmcKPhiqVx8uVzEHh5q08guum8OLa9EShlXlcK+M2DFWIx3yweb
         KDZf2dH4563tmTE+gxL4felrQ2BeWbBCeoAbxiZS1Chh+m5BlFuaLgfexR3WATDCEkJw
         2Vxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=uEeWCm94KOo7VZwDqBvTmmSVgBJlmWvoPwkZEcEjcrA=;
        b=WmrOsSkgxBcwrf+r7XV3Zq7JhJ6bGqi4YbEfxCBgA6/qwVqZnQ9fQRhNlVLGcyOUrA
         XCsyPX/R3T2egJUxUmM5NqzOJHShYkAvrxDaOm0uSozDL1ud0I3AX1oCjbRDxtFlUrbj
         noWavl2tWetejci1pUIFnR+f2kWOvXlglfIaV0Q9A6eHIPkdlhVn5BCC7MonKtNEk8dn
         fjw0BM3ncCw0jG+RZ9UdAGFBq91BKSsr/Egs5xg0DU4bdb97Yy9duykTQgzYekEKkAu/
         WLLSMj+GU6bDM/cU2iVB65TcRY3l6A6Eadc9g69VNAXQnGqJk3CsLGza5SMcC6yvNjEb
         I2Mg==
X-Gm-Message-State: ACrzQf2psfTFJrZmRXodhyKynAeaNa6LUbfbSjZ8M833f32sIJO+AUWh
        NvDr0OPOOS2Z8GyOeykrCWZQORzSYUg=
X-Google-Smtp-Source: AMsMyM5ihFLim9R7SDnN2PC1YLmcBbWjbH8DvLuTOSqgr1nXudgIhpFKmU5TCPYemmmn82qrFUdZIg==
X-Received: by 2002:a7b:ce0d:0:b0:3b4:8728:3e7e with SMTP id m13-20020a7bce0d000000b003b487283e7emr5294340wmc.182.1663759241382;
        Wed, 21 Sep 2022 04:20:41 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d6a91000000b00228da845d4dsm2206732wru.94.2022.09.21.04.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:20:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/9] io_uring: add custom opcode hooks on fail
Date:   Wed, 21 Sep 2022 12:17:46 +0100
Message-Id: <b734cff4e67cb30cca976b9face321023f37549a.1663668091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663668091.git.asml.silence@gmail.com>
References: <cover.1663668091.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sometimes we have to do a little bit of a fixup on a request failuer in
io_req_complete_failed(). Add a callback in opdef for that.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ++++
 io_uring/opdef.h    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 433466455a5f..3875ea897cdf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -865,8 +865,12 @@ inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
 
 void io_req_complete_failed(struct io_kiocb *req, s32 res)
 {
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+
 	req_set_fail(req);
 	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
+	if (def->fail)
+		def->fail(req);
 	io_req_complete_post(req);
 }
 
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 763c6e54e2ee..3efe06d25473 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -36,6 +36,7 @@ struct io_op_def {
 	int (*issue)(struct io_kiocb *, unsigned int);
 	int (*prep_async)(struct io_kiocb *);
 	void (*cleanup)(struct io_kiocb *);
+	void (*fail)(struct io_kiocb *);
 };
 
 extern const struct io_op_def io_op_defs[];
-- 
2.37.2

