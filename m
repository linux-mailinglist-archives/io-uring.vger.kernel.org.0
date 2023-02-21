Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A433E69D7DE
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 02:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbjBUBHI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 20:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbjBUBHI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 20:07:08 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31510212AF
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:05 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id j2-20020a05600c1c0200b003e1e754657aso2332985wms.2
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxtyHXpUeeZ5x2CT7DOcmWvZuW372J15FIqrjokY6vs=;
        b=ZaV52/bCUvSo3QL3gvBvH4t2sV3RW0gD4hlqix5bvf9Qd3QDdUhaGsPgmWQQpVOPfU
         lwz7GtxIv9fAGRUZMzdpyu/EDmsrss/29NQ8ElcgBJ7JoA2+RMWNl98L8LTjy/HXr9nX
         XPXXmsGYJBcS8iYX98VwdeVcL3S9dbkFaKzbpZw4B4r+ZK/bDcpj20G23uQnZJMxE7Y4
         1SCxNnQmc6RCpdZBcNETGtBCbmaae8+JtmRkC/wrQkSe+gx2JcZegtOmhN+K0saFD2um
         M6Wmz/OAYmqky2xset4Rx2Anpd2Z3I0W+k5p0o/9isIu3ZfYQOv8wkkN0lNFVn0lseVT
         b4nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PxtyHXpUeeZ5x2CT7DOcmWvZuW372J15FIqrjokY6vs=;
        b=NLaw8ek4BkL6J+U6g4vzl7mI5/re7pYPq0CoPjvClngEtrnp38p8YWUwBvAaQWqXkB
         fWS1E2qfci4Lcu+gMYgyWvd0wcLp8XBMM7RZLKwkJB5lAtWFeCGm1pz+fGQNDNURtrPg
         I0tBERJzAxWgL/ZC/m6Lv7g71pMjJU3F1fQbpe+4goIAR4Vwx+LIgphC4Akfg5sTk8CF
         eW4mR6+uHL0hUg1fr86YGqUqZV3nU4tL+gm+OeDAU1p+TMyrKh69UODwHvOO4AHVcEN/
         fhX+5XIX6BML7KENBiHug/WZn9qEeV6AJ0KPgQB1OA9Imwgm42bCxJSKAqL3TS6erJaN
         M2Fg==
X-Gm-Message-State: AO0yUKXxtiHNAMlSWUHFILxgSF4cPgErYp65j4MwMRpWROLquaNSdDUQ
        eFWsZY0nscWxQTINnB1+Q64tqx/x84M=
X-Google-Smtp-Source: AK7set8MQguAD0f/c2sFUdzTKYTPBALvXxgXZyp0jG5yCcR/U9oscp7HPLaLKZHcKRwdgCAkcStJ+g==
X-Received: by 2002:a05:600c:2e84:b0:3e0:fda8:7e26 with SMTP id p4-20020a05600c2e8400b003e0fda87e26mr1630777wmn.33.1676941623422;
        Mon, 20 Feb 2023 17:07:03 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id k17-20020a7bc411000000b003dfee43863fsm2092469wmi.26.2023.02.20.17.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 17:07:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 4/7] examples/zc: add a hugetlb option
Date:   Tue, 21 Feb 2023 01:05:55 +0000
Message-Id: <5173d9761815d23800c1b32e95e9f6ebfe10433b.1676941370.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676941370.git.asml.silence@gmail.com>
References: <cover.1676941370.git.asml.silence@gmail.com>
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

Benchmark hugetlb sends

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index 6092af9..3a80d3d 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -35,6 +35,8 @@
 #include <sys/time.h>
 #include <sys/types.h>
 #include <sys/wait.h>
+#include <sys/mman.h>
+#include <linux/mman.h>
 
 #include "liburing.h"
 
@@ -46,6 +48,7 @@ static bool cfg_fixed_files = 1;
 static bool cfg_zc = 1;
 static int  cfg_nr_reqs = 8;
 static bool cfg_fixed_buf = 1;
+static bool cfg_hugetlb = 0;
 
 static int  cfg_family		= PF_UNSPEC;
 static int  cfg_payload_len;
@@ -55,7 +58,8 @@ static int  cfg_runtime_ms	= 4200;
 static socklen_t cfg_alen;
 static struct sockaddr_storage cfg_dst_addr;
 
-static char payload[IP_MAXPACKET] __attribute__((aligned(4096)));
+static char payload_buf[IP_MAXPACKET] __attribute__((aligned(4096)));
+static char *payload;
 
 /*
  * Implementation of error(3), prints an error message and exits.
@@ -277,7 +281,7 @@ static void usage(const char *filepath)
 
 static void parse_opts(int argc, char **argv)
 {
-	const int max_payload_len = sizeof(payload) -
+	const int max_payload_len = IP_MAXPACKET -
 				    sizeof(struct ipv6hdr) -
 				    sizeof(struct tcphdr) -
 				    40 /* max tcp options */;
@@ -289,7 +293,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:k")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -324,6 +328,9 @@ static void parse_opts(int argc, char **argv)
 		case 'b':
 			cfg_fixed_buf = strtoul(optarg, NULL, 0);
 			break;
+		case 'l':
+			cfg_hugetlb = strtoul(optarg, NULL, 0);
+			break;
 		}
 	}
 
@@ -344,6 +351,17 @@ int main(int argc, char **argv)
 
 	parse_opts(argc, argv);
 
+	payload = payload_buf;
+	if (cfg_hugetlb) {
+		payload = mmap(NULL, 2*1024*1024, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_HUGETLB | MAP_HUGE_2MB | MAP_ANONYMOUS,
+				-1, 0);
+		if (payload == MAP_FAILED) {
+			fprintf(stderr, "hugetlb alloc failed\n");
+			return 1;
+		}
+	}
+
 	cfg_test = argv[argc - 1];
 	if (!strcmp(cfg_test, "tcp"))
 		do_test(cfg_family, SOCK_STREAM, 0);
-- 
2.39.1

