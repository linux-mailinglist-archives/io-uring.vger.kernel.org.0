Return-Path: <io-uring+bounces-2217-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EAD19090D2
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 18:59:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55D811F21B52
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 16:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9B2192B8F;
	Fri, 14 Jun 2024 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tcelBIHL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EFA17FAA4
	for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 16:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718384363; cv=none; b=Otik0P4vRuxVNv69DyBp7S2+MXy0YwFYc2jWHW5xznX1weJ0YyB3+J6nddI+RjNMdhJ+ly78VOUxJ9IODqIuDp3YK2NNhwIB/Tq5wj1F+qlamSkjZ1+lVSaz3Pvix7jfXxhhRAHFZQpP5dF4Rh+vfeP9WIUrHN1QwCElrxu98ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718384363; c=relaxed/simple;
	bh=lRG0a0WSe+miSuU9W/e8xUN99lWftdBceXZG5gLJCxU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=AfEtdZ3gp07rRBDjPUA4VMliygLuRHx/L4pqM05nydIks7VMBzZdWR6W7RKy0Aq3oQja8tuWiGifiT7gpqtTPtO+pMyCIJhw/FoL5RyDDU1DV1Ckozq4XSJjst2eef3/r8fGeyj6sl15iEWzm45I80E78JiJYSQ3Y0Ny1h+hPHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tcelBIHL; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2c2edc2611bso436787a91.0
        for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 09:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718384358; x=1718989158; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKABBlp9b0iLBf1/3AEsZsLlY/BPo9D7BJAQ3jTPHgU=;
        b=tcelBIHLvHZ2zUCQYDtLLFvdqA2wEQmL2Nbf9qnGoRZycMUoe8o1JNkwweiI/SDgN2
         0dUBFlC4h4VTAnGnxYmdB9B0BvXwynl33YiKp/P/nXxmlWAA9t2GtUw29AcatoNvwB7A
         UIRHiIUDc5Y+Hoai4kuRX+uulmTbc/8bzXaDgFX59z181lNsKxKDRS+InFjHUOMNnWlQ
         JI/o+Ta97ydSNSkMurYZ28vg/FxzyEWx0pKC6IVH5AklE336oSwoiPEw/y7Rx6pTqNwv
         vL0wGdCQ0hQDXYG6dIhldZ1eUcNc38EILaN5P2IMznYcQarZrPHOZ/gPPeVYgHIv7ujD
         O4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718384358; x=1718989158;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KKABBlp9b0iLBf1/3AEsZsLlY/BPo9D7BJAQ3jTPHgU=;
        b=Ax04mRywADN5oXa5LiFpmrrUJ/OmO+4vvLiqFA7K5ahbmy723gK1OqDr6lVyAV8DLd
         4Z8hmFZg2N6q9PEmiASKeISRqKwAM+zQUFg9xInxwLooYzb0gv9tSglQkMYt9c2L5wls
         i3jOtoO8aT46Jd46JFk2Nw0+tp3Q5ddErjbwOOI4nylpJJgdlHcDU+mm3UkAQ+3gU64y
         lsxeRKx/519gnIWNBI4BvnnzXp1500NOTCvk4vXfs4V1UQ2DWc5J82P5Mtoca2UCyqoz
         dZqMPVkCJNNFAzarTUFI8GJCYEFosPYZl6YMVAPwfU7D0Mkm/K4aP0zHaAGT6mu13jqU
         Ql1A==
X-Gm-Message-State: AOJu0YyDmL/2H690m3GhMp0ziCFMCnJyVmPBhMUrQ6vEmWS54hGvC/H0
	M38S9N9hVSpNq/fdXdq+FLz6FeuZU2RODcnIMziQgRjr6XeaABLf5L66GHDdHy9XD4iwbc6gxOw
	j
X-Google-Smtp-Source: AGHT+IGGqs5k4A+XAIdODiX1qMAYCZVULWgC9s/OxmVy22TqMJ15jh3Hc+hhCidH/lNDaDT0klz/YQ==
X-Received: by 2002:a17:90a:ae06:b0:2c4:d63b:cde with SMTP id 98e67ed59e1d1-2c4db132225mr3347765a91.1.1718384358372;
        Fri, 14 Jun 2024 09:59:18 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4ca4997b3sm3918854a91.54.2024.06.14.09.59.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 09:59:17 -0700 (PDT)
Message-ID: <289964c0-08a8-4a34-91b2-451899ca8737@kernel.dk>
Date: Fri, 14 Jun 2024 10:59:16 -0600
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
Subject: [PATCH] io_uring: use 'state' consistently
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

__io_submit_flush_completions() assigns ctx->submit_state to a local
variable and uses it in all but one spot, switch that forgotten
statement to using 'state' as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 96f6da0bf5cd..0c86f504fc66 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1390,7 +1390,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	}
 	__io_cq_unlock_post(ctx);
 
-	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
+	if (!wq_list_empty(&state->compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
 		INIT_WQ_LIST(&state->compl_reqs);
 	}
-- 
Jens Axboe


