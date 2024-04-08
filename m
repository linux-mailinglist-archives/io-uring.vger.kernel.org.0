Return-Path: <io-uring+bounces-1448-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CABB89B4F9
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 03:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE9E91F213CC
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 01:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A79263A;
	Mon,  8 Apr 2024 01:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J8hs9DS6"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3E6EBB
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 01:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712538234; cv=none; b=mWn0i1fO/CPD95Lz/cM50XA0MXV8Qn4HevgjABuclfkxcgCZm8d2KnSy3Nw6vlUcuncyxkPkUTG+mLzKUf7lfHjCjVbgpSYzh/D4acwKIN81A4pKBwy8+Wz7mZePJJbZOd21ScMIC+icKE+aV86T0tbTKB8pG7S0Xnl9ffzb0MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712538234; c=relaxed/simple;
	bh=Oof9IwYPFSTPeqyQDdc6SupoIfPpdAP/Y7xlesSnToE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLT17x74IAoXb1t4ZFnz3//hKzXolJD0K22Ide09FC5pIc+SKO7G9FKC3dq0ac7/T6k2IO46llCWa8W7w5a2qHy/G0SBwMuOWhBgYwZqTb8/lRj1RY0w+uf1y56R0r6lyQQWY8zg7EUPivT9CneD2k6jvb3roGCXQM868/3zdlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J8hs9DS6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712538232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w5kd2QgByI9r4402byTbewzH9k1skSighT9jtbHwX60=;
	b=J8hs9DS6k4wjHqNP/anMDJe1qRMELf0G7yGE15iP4T8WwDPyw9puX3vU40VPJIyqVT0+Ag
	FTtaxndhWHCUCgNcjMgb+6W4CqOvcHcTALFUmwPkr1ettgmGSb+Alp30RLpvNm7/Rei1pD
	vmidSzLJPCJfw8QT9qqiLvql/+gB/vI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-2kYpbW4pNbiLMujqyrIZrA-1; Sun, 07 Apr 2024 21:03:49 -0400
X-MC-Unique: 2kYpbW4pNbiLMujqyrIZrA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4976927A69;
	Mon,  8 Apr 2024 01:03:48 +0000 (UTC)
Received: from localhost (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 74ACAC27EAA;
	Mon,  8 Apr 2024 01:03:47 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 1/9] io_uring: net: don't check sqe->__pad2[0] for send zc
Date: Mon,  8 Apr 2024 09:03:14 +0800
Message-ID: <20240408010322.4104395-2-ming.lei@redhat.com>
In-Reply-To: <20240408010322.4104395-1-ming.lei@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

send_zc never uses any byte in sqe->__pad2[], and the check is
unnecessary, so remove it and prepare for using the last byte
as sqe extended flags.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 97d815d13b6a..9c0567892945 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -997,7 +997,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	zc->done_io = 0;
 
-	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
+	if (unlikely(READ_ONCE(sqe->addr3)))
 		return -EINVAL;
 	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
 	if (req->flags & REQ_F_CQE_SKIP)
-- 
2.42.0


