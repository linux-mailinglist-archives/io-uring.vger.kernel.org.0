Return-Path: <io-uring+bounces-6342-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F12A2FFD3
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 01:58:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BC7E3A53EF
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 00:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FB4155336;
	Tue, 11 Feb 2025 00:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="VTok1NaU"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908872FC23
	for <io-uring@vger.kernel.org>; Tue, 11 Feb 2025 00:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739235442; cv=none; b=ZSyaA9qGYQnRz60leUws8nB3CUAJYObQncIXhy+in+5hKrvdoq4sWkIq7kfjxxS7SrpOcJt7jN2ihViOzyuX4UtxF0Rng9DjycUeD2LlxEhnjjjmAZNBz47I5/elVlOEqxtVMvpvZpckJf6Nd4jY1EmG4YOQnl+YpdXGcTCRt9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739235442; c=relaxed/simple;
	bh=jbfXTxv7PoInJ1c76O3S84c82poazd/r/Env8Cx5+jM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HlWQdXHlIIKBW/dNhk2oEokxsj7tkWBFcPxI/linHELVs1/tYvDcVEjGJF9bq7ONW2mjgsCAN9+qGIXRRkj7RLEJ1OAY03kldSmK9SzPAq0rjWh9jwmUSr86jJwav9a4Xz4ahn6EQfSXkcvjs/zU+oXLWTSSe6gODV660867EOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=VTok1NaU; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51B0oXGS027408
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 16:57:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=rcrYmVDTZiDimYfKzmas6f3pvowE1zX2hEcw8Tz79WM=; b=VTok1NaUh7VY
	ahMhacfTwCmsHuymqoBfQMnhFAdWz6N0Vt+69Rj4+PTJTUhuaBqfn33ILJP2oVi+
	b16+8jdY1M4Jw4hTpuHZwU6n61lO27EhnkJ4Avx82ffks5FzyxeRYNyEdxHPTcFO
	PlpsHy9m+qcR76RydnKfqWfVGFokM5dcmD8boVWPu7gSY7O1TWN3rRUCY2/XYUme
	JRo7S0ZPW24Mkhpfui8jTmENEsGE1SoJhEoEikql3YiFBxFGfG/YMbsy61WXwen9
	Cfnj0lJXZfdCWSgetqy2GBvJTUHJ0TPGgSjDqoLrRymdLoogrvjBDm5U+IhQIwwP
	mtJpOFz2zg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44qpm92u3k-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 16:57:19 -0800 (PST)
Received: from twshared3076.40.frc1.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 11 Feb 2025 00:57:02 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 893A117E18F80; Mon, 10 Feb 2025 16:56:48 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 2/6] io_uring: create resource release callback
Date: Mon, 10 Feb 2025 16:56:42 -0800
Message-ID: <20250211005646.222452-3-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250211005646.222452-1-kbusch@meta.com>
References: <20250211005646.222452-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ISs5bEVAFiuusVbXEydkB0vhStvgERMy
X-Proofpoint-ORIG-GUID: ISs5bEVAFiuusVbXEydkB0vhStvgERMy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-11_01,2025-02-10_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

When a registered resource is about to be freed, check if it has
registered a release function, and call it if so. This is preparing for
resources that are related to an external component.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/rsrc.c | 2 ++
 io_uring/rsrc.h | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 4d0e1c06c8bc6..30f08cf13ef60 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -455,6 +455,8 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struc=
t io_rsrc_node *node)
 	case IORING_RSRC_BUFFER:
 		if (node->buf)
 			io_buffer_unmap(ctx, node);
+		if (node->release)
+			node->release(node->priv);
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index abd0d5d42c3e1..a3826ab84e666 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -24,6 +24,9 @@ struct io_rsrc_node {
 		unsigned long file_ptr;
 		struct io_mapped_ubuf *buf;
 	};
+
+	void (*release)(void *);
+	void *priv;
 };
=20
 struct io_mapped_ubuf {
--=20
2.43.5


