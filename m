Return-Path: <io-uring+bounces-13124-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eEczMPjT6GklQQIAu9opvQ
	(envelope-from <io-uring+bounces-13124-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 15:58:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 45E50446FDF
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 15:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 68DCE302C174
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A493E024E;
	Wed, 22 Apr 2026 13:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="dobvE+/l"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947F4286D5E
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 13:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776866293; cv=none; b=EwafLAIfyzegBoZGDl5mC0bet69OHKDKuU2z22rFZN+Bh1XXvGYeRg+i58tYyaPV7/GZ4ivzXF9gqrGjxcohjiBAoFNLxx9JMNiO+9ax604pPkNevb7/P+IUs94l492nldaE+Eb0RruPMxxblUf4D08ojAMjsDIgkbYZXmbVE60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776866293; c=relaxed/simple;
	bh=66cm+qyTPbATR1isG7ZiJ6FRxwLrieMeTcsJDtylxnQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CVqyjgYQm7njB1VB3ADVA8aJJb1fipLd1/yBbOjvDbsy/w6t08vSOYzUugRthsbPpeOkNC7j7aaNL4bBxpYBVXhj/OEAx5XTf1M6ZvwJQfMFc4YpJ5rbno2PPegzHqMfmwtADoC4LI6+1U+zQ0rVdWt87dDW6+KwtLNNHKZIhaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=dobvE+/l; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIbfBr332744;
	Wed, 22 Apr 2026 06:58:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=RwGHGtDaJBFpKLLsS4rKIrrw8S/A2YT8petf/H7rreQ=; b=dobvE+/lyeyw
	U3pYa6wbWgog9aauuOuIt26w/9uGKwecSB3XjilvBC9XzFr3oWM3RA5bw/DJcXPi
	jcDMTqBrkjXq9Y+Ed+j+Oa0lVOFJ51nnBtqbgkv69GBk72OYRGNCVHsekxwV0eYq
	jyZ4XBBKy3MABzxkMWi3HhbpW3jg3UO0otV/Xmlf6pWCf7eHHn8pcVZVRbfkT+OF
	CWI5IK5WhVCNtIF4J+lwL7dWiABu314FZGAVNnPUkUokvduGXcTZfUbOr3zRU2qT
	HNtqti3C6wiCruHsUgvJik2/V0iuJKgoXrcni4Z0tO2FgWHMknay7ORx7W0vi/5t
	IT5/SuQALg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dpepa5bnk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 22 Apr 2026 06:58:10 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1b::30) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Wed, 22 Apr
 2026 13:58:09 +0000
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
To: <io-uring@vger.kernel.org>
CC: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
        Jens Axboe
	<axboe@kernel.dk>
Subject: [PATCH liburing 1/3] Update uapi headers to add ZCRX notification
Date: Wed, 22 Apr 2026 06:57:20 -0700
Message-ID: <20260422135724.528518-2-cleger@meta.com>
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
X-Proofpoint-ORIG-GUID: ns0Uaz-bn4cmFHFbICLy22YXxyfzSENv
X-Authority-Analysis: v=2.4 cv=N9oZ0W9B c=1 sm=1 tr=0 ts=69e8d3f2 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=xtH7KyWI9dI7BmFOsl-x:22
 a=VabnemYjAAAA:8 a=MSChe4J9zM98ecmaqjIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: ns0Uaz-bn4cmFHFbICLy22YXxyfzSENv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDEzNSBTYWx0ZWRfXxnDwoVUvoHYM
 WKbMwj25DY7Kx0FzJqA4R2HDF07rr5zZJs3C5jDUS6aE5oBBKyumJzIVqOaXausZ/rfBUSnKodh
 TpqPoFEWBCS8tVBml7SJY4d09dYm8jzbRd6YxnSolkQa7vzJvIV/Iq9lxhQT2cfAP8jLeeKP2er
 tV0LnnCodbA172kSWfN5GIpeecnxQ3wwjcD3ozKTfNHK9VkruMOhSNdsizBvzYvfPENK8pIcgeX
 fLgbtH167DI11oiKYDSfwfBrev0QFCh6VrXp1SZeX+914DTbixMNKY9AEdruZVhjzntlwaCzrhA
 VVEG2Axdva3Nt+KPI2PTFLHpOLqQNU6MMMWOA08Cy+Jg6oLY0KpIv+Fc/6ZDvPFU3pGKz6eZmP6
 sH427OO2gNlbdCaExfkJYI9BOwjtzGXu+jlx00SjbA1Lvpdp8T9TlX3FTTAvAk+hwXGUM3GWX7x
 ehcLr6YbOrM66QIkdWA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Spamd-Result: default: False [-0.45 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13124-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 45E50446FDF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Extend the ZCRX uapi with notification infrastructure: notification
types (no-buffers, copy-fallback), stats structure, notification
descriptor for registration and arm control operation.

A new IORING_REGISTER_QUERY op allows userspace to discover the
notification stats memory layout. Additionnal flags are as well required
to register the statistics structure and enable notification upon
registration.

Signed-off-by: Clément Léger <cleger@meta.com>
---
 src/include/liburing/io_uring.h       | 34 ++++++++++++++++++++++++++-
 src/include/liburing/io_uring/query.h | 12 ++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 983aa265..a479d0b5 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -1068,6 +1068,30 @@ enum zcrx_features {
 	 * value in struct io_uring_zcrx_ifq_reg::rx_buf_len.
 	 */
 	ZCRX_FEATURE_RX_PAGE_SIZE	= 1 << 0,
+	ZCRX_FEATURE_NOTIFICATION	= 1 << 1,
+};
+
+enum zcrx_notification_type {
+	ZCRX_NOTIF_NO_BUFFERS = 1 << 0,
+	ZCRX_NOTIF_COPY = 1 << 1
+};
+
+enum zcrx_notification_desc_flags {
+	/* If set, assume that stats_offset hold a correct offset to  */
+	ZCRX_NOTIF_DESC_FLAG_STATS = 1 << 0,
+};
+
+struct io_uring_zcrx_notif_stats {
+	__u64	copy_count;	/* cumulative copy-fallback CQEs */
+	__u64	copy_bytes;	/* cumulative bytes copied */
+};
+
+struct zcrx_notification_desc {
+	__u64	user_data;
+	__u32	type_mask;
+	__u32	flags; /* see enum zcrx_notification_desc_flags */
+	__u64	stats_offset; /* offset from the beginning of refill ring region for stats */
+	__u64	__resv2[9];
 };
 
 /*
@@ -1085,12 +1109,14 @@ struct io_uring_zcrx_ifq_reg {
 	struct io_uring_zcrx_offsets offsets;
 	__u32	zcrx_id;
 	__u32	rx_buf_len;
-	__u64	__resv[3];
+	__u64	notif_desc; /* see struct zcrx_notification_desc */
+	__u64	__resv[2];
 };
 
 enum zcrx_ctrl_op {
 	ZCRX_CTRL_FLUSH_RQ,
 	ZCRX_CTRL_EXPORT,
+	ZCRX_CTRL_ARM_NOTIFICATION,
 
 	__ZCRX_CTRL_LAST,
 };
@@ -1104,6 +1130,11 @@ struct zcrx_ctrl_export {
 	__u32 		__resv1[11];
 };
 
+struct zcrx_ctrl_arm_notif {
+	__u32		type_mask;
+	__u32		__resv[11];
+};
+
 struct zcrx_ctrl {
 	__u32	zcrx_id;
 	__u32	op; /* see enum zcrx_ctrl_op */
@@ -1112,6 +1143,7 @@ struct zcrx_ctrl {
 	union {
 		struct zcrx_ctrl_export		zc_export;
 		struct zcrx_ctrl_flush_rq	zc_flush;
+		struct zcrx_ctrl_arm_notif	zc_arm_notif;
 	};
 };
 
diff --git a/src/include/liburing/io_uring/query.h b/src/include/liburing/io_uring/query.h
index 0b624817..ad5efd99 100644
--- a/src/include/liburing/io_uring/query.h
+++ b/src/include/liburing/io_uring/query.h
@@ -20,6 +20,7 @@ enum {
 	IO_URING_QUERY_OPCODES			= 0,
 	IO_URING_QUERY_ZCRX			= 1,
 	IO_URING_QUERY_SCQ			= 2,
+	IO_URING_QUERY_ZCRX_NOTIF		= 3,
 
 	__IO_URING_QUERY_MAX,
 };
@@ -59,6 +60,17 @@ struct io_uring_query_zcrx {
 	__u64 __resv2;
 };
 
+struct io_uring_query_zcrx_notif {
+	/* Bitmask of supported ZCRX_NOTIF_* flags*/
+	__u32 notif_flags;
+	/* Size of io_uring_zcrx_notif_stats */
+	__u32 notif_stats_size;
+	/* Required alignment for the stats buffer within the region (ie stats_offset) */
+	__u32 notif_stats_off_alignment;
+	__u32 resv1;
+	__u64 __resv2[10];
+};
+
 struct io_uring_query_scq {
 	/* The SQ/CQ rings header size */
 	__u64 hdr_size;
-- 
2.52.0


