Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A01E6AAE41
	for <lists+io-uring@lfdr.de>; Sun,  5 Mar 2023 06:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjCEFOS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Mar 2023 00:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjCEFOR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Mar 2023 00:14:17 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04EDC153
        for <io-uring@vger.kernel.org>; Sat,  4 Mar 2023 21:14:15 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id bx12so5759113wrb.11
        for <io-uring@vger.kernel.org>; Sat, 04 Mar 2023 21:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dbEq88wkkEA50IGIHjmE90aAPVSFcR1Zkxd+kwjetyM=;
        b=AgxlT9/7Aco8QeWIg34uXRqoh8sWH6FbZxnYOg2EmRjoUPrUHk4c8gmBXO/u4aUYZM
         7/mliwiMaZKYS9Uhwm3jaXV0YIXZUWDGcmSIoSA2vVmPCD8ro2JWNIOVU9iCFvbH1Fya
         oytGGFIrBy4ArC6s25j9mlOEIn5Z2AUZ28NymiZFk76DlUcidtXSdfNvz6zIZwq6rB9X
         lWDqJk853MNe3Dy7DXHVrjgkg6bnVDoSdlClwnGow+gd6UOQdN7WHgGuBc4g+1fDZAEQ
         seSsWdnE+IGZnxoBC8LsAjkGf0PHsFdqsn9EH9KeSwmf4SMeC4TlZe/nrHw9E5z0tM/K
         EKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dbEq88wkkEA50IGIHjmE90aAPVSFcR1Zkxd+kwjetyM=;
        b=NUmcwg7KClL7ymnvJw9A+esDxYOXEHUxdwgFHJFNa4bVVE4K8J4bzbDUvytJuMnD8U
         fE25ypQF7s1q9jBfxpHhYmI60b+T+/HpvOIzbOMejfA7mu/xBbK3kE8ov3i5EoRK/H/m
         CgaFZmnyRAPDmWRpTXnbjJCqbAMqzD1DUcuSxxpWXtnA50SPZAFSq33HaruPf6lHX518
         L3tklr3KodOdgVM9frHseREhFJ0OpOfiQN8E/SaGxk+qU35tvjHqcywbbu4bEex0CjAo
         EO8zrWVWsD5lkjAMcE8OjHoBoEtk1GDXY7v8Ok37k/h0KLt0Fie+CDRON3MGeC6ufMzT
         0mSA==
X-Gm-Message-State: AO0yUKWfVyDOuzim8bY0NrU3izVMae1PodF8y6YBk5OlMz/qcgIq+n3Q
        rtM4h1ZfHBnGyyOP7ZImRkESMXT6Y44=
X-Google-Smtp-Source: AK7set8iX8ljIW786m+5We7NPhYewLkDLiivZODRT2KHTjjxnp1Q4bDLCS1pj2RzmSH2e4CLFiFWpQ==
X-Received: by 2002:adf:ec4c:0:b0:2c7:156c:beb3 with SMTP id w12-20020adfec4c000000b002c7156cbeb3mr4728953wrn.69.1677993254297;
        Sat, 04 Mar 2023 21:14:14 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.92.184.threembb.co.uk. [94.196.92.184])
        by smtp.gmail.com with ESMTPSA id j4-20020adfff84000000b002cda9aa1dc1sm6524348wrr.111.2023.03.04.21.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 21:14:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 2/5] examples/send-zc: add affinity / CPU pinning
Date:   Sun,  5 Mar 2023 05:13:05 +0000
Message-Id: <b07fcc33a3c894086d8463575e390e28c0bee430.1677993039.git.asml.silence@gmail.com>
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

Pass '-C <cpu_num>' to pin threads and io-wq to the specified CPU.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index d60335c..baa2bdf 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -12,6 +12,7 @@
 #include <stdarg.h>
 #include <string.h>
 
+#include <sched.h>
 #include <arpa/inet.h>
 #include <linux/if_packet.h>
 #include <linux/ipv6.h>
@@ -49,6 +50,7 @@ static int  cfg_nr_reqs = 8;
 static bool cfg_fixed_buf = 1;
 static bool cfg_hugetlb = 0;
 static bool cfg_defer_taskrun = 0;
+static int  cfg_cpu = -1;
 
 static int  cfg_family		= PF_UNSPEC;
 static int  cfg_payload_len;
@@ -78,6 +80,32 @@ static void t_error(int status, int errnum, const char *format, ...)
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
@@ -171,6 +199,9 @@ static void do_tx(int domain, int type, int protocol)
 	if (ret)
 		t_error(1, ret, "io_uring: queue init");
 
+	set_cpu_affinity();
+	set_iowq_affinity(&ring);
+
 	if (cfg_fixed_files) {
 		ret = io_uring_register_files(&ring, &fd, 1);
 		if (ret < 0)
@@ -302,7 +333,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:d")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -343,6 +374,9 @@ static void parse_opts(int argc, char **argv)
 		case 'd':
 			cfg_defer_taskrun = 1;
 			break;
+		case 'C':
+			cfg_cpu = strtol(optarg, NULL, 0);
+			break;
 		}
 	}
 
@@ -362,6 +396,7 @@ int main(int argc, char **argv)
 	const char *cfg_test;
 
 	parse_opts(argc, argv);
+	set_cpu_affinity();
 
 	payload = payload_buf;
 	if (cfg_hugetlb) {
-- 
2.39.1

