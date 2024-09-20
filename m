Return-Path: <io-uring+bounces-3240-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF02A97D10D
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 08:11:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EAA41F22B39
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 06:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC732AE72;
	Fri, 20 Sep 2024 06:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="I6XZLBtl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEE128E0F
	for <io-uring@vger.kernel.org>; Fri, 20 Sep 2024 06:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726812679; cv=none; b=OqCyjeCgSLTj9N3DUzWsFwfQ+8l2AmT1Cxxv8zTsbntvoSwls29sWHfM2SYtcAnyiVebmgeY4MSfDOGgw//MQFPQO2AXgYo9MqsD308V8IPSnv0ODhgyZU/5W+REIyOMcOLDejeDOYjlx1tTmY0BgH9KCCWL1mZb4zYDmivmgBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726812679; c=relaxed/simple;
	bh=3sukuiICaRW4/UX2Y/u/SoM9T+3PRlB80SdRO4w9DVI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=A2JAS5RTOzFgmKfmZVSh6QONDtNTS5gSvmFV6LvdMNx2TBv1HZ+IJx4PKKXESPLQrIy8MRJUphK4jN2pPHQVQ+dlIfFTvkfs0vrPhEMPWmOxkzfv8LImyYpALGXZU7pXYsKXwza1/dMHaBNJR4xj+louw+owXGN4deFgh5iM/FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=I6XZLBtl; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-42cd74c0d16so14699345e9.1
        for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 23:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726812673; x=1727417473; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMlUJQy51FlmQuyqnWN67Iwk5+k9CxJGrAZMEG6Bt/s=;
        b=I6XZLBtlI6XqagG7COGLiEoIER6y5PS89TvlfvOhJHSPDaNSfX2EYNGR9QPRi20M+9
         nvxNrdCo39NLv4o+xmExAdujHANnEsMXYdz+C00BD1XQNr6nJihhXbQPd8wUR+yu2XmM
         HmW8pRdQUjBLMZQd6IjrGZ90WK0oN8mT/Csm0Inu8q/QIi3cMjX/z2RgbpUMoza9tE/9
         H73voISeXy84l4pKDhqiknIa/fj+rukIwtKD7vYEzkxQE+5ektVTJBT70YlFQhH20yhn
         2pX2eY6XcCCOuXFINuN1yXHlf7e7wy5XnlHnZGAOLUf2vs0Lc5ZrMUJcCQqMlIZ+sYrB
         tifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726812673; x=1727417473;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pMlUJQy51FlmQuyqnWN67Iwk5+k9CxJGrAZMEG6Bt/s=;
        b=d6drVZLGtZHPn5IRe6jNg6bJKMYjAJbvn0TaI58un628oIRiS5rUVQkX7WmocgEgU1
         8VLTgy0f+ApVftjIqoGycl5/BAAwUrjCtNYR49EyCFgq42xDnRvE1npRMfZiPTaQLo3t
         tZvkmwxBhHWHGazRRBDI96CVglFcATIe1PPiHXBgLvDrzLUcl+fa/luZFAAhZxBbPKmX
         iuh3h+HGNMaO4G6GXrOi7KAFsd3FBcmcCG82o21BCe2PW10q0FylfNEoTnN6Hkra82xB
         6uQwaykFoF11T4/Vilo85O/bGv/zlbAY1lSeVftgKthwS9d6+L+Srt8mxF7UW3UBmwAW
         rKIA==
X-Gm-Message-State: AOJu0YxB464sIFveFlt7/AilS1pumYKo78l0dMrXhQaXovspg4VeRM28
	wkzY1c+tvHMgPTPf9mI3aqkoCe2HVjC+sEOY6L4eQq4u1U51Ggjam70S0d/5Zdx37C4xVM+2F+k
	tH4JSAg==
X-Google-Smtp-Source: AGHT+IEpRwUtNEah71f3iBg3LLf9NiDSFVXEvaPaHRNSFIdAyx1K6A6B3dbfApDZsHLhPqBAC8pYlw==
X-Received: by 2002:a05:600c:1d92:b0:42c:a90c:a8a with SMTP id 5b1f17b1804b1-42e7ac4d751mr10526565e9.21.1726812672579;
        Thu, 19 Sep 2024 23:11:12 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e7afbfa1asm12997885e9.21.2024.09.19.23.11.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2024 23:11:10 -0700 (PDT)
Message-ID: <4a8d8a42-31a8-4d14-9fc8-6fb1c136ca73@kernel.dk>
Date: Fri, 20 Sep 2024 00:11:08 -0600
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
Subject: [PATCH] io_uring: improve request linking trace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Right now any link trace is listed as being linked after the head
request in the chain, but it's more useful to note explicitly which
request a given new request is chained to. Change the link trace to dump
the tail request so that chains are immediately apparent when looking at
traces.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d5425f4055ae..2b81269c4266 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2163,7 +2163,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * conditions are true (normal request), then just queue it.
 	 */
 	if (unlikely(link->head)) {
-		trace_io_uring_link(req, link->head);
+		trace_io_uring_link(req, link->last);
 		link->last->link = req;
 		link->last = req;
 
-- 
Jens Axboe


