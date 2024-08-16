Return-Path: <io-uring+bounces-2788-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ECE7954C56
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 16:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61E3D1C231B6
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 14:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1AA81E520;
	Fri, 16 Aug 2024 14:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EeUAWI1o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B49615B0FF
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 14:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723818379; cv=none; b=B+lU/pWd7/+NdLFWu4yK9eOd9bErzOV5BrwU6AA05wuMXXg3tjYUtfA1UInA6qhhJho+vAIGyX2KdWieNqwD46LZhcrEKPTFQ0Nfe2wNHTwPNVBjPX2dmgMLdpzB63ovwI/L1JubWi+sba1LQ7DNtV+Mj4Qj0PA6zygcBXk9I5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723818379; c=relaxed/simple;
	bh=rQriNfu1iOOVe6oRcAFH/toye/dWGssHI6OEameAUpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kvMoKa82AKQBDDFw65yGt48K7waKgQFSY54kZG6YTPTqZtvHBqxLXNpt/945VwnAAm2W9u+fwMlstzs4Iu7DxN4gRr/j/wg9yOsh08NAnx9FZTmdCbPX4N1qyAJ4XSGoU86GZi+A1J6s82QFiXjGZ1QPULc4fE+OVFLBZNYPj20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EeUAWI1o; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a83869373b6so179788166b.2
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 07:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723818376; x=1724423176; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Bs0iSAXwPHrYV5Cc5VAxtGDHPK2ItRLvKlR4PBE90Hw=;
        b=EeUAWI1owQF7qEjZ4id15Zy//lrsK3X3F16QSb0OankXpW9ezbjv/SgSRRu+fQiePb
         bjdHfmpiyMSIJpLmRhPSCS0hcrCav2Wx0IH9jVyfCZA91PuVsv80ujsAlll712pOn26W
         +OSxqkAyUitiJm3nh0PEM96PSUxWqCKOQkR2z8BcxgnV+eklIN2LpMPfEyROxkMzeB9g
         eBqWqHcB37UfNxF9C/QaciNR2Da5wBuVkI9+s8VJKt1kvm7MZ2ew+BWrrFWF4p/i+JuM
         KF74fEcBRx97cB1sKRogmmRSIMT9DLtA0DdD/QAgWtGFo6SmKtEOG0EL5uCy668QyUqi
         lFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723818376; x=1724423176;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bs0iSAXwPHrYV5Cc5VAxtGDHPK2ItRLvKlR4PBE90Hw=;
        b=JrT3vKjhLJMv9hnkU3slZRG1BTwic+wQvdMatZqNWG98fD5gpcReZiWy3jJWsMt3sf
         5F352QaowwaYyXOflN97diryipHW9i+wBk8z21ASWjKFfrPFHmnftnzkmlt9ZuNre7xj
         1BcxGn1fybbG6IF9a8YRYpXBUifR+GsTQhFYKO4YTmgMVGazqptt7l5hux3fsM61GbFM
         Pu8w8TZsD1FL0DMgZ96/w8ACfoPmmf70gKsNPiQTjQyIYAFF2W5R85y6iHIKHHW0nts6
         0GLUNdzCI62XX/n+wfJGPszUR0WePiPVlzMUVvteSZE78t0sOdyMRQPv7Qdb5aIisOXK
         niNw==
X-Forwarded-Encrypted: i=1; AJvYcCVF/2vuSRVHmKGKH9UZYOEI3kcR2uBrf5UAeDdMeHN6ket585GUoYgtfWtJOTMCUVUvrxFzJY5GvIM7+4SUpYKi8GsHclXZBng=
X-Gm-Message-State: AOJu0YyIJzZ7x+2phtX/gue9tByS9qMrCuZS4qLQa+wmOr74z23Q0Fj0
	8yegibbJHXQuF4+eSe4jfp+FACh0iWO4nDvr1HbjxPqZo9nCZmG0
X-Google-Smtp-Source: AGHT+IG7bTBU9FysPhgCA0GYuBiax6/8w3oGg2WZXS+79RuNgMmnVGLmWphRRxpziyE5eo10tkcesA==
X-Received: by 2002:a17:906:d7cb:b0:a7a:c256:3cf with SMTP id a640c23a62f3a-a839292f3fdmr258025666b.24.1723818375963;
        Fri, 16 Aug 2024 07:26:15 -0700 (PDT)
Received: from [192.168.42.95] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838cfb53sm261246666b.79.2024.08.16.07.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 07:26:15 -0700 (PDT)
Message-ID: <c3a3f99a-586f-4910-9eda-facc8e6bf588@gmail.com>
Date: Fri, 16 Aug 2024 15:26:52 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] abstract napi tracking strategy
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <cover.1723567469.git.olivier@trillion01.com>
 <c614ee28-eeb2-43bd-ae06-cdde9fd6fee2@kernel.dk>
 <a818bc04dfdcdbacf7cc6bf90c03b8a81d051328.camel@trillion01.com>
 <631b17e3-0c95-4313-9a07-418cd1a248b7@kernel.dk>
 <f899f21be48509d72ed8a1955061bef98512fab4.camel@trillion01.com>
 <1b13d089da46f091d66bbc8f96b1d4da881e53d1.camel@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1b13d089da46f091d66bbc8f96b1d4da881e53d1.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/15/24 23:44, Olivier Langlois wrote:
> On Thu, 2024-08-15 at 18:17 -0400, Olivier Langlois wrote:
>>
>> To my eyes, what is really important, it is that absolute best
>> technical solution is choosen and the only way that this discussion
>> can
>> be done, it is with numbers. So I have created a small created a
>> small
>> benchmark program to compare a function pointer indirect call vs
>> selecting a function in a 3 branches if/else if/else block. Here are
>> the results:

FWIW, it's just one branch / two different options in this case.
We shouldn't be doing a call if napi has never been requested,
so napi_dont_do_anything callback is not an option.

>> ----------------------------------------------------------
>> Benchmark                Time             CPU   Iterations
>> ----------------------------------------------------------
>> BM_test_virtual      0.628 ns        0.627 ns    930255515
>> BM_test_ifElse        1.59 ns         1.58 ns    446805050
>>
> I have fixed my benchmark:
> 
> ----------------------------------------------------------
> Benchmark                Time             CPU   Iterations
> ----------------------------------------------------------
> BM_test_virtual       2.57 ns         2.53 ns    277764970
> BM_test_ifElse        1.58 ns         1.57 ns    445197861

You passed the compiler flags for mitigations, right?

-mindirect-branch=thunk  -mfunction-return=thunk -mindirect-branch-register

Regardless of overhead, my concern is the complexity and
amount of extra code. It's just over engineered. It's like
adding a virtual templated hierarchy of classes just to
implement a program that prints "2".

I pushed what I had (2 last patches), you can use it as a
reference, but be aware that it's a completely untested
draft with some obvious problems and ugly uapi.

https://github.com/isilence/linux.git manual-napi
https://github.com/isilence/linux/commits/manual-napi/

-- 
Pavel Begunkov

