Return-Path: <io-uring+bounces-13119-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WFHqFmWy6GmIOwIAu9opvQ
	(envelope-from <io-uring+bounces-13119-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:35:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AECFA445729
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4465C30849D2
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 11:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5A743D16E2;
	Wed, 22 Apr 2026 11:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="FeyrDftL"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F5534D39B;
	Wed, 22 Apr 2026 11:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776857424; cv=none; b=jNty3oaGvDY9bPs36XeE8qdy0lJv5Rx4yWujf71a0+tO9PFF98fnATOH8DW5OylmKvCswY1ul6v6gF6/xS+IhA/LA44H7oSGdj1UO9qb48Lbq+qko3/o3/Vd8fDndYesr68oD+lfSKpdxgadHjViTWExX0DarLWj4VJc83XISxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776857424; c=relaxed/simple;
	bh=jlWcXL5qFGJMeIaua8rhnaRefnti71TwgpOwqoEITQ4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=om6htKz18ojuEYay3XjngJxxhWNBRwo2doJ4roxYqmjORngeEa7QUESLIpgz1LHZRXtUyzpLh2P6AJOkB7FirJCYMFQw0VEd2OyvigZ2Zuutao2vQS71dxu5bjwiWBMzUW9/lnw4YlXRuEs16btrkUCOG9Jc+cwaLWzf7pWv6wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=FeyrDftL; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIkchr624972;
	Wed, 22 Apr 2026 04:30:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=3QXOcOD0wueZJZFrD8NqKljSbt85OuvLWwPFpEKe4XE=; b=FeyrDftLa3Q9
	osIc0JT7SENKwrdPLssv0+Vude44VQwTGf0E1U9H9FWRJ34+pwnWuei0Id/dIou7
	WmtUZQzK6NJtvEFeCzheBa4Lf6JrvYteLxCgs9rnvH5SweItBih78rezgVhDzWnF
	vIetDuIcVVqGYtbW9jBZBcA2gHrXJDYpLBlRZw37uWe73gHXDMitgCKrhG9cy26l
	u9FS5pDuX1buIeGHl7Xie6ykJsNAMgug/Bz5Yj74PMNmGWP2DBASGkvp9EqlLQiq
	bHXBBo4tPW+2vjI0IXMGosKDJAlJS3vif8BUd1B7I4xd2lP7HRn5FIWKdgPa8o/y
	rVxnT3EKmg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dpepa4rd4-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 22 Apr 2026 04:30:14 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Wed, 22 Apr
 2026 11:30:00 +0000
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
To: <io-uring@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>,
        "Jens
 Axboe" <axboe@kernel.dk>
CC: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        "David S.
 Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Simon Horman
	<horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan
	<skhan@linuxfoundation.org>,
        Vishwanath Seshagiri <vishs@fb.com>
Subject: [PATCH 5/5] selftests: iou-zcrx: add notification and stats test for zcrx
Date: Wed, 22 Apr 2026 04:25:16 -0700
Message-ID: <20260422112522.3316660-6-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260422112522.3316660-1-cleger@meta.com>
References: <20260422112522.3316660-1-cleger@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: qJ21zn8NynDKXKjQrPJkjScQLJgSedUH
X-Authority-Analysis: v=2.4 cv=KMxqylFo c=1 sm=1 tr=0 ts=69e8b146 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=jCddH8ec0KUNCymVuxII:22
 a=VabnemYjAAAA:8 a=hM4E8hCzYzPdoCAyIpQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDExMCBTYWx0ZWRfX3AT1DPJviY6c
 km2XnOLcwJxoS6NfMdyonLJAjPrFt2P2x1/5QAMqeDeY/3DO8Zfqu5gElbhqPWMNfu/Qcm0wo7j
 42nV9U39wKxfv8xK0kaDo4FUoBmfwL5L/pboA/g91zB+99Nd6r1DlpjChmoVrJG+j0Y9G/I8jeO
 N1iRfBcKNXv43g+Oj9M0hn7HpHubWm81Ebe19vIj3C7OYlihfEyBnUegVEe0N7mzLZhX+Er55fd
 ErCrDOOqqhLVXR0Pj2M6VUF362rdJGARd9G514rXBLEzex18IzhV/XAMCAc0ZFVUoRpAVFXIy7t
 j2VOsWj5fyp6xDm0rRfbDi03oMeZJlqAljmU6EcurgZnsE1gFEbXGH9iB3hRc9mBMo9fTPdjeL3
 yX5VXfXfloHJncqRfXHeN9qJdA2gNCd4OoqOtSDw1mlo6BIow917cdaLcfcoVlWW/J2EIcwbW3s
 CtQbFqjwc5TmnFO6zxQ==
X-Proofpoint-GUID: qJ21zn8NynDKXKjQrPJkjScQLJgSedUH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Spamd-Result: default: False [0.96 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.63)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13119-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,meta.com:dkim,meta.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AECFA445729
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a selftest to verify that ZCRX notification are properly delivered
to userspace and that the shared-memory notification stats (copy_count,
copy_bytes) are correctly incremented when zero-copy RX falls back to
copying or when it runs out of buffers.

The test registers a notification descriptor during
IORING_REGISTER_ZCRX_IFQ with a stats region placed after the refill
queue entries. A new -n flag verifies that the copy fallback is
triggered and -b/-a flags allows to check for out of buffer
notification.

To reliably trigger copy fallback, the Python test uses a new
single_no_flow() setup variant that configures tcp-data-split and RSS
but without ethtool flow rule. Without flow steering, traffic arrives
on non-zcrx queues as regular pages, forcing the kernel copy-fallback
path in io_zcrx_copy_frag().

Out-of-buffer notification is verified by using a smaller receive area
and by avoiding recycling the buffers so that the kernel runs out of
buffer quickly.

Signed-off-by: Clément Léger <cleger@meta.com>
---
 .../selftests/drivers/net/hw/iou-zcrx.c       | 112 ++++++++++++++++--
 .../selftests/drivers/net/hw/iou-zcrx.py      |  49 +++++++-
 2 files changed, 149 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
index 240d13dbc54e..3c95e6460c24 100644
--- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
@@ -52,7 +52,27 @@ struct t_io_uring_zcrx_ifq_reg {
 	struct io_uring_zcrx_offsets offsets;
 	__u32	zcrx_id;
 	__u32	rx_buf_len;
-	__u64	__resv[3];
+	__u64	notif_desc;
+	__u64	__resv[2];
+};
+
+#define ZCRX_NOTIF_NO_BUFFERS		(1 << 0)
+#define ZCRX_NOTIF_COPY			(1 << 1)
+#define ZCRX_NOTIF_DESC_FLAG_STATS	(1 << 0)
+
+#define NOTIF_USER_DATA			3
+
+struct t_zcrx_notification_desc {
+	__u64	user_data;
+	__u32	type_mask;
+	__u32	flags;
+	__u64	stats_offset;
+	__u64	__resv2[9];
+};
+
+struct t_io_uring_zcrx_notif_stats {
+	__u64	copy_count;
+	__u64	copy_bytes;
 };
 
 static long page_size;
@@ -84,7 +104,10 @@ static int cfg_oneshot_recvs;
 static int cfg_send_size = SEND_SIZE;
 static struct sockaddr_in6 cfg_addr;
 static unsigned int cfg_rx_buf_len;
+static size_t cfg_area_size;
 static bool cfg_dry_run;
+static bool cfg_copy_fallback;
+static bool cfg_no_buffers;
 
 static char *payload;
 static void *area_ptr;
@@ -95,6 +118,8 @@ static unsigned long area_token;
 static int connfd;
 static bool stop;
 static size_t received;
+static unsigned int notif_received_mask;
+static size_t notif_stats_offset;
 
 static unsigned long gettimeofday_ms(void)
 {
@@ -142,6 +167,7 @@ static void setup_zcrx(struct io_uring *ring)
 {
 	unsigned int ifindex;
 	unsigned int rq_entries = 4096;
+	size_t area_size = cfg_area_size ? cfg_area_size : AREA_SIZE;
 	int ret;
 
 	ifindex = if_nametoindex(cfg_ifname);
@@ -150,7 +176,7 @@ static void setup_zcrx(struct io_uring *ring)
 
 	if (cfg_rx_buf_len && cfg_rx_buf_len != page_size) {
 		area_ptr = mmap(NULL,
-				AREA_SIZE,
+				area_size,
 				PROT_READ | PROT_WRITE,
 				MAP_ANONYMOUS | MAP_PRIVATE |
 				MAP_HUGETLB | MAP_HUGE_2MB,
@@ -162,7 +188,7 @@ static void setup_zcrx(struct io_uring *ring)
 		}
 	} else {
 		area_ptr = mmap(NULL,
-				AREA_SIZE,
+				area_size,
 				PROT_READ | PROT_WRITE,
 				MAP_ANONYMOUS | MAP_PRIVATE,
 				0,
@@ -172,6 +198,12 @@ static void setup_zcrx(struct io_uring *ring)
 	}
 
 	ring_size = get_refill_ring_size(rq_entries);
+
+	if (cfg_copy_fallback) {
+		notif_stats_offset = ring_size;
+		ring_size += ALIGN_UP(sizeof(struct t_io_uring_zcrx_notif_stats), page_size);
+	}
+
 	ring_ptr = mmap(NULL,
 			ring_size,
 			PROT_READ | PROT_WRITE,
@@ -187,10 +219,11 @@ static void setup_zcrx(struct io_uring *ring)
 
 	struct io_uring_zcrx_area_reg area_reg = {
 		.addr = (__u64)(unsigned long)area_ptr,
-		.len = AREA_SIZE,
+		.len = area_size,
 		.flags = 0,
 	};
 
+	struct t_zcrx_notification_desc notif_desc;
 	struct t_io_uring_zcrx_ifq_reg reg = {
 		.if_idx = ifindex,
 		.if_rxq = cfg_queue_id,
@@ -200,11 +233,32 @@ static void setup_zcrx(struct io_uring *ring)
 		.rx_buf_len = cfg_rx_buf_len,
 	};
 
+	if (cfg_copy_fallback || cfg_no_buffers) {
+		__u32 type_mask = 0;
+
+		if (cfg_copy_fallback)
+			type_mask = ZCRX_NOTIF_COPY;
+		if (cfg_no_buffers)
+			type_mask = ZCRX_NOTIF_NO_BUFFERS;
+
+		memset(&notif_desc, 0, sizeof(notif_desc));
+		notif_desc.user_data = NOTIF_USER_DATA;
+		notif_desc.type_mask = type_mask;
+		if (cfg_copy_fallback) {
+			notif_desc.flags = ZCRX_NOTIF_DESC_FLAG_STATS;
+			notif_desc.stats_offset = notif_stats_offset;
+		}
+		reg.notif_desc = (__u64)(unsigned long)&notif_desc;
+	}
+
 	ret = io_uring_register_ifq(ring, (void *)&reg);
 	if (cfg_rx_buf_len && (ret == -EINVAL || ret == -EOPNOTSUPP ||
 			       ret == -ERANGE)) {
 		printf("Large chunks are not supported %i\n", ret);
 		exit(SKIP_CODE);
+	} else if ((cfg_copy_fallback || cfg_no_buffers) && ret == -EINVAL) {
+		printf("Notifications not supported %i\n", ret);
+		exit(SKIP_CODE);
 	} else if (ret) {
 		error(1, 0, "io_uring_register_ifq(): %d", ret);
 	}
@@ -304,10 +358,13 @@ static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
 	}
 	received += n;
 
-	rqe = &rq_ring.rqes[(rq_ring.rq_tail & rq_mask)];
-	rqe->off = (rcqe->off & ~IORING_ZCRX_AREA_MASK) | area_token;
-	rqe->len = cqe->res;
-	io_uring_smp_store_release(rq_ring.ktail, ++rq_ring.rq_tail);
+	/* Skip ring refill so that we ran out of buffers quickly */
+	if (!cfg_no_buffers) {
+		rqe = &rq_ring.rqes[(rq_ring.rq_tail & rq_mask)];
+		rqe->off = (rcqe->off & ~IORING_ZCRX_AREA_MASK) | area_token;
+		rqe->len = cqe->res;
+		io_uring_smp_store_release(rq_ring.ktail, ++rq_ring.rq_tail);
+	}
 }
 
 static void server_loop(struct io_uring *ring)
@@ -324,8 +381,15 @@ static void server_loop(struct io_uring *ring)
 			process_accept(ring, cqe);
 		else if (cqe->user_data == 2)
 			process_recvzc(ring, cqe);
-		else
+		else if ((cfg_copy_fallback || cfg_no_buffers) &&
+			 cqe->user_data == NOTIF_USER_DATA) {
+			notif_received_mask |= cqe->res;
+			if (cfg_no_buffers &&
+			    (cqe->res & ZCRX_NOTIF_NO_BUFFERS))
+				stop = true;
+		} else {
 			error(1, 0, "unknown cqe");
+		}
 		count++;
 	}
 	io_uring_cq_advance(ring, count);
@@ -374,6 +438,23 @@ static void run_server(void)
 
 	if (!stop)
 		error(1, 0, "test failed\n");
+
+	if (cfg_copy_fallback) {
+		struct t_io_uring_zcrx_notif_stats *stats =
+			(void *)((char *)ring_ptr + notif_stats_offset);
+
+		if (!(notif_received_mask & ZCRX_NOTIF_COPY))
+			error(1, 0, "expected copy fallback notification");
+		if (!IO_URING_READ_ONCE(stats->copy_count))
+			error(1, 0, "expected copy_count > 0");
+		if (!IO_URING_READ_ONCE(stats->copy_bytes))
+			error(1, 0, "expected copy_bytes > 0");
+	}
+
+	if (cfg_no_buffers) {
+		if (!(notif_received_mask & ZCRX_NOTIF_NO_BUFFERS))
+			error(1, 0, "expected no-buffers notification");
+	}
 }
 
 static void run_client(void)
@@ -425,7 +506,7 @@ static void parse_opts(int argc, char **argv)
 		usage(argv[0]);
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "sch:p:l:i:q:o:z:x:d")) != -1) {
+	while ((c = getopt(argc, argv, "sch:p:l:i:q:o:z:x:a:dnb")) != -1) {
 		switch (c) {
 		case 's':
 			if (cfg_client)
@@ -466,8 +547,19 @@ static void parse_opts(int argc, char **argv)
 		case 'd':
 			cfg_dry_run = true;
 			break;
+		case 'n':
+			cfg_copy_fallback = true;
+			break;
+		case 'b':
+			cfg_no_buffers = true;
+			break;
+		case 'a':
+			cfg_area_size = strtoul(optarg, NULL, 0) * page_size;
+			break;
 		}
 	}
+	if (cfg_copy_fallback && cfg_no_buffers)
+		error(1, 0, "Pass one of -n or -b");
 
 	if (cfg_server && addr)
 		error(1, 0, "Receiver cannot have -h specified");
diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
index e81724cb5542..f7f1cbff5959 100755
--- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
@@ -41,7 +41,9 @@ def set_flow_rule_rss(cfg, rss_ctx_id):
     return int(values)
 
 
-def single(cfg):
+def single_no_flow(cfg):
+    """Like single() but without a flow rule."""
+
     channels = cfg.ethnl.channels_get({'header': {'dev-index': cfg.ifindex}})
     channels = channels['combined-count']
     if channels < 2:
@@ -65,6 +67,9 @@ def single(cfg):
     ethtool(f"-X {cfg.ifname} equal {cfg.target}")
     defer(ethtool, f"-X {cfg.ifname} default")
 
+def single(cfg):
+    single_no_flow(cfg)
+
     flow_rule_id = set_flow_rule(cfg)
     defer(ethtool, f"-N {cfg.ifname} delete {flow_rule_id}")
 
@@ -130,6 +135,26 @@ def test_zcrx_oneshot(cfg, setup) -> None:
         cmd(tx_cmd, host=cfg.remote)
 
 
+@ksft_variants([
+    KsftNamedVariant("single", single_no_flow),
+])
+def test_zcrx_notif(cfg, setup) -> None:
+    """Test zcrx copy fallback notification.
+
+    Omits the flow rule so traffic arrives on non-zcrx queues as regular
+    pages, forcing the kernel copy-fallback path. Asserts that the
+    ZCRX_NOTIF_COPY notification CQE is delivered."""
+
+    cfg.require_ipver('6')
+
+    setup(cfg)
+    rx_cmd = f"{cfg.bin_local} -s -p {cfg.port} -i {cfg.ifname} -q {cfg.target} -n"
+    tx_cmd = f"{cfg.bin_remote} -c -h {cfg.addr_v['6']} -p {cfg.port} -l 12840"
+    with bkg(rx_cmd, exit_wait=True):
+        wait_port_listen(cfg.port, proto="tcp")
+        cmd(tx_cmd, host=cfg.remote)
+
+
 def test_zcrx_large_chunks(cfg) -> None:
     """Test zcrx with large buffer chunks."""
 
@@ -157,6 +182,25 @@ def test_zcrx_large_chunks(cfg) -> None:
         cmd(tx_cmd, host=cfg.remote)
 
 
+@ksft_variants([
+    KsftNamedVariant("single", single),
+])
+def test_zcrx_notif_no_buffers(cfg, setup) -> None:
+    """Test zcrx out-of-buffer notification.
+
+    Skips buffer refill so the pool is quickly exhausted, triggering
+    a ZCRX_NOTIF_NO_BUFFERS notification CQE."""
+
+    cfg.require_ipver('6')
+
+    setup(cfg)
+    rx_cmd = f"{cfg.bin_local} -s -p {cfg.port} -i {cfg.ifname} -q {cfg.target} -b -a 64"
+    tx_cmd = f"{cfg.bin_remote} -c -h {cfg.addr_v['6']} -p {cfg.port} -l 12840"
+    with bkg(rx_cmd, exit_wait=True):
+        wait_port_listen(cfg.port, proto="tcp")
+        cmd(tx_cmd, host=cfg.remote, fail=False)
+
+
 def main() -> None:
     with NetDrvEpEnv(__file__) as cfg:
         cfg.bin_local = path.abspath(path.dirname(__file__) + "/../../../drivers/net/hw/iou-zcrx")
@@ -166,7 +210,8 @@ def main() -> None:
         cfg.netnl = NetdevFamily()
         cfg.port = rand_port()
         ksft_run(globs=globals(), cases=[test_zcrx, test_zcrx_oneshot,
-                                        test_zcrx_large_chunks], args=(cfg, ))
+                                        test_zcrx_large_chunks, test_zcrx_notif,
+                                        test_zcrx_notif_no_buffers], args=(cfg, ))
     ksft_exit()
 
 
-- 
2.52.0


