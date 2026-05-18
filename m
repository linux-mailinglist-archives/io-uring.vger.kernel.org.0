Return-Path: <io-uring+bounces-13411-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oDS1B9EzC2qgEgUAu9opvQ
	(envelope-from <io-uring+bounces-13411-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:44:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A026557037C
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6616A30AA98F
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 15:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756633F88B8;
	Mon, 18 May 2026 15:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="pEOj1Kxm"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1038C36CDE3;
	Mon, 18 May 2026 15:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779118591; cv=none; b=b4PxrNSqiNem8jUnGW+9pmDioAbUwzRAMw0bMtTb4Lv49V0xoHNsgyCO54FV0iu5zVuJbVaNfxfaiimO00EgjSESZzCIpdolmhqFxrbM1glM9nci7QSJpSySCe3uDnf53pFbxRt6DYWDRwU3pQBE32LEWE2IFcQa0GidTApnAfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779118591; c=relaxed/simple;
	bh=7u+hKOoWW66Y8kcYWNogf07t4JVPr6VZPCTE+rHo3EM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kSB4RgssKxNPgsbjmbavsOGv819PcwHtylJ7lPnpJOTkGkSQ75uoI6ztNNSqhlL1Jlj/iCielyS/bZJdBJmhgw1gcnYlX6cywmXsXOXRtfVef2ewxBlCpY3ARInIiBVsFJPgil7HZ8/vd5WfYV88qezFQaOyQNlzalOuVkM/sbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=pEOj1Kxm; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64I31jt01641348;
	Mon, 18 May 2026 08:36:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=hC/Q+HF3sh1W434WgFYdHA9Vrg7QRFbGt3rlf+dK6So=; b=pEOj1Kxmpstz
	8X/t8Cj0lnJb0G14rS2epxxOkQ78MNZUGFxQ6ngP/mnbneB+KxRo09GPEZylFSf6
	uz1bkN4eBdBKIBThP5gRvncqkTSOtA+qfl3GTbPArjXl//qJfa1qTbR6mtTRH2ZI
	gepCf/M/4SXOeWlvGh3iyA3EWTRAs0hDVCFKhee5dlVzvbnHiRUui4Xdl9AmEEaG
	J/VUcXvaLu5ZwE522B/D7iTIe5Nj9gRNPnRhgvMqidqUjB+wmaFXcrqLF6LQA+Ok
	mieYyv1S3zuW7FHbs7mfgu+24WUmodyBd5wIweJSMGJCYYk3DSrx6YhPmUP2fuT4
	KQEoS4L09A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4e7ab565a0-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 18 May 2026 08:36:21 -0700 (PDT)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Mon, 18 May
 2026 15:36:21 +0000
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
Subject: [PATCH v2 3/6] io_uring/zcrx: notify user on frag copy fallback
Date: Mon, 18 May 2026 08:35:26 -0700
Message-ID: <20260518153532.2835502-4-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260518153532.2835502-1-cleger@meta.com>
References: <20260518153532.2835502-1-cleger@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=XNQAjwhE c=1 sm=1 tr=0 ts=6a0b31f5 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=U_y8lYiYyhHBU5rMqhb2:22
 a=VabnemYjAAAA:8 a=wIfzXL8Z3gsHLL3D1c4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDE1MyBTYWx0ZWRfX0EDeXOgP5v7K
 4Fl5RY9RkJYG9nDEcdau3aw6fUXawfnXEFaepnGFB/WaWpq1fnBZ8LxGxBoc5+o/xiL+7F6b7Z0
 MpgUinlQB/n/CDFKdhAgcIRWtFanQPxRo5oQiIW64w+P6PmGZk4zdyYesC3vwI3lXg8rDivHr6G
 f6ODdhZyRKyFU/faY6byRQHWg4PJ/VVvmq47VGZaDD4hxyFVbN/NY1Q2ypJxepFxpm1PP3IAo3u
 gWOJWTTmCBC+HyL4A3Xt6FOzwdWXcOkGr6rOe8qZPf/LJehUL5Ko5gQKezB6bngt7lKvGpNd4B3
 bk6/l8G1dEti1POD5q1JmUlbWPf7I3ML5vDj7UGrgdrFL/CMWOxeOf/TxWzCo8REpKKdsD0qGgU
 omx8UTXZ3+v4wD4BOc70tdmfHr5m6WZD5XR8ylN70tJJJvBeIuV0M3/+53AesrtaS6FZOWprOv6
 h9Y8bdr2Xk4xwg1Xq2Q==
X-Proofpoint-ORIG-GUID: 9maH-ML0zefpJDOm0izlgR6sZCstVxHE
X-Proofpoint-GUID: 9maH-ML0zefpJDOm0izlgR6sZCstVxHE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_03,2026-05-18_01,2025-10-01_01
X-Spamd-Result: default: False [1.01 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.67)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13411-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[meta.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,meta.com:mid,meta.com:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: A026557037C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a ZCRX_NOTIF_COPY notification type to signal userspace when a
received fragment could not be delivered using zero-copy and was
instead copied into a buffer.

Signed-off-by: Clément Léger <cleger@meta.com>
---
 include/uapi/linux/io_uring/zcrx.h | 1 +
 io_uring/zcrx.c                    | 7 ++++++-
 io_uring/zcrx.h                    | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring/zcrx.h b/include/uapi/linux/io_uring/zcrx.h
index 67185566ad3c..3f7b72b09878 100644
--- a/include/uapi/linux/io_uring/zcrx.h
+++ b/include/uapi/linux/io_uring/zcrx.h
@@ -70,6 +70,7 @@ enum zcrx_features {
 
 enum zcrx_notification_type {
 	ZCRX_NOTIF_NO_BUFFERS,
+	ZCRX_NOTIF_COPY,
 
 	__ZCRX_NOTIF_TYPE_LAST,
 };
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 463fbaead35b..f31f2ca0f7ec 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1534,8 +1534,13 @@ static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
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
index cca10d0d02ac..203b3049e14b 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -11,7 +11,7 @@
 #define ZCRX_SUPPORTED_REG_FLAGS	(ZCRX_REG_IMPORT | ZCRX_REG_NODEV)
 #define ZCRX_FEATURES			(ZCRX_FEATURE_RX_PAGE_SIZE |\
 					 ZCRX_FEATURE_NOTIFICATION)
-#define ZCRX_NOTIF_TYPE_MASK		(1U << ZCRX_NOTIF_NO_BUFFERS)
+#define ZCRX_NOTIF_TYPE_MASK		((1U << ZCRX_NOTIF_NO_BUFFERS) | (1U << ZCRX_NOTIF_COPY))
 
 struct io_zcrx_mem {
 	unsigned long			size;
-- 
2.53.0-Meta


