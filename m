Return-Path: <io-uring+bounces-8524-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F5AEAEE4F0
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:48:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3876A189BC91
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 16:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E148A1990D8;
	Mon, 30 Jun 2025 16:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C4HhZGZX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305408460
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751302085; cv=none; b=WxrquyJR/qsRcPj6oZdm/N+/LMq6fpj3AptgsMYsTJQo7gBlIWVFJUvf7tx/OBuUojwMyD6LKvw5R42J7wwp/Rmo07B7VzoqTSjLd4nCnWZ2cNu40ajJCR45oJXEglnLr4P6OAh760TJ1ZSzSBviNjFLj5NP2SrT538zVfdnIC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751302085; c=relaxed/simple;
	bh=M/TWZJa4acvvJWixUJyz5CCBjZugrP//tY1Ew3Hl3d8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GMOgiUJOhHaE89MJe29Ttxg3Kgn3DoxOZ1eA2fLSqFwdvCk4M/5DPRzlFr7hCIr/WSPTxhJg/XpoVDlx/F18iv/9Xgpiqjdzy3Xzp3L1ljw7txB/knTAGXo/0EYH94RHYzo7NzW/jjX28Js5H58KQ8ZplQHkRroXyRPkYxwL3jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C4HhZGZX; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-86cf3a3d4ccso478382839f.3
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 09:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751302081; x=1751906881; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RjS7qC7e2waIXaU0tCSLDQ9d60EHxYBH9//6vYZ+75I=;
        b=C4HhZGZXsvR+iPA+wTsRTAu8MwmrLKvT7+q3RHibDYG+lnvAnPj/QdsgstfwdL2H9z
         Jl4OovC+VOYciUhv5wvKtegZEOjRQaVQI9G7vI26Ddu7Bm5IhlQVtgIvO/DsMuw7AeDP
         BpzoEBYvMOfHFqIiV6KcSQjNxfEM8L64JygkpcRRUpvykISXpT7evJSBTYqgd3zLdlmp
         6pCcZ4OhTShCYoT8yJY+qcJI9nL1WSuci0zU7g9waIzr3E/tu+4nI2b6feh+fLLRvyxP
         Z+N57gxtTW68QMUBzas3zWfSkBsglHl5m0p3f01xdvvz7QqSBD8ETzaCKYL/D6/zuj1o
         KcIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751302081; x=1751906881;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RjS7qC7e2waIXaU0tCSLDQ9d60EHxYBH9//6vYZ+75I=;
        b=CuHYH1ucczmfjHj/oty6wd5240QmF9owLPYiQmDAUcjjuSZcgtDXlOLgwxyEFpG5L9
         xfhtQICsa5kGDLD0ZS4fm+KqW2DTci0rzG+MrF88yvtQ8cl4Kmi7fblShL5exjTUN6C2
         LnajSl9/gniSjnc25AzMLfo8Uy7/nfjaVijONpz4rXmNUdjsvGnYbtWj6vG3hAYS8HJQ
         PT4BeMl1i8NhQyMk0qrrKgoQVe2Xpx+e6wg1u4acDCwXFBamG18tUM8HyOLOmcHI27mD
         KI02DOxAG1gl0JFDXm/wVBLnKMnV8u84M1oPwsQ+s905CxqGpxT891UpDM2+QswHpWyp
         CKJg==
X-Forwarded-Encrypted: i=1; AJvYcCWU/hi3738TELV9KoA6ctopKaYlo79zH5NtCcLgDBdFesUVPu2k76HCaonBoGdtG37MTT/YPgE1CQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWXvxBDFAaepLlvd2jv8GLSGIzRjzmP+AwNhBmeLGCACMuqCD9
	0yjQ6oJtHxxxo70Cv832Qcpt/+rSTORlI6DnynYgA4Fwi8SyR3ALWZMJTYUtNxHd8GM=
X-Gm-Gg: ASbGncv/R8/T9b635G//w+q8/f9/vmKZiGWEgpobCHEbJaVbtbZFXTFbcsFcJiBwZM1
	us353fexbIjXufRprOelR0iQ7kgQtQGmekDajMrQ/LOVL9h+3baRkgMZv8ZEQ9bWd+48V9hwj2A
	T5KpKAT1HT59bdqcSIMX3Kw4uFUvV4aZWOkchBrf4S/Rim5rZ3d8yJ1D03dzZZu6o3iO1QZuo2D
	jjnFbqhQwBMGCMJUsAdwA1FLUVvM0e6eINkyXrx2nLLgAgd5xXwJXaRDjbyTTx2TmcqN6ikDRoD
	lb1rYHmMrGau1HROVsVpePfYeEQwxRqqE4UeVRMwo9YF0mbIlYiOZJpU2DI=
X-Google-Smtp-Source: AGHT+IEDAvQnGdCWPRWWJKrfeXypjaZoxFXtahwTBzdNGV5QShmM35RwKCvHgnNyQaou7ojt6FpuNw==
X-Received: by 2002:a5d:8e0b:0:b0:875:b255:e6af with SMTP id ca18e2360f4ac-8768836adf1mr1043673839f.10.1751302081131;
        Mon, 30 Jun 2025 09:48:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50204a5373asm2027832173.76.2025.06.30.09.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 09:48:00 -0700 (PDT)
Message-ID: <2a2ac741-7952-4b7d-a731-5db7b40ea19f@kernel.dk>
Date: Mon, 30 Jun 2025 10:47:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] tests: timestamp example
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1751299730.git.asml.silence@gmail.com>
 <4ba2daee657f4ff41fe4bcae1f75bc0ad7079d6d.1751299730.git.asml.silence@gmail.com>
 <accdc66c-1ee4-44af-9555-be2bd9236e25@kernel.dk>
 <79255ffd-9985-41f4-b404-4478d11501e5@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <79255ffd-9985-41f4-b404-4478d11501e5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/30/25 10:45 AM, Pavel Begunkov wrote:
> On 6/30/25 17:20, Jens Axboe wrote:
>> On 6/30/25 10:09 AM, Pavel Begunkov wrote:
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>
>> A bit of commit message might be nice? Ditto the other patch.
>> I know they are pretty straight forward, but doesn't hurt to
>> spell out a bit why the change is being made.
> 
> It's not like there is much to describe. The only bit
> I can add is the reference to the selftest as per the CV

Agree, but even a link to the cover letter for the feature would be
nice, then people can at least look it up rather than need to search for
what it is.

>>> +#ifndef SCM_TS_OPT_ID
>>> +#define SCM_TS_OPT_ID 0
>>> +#endif
> 
> Otherwise it needs to be
> 
> #ifdef SCM_TS_OPT_ID
> 
> All tests using SCM_TS_OPT_ID
> 
> #else
> int main() {
>     return skip;
> }
> #endif
> 
> which is even uglier

That's not what I meant, as per below. It was about defining it to
something valid, rather than gate the entire test on the define being
available.

>> This one had me a bit puzzled, particularly with:
>>
>>> +    if (SCM_TS_OPT_ID == 0) {
>>> +        fprintf(stderr, "no SCM_TS_OPT_ID, skip\n");
>>> +        return T_EXIT_SKIP;
>>> +    }
>>
>> as that'll just make the test skip on even my debian unstable/testing
>> base as it's still not defined there. But I guess it's because it's arch
>> specific? FWIW, looks like anything but sparc/parisc define it as 81,
>> hence in terms of coverage might be better to simply define it for
>> anything but those and actually have the test run?
> 
> That only works until someone runs it on those arches and complain,
> i.e. delaying the problem. And I honesty don't want to parse the
> current architecture and figuring the value just for a test.

Since it's just those two obscure archs that nobody uses, I can just add
it after the fact. I'd rather deal with that than not have the test run
just because some arch relics use private defines. Not a big deal.

-- 
Jens Axboe

