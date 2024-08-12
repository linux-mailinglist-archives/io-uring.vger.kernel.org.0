Return-Path: <io-uring+bounces-2697-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2623494E410
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 02:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2A701F2123D
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 00:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB9883FF1;
	Mon, 12 Aug 2024 00:47:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A7F4A1C
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 00:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723423641; cv=none; b=gM/bbJqqo4dQsTqnz7PLVxnqI4h6xGaSPrzz71Thfm/2tjCQEJPponSWMvTdrVSKrwmGh/cSTfT4yzjhsBf8FJKRDtf95FomR/kyK5Kiube0E2pZNC0SQf9elHnQDldFuFV8jJPNXjVqTNgN44Mc8X1wsUTHUZS82PaylFP0GGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723423641; c=relaxed/simple;
	bh=EBBmogkOQcmgxz70iRk4O6aK0r9u+kq7b/wrUiSCmXg=;
	h=From:Message-ID:To:Date:Subject; b=h784BHIn8RN1k+wQNxY3+lD/uvzEWeqzzVvSe28sA6MtDVF9rCUceEoqz6vSRfY0e4AEePYOQrqnb9DS8oUr+XyHOa4W5kiuzncxFK963faHmvSv/668KUruhggAfv4B2YFAYxUhTAS4Sk6i01ffv5GETckwVMcgd9XmME6m4zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=45824 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sdJDR-0006cc-2W;
	Sun, 11 Aug 2024 20:47:17 -0400
From: Olivier Langlois <olivier@trillion01.com>
Message-ID: <145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Date: Sun, 11 Aug 2024 20:34:46 -0400
Subject: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

io_napi_entry() has 2 calling sites. One of them is unlikely to find an
entry and if it does, the timeout should arguable not be updated.

The other io_napi_entry() calling site is overwriting the update made
by io_napi_entry() so the io_napi_entry() timeout value update has no or
little value and therefore is removed.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/napi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 73c4159e8405..1de1d4d62925 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -26,7 +26,6 @@ static struct io_napi_entry *io_napi_hash_find(struct hlist_head *hash_list,
 	hlist_for_each_entry_rcu(e, hash_list, node) {
 		if (e->napi_id != napi_id)
 			continue;
-		e->timeout = jiffies + NAPI_TIMEOUT;
 		return e;
 	}
 
-- 
2.46.0


