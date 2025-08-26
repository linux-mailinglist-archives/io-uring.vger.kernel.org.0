Return-Path: <io-uring+bounces-9297-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F15DCB36F93
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 18:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF8DC178AED
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 16:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE84D31A55D;
	Tue, 26 Aug 2025 16:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f2dOckqs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E6631A550
	for <io-uring@vger.kernel.org>; Tue, 26 Aug 2025 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756224301; cv=none; b=Ne16q1C0mleVVLoz1G3p1lhOMXyZM0fjIbGTTA3ohIg5GLWcvt3DNZ4+GWcD6d6Cai1i1/rGkae0JONryVbmbC1zSa7ZiAbCbnr/gjs4/RDDOHn7Ozf+t+GvBwyfNrjywTRsOShby7Iy68zRmamwSWIWp6gDXyxVW35IQ8V2ybI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756224301; c=relaxed/simple;
	bh=ZZc9YZA8K3C/Ja5JioRccNQpEfijRxONZbAa5+/m2f0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJ+qyd8d6a0swfA0BXJR0QUheL7ywYzOaswg+9/KTg0tEm0PSs+HnLfEOT7y9AsbnxFN/6g0Qj/7mdD4erdc8E7HKf1o7iUoVCLXKXxGBb+hl05rNvRAfiLQPh8yTU290dzwczNi9oT4jqNunqBlfmm7ybfKP3GOTXVteefaZ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f2dOckqs; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3ea8b3a6454so190315ab.1
        for <io-uring@vger.kernel.org>; Tue, 26 Aug 2025 09:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756224298; x=1756829098; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sUpAjd8tOdDLXSWNwz5Mlzu7zvfpiEB/z3uqoorZl4U=;
        b=f2dOckqsYTMbbOSCnGGzSoS2tp4EYM3w3wj310Hr8VtmkXSEmwr02UdeITra/zcBl5
         wzg8pgoS2m3KxATBlx97jBcb3bHToroZg40YmHIuTbA0Uzv+mLGI+jXGKinKmelxhqEU
         tnEoB20iqMnSq4y0Kqp3FXO3k5a5K4xaRdDHh6iCGOrqdY0OhKRVTluMy3kqi8SzM9gB
         JA432A5EZi9jNMzWJhW8GkJBfWGhS8YL5/BUb0mWIS91u7LRvskC/VWT2q4mGAQKGehB
         K4SC2Dm3cbrJhP5+v2nNrCIqEzlcAbuRs/kduY104H3bIzQFDsS/T543Peio0u3/iYUJ
         y3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756224298; x=1756829098;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sUpAjd8tOdDLXSWNwz5Mlzu7zvfpiEB/z3uqoorZl4U=;
        b=IUES4e5VS66TuCbSFQ0Xy6AVbjW/PVrcnTU8NNh0V1O8cEBDtmZF+98dvy6OEM64yD
         4853czp3JrSVJWAXNmtY+UcP+TPEBExd0zzhV1JtNV2Vwdw9FbpxV2/OIKeaCAR/H9qe
         KK0fEpxiLYw3WdFREdwbiHOdW3IMKcX6OMxJLDYAbScAZbreY6XVk3nDGlUInN+xOPpf
         AmpJJVSWnCEeo/ud/1gprIAc3cycr2nYmcO1L2P1D9z0dyL78G1ju/vI1gkrToSt669u
         rY7R7ntn8bcsvwvVfHcLLbIDP+TZm5GfH7CUt5mTF/1nxNjUIXJdXdXyMFGD1tmnIuTt
         ERTw==
X-Gm-Message-State: AOJu0YwZCI49FgWIkc83jWSMnEHwH+m0p+0YfKMEu72y/GWrW1+Kx2iN
	K4Oe0McO3QgB36OU12W4tjglrF8nNiQ+FGX/BaVFMOOjxDNoRA98qIQvPLsWpY67s5hpDDW+ZCN
	BMPk8
X-Gm-Gg: ASbGncuKx4I5nEeUzVCQKZ7OA0wSiZblp5DoxDIjA2rht0FUWJHSaklG1F+5awDpXIV
	trcX4i6kUahxSeY9OrHTgu5xqdpsAOncdAOzGu4psrRAcMuz5B4Sf/Yue4DGIH1oy0n7OmzoIBA
	ld4WvbPwNqySKtqYEaARN1VwTVtmYvVIfdIHdlCw+sYtvkEAkAYd/l+mlpU7OXOpL0pOcnfEsnL
	M2nZYY8ukgMtljwa/lcdrbPElHYfz+ROYQEcKdzjTUMmSgGjBWS/3Ej1+W5Vyu7wridklya7ntF
	pMH/fO966kjfhT/zJ5Su7viCoOteRu9pk8Sd/5BSbf8N46cIGHggbLiJ9Wz1Pige88dnDlIFu8W
	w6cjqP242bANP7YqYChc=
X-Google-Smtp-Source: AGHT+IHMhF30ZZO6E6YgvYkBHYCx2UzXYAm+ccMKiqFq5E4qbNW86s3esG4zB6CNh4iSkBd138cWww==
X-Received: by 2002:a05:6e02:1a8b:b0:3ea:713d:1eca with SMTP id e9e14a558f8ab-3ef0894d158mr29342305ab.10.1756224296527;
        Tue, 26 Aug 2025 09:04:56 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ea4c761718sm71392925ab.23.2025.08.26.09.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 09:04:56 -0700 (PDT)
Message-ID: <810863fb-4479-46ff-9a2b-1b0e3293ee71@kernel.dk>
Date: Tue, 26 Aug 2025 10:04:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] io_uring: add async data clear/free helpers
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <c93fcc03-ff41-4fe5-bea1-5fe3837eef73@kernel.dk>
 <CADUfDZqcgkpbdY5jH8UwQNc5RBi-QKR=sw2fsgALPFzKBNcbUw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CADUfDZqcgkpbdY5jH8UwQNc5RBi-QKR=sw2fsgALPFzKBNcbUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/26/25 9:27 AM, Caleb Sander Mateos wrote:
>> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>> index 2e4f7223a767..86613b8224bd 100644
>> --- a/io_uring/io_uring.h
>> +++ b/io_uring/io_uring.h
>> @@ -281,6 +281,19 @@ static inline bool req_has_async_data(struct io_kiocb *req)
>>         return req->flags & REQ_F_ASYNC_DATA;
>>  }
>>
>> +static inline void io_req_async_data_clear(struct io_kiocb *req,
>> +                                          io_req_flags_t extra_flags)
>> +{
>> +       req->flags &= ~(REQ_F_ASYNC_DATA|extra_flags);
>> +       req->async_data = NULL;
>> +}
>> +
>> +static inline void io_req_async_data_free(struct io_kiocb *req)
>> +{
>> +       kfree(req->async_data);
>> +       io_req_async_data_clear(req, 0);
>> +}
> 
> Would it make sense to also add a helper for assigning async_data that
> would also make sure to set REQ_F_ASYNC_DATA?

I did consider that, but it's only futex that'd use it and just in those
two spots. So decided against it. At least for now.

>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index ff1d029633b8..09f2a47a0020 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -37,8 +37,7 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
>>
>>         if (io_alloc_cache_put(&req->ctx->cmd_cache, ac)) {
>>                 ioucmd->sqe = NULL;
>> -               req->async_data = NULL;
>> -               req->flags &= ~(REQ_F_ASYNC_DATA|REQ_F_NEED_CLEANUP);
>> +               io_req_async_data_clear(req, 0);
> 
> Looks like the REQ_F_NEED_CLEANUP got lost here. Other than that,

Oops indeed, added back.

> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

Thanks for the review!

-- 
Jens Axboe

