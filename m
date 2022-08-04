Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58FF589D65
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 16:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239754AbiHDOVg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 10:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239672AbiHDOVf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 10:21:35 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D15E33E35
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 07:21:32 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s11so14142138edd.13
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 07:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=zckFU/3r31KwkLbdteztPMNAFUqqjvC/+Xlbru31XI4=;
        b=h9AySY89mXZtQ0076t67TR+GL1UA5X5w4fddynVA+tXxShfp1mf0YGdDnluxsT79xO
         1c9HmvcVyqBUQVLpUi95t8Nb2hgCFnixMBODPSBlAU4cnKASDkbKooJWQ99+TaCk96Da
         vnTwRpcZLBcEQr6fAw/k1//xis2DLX6uc2k4WlEyCkI+JxbQJqhPqMAjMt5FhJ6pbj6p
         Or50ojrL8v/CjNIC+3vrREijKOCQK1ltSkZzesAAV0rbdZlS0sugep4tKadeRS6UDNWz
         3itrtI/vBoi99ezg9dmGkxcKdilx4VF3/LWqCRXmW5673D4ZcctCoDAUkJ4yfc7JAxvE
         jVtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=zckFU/3r31KwkLbdteztPMNAFUqqjvC/+Xlbru31XI4=;
        b=dvpyyjgw6/iHiA0RKKSkto1e3IcjSP05KBi+UiU2oX174UitB90nPv4PtHYqAj0hPb
         4V5E67vHI6d89cWLu2uCIBwDeFUv0U4GNaavWrFs6saaWamTLDyGm9kETomFYJTITWBE
         ss2nbxmEE9TCYfJLKrO7iLHzybF2+LuAsJPA/o4jEoxBNqfQsIvNw+N+6b+hbkGb2gMH
         838+br/c6gqofpQuLsvUO4R7GEi2gDpBEaCkObRG6XZnhOT4hm90LxgBzg5pYBArd1Nf
         So1hALC+wyHCnTxZWg8ClTHRMlYrl1GynFBj6Vt2x0v0kQC8ZZkYKP2dsgfSliLcW8E0
         QjGw==
X-Gm-Message-State: ACgBeo2aakWI8bCkyY9QECnNsr+s1BQnQJ0b0A0cPTvGbTYreFaI0kZw
        HOL/c0ek8NbrhLtsupK8IUWpvKSaLXM=
X-Google-Smtp-Source: AA6agR7gjAkkVkCNSkTh4BqY/IRTkcF2y+vOqM+87eT9CbVSWXMpBgV7hh5M3dTcLpfJmOTC4ovd9Q==
X-Received: by 2002:a05:6402:428a:b0:42e:8f7e:1638 with SMTP id g10-20020a056402428a00b0042e8f7e1638mr2279955edc.228.1659622890806;
        Thu, 04 Aug 2022 07:21:30 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id r10-20020aa7c14a000000b0043bc33530ddsm727945edp.32.2022.08.04.07.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:21:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/6] test/zc: allocate buffers dynamically
Date:   Thu,  4 Aug 2022 15:20:22 +0100
Message-Id: <55d91cebef205ca8bf9c004980f36eca06dae966.1659622771.git.asml.silence@gmail.com>
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

A prep patch, allocate receive and transfer buffers dynamically.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 7999f46..a572407 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -46,7 +46,6 @@
 
 #define NR_SLOTS 5
 #define ZC_TAG 10000
-#define MAX_PAYLOAD 8195
 #define BUFFER_OFFSET 41
 
 #ifndef ARRAY_SIZE
@@ -54,14 +53,8 @@
 #endif
 
 static int seqs[NR_SLOTS];
-static char tx_buffer[MAX_PAYLOAD] __attribute__((aligned(4096)));
-static char rx_buffer[MAX_PAYLOAD] __attribute__((aligned(4096)));
-static struct iovec buffers_iov[] = {
-	{ .iov_base = tx_buffer,
-	  .iov_len = sizeof(tx_buffer), },
-	{ .iov_base = tx_buffer + BUFFER_OFFSET,
-	  .iov_len = sizeof(tx_buffer) - BUFFER_OFFSET - 13, },
-};
+static char *tx_buffer, *rx_buffer;
+static struct iovec buffers_iov[2];
 
 static inline bool tag_userdata(__u64 user_data)
 {
@@ -662,7 +655,7 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	char *buf = buffers_iov[buf_idx].iov_base;
 
 	assert(send_size <= buffers_iov[buf_idx].iov_len);
-	memset(rx_buffer, 0, sizeof(rx_buffer));
+	memset(rx_buffer, 0, send_size);
 
 	for (i = 0; i < nr_reqs; i++) {
 		bool cur_fixed_buf = fixed_buf;
@@ -804,10 +797,23 @@ int main(int argc, char *argv[])
 {
 	struct io_uring ring;
 	int i, ret, sp[2];
+	size_t len = 8096;
 
 	if (argc > 1)
 		return T_EXIT_SKIP;
 
+	tx_buffer = aligned_alloc(4096, len);
+	rx_buffer = aligned_alloc(4096, len);
+	if (!tx_buffer || !rx_buffer) {
+		fprintf(stderr, "can't allocate buffers\n");
+		return T_EXIT_FAIL;
+	}
+
+	buffers_iov[0].iov_base = tx_buffer;
+	buffers_iov[0].iov_len = len;
+	buffers_iov[1].iov_base = tx_buffer + BUFFER_OFFSET;
+	buffers_iov[1].iov_len = len - BUFFER_OFFSET - 13;
+
 	ret = io_uring_queue_init(32, &ring, 0);
 	if (ret) {
 		fprintf(stderr, "queue init failed: %d\n", ret);
@@ -824,8 +830,9 @@ int main(int argc, char *argv[])
 	}
 
 	srand((unsigned)time(NULL));
-	for (i = 0; i < sizeof(tx_buffer); i++)
+	for (i = 0; i < len; i++)
 		tx_buffer[i] = i;
+	memset(rx_buffer, 0, len);
 
 	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
 		perror("Failed to create Unix-domain socket pair\n");
-- 
2.37.0

