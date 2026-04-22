Return-Path: <io-uring+bounces-13126-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4OZYCOTV6GklQQIAu9opvQ
	(envelope-from <io-uring+bounces-13126-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 16:06:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 680D04470C9
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 16:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F05C30134A0
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2DDA3EAC8D;
	Wed, 22 Apr 2026 13:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="o3faiEWO"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A513E9F74
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 13:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776866325; cv=none; b=ql40nSsHrxhuWsXnNo4n4ep8IQ9bCkNnPM1R5gbJunD7667Jjx5lS+tLVmeqKNfPPfH7UbK74tkMmbb2D0LE82l/fGx1e/50IIXMrwYX4mIAQh64B5aTpmz5y9tqtclu713EY7enRM+FSucFeQF/3aTPPFNYmi3v9OgLGkH0Q80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776866325; c=relaxed/simple;
	bh=r2karF91b+J6HZPrIpIg7beRF717ENfJzcDlLPDD7rM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rZzCrDTXHHD/YoxAHN2c7S2TYW44nMDQfjN/kp6aSy4zRIPfSuynB2DMj1r1S8M9dwe7njx5srN3WUkc46ZUURZ473BK1KgBz2xuA93Dx3w9Pnedm8b8pbJ3uAwEQer/328OjtUA1tZHNK+HE1IKRZNsBVPciRSV8AmtD9wJT7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=o3faiEWO; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63M3iRAw878937;
	Wed, 22 Apr 2026 06:58:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=xVVWw1rsvsTat35PjgdmSWTpnIVELWtZPzqaNYjmmnY=; b=o3faiEWOfcP+
	iIDlSPOKcptf7IZR0Im3VXSGNvL7TET6XD/PZ6zNsGnkHNgLunphbjjIgRgDQbCr
	bMws+mhs+bGp9HbrXRL2V2+Ez1qH5OMTnxx6AyIZpAoQehGpb93759RNyh7tmGHv
	pVUzcq2SDy2pG/CKt+lJuG1q8Bv7cTtlEJA4iqZrVa16C4XhsYXyRcaHkIqHg0T+
	Vy0fBIqoHuY2sFhGX0eLkm0bdV4+O5HsnZSFZdtE90z0k7sb9RG8LlGGFshbTjLx
	KjCje4HE4nEeO3JMGKGST54n3PrTg/ukBjR+VyFpzAoktr3DNUvYHp8zlDuLoSVN
	lryeBMMzUA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dpeph5d9r-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 22 Apr 2026 06:58:43 -0700 (PDT)
Received: from localhost (2620:10d:c085:108::4) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Wed, 22 Apr
 2026 13:58:41 +0000
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
To: <io-uring@vger.kernel.org>
CC: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
        Jens Axboe
	<axboe@kernel.dk>
Subject: [PATCH liburing 3/3] examples/zcrx: add notification support
Date: Wed, 22 Apr 2026 06:57:22 -0700
Message-ID: <20260422135724.528518-4-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260422135724.528518-1-cleger@meta.com>
References: <20260422135724.528518-1-cleger@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ZOe9yFjC2TOe4I_Fj-1fLf5EEE30aHks
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDEzNSBTYWx0ZWRfXz4nwdAzkcXFv
 Gq31Rhr4zZvcvAkLOjczTm5EPkhXEEKbGYN9RmF11sL8jJgnWM6a779DGRaOR7PpjNsA+MfnyhM
 tXru03eyjNQ+tTWLwuL90PKP5LD/UyzVRq5lheH21TwjpcXcQHpalc2qjVe0/PxSHT9xfblxFen
 9720Z+0UOrSwfYGWU7jt64me8hxcqr6j3t7O9lTf8jUWb0BitRwx+7Pi5AJd1koRRWFsrLTZp7d
 0cl/HIXkwwCUQMLNiCJdakoum3HXkkN9Qx6CALDDZLI82XccWVVtlZI6Erw1P70EiGaLaMT6zng
 xRvS3WC1tEfZi9q0rcs94SEK241PmqyCm1kdeRGkS1h9ZZMm49LzyUttCJbuH3trlC2EY6Q6qKv
 oV84RRjFRPSaX/L/ZXkCjO3dgHr0vXmo87jkxzsh0j4Pgjcqqk/r6gg2zS5yCRq288k8XrNR+WG
 nIIj1KBimgjnxqGgOgQ==
X-Proofpoint-GUID: ZOe9yFjC2TOe4I_Fj-1fLf5EEE30aHks
X-Authority-Analysis: v=2.4 cv=ZLjnX37b c=1 sm=1 tr=0 ts=69e8d413 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=M51BFTxLslgA:10 a=sWKEhP36mHoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=PAz_-FQ8hEVmOPYdF0yf:22
 a=VabnemYjAAAA:8 a=QvjoEvHx9T2nUATbkMQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Spamd-Result: default: False [-0.33 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.83)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13126-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[6];
	MAILSPIKE_FAIL(0.00)[172.234.253.10:query timed out];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 680D04470C9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add support to register notifications and display stats when
notifications are received. This allows to provide an example of how to
register and configure notifications and stats support. If an error is
encountered while running, then the notification type will be display
along stat counter if associated to the notification (ie copy fallback).

Notification support is probe before zcrx setup and enabled by default
if detected.

Signed-off-by: Clément Léger <cleger@meta.com>
---
 examples/zcrx.c | 109 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index b55b07ce..537c62ad 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -91,8 +91,11 @@ static size_t cfg_size = 0;
 static unsigned cfg_affinity_mode = AFFINITY_MODE_NONE;
 static unsigned cfg_rq_alloc_mode = RQ_ALLOC_USER;
 static unsigned cfg_area_type = AREA_TYPE_NORMAL;
+static bool cfg_notif = false;
 static struct sockaddr_in6 cfg_addr;
 
+#define NOTIF_USER_DATA		UINT64_MAX
+
 static long page_size;
 
 static void *area_ptr;
@@ -102,6 +105,10 @@ static struct io_uring_zcrx_rq rq_ring;
 static unsigned long area_token;
 static bool stop;
 static __u32 zcrx_id;
+static __u32 notif_stats_size;
+static __u32 notif_stats_alignment;
+static __u32 notif_stats_offset;
+static struct io_uring_zcrx_notif_stats *notif_stats;
 
 static int dmabuf_fd;
 static int memfd;
@@ -164,6 +171,13 @@ static inline size_t get_refill_ring_size(unsigned int rq_entries)
 	ring_size = rq_entries * sizeof(struct io_uring_zcrx_rqe);
 	/* add space for the header (head/tail/etc.) */
 	ring_size += page_size;
+
+	if (cfg_notif && notif_stats_size) {
+		notif_stats_offset = T_ALIGN_UP(ring_size,
+						notif_stats_alignment);
+		ring_size = notif_stats_offset + notif_stats_size;
+	}
+
 	return T_ALIGN_UP(ring_size, page_size);
 }
 
@@ -236,9 +250,48 @@ static void zcrx_populate_area(struct io_uring_zcrx_area_reg *area_reg)
 	area_reg->flags = 0;
 }
 
+static void zcrx_probe_notif(void)
+{
+	struct io_uring_query_zcrx zcrx_query;
+	struct io_uring_query_hdr zcrx_hdr = {
+		.size = sizeof(zcrx_query),
+		.query_data = uring_ptr_to_u64(&zcrx_query),
+		.query_op = IO_URING_QUERY_ZCRX,
+	};
+	struct io_uring_query_zcrx_notif notif_query;
+	struct io_uring_query_hdr notif_hdr = {
+		.size = sizeof(notif_query),
+		.query_data = uring_ptr_to_u64(&notif_query),
+		.query_op = IO_URING_QUERY_ZCRX_NOTIF,
+	};
+	int ret;
+
+	ret = io_uring_register(-1, IORING_REGISTER_QUERY, &zcrx_hdr, 0);
+	if (ret < 0 || zcrx_hdr.result < 0) {
+		printf("Failed to query ZCRX\n");
+		return;
+	}
+
+	if (!(zcrx_query.features & ZCRX_FEATURE_NOTIFICATION)) {
+		printf("Kernel doesn't support ZCRX notifications\n");
+		return;
+	}
+
+	ret = io_uring_register(-1, IORING_REGISTER_QUERY, &notif_hdr, 0);
+	if (ret < 0 || notif_hdr.result < 0) {
+		printf("Failed to query ZCRX stats parameters\n");
+		return;
+	}
+
+	notif_stats_size = notif_query.notif_stats_size;
+	notif_stats_alignment = notif_query.notif_stats_off_alignment;
+	cfg_notif = true;
+}
+
 static void setup_zcrx(struct io_uring *ring)
 {
 	struct io_uring_zcrx_area_reg area_reg;
+	struct zcrx_notification_desc notif;
 	unsigned int ifindex;
 	unsigned int rq_entries = cfg_rq_entries;
 	unsigned rq_flags = 0;
@@ -276,6 +329,18 @@ static void setup_zcrx(struct io_uring *ring)
 		.region_ptr = uring_ptr_to_u64(&region_reg),
 	};
 
+	if (cfg_notif) {
+		memset(&notif, 0, sizeof(notif));
+		notif.user_data = NOTIF_USER_DATA;
+		notif.type_mask = ZCRX_NOTIF_NO_BUFFERS |
+				  ZCRX_NOTIF_COPY;
+		if (notif_stats_size) {
+			notif.flags = ZCRX_NOTIF_DESC_FLAG_STATS;
+			notif.stats_offset = notif_stats_offset;
+		}
+		reg.notif_desc = uring_ptr_to_u64(&notif);
+	}
+
 	ret = io_uring_register_ifq(ring, &reg);
 	if (ret)
 		t_error(1, 0, "io_uring_register_ifq(): %d", ret);
@@ -297,6 +362,10 @@ static void setup_zcrx(struct io_uring *ring)
 
 	zcrx_id = reg.zcrx_id;
 	area_token = area_reg.rq_area_token;
+
+	if (cfg_notif && notif_stats_size)
+		notif_stats = (struct io_uring_zcrx_notif_stats *)
+				((char *)ring_ptr + notif_stats_offset);
 }
 
 static void add_accept(struct io_uring *ring, int sockfd)
@@ -473,6 +542,40 @@ static void process_recvzc(struct io_uring *ring,
 	return_buffer(&rq_ring, cqe);
 }
 
+static void rearm_notification(struct io_uring *ring, __u32 type_mask)
+{
+	struct zcrx_ctrl ctrl = {
+		.zcrx_id = zcrx_id,
+		.op = ZCRX_CTRL_ARM_NOTIFICATION,
+	};
+	int ret;
+
+	ctrl.zc_arm_notif.type_mask = type_mask;
+	ret = io_uring_register(ring->ring_fd, IORING_REGISTER_ZCRX_CTRL,
+				&ctrl, 0);
+	if (ret < 0)
+		fprintf(stderr, "arm notification failed: %d\n", ret);
+}
+
+static void process_notification(struct io_uring *ring,
+				 struct io_uring_cqe *cqe)
+{
+	__u32 type_mask = cqe->res;
+
+	if (type_mask & ZCRX_NOTIF_NO_BUFFERS)
+		printf("Notification: no buffers available\n");
+	if (type_mask & ZCRX_NOTIF_COPY) {
+		printf("Notification: copy fallback\n");
+
+		if (notif_stats)
+			printf("stats: copy_count=%llu copy_bytes=%llu\n",
+			       IO_URING_READ_ONCE(notif_stats->copy_count),
+			       IO_URING_READ_ONCE(notif_stats->copy_bytes));
+	}
+
+	rearm_notification(ring, type_mask);
+}
+
 static void server_loop(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe;
@@ -484,6 +587,11 @@ static void server_loop(struct io_uring *ring)
 		t_error(1, ret, "io_uring_submit_and_wait failed\n");
 
 	io_uring_for_each_cqe(ring, head, cqe) {
+		if (cqe->user_data == NOTIF_USER_DATA) {
+			process_notification(ring, cqe);
+			count++;
+			continue;
+		}
 		switch (cqe->user_data & REQ_TYPE_MASK) {
 		case REQ_TYPE_ACCEPT:
 			process_accept(ring, cqe);
@@ -534,6 +642,7 @@ static void run_server(void)
 	if (ret)
 		t_error(1, ret, "ring init failed");
 
+	zcrx_probe_notif();
 	setup_zcrx(&ring);
 	add_accept(&ring, listen_fd);
 
-- 
2.52.0


