Return-Path: <io-uring+bounces-11567-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D98B0D08F0C
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 12:35:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CDC383101220
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 11:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7E535CB86;
	Fri,  9 Jan 2026 11:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h+0hgalO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171033590A5
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 11:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767958163; cv=none; b=TN3ujZ0nzkhvAuBz/gnz1+WYJZn3qwLWBVUGnJDW0kRyhHlOqymPZQMhVSRkXPlOlVeAm1lRKgCw2ditjgwjq57pQs0MoLr8421GHHI62ExwEIxfkzUpJ/Q51Rg7jvNpZXkKOdZKKViqmRDypvG/UdurTZGyoDF6YuPV4fminSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767958163; c=relaxed/simple;
	bh=/jxCrpK8l6glGcqt49LNeHrXzbo3WZk9EY0AmmIwENo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=by+Mg5MD5esPeJYVtmdq+qT4m1zthfFYs3xsVpQlodyP37+6WLKwKKTgEOyQfCKgBMgHdUknEyOQtPggVJ3Y/ZnCJlttbwFebNg2zgMSF7uA/pjWCpSyAFckrFqFB1wCt13LWXDRaSdfuuESAgj/DidkSA9sIay/bv1RwEPI5qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h+0hgalO; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47d493a9b96so24568435e9.1
        for <io-uring@vger.kernel.org>; Fri, 09 Jan 2026 03:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767958155; x=1768562955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJRC4dPidxMIa9vqar4Y3LK2OFHt6WzESXNCWKhLD0s=;
        b=h+0hgalOLvkaiVreIVlWnFsD7FLxMGxgYjcECpRiFlLppOrRDuSOin4WdyW83RlYK4
         4SeCVO9+TvbdniM3n7n0RV0JHTKrPFphJJC/dXsDoV5NsL898yYMH8Q0r/E2fJxAgbjy
         qxA2+cAt2tmQfgW5WfGwgmoSZyd5R6tpVnqkwEEee3MTFFUKoBHdtId+pxPW0w4F2J+q
         RGjZIyzmTENj1Qa1QkhlDr6Z25G7VOwQvrtv94NFpD80LN0YYXp0HUBO8PFU9YA5kGDG
         y45NLgx/HYPMjNarPZ3hyLahLByhGvYD1964kMaDn/T56iD0aOJURD1NMaeNn+UzI3tg
         6tQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767958155; x=1768562955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJRC4dPidxMIa9vqar4Y3LK2OFHt6WzESXNCWKhLD0s=;
        b=RSPsYNi/qa02sHjksL8L2IHLhTshoHIRbd1eJEycFccXDEifIZOkYFJunHY45CdH7Z
         vI+VarE8Caq0iWbTlpJ1RUbScxMw/QEJ/m3aUx/8iWVV0SAnK7j1TqFVCLCBcCpC+tPt
         bbb4OYNrYNSuMFRI5yVnfJ2MO/zd3ZZFYIOVcCEBESvl/1vT+RZ+lWg9WN/EK806iNQ8
         aEVrJU3lPE9s+H8O+kGl1PflY3y90a3knl+h+RPmk/qTKDUcxLlfA662SL9XRm7B7jW6
         rF4Ccvz0trQVsGjXNksdgfWENt/5m6FpCCzR/3BrsNhS1ZyLAkgT/Bo9uqQHPm3L40xq
         c3fg==
X-Forwarded-Encrypted: i=1; AJvYcCWB3BR7oKx9Gy2oUSx6BgOYC/QoLktJP5qurIEmlJdbTJAcw43rCaMpWIaNBcL9L+WxzLZUx1Ea+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa1J7Ns8hd+O0+FSLYksiH1R5laKCcGz65OR7qA+M0HJhe2d8h
	+eJ5oStyEI2IRS6Efgv3fXBiJbOjsMpMAG1u5vfyD11ELl8MTJwG6F88
X-Gm-Gg: AY/fxX6xlehnqTZtgJkv/rLu/sNS+ZeKx0fiIWCk0xfzS8IpEg4YL/9I8E93co7j4tG
	fW0uqo6RoqDeU/5vdkKb8Ax7CtXMbVJ1dHyQVMa8p3+xwPnkYMaoAfRVkp3lQcFtLM8NjXJW+Qo
	et8XDjzqlg7foyzP/a7S6/F1Es+IWX2B90UWrL4IaHkdfOh2fLsU9vW3pIUZcm51HnCUWGw+a6c
	mA39+0Lf79LR8OYw5Kzw43Z0RGAtQg18K4dXwBCAXQixzmVCLFGD4FYOUByrkPDpeFMs7+gw3Tx
	ELsYtWfKV3oez96PIBDiDtGnHcohufAEn2D/VPoP3n2Pf7Ngy0K8Ni5drfnwcgMg4En4/+zfFA1
	2FFcFBbDpHED+TfEy4WbseeTOIZ3U4rOqFmEVSmEAHIa79WeYLwPr7dbhC691j8sFtOSSp21UYT
	2tijke469SrLOTjvB9Jp1w052GPVt5nIjBdU6Z2XEzpzydvBhEAy9fr/TbP+MbKwOu4zSBYQ==
X-Google-Smtp-Source: AGHT+IFP8GKWdVbTR4kP2eSXOtP3B21YVVOqcaO/WazPjd6IKdKiRPGp9LwPNLHkHaCIs9RrvfXe8w==
X-Received: by 2002:a05:600c:8b57:b0:477:54f9:6ac2 with SMTP id 5b1f17b1804b1-47d849bdfa7mr100045195e9.0.1767958154803;
        Fri, 09 Jan 2026 03:29:14 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:69b5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d8636c610sm60056985e9.0.2026.01.09.03.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 03:29:14 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <shuah@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Ankit Garg <nktgrg@google.com>,
	Tim Hostetler <thostet@google.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ziwei Xiao <ziweixiao@google.com>,
	John Fraker <jfraker@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Joe Damato <joe@dama.to>,
	Mina Almasry <almasrymina@google.com>,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>,
	Yue Haibing <yuehaibing@huawei.com>,
	Haiyue Wang <haiyuewa@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <horms@kernel.org>,
	Vishwanath Seshagiri <vishs@fb.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	dtatulea@nvidia.com,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v8 8/9] selftests: iou-zcrx: test large chunk sizes
Date: Fri,  9 Jan 2026 11:28:47 +0000
Message-ID: <bb51fe4e6f30b0bd2335bfc665dc3e30b8de7acb.1767819709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767819709.git.asml.silence@gmail.com>
References: <cover.1767819709.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test using large chunks for zcrx memory area.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 .../selftests/drivers/net/hw/iou-zcrx.c       | 72 +++++++++++++++----
 .../selftests/drivers/net/hw/iou-zcrx.py      | 37 ++++++++++
 2 files changed, 97 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
index 62456df947bc..0a19b573f4f5 100644
--- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
@@ -12,6 +12,7 @@
 #include <unistd.h>
 
 #include <arpa/inet.h>
+#include <linux/mman.h>
 #include <linux/errqueue.h>
 #include <linux/if_packet.h>
 #include <linux/ipv6.h>
@@ -37,6 +38,23 @@
 
 #include <liburing.h>
 
+#define SKIP_CODE	42
+
+struct t_io_uring_zcrx_ifq_reg {
+	__u32	if_idx;
+	__u32	if_rxq;
+	__u32	rq_entries;
+	__u32	flags;
+
+	__u64	area_ptr; /* pointer to struct io_uring_zcrx_area_reg */
+	__u64	region_ptr; /* struct io_uring_region_desc * */
+
+	struct io_uring_zcrx_offsets offsets;
+	__u32	zcrx_id;
+	__u32	rx_buf_len;
+	__u64	__resv[3];
+};
+
 static long page_size;
 #define AREA_SIZE (8192 * page_size)
 #define SEND_SIZE (512 * 4096)
@@ -65,6 +83,8 @@ static bool cfg_oneshot;
 static int cfg_oneshot_recvs;
 static int cfg_send_size = SEND_SIZE;
 static struct sockaddr_in6 cfg_addr;
+static unsigned cfg_rx_buf_len;
+static bool cfg_dry_run;
 
 static char *payload;
 static void *area_ptr;
@@ -128,14 +148,28 @@ static void setup_zcrx(struct io_uring *ring)
 	if (!ifindex)
 		error(1, 0, "bad interface name: %s", cfg_ifname);
 
-	area_ptr = mmap(NULL,
-			AREA_SIZE,
-			PROT_READ | PROT_WRITE,
-			MAP_ANONYMOUS | MAP_PRIVATE,
-			0,
-			0);
-	if (area_ptr == MAP_FAILED)
-		error(1, 0, "mmap(): zero copy area");
+	if (cfg_rx_buf_len && cfg_rx_buf_len != page_size) {
+		area_ptr = mmap(NULL,
+				AREA_SIZE,
+				PROT_READ | PROT_WRITE,
+				MAP_ANONYMOUS | MAP_PRIVATE |
+				MAP_HUGETLB | MAP_HUGE_2MB,
+				-1,
+				0);
+		if (area_ptr == MAP_FAILED) {
+			printf("Can't allocate huge pages\n");
+			exit(SKIP_CODE);
+		}
+	} else {
+		area_ptr = mmap(NULL,
+				AREA_SIZE,
+				PROT_READ | PROT_WRITE,
+				MAP_ANONYMOUS | MAP_PRIVATE,
+				0,
+				0);
+		if (area_ptr == MAP_FAILED)
+			error(1, 0, "mmap(): zero copy area");
+	}
 
 	ring_size = get_refill_ring_size(rq_entries);
 	ring_ptr = mmap(NULL,
@@ -157,17 +191,23 @@ static void setup_zcrx(struct io_uring *ring)
 		.flags = 0,
 	};
 
-	struct io_uring_zcrx_ifq_reg reg = {
+	struct t_io_uring_zcrx_ifq_reg reg = {
 		.if_idx = ifindex,
 		.if_rxq = cfg_queue_id,
 		.rq_entries = rq_entries,
 		.area_ptr = (__u64)(unsigned long)&area_reg,
 		.region_ptr = (__u64)(unsigned long)&region_reg,
+		.rx_buf_len = cfg_rx_buf_len,
 	};
 
-	ret = io_uring_register_ifq(ring, &reg);
-	if (ret)
+	ret = io_uring_register_ifq(ring, (void *)&reg);
+	if (cfg_rx_buf_len && (ret == -EINVAL || ret == -EOPNOTSUPP ||
+			       ret == -ERANGE)) {
+		printf("Large chunks are not supported %i\n", ret);
+		exit(SKIP_CODE);
+	} else if (ret) {
 		error(1, 0, "io_uring_register_ifq(): %d", ret);
+	}
 
 	rq_ring.khead = (unsigned int *)((char *)ring_ptr + reg.offsets.head);
 	rq_ring.ktail = (unsigned int *)((char *)ring_ptr + reg.offsets.tail);
@@ -323,6 +363,8 @@ static void run_server(void)
 	io_uring_queue_init(512, &ring, flags);
 
 	setup_zcrx(&ring);
+	if (cfg_dry_run)
+		return;
 
 	add_accept(&ring, fd);
 
@@ -383,7 +425,7 @@ static void parse_opts(int argc, char **argv)
 		usage(argv[0]);
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "sch:p:l:i:q:o:z:")) != -1) {
+	while ((c = getopt(argc, argv, "sch:p:l:i:q:o:z:x:d")) != -1) {
 		switch (c) {
 		case 's':
 			if (cfg_client)
@@ -418,6 +460,12 @@ static void parse_opts(int argc, char **argv)
 		case 'z':
 			cfg_send_size = strtoul(optarg, NULL, 0);
 			break;
+		case 'x':
+			cfg_rx_buf_len = page_size * strtoul(optarg, NULL, 0);
+			break;
+		case 'd':
+			cfg_dry_run = true;
+			break;
 		}
 	}
 
diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
index 712c806508b5..83061b27f2f2 100755
--- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
@@ -7,6 +7,7 @@ from lib.py import ksft_run, ksft_exit, KsftSkipEx
 from lib.py import NetDrvEpEnv
 from lib.py import bkg, cmd, defer, ethtool, rand_port, wait_port_listen
 
+SKIP_CODE = 42
 
 def _get_current_settings(cfg):
     output = ethtool(f"-g {cfg.ifname}", json=True)[0]
@@ -132,6 +133,42 @@ def test_zcrx_rss(cfg) -> None:
         cmd(tx_cmd, host=cfg.remote)
 
 
+def test_zcrx_large_chunks(cfg) -> None:
+    cfg.require_ipver('6')
+
+    combined_chans = _get_combined_channels(cfg)
+    if combined_chans < 2:
+        raise KsftSkipEx('at least 2 combined channels required')
+    (rx_ring, hds_thresh) = _get_current_settings(cfg)
+    port = rand_port()
+
+    ethtool(f"-G {cfg.ifname} tcp-data-split on")
+    defer(ethtool, f"-G {cfg.ifname} tcp-data-split auto")
+
+    ethtool(f"-G {cfg.ifname} hds-thresh 0")
+    defer(ethtool, f"-G {cfg.ifname} hds-thresh {hds_thresh}")
+
+    ethtool(f"-G {cfg.ifname} rx 64")
+    defer(ethtool, f"-G {cfg.ifname} rx {rx_ring}")
+
+    ethtool(f"-X {cfg.ifname} equal {combined_chans - 1}")
+    defer(ethtool, f"-X {cfg.ifname} default")
+
+    flow_rule_id = _set_flow_rule(cfg, port, combined_chans - 1)
+    defer(ethtool, f"-N {cfg.ifname} delete {flow_rule_id}")
+
+    rx_cmd = f"{cfg.bin_local} -s -p {port} -i {cfg.ifname} -q {combined_chans - 1} -x 2"
+    tx_cmd = f"{cfg.bin_remote} -c -h {cfg.addr_v['6']} -p {port} -l 12840"
+
+    probe = cmd(rx_cmd + " -d", fail=False)
+    if probe.ret == SKIP_CODE:
+        raise KsftSkipEx(probe.stdout)
+
+    with bkg(rx_cmd, exit_wait=True):
+        wait_port_listen(port, proto="tcp")
+        cmd(tx_cmd, host=cfg.remote)
+
+
 def main() -> None:
     with NetDrvEpEnv(__file__) as cfg:
         cfg.bin_local = path.abspath(path.dirname(__file__) + "/../../../drivers/net/hw/iou-zcrx")
-- 
2.52.0


