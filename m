Return-Path: <io-uring+bounces-2226-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A1B909B57
	for <lists+io-uring@lfdr.de>; Sun, 16 Jun 2024 04:54:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 740E71C20E49
	for <lists+io-uring@lfdr.de>; Sun, 16 Jun 2024 02:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2372D4204F;
	Sun, 16 Jun 2024 02:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S7q3z3Uv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB001E861
	for <io-uring@vger.kernel.org>; Sun, 16 Jun 2024 02:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718506456; cv=none; b=QNfNsAqdS0F6bkwnmwib7grap55vpDVaFwu76fW48Q58DvaYpyAeNmQ1y2AF134cxmDxZ89N6rccF+iMYLwXmu3S6WXoRET5pLN75SkhYZ430ImMZEAp5+HOowYaFYm3RxWUriqTs5a6cnMLuEqUyH7xQH3U1TrapUAlgKlex04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718506456; c=relaxed/simple;
	bh=MAy/m30nXPFeF1JGrpT8ZKuHFrgcJEKG+VYwVDErsH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z9+8Qcl0lPLxcqI5GiHeRkZ5QKoJuexNZxybhSx8qw0ithRsvAJMcNiZGjQmsb3ISXZOUrpAJuizhyZ4SBdsKYD/73mKvDJIQTvzhwA1rcYmE+EOwiQYyHJ9eQrc8udvdBz/pq5BXgeVb7O/SZC1V1SLJS4G5MQrsYph9ehKa30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S7q3z3Uv; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2c2cb6750fcso638919a91.1
        for <io-uring@vger.kernel.org>; Sat, 15 Jun 2024 19:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718506453; x=1719111253; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SgA1d2/VOH0FcQ9SgVQKQDKyZjj/f2khP8DaZk66WXU=;
        b=S7q3z3Uv7e0+4vXrdEvL9/QQuAI5+rkYbvvCWxYOplFyAD7zEabx5PKjqZUl2KQt6l
         OIL2M8aFgau4vrwm8Jodb7QSOaojhx7t2+4mxVs+nCMlF7CDT+BilDyqLcFWFjGWmq0+
         UkjpAbPAwtUL3Pzsf8al2dDHpQ7MvYVDpcysP9lBLLq1g8tU1AhxqvmPnuFRyTqYwMrl
         fjhDLZPTi1cQx5iVKaZclof3tATQrD9zkm/3MIMynQSwaRiNhLSscNAggm847skAPbnW
         G2/tyRrnsMD26uA1rKb8G1WluHUkZEPDpKoL3yTVOWmponMxCN00gi6oTphhYA1UDP3A
         tMaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718506453; x=1719111253;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SgA1d2/VOH0FcQ9SgVQKQDKyZjj/f2khP8DaZk66WXU=;
        b=b8oJIG3XAXMwVA//53stmNf+eFiRnXV1ezKlS+Xrejrn7K0dEmCeIIamZ5cpCBYGyn
         dM8MN62lScCvJiEH77leubcfVwnkAERclptHVlEmCAWlt7epjKsYXp/1cBBhNjiKh719
         F5THh6MFMt8lLJaOoyCyjCrZvvP8RESFbUvHPlUPTQ21nikDOYamrbKVlBFQWJ5/vqiZ
         /0uKAhEZIQEniQJLgb7lAnK6GK8ISmZeVc8SgSkrVvASPLm0kt5G20dOFDXVDy3MT97Z
         cIEGXm7t8jmE1eGVd/SunE2NiaQWgna6NBKoFwGtIle86Nj8unvq+D102+D/NxLTq2D/
         y1vA==
X-Forwarded-Encrypted: i=1; AJvYcCXX0287jt+zfICkiQk5DV1iRaG1GrcYcVpy0Snbox0RODTsHs/lLeMv8y00EMgyA2pMaFEmnKfCLKM7OzDE1CeG1HSOSVdJaq0=
X-Gm-Message-State: AOJu0Yx4R8S3dUny+AAedci7ljyBwVKjQcygitRUPzxoSupvJb7Z8t0F
	tcpF0sI/X9bCX7jKhUyTA/cTZ5uBiaUfEKCOoOfKJfdMuTCVvNY7PBJD2zosXg0=
X-Google-Smtp-Source: AGHT+IGsoyvg4l3jXJkMph9XXcpowocfGuMn1ftzbTNQqsj2iHLh0X8rb6LSpDqcO2M+lFT4q3N77w==
X-Received: by 2002:a17:902:e543:b0:1f7:2dca:ea32 with SMTP id d9443c01a7336-1f862c1db23mr77221255ad.3.1718506453182;
        Sat, 15 Jun 2024 19:54:13 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855e55ca1sm56477325ad.49.2024.06.15.19.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Jun 2024 19:54:12 -0700 (PDT)
Message-ID: <aaad076c-af5b-46fa-9f74-0c1e8358715b@kernel.dk>
Date: Sat, 15 Jun 2024 20:54:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
To: Chenliang Li <cliang01.li@samsung.com>
Cc: anuj1072538@gmail.com, anuj20.g@samsung.com, asml.silence@gmail.com,
 gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
 kundan.kumar@samsung.com, peiwei.li@samsung.com
References: <20240530051044.1405410-1-cliang01.li@samsung.com>
 <CGME20240613024932epcas5p2f053609efe7e9fb3d87318a66c2ccf53@epcas5p2.samsung.com>
 <20240613024926.2925-1-cliang01.li@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240613024926.2925-1-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/12/24 8:49 PM, Chenliang Li wrote:
> On Thu, 30 May 2024 13:10:44 +0800, Chenliang Li wrote:
>> On Thu, 16 May 2024 08:58:03 -0600, Jens Axboe wrote:
>>> The change looks pretty reasonable to me. I'd love for the test cases to
>>> try and hit corner cases, as it's really more of a functionality test
>>> right now. We should include things like one-off huge pages, ensure we
>>> don't coalesce where we should not, etc.
>>
>> Hi Jens, the testcases are updated here:
>> https://lore.kernel.org/io-uring/20240530031548.1401768-1-cliang01.li@samsung.com/T/#u
>> Add several corner cases this time, works fine. Please take a look.
> 
> Hi, a gentle ping here.
> The latest liburing testcase: https://lore.kernel.org/io-uring/20240531052023.1446914-1-cliang01.li@samsung.com/

I'll take a look on Monday, thanks.

-- 
Jens Axboe



