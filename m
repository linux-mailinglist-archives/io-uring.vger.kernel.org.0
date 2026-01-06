Return-Path: <io-uring+bounces-11407-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 277A1CF7B21
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:12:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D5EB7301E15A
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D0A1A256E;
	Tue,  6 Jan 2026 10:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FrdoLcUA"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29558309EF0
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694334; cv=none; b=eIuozmS/6OU/mfwNB54v2iL/nXCySIhmHVbkvLgZCCGug4cJN8w6axIWIFqDjPwpQIoAVO+IdKEj/vmdQIuT4+xubeCfgGtPtbELRd4Goht6CPv+jPOnYAqbwaGgOzZfkyZkimLL1Kov20fSgAf1iV2EqiSQmvhscuY5mw1n6L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694334; c=relaxed/simple;
	bh=7DGtW3rVAwIiydj7lC4sP2ThubENudQahThMjUz4oKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeGMdX2ZTU/jaDzj6OJcS3W+KkUJOdQtc/atiNHrpLoA1tGI5z+IgMm90oqlcuRaBRulLtobmCwZZsWUckZwGK9OkIZgWxT22LzXFR8r+o9fqiz6Bb7AMKGbRZcB2veH/xR5B5UZ/VrlBl7ZiavpobuV5tVVecFRgoOY09x8mrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FrdoLcUA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FuYcErdMtRH1a4Kiq2Sz4xwkFCIxBBpBHYiXVctiRj8=;
	b=FrdoLcUAEOJXpF8xcCwv7MBLLK1pzH0BOPPg1HYUwOE2shKxybqPzKDSCY9E85oh50xRAF
	OMTGy8d+NEKXFC0w1VqdDoe+iP+3z2hMuTcHWhGrVSPe8JTxFiy8OIVmrdmzRxCnGZQLJf
	9gzcIT0yYm9HIRbO3Bo1OsEtGSvzXqA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-348-oNibR4heNq6cLa1ZfdF9ig-1; Tue,
 06 Jan 2026 05:12:07 -0500
X-MC-Unique: oNibR4heNq6cLa1ZfdF9ig-1
X-Mimecast-MFC-AGG-ID: oNibR4heNq6cLa1ZfdF9ig_1767694326
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C60619560B2;
	Tue,  6 Jan 2026 10:12:05 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 749CC30001A7;
	Tue,  6 Jan 2026 10:12:04 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 07/13] io_uring: bpf: add BPF buffer descriptor for IORING_OP_BPF
Date: Tue,  6 Jan 2026 18:11:16 +0800
Message-ID: <20260106101126.4064990-8-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Add io_bpf_buf_desc struct and io_bpf_buf_type enum to describe
buffer parameters for IORING_OP_BPF kfuncs. Supports plain userspace,
registered, vectored, and registered vectored buffer types.

Registered buffers (FIXED, KFIXED, REG_VEC) refer to buffers
pre-registered with io_uring and can be either userspace or kernel
buffers depending on how they were registered.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/uapi/linux/io_uring.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 441a1038a58a..113d8c7b8e05 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -433,6 +433,33 @@ enum io_uring_op {
 #define IORING_BPF_OP_BITS	8
 #define IORING_BPF_OP_SHIFT	24
 
+/*
+ * BPF buffer descriptor types.
+ *
+ * Registered buffers (FIXED, KFIXED, REG_VEC) refer to buffers pre-registered
+ * with io_uring. These can be either userspace or kernel buffers depending on
+ * how they were registered.
+ *
+ * For KFIXED, addr is an offset from the registered buffer start.
+ * For REG_VEC with kernel buffers, each iov.iov_base is offset-based.
+ */
+enum io_bpf_buf_type {
+	IO_BPF_BUF_USER		= 0,	/* plain userspace buffer */
+	IO_BPF_BUF_FIXED	= 1,	/* registered buffer (absolute address) */
+	IO_BPF_BUF_VEC		= 2,	/* vectored buffer (iovec array) */
+	IO_BPF_BUF_KFIXED	= 3,	/* registered buffer (offset-based) */
+	IO_BPF_BUF_REG_VEC	= 4,	/* registered vectored buffer */
+};
+
+/* BPF buffer descriptor for IORING_OP_BPF */
+struct io_bpf_buf_desc {
+	__u8  type;		/* IO_BPF_BUF_* */
+	__u8  reserved;
+	__u16 buf_index;	/* registered buffer index (FIXED/KFIXED/REG_VEC) */
+	__u32 len;		/* length (non-vec) or nr_vecs (vec types) */
+	__u64 addr;		/* userspace address, iovec ptr, or offset (KFIXED) */
+};
+
 /*
  * cqe.res for IORING_CQE_F_NOTIF if
  * IORING_SEND_ZC_REPORT_USAGE was requested
-- 
2.47.0


