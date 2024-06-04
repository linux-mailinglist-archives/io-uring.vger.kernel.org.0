Return-Path: <io-uring+bounces-2090-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC628FB326
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 15:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA817282573
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 13:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05F7146016;
	Tue,  4 Jun 2024 13:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="s8RLdmUb"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212A9144D2E;
	Tue,  4 Jun 2024 13:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717506337; cv=none; b=WXQsVMYZN47uAiYNcMTS+J1rgddn3hxcVDmayuNZQscvM//8NPP6jzLWfhfmkypIwLjHFCBfcgC1I9iy+bfMIVkeBC38guHCkbHgvaUpYoQbMqeojXAURgGnvHRvbSmpHRqT55qdxvsfS1JnmI9xO7s9u0BHXdpqHi8i9RkjxF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717506337; c=relaxed/simple;
	bh=w4G3vk3yGRoYokSs4XfRHyLnA6vOC8gki8MNmf6avxg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=E6oMJMAY7dwsMcc4/kKyEOp4UGyE1DWKq63I9IUs5fPgkj82dcm3VtyVvYd20cnw+pKCqwl6Ehdqqu+Esr8KdHvSOZLwP+5SDlgLWEk66YKeQBgSnCjwDHRvKseDiT3hmF9iVS2BrATJvj594XgWbreyeIGhTpHvoLgiQ4mziNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=s8RLdmUb; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1717506336; x=1749042336;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tNtONfHPFlDZf3t3YUJODvwLfbp2sSOE5aYh5N9nCfk=;
  b=s8RLdmUbHYxHgJ/TFPUIWY8Bsb5CwucPerKPzslBipBJoNT3ryw0GpeJ
   2XR7jCd4qL+odWU/Ng8xWPniC36HwoKc5ogBGScn6OTkfJfJ35cDRxMh7
   RXnMFPT2Rq/JQJUS6Ik6ycTRA+u0yC2JPhgWyhb4yfjOBxuIB38cszFiI
   A=;
X-IronPort-AV: E=Sophos;i="6.08,213,1712620800"; 
   d="scan'208";a="405516568"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2024 13:05:33 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:9945]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.14.23:2525] with esmtp (Farcaster)
 id 5fb5735b-b0c2-43e5-8e58-813e3c2a75b8; Tue, 4 Jun 2024 13:05:31 +0000 (UTC)
X-Farcaster-Flow-ID: 5fb5735b-b0c2-43e5-8e58-813e3c2a75b8
Received: from EX19D002EUA004.ant.amazon.com (10.252.50.181) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Tue, 4 Jun 2024 13:05:31 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D002EUA004.ant.amazon.com (10.252.50.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 4 Jun 2024 13:05:31 +0000
Received: from dev-dsk-hagarhem-1b-b868d8d5.eu-west-1.amazon.com
 (10.253.65.58) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server id 15.2.1258.28 via Frontend Transport; Tue, 4 Jun 2024 13:05:30 +0000
Received: by dev-dsk-hagarhem-1b-b868d8d5.eu-west-1.amazon.com (Postfix, from userid 23002382)
	id 569ED20C69; Tue,  4 Jun 2024 13:05:30 +0000 (UTC)
From: Hagar Hemdan <hagarhem@amazon.com>
To:
CC: Maximilian Heyne <mheyne@amazon.de>, Norbert Manthey <nmanthey@amazon.de>,
	Hagar Hemdan <hagarhem@amazon.com>, Jens Axboe <axboe@kernel.dk>, "Pavel
 Begunkov" <asml.silence@gmail.com>, <io-uring@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] io_uring: fix possible deadlock in io_register_iowq_max_workers()
Date: Tue, 4 Jun 2024 13:05:27 +0000
Message-ID: <20240604130527.3597-1-hagarhem@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The io_register_iowq_max_workers() function calls io_put_sq_data(),
which acquires the sqd->lock without releasing the uring_lock.
Similar to the commit 009ad9f0c6ee ("io_uring: drop ctx->uring_lock
before acquiring sqd->lock"), this can lead to a potential deadlock
situation.

To resolve this issue, the uring_lock is released before calling
io_put_sq_data(), and then it is re-acquired after the function call.

This change ensures that the locks are acquired in the correct
order, preventing the possibility of a deadlock.

Suggested-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
---
only compile tested.
---
 io_uring/register.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/register.c b/io_uring/register.c
index ef8c908346a4..c0010a66a6f2 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -355,8 +355,10 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	}
 
 	if (sqd) {
+		mutex_unlock(&ctx->uring_lock);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
+		mutex_lock(&ctx->uring_lock);
 	}
 
 	if (copy_to_user(arg, new_count, sizeof(new_count)))
@@ -380,8 +382,10 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	return 0;
 err:
 	if (sqd) {
+		mutex_unlock(&ctx->uring_lock);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
+		mutex_lock(&ctx->uring_lock);
 	}
 	return ret;
 }
-- 
2.40.1


