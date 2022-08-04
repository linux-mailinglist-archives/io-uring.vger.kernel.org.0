Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40728589D52
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 16:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiHDOQf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 10:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiHDOQe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 10:16:34 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919892B188
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 07:16:33 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id k26so21445373ejx.5
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 07:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=3ygSCOFYMKn9cqIdrpeF3sGdIfgYnr4qJg3YOXtFLwc=;
        b=jav67WjElWXPNNjcwF0EC6Ysb0opzO1UUIPAMItp0jD3xylFP+cqwzqm3fbQxtlNlC
         bxIkiaM9w2aOrWFmeFgi5A5YwS04seBBTzV0Jymfjq5hRJdFNyX4SZkiiQuhxR7buFSU
         enDP3/AwXymwaR7DAXZ4UHmtT5IjGNXBc1WZ4OGrwAzFpSRd/lpN/CEfAaMq2pu09cO7
         ubjGUxqBy+v8Ys/LxpgyfM2n/kuWPR2PorcFLbTHeCZpKRLc4baOChYCzu0gCZ8cwJDf
         odOVX1DwMlhkouFYICXUfovgSMC0EkVIcMRsuuId+t6hOi2au1MWrN+Yhyv/gFKAF4hW
         TxSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=3ygSCOFYMKn9cqIdrpeF3sGdIfgYnr4qJg3YOXtFLwc=;
        b=J48jWcCoApG+IGGQsqSHk7lSsTvqmWq2bEPgidtSGXNXKqWc/crMg2X+y5x0N4A5cq
         1myCcNo3zc8xKIABnmW83JujBuYcNXxb+KGmjthNcu0pFsevUrup4mk79r8JnPM3TUAb
         dCTjbPBuQHr00X6uh4blpnI92tMQbeMs9UBkDiLYqy6hlcrhfR/cQMHgIDIMJKf7b9Hp
         /VO/h3JPqQWQqn2Xn7PLRTszI9aX9r9SPJ3872QfVUCNY6rnKgTwC3laJZVYiY0UqygJ
         VrOsCr7AJmWDuxXHuHQ713eX+UFuE0BLQnO8qPKZtScFFsQjd6+/9sc2++y2gcDxs3lw
         KG7A==
X-Gm-Message-State: ACgBeo3/s4qWCAxTtBq6nAW8CvVEwsBLSLJ2yUwspnNzdYs3opaVp8s2
        fr0k1ZeelHcJOnqGiEvKBrGRoN3Uat0=
X-Google-Smtp-Source: AA6agR7qO7Q4Ni1VE6RawNzRprbny34c4INfvnfiLk31LeaZc6TSjpRR9asml27LP9ILwVJAuUXETA==
X-Received: by 2002:a17:907:2cd1:b0:730:65c9:4c18 with SMTP id hg17-20020a1709072cd100b0073065c94c18mr1601658ejc.324.1659622591705;
        Thu, 04 Aug 2022 07:16:31 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id y89-20020a50bb62000000b0043ba0cf5dbasm761869ede.2.2022.08.04.07.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:16:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/net: send retry for zerocopy
Date:   Thu,  4 Aug 2022 15:15:30 +0100
Message-Id: <b876a4838597d9bba4f3215db60d72c33c448ad0.1659622472.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

io_uring handles short sends/recvs for stream sockets when MSG_WAITALL
is set, however new zerocopy send is inconsistent in this regard, which
might be confusing. Handle short sends.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 32fc3da04e41..f9f080b3cc1e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -70,6 +70,7 @@ struct io_sendzc {
 	unsigned			flags;
 	unsigned			addr_len;
 	void __user			*addr;
+	size_t				done_io;
 };
 
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
@@ -878,6 +879,7 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	zc->addr_len = READ_ONCE(sqe->addr_len);
+	zc->done_io = 0;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -1012,11 +1014,23 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret < min_ret)) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return -EAGAIN;
-		return ret == -ERESTARTSYS ? -EINTR : ret;
+		if (ret > 0 && io_net_retry(sock, msg.msg_flags)) {
+			zc->len -= ret;
+			zc->buf += ret;
+			zc->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return -EAGAIN;
+		}
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+	} else if (zc->flags & IORING_RECVSEND_NOTIF_FLUSH) {
+		io_notif_slot_flush_submit(notif_slot, 0);
 	}
 
-	if (zc->flags & IORING_RECVSEND_NOTIF_FLUSH)
-		io_notif_slot_flush_submit(notif_slot, 0);
+	if (ret >= 0)
+		ret += zc->done_io;
+	else if (zc->done_io)
+		ret = zc->done_io;
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
-- 
2.37.0

