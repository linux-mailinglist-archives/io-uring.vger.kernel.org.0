Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A66E5BFCEC
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiIULYi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiIULYh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:24:37 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DA855B1
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:24:35 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bq9so9364101wrb.4
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=d87InZRix5/dcCxIK4j++OlFEw67hTdpxdg2YxzrBds=;
        b=lKFw42IxDvTDmxaaCBQWMtXTgnT0XVnn/H6j1zFtcamuKgRzDsuajHBVTCHN0+STc7
         faJaw/vU6eqQPJa2wlIACcQ2LjlSxIAUBO3e4KNjnvQUEv94GTgDJqEcafimeWlN+Hbi
         hvke14blmlEWyj3Z4KpiZcxYckbNW5lAAeaYCvL9P0o10bs/RZC1ZH/Bo6YKbgOfvLvw
         1wv1kGfNsG0lKfbE3dNFz+SC5Dewpkvuu8xw/18ohCoDXPH40DEnzr7HPipo/a7/AWHD
         OQ4+vFN2+C3fNPhnzTuvw/kmH3yUfbM2mwGbKJZJTcqIv3407XXxH+gLMnYHpryQwycP
         DXiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=d87InZRix5/dcCxIK4j++OlFEw67hTdpxdg2YxzrBds=;
        b=oVryuGOUUXnVWI9cd6ZK3X9Ite0aZ/zjwune7K9EhZL3klCX0cejZq0sWv5osiAwFJ
         oIpufBGWJYEh6b3Fs3hqkqF5l+739E2e/T46xjn6LVCoLHDZa98TUFyBTosxlvAABwsK
         paFwnXehF44yw9cy+claD4LFush5BD5WmIQUN3eDb40WbVIU0SdMT6UCvGReYJp1nR2I
         R3PvuXfGdEINtvhgdJZM8mssI4BcJpWgdXRSkRxuLRBO6UWr+6XsVtC09QaSvNZ544Wr
         jt93nebNkR+XY3qewOIJxTULx1xVmFhteEH4HSOAxBp8qQuMvX16R2l6iNFj3NohIRi/
         lgYg==
X-Gm-Message-State: ACrzQf3lHgPo0VVPqGp4AWo8d4uaZS2y6OQE8BgOWHNdXf9qZfJMr0Bq
        T2AvS3rsov558+2Ki/LHTajROy+8hfU=
X-Google-Smtp-Source: AMsMyM5QtHmB68vVVBqy0U4NT68RnJn3eJgJpysnQgf3r/gLF7HT/Tl7VlnRdHedEgDI2ryzSdztkg==
X-Received: by 2002:a05:6000:696:b0:22a:f497:3c45 with SMTP id bo22-20020a056000069600b0022af4973c45mr12226298wrb.24.1663759473705;
        Wed, 21 Sep 2022 04:24:33 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id bw25-20020a0560001f9900b0022ac1be009esm2467539wrb.16.2022.09.21.04.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:24:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/4] test: fix zc tests
Date:   Wed, 21 Sep 2022 12:21:56 +0100
Message-Id: <1529ac2cc55de274f3cf96aa150f56b5d550a19c.1663759148.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663759148.git.asml.silence@gmail.com>
References: <cover.1663759148.git.asml.silence@gmail.com>
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

Decouple result from F_NOTIF/F_MORE, even failed requests may produce a
notification.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 39c5c5d..e34e0c1 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -117,7 +117,7 @@ static int test_send_faults(struct io_uring *ring, int sock_tx, int sock_rx)
 	int msg_flags = 0;
 	unsigned zc_flags = 0;
 	int payload_size = 100;
-	int ret, i;
+	int ret, i, nr_cqes = 2;
 
 	sqe = io_uring_get_sqe(ring);
 	io_uring_prep_send_zc(sqe, sock_tx, (void *)1UL, payload_size,
@@ -125,7 +125,7 @@ static int test_send_faults(struct io_uring *ring, int sock_tx, int sock_rx)
 	sqe->user_data = 1;
 
 	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_send_zc(sqe, sock_tx, (void *)1UL, payload_size,
+	io_uring_prep_send_zc(sqe, sock_tx, tx_buffer, payload_size,
 			      msg_flags, zc_flags);
 	sqe->user_data = 2;
 	io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)1UL,
@@ -134,12 +134,18 @@ static int test_send_faults(struct io_uring *ring, int sock_tx, int sock_rx)
 	ret = io_uring_submit(ring);
 	assert(ret == 2);
 
-	for (i = 0; i < 2; i++) {
+	for (i = 0; i < nr_cqes; i++) {
 		ret = io_uring_wait_cqe(ring, &cqe);
 		assert(!ret);
 		assert(cqe->user_data <= 2);
-		assert(cqe->res == -EFAULT);
-		assert(!(cqe->flags & IORING_CQE_F_MORE));
+
+		if (cqe->flags & IORING_CQE_F_NOTIF) {
+			assert(ret > 0);
+		} else {
+			assert(cqe->res == -EFAULT);
+			if (cqe->flags & IORING_CQE_F_MORE)
+				nr_cqes++;
+		}
 		io_uring_cqe_seen(ring, cqe);
 	}
 	assert(check_cq_empty(ring));
-- 
2.37.2

