Return-Path: <io-uring+bounces-13652-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id LTxSFZPYJ2oH3QIAu9opvQ
	(envelope-from <io-uring+bounces-13652-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 09 Jun 2026 11:10:43 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E62D865E21D
	for <lists+io-uring@lfdr.de>; Tue, 09 Jun 2026 11:10:42 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=SjYB7fu3;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13652-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13652-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 33388313CD7A
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2026 09:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29BA2E091E;
	Tue,  9 Jun 2026 09:02:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6BE38AC88
	for <io-uring@vger.kernel.org>; Tue,  9 Jun 2026 09:02:28 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780995749; cv=none; b=jK4CVaQMx9DJgWk4obK0rdjZnuj3BE4tQukxL1Khvm4uo5HHee31H2BN+ppbAFlsRnbrrXaE4X/qoCq77rz3wdbaI6s459T2nb4cAMsbh0EtRb1xrFjsch0kExiX3FneHRvP06lBnRUs5/QUedRNsV8l7ecO1lnmIU21IHmkf5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780995749; c=relaxed/simple;
	bh=GYjCvdXei/QTqpSO9+gf+Ejy+VvJ9jkj+JbdnKrdoEI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h7gNxuFHk4LSn/vkUViYmuMQ/GxRAK7KN44DTdu3UrPHlxAJkT3Hzre3lIDQsTY0vTGpVX4tFYdnLMYAJhd6PRQGVWdD4W4s1HYhGdhUOxqAPm5CVHgMJ9zYmjb+hlgM3X+DAhFNHtC6k0+G0f3yPCNhAkQ/fXTQeEiWra0DH94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=SjYB7fu3; arc=none smtp.client-ip=67.231.145.42
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658LTQJU1423954;
	Tue, 9 Jun 2026 02:02:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=7vzda1og3XnH/0V2CYLPaAlVALiJ0oCuPG0qN2E4Wy0=; b=SjYB7fu3Yoph
	0d77mRZ+X1PUBLQNohc8/CVU247a14xlGL5gk5uo3HmwVwzjv6iKe4A8IoqE9fgM
	BDK2IPkBSaZeid0Tsrr8EEzt0sajjkHQO19BYy3r0ijlAgBV+8RgEPih3r90TEuW
	tsHCI4U2bleGyzgZQAm4LkCmwmls0CrVlaFKkvDdVnAlOrDazBv+b2JJ2GWzywCq
	wksjzbb8dXEcDWUvUURegYvFrHnKQpnrxQGnaBk0O/9s9OEtE8k8RsB4HsIONOKt
	FDSHeSKbcyqoQOtsl+kPOLuvzZuchAC44WpyDg9S5Xt73tCPIeU9zS4WH0AsM+SU
	yAPty5DyNg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4emjum6s2v-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 09 Jun 2026 02:02:26 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1c::11) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.41; Tue, 9 Jun
 2026 09:02:25 +0000
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
To: <io-uring@vger.kernel.org>
CC: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
        Jens Axboe
	<axboe@kernel.dk>
Subject: [PATCH liburing v2 3/3] examples/zcrx: add notification support
Date: Tue, 9 Jun 2026 02:01:50 -0700
Message-ID: <20260609090156.3862920-4-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260609090156.3862920-1-cleger@meta.com>
References: <20260609090156.3862920-1-cleger@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Fvk1OWrq c=1 sm=1 tr=0 ts=6a27d6a2 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=M51BFTxLslgA:10 a=sWKEhP36mHoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=crHB47gyY4rKiduisYu9:22
 a=VabnemYjAAAA:8 a=QvjoEvHx9T2nUATbkMQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: j2COY10HaeSAq4uhqL_rK_5lvpLduQN2
X-Proofpoint-ORIG-GUID: j2COY10HaeSAq4uhqL_rK_5lvpLduQN2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA4MyBTYWx0ZWRfXy0b6gxC3PJFy
 Lkqd0xeLoRptgLBTy+ZkZsytq6jnHz19eUbXGyLZMxY4i8VLbBy6mMcQ5wQOkaUZYw0FAyvYMtK
 RqD060lmk7mFOPp5qExFQYEHynjzPAHfN9IS3pCWlKvt+/uuDfA/3D/JhBs5UK06KCxDO1+wUdz
 jeIjQyyYG1XdtkgJ+p7H2hvcEiChq46azC7YEtSjq3ZdYZ5G/WmDrQQleY/L932HMiHGsfKs3xa
 2V3iiPVa2ykf4Vii11U/yPshyXH7nIRxWU6lR+EU+tNLKhizFbT9PpDWtd9xnaXvwMLFXCAl2ur
 v1zWB07N4y2llfMZGLoH2yXV3XnT0oC9o6MY4VDLVwd1/VU0VPxOFIrn8oU5e8Qrrn0e0pOooUE
 73m4IiG26xtXEVoKcrFuieNH+HclahaaDlAjzA21xh5BlmiIzxI/VL9h0nizvipLqG5AMGw6hBD
 JjcxOFA98hia/9+EVgA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_01,2025-10-01_01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.39 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.77)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13652-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:cleger@meta.com,m:axboe@kernel.dk,s:lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:dkim,meta.com:email,meta.com:mid,meta.com:from_mime,vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E62D865E21D

Add support to register notifications and display stats when
notifications are received. This allows to provide an example of how to
register and configure notifications and stats support. If an error is
encountered while running, then the notification type will be displayed
along the stat counter if associated to the notification (ie copy fallback).

Notification support is probe before zcrx setup and enabled by default
if detected.

Signed-off-by: Clément Léger <cleger@meta.com>
---
 examples/zcrx.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index b55b07ce..f2cb5c1d 100644
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
+		notif.type_mask = (1 << ZCRX_NOTIF_NO_BUFFERS) |
+				  (1 << ZCRX_NOTIF_COPY);
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
@@ -473,6 +542,41 @@ static void process_recvzc(struct io_uring *ring,
 	return_buffer(&rq_ring, cqe);
 }
 
+static void rearm_notification(struct io_uring *ring, __u32 notif_type)
+{
+	struct zcrx_ctrl ctrl = {
+		.zcrx_id = zcrx_id,
+		.op = ZCRX_CTRL_ARM_NOTIFICATION,
+	};
+	int ret;
+
+	ctrl.zc_arm_notif.notif_type = notif_type;
+	ret = io_uring_register(ring->ring_fd, IORING_REGISTER_ZCRX_CTRL,
+				&ctrl, 0);
+	if (ret < 0)
+		fprintf(stderr, "arm notification failed: %d\n", ret);
+}
+
+static void process_notification(struct io_uring *ring,
+				 struct io_uring_cqe *cqe)
+{
+	__u32 notif_type = cqe->res;
+
+	if (notif_type == ZCRX_NOTIF_NO_BUFFERS) {
+		printf("Notification: no buffers available\n");
+	} else {
+		printf("Notification: unknown notification %u\n", notif_type);
+	}
+
+	if (notif_stats && notif_type == ZCRX_NOTIF_COPY) {
+		printf("Notification: copy fallback\nStats: copy_count=%llu copy_bytes=%llu\n",
+			IO_URING_READ_ONCE(notif_stats->copy_count),
+			IO_URING_READ_ONCE(notif_stats->copy_bytes));
+	}
+
+	rearm_notification(ring, notif_type);
+}
+
 static void server_loop(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe;
@@ -484,6 +588,11 @@ static void server_loop(struct io_uring *ring)
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
@@ -534,6 +643,7 @@ static void run_server(void)
 	if (ret)
 		t_error(1, ret, "ring init failed");
 
+	zcrx_probe_notif();
 	setup_zcrx(&ring);
 	add_accept(&ring, listen_fd);
 
-- 
2.52.0


