Return-Path: <io-uring+bounces-6628-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 436C2A4046B
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 01:52:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9E1E3B9B20
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 00:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0C6B78F29;
	Sat, 22 Feb 2025 00:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C5906z1g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283CA4EB50
	for <io-uring@vger.kernel.org>; Sat, 22 Feb 2025 00:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740185561; cv=none; b=oYRdWRwWYV+9sudaUnCgOnI8dDs4Tf18T1uvwhn9uiRGJe2khu/Zwj8eIJTwZRRV2vbWOiFxj/I0SbmjG9jgIOC74Jcfi9zQ/j7LzIGn6WZhuwhc3vZvfgiYU8A69BA6yYX/KRhBBeQCqQ669qsBnl7mQ5Pv0GzjpMMqOMn24Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740185561; c=relaxed/simple;
	bh=qLl1ci1ogYHXYlEiNeVmKo7f5B9hyBYm7e+03f1LII8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RkXszi1eiasV6zaMZ/vDafvYJVAuXAA3mRAkg1Xh3GI/uJi1fH3YBADbuVC25yZx8bAhfIdKEc//wZbbPd9wOqRVODS75nFmZjHt2pd+DMEpIom36OgqsANaIDN3CUK3UhmPsMwI3bR4g+iiwQ/bBKYMPKBmg0hJ2g8LmOx6JPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C5906z1g; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-85592116ca4so206369639f.1
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 16:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740185557; x=1740790357; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U5Sf3PdcH2UCr4NpNH3aNX+vclHBdn3bn/uKeeHtF64=;
        b=C5906z1gzfuIqueam0L58XpRrW44j9j2/l6mxRqy/cqb6Os0NAR6R26hB84IgCcMIF
         9gNpuW0tcvFJb6TEjOA2dtA/QCeTvscBJBj61PPUJCvxDQtd6iWb448Hmxp9Z6uyFQdm
         IUgRscvABHT7IV8qTX62rjrWcMy3f8qWO2N7W4ujYZZPkJFap1KPukw9E1xAGT7Rr/uu
         oECxaUn9LblPvqsn/DgTJpClXNwMtjP+UueoPIZ/0vR1LJhhLU0gGoybvWUJh1pgIrRB
         shnJ9JEMdjKAE9p4UlCjvppF/VOuGHZFRaoWBWHZAuC+OZE+4ZTZLtahWG5V9AnkG6aT
         Ctvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740185557; x=1740790357;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U5Sf3PdcH2UCr4NpNH3aNX+vclHBdn3bn/uKeeHtF64=;
        b=KVvr18rfp4pqi8wYhgr8dbVgEn1P/Zy6Uhg5YEL+DVszXwg8go/4wdtryR4JikXXAF
         1Vtc4wkD0uosl7Yik8Nh1R8dcm5dkgTlvsh+GdXzriRB6H9exBp/5TKcBKinYDfmIT5u
         CTJwglWg1UDvTYRhEAdqoYC5i39AlaHQUULgbu70RKzqfg8IEuDyITqtg6LBM2bK0B2F
         rwxehpWVVK1l7uWNh7k5ppe/2aFjLf1DwsXHFhl9Tp0CNKzGHKtv289pNq5NwY0HF9yR
         O177D8vPzqbJk6mx/66mE+BrntKRV7MgMZHT365wksyVVnGkpgp1ctSXCqKbvdPeBSie
         GlVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNiqz0W8vtH39w1SapzNRUVs1THNa6UIygYaaZ6GObSK1chPk25O2iJNfOd9/TUjzwdUVoXe7LWg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu1Ekks+i7/SnsWu8RYmfUmuyDnv4m7G5KYh/e5KMuZhAUzuH+
	u4be26aTT91QblBbg3WZUFyzlvoJZUGy88hg0AEn31FJJM5A6LJD1B288o4V4Ys=
X-Gm-Gg: ASbGncuKOq0LRc30jdKJyt138/NxirA6TU0KmIFYfXTALCvXHtZdKOBmMoeLjqqe393
	Q2HEnlR3OC3H95xWRzrnBgMuAvGzIrW1VT7SPUwg7uTCi1u2bMkXe6VM7X1vc1Je20EtC/joTJ0
	TIz/t7+JEdx/9brnCZ887NtSn1gkjmZGfua2Pim7z5Fob8os8AsdaYpxcGJyeax9frbdhTDBGJp
	V+yYHtzRTDyIYS6QoFyxk9/pgF3U3Z8XZKmzT0MwQu9S1TJ4S7dS+wdQx8Wo5MM7BF8O0ELaSsz
	60HVBI2nA91OsMfYHZESzew=
X-Google-Smtp-Source: AGHT+IGHII5en0drCyzlUORWiYv6SvW7U7C6I5bJp9Rfb7EzSGT8HQwzsbNo8GxIiQfzwiJNgaOSiQ==
X-Received: by 2002:a05:6602:1484:b0:855:9e01:9aca with SMTP id ca18e2360f4ac-855daa9e7e3mr612898539f.13.1740185557200;
        Fri, 21 Feb 2025 16:52:37 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-855921817b2sm244114339f.17.2025.02.21.16.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 16:52:36 -0800 (PST)
Message-ID: <a44a6ed1-8a4c-4334-9785-aee8b545c68d@kernel.dk>
Date: Fri, 21 Feb 2025 17:52:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
 <6165d6a4-a8d3-4c2f-8550-e157a279c8f3@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <6165d6a4-a8d3-4c2f-8550-e157a279c8f3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

>> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>       zc->ifq = req->ctx->ifq;
>>       if (!zc->ifq)
>>           return -EINVAL;
>> +    zc->len = READ_ONCE(sqe->len);
>> +    if (zc->len == UINT_MAX)
>> +        return -EINVAL;
> 
> The uapi gives u32, if we're using a special value it should
> match the type. ~(u32)0

Any syscall in Linux is capped at 2G anyway, so I think all of this
special meaning of ->len just needs to go away. Just ask for whatever
bytes you want, but yes more than 2G will not be supported anyway.

-- 
Jens Axboe

