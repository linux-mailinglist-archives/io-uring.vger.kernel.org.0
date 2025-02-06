Return-Path: <io-uring+bounces-6287-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF9D7A2AAC0
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2025 15:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B917318887CE
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2025 14:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D91B11C6FF0;
	Thu,  6 Feb 2025 14:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SgRYkDQK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D68D1624C3
	for <io-uring@vger.kernel.org>; Thu,  6 Feb 2025 14:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738851033; cv=none; b=TtcQE1fHuwRDhtZ2x1BxjQZtMhuvzZCEbSik/w7AojHOighS3Nec1Pcuo0J1uXMFbssNHkZdAn7aAQfcT2Z0NhUwYOD6YrAK3mDf86DTQY/WtrJKz3R71S+Ffzv4+ek+R/BGcwgJJesmUKoO7I7lciTNO3o+cw1Qri/WOSveSMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738851033; c=relaxed/simple;
	bh=j3a73DgsKMHr0DhTblhfZBenchOy/RHLAFM1hY1dPQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mSdj7soGWUJ5PweKU6+sHFWa3MZuKFw4Zga9dKF4HG5m3mpaG734Ah44aDvOGLOqmqL/HJFbwQTq0zbgLytHPebjtaNFmf5LVvEgCI474UMe45kkGV2Crq6Q4Oi4zTHSCLoeFDMAn6K5prjway6erdocViLXO349zY6YCGJDcHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SgRYkDQK; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3d03d2bd7d2so8428465ab.0
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2025 06:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738851030; x=1739455830; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OzDn5rlZRJF9rzbr5c0HI/np5HiZJF4UVRzpeNhkg2E=;
        b=SgRYkDQKIhIGKZMZAnaHy6ZmBFVT1YgHMaUQw3dU8To/SDZKXJVmFeswh+gk8dKGik
         oGoYQim7HPLKr2ItfT703574b1dm2x8O6E9qOJmNibj5XTT2aFPc8pjsu5XOKD1WUZ9B
         qkn1AuTeYWpjReO4X7BaTYm4HtFXkXu18iVHmeYwJmMu2B4+c7cmSMmSJAlkAE2blmrG
         U3tNWxLUf1f+pdD2h3fvuKSGGqsKodDkNRX+J3CMSYWh4tpQXn6BH6sax2hOmXWYgDz8
         7f+oCC5hj9D9d45iynI6Z6P+2NZqENXGhFcLpFTpAsavCeKSY4ktcaGtn8GhZZuj8+3Z
         LCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738851030; x=1739455830;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OzDn5rlZRJF9rzbr5c0HI/np5HiZJF4UVRzpeNhkg2E=;
        b=GmEjKEHDkj+86FiJ3Wl3iPoVeiycfE4KHfWk9S72FwlwQWN1wlJ4HmWXxbe+nOLBKm
         /RBVMLdDUnR9o0dGbIRQ0Ap6UKw68ZyEQujNQHcXzA/VnZnGdTSjfh/LVmXPV3LUxjSb
         7pJAUdTO784Urx8kNDWO8osQN6QtwtsipuG6HCBTG5gVVlW3gCLraKMJvzJE6rZdnIB3
         EUr4Re+gtyABc8RT0Nb3nwGu+vxRYR0DRAK83WjasUqkppnA/obIRWhh/R70NwdMyhg0
         bchiAYM0AXOqKNiTRUxqg2N2OzNV047GBCskYts8gQ8qvb2I8sWEIHnFnQ/KYePeU81v
         i6Mg==
X-Forwarded-Encrypted: i=1; AJvYcCVtkPzJvhoAP0AoZNLvs6tPzIR0JoYA8zwvwDmCm3XrDxIDD4irnxj6ek+XlajVwCUeFhvjglCApQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZze81DyWo5l4YHE+GOtKmMcG71YeT1Y56hJF5CirJrsJOpdEe
	+KSRb6EQErnYg1159NVOafxsV4S7kmP6fw90qltiuDQobP6kjKaeLyzHG0qwUus=
X-Gm-Gg: ASbGncuuRcfV5RubCyBREAFcUBlBr4C/DBT2WotltWW1m604lyCUZ4tntWs0uub7BG9
	PFx45BjkCnh9XvtHPnPQMnugxvztHzGR9TTEW2uf8XNAnOcRVf4S1XO8mtSdwMFzKZ0BRHz31E3
	gd62S037MnCSb4EWPscIaLgLbs3qlNJfUpxMlpyHnw2rrqUWSGXV8hDqlpYy3OFtovd88x+rASP
	43BnarJhTYTV3+1quaVYtQ2XfKYgVTgG5qWLj624+j9Q1VUMFvJK2AXJjJdD1xII/tM0PZTHWOs
	9AmGZD9tsqU=
X-Google-Smtp-Source: AGHT+IEYcxabuFkEpN+DcXusfKTZeXvIDecHfFoDOlyi2BHa3PvzHLqaaDY7z4UuQjDUi8Do4AOMjQ==
X-Received: by 2002:a05:6e02:744:b0:3cf:b365:dcf8 with SMTP id e9e14a558f8ab-3d04f97d020mr89685815ab.21.1738851030536;
        Thu, 06 Feb 2025 06:10:30 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eccf9afd27sm268419173.27.2025.02.06.06.10.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 06:10:29 -0800 (PST)
Message-ID: <d7215f82-f83b-46d6-802a-d9e4647bccd3@kernel.dk>
Date: Thu, 6 Feb 2025 07:10:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] io_uring/futex: use generic io_cancel_remove() helper
To: lizetao <lizetao1@huawei.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20250205202641.646812-1-axboe@kernel.dk>
 <20250205202641.646812-6-axboe@kernel.dk>
 <c619c868b7b442cc9a2c669522242d96@huawei.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <c619c868b7b442cc9a2c669522242d96@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/25 5:56 AM, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: Jens Axboe <axboe@kernel.dk>
>> Sent: Thursday, February 6, 2025 4:26 AM
>> To: io-uring@vger.kernel.org
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Subject: [PATCH 5/6] io_uring/futex: use generic io_cancel_remove() helper
>>
>> Don't implement our own loop rolling and checking, just use the generic helper to
>> find and cancel requests.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/futex.c | 24 +-----------------------
>>  1 file changed, 1 insertion(+), 23 deletions(-)
>>
>> diff --git a/io_uring/futex.c b/io_uring/futex.c index
>> 808eb57f1210..54b9760f2aa6 100644
>> --- a/io_uring/futex.c
>> +++ b/io_uring/futex.c
>> @@ -116,29 +116,7 @@ static bool __io_futex_cancel(struct io_kiocb *req)  int
>> io_futex_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
>>  		    unsigned int issue_flags)
>>  {
>> -	struct hlist_node *tmp;
>> -	struct io_kiocb *req;
>> -	int nr = 0;
>> -
>> -	if (cd->flags &
>> (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_FD_FIXED))
>> -		return -ENOENT;
> 
> Why remove this check?

It isn't really necessary. Yes we could loop pointlessly if they are set
and not find anything, but it's really just a bad use case from the
application. End result should be the same, that -ENOENT is returned on
trying to lookup a futex operation based on the fd.

-- 
Jens Axboe

