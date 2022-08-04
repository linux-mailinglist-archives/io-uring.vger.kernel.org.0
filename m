Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496F1589D66
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 16:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbiHDOVg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 10:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239487AbiHDOVf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 10:21:35 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3093AB17
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 07:21:33 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id x21so12814256edd.3
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 07:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Q8bh0yHRmnGsPs8d8XIQ89fzl0kLwyc+bl0Zuu0VtdU=;
        b=odYfBBvn5DX7Sppl6VZz4tc/A08YdObOKDpmbtnvDFO/e1VyOYXSgrCHwqx0gPgBcY
         BGultPMPIXIUvwEDR9l7UasFePUZSY2UFF9CvcXyeZdGW4Tj15BF4jIkso9DhCZ79+Cx
         c4sbtcDxmRxEndCFRfpzvQ2vf4VxX2GLiq0dwcdJnQ78/ntrdKbaxlctzJyz8cyzZzSp
         KbTYX2WUTFJNTDVZFdv29AyytUZS50EGc/uHGzKWxDUGl/16gcPabOVpmsE0G5Xu/CMH
         hTPRBF5g2F0dxI0Aiq1byGzpPyFFRCHG+laBeTN1cgwEc0TmN07f0360st1jyijJbx10
         jcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Q8bh0yHRmnGsPs8d8XIQ89fzl0kLwyc+bl0Zuu0VtdU=;
        b=tMPi8r28CMq8BW7Pgrmy9AEbdcfjGK3c5oqVPZBr9fwy7nVU0m9O3DDc5RNCJak8ca
         NeiQe5yTeECnbrNTV0NOzurYGZTbp5gjje8U180nuB8CG/DJ/LgBe19FR7vL6VHlhtas
         n+9iI5mYxgEkaP82ZO5rLvFx6OHdL/3HkKmSvL3vYO4OXyhL7G2SrACrjmQuEi8w9Ui2
         W9uh/2VOk70ST5csOwf7pBN86NRBHWhu7BbkfPeVDFD68ncN8F6GT1J+6/1G099204OT
         DvrcrwqAwD0m5vbz5kk6Y0N+P8HSudcQ1doMzEkWZaosIUYXy5LbiLj0SzKP8sR5/7WS
         uTHA==
X-Gm-Message-State: ACgBeo2GARlT4RXp3b5L4Ilz4zhYmqIkm5YmIfMW8UhKS49RveNK+vsV
        mD/sVdm8NTaCoP6oKZBmC8Gqkp7ok1k=
X-Google-Smtp-Source: AA6agR7PS7PSl23sxJb0IcFvWljmnSEQz3VSssbx2HCLvd3OGafGZGuFwwSKyXB8DHwivJoxy81MBg==
X-Received: by 2002:aa7:d597:0:b0:43d:5bcf:f251 with SMTP id r23-20020aa7d597000000b0043d5bcff251mr2272600edq.15.1659622891951;
        Thu, 04 Aug 2022 07:21:31 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id r10-20020aa7c14a000000b0043bc33530ddsm727945edp.32.2022.08.04.07.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:21:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 4/6] test/zc: handle short rx
Date:   Thu,  4 Aug 2022 15:20:23 +0100
Message-Id: <de886a33656d5407a9d8b61b56bb664edada09e6.1659622771.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1659622771.git.asml.silence@gmail.com>
References: <cover.1659622771.git.asml.silence@gmail.com>
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

After a send we receive and check buffers, make sure that we also handle
short receives.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index a572407..d0f5931 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -653,6 +653,7 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	size_t chunk_size = send_size / nr_reqs;
 	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
 	char *buf = buffers_iov[buf_idx].iov_base;
+	size_t bytes_received = 0;
 
 	assert(send_size <= buffers_iov[buf_idx].iov_len);
 	memset(rx_buffer, 0, send_size);
@@ -699,6 +700,18 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		return 1;
 	}
 
+	while (bytes_received != send_size) {
+		ret = recv(sock_server,
+			   rx_buffer + bytes_received,
+			   send_size - bytes_received, 0);
+		if (ret <= 0) {
+			fprintf(stderr, "recv failed, got %i, errno %i\n",
+				ret, errno);
+			return 1;
+		}
+		bytes_received += ret;
+	}
+
 	for (i = 0; i < nr_reqs; i++) {
 		int expected = chunk_size;
 
@@ -721,13 +734,6 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		io_uring_cqe_seen(ring, cqe);
 	}
 
-	ret = recv(sock_server, rx_buffer, send_size, 0);
-	if (ret != send_size) {
-		fprintf(stderr, "recv less than expected or recv failed, "
-			"got %i, errno %i\n", ret, errno);
-		return 1;
-	}
-
 	for (i = 0; i < send_size; i++) {
 		if (buf[i] != rx_buffer[i]) {
 			fprintf(stderr, "botched data, first mismated byte %i, "
-- 
2.37.0

