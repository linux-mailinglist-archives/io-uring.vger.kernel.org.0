Return-Path: <io-uring+bounces-6501-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC9E5A3A355
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 17:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E72A1892F71
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 16:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD6626FDAA;
	Tue, 18 Feb 2025 16:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="yq9aPGG4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F24B26FA6E
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 16:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739897842; cv=none; b=N4sg+820fy8odERrkW1Srcg+5iaZBwHEr9hIkE5vr3JOtLWez2UItf1PLo6yKl+mpkgtWQTG9phsZYT7DBqIE50IqpJ5ZGTMj0B81IPjeBbm63fv/ugQqvlY31r81cuFGRSN3fePA06KFC0imKPBuTbqq5GV5gr5pKiUpP1+Tzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739897842; c=relaxed/simple;
	bh=6PS//lO+rorS7RVWVpqSRGD/hz7YUE+g1sY+VjICbhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbJODcUFIEVhzn4STuBnaYYlRKYiv21/Uk9uOtlq249NxzH9bIpSVQvu3VC/xvfOt+r4962q2aonY+7jDh0kMA648pBVNUtCf3b9fZEbYY+RqM1pRwLMnI8+btkBtei88kctnAzrlU7vr0WMsekMO+PlCrxI9FsYypnyqbnemRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=yq9aPGG4; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-220e83d65e5so91435345ad.1
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 08:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739897839; x=1740502639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NOCzxCVxAvNYsJunStzLE+uJyOxRfSh+zzOduGNwM6o=;
        b=yq9aPGG4SSI1l5G3+l1ot7mMDZrusf7OrhPjabP601YJBGJ9EzVgDSGjHeythqj3Ij
         fM3CZ8peSFVBX6lE5SWFhWWI3NNqqoP3WAWmzWjHpNxCVt9wHEt8QXoXG38ITi3hPn8S
         jxYhtuzWfLZKPbkKqgt+cv6c/u2ZugIMzeehD158ra/SZzeaYolU3ldVSnFlzdsBv6+p
         ZBJ3uU28dXikgDqR5OU8GpBHxkMPgRvVBnsZuqdMLMt8/FQMfIKNa65tpamYMZl4fERi
         z+/XLvpjUuDzhBnpR+m+1dvmipnlq8iUrelEvn6i9rQXFoHLRxkfyeU2qpenzGOsnTRf
         FyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739897839; x=1740502639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NOCzxCVxAvNYsJunStzLE+uJyOxRfSh+zzOduGNwM6o=;
        b=u8WjSKJdnxOPLnxaTL9II97dSlRE21gGQ669tM1HDeNPyKnQm25hAyodPxa7ZutG+O
         JCZzBRHwZpqqrebUQ8hw37z5Ocv6vfjBt1usN6Rye4m/W2QkS7kCn6havMwJqm5NHlMz
         lUb/f3mwRWkJkBeOJx4F4HLipue1mugETypPtlT1eQF+OvvNS2pntdp37qFmYZ5uN1KH
         zcHhRb8lXQn/EkQfCxoEO8qGibCe0e2U3CmW7LQPK+B/eZ/fZzvhEjHgjJUxR9ypMhSp
         U58eDbKGsHF2HR6EaPCr7pj99dynHs9U796KunCh7uousfWsJoJ4uC7pR/+apuQpePW4
         CgvQ==
X-Gm-Message-State: AOJu0Yx5oacCZqbiomBru7ADVRXa9dqNZqTaXsUgPcZcqGNuXS7Gjtaj
	hC0jMxZCUDQYQ2KUj8L53aaVRBOoIA/ampILqnm7WRlML0xfS3jNvw2SWjQgszegOS7R8pzXc66
	U
X-Gm-Gg: ASbGncsNfrHTTopGbvTlIYsUE+2ls0f4TiL7uiNrXlGkz/hFQ7do8Dre9nQOV4PAsaN
	IqE2k+NJEyKTTAw1yiFD3EDYfn3VjzrDskamKg4GaSOGeDwDB5SUI7pCYv9Uor6NU1FgQMxxVaP
	hWoQ5g0TkqxikSqUYQxs0CYyRqB9fNtYYLBDaxpLlvALqx6zXQUxq7NOc7bG3orH4sXmg8jbKXQ
	ZHreiiOs2Jel1qSV1MumAF6Uo9k+BbLw2N6rs6PalUfZX0d63ryGD2FKgvVbxcRWOnZa/KCEjKn
X-Google-Smtp-Source: AGHT+IHrBY1zHRHYuJwNRTUUiPrjLEbsi+HbbM1cKYH1pTj4lnerUD971C+dgGwGEIVOFndsOX6tnw==
X-Received: by 2002:a17:902:d2c6:b0:220:be86:a42d with SMTP id d9443c01a7336-22170777df8mr3063875ad.21.1739897839536;
        Tue, 18 Feb 2025 08:57:19 -0800 (PST)
Received: from localhost ([2a03:2880:ff:16::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d5590770sm90673115ad.231.2025.02.18.08.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 08:57:19 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH v1 2/2] io_uring/zcrx: add selftest case for single shot recvzc
Date: Tue, 18 Feb 2025 08:57:14 -0800
Message-ID: <20250218165714.56427-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250218165714.56427-1-dw@davidwei.uk>
References: <20250218165714.56427-1-dw@davidwei.uk>
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
 .../selftests/drivers/net/hw/iou-zcrx.c       | 42 ++++++++++++++++---
 .../selftests/drivers/net/hw/iou-zcrx.py      | 27 +++++++++++-
 2 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
index 5d04dd55ae55..e7f0688991ab 100644
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
@@ -196,6 +199,16 @@ static void add_recvzc(struct io_uring *ring, int sockfd)
 	sqe->user_data = 2;
 }
 
+static void add_recvzc_oneshot(struct io_uring *ring, int sockfd, size_t len)
+{
+	struct io_uring_sqe *sqe;
+
+	sqe = io_uring_get_sqe(ring);
+
+	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, sockfd, NULL, len, 0);
+	sqe->user_data = 2;
+}
+
 static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
 {
 	if (cqe->res < 0)
@@ -204,7 +217,10 @@ static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
 		error(1, 0, "Unexpected second connection");
 
 	connfd = cqe->res;
-	add_recvzc(ring, connfd);
+	if (cfg_oneshot)
+		add_recvzc_oneshot(ring, connfd, PAGE_SIZE);
+	else
+		add_recvzc(ring, connfd);
 }
 
 static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
@@ -218,7 +234,7 @@ static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
 	ssize_t n;
 	int i;
 
-	if (cqe->res == 0 && cqe->flags == 0) {
+	if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs == 0) {
 		stop = true;
 		return;
 	}
@@ -226,8 +242,14 @@ static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
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
 
@@ -237,7 +259,7 @@ static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
 
 	for (i = 0; i < n; i++) {
 		if (*(data + i) != payload[(received + i)])
-			error(1, 0, "payload mismatch");
+			error(1, 0, "payload mismatch at ", i);
 	}
 	received += n;
 
@@ -313,7 +335,7 @@ static void run_server(void)
 
 static void run_client(void)
 {
-	ssize_t to_send = SEND_SIZE;
+	ssize_t to_send = cfg_send_size;
 	ssize_t sent = 0;
 	ssize_t chunk, res;
 	int fd;
@@ -360,7 +382,7 @@ static void parse_opts(int argc, char **argv)
 		usage(argv[0]);
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46sch:p:l:i:q:")) != -1) {
+	while ((c = getopt(argc, argv, "sch:p:l:i:q:o:z:")) != -1) {
 		switch (c) {
 		case 's':
 			if (cfg_client)
@@ -387,6 +409,14 @@ static void parse_opts(int argc, char **argv)
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


