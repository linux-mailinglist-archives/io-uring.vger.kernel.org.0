Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A2154E6E9
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 18:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbiFPQX2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 12:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377351AbiFPQXE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 12:23:04 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B5914009
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 09:23:03 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id n1so2284130wrg.12
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 09:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U9wkOM1plbUinAoA0/0bJvix8PjIfxAr3gMq6kk0yD8=;
        b=OozC7m3VvlKXSamw0Kry8xY2v2PYlmSMKRhKOc2V/ZKT8HkJS9PIf9NAweeKmXQDci
         znLL02tTcFYEzZOrKfxZoNq36FF85LtHjYmyl16fZTmTu3fylZ2suStFl6Awy3qf7w+q
         Ubf4JxvQnfnG+vCducXNnLVJYrYgE69GCSlkxQj7dJaa6vM4naBylS5x0gF+fPvhHZQz
         NhMvEN1d6eAp2nms7BY5EV0WfNECKRdkyE+EvB5H3/0pxI2p7gJci/e9SE6PV/f5opt1
         OJLMcqTssLb+YwRnXWox7V4xsAcciGZKdNQbJGX4B0VDhsP5Hbor6FOxW4fV45CXTQ97
         Exag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U9wkOM1plbUinAoA0/0bJvix8PjIfxAr3gMq6kk0yD8=;
        b=s8v9BiSHq/NduRbcfCLhBcxQDRQY6S5auCJrMESma5yp515UHSoK3e/3XsdIkfwaK1
         /K+P5zQi3aUNUfErUXXyGot3YKAzCAQZRTh9UITT1xYoQ86sdGjxBqfV4Dz7uCknUOnS
         veubQ2zjsPfmK8LxmmdTWMUcjmLzmQ31aECqeUFanUixge31XNTQRScRjji/70idX3B4
         +t5pdc7jEAXEkZ+xznBmuNrw/7tbKHzBCXxxPjw3GClp701Siz4I3H3df/3npI4zTKR+
         S1h51xdhCLcvojW9CGmrGW3CnNimiDTMm313apn9/j0LnmFvVseJWJ6p75dFcztTY3Go
         Zm2w==
X-Gm-Message-State: AJIora8H87cvC6SimhQQ2jlVjSxJcMrDhNbUH2X2Xqbca2sOMKBOlDiO
        yhWN+QIzvys/DiLU83uza/E=
X-Google-Smtp-Source: AGRyM1spKys9c5kp7pHAghKWGcvGmHqiwJxbIESi7A+KIbajVheRgxvUo5TLLxAm1GgXRV+ZIq/+5g==
X-Received: by 2002:a5d:5686:0:b0:217:7da8:8c5a with SMTP id f6-20020a5d5686000000b002177da88c5amr5174375wrv.3.1655396582400;
        Thu, 16 Jun 2022 09:23:02 -0700 (PDT)
Received: from fedora.fritz.box ([2a02:8010:60a0:0:a00:27ff:feb2:6412])
        by smtp.gmail.com with ESMTPSA id i3-20020a05600011c300b002102b16b9a4sm2187897wrx.110.2022.06.16.09.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 09:23:02 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH liburing] Fix incorrect close in test for multishot accept
Date:   Thu, 16 Jun 2022 17:22:45 +0100
Message-Id: <20220616162245.6225-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.36.1
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

This fixes a bug in accept_conn handling in the accept tests that caused it
to incorrectly skip the multishot tests and also lose the warning message
to a closed stdout. This can be seen in the strace output below.

close(1)                                = 0
io_uring_setup(32, { ...
...
write(1, "Fixed Multishot Accept not suppo"..., 47) = -1 EINVAL

Unfortunately this exposes a a bug with gcc -O2 where multishot_mask logic
gets optimized incorrectly and "Fixed Multishot Accept misses events" is
wrongly reported. I am investigating this separately.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 test/accept.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/test/accept.c b/test/accept.c
index 7bc6226..fb87a1d 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -103,7 +103,7 @@ static void queue_accept_conn(struct io_uring *ring, int fd,
 	}
 }
 
-static int accept_conn(struct io_uring *ring, int fixed_idx)
+static int accept_conn(struct io_uring *ring, int fixed_idx, bool multishot)
 {
 	struct io_uring_cqe *cqe;
 	int ret;
@@ -115,8 +115,10 @@ static int accept_conn(struct io_uring *ring, int fixed_idx)
 
 	if (fixed_idx >= 0) {
 		if (ret > 0) {
-			close(ret);
-			return -EINVAL;
+			if (!multishot) {
+				close(ret);
+				return -EINVAL;
+			}
 		} else if (!ret) {
 			ret = fixed_idx;
 		}
@@ -208,7 +210,7 @@ static int test_loop(struct io_uring *ring,
 		queue_accept_conn(ring, recv_s0, args);
 
 	for (i = 0; i < MAX_FDS; i++) {
-		s_fd[i] = accept_conn(ring, args.fixed ? 0 : -1);
+		s_fd[i] = accept_conn(ring, args.fixed ? 0 : -1, multishot);
 		if (s_fd[i] == -EINVAL) {
 			if (args.accept_should_error)
 				goto out;
-- 
2.36.1

