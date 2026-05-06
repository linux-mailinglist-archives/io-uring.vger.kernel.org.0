Return-Path: <io-uring+bounces-13248-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sHi9MlUg+2kgWwMAu9opvQ
	(envelope-from <io-uring+bounces-13248-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 13:04:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F44B4D9952
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 13:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 917AB30066B0
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2026 11:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF0523D904E;
	Wed,  6 May 2026 11:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="PzGFpBUV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0540D3FE341
	for <io-uring@vger.kernel.org>; Wed,  6 May 2026 11:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778065489; cv=none; b=JcwcqWoS0vpBC+4z35FM1N3a1WCz+Wd38Y6CPubRtleS04+MqwiQBRPd6rhZV74d2vHa2s4u9IcClcBhvU8/jZbjsMOWxNQ48OJP99BujxAVHIKEZFFKmU9odmQu9taWqQ7jvcTYbhePeHDHl6EHukdpiP0Nyn8Oidc/YY9oavw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778065489; c=relaxed/simple;
	bh=Ep/l3Tx4naPqZAkU32u2xL4oqc77BusXOyLruaz4vWA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=XLV4+ev7j+G4nEGaJSfm4RA/ytsm1CiP4jdO3ZF5ws9lX+qQ4QRxBxitytX2bDLbJtlmTiX4y/HxYPvAy/bHOUOkdooLh5kmfYNOF1YViH3LPMV+83I8Vs/2bfJGTkPqTRYF1nltwUtZAKEvJpv5N82ysyI57opH8H0X9bA8HrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=PzGFpBUV; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488ff90d6c7so59620055e9.2
        for <io-uring@vger.kernel.org>; Wed, 06 May 2026 04:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778065484; x=1778670284; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zG+MVy2+yzM0YmAXRqlUNKNXzostrBe4j+S4Kg5YiGI=;
        b=PzGFpBUVXb1cIFijajaSxQ2kY/qTKuwv4Sv0oDBOiF2x/kBUqZGt3mYIjtp9Yia49y
         vqBMfT5lncOuPtqo2TL2GB/8kfo4+o/pJ3QMBkEKVjUv7zpIAQx3rvOqQccEjIOxXavL
         fHTnQ+QFUxaXLOm9Qth5Q61MLUP4qROrmxNIEKBSQ07auQ3MwKGHvphGdhplMRGX37K1
         FQ1wz8sWYZ3A36WA+yuH67D3QiGxOQvLbCOdIJRD4vFNlUqeYLZe2YDBOmQG7cp0C/2O
         wEJQuuDGAQeZeH/RssdjiGo9ARTdNhrA1+g3fVeTu0p53+n9Haj6DcXQHvdiaVsLT9u1
         M+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778065484; x=1778670284;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zG+MVy2+yzM0YmAXRqlUNKNXzostrBe4j+S4Kg5YiGI=;
        b=NdYl1hNLcz7cFrh9bF9ySY71raum4TCnHUNLq58Wb7ZI32LFygdi8vk2gJd3OQuGT5
         nIQzyawSq1I8ywg2Il6wUPfxq9puf6aR6UyLm2eTxo0cnm6pIgLEB/CIWfGJ6vlbT9uU
         o/We/52gMZWwtNsiKg8PQnM4VCHcP7oWEpsF0FgoefYf5GBFbP92422XRwXX68iMHrzY
         woMImMtXBuLGtLVhEC69CHqObw+Duntl2UdnqnrKoFNXqEkG3mH4TWWrxWtCl3YjH0bI
         CNDN2RjuTfyX5ZvWJj71Xj55Xzon0Qpp9kD8Nj7zRNZ7XU0Tqnx+BIp2SRXjhVOHZtO7
         fjRg==
X-Gm-Message-State: AOJu0YwLtduhxWfxnmKfm2xrufCtnA2nrWlhpzZBEZbOwe8R0u1cYIPz
	M/ODTAthrQH+ci02D06xCdTed48YIlxq1uSxDEDfRD6aC1lzRvfq07dty5vHgCJtzZZH6ld0cr1
	2yh1tbM4=
X-Gm-Gg: AeBDiespNiBryqnOVlJ1i3or4Tc4U/o6PWQROit02/Pf/UQ2UvcfCXPwWUrv1rnS4B2
	uV4o8FEmTkzAgq7ElkixN1rjeBqcOLLp/vlDsSijw8qYbKDIdYlbV1/iRLe27v2pQRLYrkv6Y33
	VkMMPhruN/qOt2vSCxe4tpaDeltUlY29r0WOATydXwen1omg7j3oOemGXZyUh9lKI68SCu+pYqu
	gDNs4uHqlZAPIx6Uz2nfntW91azKGf9IwGJK41zyjz/LjxPqXvVU7X/sjs3ZO8nKw9/67m7/0lc
	pAXiOJnLG+DuprhS4eBr2RqdBqmE9BrJK/UfqTLxDP91x1eNDQPhCZ5vJU4OUoYD4pKH6fY9EN5
	qo5OUYW8lltm+dX2YpHkNYYrdm5IXRMcoUQ/fnkH4hBhgD5NYzgzliMl87xBTdI4p2x/LZErPoW
	n7blYEISv/I1cXwHtW7Vbop4b4VQC/Zd2YJSwVr9wbim5Sri0MrtRphSH4sJqioqsZqe6knr7NQ
	CWhdLUpK7OhLYiM1xmGWdDwsl4Wl9g=
X-Received: by 2002:a05:600c:8485:b0:488:af7f:775f with SMTP id 5b1f17b1804b1-48e51f32a64mr54457955e9.18.1778065484353;
        Wed, 06 May 2026 04:04:44 -0700 (PDT)
Received: from [10.211.9.173] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e538acf23sm37121445e9.8.2026.05.06.04.04.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 04:04:43 -0700 (PDT)
Message-ID: <2469b617-3b4d-442f-84a9-7d1136d84065@kernel.dk>
Date: Wed, 6 May 2026 05:04:42 -0600
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
Subject: [PATCH] io_uring/uring_cmd: skip inline completion cleanup if
 unlocked
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5F44B4D9952
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13248-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]

If the call path to __io_uring_cmd_done() is not locked, then we
cannot recycle the uring_cmd to our allocation cache. Check for
that and skip it, and let the normal locked completion flushing
do the cleanup.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

This effectively defeats proper cache recyling for uring_cmd opcodes,
with the fix it's working fine again.

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 42be1be5b132..35e2aa8b9446 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -166,7 +166,9 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 			req->cqe.flags |= IORING_CQE_F_32;
 		io_req_set_cqe32_extra(req, res2, 0);
 	}
-	io_req_uring_cleanup(req, issue_flags);
+	/* defer cleanup if not locked, otherwise cache recyling is skipped */
+	if (!(issue_flags & IO_URING_F_UNLOCKED))
+		io_req_uring_cleanup(req, issue_flags);
 	if (req->flags & REQ_F_IOPOLL) {
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
@@ -211,6 +213,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	ac = io_uring_alloc_async_data(&req->ctx->cmd_cache, req);
 	if (!ac)
 		return -ENOMEM;
+	req->flags |= REQ_F_NEED_CLEANUP;
 	ioucmd->sqe = sqe;
 	return 0;
 }

-- 
Jens Axboe


