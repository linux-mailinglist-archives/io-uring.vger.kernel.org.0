Return-Path: <io-uring+bounces-6625-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6104A40159
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 21:52:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0AAF19C19A9
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 20:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF612512FC;
	Fri, 21 Feb 2025 20:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="CzpDip5e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881CB253331
	for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 20:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740171122; cv=none; b=Nwu9c4IicI8kPLMce6jtEuvclnyQHdIxHTRAezH0nGPE2U5P/Zt8a4xgRfsPCX8aSrDtsY0bV3n+wMjvyF/ujKQ8aji5w2wj6wIG8yJOSjr73vl1FQG1PGoXGVLUIiwxOqqjcHPmSPPnT+FEEeWl20rA16/hef2m/ZsMU9nslDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740171122; c=relaxed/simple;
	bh=FfqYGy8b07uSLXQodIrztUZ4I6DB2xhiR7+BkOa1vFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pi+TfrkM3Fc34zxj/szluWLj9mtYq5o4VvgsR3BQgM403i3600LCGDne85mbsYg6rnO+8R+NT498tX0E6QBK2GDyulPgunMIAE+OlH9z8wrYuQjIPcrwbfA9lG9KfHSsHH5yHv24nG+anqGOXi0Ca4KYVC0RUYxE9M6j3Gkaees=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=CzpDip5e; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-220dc3831e3so58073655ad.0
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 12:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740171120; x=1740775920; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0HEktxV4Q3t/rtiye36mZ1RmDr9jA8IU4pdGgVXdYsw=;
        b=CzpDip5ekmUEVwxKZ0nJo6/JpmWp9G71PEx92qoDAdGGioqbYUN/t43iF/0RpmA/1D
         uWh7q/et+1hXdB8EFx/t6H53kXOVEXF17qpiXW3sfiWYCbB43emKp70GFvJ58isUgh0n
         lMURgbPW1NLsMBZ6T3UFkjSdC1joj/7wkVb1CZmhRwHT2KwEO4p8mPjI+PqDHhLNl8pn
         LA7J69qfkIm5EJcC4DWT1/4JTVzdUryvlgmcZNASeU61Z2VlxGWXzurHa8+mu0aUYhei
         sbePq/jVDUapYVeTIkj2W6L4LNhVj5xPvmXIEgmEpJudfDGUTStou8WkI0Z4nV0gVfqb
         XKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740171120; x=1740775920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0HEktxV4Q3t/rtiye36mZ1RmDr9jA8IU4pdGgVXdYsw=;
        b=SXFS5sH2HqflnFYFtO2dBuJOF+xHrnABjZiq8aQQPd3AqJ3GBf9+YYoD6KgGX1IBiH
         o99CdNxtZ5jPhIQ/ipm01YOm9fJKoxNm01iumqHu05gnnsb5BeRm09oQKJIqn1536i0w
         d0CinuwePnK+m82sFl3MNP8Sdke3PBWCCTL7T7+Oc0/w37ws8y0wILivqpm1bOdhsn0T
         9U676XaXv8RJMyA5oWGilg+YNzlcAiF1/opjmVOxF27z4BmaWqavmbqHSYY7NXAr/kzZ
         qNbva/UNnN4MgRNtW/FhXaMtBKM3uq2c22CM+B16xAALOrCA1igW5tAd0rFAYoDnJp1h
         pZhg==
X-Gm-Message-State: AOJu0YywL/9gYF8sPoAVp9obI3UATFvE7IZE47wx+UO5BpJ6YPI9Lg0A
	ZCuIr8vFcP71B/GouxA1oH2uL459InZdMygdRcCQV/BAkGta1eO1e6XkQtJS++GQXGTtqjYEw/V
	6
X-Gm-Gg: ASbGncua7CF9vR14BXs/Chz3Wo+bpi6uRDLiOo7Hentj+B5TO5YgLuA2LmXmAHV20Ok
	7HD++1OQHWYVgsyM388PNmagoxP2ExKuS8N8na8gYzU7PFc+T25OQpw3SHMaOaO8jgwlT8jdbO5
	5cHlKfjHS27PDQXwTBrE0hHZmO7On3IdWG+q/WHdFFU6Gg5E0rColdg5KjR1HIoA4zO74p3ftY3
	4zQfwVdht1cEhu0vrdJv1g0T4ccepa3H5Iblbo30DqmFpyPyhr3HyRph9y5ANdVpzG9lusd+2GR
	aUorjua8vw==
X-Google-Smtp-Source: AGHT+IHJsxq7agJBHvXEvufkqecZYtxl4Dprk/uVHHBdlUsRVJRAN6jrIlw/CxdzHb5PC5vnYm0/WQ==
X-Received: by 2002:a62:b610:0:b0:732:57d3:f004 with SMTP id d2e1a72fcca58-73414089d42mr11212469b3a.6.1740171119695;
        Fri, 21 Feb 2025 12:51:59 -0800 (PST)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-732707863cbsm11267358b3a.128.2025.02.21.12.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 12:51:59 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 2/2] io_uring/zcrx: add selftest case for single shot recvzc
Date: Fri, 21 Feb 2025 12:51:46 -0800
Message-ID: <20250221205146.1210952-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250221205146.1210952-1-dw@davidwei.uk>
References: <20250221205146.1210952-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a selftest case to iou-zcrx where the sender sends 4x4K = 16K and
the receiver does 4x4K single shot recvzc. Validate that the requests
are successful and the data is not corrupted.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 .../selftests/drivers/net/hw/iou-zcrx.c       | 43 ++++++++++++++++---
 .../selftests/drivers/net/hw/iou-zcrx.py      | 27 +++++++++++-
 2 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
index 5d04dd55ae55..c26b4180eddd 100644
--- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
@@ -61,6 +61,9 @@ static int cfg_port = 8000;
 static int cfg_payload_len;
 static const char *cfg_ifname;
 static int cfg_queue_id = -1;
+static bool cfg_oneshot;
+static int cfg_oneshot_recvs;
+static int cfg_send_size = SEND_SIZE;
 static struct sockaddr_in6 cfg_addr;
 
 static char payload[SEND_SIZE] __attribute__((aligned(PAGE_SIZE)));
@@ -196,6 +199,17 @@ static void add_recvzc(struct io_uring *ring, int sockfd)
 	sqe->user_data = 2;
 }
 
+static void add_recvzc_oneshot(struct io_uring *ring, int sockfd, size_t len)
+{
+	struct io_uring_sqe *sqe;
+
+	sqe = io_uring_get_sqe(ring);
+
+	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, sockfd, NULL, len, 0);
+	sqe->ioprio |= IORING_RECV_MULTISHOT;
+	sqe->user_data = 2;
+}
+
 static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
 {
 	if (cqe->res < 0)
@@ -204,7 +218,10 @@ static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
 		error(1, 0, "Unexpected second connection");
 
 	connfd = cqe->res;
-	add_recvzc(ring, connfd);
+	if (cfg_oneshot)
+		add_recvzc_oneshot(ring, connfd, PAGE_SIZE);
+	else
+		add_recvzc(ring, connfd);
 }
 
 static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
@@ -218,7 +235,7 @@ static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
 	ssize_t n;
 	int i;
 
-	if (cqe->res == 0 && cqe->flags == 0) {
+	if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs == 0) {
 		stop = true;
 		return;
 	}
@@ -226,8 +243,14 @@ static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
 	if (cqe->res < 0)
 		error(1, 0, "recvzc(): %d", cqe->res);
 
-	if (!(cqe->flags & IORING_CQE_F_MORE))
+	if (cfg_oneshot) {
+		if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs) {
+			add_recvzc_oneshot(ring, connfd, PAGE_SIZE);
+			cfg_oneshot_recvs--;
+		}
+	} else if (!(cqe->flags & IORING_CQE_F_MORE)) {
 		add_recvzc(ring, connfd);
+	}
 
 	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
 
@@ -237,7 +260,7 @@ static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
 
 	for (i = 0; i < n; i++) {
 		if (*(data + i) != payload[(received + i)])
-			error(1, 0, "payload mismatch");
+			error(1, 0, "payload mismatch at ", i);
 	}
 	received += n;
 
@@ -313,7 +336,7 @@ static void run_server(void)
 
 static void run_client(void)
 {
-	ssize_t to_send = SEND_SIZE;
+	ssize_t to_send = cfg_send_size;
 	ssize_t sent = 0;
 	ssize_t chunk, res;
 	int fd;
@@ -360,7 +383,7 @@ static void parse_opts(int argc, char **argv)
 		usage(argv[0]);
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46sch:p:l:i:q:")) != -1) {
+	while ((c = getopt(argc, argv, "sch:p:l:i:q:o:z:")) != -1) {
 		switch (c) {
 		case 's':
 			if (cfg_client)
@@ -387,6 +410,14 @@ static void parse_opts(int argc, char **argv)
 		case 'q':
 			cfg_queue_id = strtoul(optarg, NULL, 0);
 			break;
+		case 'o': {
+			cfg_oneshot = true;
+			cfg_oneshot_recvs = strtoul(optarg, NULL, 0);
+			break;
+		}
+		case 'z':
+			cfg_send_size = strtoul(optarg, NULL, 0);
+			break;
 		}
 	}
 
diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
index ea0a346c3eff..d301d9b356f7 100755
--- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
@@ -34,14 +34,37 @@ def test_zcrx(cfg) -> None:
         raise KsftSkipEx('at least 2 combined channels required')
     rx_ring = _get_rx_ring_entries(cfg)
 
-    rx_cmd = f"{cfg.bin_remote} -s -p 9999 -i {cfg.ifname} -q {combined_chans - 1}"
-    tx_cmd = f"{cfg.bin_local} -c -h {cfg.remote_v6} -p 9999 -l 12840"
+    try:
+        ethtool(f"-G {cfg.ifname} rx 64", host=cfg.remote)
+        ethtool(f"-X {cfg.ifname} equal {combined_chans - 1}", host=cfg.remote)
+        flow_rule_id = _set_flow_rule(cfg, combined_chans - 1)
+
+        rx_cmd = f"{cfg.bin_remote} -s -p 9999 -i {cfg.ifname} -q {combined_chans - 1}"
+        tx_cmd = f"{cfg.bin_local} -c -h {cfg.remote_v6} -p 9999 -l 12840"
+        with bkg(rx_cmd, host=cfg.remote, exit_wait=True):
+            wait_port_listen(9999, proto="tcp", host=cfg.remote)
+            cmd(tx_cmd)
+    finally:
+        ethtool(f"-N {cfg.ifname} delete {flow_rule_id}", host=cfg.remote)
+        ethtool(f"-X {cfg.ifname} default", host=cfg.remote)
+        ethtool(f"-G {cfg.ifname} rx {rx_ring}", host=cfg.remote)
+
+
+def test_zcrx_oneshot(cfg) -> None:
+    cfg.require_v6()
+
+    combined_chans = _get_combined_channels(cfg)
+    if combined_chans < 2:
+        raise KsftSkipEx('at least 2 combined channels required')
+    rx_ring = _get_rx_ring_entries(cfg)
 
     try:
         ethtool(f"-G {cfg.ifname} rx 64", host=cfg.remote)
         ethtool(f"-X {cfg.ifname} equal {combined_chans - 1}", host=cfg.remote)
         flow_rule_id = _set_flow_rule(cfg, combined_chans - 1)
 
+        rx_cmd = f"{cfg.bin_remote} -s -p 9999 -i {cfg.ifname} -q {combined_chans - 1} -o 4"
+        tx_cmd = f"{cfg.bin_local} -c -h {cfg.remote_v6} -p 9999 -l 4096 -z 16384"
         with bkg(rx_cmd, host=cfg.remote, exit_wait=True):
             wait_port_listen(9999, proto="tcp", host=cfg.remote)
             cmd(tx_cmd)
-- 
2.43.5


