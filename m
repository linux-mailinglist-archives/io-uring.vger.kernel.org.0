Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59936AAE42
	for <lists+io-uring@lfdr.de>; Sun,  5 Mar 2023 06:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjCEFOS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Mar 2023 00:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCEFOQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Mar 2023 00:14:16 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAB9BDED
        for <io-uring@vger.kernel.org>; Sat,  4 Mar 2023 21:14:15 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id c18so3794183wmr.3
        for <io-uring@vger.kernel.org>; Sat, 04 Mar 2023 21:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kiOuJmYf9ubKbzwOtDLrrlNEJv7ZGt7esi0qo9k/DX8=;
        b=f3QUJpJIM0tCpb8IsncRKW3OEr+ZYFPGh1W9qKsNTVbEicRv/nSxI2roAw9N3VUxwX
         tdq2w09ne/wPtp5I8HD1IGKWsTpjfOVkut1pOGi9SSW99rTW/HPWZoMwzlIoVlinYsDy
         +LMYoMbxFQ+XwxTZ6zGnPRr81o6fDNNKz+5H/TzEyQJU1ZXzXN2LFCl53lXOnBEZz4wS
         6V79B05Ri20z9FrOSd4VGKWxZ9ndovSJiizhN26ttyb7XdzdPBODMl87OdNHQl7x6hXt
         bWNdYJKmqAI8YriclwYXueMLBZDcMzY/EGYE+niR4CgkoLcIBcPTyd46DbBUX5hbZyy0
         aBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kiOuJmYf9ubKbzwOtDLrrlNEJv7ZGt7esi0qo9k/DX8=;
        b=UlRZ4yBGncIvHO2W7FpZnSy5XcStFbh26oxVWHOIR5vcrcFOkQy1lSJY0bWc/PxOKg
         Pl+DuR5OnmRjq4ADoB9Jz6nEEUCUv6+EPc6K8Pom3RtSkN027K21SdSQwASU7Gpa55ym
         C9myEkb4Io7yk+f6P03KT3/OOcS1SFfO5jn9q4QJeMbayBSPt+u/LD289yspH2kVqoVJ
         k56UzjAOFQwggt8MZ0GGVAFRGmxITZ0Vxx2sHX+MiIsZ4MnaB1x24JgAsSeJiPbLbYLN
         gLTOU7Llve7EKvd1lwzyYb5/FcM6n21LOqopCzFmjg0WRcwMySvmA7A48d052msP/Pcc
         BOIw==
X-Gm-Message-State: AO0yUKUKFXuwzqiHGh1GHO4CK6J+SwjnzxGBeURu4nhh9hImyBD4TkkH
        3kyPdmk9IjftRVgKxkzAaZEAkJf4z58=
X-Google-Smtp-Source: AK7set/nPhcwbGowVFisT9S7/3uDR6Pyxa9Wv1up6pXShI5dQ6oYxcewE9yHlTDBgUCAi1csui6N0Q==
X-Received: by 2002:a05:600c:1c96:b0:3eb:3300:1d13 with SMTP id k22-20020a05600c1c9600b003eb33001d13mr6002217wms.14.1677993253422;
        Sat, 04 Mar 2023 21:14:13 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.92.184.threembb.co.uk. [94.196.92.184])
        by smtp.gmail.com with ESMTPSA id j4-20020adfff84000000b002cda9aa1dc1sm6524348wrr.111.2023.03.04.21.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 21:14:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 1/5] examples/send-zc: add defer taskrun support
Date:   Sun,  5 Mar 2023 05:13:04 +0000
Message-Id: <ba9e53c44f2342a02d7d5f8070eff13bbdf2d4e0.1677993039.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677993039.git.asml.silence@gmail.com>
References: <cover.1677993039.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index 2844491..d60335c 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -48,6 +48,7 @@ static bool cfg_zc = 1;
 static int  cfg_nr_reqs = 8;
 static bool cfg_fixed_buf = 1;
 static bool cfg_hugetlb = 0;
+static bool cfg_defer_taskrun = 0;
 
 static int  cfg_family		= PF_UNSPEC;
 static int  cfg_payload_len;
@@ -151,6 +152,7 @@ static inline struct io_uring_cqe *wait_cqe_fast(struct io_uring *ring)
 
 static void do_tx(int domain, int type, int protocol)
 {
+	const int notif_slack = 128;
 	unsigned long packets = 0;
 	unsigned long bytes = 0;
 	struct io_uring ring;
@@ -158,10 +160,14 @@ static void do_tx(int domain, int type, int protocol)
 	uint64_t tstop;
 	int i, fd, ret;
 	int compl_cqes = 0;
+	int ring_flags = IORING_SETUP_COOP_TASKRUN | IORING_SETUP_SINGLE_ISSUER;
+
+	if (cfg_defer_taskrun)
+		ring_flags |= IORING_SETUP_DEFER_TASKRUN;
 
 	fd = do_setup_tx(domain, type, protocol);
 
-	ret = io_uring_queue_init(512, &ring, IORING_SETUP_COOP_TASKRUN);
+	ret = io_uring_queue_init(512, &ring, ring_flags);
 	if (ret)
 		t_error(1, ret, "io_uring: queue init");
 
@@ -211,7 +217,11 @@ static void do_tx(int domain, int type, int protocol)
 			}
 		}
 
-		ret = io_uring_submit(&ring);
+		if (cfg_defer_taskrun && compl_cqes >= notif_slack)
+			ret = io_uring_submit_and_get_events(&ring);
+		else
+			ret = io_uring_submit(&ring);
+
 		if (ret != cfg_nr_reqs)
 			t_error(1, ret, "submit");
 
@@ -292,7 +302,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:d")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -330,6 +340,9 @@ static void parse_opts(int argc, char **argv)
 		case 'l':
 			cfg_hugetlb = strtoul(optarg, NULL, 0);
 			break;
+		case 'd':
+			cfg_defer_taskrun = 1;
+			break;
 		}
 	}
 
-- 
2.39.1

