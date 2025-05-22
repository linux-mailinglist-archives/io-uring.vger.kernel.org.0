Return-Path: <io-uring+bounces-8084-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4BEBAC0FD2
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 17:21:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 277203A355A
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 15:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B848298254;
	Thu, 22 May 2025 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wq7TZLNd"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5402980DE
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747927263; cv=none; b=uvUxbiM0ivdlyONauafD3ARS3bBqKuY0Oe73ci/Z40jhIEZFEoIDrNG0gh+03BpqUabIWoyk9YtXw+kTbSPr+If54lMGzGaUvGbzlPxs1HDx9BzdC3urZNYS9FTmsuuVjkuBG6AgjlY/DfUW/k/UXzq8M3veXCwEbNSm1R58YPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747927263; c=relaxed/simple;
	bh=SM2ZtiuFy7JBlVofkEdAeZdgOUGTnsXJwFWepvm8o3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtdQMht2GAw0pCFAGe/C8f5mWUyENf4GfaLyhn2Q/VxKOk6k+E1i77Hdh0jPxcUy5CCn7+1VxsxosXdiNQFGq+pVM6TNCKsG+UgZnx3juLuk/ZG4qej459g8FmLsa9b3LlFmR3zYQk+owtY95xca17+pBk+SL9CqWO8ql8EXqs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wq7TZLNd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747927260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d4Vqru2eKFiXCmx5up5YzH0fkWZCbnETiUU9gB6Y7AE=;
	b=Wq7TZLNdIU30hkzxSXYPWzRH4Cy+p8OeDj+Mcjs86HBwYPmsFXToqENgqZ6XqeOc0S3Eb1
	KHDK/e56ONDkywNQ0Fu/nMQQjEkXiYcVo4D5VHXCNtnBFj8cE7AmZgCPKG6t1FWxpow1mv
	WcpeTiR0UU3SLKEnpQUwn2IgdEgKYEU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-qFy3QHQ2NeOr-ohH3OPPSw-1; Thu,
 22 May 2025 11:20:56 -0400
X-MC-Unique: qFy3QHQ2NeOr-ohH3OPPSw-1
X-Mimecast-MFC-AGG-ID: qFy3QHQ2NeOr-ohH3OPPSw_1747927255
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0CB9B19560A0;
	Thu, 22 May 2025 15:20:55 +0000 (UTC)
Received: from localhost (unknown [10.72.116.39])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DE2A919560AB;
	Thu, 22 May 2025 15:20:53 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 1/2] io_uring: add helper io_uring_cmd_ctx_handle()
Date: Thu, 22 May 2025 23:20:39 +0800
Message-ID: <20250522152043.399824-2-ming.lei@redhat.com>
In-Reply-To: <20250522152043.399824-1-ming.lei@redhat.com>
References: <20250522152043.399824-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Add helper io_uring_cmd_ctx_handle() for driver to track per-context
resource, such as registered kernel io buffer.

Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring/cmd.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 0634a3de1782..53408124c1e5 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -140,6 +140,15 @@ static inline struct io_uring_cmd_data *io_uring_cmd_get_async_data(struct io_ur
 	return cmd_to_io_kiocb(cmd)->async_data;
 }
 
+/*
+ * Return uring_cmd's context reference as its context handle for driver to
+ * track per-context resource, such as registered kernel IO buffer
+ */
+static inline void *io_uring_cmd_ctx_handle(struct io_uring_cmd *cmd)
+{
+	return cmd_to_io_kiocb(cmd)->ctx;
+}
+
 int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 			    void (*release)(void *), unsigned int index,
 			    unsigned int issue_flags);
-- 
2.47.0


