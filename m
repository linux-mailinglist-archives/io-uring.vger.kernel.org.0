Return-Path: <io-uring+bounces-1852-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04EBB8C1D34
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 05:51:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3612C1C2178F
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 03:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C22B7171A7;
	Fri, 10 May 2024 03:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MFu0IJtW"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEC1149C56
	for <io-uring@vger.kernel.org>; Fri, 10 May 2024 03:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715313050; cv=none; b=joCfej5t7SAYtlZx6rdouxuwwpiZt4Hz7zEk3S6ZofdyNZBgvfk4LRyn35KEPsGtjmUbTR0S7HnDKr8YkJ/RgPEFZ+pyQPFIrnmrO+J+cZ/yXumaGs4NggzkaXj2KTmIl1RJfHAe020hlRPHATtfT+4kEq8+kK3noLLu5APA1gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715313050; c=relaxed/simple;
	bh=IVCkJCiOABWzxjCH/t7/nMwNUwuLt4iI1yIP9Yui0Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPsoSyEi5nnjn2qQJP5uaBI6nkRf+z1q9Ue2W7KDtef+o04+UA9ZqjBKQvUcMkfYBIJlIILgk0LNmz6ovOpEuABhIGwyIjoWKJWhr8oz2vtu3oxlDxE6bM1xJKzPley+ZV1uSg/i2GvDW7UDwHaoMHdxj7RKmBLKahHknQmJBPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MFu0IJtW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715313047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j8FluV5Q9vpqiSeY3lSHVZET6tI/O0uYgS5WdWWBERE=;
	b=MFu0IJtWPkv1jEWYTXZWB2J88y4UV0WZhlftCxhkeIQml4A19q7xggtEGtXbCP4jRlaM29
	M8pl7S4YuvAdxQzbAyAWFC66npwyqcAXNwlXdKDlyIDGT1x80pZm4XmvNnviKZBN4UfTbM
	OQG0t96XU4e8QIHfGCC4fVbJSRUu3HU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-Jm57ilPRO9-76Ep_zByzSA-1; Thu, 09 May 2024 23:50:41 -0400
X-MC-Unique: Jm57ilPRO9-76Ep_zByzSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E5078009F8;
	Fri, 10 May 2024 03:50:41 +0000 (UTC)
Received: from localhost (unknown [10.72.116.53])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E7192087D7B;
	Fri, 10 May 2024 03:50:40 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH V2 1/2] io_uring: fail NOP if non-zero op flags is passed in
Date: Fri, 10 May 2024 11:50:27 +0800
Message-ID: <20240510035031.78874-2-ming.lei@redhat.com>
In-Reply-To: <20240510035031.78874-1-ming.lei@redhat.com>
References: <20240510035031.78874-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

The NOP op flags should have been checked from beginning like any other
opcode, otherwise NOP may not be extended with the op flags.

Given both liburing and Rust io-uring crate always zeros SQE op flags, just
ignore users which play raw NOP uring interface without zeroing SQE, because
NOP is just for test purpose. Then we can save one NOP2 opcode.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Fixes: 2b188cc1bb85 ("Add io_uring IO interface")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/nop.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/nop.c b/io_uring/nop.c
index d956599a3c1b..1a4e312dfe51 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -12,6 +12,8 @@
 
 int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	if (READ_ONCE(sqe->rw_flags))
+		return -EINVAL;
 	return 0;
 }
 
-- 
2.42.0


