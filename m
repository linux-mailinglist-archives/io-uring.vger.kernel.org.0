Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2400E4E5B6A
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 23:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345317AbiCWWnN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 18:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345311AbiCWWnM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 18:43:12 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3169024C
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 15:41:42 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso3286647pjb.5
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 15:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dJkGec8J6ZKub4X4VYEOP/eRPrNuJ15phOkKzmbFez4=;
        b=Sm3Wp/iBNPpaxj9WteQF7jsVvp6blyo/CQEoCQPKX0JuRAct0ETSeUmp3RsGiuD6qa
         sqy97l2gOnMhZjd8uA6uisLdI7APu1n3WxLZS5YIvZsTFIz+rolc8o6Xku72wmfN0KyB
         hcum9JMqGqcvI+drOPx3lBwEpPH0JtCUvn/t241h8VNWkG6XmOz/CNGw6Ox5oTj86In7
         zvjYH1SpX7ggx1Hx6GzusLnYQHrqCjEJjAdTnbewntIbc4CXRRvHj2nYK25PY3yvFaEG
         7oSkb3tHPmz363QXUKoPjE59xMcuuiU1MlYZS/3EZr2qPvKdSDYh5SKbZoGnmonssvxw
         iEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dJkGec8J6ZKub4X4VYEOP/eRPrNuJ15phOkKzmbFez4=;
        b=UBdijRfHsm/+TYrg3EoiT/BnqTPMGxFtO/jpp9cbTt1jssEn80KQHTjEFVO1Et7f3Q
         sWdpEpvB2cFa7NrTfbq5ZMleM7ZdV3f6Y46BHb7ARP2kZrG5QoND8zz5fW4kCNDHZjEN
         ZhJHshYyDr9s1YN1b1O6z/CPXxEw+Dq7V5zPihhtQM60tssVcJI9t42ePkg3/iizT52q
         8yTzVMSxZv3IctOjS3Th5VGc8s3MksFFRf/ECGVgFXs63XAfXp32iLBBVR4Xc45lqjvf
         oSGqFp+0Ja3GuKco0O5d2vlozm3gsztJQ586yossJ2mwA0wJlHmuMFq8KATfW9MbGBS4
         MYXw==
X-Gm-Message-State: AOAM533OY/GjyJ315TC7XqWJMh2Nj8OOcTtLe1lnXxJvoo6qZp9BshnI
        YoJphtwobWeRVZZwKiu8DDNjy77fbJOc99vy
X-Google-Smtp-Source: ABdhPJwkPShEmSgka5aGwiN29Kk3Ii7HF7JGgTo6VnBpQ0buQRW8S1C2nAOZ0hHgiJkeWZCgKhioGQ==
X-Received: by 2002:a17:90b:4d0f:b0:1c7:82e9:1024 with SMTP id mw15-20020a17090b4d0f00b001c782e91024mr2352658pjb.42.1648075301536;
        Wed, 23 Mar 2022 15:41:41 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g5-20020a056a001a0500b004def10341e5sm867839pfv.22.2022.03.23.15.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 15:41:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     constantine.gavrilov@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: add flag for disabling provided buffer recycling
Date:   Wed, 23 Mar 2022 16:41:31 -0600
Message-Id: <20220323224131.370674-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323224131.370674-1-axboe@kernel.dk>
References: <20220323224131.370674-1-axboe@kernel.dk>
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

If we need to continue doing this IO, then we don't want a potentially
selected buffer recycled. Add a flag for that.

Set this for recv/recvmsg if they do partial IO.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a70de170aea1..88556e654c5a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -783,6 +783,7 @@ enum {
 	REQ_F_SKIP_LINK_CQES_BIT,
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
+	REQ_F_PARTIAL_IO_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -845,6 +846,8 @@ enum {
 	REQ_F_SINGLE_POLL	= BIT(REQ_F_SINGLE_POLL_BIT),
 	/* double poll may active */
 	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
+	/* request has already done partial IO */
+	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
 };
 
 struct async_poll {
@@ -1392,6 +1395,9 @@ static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 
 	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
 		return;
+	/* don't recycle if we already did IO to this buffer */
+	if (req->flags & REQ_F_PARTIAL_IO)
+		return;
 
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		mutex_lock(&ctx->uring_lock);
@@ -5477,6 +5483,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg);
 		}
 		req_set_fail(req);
@@ -5546,6 +5553,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
 			return -EAGAIN;
 		}
 		req_set_fail(req);
-- 
2.35.1

