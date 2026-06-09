Return-Path: <io-uring+bounces-13650-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id lFMJO4zYJ2oC3QIAu9opvQ
	(envelope-from <io-uring+bounces-13650-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 09 Jun 2026 11:10:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7500465E211
	for <lists+io-uring@lfdr.de>; Tue, 09 Jun 2026 11:10:36 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=tbWeLXKQ;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13650-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13650-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B6F24313AD9E
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2026 09:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77921194AE6;
	Tue,  9 Jun 2026 09:02:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B3637F01A
	for <io-uring@vger.kernel.org>; Tue,  9 Jun 2026 09:02:20 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780995742; cv=none; b=Sn5elf0jKeMtC8oQb7jkBlGM+EmarIH5LcwhI8DAyZpAVKpggop7G7MHM2M321kqB/03sC7+M9CJiVRDK+DnISJ/T5lVKUd2uMEbrI8/MXXec5FIjhXHu9tJ5NVZ70iXdmyfXeZi9HEl/MraV8JrktwqsaacudcH4MQaKy9fPwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780995742; c=relaxed/simple;
	bh=uXZ4PZktIEeWht7/gEmi6OaZrvKOlQ6diDLYYtky4xM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NmLk4G7rjKsMdD5F0OgzKDQZ1H0UJYPTstnb0S8byJJs9NVLaWrNafvP8Tm27C7GUZpWY6Z9wJ2YViVRkH6N/ybZWH9Dvkc8CpFSVn1bttx+nWXQPb8ap9HunV1VjWc7dO8OfbFckSeosxSN6v+IMVXGvVeCHU4c1Os338mwhpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=tbWeLXKQ; arc=none smtp.client-ip=67.231.145.42
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658LaKHG2260246;
	Tue, 9 Jun 2026 02:02:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=Cv+/ZbeBqgKFmPKD8ZhKIiZQhiRZTiQJLulsYPJSwiw=; b=tbWeLXKQn7xc
	r4694naqKCp/vO5L1qUr07L3c/whphquEsgQwq+Aise3rNGuMlZjQDkNKFd3HW47
	k4rraZ6DHlT5wPIFfc5OasK86ONz6iC6HKgZUi/GvFIRaSoWl3FJivwNrlQcBpzP
	78Mr4d8ZSqjD0SjT/6Hb93QFG9aOuPsXu5lAhORQcTonvgyLWjtd5vBKDI0gZuGD
	LOrF9sTug1LblRp9J0MYR/lIN29EMadamKsFq66eTLs5tZ97CcRy/uSFyMT7Zf7X
	wSCYW3z8vpn3Z84TlaRhcivBx+ilHyE2i1mM6XW7FLNvAhSEX9vZiasxftYZyQtG
	g/ajqzuEDQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4en7jsu63x-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 09 Jun 2026 02:02:19 -0700 (PDT)
Received: from localhost (2620:10d:c085:208::7cb7) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.41; Tue, 9 Jun
 2026 09:02:18 +0000
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
To: <io-uring@vger.kernel.org>
CC: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
        Jens Axboe
	<axboe@kernel.dk>
Subject: [PATCH liburing v2 1/3] Update uapi headers to add ZCRX notification
Date: Tue, 9 Jun 2026 02:01:48 -0700
Message-ID: <20260609090156.3862920-2-cleger@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA4MyBTYWx0ZWRfX/5C497WYGRB3
 QRzwbhvwgeLvbJW7QmnfGjemsYOnlJVN4ilb3cDydf6YjUKrqTMesc3pzYB1UnHq+UDp5DHVDKO
 5M4tH8RNxkzVziflUfEOAcWTzpqT5PsdEhifaxEf0uK6434e6b+Xj7o/Jy2qOhRykg2AYdtZXNp
 Bk8aLGzTioqIgKYPBqpVZ6jbdwTYgEeWPElsnhzAbPU7AZdLn/zxA4h4ynLJ/jyLZSbkMS9i/UA
 RsypIYui5prJ/XmupOyjh3xOS2jU8O3Ph54ksrj/CkiW7644YF+AZ/aNugdLEQ0tcqI6C4LL7XV
 IFdG11qRAeRo7bBoDMNcc7wc8dCIQAKIaV3lvbznWp7zNirYA3UfWhVOJLhYARonfa5vjcd8xRc
 4sZPE/yqtUBo/s1LrKf2sRdGpWwqbDb7aFitXxRTF7JgYJcYHZYT7Q8ptAuwlz1t9o/p6BORm9T
 P7qaFGCJGbmCmoNof/g==
X-Authority-Analysis: v=2.4 cv=Fso1OWrq c=1 sm=1 tr=0 ts=6a27d69b cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=4h92JMTCafKA-fb_NiOh:22
 a=VabnemYjAAAA:8 a=MSChe4J9zM98ecmaqjIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: e7bOT7l7APmm_WO5avUj7rTYOCB3ePYC
X-Proofpoint-ORIG-GUID: e7bOT7l7APmm_WO5avUj7rTYOCB3ePYC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_01,2025-10-01_01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.49 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.67)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13650-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:cleger@meta.com,m:axboe@kernel.dk,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp,meta.com:dkim,meta.com:email,meta.com:mid,meta.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7500465E211

Extend the ZCRX uapi with notification infrastructure: notification
types (no-buffers, copy-fallback), stats structure, notification
descriptor for registration and arm control operation.

A new IORING_REGISTER_QUERY op allows userspace to discover the
notification stats memory layout. Additionnal flags are as well required
to register the statistics structure and enable notification upon
registration.

Signed-off-by: Clément Léger <cleger@meta.com>
---
 src/include/liburing/io_uring.h       | 36 ++++++++++++++++++++++++++-
 src/include/liburing/io_uring/query.h | 12 +++++++++
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index b9ec1ebf..00f5940a 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -1069,6 +1069,32 @@ enum zcrx_features {
 	 * value in struct io_uring_zcrx_ifq_reg::rx_buf_len.
 	 */
 	ZCRX_FEATURE_RX_PAGE_SIZE	= 1 << 0,
+	ZCRX_FEATURE_NOTIFICATION	= 1 << 1,
+};
+
+enum zcrx_notification_type {
+	ZCRX_NOTIF_NO_BUFFERS,
+	ZCRX_NOTIF_COPY,
+
+	__ZCRX_NOTIF_TYPE_LAST,
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
@@ -1086,12 +1112,14 @@ struct io_uring_zcrx_ifq_reg {
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
@@ -1105,6 +1133,11 @@ struct zcrx_ctrl_export {
 	__u32 		__resv1[11];
 };
 
+struct zcrx_ctrl_arm_notif {
+	__u32		notif_type;
+	__u32		__resv[11];
+};
+
 struct zcrx_ctrl {
 	__u32	zcrx_id;
 	__u32	op; /* see enum zcrx_ctrl_op */
@@ -1113,6 +1146,7 @@ struct zcrx_ctrl {
 	union {
 		struct zcrx_ctrl_export		zc_export;
 		struct zcrx_ctrl_flush_rq	zc_flush;
+		struct zcrx_ctrl_arm_notif	zc_arm_notif;
 	};
 };
 
diff --git a/src/include/liburing/io_uring/query.h b/src/include/liburing/io_uring/query.h
index 0b624817..5655035a 100644
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
+	__u32 __resv1;
+	__u64 __resv2[4];
+};
+
 struct io_uring_query_scq {
 	/* The SQ/CQ rings header size */
 	__u64 hdr_size;
-- 
2.52.0


