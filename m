Return-Path: <io-uring+bounces-13125-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCVeCa7V6GklQQIAu9opvQ
	(envelope-from <io-uring+bounces-13125-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 16:05:34 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0682E4470B3
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 16:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B38463008D03
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9ADA3E9F97;
	Wed, 22 Apr 2026 13:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="A8Aw9d9P"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BDD26E718
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 13:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776866306; cv=none; b=jO6kgKWg6WMms2WGYUalAXvh/+QDnMZRNcxwLYxJaOIR7CMrnnYxag+vWHScEN6qylurw7E6fnVDjdVJJByN+pHYTkgM3WWfBMPIfUHdPsbE/fLd0JjVDkWtpuFDmdlA1tccbihhFRa1Iyy2lImn+ELY8q/teqEt9Kt7p4EhuBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776866306; c=relaxed/simple;
	bh=zqhReJruRucvj18YcSeO34CwUaTpX1efdrp3PsJAXVc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mbb78dDA2G0cK8dGpv6g12GFIZb5iyQEMt7t3ZItnrUzllgG7IpaihqI48NnswiRuuOcT4yyIwfsyQjMhHyMAGaRT9G446SgnR5PNPjwnda+JezaZ5A7Y3gkpF7I7BTTFLRCXf0ssHbJyBv9FFlKOgQH8lqtd2BnvG2/8BQoiug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=A8Aw9d9P; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIbfXn710935;
	Wed, 22 Apr 2026 06:58:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=HDs6tyzKnj0Lq49x7w+CJ3cMA1MQARLOB1A3hS3DpiU=; b=A8Aw9d9P7RRz
	jBP7th0wgfVc4Ff/kOgRmArFLqEFQusyvTgkNsNlg+RgffUom+Sp5tv72LYninzF
	eRz6K8otziQKCMAGgQoHGSHt4LnlahqPfZQFctGGXmn/Qkijs4lbtb22THgw07bd
	ehHPOX11PQXCi1EIIAdVu2D9HYAJ0/odoZTA4eJ/6eS5VM1FnStrp3QeTziYFqOu
	StdVNCbaFsCOzizEvZn0s6V5qnof/5PRHg8sB3k99M2sdmN88eMq6AScmN0ww9rn
	EQnMJUCraS1jY9THjMj3A8Ym4MWlTN5mhcTMzasWBB3NkxtDVqEfqZ68sHyZtaWc
	Y8x/pSk/FA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dpepc5csa-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 22 Apr 2026 06:58:23 -0700 (PDT)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Wed, 22 Apr
 2026 13:58:22 +0000
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
To: <io-uring@vger.kernel.org>
CC: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
        Jens Axboe
	<axboe@kernel.dk>
Subject: [PATCH liburing 2/3] test/zcrx: add ZCRX notification/stats tests
Date: Wed, 22 Apr 2026 06:57:21 -0700
Message-ID: <20260422135724.528518-3-cleger@meta.com>
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
X-Authority-Analysis: v=2.4 cv=NInlPU6g c=1 sm=1 tr=0 ts=69e8d3ff cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=U_y8lYiYyhHBU5rMqhb2:22
 a=VabnemYjAAAA:8 a=i-tqJ75dfQDP0daudQQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: oyjj2bqasmvrUnDRCwjn82eZZ-VxqsUn
X-Proofpoint-ORIG-GUID: oyjj2bqasmvrUnDRCwjn82eZZ-VxqsUn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDEzNSBTYWx0ZWRfXwmqmhSLrdjvO
 GbhRzS+e/+rXHtEzsf3qz0XfLijaMveC0nUGGDHWC7fNbdW6zjeIcEo49xHBgUo51FoM6aGkpNI
 ARmBRJm40vbGKehPUFOCg/o9bBjETdH2O1N0nnRXhhbwnui2DVBgRbzqUDy6KfObidxQn1QTMBw
 DglLc4dO+DWmBbZ5rSDTRHJ1xCuWc+UZTphQqTeGGlHjsodIyaU5JXFSXcH049xZCfPG/cZEhoo
 Hf3unQVsHNIRnWJxWNZzxEp0acl5xy7xCafZGpKQuSdUb/LBYZGS2ZkHPrKlTnWyrQhz4X4oEnf
 mdiRbHMsPQv6XSHLSDGv/fZr1+5sQRBwivSIpc+2dWoAdkYNl8hngJ0LkL9pT81yRNJ3ROPudLC
 OJ9QZA1ugZKqbqkL1WWbG4lUmCuWlqbMsWPn+t3uouGzz+/Cu7IOPm3Bg7PG5ivUIr/GyzV/GmW
 ujKzxktCTrM4xwmVJlA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Spamd-Result: default: False [-0.45 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13125-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,meta.com:dkim,meta.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0682E4470B3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Enhance zcrx testsutie so that it covers notification registration
validation, stats region placement, and arm operation error paths.

Signed-off-by: Clément Léger <cleger@meta.com>
---
 test/zcrx.c | 376 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 376 insertions(+)

diff --git a/test/zcrx.c b/test/zcrx.c
index a0e8a863..b13eab43 100644
--- a/test/zcrx.c
+++ b/test/zcrx.c
@@ -811,6 +811,364 @@ static int test_zcrx_clone(void)
 	return 0;
 }
 
+static int try_register_ifq_with_notif(struct zcrx_notification_desc *notif,
+				       void *area)
+{
+	struct io_uring_region_desc rq_region = {
+		.size = get_rq_size(RQ_ENTRIES),
+		.user_addr = uring_ptr_to_u64(def_rq_mem),
+		.flags = IORING_MEM_REGION_TYPE_USER,
+	};
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = uring_ptr_to_u64(area),
+		.len = AREA_SZ,
+		.flags = 0,
+	};
+	struct io_uring_zcrx_ifq_reg reg = {
+		.flags = ZCRX_REG_NODEV,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
+		.region_ptr = uring_ptr_to_u64(&rq_region),
+		.notif_desc = uring_ptr_to_u64(notif),
+	};
+
+	return try_register_zcrx(&reg);
+}
+
+static int test_notif_registration(void *area)
+{
+	struct zcrx_notification_desc notif;
+	int ret;
+
+	/* Valid registration with no-buffers notification */
+	memset(&notif, 0, sizeof(notif));
+	notif.user_data = 42;
+	notif.type_mask = ZCRX_NOTIF_NO_BUFFERS;
+
+	ret = try_register_ifq_with_notif(&notif, area);
+	if (ret) {
+		fprintf(stderr, "valid notif registration failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	/* Valid registration with both notification types */
+	memset(&notif, 0, sizeof(notif));
+	notif.user_data = 42;
+	notif.type_mask = ZCRX_NOTIF_NO_BUFFERS |
+			  ZCRX_NOTIF_COPY;
+
+	ret = try_register_ifq_with_notif(&notif, area);
+	if (ret) {
+		fprintf(stderr, "valid notif both-types registration failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	/* Invalid type_mask (bit beyond valid range) */
+	memset(&notif, 0, sizeof(notif));
+	notif.user_data = 42;
+	notif.type_mask = (1 << 31);
+
+	ret = try_register_ifq_with_notif(&notif, area);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "invalid notif type_mask should fail with -EINVAL, got %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	/* Non-zero reserved field should fail */
+	memset(&notif, 0, sizeof(notif));
+	notif.user_data = 42;
+	notif.type_mask = ZCRX_NOTIF_NO_BUFFERS;
+	notif.__resv2[0] = 1;
+
+	ret = try_register_ifq_with_notif(&notif, area);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "non-zero resv2 should fail with -EINVAL, got %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	/* Invalid notif flags */
+	memset(&notif, 0, sizeof(notif));
+	notif.user_data = 42;
+	notif.type_mask = ZCRX_NOTIF_NO_BUFFERS;
+	notif.flags = ~ZCRX_NOTIF_DESC_FLAG_STATS;
+
+	ret = try_register_ifq_with_notif(&notif, area);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "invalid notif flags should fail with -EINVAL, got %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	return T_EXIT_PASS;
+}
+
+static int test_notif_stats(void *area)
+{
+	struct io_uring_query_zcrx zcrx_query = {};
+	struct io_uring_query_hdr zcrx_hdr = {
+		.size = sizeof(zcrx_query),
+		.query_data = uring_ptr_to_u64(&zcrx_query),
+		.query_op = IO_URING_QUERY_ZCRX,
+	};
+	struct io_uring_query_zcrx_notif notif_query = {};
+	struct io_uring_query_hdr notif_hdr = {
+		.size = sizeof(notif_query),
+		.query_data = uring_ptr_to_u64(&notif_query),
+		.query_op = IO_URING_QUERY_ZCRX_NOTIF,
+	};
+	struct zcrx_notification_desc notif;
+	size_t ring_size, rqes_end, stats_off, hdr_size;
+	int ret;
+	int tret = T_EXIT_FAIL;
+	void *ring_mem;
+
+	/*
+	 * Query the kernel for the actual refill ring header size and stats
+	 * struct layout so we can build a correctly-sized user region.
+	 */
+	ret = io_uring_register(-1, IORING_REGISTER_QUERY, &zcrx_hdr, 0);
+	if (ret < 0 || zcrx_hdr.result < 0) {
+		fprintf(stderr, "zcrx query not supported: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_register(-1, IORING_REGISTER_QUERY, &notif_hdr, 0);
+	if (ret < 0 || notif_hdr.result < 0) {
+		fprintf(stderr, "zcrx notif query not supported: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	if (!notif_query.notif_stats_size) {
+		fprintf(stderr, "notif stats not supported\n");
+		return T_EXIT_FAIL;
+	}
+
+	hdr_size = T_ALIGN_UP((__u64)zcrx_query.rq_hdr_size,
+			     zcrx_query.rq_hdr_alignment);
+	rqes_end = hdr_size + sizeof(struct io_uring_zcrx_rqe) * RQ_ENTRIES;
+	stats_off = T_ALIGN_UP(rqes_end, notif_query.notif_stats_off_alignment);
+	ring_size = stats_off + notif_query.notif_stats_size;
+	ring_size = T_ALIGN_UP(ring_size, page_size);
+
+	ring_mem = mmap(NULL, ring_size, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (ring_mem == MAP_FAILED) {
+		perror("mmap ring_mem");
+		return T_EXIT_FAIL;
+	}
+
+	struct io_uring_region_desc region = {
+		.user_addr = uring_ptr_to_u64(ring_mem),
+		.size = ring_size,
+		.flags = IORING_MEM_REGION_TYPE_USER,
+	};
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = uring_ptr_to_u64(area),
+		.len = AREA_SZ,
+		.flags = 0,
+	};
+
+	/* Valid stats offset */
+	memset(&notif, 0, sizeof(notif));
+	notif.user_data = 42;
+	notif.type_mask = ZCRX_NOTIF_NO_BUFFERS;
+	notif.flags = ZCRX_NOTIF_DESC_FLAG_STATS;
+	notif.stats_offset = stats_off;
+
+	struct io_uring_zcrx_ifq_reg reg = {
+		.flags = ZCRX_REG_NODEV,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
+		.region_ptr = uring_ptr_to_u64(&region),
+		.notif_desc = uring_ptr_to_u64(&notif),
+	};
+
+	/*
+	 * Pre-fill the stats area with non-zero values to verify the kernel
+	 * zeroes it on registration.
+	 */
+	memset((char *)ring_mem + stats_off, 0xff,
+	       sizeof(struct io_uring_zcrx_notif_stats));
+
+	ret = try_register_zcrx(&reg);
+	if (ret) {
+		fprintf(stderr, "notif stats registration failed: %d\n", ret);
+		goto unmap;
+	}
+
+	/* Verify the stats area was zeroed by the kernel */
+	struct io_uring_zcrx_notif_stats *stats =
+		(struct io_uring_zcrx_notif_stats *)((char *)ring_mem + stats_off);
+	if (stats->copy_count || stats->copy_bytes) {
+		fprintf(stderr, "stats not zeroed after registration\n");
+		goto unmap;
+	}
+
+	/* Misaligned stats offset should fail */
+	memset(&notif, 0, sizeof(notif));
+	notif.user_data = 42;
+	notif.type_mask = ZCRX_NOTIF_NO_BUFFERS;
+	notif.flags = ZCRX_NOTIF_DESC_FLAG_STATS;
+	notif.stats_offset = stats_off + 1;
+
+	region.user_addr = uring_ptr_to_u64(ring_mem);
+	reg.region_ptr = uring_ptr_to_u64(&region);
+	reg.notif_desc = uring_ptr_to_u64(&notif);
+
+	ret = try_register_zcrx(&reg);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "misaligned stats_offset should fail, got %d\n", ret);
+		goto unmap;
+	}
+
+	/* Stats offset overlapping with rqes should fail */
+	notif.stats_offset = sizeof(struct io_uring_zcrx_rqe);
+
+	ret = try_register_zcrx(&reg);
+	if (ret != -ERANGE) {
+		fprintf(stderr, "overlapping stats_offset should fail, got %d\n", ret);
+		goto unmap;
+	}
+
+	/* Stats offset beyond region should fail */
+	notif.stats_offset = ring_size;
+
+	ret = try_register_zcrx(&reg);
+	if (ret != -ERANGE) {
+		fprintf(stderr, "out-of-bounds stats_offset should fail, got %d\n", ret);
+		goto unmap;
+	}
+
+	tret = T_EXIT_PASS;
+unmap:
+	munmap(ring_mem, ring_size);
+	return tret;
+}
+
+static int test_arm_notification(void *area)
+{
+	struct zcrx_notification_desc notif;
+	struct io_uring ring;
+	struct zcrx_ctrl ctrl;
+	__u32 zcrx_id;
+	int ret;
+
+	struct io_uring_zcrx_area_reg area_reg = {
+		.addr = uring_ptr_to_u64(area),
+		.len = AREA_SZ,
+		.flags = 0,
+	};
+	struct io_uring_region_desc rq_region = {
+		.size = get_rq_size(RQ_ENTRIES),
+		.user_addr = uring_ptr_to_u64(def_rq_mem),
+		.flags = IORING_MEM_REGION_TYPE_USER,
+	};
+	struct io_uring_zcrx_ifq_reg reg = {
+		.flags = ZCRX_REG_NODEV,
+		.rq_entries = RQ_ENTRIES,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
+		.region_ptr = uring_ptr_to_u64(&rq_region),
+	};
+
+	/* First, register without notifications and check arm fails */
+	ret = t_create_ring(128, &ring, RING_FLAGS);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_register_ifq(&ring, &reg);
+	if (ret) {
+		fprintf(stderr, "ifq register failed: %d\n", ret);
+		io_uring_queue_exit(&ring);
+		return T_EXIT_FAIL;
+	}
+	zcrx_id = reg.zcrx_id;
+
+	memset(&ctrl, 0, sizeof(ctrl));
+	ctrl.zcrx_id = zcrx_id;
+	ctrl.op = ZCRX_CTRL_ARM_NOTIFICATION;
+	ctrl.zc_arm_notif.type_mask = ZCRX_NOTIF_NO_BUFFERS;
+
+	ret = io_uring_register(ring.ring_fd, IORING_REGISTER_ZCRX_CTRL,
+				&ctrl, 0);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "arm without prior notif should fail, got %d\n", ret);
+		io_uring_queue_exit(&ring);
+		return T_EXIT_FAIL;
+	}
+	io_uring_queue_exit(&ring);
+
+	/* Now register with notifications and try arm with invalid mask */
+	memset(&notif, 0, sizeof(notif));
+	notif.user_data = 42;
+	notif.type_mask = ZCRX_NOTIF_NO_BUFFERS;
+
+	reg.notif_desc = uring_ptr_to_u64(&notif);
+
+	ret = t_create_ring(128, &ring, RING_FLAGS);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = io_uring_register_ifq(&ring, &reg);
+	if (ret) {
+		fprintf(stderr, "notif ifq register failed: %d\n", ret);
+		io_uring_queue_exit(&ring);
+		return T_EXIT_FAIL;
+	}
+	zcrx_id = reg.zcrx_id;
+
+	/* Arm with invalid type (bit 31) should fail */
+	memset(&ctrl, 0, sizeof(ctrl));
+	ctrl.zcrx_id = zcrx_id;
+	ctrl.op = ZCRX_CTRL_ARM_NOTIFICATION;
+	ctrl.zc_arm_notif.type_mask = (1 << 31);
+
+	ret = io_uring_register(ring.ring_fd, IORING_REGISTER_ZCRX_CTRL,
+				&ctrl, 0);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "arm with invalid mask should fail, got %d\n", ret);
+		io_uring_queue_exit(&ring);
+		return T_EXIT_FAIL;
+	}
+
+	/*
+	 * Arm for a type that hasn't fired yet should fail because the kernel
+	 * only allows rearming notifications that have already been delivered.
+	 */
+	memset(&ctrl, 0, sizeof(ctrl));
+	ctrl.zcrx_id = zcrx_id;
+	ctrl.op = ZCRX_CTRL_ARM_NOTIFICATION;
+	ctrl.zc_arm_notif.type_mask = ZCRX_NOTIF_NO_BUFFERS;
+
+	ret = io_uring_register(ring.ring_fd, IORING_REGISTER_ZCRX_CTRL,
+				&ctrl, 0);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "arm for unfired notif should fail, got %d\n", ret);
+		io_uring_queue_exit(&ring);
+		return T_EXIT_FAIL;
+	}
+
+	/* Non-zero reserved in arm_notif should fail */
+	memset(&ctrl, 0, sizeof(ctrl));
+	ctrl.zcrx_id = zcrx_id;
+	ctrl.op = ZCRX_CTRL_ARM_NOTIFICATION;
+	ctrl.zc_arm_notif.type_mask = ZCRX_NOTIF_NO_BUFFERS;
+	ctrl.zc_arm_notif.__resv[0] = 1;
+
+	ret = io_uring_register(ring.ring_fd, IORING_REGISTER_ZCRX_CTRL,
+				&ctrl, 0);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "arm with non-zero resv should fail, got %d\n", ret);
+		io_uring_queue_exit(&ring);
+		return T_EXIT_FAIL;
+	}
+
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+}
+
 static int test_rq_flush(void)
 {
 	struct t_executor ctx;
@@ -1112,6 +1470,24 @@ static int run_tests(void)
 		return T_EXIT_FAIL;
 	}
 
+	ret = test_notif_registration(def_area_mem);
+	if (ret) {
+		fprintf(stderr, "test_notif_registration failed\n");
+		return ret;
+	}
+
+	ret = test_notif_stats(def_area_mem);
+	if (ret) {
+		fprintf(stderr, "test_notif_stats failed\n");
+		return ret;
+	}
+
+	ret = test_arm_notification(def_area_mem);
+	if (ret) {
+		fprintf(stderr, "test_arm_notification failed\n");
+		return ret;
+	}
+
 	ret = test_recv();
 	if (ret) {
 		fprintf(stderr, "test_recv() failed %i\n", ret);
-- 
2.52.0


