Return-Path: <io-uring+bounces-8428-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1980ADF186
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 17:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D49C3AF8F6
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 15:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990E32EE26E;
	Wed, 18 Jun 2025 15:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c2ejdJ2F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C748A2EFDA7;
	Wed, 18 Jun 2025 15:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750261172; cv=none; b=fiY98+/QkoxZ4GvHRnwwAv7+MrVuF7JLrr05g+8jKrmKznEYJUFqFackw9LPo6d0TD/ob2M6XURwvWe4cIvSC4hP1wwQbAyA1+BjXMSMEr8q2uGKEG6z2QyiFLNTtJIIGKngtMaKgKAemUlxt1v1nPxOpGSSM/3tQF7QAuB7RJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750261172; c=relaxed/simple;
	bh=7lErsAHSRoCyQEMmRAoJeuAHaQ8/QZ36UhrYB62zQHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XIAT5/O4CSrDnkXkbstAVDAgNxG3WUELb82HRsHr1A9zGmdCRRgmvuRzhyoKLVdN55u6/t9BX2YYTlgaYMafD+q8w33g/wL6vlPNjdBPBIkEnoDi64Q4tDO1D+H4hfIVXYiyJ6685k6i1SKrHBfwhbpNS0YNpoFrBl5cwes0gH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c2ejdJ2F; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ade750971f2so934653266b.2;
        Wed, 18 Jun 2025 08:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750261169; x=1750865969; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0+WVJxBsXeB2LzI73CXOJ5+vwmAsCvL86Bnd2mBbtAQ=;
        b=c2ejdJ2FDe3YyBDNOBbRo1SLDgjn6V0FiAhVIpmsr8uZWaKgzygaVsCxeV0HFdlO8y
         zKtpP++cfqVOxVwto7ScXBNt+mpJumtkxh3xkQ14lgkhoFaHhj4kVpg/hGwUn+GhjMXk
         KIGio5Z8UCIM64HApZc6g43usEam3XXnroBZfwsRCLHJ5dPFPCsGfcnApbJgI0SmPuHz
         2uYDfYzf4Q25e3YULKuePIMeRHC+xEKhLCeXxz5euOb/Xpy2X42TITl4Bf4vBC6sb8Ul
         6eximFl7VRJcRb6GyL9UBAOQPw+LCTSn4PAOLki70TbzRbwSh0oVuTwrNNos57/x4O3M
         dsyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750261169; x=1750865969;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0+WVJxBsXeB2LzI73CXOJ5+vwmAsCvL86Bnd2mBbtAQ=;
        b=hlKeS1IRIrkbk8yPR6riU7o1BdgM9YaGHe0s2TOeVkKxgDXO++BZvbpRE4kpugUJEI
         WNNo6x6Vhw8NzgcZ0bBN3840e8/Sc710s8n1JaQeBWsfH5hJFMTrCtaAR+bWz9AZLszR
         P5qNkN2Go98Ll4dljfJM+A42U7qVpBJczv/SU5YXjB2NR1yJEI0bn9ztDCxSpjCMyk3B
         F01DP3K6cem7AyZ1vP88nf4q5QFiu/jvdxBnwU9em1uo++6wfGcsV0iCjdTsupBQ2AD6
         jQlp0pDNbEWgwEP8uC3CxctEhpKoAXfTQ0DX8KycRYtb5QZfJh7fYxW3Uit+1PveYYe5
         O0AA==
X-Forwarded-Encrypted: i=1; AJvYcCXH8j49cx+IvJ9NLwmOu5dHChC/wAcd3A9zpoFAR+PmcGJhQx9IXPi1mB43Jlf++kuu//GzEKTCMJz+PxxqXA==@vger.kernel.org, AJvYcCXXeYcu5PHClOyiCwufAIWKBPss3ayGhHryuuTISfOhfDZ6dZT8VG0EdZKPX+/oL7mkyXDtC8kzCA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyrLuC9FHEpYoQSwxWjpBbNyT9SEZWD9yyKZkGjC1On9OBMRmY7
	kliCnw2DqzvrADashMOzZXy0PagS5C8w4WppJsVDmifkKEPA34tt67bj
X-Gm-Gg: ASbGncvnsIV9dgxO1M/Jr7aLUQgtn6axSuEzwlKJL65OR0LmIimbvPy/joq0M0fzSmW
	NeNWLFvpEaowjC+y047Tk1ohC13t19m0yRASP0ZVZ4A2DeeCbDoMawYaEqvyFO6wSQeWzRNBVc5
	k90RslNVIMFvPvL5kzM4q+9H5cLQWcaIPgu2oXNBzINQlILpEpOgB2/TyULkqm2lAIZZ5BfvsGx
	eJ/0lW+0QePEtMI/1mnnKf7IrPVtMW+wVNz5Emgh8ldvqHZqXVKpBZlAN8fYbtQ2D4lnOLmVyid
	hICHMoUMZNHFaz0JY+i6VQ+t1w6V1DXJPItko3iYPjcZpHefgoZrPdDpYTHTon4nLNXiQEA=
X-Google-Smtp-Source: AGHT+IGr1F+id+XITad14BlMe6GcxiFKdR9ap4zvcM+8Wpqe/H6QSqtveU0SqzXbNEX1fb0XeP8VtA==
X-Received: by 2002:a17:907:1c0d:b0:ad2:2ef3:d487 with SMTP id a640c23a62f3a-adfad4f68f8mr1503412266b.58.1750261168737;
        Wed, 18 Jun 2025 08:39:28 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8159377sm1066214866b.9.2025.06.18.08.39.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 08:39:28 -0700 (PDT)
Message-ID: <a60a8c3e-e777-4f2f-ad83-916bb7b5bd2b@gmail.com>
Date: Wed, 18 Jun 2025 16:40:45 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/17] fuse: fuse-over-io-uring.
To: Keith Busch <kbusch@kernel.org>, Bernd Schubert <bschubert@ddn.com>
Cc: "xiaobing.li" <xiaobing.li@samsung.com>, amir73il@gmail.com,
 axboe@kernel.dk, io-uring@vger.kernel.org, joannelkoong@gmail.com,
 josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, miklos@szeredi.hu,
 tom.leiming@gmail.com, kun.dou@samsung.com, peiwei.li@samsung.com,
 xue01.he@samsung.com, cliang01.li@samsung.com, joshi.k@samsung.com,
 David Wei <dw@davidwei.uk>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <CGME20250618105918epcas5p472b61890ece3e8044e7172785f469cc0@epcas5p4.samsung.com>
 <20250618105435.148458-1-xiaobing.li@samsung.com>
 <dc5ef402-9727-4168-bdf4-b90217914841@ddn.com> <aFLbq5zYU6_qu_Yk@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aFLbq5zYU6_qu_Yk@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/25 16:30, Keith Busch wrote:
> On Wed, Jun 18, 2025 at 03:13:41PM +0200, Bernd Schubert wrote:
>> On 6/18/25 12:54, xiaobing.li wrote:
>>>
>>> Hi Bernd,
>>>
>>> Do you have any plans to add zero copy solution? We are interested in
>>> FUSE's zero copy solution and conducting research in code.
>>> If you have no plans in this regard for the time being, we intend to
>>>   submit our solution.
>>
>> Hi Xiobing,
>>
>> Keith (add to CC) did some work for that in ublk and also planned to
>> work on that for fuse (or a colleague). Maybe Keith could
>> give an update.
> 
> I was initially asked to implement a similar solution that ublk uses for
> zero-copy, but the requirements changed such that it won't work. The
> ublk server can't directly access the zero-copy buffers. It can only
> indirectly refer to it with an io_ring registered buffer index, which is
> fine my ublk use case, but the fuse server that I was trying to
> enable does in fact need to directly access that data.
> 
> My colleauge had been working a solution, but it required shared memory
> between the application and the fuse server, and therefore cooperation
> between them, which is rather limiting. It's still on his to-do list,
> but I don't think it's a high priority at the moment. If you have
> something in the works, please feel free to share it when you're ready,
> and I would be interested to review.

CC David

-- 
Pavel Begunkov


