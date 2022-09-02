Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F375AAD46
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 13:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiIBLO5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 07:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiIBLOz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 07:14:55 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94BF13E0B
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 04:14:53 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k9so1924428wri.0
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 04:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=oBqjmTxxDXC+6e/PM5LYg4CPi97y7DsIl/wxiWy6Ads=;
        b=aKZwzG7/wkju9WW933foJklI0aRS+5xOX1hX0Gqbk3dVhdz4z+HEyAYa+u4161N4TP
         wSGLOQEecqWzrIAeIHAS3z4wgMZiKOpMeeA++EeViqAhBn8eKP9Uh7Qfmn8+/UPm5snS
         XWhDAEzEuiKAJW8PXxo3v1R5d8nYL/F2mjPZcabnmA+sei3ZNPiwFIsfO6f4y33QJCI3
         1ULouf4Nh3rpscu0kiBsoNfCf6MZi2+8DgVwEaiMktOTP6mfFLeUrV88AgrB+bKjlzIu
         PcTVWTDWvG7uScrAnZeMJVsnifh4YxJcIBlsgvGaBA0X++BccEHlTCWIcLL62h/sR/S8
         Fu7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=oBqjmTxxDXC+6e/PM5LYg4CPi97y7DsIl/wxiWy6Ads=;
        b=GSA6gAypEzLSrtO0bVj+kBswaahHKYOtdwoftObMsQwtJ7p9BUEdAUDC3zPeku7oxV
         VlXIhbLaM986DByy2pGoJRJWxSsXECwNPveUSXqrAPUG/8q2k1PSsluQHg+Smj+z3bkA
         zeZLd7kCZznu9qzzthhGVq5Y2sQkZ1Y9yQ2h2VNY76pTJ8LNehYhnJ53u8Etbr3U5bvI
         3yiXk721VaHiFicWSX8mHp2/VJjM7c4v3wtjD3mHj1BcLV0RivljzmgUbGFxqaXkN2sf
         V6sdj+UxSjJpLGQs89SUp3v6uwBkfsCt41mqpOU6U2MXzs1V1EvQSq6hE654SvzFWl4r
         xTMg==
X-Gm-Message-State: ACgBeo0zVqxfgGMUON8e1VpjeIUDtst2YpVNwlCGw+6CM0B7HoW7xRDr
        ZFVE6oILXqkCRl2JS4aZy8haRfvS65I=
X-Google-Smtp-Source: AA6agR6Uafa8zv7cuSO8W1TstWx8zNoBxPincOVa8Kj04kQnkKSZpYYxbtjPdKYbHFM0VoovgxOEaA==
X-Received: by 2002:a5d:510e:0:b0:226:e949:8baf with SMTP id s14-20020a5d510e000000b00226e9498bafmr7704634wrt.204.1662117291221;
        Fri, 02 Sep 2022 04:14:51 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-225.dab.02.net. [82.132.230.225])
        by smtp.gmail.com with ESMTPSA id bg32-20020a05600c3ca000b003a536d5aa2esm2087379wmb.11.2022.09.02.04.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 04:14:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/4] test: test iowq zc sends
Date:   Fri,  2 Sep 2022 12:12:38 +0100
Message-Id: <8562fc9c8860b0e6b92d20e4f773ce3bde7d9137.1662116617.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662116617.git.asml.silence@gmail.com>
References: <cover.1662116617.git.asml.silence@gmail.com>
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

Add tests exercising io-wq paths with zc by setting IOSQE_ASYNC.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 7b58ae7..8714b6f 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -239,7 +239,7 @@ static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock
 static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_server,
 			     bool fixed_buf, struct sockaddr_storage *addr,
 			     size_t send_size, bool cork, bool mix_register,
-			     int buf_idx)
+			     int buf_idx, bool force_async)
 {
 	const unsigned zc_flags = 0;
 	struct io_uring_sqe *sqe;
@@ -285,6 +285,8 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 			io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)addr,
 						    addr_len);
 		}
+		if (force_async)
+			sqe->flags |= IOSQE_ASYNC;
 	}
 
 	ret = io_uring_submit(ring);
@@ -389,7 +391,7 @@ static int test_inet_send(struct io_uring *ring)
 			return 1;
 		}
 
-		for (i = 0; i < 128; i++) {
+		for (i = 0; i < 256; i++) {
 			bool fixed_buf = i & 1;
 			struct sockaddr_storage *addr_arg = (i & 2) ? &addr : NULL;
 			size_t size = (i & 4) ? 137 : 4096;
@@ -398,6 +400,7 @@ static int test_inet_send(struct io_uring *ring)
 			bool aligned = i & 32;
 			bool large_buf = i & 64;
 			int buf_idx = aligned ? 0 : 1;
+			bool force_async = i & 128;
 
 			if (!tcp || !large_buf)
 				continue;
@@ -418,7 +421,7 @@ static int test_inet_send(struct io_uring *ring)
 
 			ret = do_test_inet_send(ring, sock_client, sock_server, fixed_buf,
 						addr_arg, size, cork, mix_register,
-						buf_idx);
+						buf_idx, force_async);
 			if (ret) {
 				fprintf(stderr, "send failed fixed buf %i, conn %i, addr %i, "
 					"cork %i\n",
-- 
2.37.2

