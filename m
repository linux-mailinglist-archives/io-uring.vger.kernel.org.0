Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D5D589D68
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 16:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbiHDOVi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 10:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239672AbiHDOVh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 10:21:37 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D30533E27
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 07:21:36 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e13so6605502edj.12
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 07:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=pJ6Nu6ke0tEeP4WGcPqc987CZlnioHDjGxMs6lV8f9E=;
        b=Dh4YVCEZ1/4ZsfBf39hKqqutmVilRgOMFeTSi9BAv0py0b65OX3Dcyfc5Fi46BSBa1
         yIWVTIaV8MYyHWnj6LxWUJHmPlWU5jCKfxTQIMvP5qCladOqPqgu7IE7qstBjAXYhqUv
         iBwvA9sfoSsDBia8GAzu84hKBQqg2cLi3Os9fircBao3Vf4Pz8N5KUAtyRrKMmpS796v
         /jzD90nz5qtclnAT5XBtd32AM06BFG75WMiHKcYBiVTH6URJrMrqJPyqojgpQA74Oizp
         BhyFzMFUL/qJxlIhWzaSU8k5WPd/sJvLx8IFKY13vQrm5sKbstbawkcxNqkUyv1M5+79
         S4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=pJ6Nu6ke0tEeP4WGcPqc987CZlnioHDjGxMs6lV8f9E=;
        b=Y4G/6nQAqsSBN+cGOC/RhfmLcgm7pRyGlfFTvlAnTAmvsT1HnqX26L1n9wAQBydoxS
         Gq2zJ+7NWXjSLyC0HNOzff4MViJRYfGY4CfRCTtozdBQX1NJBHoqhkmAd1DxDnruBish
         3Zpd8J9xwF7ma8tk/xJnRmCx2E07/z+NWLdr7cqM2tR1zZCRkUa4MXLKFUWl/LEjyu57
         V25DJvg3jozuGEJr1UgighyES+1KYdXhytFX9O9w5Db6gfRhIRncKKOaTFSdEgDSq1j1
         IzVb7Tn7TeWcBt8/7GDJQqeCnZlhupANBjukSCjjtUtNpaeN5BUuQkCqRagsRT26bBnx
         5YmA==
X-Gm-Message-State: ACgBeo0pbu1Ho4yAPu4/Cx3TmI9+GM7DAyvQZPoge1hAbygXDY6wJLDb
        WEF3Rys2/+jfi0Pceyt8xPeNu7pDOs4=
X-Google-Smtp-Source: AA6agR4Jf6cAWJmRxZWXJAKkGZcUmDj5pU9rcJVMpTatG/Mhkci4gjpgX6IUOKYifkYAKRHj4Lwjmw==
X-Received: by 2002:a05:6402:27c6:b0:43d:6fab:146e with SMTP id c6-20020a05640227c600b0043d6fab146emr2241308ede.376.1659622894256;
        Thu, 04 Aug 2022 07:21:34 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id r10-20020aa7c14a000000b0043bc33530ddsm727945edp.32.2022.08.04.07.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:21:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 6/6] test/zc: test short zc send
Date:   Thu,  4 Aug 2022 15:20:25 +0100
Message-Id: <6ee389d6b720356ec2a8c677a34a852c761c1627.1659622771.git.asml.silence@gmail.com>
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

Zerocopy send should hide short writes for stream sockets, test it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 617e7a0..307c114 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -54,7 +54,7 @@
 
 static int seqs[NR_SLOTS];
 static char *tx_buffer, *rx_buffer;
-static struct iovec buffers_iov[2];
+static struct iovec buffers_iov[3];
 
 static inline bool tag_userdata(__u64 user_data)
 {
@@ -662,7 +662,7 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	for (i = 0; i < nr_reqs; i++) {
 		bool cur_fixed_buf = fixed_buf;
 		size_t cur_size = chunk_size;
-		int msg_flags = 0;
+		int msg_flags = MSG_WAITALL;
 
 		if (mix_register)
 			cur_fixed_buf = rand() & 1;
@@ -791,15 +791,26 @@ static int test_inet_send(struct io_uring *ring)
 			return 1;
 		}
 
-		for (i = 0; i < 64; i++) {
+		for (i = 0; i < 128; i++) {
 			bool fixed_buf = i & 1;
 			struct sockaddr_storage *addr_arg = (i & 2) ? &addr : NULL;
 			size_t size = (i & 4) ? 137 : 4096;
 			bool cork = i & 8;
 			bool mix_register = i & 16;
 			bool aligned = i & 32;
+			bool large_buf = i & 64;
 			int buf_idx = aligned ? 0 : 1;
 
+			if (!tcp || !large_buf)
+				continue;
+			if (large_buf) {
+				buf_idx = 2;
+				size = buffers_iov[buf_idx].iov_len;
+				if (!aligned || !tcp)
+					continue;
+			}
+			if (!buffers_iov[buf_idx].iov_base)
+				continue;
 			if (tcp && cork)
 				continue;
 			if (mix_register && (!cork || fixed_buf))
@@ -829,22 +840,33 @@ int main(int argc, char *argv[])
 {
 	struct io_uring ring;
 	int i, ret, sp[2];
-	size_t len = 8096;
+	size_t len;
 
 	if (argc > 1)
 		return T_EXIT_SKIP;
 
+	len = 1U << 25; /* 32MB, should be enough to trigger a short send */
 	tx_buffer = aligned_alloc(4096, len);
 	rx_buffer = aligned_alloc(4096, len);
+	if (tx_buffer && rx_buffer) {
+		buffers_iov[2].iov_base = tx_buffer;
+		buffers_iov[2].iov_len = len;
+	} else {
+		printf("skip large buffer tests, can't alloc\n");
+
+		len = 8192;
+		tx_buffer = aligned_alloc(4096, len);
+		rx_buffer = aligned_alloc(4096, len);
+	}
 	if (!tx_buffer || !rx_buffer) {
 		fprintf(stderr, "can't allocate buffers\n");
 		return T_EXIT_FAIL;
 	}
 
 	buffers_iov[0].iov_base = tx_buffer;
-	buffers_iov[0].iov_len = len;
+	buffers_iov[0].iov_len = 8192;
 	buffers_iov[1].iov_base = tx_buffer + BUFFER_OFFSET;
-	buffers_iov[1].iov_len = len - BUFFER_OFFSET - 13;
+	buffers_iov[1].iov_len = 8192 - BUFFER_OFFSET - 13;
 
 	ret = io_uring_queue_init(32, &ring, 0);
 	if (ret) {
-- 
2.37.0

