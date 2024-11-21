Return-Path: <io-uring+bounces-4929-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11C1A9D4F8A
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 16:15:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 49E1EB24AA8
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 487061D7E4E;
	Thu, 21 Nov 2024 15:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ObRz4nP4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF541D932F
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732202122; cv=none; b=ILFrEiB/RSIf3syzBu2ZX3j4eNfNGmOtoG0xXPnn0rg1aWaioZdJ35onx0Goj7jPjYIk0ziVPC1BuB44m3X+nKB6O4pJPofWUY21elogUWicdpBA7sig8RU7D9u31eZIkRW/Jx7g4NLPfvGUL89WTm4CJs6DjP+6DzHlkp4g1H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732202122; c=relaxed/simple;
	bh=LznoQQ8urXUeQF5poTATRBT1Q300CZ7QbP5Xf5JuPt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rfYyJlPiKGqTgJhzM/Qz/DpwMIPa1k0pr8k/2f6gUXOqH411ljuVAgFi4dQnye0/IM7SJg10mlfFuosdzCSJ5xX5DctNzbblWky8TeIBQbnyP1Vz+mmLNiN8chebZCB8skhatNgdoc2lrNk7dovQ8QRl+dC1592RI/Ky8ccarGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ObRz4nP4; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5ef0909376dso516854eaf.1
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 07:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732202117; x=1732806917; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tjh4z561JdeBjN+ma1qAKRTnhU+qJYJgb8OhH19jCVg=;
        b=ObRz4nP4X4guuU2lXTboQbfjWaYql+SOEDEM5bcHvnFY7jzpTXsXFNVUvfcfWmiEsu
         PPcuE0aAxEwaVth0u/eQvoqIgnk9wFIVpUOFXkGz6ZcWoCbx4iPJgXvpyUIzOCC4EwvD
         O2viwP5cPusKcEe8aQUaS6v5SMIOqe6kZZHoDHrD6pIRnffxvrgTdA88fV/fUgdTteHa
         Q2oFwMLivvMo3rKEwc286oyEAd6thvkZ0LoWKlWhCqKJJBlZUe/09bAUDOQlLWOjYMnP
         YzOfD3BSP3+zYiuO/lJwiIdNLuIo2AFvK5S5nAon1Comt+9w/IoMnyW9Xv4UsLNmUJCj
         EbQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732202117; x=1732806917;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tjh4z561JdeBjN+ma1qAKRTnhU+qJYJgb8OhH19jCVg=;
        b=AvV72I6jPdqu0Bapw94npRX/Ot+DhzSo2TmlQy2PyT/z/XOeeriganNS0Z95STg16k
         fOIMxS3F2SikUFajwX1oMnJ5qJq04YO3jWWRk0+V9lKiwe8mGhnrybcWM9w06Ai8vV9s
         5Ma4EBEufOcgqazSzCORHNIH/K/P/IZ6FPqKkZDR5OJWU6w2WFYOpLSnnfEfUelk7dIe
         Gt/1LhDpFTM5Nh7m6AYXvDa6kPvauQtQKpIOM8PMu0DHsxXPVoU8aYwknCvLIUn992I/
         6qoZ3xzjG/KGfUEFn5NAow+3SIC592Mf2sF/AAZvS0SqMXMi+WqwTUVcVON3jZ1S9hvB
         hvmg==
X-Forwarded-Encrypted: i=1; AJvYcCUySZXMaln8reTayGPcl87cdYd4S0sa5L9e51VLZFgZbAd0Xyzz10M7SwZ0L4Qcl0JszkgS2rNqhw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyoIRdVkX45C5QqIc9ojtrQiurbacTJCX4pZQXLH/O5WqZUEREM
	xkl0EwrCEnE5NltlgIhqU5Vf/FKTd9eOQhlw41w7kY2gtV0hOjleMLFt111t644=
X-Gm-Gg: ASbGncsUGAVii7us0+iolfUD5/qANYD3CtpiZ6U2mnH8ihN4YhnTyLVttXxl/N4jiyj
	82IegmfLw6KnqFpQ4VRkzS4Ocn8F6TRIRWdAG0jsvNildKilHRWSrlqhld/uwgnbFx8cw5nE31n
	pyUn6e6WaUJ29w5txcxK8x9nbii7j09xJN7pdKZRc6j/+nPWavCEbR8aitbq15aP27r5oeUBhuo
	GSrxMczKzQkMIoiUyilDpS92Iat06vnW5EwPp0amfvGYw==
X-Google-Smtp-Source: AGHT+IFOfu98N93r0DOJE7jvnWzCw7de+VwVC9h7lLnN3k28idY4ThwC4Hq0JoEv9yDtaxUpDcqEwA==
X-Received: by 2002:a05:6820:2d08:b0:5e1:ebf1:816d with SMTP id 006d021491bc7-5eee823d2e4mr6761229eaf.4.1732202117421;
        Thu, 21 Nov 2024 07:15:17 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5ef09096c7fsm538723eaf.42.2024.11.21.07.15.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 07:15:15 -0800 (PST)
Message-ID: <9859667c-0fbf-4aa5-9779-dae91a9c128b@kernel.dk>
Date: Thu, 21 Nov 2024 08:15:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
 <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
 <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
 <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/24 8:07 AM, Pavel Begunkov wrote:
>> At least for now, there's a real issue reported and we should fix it. I
>> think the current patches are fine in that regard. That doesn't mean we
>> can't potentially make it better, we should certainly investigate that.
>> But I don't see the current patches as being suboptimal really, they are
>> definitely good enough as-is for solving the issue.
> 
> That's fair enough, but I still would love to know how frequent
> it is. There is no purpose in optimising it as hot/slow path if
> it triggers every fifth run or such. David, how easy it is to
> get some stats? We can hack up some bpftrace script

As mentioned, I don't think it's a frequent occurence in the sense that
it happens all the time, but it's one of those "if it hits, we're
screwed" cases as now we're way over budget. And we have zero limiting
in place to prevent it from happening. As such it doesn't really matter
how frequent it is, all that matters is that it cannot happen.

In terms of a different approach, eg "we can tolerate a bit more
overhead for the overrun case happening", then yeah that'd be
interesting as it may guide improvements. But the frequency of it
occuring for one case doesn't mean that it won't be a "hits 50% of the
time" for some other case. Living with a separate retry list (which is
lockless, after all) seems to me to be the least of all evils, as the
overhead is both limited and constant in all cases.

I'd rather entertain NOT using llists for this in the first place, as it
gets rid of the reversing which is the main cost here. That won't change
the need for a retry list necessarily, as I think we'd be better off
with a lockless retry list still. But at least it'd get rid of the
reversing. Let me see if I can dig out that patch... Totally orthogonal
to this topic, obviously.

-- 
Jens Axboe

