Return-Path: <io-uring+bounces-12827-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OPqOG6jAwmmjlQQAu9opvQ
	(envelope-from <io-uring+bounces-12827-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:49:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09463319616
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4AC223089DBF
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 16:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A6283FBEB0;
	Tue, 24 Mar 2026 16:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cDsm2LcA"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CF83FEB03
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 16:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370321; cv=none; b=Zs3ZLcgtMt2jSQQhFO6gRoIQhr80o4Y+HWYemRNDP1ZP/RZkxTELcUbW6UK6J2/OlddFM3V7bSyfFeKe9An6q94WpEMOOBVJ8tM7nIvcKMbYO9M+T4QIeaf2Cui5MEaVKfyWrV3nfbG82OiwXYEZ8iVkovwJhba2s1WJbipk2kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370321; c=relaxed/simple;
	bh=vEw+Sd85+ssE0jae8ad5e9A3xlxTL8/CZ4l6YfDHWPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRKFRZutYyQzvtPLveLAXLrXqzai7L7dt6D5M85vIkIH27ZCfJ3pyaGKdb+nmt/SSQzEL6/iNbdbznNcPk2hgDYzmIr9ZgNu0Lvcsr86vFvBE8mV7inqdZp7SqZmGTWr3N3ITaMmPrevsA8R9Mx2/pNoO99sJodyfu+DzR7Q8QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cDsm2LcA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774370318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+SEnONMO6QE0oD/ZVmTfJfXvNgK5ZzMqlqDV/cmRY9o=;
	b=cDsm2LcAJ7PCoLpdpv47lNZM0aK+m2m7Xcjx4WMrWhpgWCAoCuHaBv++zdu+dBOTgh7ST5
	6OS+bdG/SP6M0C5mnHg3xNpFVjg4NSqg5ZMgfIcsiV7PT3yYLoEWWiuCkZv04245dEabmI
	w6m7bUmzj9V3BbgOS1GWo0dsOaBsNz0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-JEfM5P_UPF2fyJRGREdgAA-1; Tue,
 24 Mar 2026 12:38:35 -0400
X-MC-Unique: JEfM5P_UPF2fyJRGREdgAA-1
X-Mimecast-MFC-AGG-ID: JEfM5P_UPF2fyJRGREdgAA_1774370314
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DB0B1800464;
	Tue, 24 Mar 2026 16:38:34 +0000 (UTC)
Received: from localhost (unknown [10.72.116.133])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9E9D319540C4;
	Tue, 24 Mar 2026 16:38:33 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 07/12] io_uring: bpf: add BPF buffer descriptor for IORING_OP_BPF
Date: Wed, 25 Mar 2026 00:37:28 +0800
Message-ID: <20260324163753.1900977-8-ming.lei@redhat.com>
In-Reply-To: <20260324163753.1900977-1-ming.lei@redhat.com>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12827-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 09463319616
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
index 3bf9be78a00a..6a265661bc20 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -453,6 +453,33 @@ enum io_uring_op {
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
2.53.0


