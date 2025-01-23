Return-Path: <io-uring+bounces-6107-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 524C8A1AD30
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 00:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FD28169197
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 23:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 805B11CEE9F;
	Thu, 23 Jan 2025 23:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VOjCJFCP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28D71CAA83;
	Thu, 23 Jan 2025 23:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737674412; cv=none; b=jbrr9ytSlZ+deuabt975fvu+zH1mtUa+W4vse21OxXbZ3cBMHchmDLcmVLV0ROod9QR1JWx6Ccxr1Gzw7wVaA5STEoxzCcbsf7p7DctwseDFq2mzSH6w6tnvxt+XYhGIepmHohLDiAQdFjtcWpFrBO7XboJYeEhpbzYf4YTq/zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737674412; c=relaxed/simple;
	bh=0uqavqoxj1FGij5M52aWjZZmcjPUuADD59Jx3cQU1is=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sc/HyOiFOMLbZEDvZHZGukhYnDbDvc1MOG5+tee+zbgk3Ng9mQiK58HG5aL4Oe0dzDyLzUNfVtzwJHE27Q/JHvFFJ8hvdGDWf2YrakusrDa+mAKL8P4w5UFEWIlNNZQ5TMlkL74LwAVRIORBBIS5DGZyqcCMuYbRy/Uy9wbgSFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VOjCJFCP; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aaec61d0f65so331762066b.1;
        Thu, 23 Jan 2025 15:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737674409; x=1738279209; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1100t6Z2WADpCSMQ521oIcYSyaD3rMWmlFFPXP56KpY=;
        b=VOjCJFCP4XcZ6Zyr5BRhq7JggwWWKz3eXcX9BfnBLAIvnwWX55xCcJnu9yl5zJWKN0
         M7dfLjNh4Rc4Irwk84gKiQ4k2ERK1fW0tz6LH5HDapb7f25JoxpET59Ny8PnC65kDqPh
         TyPGBbDJwYS5p9eXAiNsWtUcLDw0NTtAGIa0tiabwBa2lzqkJq3tdPVZ+WTvP46LfGP1
         j6N/lsMWjqtUu08DKGwTSM+tA7GeDe6QeverhuWLpzjqRVpepAfP2ol+tr3J3mXhvAcC
         fNzrdsXw9FBblF8CPqQnXf2gBos093SZp3fNTwsnW0SnJuBlIRR945T/flIARNNRBMus
         kMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737674409; x=1738279209;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1100t6Z2WADpCSMQ521oIcYSyaD3rMWmlFFPXP56KpY=;
        b=kPfU9G0TKPunCCuJ1HuIH/bEEgjwbeD/UI69SRNOJfeDUT1PMm9nn3DtmI/O8dpbFK
         2VUxraQgLrjFDF+pjwAvp3Nyu57rVVwb7upnqrMxVfQ4p4hqiuRzYsPW/v5OEUPcXIMq
         H/ITRfZ/qf2yrnkRxtocyX8ToFd0+D1evIYR6Mk64Z9T+oW2XB6EBLXT0wKn3YFY5Rh3
         4GE/pUqbw9pZfG9diUZa7v+PEW1GtPw91cadkiuCBe2bdKhzQHdye3NVejNQHdA0UlG3
         Pu66RSVmCZJ/cTGyxH3pU44neJ6OcJmb9UnW0hb16eVuCEUuertxVRuoqMoC86vqIQo4
         Thlg==
X-Forwarded-Encrypted: i=1; AJvYcCUdCixz4ANJOCATjLkV7N7RDgjz4IY1pa2vTu9osVRJhWtS4RVq+uDQCCaepICs3Tjbk+oz0kcxdw==@vger.kernel.org, AJvYcCVL+N9Q6pwj0K9c6HNPcXw2Mb1Aub5+g33RzozP8jGQy5roCmoQTDSwWiuh2y+IAb3HQOhNoIrcAxVik9Q3@vger.kernel.org
X-Gm-Message-State: AOJu0YyOa0838dMmwzUFaLF6gNgZUk+POP0e4WxctDb8X0uVRDJfx59/
	pQ8pPRGlf1IOmOGMsJ1YgxijLAV5d9CiZOKkUZz0pt1NL4bI7eo4
X-Gm-Gg: ASbGncsi1ETQVNN8lNRVGvr5IyxJ/CTlAK11RVwA5WKkxAkPgJ4OKZVrPvNyQSGGNYd
	1WXKCeGsOx2uzGvYad8EIHzcmXCq9oNFIx04xW1FrlC6Spk2WvCVR/zC8byUuVx0Bxz/oImyDr5
	TxhxnDXpBzPCnUfYaTmgrY6GC+z+WvCRgDYv2dft6k3TfqY7gPTUSMIT040uEKfqMcwLJofqq5b
	ps0d8Kh/s8f2TliKqASRmhPy9TUCL0qytdZoeBkbotR8j0xQjoDBtXV4DIBr6r2ueXurPPUgZfs
	gICJUQfUf2iclKY=
X-Google-Smtp-Source: AGHT+IHgWJu69C4L+ydARrzhs3ceb4GR3YuNCAm1GWrkvCggk5kH0lDtmiXzhohqkColNIe+S3RGiA==
X-Received: by 2002:a17:907:7ba9:b0:aab:8ca7:43df with SMTP id a640c23a62f3a-ab38b37eb9fmr2862357966b.39.1737674408737;
        Thu, 23 Jan 2025 15:20:08 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.156])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab676114e14sm28878366b.163.2025.01.23.15.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 15:20:08 -0800 (PST)
Message-ID: <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
Date: Thu, 23 Jan 2025 23:20:40 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
To: Salvatore Bonaccorso <carnil@debian.org>,
 Xan Charbonnet <xan@charbonnet.com>, 1093243@bugs.debian.org,
 Jens Axboe <axboe@kernel.dk>
Cc: Bernhard Schmidt <berni@debian.org>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
 <Z5KrQktoX4f2ysXI@eldamar.lan>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z5KrQktoX4f2ysXI@eldamar.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/25 20:49, Salvatore Bonaccorso wrote:
> Hi Xan,
> 
> On Thu, Jan 23, 2025 at 02:31:34PM -0600, Xan Charbonnet wrote:
>> I rented a Linode and have been trying to load it down with sysbench
>> activity while doing a mariabackup and a mysqldump, also while spinning up
>> the CPU with zstd benchmarks.  So far I've had no luck triggering the fault.
>>
>> I've also been doing some kernel compilation.  I followed this guide:
>> https://www.dwarmstrong.org/kernel/
>> (except that I used make -j24 to build in parallel and used make
>> localmodconfig to compile only the modules I need)
>>
>> I've built the following kernels:
>> 6.1.123 (equivalent to linux-image-6.1.0-29-amd64)
>> 6.1.122
>> 6.1.121
>> 6.1.120
>>
>> So far they have all exhibited the behavior.  Next up is 6.1.119 which is
>> equivalent to linux-image-6.1.0-28-amd64.  My expectation is that the fault
>> will not appear for this kernel.
>>
>> It looks like the issue is here somewhere:
>> https://www.kernel.org/pub/linux/kernel/v6.x/ChangeLog-6.1.120
>>
>> I have to work on some other things, and it'll take a while to prove the
>> negative (that is, to know that the failure isn't happening).  I'll post
>> back with the 6.1.119 results when I have them.
> 
> Additionally please try with 6.1.120 and revert this commit
> 
> 3ab9326f93ec ("io_uring: wake up optimisations")
> 
> (which landed in 6.1.120).
> 
> If that solves the problem maybe we miss some prequisites in the 6.1.y
> series here?

I'm not sure why the commit was backported (need to look it up),
but from a quick look it does seem to miss a barrier present in
the original patch.

-- 
Pavel Begunkov


