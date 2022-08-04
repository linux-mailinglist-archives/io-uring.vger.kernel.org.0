Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31AC589D67
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 16:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239487AbiHDOVg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 10:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239700AbiHDOVg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 10:21:36 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E4647BAA
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 07:21:34 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w3so9894558edc.2
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 07:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=40GIJeWXkRh0CCXmtErKQ4+wmKT1qUseLdNeN4jDS1I=;
        b=NjP+nxe7kjbf2fOOEa2DjEngm5PAj8nLlkiBWwDx/q6MUPfhCdFB3sTm6p+acK4qqN
         38rWsL/75p9q4LuyVDnISoLw8E1FLX0bilWuZe0Hevm2YtqEv0xRMavw60VlMH6yOJqv
         Vtg80zXhJfaWU0uFmWDxEtMRTggPFVK8WE26Od49cHmgGB59wVLTEHjWuf+j72METX0Q
         5ljSOr8Kkre/pbjfEa1vkLK5wDnTvhiDA7J9+ipWk7JB72RCTzlwXB0vsPb27T1B9LFf
         IQs4/JhNjEEaa/nWAxT5O1smF1FOqUrIpUYvDKwrAf6NWyM41a4wVMtcqSs2cz1/tpou
         huPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=40GIJeWXkRh0CCXmtErKQ4+wmKT1qUseLdNeN4jDS1I=;
        b=udZj4apaA7cSGTVhCqEKK5/+fjohBsbExVao7DDEifa5lMkd4KT8Os0b0Ow5c/qLYb
         6DFtamc3ag3U1eg6rJFCEy7CGgiPONWazTsb3HPiEdBS2Nq87FGyA8krf9v624vh2Yj1
         66PBDNk7mbVPGQU0lGmVPnaGXSJT+o5OA2DcTA5PvRL+CMC+79OFJ5H2cDrMtAmw9jwY
         YyTIZFuLyPC+HnINcJgGctvAxiwgD/39gSCn0mnCCgW1cCcNi0K+KhKGNC3Pl6jMh2Yu
         9upSz7xmLd3HTgqg+MKOjL7KnUnMA/rr/Gz/l9zohKL17NXnaI44oQ/fEp/GD3+iL0pm
         Ibwg==
X-Gm-Message-State: ACgBeo0GktwQWr4PprXM9T4kUehaOyNfjSCawe4stmGefPteCBkvAqny
        UAdLJrwdhGud15IHqE3mMLcodEnGa/k=
X-Google-Smtp-Source: AA6agR48q/IlnYTgigRQnjYMLb+fwhDnI+ThTJYycHHxdsDvRD7Ad/5c3fskJrIDCa1LuSzcLIv6Kg==
X-Received: by 2002:a05:6402:40ce:b0:43d:f8a0:9c4f with SMTP id z14-20020a05640240ce00b0043df8a09c4fmr2295319edb.95.1659622893062;
        Thu, 04 Aug 2022 07:21:33 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id r10-20020aa7c14a000000b0043bc33530ddsm727945edp.32.2022.08.04.07.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:21:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 5/6] test/zc: recv asynchronously
Date:   Thu,  4 Aug 2022 15:20:24 +0100
Message-Id: <e50ed637cdba845e7f68f7e97fb05dee69b007d4.1659622771.git.asml.silence@gmail.com>
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

Receive in a separate task to avoid locking up in case of short sends.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 56 ++++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index d0f5931..617e7a0 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -653,7 +653,8 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	size_t chunk_size = send_size / nr_reqs;
 	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
 	char *buf = buffers_iov[buf_idx].iov_base;
-	size_t bytes_received = 0;
+	pid_t p;
+	int wstatus;
 
 	assert(send_size <= buffers_iov[buf_idx].iov_len);
 	memset(rx_buffer, 0, send_size);
@@ -700,16 +701,35 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		return 1;
 	}
 
-	while (bytes_received != send_size) {
-		ret = recv(sock_server,
-			   rx_buffer + bytes_received,
-			   send_size - bytes_received, 0);
-		if (ret <= 0) {
-			fprintf(stderr, "recv failed, got %i, errno %i\n",
-				ret, errno);
-			return 1;
+	p = fork();
+	if (p == -1) {
+		fprintf(stderr, "fork() failed\n");
+		return 1;
+	}
+
+	if (p == 0) {
+		size_t bytes_received = 0;
+
+		while (bytes_received != send_size) {
+			ret = recv(sock_server,
+				   rx_buffer + bytes_received,
+				   send_size - bytes_received, 0);
+			if (ret <= 0) {
+				fprintf(stderr, "recv failed, got %i, errno %i\n",
+					ret, errno);
+				exit(1);
+			}
+			bytes_received += ret;
 		}
-		bytes_received += ret;
+
+		for (i = 0; i < send_size; i++) {
+			if (buf[i] != rx_buffer[i]) {
+				fprintf(stderr, "botched data, first mismated byte %i, "
+					"%u vs %u\n", i, buf[i], rx_buffer[i]);
+				exit(1);
+			}
+		}
+		exit(0);
 	}
 
 	for (i = 0; i < nr_reqs; i++) {
@@ -734,11 +754,17 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		io_uring_cqe_seen(ring, cqe);
 	}
 
-	for (i = 0; i < send_size; i++) {
-		if (buf[i] != rx_buffer[i]) {
-			fprintf(stderr, "botched data, first mismated byte %i, "
-				"%u vs %u\n", i, buf[i], rx_buffer[i]);
-		}
+	if (waitpid(p, &wstatus, 0) == (pid_t)-1) {
+		perror("waitpid()");
+		return 1;
+	}
+	if (!WIFEXITED(wstatus)) {
+		fprintf(stderr, "child failed %i\n", WEXITSTATUS(wstatus));
+		return 1;
+	}
+	if (WEXITSTATUS(wstatus)) {
+		fprintf(stderr, "child failed\n");
+		return 1;
 	}
 	return 0;
 }
-- 
2.37.0

