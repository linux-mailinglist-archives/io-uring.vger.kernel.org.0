Return-Path: <io-uring+bounces-7713-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6ABAA9B452
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 18:41:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B1133ACB55
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 16:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2D7284698;
	Thu, 24 Apr 2025 16:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1Cnv2P/t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CFF1AF0B5
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745512865; cv=none; b=LyFY8wRmgmxaOOZBkaWewAXfSl8QjVX5BfGwXopq2D0E2gE/i+WZSvwOVAIbPEEOZ5i4yuNeDPFPrYUu+memAzzYKLIz/aoHel7LIkYKfF64TFZPeWJQclmyzDM09ba3OW9xlPLm4SzEeP+qhLnVWV4fAusjqk6e86j0NrMRHVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745512865; c=relaxed/simple;
	bh=8ps/64XWv9mafZmXiCXM33w6xroWq14hw8UNaXLd5Bk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=cqf9OGFUF19AMKLuMsSkke8xA6az0wo/T1/Kg4Q/Obuz+dEL4P/fGKr1/1q0+3KPCixSK0jZvvK8CDc4pKBNDwDbyIU9Od1mpoGs7nlj1UGx/0Agnj+f/DZ+4Bs4/psX4RFiymc0IwgQ/X7O3pe5ZDV6tAqociLpUqt5L8GQIhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1Cnv2P/t; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3cfce97a3d9so5181555ab.2
        for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 09:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745512860; x=1746117660; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9IYi8XAI/Ztd78Z1vsJEkTDdxKHnArXUAorO0kcmqdE=;
        b=1Cnv2P/tIsvchQUJ2YxOL3Y3UZaI2r1LbojnTd2HuxlvAhrLAzjdaepwHy1NGXARHg
         KtSZvGWio6tuG83SJ2SW5D6gWa1qyzUy4Ql8fQcvioYKShjKJRT+0I/NiWpnK/mRZewv
         v6iXnhcTMS2N5EHc/hp4jBBfqoXcus+Kr8pgo9IcH6ivPxSgSMGjx4j8WRpTOeOv4cBZ
         bTwWlgyWL/aSlNGKEiXsaEkurctSmiRayCIxW9WpszvkFjr5JNiWu70Lb6BQiT+ioRPS
         BdK2/rKfO7kO48KGFjulUSZOhgXgJNNeZRHQgjAtaX1iLwgv2XXDKIRkoV7YjZ7RlGl5
         yC9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745512860; x=1746117660;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9IYi8XAI/Ztd78Z1vsJEkTDdxKHnArXUAorO0kcmqdE=;
        b=SJvwuGxWfMOu/cZ8wdfN4kWT2p+kXW0lsLHzb9P1Z63Eetear8HgOrofjOnn7SDCA5
         ehIixuCBDHYecQNAl3ir12otBJj+eQzRQ8zKPc6JRTfCZjAHFdBbQNAHxIwUrG/rhw1+
         FHt7KfzBDUI2I889Z12uogZi1IADYs7V3ixeHz/TRv0cvA0Vb0McL/BQR9U5TwmDFqii
         /dmgC5Fa6JWCcF6j98GbbAPGrrzbwtzNSWnw47xrNXspFsV6A4t0hrFmRVBx5hdW1ymx
         DgxeIbJTBAsaES/r2mjp2ZINW13lPgf8Zj7jipF4/+6vPeB0m1T2yxJW+m4s3ecZoBS4
         eZBA==
X-Gm-Message-State: AOJu0YxRUWXiwXUsye6zh7e5uf6wd5ZOpvh/3Mi268yjP8ZWcLIS3wDa
	BXp9WKFsdJcFW+M/pXuo6+PCBRIkciqK3PQ1+/f66317S9ysJhpI2U4dnWR1/+tGRVN/WP8vKxf
	7
X-Gm-Gg: ASbGnct+vgS4r7ucHZyTeAxQuN1/aYTzrIYmvBo2s0YMXpHF8yd5whIzDQ9X1Z6o6eL
	rKsTUzSqlNBoFGEbiTlRh7LnbfxFVLRxMmaoXS1QRlHUgJSbyNae6QelUNiWSJmcmVZyw3wspki
	kS2rIc6Pt/yM8cBc0gYvh61k3eN/PlpN55rf9N0A5AF/0JRzqVGoZh1LPmX3widfUtAkZJXlRvz
	RzqO7BBeHAWyf8ABHLmY2ogyZkNp39H5VkgbMq+SB83kSxg28zHdCrMyuBpLpYR8SIM511z3VuR
	fKy0r8xdQYkb3aKMNcgzwFeThlwnw+WBc+Ov
X-Google-Smtp-Source: AGHT+IEKm53MsZVgwg7El0sh/yWUI3DN3EvlvJSbkg4p7g/60QnD9MlgMsTfh2bMiw/oL7PN0OspBA==
X-Received: by 2002:a05:6e02:198f:b0:3d8:1fd5:9c6c with SMTP id e9e14a558f8ab-3d938d09f41mr3324385ab.0.1745512860078;
        Thu, 24 Apr 2025 09:41:00 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f824a38657sm347115173.34.2025.04.24.09.40.59
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 09:40:59 -0700 (PDT)
Message-ID: <13db01bb-35ac-41b3-9c80-27119b61cf42@kernel.dk>
Date: Thu, 24 Apr 2025 10:40:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix 'sync' handling of io_fallback_tw()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit added a 'sync' parameter to io_fallback_tw(), which if
true, means the caller wants to wait on the fallback thread handling it.
But the logic is somewhat messed up, ensure that ctxs are swapped and
flushed appropriately.

Cc: stable@vger.kernel.org
Fixes: dfbe5561ae93 ("io_uring: flush offloaded and delayed task_work on exit")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index eedb47c8c79e..a2b256e96d5d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1083,21 +1083,22 @@ static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
 	while (node) {
 		req = container_of(node, struct io_kiocb, io_task_work.node);
 		node = node->next;
-		if (sync && last_ctx != req->ctx) {
+		if (last_ctx != req->ctx) {
 			if (last_ctx) {
-				flush_delayed_work(&last_ctx->fallback_work);
+				if (sync)
+					flush_delayed_work(&last_ctx->fallback_work);
 				percpu_ref_put(&last_ctx->refs);
 			}
 			last_ctx = req->ctx;
 			percpu_ref_get(&last_ctx->refs);
 		}
-		if (llist_add(&req->io_task_work.node,
-			      &req->ctx->fallback_llist))
-			schedule_delayed_work(&req->ctx->fallback_work, 1);
+		if (llist_add(&req->io_task_work.node, &last_ctx->fallback_llist))
+			schedule_delayed_work(&last_ctx->fallback_work, 1);
 	}
 
 	if (last_ctx) {
-		flush_delayed_work(&last_ctx->fallback_work);
+		if (sync)
+			flush_delayed_work(&last_ctx->fallback_work);
 		percpu_ref_put(&last_ctx->refs);
 	}
 }

-- 
Jens Axboe


