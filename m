Return-Path: <io-uring+bounces-8074-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 711CBAC0D58
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 15:53:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43EAA7B8E1D
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 13:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D8C28C01E;
	Thu, 22 May 2025 13:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cES1pueM"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1079828C2AD
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 13:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747921866; cv=none; b=K/eAKKhbC6yl0HK0vNpCm8ENqLCpS1a3rAeuv12daVylxCjvz9zuc0BS+GNF8tL59AdaTYSuCK7xNNIjoWwRq1CTlSa9XPqQoBki2ebgUbM1mmxQ5r2rticsetDnKffaMxYapTBwyI5Fd4tY81Mp4e49pt/mWsV3PYOfp8iuBN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747921866; c=relaxed/simple;
	bh=UARQdG7QTYiXgZW9weZ+29Yf+kc0R6+WPZIWEhqCrOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwgdxVC5kwDjH2aUXd9uWdUpMnWIyVikdZuPJvN7wm+9uAjAbi2NFfnPcFRBsp/Cc9wNqU33bjSXrmRZOODaWfWx0o1fx0ozfO5SVfLmoc6NAivYWfCTHeU+4lIsLqWoUNHQ7X5EIlItuPyBSawGOmG2rmHgtOCgnx47LjJou24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cES1pueM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747921863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MTch9e4t2kQwWUyMdecxW27qDhTjZ6cMji6wugW2Uik=;
	b=cES1pueMdkNwOnVOBE0ri8+14FO1Tbz5JKn8mgQga6pURl+ZSA+6SQztqpewdsAgna9pdS
	/GrsjY+UYTfFA2LCVpg01FjG6EBK/BNuyafTb1raVZpCECcwO92h0QdSC0pvJOvgx9tM9U
	VpKceBtvyP/M9quewJYgZNChFkx1aZY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-326-gO7ohxXZNRGvk44biQ3tPw-1; Thu,
 22 May 2025 09:51:02 -0400
X-MC-Unique: gO7ohxXZNRGvk44biQ3tPw-1
X-Mimecast-MFC-AGG-ID: gO7ohxXZNRGvk44biQ3tPw_1747921861
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED8241800570;
	Thu, 22 May 2025 13:51:00 +0000 (UTC)
Received: from localhost (unknown [10.72.116.39])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF8E71944DFF;
	Thu, 22 May 2025 13:50:59 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 1/2] io_uring: add helper io_uring_cmd_ctx_handle()
Date: Thu, 22 May 2025 21:50:42 +0800
Message-ID: <20250522135045.389102-2-ming.lei@redhat.com>
In-Reply-To: <20250522135045.389102-1-ming.lei@redhat.com>
References: <20250522135045.389102-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add helper io_uring_cmd_ctx_handle() for driver to track per-context
resource, such as registered kernel io buffer.

Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring/cmd.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 0634a3de1782..92d523865df8 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -140,6 +140,15 @@ static inline struct io_uring_cmd_data *io_uring_cmd_get_async_data(struct io_ur
 	return cmd_to_io_kiocb(cmd)->async_data;
 }
 
+/*
+ * Return uring_cmd's context reference as its context handle for driver to
+ * track per-context resource, such as registered kernel IO buffer
+ */
+static inline unsigned long io_uring_cmd_ctx_handle(struct io_uring_cmd *cmd)
+{
+	return (unsigned long)cmd_to_io_kiocb(cmd)->ctx;
+}
+
 int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 			    void (*release)(void *), unsigned int index,
 			    unsigned int issue_flags);
-- 
2.47.0


