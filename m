Return-Path: <io-uring+bounces-6653-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FBE9A4146B
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 05:13:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5C893B2009
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 04:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B76E21A3153;
	Mon, 24 Feb 2025 04:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="riwjX6Zv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DAF194C61
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740370410; cv=none; b=mQUcW3xtHCYY/efJHB96zWu8tG/HyplL+rr3cfGXvhlqGewnXHthSeR4sotSuoMouuLSPag4JctACUtahx962WnXOXXoQpsxurfMuV/Qca2BND3Jovh3owCDorLV4HZ43bd6Yy263ls0omwDsj4u26G5ux2yZHi0txXJqR1jdlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740370410; c=relaxed/simple;
	bh=8OrKcp7equzeG3tGdfDMFn+f1QKM3cQWPZKQL/7wUr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7GexnVHdZWwJYBTPpojMXmQY8HiA+jkWuoijBHRsDkpWF5ScRsFsMHl4wz5yEfsE9Ygr0J4B+zlD9Qd7ZbDCcCwJRcYgKckV48nKrHlGlehq/7+jADzvymu2hI1idYr83qkfrftFxMYVtWflKy9T+pxa03v22L4wJut6EO2PrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=riwjX6Zv; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-220d28c215eso58504445ad.1
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 20:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740370408; x=1740975208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJbKmTBhWVrel+9zJJaXnq4FVVnPUdEraVS029Zzc94=;
        b=riwjX6ZvpdVUSL/pqnkOB5cDcP59qwbWZXQGPU/JnLv485fzzhWV/kyXqTTp3W48a0
         I21f11ATjXpk0wS5ubWn4+IiNBcarTklMmfNpixFTi/9mZDdVIvYPTGhhts9Ty01XKvC
         9TnHsfABPe+BNOoDfbwSnElzS9LirjCq+rQmWihbmI6ELx8oqPLCZw3qxE4t0PmMPD3S
         xe9u2K1UdnHHQqZygz0dKDi9jVOfwFoh4fBVluhnZXeT3/GROnFk0kENENKNQq44+VtD
         4GoYo1W+DEevt2LVxI93tRlnwbuCXgUGD9FWBM+rJ1DZe4N5njClY4gNbj7nC6GU0pwU
         FiSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740370408; x=1740975208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SJbKmTBhWVrel+9zJJaXnq4FVVnPUdEraVS029Zzc94=;
        b=tWA0/0Mqvo5crGpA5eTK6E7t/rXbMX7Sr6YJHoOn4JtwkDFJUwWqZS51O5AIFtCxML
         vfYjvTbUAePWElrMCeQbFcPclGc3zUFF/4Uf5o7mPiMrbPYi5oTYEwLK6b6AS+aRJ71H
         5Tti0XifdNPhLWxc+pQZ810FsRPKFzDGRI1H8aaN9Bcmfion9gaY1Y85V/kEt+EKKuIx
         35NitqsHXXdir8i46khKIK4NeNC6WVs5KIORtqvv5d3rycQn6gSApDV5KnUzNH9NL7jK
         lMtOeELMJZIBKUFHYKyORkPK6fYa+vaLM48Ox0+mCfutwLTezj3CHvY7ZalLHGWplxt7
         Nx8g==
X-Gm-Message-State: AOJu0Yyrd9JvFaPAeYFCwpFL7DXJVJP+CtFjkRWTf4p51+YoGxY8uVQI
	uwjnMfH6tGOWMRSUH0mHdwpxT1AJqWIrn8VziPuufLnWxzwhQnb4PqW2RLEBUC3XbgMR3wwECRg
	Q
X-Gm-Gg: ASbGncsBUeK4dl5us8UZd0W+Q0DzEk2jHMXO53YVMTUB6v29t0lv95qgnxTpIk5G62b
	ra+aIoFEho2olyfDR7djuUUI5dAHRYW1DExiT74/xdqxIsZB7jOSEA5YrLKYNKQcvfEidFNiSGB
	KVuo+fR5YjEhijgSzK4w2Br83XWkTKwrJgQq9bnZcuuGM/e3cEp5NEEktYeCOBw8uBT65lawSVb
	2mPXCWm7Z7h1mALDMVEROJGq6YF7aoa+4SK07nVF5vtoc60F1Mv6FnL0mY7zDdwzdc5Jpvz56jx
	JGX9OMtVNtc=
X-Google-Smtp-Source: AGHT+IG3bfFHC7+oolQJuWpm/sbsvRfLnAX8zANIy1LIv3hmPByUDjaQ5vVTII2yfmZLoNFa98WZLA==
X-Received: by 2002:a17:902:d4cd:b0:21f:6546:9af0 with SMTP id d9443c01a7336-2219fffa862mr223606765ad.44.1740370408248;
        Sun, 23 Feb 2025 20:13:28 -0800 (PST)
Received: from localhost ([2a03:2880:ff:10::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d53490absm171699075ad.41.2025.02.23.20.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2025 20:13:27 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	lizetao <lizetao1@huawei.com>
Subject: [PATCH v3 2/2] io_uring/zcrx: add selftest case for recvzc with read limit
Date: Sun, 23 Feb 2025 20:13:19 -0800
Message-ID: <20250224041319.2389785-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250224041319.2389785-1-dw@davidwei.uk>
References: <20250224041319.2389785-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a selftest case to iou-zcrx where the sender sends 4x4K = 16K and
the receiver does 4x4K recvzc requests. Validate that the requests
complete successfully and that the data is not corrupted.

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


