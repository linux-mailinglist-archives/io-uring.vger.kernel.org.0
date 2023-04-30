Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB1C6F2858
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 11:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjD3Jhm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 05:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjD3Jhk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 05:37:40 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316D5199F
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:39 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-2f95231618aso798243f8f.1
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682847457; x=1685439457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MzBA59yYyYkKW9Q9sRIrnqWt/01emGF0gXOuXVIPvFA=;
        b=BF2RK0RPKWkVkaz5oc5sTryOFI2S4kaI7WpQ+ic/WSiEyzxfI030A/Li1ZrD0mlsLh
         25vuq1YhABsS6ahEBScW83LelfRxhSVpqQn4DR62gu8ZN/f63donFw/aweDrBj1bkJ8q
         sCrXyBtcohUBvzbRr94d7AOIEQUqXxjuIw1Hz49BctU8XSajMYPfhzOBJU3hMuIPMfAl
         CV11/01QiR/7sl/SNGXTF95JJ4OOl4UexhdUaWhzUOSkbUQCDHsQGI2ZH5cXtjAHAcrI
         tNouw2S+5gxvC8Sq6JjOextEt9vpqJ1zeEID0LZX06DnV7TY8UZiae+Gdw7b3DUAmCiC
         k0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682847457; x=1685439457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzBA59yYyYkKW9Q9sRIrnqWt/01emGF0gXOuXVIPvFA=;
        b=FuvZT/SBH6SHSfpLggGjyHb4/KFNCztU58W7E43Krq1lIaTzyVkORfHFDi2sIQRY3+
         6D4gbF2hefdWZaxHfA9WtmMShHpdrZTsxq8xnvkNyNZsOoTCCOWPNugLHNgiEVhnAf9S
         JYZyOtAlbS8L/YZJpUWdiOGhCwzLdBenWjiUg1kWcnd6tjG6bXFFENLdm/2R7zCWlr6X
         r1nRIKC+7zh58A8ryl70FoaUz1r2cUuckumHbKZx4Ndqp3lEpaa1kWUBYadOQ7koJ5DE
         kDC0I+4UoQSbFGqIRDIuWUNrt5oE8ebJoCGEH/A5nuo+Sx015vaIgPx00r+pHNONG7Gm
         8DTw==
X-Gm-Message-State: AC+VfDzQ5MfvTt3KReRSaOWrq+tIhjVVQZ695n6+MUpr9oLVNKjsp+Ap
        ZUpHSpZBeFLHQj2MqEsPN3VDAAySE00=
X-Google-Smtp-Source: ACHHUZ5Z3yR1+FAsPqItLSw5LVAMWb397YdFg7m32ihLCi0zadX+bzCKFCN4HYqPFBUmVzGS3TnTwA==
X-Received: by 2002:adf:ef52:0:b0:306:b48:3fc4 with SMTP id c18-20020adfef52000000b003060b483fc4mr2903484wrp.31.1682847457345;
        Sun, 30 Apr 2023 02:37:37 -0700 (PDT)
Received: from 127.0.0.1localhost (188.31.116.198.threembb.co.uk. [188.31.116.198])
        by smtp.gmail.com with ESMTPSA id u19-20020a05600c00d300b003f17eaae2c9sm29473170wmm.1.2023.04.30.02.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 02:37:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, ming.lei@redhat.com
Subject: [RFC 3/7] io_uring: fail loop_rw_iter with pure bvec bufs
Date:   Sun, 30 Apr 2023 10:35:25 +0100
Message-Id: <ea3b1ee3dbfc69727342813e8470d0a22820ae14.1682701588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682701588.git.asml.silence@gmail.com>
References: <cover.1682701588.git.asml.silence@gmail.com>
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

There will be registered buffers that have never had a userspace mapping
and to use them the file have to work with iterators. Fail
loop_rw_iter() if it meets such a buffer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 6c7d2654770e..b2ad99e0e304 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -428,11 +428,18 @@ static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
  */
 static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
 {
+	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 	struct kiocb *kiocb = &rw->kiocb;
 	struct file *file = kiocb->ki_filp;
 	ssize_t ret = 0;
 	loff_t *ppos;
 
+	if (req->opcode == IORING_OP_READ_FIXED ||
+	    req->opcode == IORING_OP_WRITE_FIXED) {
+		if (!req->imu->ubuf)
+			return -EFAULT;
+	}
+
 	/*
 	 * Don't support polled IO through this interface, and we can't
 	 * support non-blocking either. For the latter, this just causes
-- 
2.40.0

