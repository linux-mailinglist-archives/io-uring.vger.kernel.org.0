Return-Path: <io-uring+bounces-4177-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7BF09B591A
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 02:25:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8D351C22FE5
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 01:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6656C142E7C;
	Wed, 30 Oct 2024 01:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DXAkv8t2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356E9171CD;
	Wed, 30 Oct 2024 01:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730251519; cv=none; b=VQFY14GTyxXg+7c+rhtyQqMUFnAWr7ANzHOiyQK+bHPD+sp1a8O0k+kfFSa8rBPSDeoGnyBYZnARbHs/5E8ceJuxDmPl6fHbNAHzHBinM7VqbOJ0M2BmqDqOmWL9VDYKfCx/oWrV1XLOIj/tRfWpYtdzfbcfSp16QKk1AnanS+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730251519; c=relaxed/simple;
	bh=BukwrriuG8Q19i34UJMpZUYxgkG47HTu1fTJ3jvmKsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oupr4+pz8d2AB/+wkau5IP/bWyzOCc+cJvxJhi83v7ltr/5TGSb5j8nmPNfTY34wru8s7lyVX/2z/6E6UigqfTrPJKQf93m6/FzB4jjjrfGXfiqRnMiVswd1Tb9AgJiapl6VhYiK4Q5Kbl5LAn37WpUTgAah061CYSwAdG9Yxhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DXAkv8t2; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43163667f0eso56946015e9.0;
        Tue, 29 Oct 2024 18:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730251515; x=1730856315; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PT19Pqdmf6rUKXGNyTPCdXL7qGFoS3nXyhbhKzXGY94=;
        b=DXAkv8t2ZuzTKx21eF65y0X9y6r3NPBuIvC3oxpYCsNTEO6Ad7oiasjRmqE4p1cPMH
         PD394VqsYQndSs8zE9G/+RIINqoiXmyeM/RRbQBLBvDKuvvt3qnS6ETxbATeigRmHzG4
         d3F2CdiigrJvGHz+uxB68N+BNVmTcdEL3YUW/YAwj5E0vI7jqIcRs1wb+lSzeR9aw82V
         N2qnZYW8gcg/Cq00WrPnudbkyFxuqpBCMiPtf8WPA2lCT5sUnlDQbM0axYuY45xlsGA1
         FBI3EoEBr0ZvIISG+P+EP1nE3iDnIk2PeJ5XFibOXc1BnZhoCXqEeI+e+Eix2GwFHA+i
         9qzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730251515; x=1730856315;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PT19Pqdmf6rUKXGNyTPCdXL7qGFoS3nXyhbhKzXGY94=;
        b=G1Ot9MbeXqH80JT5ugH7z4KKjd8bLKRqJ1U2tsYMYPHJKsEB/4TyUAmvgn1tNY75OX
         2E6xcI11DFySb3hGkenJEBQ7o9FZIdvOMy+onsdY5rQIlBl/oqIn6xmTm9lffRaxqFR7
         UTWv+WIty0fM+dJkRt30A5FcBU17RHg5huf93G5nX2w+3bV72TQX8T5JC2KpaKzHXDf5
         ZFRgvaUVq0oB++nKmx3JHXW1u5c6gXbdNWRDss+D46YYB9qqwB1cR6i+dA98a6wfa3up
         9VaABBYk08ao/Ie8Mu+wY8pywVDBTPvwikkKZv7bQF9VnNEHvaYl3dl5z8hGk7BZ/5C9
         fx5g==
X-Forwarded-Encrypted: i=1; AJvYcCUfob2Fbs/URNfqVPz1vBOjQu4C+weuyzk2OAMQmmBn6HLj5FaH9ZRjBhp1X0+LV4Y/DpXXH57Rgu3UkBM=@vger.kernel.org, AJvYcCXMEjH8thzyqKJrcco7lJHVIqylB3e3sTOVeT0adAfW9h60f9gHfm1l3FcvEAMqtZeRUq1+K68aQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YynbCSgtO0i9Ee1fUugJtrGLvu0sKvua3Hphghk5qL6h/pk2Nvf
	0RhMckUyPYEurRugVZvyFhe1wKeFx3loPsUsP0MovnZO9eGOgU+j
X-Google-Smtp-Source: AGHT+IHXklTlZM8OI2GhRLKI4kTDBLfNU9YVFe7ldnFbTbhwVeIhGQ/YBdohCZX8EctRXs0K0Hmfiw==
X-Received: by 2002:a05:600c:350b:b0:431:44fe:fd9a with SMTP id 5b1f17b1804b1-4319acb8a7cmr114617205e9.19.1730251515402;
        Tue, 29 Oct 2024 18:25:15 -0700 (PDT)
Received: from [192.168.42.216] ([148.252.146.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd99edebsm5415825e9.45.2024.10.29.18.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 18:25:15 -0700 (PDT)
Message-ID: <bbf2612e-e029-460f-91cf-e1b00de3e656@gmail.com>
Date: Wed, 30 Oct 2024 01:25:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <20241025122247.3709133-6-ming.lei@redhat.com>
 <4576f723-5694-40b5-a656-abd1c8d05d62@gmail.com> <ZyGBlWUt02xJRQii@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZyGBlWUt02xJRQii@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/24 00:45, Ming Lei wrote:
> On Tue, Oct 29, 2024 at 04:47:59PM +0000, Pavel Begunkov wrote:
>> On 10/25/24 13:22, Ming Lei wrote:
>> ...
>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>> index 4bc0d762627d..5a2025d48804 100644
>>> --- a/io_uring/rw.c
>>> +++ b/io_uring/rw.c
>>> @@ -245,7 +245,8 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
>>>    	if (io_rw_alloc_async(req))
>>>    		return -ENOMEM;
>>> -	if (!do_import || io_do_buffer_select(req))
>>> +	if (!do_import || io_do_buffer_select(req) ||
>>> +	    io_use_leased_grp_kbuf(req))
>>>    		return 0;
>>>    	rw = req->async_data;
>>> @@ -489,6 +490,11 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
>>>    		}
>>>    		req_set_fail(req);
>>>    		req->cqe.res = res;
>>> +		if (io_use_leased_grp_kbuf(req)) {
>>
>> That's what I'm talking about, we're pushing more and
>> into the generic paths (or patching every single hot opcode
>> there is). You said it's fine for ublk the way it was, i.e.
>> without tracking, so let's then pretend it's a ublk specific
>> feature, kill that addition and settle at that if that's the
>> way to go.
> 
> As I mentioned before, it isn't ublk specific, zeroing is required
> because the buffer is kernel buffer, that is all. Any other approach
> needs this kind of handling too. The coming fuse zc need it.
> 
> And it can't be done in driver side, because driver has no idea how
> to consume the kernel buffer.
> 
> Also it is only required in case of short read/recv, and it isn't
> hot path, not mention it is just one check on request flag.

I agree, it's not hot, it's a failure path, and the recv side
is of medium hotness, but the main concern is that the feature
is too actively leaking into other requests.

-- 
Pavel Begunkov

