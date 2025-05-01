Return-Path: <io-uring+bounces-7807-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD74FAA6341
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 20:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 633577AE6CA
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 18:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA982153FB;
	Thu,  1 May 2025 18:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aSPjG9hi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CBB223316
	for <io-uring@vger.kernel.org>; Thu,  1 May 2025 18:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746125749; cv=none; b=Bd6z5DxA8aib2r6pkgQzUcBm4Uw0eH4NBLpP9+Ff7cXQUn9PRCXuw4fevKxwqel8olCUDV35tbtKEzLe1jXLRrg9qPecJ7SpVS3i0jjsve76sNJtD4u6RQGcoWdeCgWcodFVko6YcmUBfQtsXvFR8GZNMjARf1vkrY2YzhOuqBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746125749; c=relaxed/simple;
	bh=EX0dp+qdCRe1ogStwfzDquAz0JMASqblzST7f6KYj6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVSXNWi9G5PraTfxW/oL1Qn9qgfs64S3bpwmFB8xzuhchNq/WLBZY9Gruy804ROgniB3NdZ9jiYd1wLWgDF7FMsKivT34pr+aKXLQ6vbhGkAiA/Z7KSz2IVr+hGC9tsRwxMEfQ9bDe8gILCGHW97Uzvn+gJTz5pcXaGTj0RCQrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aSPjG9hi; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e5c7d6b96fso2250293a12.3
        for <io-uring@vger.kernel.org>; Thu, 01 May 2025 11:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746125745; x=1746730545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ai9s+hQXClPjz/Pdu/F/gefUdfFyS3b9OKFvObOm1Ho=;
        b=aSPjG9hi5OLgbh6H4imQe6Rj/0yz+mbtsbKQ7qeLTHS871pV3j8JKvJ7PV5/L4CULI
         kM2FNc7feaERmBKc9YTkOgJdLVOWbh+B/2E2DGFyLcabG5zaOzoea4KoQ7OMh/urWUnS
         bOfya3rfj/poDHJSKKQOwSwVymhY7c+/pwayiynTRdz1jeNLHQn57cnqxnG1hD3iIEPe
         Lp4c7DcPIEre3njEsrnxE8Lxa8DkxnktGqfzyzaDgQ2SYM2NJXF7sX6qg3adKkpEidjb
         jM23gZZXiM+lf4tYzhiS+Hj5rX305lUprqCG+0nm7CvZq7tndS+enWHUyzguwNR4itJy
         UYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746125745; x=1746730545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ai9s+hQXClPjz/Pdu/F/gefUdfFyS3b9OKFvObOm1Ho=;
        b=uoP+mbKnnBeIILUCphEoV7VmsG8nTbl3tgaXGDSUms30AVouNZAUbeuwSyXBAX7wYj
         QtAvdmcImosMU4HKZrQ5IykVkUN+3eJegw3Lun4MGvR6dLQaAExwhwR/6wrC4dz2bHIk
         T5WMQSnwUUwCtSVV/ygpCG6XNQSOSc/jM5Bc4Xdh0qvEpqs9XB5yv0a166bz4wXymIfy
         kTsunMlTQK6vI9nK2UEZlyJk1uaCi0ekOgwTGF/lrgM7cQAMb1JNnKg5u2WB4jdhnLO4
         pNRhlRSLLQn/yL/rEHPQLIvIuB2SdgjliZQtwiWCqtplCr5iqqIoFeoXkueeA6FAtftj
         8dtQ==
X-Gm-Message-State: AOJu0YzTHzj2cJ1u6WD2oaQLwjl1y+IpAU/aTNRbjPBXJfTN1ZSGrOOL
	wFRoomwgrbKEeAk/v8oOOEdTbUGQhSMTM93F0l2qnXQnQHmu7CHRC8sH/Q==
X-Gm-Gg: ASbGncvcLKEfh4+kPdpcrg1jqZ1tMNeprnb9FiltpXsk6IYE1tfzyBCFJ4GTE4rxFVZ
	aSvILXmCu0Eoyae+cynxPpRVIbf5KIJ6AMPTwYjXtJwUAauEmR5SPNOeLZETscEKAe5PPOf7r1s
	PV0FE43rjOG//mF6X4LA42BS6DxkAapfJnrVsOQMSgAuuCStSLBhbgo3ZBk4otSqGXoGU59ydpR
	wnFlPJM9dvjX1iCR8AHQztC+To3sxxdDQQ+LK5Gii+nqqmJc6hocu6m1SR6Oae/04VyWOppej9V
	XFXoAcxRIbyg5LaBJR7shVWXvjQqt66G2l3u/eCuBUjYFZ4sk3DRwD1PFUxndXwk
X-Google-Smtp-Source: AGHT+IHXDNsY9yDic989qOPQ/yeT6emZ404IMFwVdfGHC1id/h8LOnt/dWb1++5AoKFwYkfDqUuYaQ==
X-Received: by 2002:a17:906:4fca:b0:acb:5070:dd19 with SMTP id a640c23a62f3a-ad17b00df14mr26774966b.61.1746125745320;
        Thu, 01 May 2025 11:55:45 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad0c70d3955sm79059566b.7.2025.05.01.11.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 11:55:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 3/4] examples/send-zc: optionally fill data with a pattern
Date: Thu,  1 May 2025 19:56:37 +0100
Message-ID: <bafcd4da1148fdff2890c6ee186bfb516f434a65.1746125619.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746125619.git.asml.silence@gmail.com>
References: <cover.1746125619.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

-v option tells to make the outgoing traffic to follow a pattern, which
is repeating all lower case letters. zcrx already has an option to
verify received data.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index b4721672..ab67d189 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -76,11 +76,12 @@ static int  cfg_payload_len;
 static int  cfg_port		= 8000;
 static int  cfg_runtime_ms	= 4200;
 static bool cfg_rx_poll		= false;
+static bool cfg_verify;
 
 static socklen_t cfg_alen;
 static char *str_addr = NULL;
 
-static char payload_buf[IP_MAXPACKET] __attribute__((aligned(4096)));
+static char payload_buf[IP_MAXPACKET + 26] __attribute__((aligned(4096)));
 static char *payload;
 static struct thread_data threads[MAX_THREADS];
 static pthread_barrier_t barrier;
@@ -376,7 +377,7 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 	}
 
 	iov.iov_base = payload;
-	iov.iov_len = cfg_payload_len;
+	iov.iov_len = cfg_payload_len + 26;
 
 	ret = io_uring_register_buffers(&ring, &iov, 1);
 	if (ret)
@@ -403,13 +404,18 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 		unsigned msg_flags = MSG_WAITALL;
 
 		for (i = 0; i < cfg_nr_reqs; i++) {
+			char *buf = payload;
+
+			if (cfg_verify && cfg_type == SOCK_STREAM)
+				buf += td->bytes % 26;
+
 			sqe = io_uring_get_sqe(&ring);
 
 			if (!cfg_zc)
-				io_uring_prep_send(sqe, fd, payload,
+				io_uring_prep_send(sqe, fd, buf,
 						   cfg_payload_len, 0);
 			else {
-				io_uring_prep_send_zc(sqe, fd, payload,
+				io_uring_prep_send_zc(sqe, fd, buf,
 						     cfg_payload_len, msg_flags, 0);
 				if (cfg_fixed_buf) {
 					sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
@@ -527,7 +533,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:I:b:l:dC:T:Ry")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:I:b:l:dC:T:Ryv")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -582,12 +588,19 @@ static void parse_opts(int argc, char **argv)
 		case 'R':
 			cfg_rx = 1;
 			break;
+		case 'v':
+			cfg_verify = true;
+			break;
 		case 'y':
 			cfg_rx_poll = 1;
 			break;
 		}
 	}
 
+	available_buffer_len = cfg_payload_len;
+	if (cfg_verify)
+		available_buffer_len += 26;
+
 	cfg_test = argv[argc - 1];
 	if (!strcmp(cfg_test, "tcp"))
 		cfg_type = SOCK_STREAM;
@@ -604,8 +617,13 @@ static void parse_opts(int argc, char **argv)
 		t_error(1, 0, "-n: submit batch can't be zero");
 	if (cfg_ifname && cfg_rx)
 		t_error(1, 0, "Interface can only be specified for tx");
-	if (cfg_nr_reqs > 1 && cfg_type == SOCK_STREAM)
+	if (cfg_nr_reqs > 1 && cfg_type == SOCK_STREAM) {
 		printf("warning: submit batching >1 with TCP sockets will cause data reordering");
+		if (cfg_verify)
+			t_error(1, 0, "can't verify data because of reordering");
+	}
+	if (cfg_rx && cfg_verify)
+		t_error(1, 0, "Server mode doesn't support data verification");
 
 	str_addr = daddr;
 
@@ -637,8 +655,10 @@ int main(int argc, char **argv)
 
 	pthread_barrier_init(&barrier, NULL, cfg_nr_threads);
 
-	for (i = 0; i < IP_MAXPACKET; i++)
-		payload[i] = 'a' + (i % 26);
+	if (cfg_verify) {
+		for (i = 0; i < available_buffer_len + 26; i++)
+			payload[i] = 'a' + (i % 26);
+	}
 
 	for (i = 0; i < cfg_nr_threads; i++) {
 		td = &threads[i];
-- 
2.48.1


