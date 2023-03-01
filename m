Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70DC6A709C
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 17:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjCAQN7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 11:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCAQN6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 11:13:58 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D642BF33
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 08:13:57 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id g3so4929083wri.6
        for <io-uring@vger.kernel.org>; Wed, 01 Mar 2023 08:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AnHkTJ61Q7Bqw6KixEH1vawdQtVxM2jdLrGN4p7QCGA=;
        b=GpAorfIqZzCT+xvSpaWcIbeE2H9U3yQ+QfAzUZycttlLNvcZe2giA1mZASOcyQ5tOg
         ZhJHmcLbgfbLigDX1KZ6ke+DSsKClXGAvMTKQAZ/2N3aFpPne/4QYc1wPUM2CYg9HjuB
         9VkorClv4Eq98qx1NB0kwViwpP/6A77STy4HUebezAkfjD+ZJrGFcvnBgyAmSBSwjYIQ
         rhKAz/yYEId/0mOkFODLnLGtIpt0enT7/ijQlyyG7P4XrHG1/TjBZphTw6xEadrJpp/D
         rzhMHhNuKX4AHPejNoscxABQGtBa/jLUXqqkCzVuWEOXaG2awmDge2ySmisAAJSmLLQo
         u6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AnHkTJ61Q7Bqw6KixEH1vawdQtVxM2jdLrGN4p7QCGA=;
        b=fbVqkiPy1G6uC9roC8+4+RdEXQ2lQduFW5vmFUhDk03Umj2Z/GE8idF5If2CfLbCmB
         a0G+Yi23tfE5czDFl1boz4KC7ekzhAsnsPlvj6eewqyaTdwmC9+sQqvI9YZ1hcWZcXOH
         Mu+XyTeIsg6IgL58ze9kSjoW6SspGTIbD8h1DRhWGt0/g4z6w4HL2/EV3iRj7Bc5sqqL
         J90YuMIxEy9Bk3bMd53GaksKqh0c3pUe7Y0I+cgT+W6YdrriksuRh6yyvc2MPFcQF7um
         TtCPB7z1BSazJXGXWswiwxPA5SM8i0ImUAlve6fFDALytOYAJo/G/vEoA0t+PyWXW6oz
         TyKg==
X-Gm-Message-State: AO0yUKWgu71N+sRSfIO1m6zr25r8lnoxjMWfos389fbMi5UZM0qtDlW1
        y7rIDoJronUoVHFB06PivOjTBGDk/Sc=
X-Google-Smtp-Source: AK7set9wRg65i9Xnm/IRsWnQL/XC9pgJEm8ZPIRJcT+a1v+65h17fyhC6m1qZcXT5KUNQpdBPUJPaw==
X-Received: by 2002:adf:f611:0:b0:2cc:498d:b902 with SMTP id t17-20020adff611000000b002cc498db902mr4965495wrp.59.1677687235378;
        Wed, 01 Mar 2023 08:13:55 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:94bb])
        by smtp.gmail.com with ESMTPSA id s2-20020adfeb02000000b002cda9aa1dc1sm2701474wrn.111.2023.03.01.08.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 08:13:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/3] examples/send-zc: add affinity / CPU pinning
Date:   Wed,  1 Mar 2023 16:10:10 +0000
Message-Id: <28b0e6d9c7d0c6adecb17fb72f6dfefb9bb51b47.1677686850.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677686850.git.asml.silence@gmail.com>
References: <cover.1677686850.git.asml.silence@gmail.com>
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

Pass '-C <cpu_num>' to pin threads and io-wq to the specified CPU.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index c9b5506..a86106f 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -12,6 +12,7 @@
 #include <stdarg.h>
 #include <string.h>
 
+#include <sched.h>
 #include <arpa/inet.h>
 #include <linux/errqueue.h>
 #include <linux/if_packet.h>
@@ -50,6 +51,7 @@ static int  cfg_nr_reqs = 8;
 static bool cfg_fixed_buf = 1;
 static bool cfg_hugetlb = 0;
 static bool cfg_defer_taskrun = 0;
+static int  cfg_cpu = -1;
 
 static int  cfg_family		= PF_UNSPEC;
 static int  cfg_payload_len;
@@ -79,6 +81,32 @@ static void t_error(int status, int errnum, const char *format, ...)
 	exit(status);
 }
 
+static void set_cpu_affinity(void)
+{
+	cpu_set_t mask;
+
+	if (cfg_cpu == -1)
+		return;
+
+	CPU_ZERO(&mask);
+	CPU_SET(cfg_cpu, &mask);
+	if (sched_setaffinity(0, sizeof(mask), &mask))
+		t_error(1, errno, "unable to pin cpu\n");
+}
+
+static void set_iowq_affinity(struct io_uring *ring)
+{
+	cpu_set_t mask;
+	int ret;
+
+	if (cfg_cpu == -1)
+		return;
+
+	ret = io_uring_register_iowq_aff(ring, 1, &mask);
+	if (ret)
+		t_error(1, ret, "unabled to set io-wq affinity\n");
+}
+
 static unsigned long gettimeofday_ms(void)
 {
 	struct timeval tv;
@@ -172,6 +200,9 @@ static void do_tx(int domain, int type, int protocol)
 	if (ret)
 		t_error(1, ret, "io_uring: queue init");
 
+	set_cpu_affinity();
+	set_iowq_affinity(&ring);
+
 	if (cfg_fixed_files) {
 		ret = io_uring_register_files(&ring, &fd, 1);
 		if (ret < 0)
@@ -303,7 +334,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:d")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -344,6 +375,9 @@ static void parse_opts(int argc, char **argv)
 		case 'd':
 			cfg_defer_taskrun = 1;
 			break;
+		case 'C':
+			cfg_cpu = strtol(optarg, NULL, 0);
+			break;
 		}
 	}
 
@@ -363,6 +397,7 @@ int main(int argc, char **argv)
 	const char *cfg_test;
 
 	parse_opts(argc, argv);
+	set_cpu_affinity();
 
 	payload = payload_buf;
 	if (cfg_hugetlb) {
-- 
2.39.1

