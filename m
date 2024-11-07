Return-Path: <io-uring+bounces-4533-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1006B9C033C
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 12:03:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31CE61C21C63
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 11:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A39CF1F4280;
	Thu,  7 Nov 2024 11:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ips2zOeL"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11D91F4260
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 11:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730977373; cv=none; b=tHQtcRqoflTFg2BSo5o3GMMk+DYrz17Rm70UYNfZo9+Gk2/GssdCp9fO9rcOmon4DOmEqnSBxURKFBF42grW21mlZ3DMgqtBaiTy1wMbRimVVOViysJ4WSm3PIJT6NxsswoQ7umRc5zxPT3RrDUrAT22YCjZpxq/H5anaGNwyM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730977373; c=relaxed/simple;
	bh=NZJz+MfkbY392ub/DHGzxgS6cymJL7zcbYfAl3y7Pgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8i84coRj8nThL/Fj3rkMZt82EemFZQlRT8CcQGyRdNd4g6kEN38NQz7kYKWMvkFPN40xjMQeZRaXOxKCYN5QMp+IOwdWdhKNhThkLLmiMX7+BzpA8xK4mqLP0KH183076pKeKhAzx3J2ImPzLmKQR7LxdD2qghIyrgYW+Zptj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ips2zOeL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730977371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C1/P1RCfeEfoec5Dd70p3CI65Q7oJutsf47QDyw0okI=;
	b=Ips2zOeLO1TVZs2Uz5DvDYJl9FlIl8iROi8e8smwVFPkfBnYxm9nyyTFkTf2ianhwLax1E
	PbrYq+s1AucASrWglWSPO7TmUlkBQYZCKvkoZQXDwQo8vMtKmaD3tEJk/U9k/QaOOopSyg
	BPoWl/XIwTWiMxSK7ulK8cY3GrSRO3Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-400-fa_4EcmFMISrUjoD2tI3gA-1; Thu,
 07 Nov 2024 06:02:48 -0500
X-MC-Unique: fa_4EcmFMISrUjoD2tI3gA-1
X-Mimecast-MFC-AGG-ID: fa_4EcmFMISrUjoD2tI3gA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7AB21955D58;
	Thu,  7 Nov 2024 11:02:46 +0000 (UTC)
Received: from localhost (unknown [10.72.116.54])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7B826196BC05;
	Thu,  7 Nov 2024 11:02:45 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 11/12] io_uring/uring_cmd: support leasing device kernel buffer to io_uring
Date: Thu,  7 Nov 2024 19:01:44 +0800
Message-ID: <20241107110149.890530-12-ming.lei@redhat.com>
In-Reply-To: <20241107110149.890530-1-ming.lei@redhat.com>
References: <20241107110149.890530-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Add API of io_uring_cmd_lease_kbuf() for driver to lease its kernel
buffer to io_uring.

The leased buffer can only be consumed by io_uring OPs in group wide,
and the uring_cmd has to be one group leader.

This way can support generic device zero copy over device buffer in
userspace:

- create one sqe group
- lease one device buffer to io_uring by the group leader of uring_cmd
- io_uring member OPs consume this kernel buffer by passing IOSQE_IO_DRAIN
  which isn't used for group member, and mapped to GROUP_BUF.
- the kernel buffer is returned back after all member OPs are completed

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring/cmd.h |  7 +++++++
 io_uring/uring_cmd.c         | 10 ++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 578a3fdf5c71..0997ea247188 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -60,6 +60,8 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 /* Execute the request from a blocking context */
 void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
 
+int io_uring_cmd_lease_kbuf(struct io_uring_cmd *ioucmd,
+			    struct io_rsrc_node *node);
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
@@ -82,6 +84,11 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 {
 }
+static inline int io_uring_cmd_lease_kbuf(struct io_uring_cmd *ioucmd,
+					  struct io_rsrc_node *node);
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 /*
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index b62965f58f30..e7723759cb23 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -15,6 +15,7 @@
 #include "alloc_cache.h"
 #include "rsrc.h"
 #include "uring_cmd.h"
+#include "kbuf.h"
 
 static struct uring_cache *io_uring_async_get(struct io_kiocb *req)
 {
@@ -175,6 +176,15 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
+int io_uring_cmd_lease_kbuf(struct io_uring_cmd *ioucmd,
+			    struct io_rsrc_node *node)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_lease_group_kbuf(req, node);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_lease_kbuf);
+
 static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
-- 
2.47.0


