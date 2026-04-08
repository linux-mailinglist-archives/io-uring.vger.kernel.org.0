Return-Path: <io-uring+bounces-12990-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SAmeLmpP1mm8DQgAu9opvQ
	(envelope-from <io-uring+bounces-12990-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 14:51:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 364EF3BC672
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 14:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA1C2300E244
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 12:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C3E19D891;
	Wed,  8 Apr 2026 12:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="xVcIaZEU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F63E3612F6
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 12:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775652709; cv=none; b=GmsPUnFnlZKeby4WO/v54DO0/nHx80z/XuUpcDasbx/H0GBYH9Obhg3KWWkwjOZ53N4FyaThVOeqZ6nU5tV/cQFkHyM02ICji6gkzB6nE5noDu1imqz1qy4e9HbiENiiWUXDQHKlf9zt9mKGSR3EOA3YEQu1n3mRoozKH0r5/hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775652709; c=relaxed/simple;
	bh=0vLo7tp497CFjsUg5IlBcVQ/iuP+v2IaN/Ud73bs17E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ALRbfDhfPL7L7PqD88/Zv9EyTJEeDdLPUYS6SeInGqTk07yHeiIkdXYOd8Msm4zutii9vtMAuz3gihqQvzQowNhv6ydAsoDVTYiIC8coF/QuptNBL6zl2RXIKD5sfE5yCCB84j6Y2TLICWwpa11+2BUXgEZsbG5UKRtweN6BIHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=xVcIaZEU; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-67c1b8b1f96so3239370eaf.2
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 05:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775652707; x=1776257507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zkJ3gH9TLnBN4l2XWLDJVveLcFNwieT7aov30h8JMgg=;
        b=xVcIaZEUQ5FEfLj1wGzhcYD191wDwGkSp1YuK90H9jXtvHxQ/erdbQUG8dvqQ0vcK7
         A7v6GUL726dZ9MCZvVgXmtYYMbzS3fankZuEjlqfl5HjneSPJaDaqv773inkpPNdBahj
         zn+taG8ITmP3qGZoo0tfai92S18q9mKXB4Upn7+tY/4AxXPwX3mJ0o0xadFXvFBXd4Ou
         z98OaZVRdLOndCfBAC3F890uTbt37T0ohHK+/TCmbX47jKvVNPqhtaaxDdDF6ADscH1k
         5ct/EDNh9UAemP2IhYGgbATvyrD6EM5qbW76bkNVLxeiYgt6WOpBCpARAbcdLe2a1qpn
         Wb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775652707; x=1776257507;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zkJ3gH9TLnBN4l2XWLDJVveLcFNwieT7aov30h8JMgg=;
        b=CEAGuhp8MYLXgWL7VGsg9pHd0O08C06q39v3Lphq+JrQoNV441321Rs09yPPi3V4e3
         JrXA/ssP4fqst1fVR/uJqP5WTehKdaAecd34I7qahoBixANgG3o7d1rE/1L5OZCTBQA2
         qqiZG+ailVzCobYxrwP/3nOcjXj6mOA6CPqVKU4qgC2dDhtZhTPJkyfy7VAjZBvRGUdJ
         /3UfNCP9QBwm8BCPcGOQeibaOR4EDeli7FHHfdnDsraTI23pLbuHbtKtI2fEaXtOBN0b
         NqQl4MrEddeBGbRH+eoQSQskLB00lqPOgEDF8u6PNyMC/nBDkVujxMjogbZUZ31M4gZk
         azbA==
X-Forwarded-Encrypted: i=1; AJvYcCVgNm+N8wDgh6/AFBnFZCGTzAq8vPMArkUhwZ/+Td2UyxiVgeD9kRr5Eg2YqptKV+U5OVrG6/GJ7g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxdKymNK5J4ah660wmMbL2m4yqny57g3poHfXKRivocl6MThqUA
	tp2LYpV+TXlS0rZs9NyzEUpCYClccOpDYihlCCAxvOOJGeX2gR/0u5eMcvLt4eEtlPc=
X-Gm-Gg: AeBDietrjm/iW+juRgqERg7VoyhtSGrG5NaHNF4OMriJDagBzp9UW6QbBGVGVTlVLbU
	KZ2ZYUhxTqVU7rUCoX2bgKHswiNIcXYs3trZSPKncG2jillMm7fNaADuo9okJGas+tt7j/58o8q
	i76dVWQ6oMsIgYLVKfXnWqj2c+8mfX0i3xRJxZ/mzyGW/7keanLnIdFYii9DpLMpGgT6XwGhY6K
	wFaYwfGbjGRbPyDQAOEwdnbMgOyvYJwKM9WVl0adgfvH9w4B4q28jVBjjy288GWDneRpn7glPMU
	dNQ67ADmx8Ezj3IMYif65D+MTu7VkrwvO6EWYqsNOe/SbFLIiHbTFb1zetxMjdScPQNQ9oIGAPz
	p/vZXcx+gzcsnUPvdy/So99kAXLX8fQFk9oo5E7vd6b6ktpvbyVr6+ShBO0m6oeAIYFmLFgrVE+
	o1kG1ZOPCHMgIEBTbhgvllJiLOvFjAevIQfut9MaqJTJefIgM6O1S3KJTyzoj0ZSxQ5He8KbEB4
	cj32q3UyQ==
X-Received: by 2002:a05:6820:f07:b0:680:322:4f36 with SMTP id 006d021491bc7-6821e261e79mr11791129eaf.25.1775652707173;
        Wed, 08 Apr 2026 05:51:47 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6892da88901sm1085560eaf.0.2026.04.08.05.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 05:51:46 -0700 (PDT)
Message-ID: <f3dc1661-02d1-4bbf-bf3e-c3d7d323b818@kernel.dk>
Date: Wed, 8 Apr 2026 06:51:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] io_uring: fix resource leak issues
To: KobaK <kobak@nvidia.com>, Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260408065408.2017967-1-kobak@nvidia.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260408065408.2017967-1-kobak@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12990-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[nvidia.com,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nvidia.com:email,kernel.dk:mid]
X-Rspamd-Queue-Id: 364EF3BC672
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/8/26 12:54 AM, KobaK wrote:
> From: Koba Ko <kobak@nvidia.com>
> 
> Three resource leak fixes found by code audit:
> 
> 1. memmap: pinned pages and pages array leak on WARN_ON path in
>    io_region_pin_pages() ? mr->pages is never assigned so the caller's
>    cleanup is a no-op.
> 
> 2. rsrc: kfree() used instead of io_cache_free() in
>    io_buffer_register_bvec() error path ? bypasses cache return.
> 
> 3. zcrx: io_import_umem() leaves live pinned pages in a partially
>    initialized struct on io_account_mem() failure, and
>    io_release_area_mem() is not idempotent (missing pages = NULL),
>    creating a double-free hazard.

General advice - anyone can point an LLM at a code base and get some
reports, but please apply some actual critical thinking to the "issues"
found before blindly sending them out.

-- 
Jens Axboe

