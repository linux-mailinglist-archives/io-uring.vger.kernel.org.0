Return-Path: <io-uring+bounces-12830-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KPoGOzDAwmmjlQQAu9opvQ
	(envelope-from <io-uring+bounces-12830-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:47:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 540B7319527
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:47:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 58C7B30DB44A
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 16:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16183FE34E;
	Tue, 24 Mar 2026 16:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="irSo/l3b"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798953DDDCD
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 16:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370332; cv=none; b=mg4lW0Ljmyk0/2gxusUGcoAWEwhxwNthbnnWc09F8SH69gVPzncUx006INv2fBTEiyWJ+Qdd9QoATrls5otpWxA/fxyDlKnqitGKOpitYCkapvc2ouygNwUWuZ3xOml4XfkYFZVD3U2mfduBDrYRDUZkjJbjG4UagBL7VJPw6A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370332; c=relaxed/simple;
	bh=cncIqUSfvysDO7PSc/IByimFiUn2+USMFyKGt+tqdzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jw1849vJhG3MWaTurSnpp+DK3/EWa6px9hT8FwhClgAVBQ9GcTHuBOOxDejzSp4MegnWYneE/HpK8bmlMiB+j5YW+jmoGa6NDhqfpUN1Ft5kulyR+t2u2+bDo+XXMVLg6MR60z4ohSjWGbUeTDPk7rpiG2iqs9CIlj7NviY4W4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=irSo/l3b; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774370330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xr0nNqOTEoDj3cLYSR2qyb0IFCzRzlPzF6LCm0TFjh4=;
	b=irSo/l3bUCRjEn+gr/w7T5mQhn9+azw+yZ75yxIlBnGfHqH7ZjGsDc4kWDWDRviz+Vt8iw
	IZWdHEdMK0pGYEKTaP1nfMxGvCyjdRIFSkp4Y+7AlzX92KeGAdQY2qdtWftbO2lJQpGA2u
	6oBvkE6gfVXIX7VO6AZHRfB17rCG+hs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-s6TV0vERN7O6NOYDHLqjdA-1; Tue,
 24 Mar 2026 12:38:47 -0400
X-MC-Unique: s6TV0vERN7O6NOYDHLqjdA-1
X-Mimecast-MFC-AGG-ID: s6TV0vERN7O6NOYDHLqjdA_1774370325
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1608180034F;
	Tue, 24 Mar 2026 16:38:45 +0000 (UTC)
Received: from localhost (unknown [10.72.116.133])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0F2BC180035F;
	Tue, 24 Mar 2026 16:38:44 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 10/12] selftests/io_uring: add io_uring_unregister_buffers()
Date: Wed, 25 Mar 2026 00:37:31 +0800
Message-ID: <20260324163753.1900977-11-ming.lei@redhat.com>
In-Reply-To: <20260324163753.1900977-1-ming.lei@redhat.com>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12830-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 540B7319527
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add io_uring_unregister_buffers(), so that kernel selftest can call it
explicitly.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 tools/include/io_uring/mini_liburing.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/include/io_uring/mini_liburing.h b/tools/include/io_uring/mini_liburing.h
index 44be4446feda..b9163a41024f 100644
--- a/tools/include/io_uring/mini_liburing.h
+++ b/tools/include/io_uring/mini_liburing.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: MIT */
 
 #include <linux/io_uring.h>
+#include <signal.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <stdio.h>
@@ -284,6 +285,15 @@ static inline int io_uring_register_buffers(struct io_uring *ring,
 	return (ret < 0) ? -errno : ret;
 }
 
+static inline int io_uring_unregister_buffers(struct io_uring *ring)
+{
+	int ret;
+
+	ret = syscall(__NR_io_uring_register, ring->ring_fd,
+		      IORING_UNREGISTER_BUFFERS, NULL, 0);
+	return (ret < 0) ? -errno : ret;
+}
+
 static inline void io_uring_prep_send(struct io_uring_sqe *sqe, int sockfd,
 				      const void *buf, size_t len, int flags)
 {
-- 
2.53.0


