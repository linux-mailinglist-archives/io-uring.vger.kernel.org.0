Return-Path: <io-uring+bounces-13116-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iOpOLway6GnIOwIAu9opvQ
	(envelope-from <io-uring+bounces-13116-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:33:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06CD24456CF
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:33:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6D020302E19C
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 11:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252AE3CFF72;
	Wed, 22 Apr 2026 11:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Tg6eEF7F"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07693CF67A;
	Wed, 22 Apr 2026 11:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776857372; cv=none; b=fs0Wl/MdPMZRxYYhncGRM4sZjYB5N2FL/bEUkAs08wo7w0COWIrsjxJMnpdFroxIqFoKRSip5OjLZYBErSTl23Cf62E57GjluMG7nz4hwHuqPorNDyHJOrW1K0EkPgrrwaEj/qNuaELRIOXKbo0AwcnxyilBW2NMa+AAeP7b9RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776857372; c=relaxed/simple;
	bh=8Yu9AhycblC0jgrvSU9P5Iijhr7hjgqaVjh7IVp+nBM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WofRxT+tw8QrwWIuHt/yzMVfXlhXhe16AFD2gvSXa3Yu57qG/sbe1I0w3MsbTh5fFwr5ZuEO8cVPusBzL5WzBzplKk+BoAMEH+TIJFDY8A+S4oPknWHqRl/3wZpCdPP1gkhCp4aIiUvdd7vM5blR7dLuOzk8KUTbNmLjR/6/DWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Tg6eEF7F; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0528006.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIbdCc460608;
	Wed, 22 Apr 2026 04:29:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=PI2w7VIQwHzslKjhFhmPmWwQ5wHNLy5oscyWVJBbvz0=; b=Tg6eEF7Fo4by
	aHUzi4rNFxTUwdJcP6SZTtAqPt243jDRSc3GEt/VfhRsoWAoYvogio0y+L2vmP1M
	4tcLKen1zQ6dGaxT9uUqMzN8aJh3dT8SSMW0cg0OEM7pLWptRb3HU7IMtFtp6m72
	FK46de5CNOEMACtJ8/la8GT1q7ZLri9Ao54WjY9WD2oQAPKicO8HAddJsM70efAH
	62cLr8qZbia5wAc1HWtPn2glPIK+VxkZw3siud1Hs+0DiZM/OBQv489qo3uAACNX
	zWt9FITZzArQrAinQf4wid6FUk9H12whXG+doYSErlok/uS2u+1oZ1FNjnxRw1CJ
	881ZOtj2vg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dpep9mnf5-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 22 Apr 2026 04:29:20 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:fe::f072) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Wed, 22 Apr
 2026 11:29:19 +0000
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
Subject: [PATCH 2/5] io_uring/zcrx: notify user on frag copy fallback
Date: Wed, 22 Apr 2026 04:25:13 -0700
Message-ID: <20260422112522.3316660-3-cleger@meta.com>
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
X-Authority-Analysis: v=2.4 cv=VYjH+lp9 c=1 sm=1 tr=0 ts=69e8b110 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=kkcUborcUVj0H7zxAXTl:22
 a=VabnemYjAAAA:8 a=wIfzXL8Z3gsHLL3D1c4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: 894fdtc0NQTca4-eDW-25f5S5VO3Vesp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDExMCBTYWx0ZWRfXygdFLHtkTFFe
 nsQMSPe8ubQ3ATPe8V/1/28fIibUTc8uvVg8/QC8Dr67TGIsAU2JXorbAHxtCTB1Az7zFgtosLI
 GpCbmEny2lwFNvQZwbdZDetlJnIRwy0HARDKZLBrUmsU3jicSdGygnPphWrACOxi0+KnBZouIH2
 XYKwDIMLTHPhjDdarPbWp7H2zbGobkZjtqgyrgrg4x1Px+LY4D9YaBT8Eou7+4Y5/yLLmlNqR2h
 8SkHQTJNVZtTb+JYZ2MN6qJa9390691leaEc1/G2js+k/NmtTWll/+Uo54n4ovporRXVgkPDXvh
 BUPsBkdiFzwipht+PWlXHlK93YWVEB0GKfJ3sSMQe/UTwmPr3t8VEMkPXIAGrIXdc0NPg/sXWi/
 UjTxksJAPLiVoueHyrlhcsONgyQzR3Pb4IK3N5ObzINZnzXwIUnEMDcqGm5gOt6YcDQQdpjRp8A
 Qruf4VgD0GvekbULTKQ==
X-Proofpoint-ORIG-GUID: 894fdtc0NQTca4-eDW-25f5S5VO3Vesp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Spamd-Result: default: False [1.05 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13116-lists,io-uring=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,meta.com:dkim,meta.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 06CD24456CF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a ZCRX_NOTIF_COPY notification type to signal userspace when a
received fragment could not be delivered using zero-copy and was
instead copied into a buffer.

Signed-off-by: Clément Léger <cleger@meta.com>
---
 include/uapi/linux/io_uring/zcrx.h | 1 +
 io_uring/zcrx.c                    | 7 ++++++-
 io_uring/zcrx.h                    | 3 ++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring/zcrx.h b/include/uapi/linux/io_uring/zcrx.h
index b8596d7d47b6..e0c0079626c8 100644
--- a/include/uapi/linux/io_uring/zcrx.h
+++ b/include/uapi/linux/io_uring/zcrx.h
@@ -70,6 +70,7 @@ enum zcrx_features {
 
 enum zcrx_notification_type {
 	ZCRX_NOTIF_NO_BUFFERS = 1 << 0,
+	ZCRX_NOTIF_COPY = 1 << 1
 };
 
 struct zcrx_notification_desc {
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 35ca28cb6583..732e585aa13a 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1510,8 +1510,13 @@ static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			     const skb_frag_t *frag, int off, int len)
 {
 	struct page *page = skb_frag_page(frag);
+	int ret;
+
+	ret = io_zcrx_copy_chunk(req, ifq, page, off + skb_frag_off(frag), len);
+	if (ret > 0)
+		zcrx_send_notif(ifq, ZCRX_NOTIF_COPY);
 
-	return io_zcrx_copy_chunk(req, ifq, page, off + skb_frag_off(frag), len);
+	return ret;
 }
 
 static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 3ddebed06d57..1bd63adaa711 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -11,7 +11,8 @@
 #define ZCRX_SUPPORTED_REG_FLAGS	(ZCRX_REG_IMPORT | ZCRX_REG_NODEV)
 #define ZCRX_FEATURES			(ZCRX_FEATURE_RX_PAGE_SIZE |\
 					 ZCRX_FEATURE_NOTIFICATION)
-#define ZCRX_NOTIF_TYPE_MASK		(ZCRX_NOTIF_NO_BUFFERS)
+#define ZCRX_NOTIF_TYPE_MASK		(ZCRX_NOTIF_NO_BUFFERS |\
+					 ZCRX_NOTIF_COPY)
 
 struct io_zcrx_mem {
 	unsigned long			size;
-- 
2.52.0


