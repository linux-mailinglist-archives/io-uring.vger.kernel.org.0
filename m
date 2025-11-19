Return-Path: <io-uring+bounces-10667-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D360BC715A3
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 23:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7B38A34FA28
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 22:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 193533376A5;
	Wed, 19 Nov 2025 22:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="CPfhLjmx"
X-Original-To: io-uring@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC35320CA2;
	Wed, 19 Nov 2025 22:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763592175; cv=none; b=YeG1w57OXpIvGx8+9apvF/daU6+APvOJGtsw8s52IrK3+LOSe5GYKPZU5t7uUqy8i34Uei/rQ9EEz6EBDu7Q0GsZGo7kknWYXXRv2LdfMdnW2j+GElA3qM4GJhfqbA/RJcnIhLRwpEAkaUEJiSldtkle6T+hfaPpjUhzi8kP9D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763592175; c=relaxed/simple;
	bh=EHCU7lsqTITN0JArAIrf/ydpOv9qgaNKENZvKoKlquA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tNgH7qlz3nSj3mE5xhR7gjf0X3+VjgH79tQRguogTf+fExglYMh45g+ylggkZG9U29pgpHi8Ot0Gh7rVh/NLvvzSK4IZRnE4Xn0fvwO7wfQeHGCvuHPSuO+V4gPJbRX9CFZcjORlsYKdyOjmL9nXzHIjmaacEdCrZeTVgLx/E8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=CPfhLjmx; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqt0-006kxN-Hf; Wed, 19 Nov 2025 23:42:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
	:Message-Id:Date:Subject:Cc:To:From;
	bh=ffasTl97fub2t0VouM2GGBABLZMcuYWcFCpA19DY7Nw=; b=CPfhLjmxH+S1BU+z+2EBjHlhfE
	VibMWwBHqw3qoHwq3ZSO9Mgv1/OYHLTyGjl8miE8wG/0w1c0Rfsauknv2vxZZ5Rg3gGDBRFgbTa/R
	g/RKfomRTViwW8LpJCia25/268tb2VtJ7WZVxGdoS6fKd7aluRZMuPMqmhEQ7kwzhehtSFcagxfqd
	fUjSa3KN/SP+VLA/I6i4ETxQwL80a+dPZywjn/An/hszasOfGOHGXeENLKpVthkrHol9MC47JjKro
	8/6mHaZdTZI/eaZ1WcOdo93o3XKS/RFWv0glTgrrOzWU2KR+iARarsGzBxxZjOzXMDNPtOQxVCenr
	XQjg9bvw==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqsz-0000Dj-T5; Wed, 19 Nov 2025 23:42:50 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vLqsV-00Fos6-T9; Wed, 19 Nov 2025 23:42:20 +0100
From: david.laight.linux@gmail.com
To: linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 04/44] io_uring/net: Change some dubious min_t()
Date: Wed, 19 Nov 2025 22:41:00 +0000
Message-Id: <20251119224140.8616-5-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Since iov_len is 'unsigned long' it is possible that the cast
to 'int' will change the value of min_t(int, iov[nbufs].iov_len, ret).
Use a plain min() and change the loop bottom to while (ret > 0) so that
the compiler knows 'ret' is always positive.

Also change min_t(int, sel->val, sr->mshot_total_len) to a simple min()
since sel->val is also long and subject to possible trunctation.

It might be that other checks stop these being problems, but they are
picked up by some compile-time tests for min_t() truncating values.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 io_uring/net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a95cc9ca2a4d..5fcc3e9b094e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -483,11 +483,11 @@ static int io_bundle_nbufs(struct io_async_msghdr *kmsg, int ret)
 	/* short transfer, count segments */
 	nbufs = 0;
 	do {
-		int this_len = min_t(int, iov[nbufs].iov_len, ret);
+		int this_len = min(iov[nbufs].iov_len, ret);
 
 		nbufs++;
 		ret -= this_len;
-	} while (ret);
+	} while (ret > 0);
 
 	return nbufs;
 }
@@ -853,7 +853,7 @@ static inline bool io_recv_finish(struct io_kiocb *req,
 		 * mshot as finished, and flag MSHOT_DONE as well to prevent
 		 * a potential bundle from being retried.
 		 */
-		sr->mshot_total_len -= min_t(int, sel->val, sr->mshot_total_len);
+		sr->mshot_total_len -= min(sel->val, sr->mshot_total_len);
 		if (!sr->mshot_total_len) {
 			sr->flags |= IORING_RECV_MSHOT_DONE;
 			mshot_finished = true;
-- 
2.39.5


