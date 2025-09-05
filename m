Return-Path: <io-uring+bounces-9589-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1F4B4545C
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 12:18:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 300095A351D
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 10:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DB902D46CB;
	Fri,  5 Sep 2025 10:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VjpE062b"
X-Original-To: io-uring@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E422D373E
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 10:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757067520; cv=none; b=iV4K3744cnS43Afei0P3O3Kqtf462vM5GLGB6bli5C+FBaWZDeLm/SzZLkeRKHcc+TDNP6T4IryNgKcmdUjPBPV4zESF3mwUAunpMPiQm9hlSntk+fyZc0FcItUsRQL8N/HuwRFNvuY3dhewaEessDnv4h99jOod7DveOKQ0CDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757067520; c=relaxed/simple;
	bh=TXVtCNbtQ2lodx5EpXTUy9FKIYa9RVGmy3ldANp/kmM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tBSutToAPNN9Ad2NeTrYnfynJKw0hglBg41i9Q3GMgPD0o7yZDDBNJaOfx1Lsndprjko1zI7mpEJu0Cfysu4IXBOQ+UyL9exJeCcUv1wXSKwjeIhY10SSf0g8af0iGdYUfAqXGFuO2IgI1SGqjmgMn/n3pd3qG+8nSTMmrfS0/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VjpE062b; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757067516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HXldozByKM3yK+U8GWEAxToMUD6d/zDohGXXBFjaHwc=;
	b=VjpE062b3Re82VNivDyWmMJiN+k88Sve0KPxH+Sd5mORtfPkXNNCeFCuQ+e47EJi5556+a
	Yhbb3Y1bGik1EhPRiFfxU7sugWLWBAINV88UoKhwAX1DVk53wNHcn6KvuJ7RDg0O9u3Mj8
	oUkWiM6z+wimeMpNb0sr7rYx7AdIeBY=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: Replace kzalloc() + copy_from_user() with memdup_user()
Date: Fri,  5 Sep 2025 12:18:17 +0200
Message-ID: <20250905101817.392834-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace kzalloc() followed by copy_from_user() with memdup_user() to
improve and simplify io_probe().

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 io_uring/register.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index a59589249fce..306252f11475 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -46,13 +46,9 @@ static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 		nr_args = IORING_OP_LAST;
 
 	size = struct_size(p, ops, nr_args);
-	p = kzalloc(size, GFP_KERNEL);
-	if (!p)
-		return -ENOMEM;
-
-	ret = -EFAULT;
-	if (copy_from_user(p, arg, size))
-		goto out;
+	p = memdup_user(arg, size);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
 	ret = -EINVAL;
 	if (memchr_inv(p, 0, size))
 		goto out;
-- 
2.51.0


