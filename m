Return-Path: <io-uring+bounces-4936-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A609D50CE
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 17:43:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FBD91F2288C
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 16:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8921B487A7;
	Thu, 21 Nov 2024 16:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="grlU87pV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0A541C79
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 16:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732207388; cv=none; b=rjvQHpcXWw65596SbQgUK6bmFx5RWckgmCH2P5T11rR2XwJFnjxMDv1EPx3CpWl1rhSnZMntHot8rZBCI4ZeiiNzAIwJY42GiU/JV4qwQ7NykeQ6E3v6ssT0tLSSCG71DIC3tsBnK9wkc697AdNUxUQ7PHv7oNMPdakJyFxJutM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732207388; c=relaxed/simple;
	bh=ZqQPKcLr9QkBCNYEQ8kDqhE38Bo0vjoEbJT+XfyDPtM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jUxURMJZrljBQFUjPhgl8juVSxvO6j6Lgx+N0N6Jvrvx39sG03Fixh6wGRFe010NBbKM3lsi/chg5lmmV/oeWyRGdRotIpYxiuvAC3gvXKyyeB34jZ1wCNXOO9dYL6d+mv0uGOKAPnoRGzSTFthlG3MukBh5Mb7mhTrwYHSP4Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=grlU87pV; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a99f646ff1bso175789166b.2
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 08:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732207385; x=1732812185; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fkx2uSnSPPI0O3OrymR/btzV/7IjmGfI6bTFbRiuZNc=;
        b=grlU87pVMS+TCQ9rlr8oYRc/97Qs7b20vBs16Kza6fKJ8z8Pa9Az/0F75QCo5mZzib
         pPXpiGTc+DV2n1/Ri+tHmbpUmSsdvznSX06fHfkuXM7D+lJiVYJtVA4iv7A6zTfL14cD
         sQdsA3QNeH4bU0ykaikpNAXejG6M/sKqKOTLp0Q4A6zsIpkoyjXVoweaLtIQFUg2a0N9
         RCPWqK/l2ASYIl8K+hZakDo7k2dzB6IdclTqv3cTmUqkBoOLTYeQq64IGkcQnr5yAVBe
         SGfzEENZ/w3s53Dr34Zuqjyw/5f356Nxr6tzdAThj9RAhOJYcFLFHgqjSAW1tZ0K6E3j
         Ad1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732207385; x=1732812185;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fkx2uSnSPPI0O3OrymR/btzV/7IjmGfI6bTFbRiuZNc=;
        b=w3peohSuBX56SVdeYzlhepIgx2cM85I30ko6r2GvqvIrOPKRQ232IedvSLhpQ7LmqR
         fsYrGC046JI+4g9HsWHdN/5o49sHoJ6FVHR60vA165V4wZ1Vavr1fdJkK851cf+I5xEe
         Zo/epY8UvjF12xS0ADYlp4mV4+gQM4RMsxy9MyB33PNEatfuLt9jakLS4z9AO4Z9SpG1
         jVGH/0++8e+LBQY1o1NC/OpcZW0N6//Jh/8sqBKhnUftkNUVd6/9XZX/h6MkfJYmp8V2
         1nwLWhmfKUOx+Gtq8tS7QL8Vx1W7JLPjRT33d9umF0fX0lSB3FoVDQ1jcr4CZ98qpeSt
         TD0g==
X-Forwarded-Encrypted: i=1; AJvYcCW5/iczDIVscVUNlL/hhUE1/HAjF4uOE52N5hPdcsTzwoYEeOactNds1Boop6fIm/enaLqZDHHrWA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyI3uOo6Syz+CC8ayGrr92O6Z+lYtH15fVjAhmFUWygmZsXavG6
	nHCM4/Ty8Vg6Th5DKtliqvGeLhrn0SXaE+o4XNq9af8y2yKV1a068wkDPA==
X-Gm-Gg: ASbGncsyBXVurbR6ggQFwgItGx+qN7uzdyZScOVFfzZrAxyOUESJpoXBrC90oN1UkOA
	WcAtxeGDPTqxrUzBQCdATdfDP+P73W8HiULqZMoISmrrEmRjYyjrRhtcs3WiEYydZ7szgLuBWKs
	vw9JFg7SO1UWE6qzNXir9g1wj9/17UbGLw14rshr/YTxKIsihoTXg6dQ6eWQpAPFRt2AnSsdL6V
	U0SExd6doO5A99exnorydmW4pT0oxeA+joPj1pycxgDfaW4Mx+d745AKDaCbA==
X-Google-Smtp-Source: AGHT+IGKL8RlNtBkYE2w6ing4o7ooqfuhri9R4PAmxE25b/rDRXEy+MHYk7YShswxdvvbUVC1tkW8w==
X-Received: by 2002:a17:907:9281:b0:a9a:29a9:70bb with SMTP id a640c23a62f3a-aa4dd55f301mr754513266b.14.1732207385004;
        Thu, 21 Nov 2024 08:43:05 -0800 (PST)
Received: from [192.168.42.237] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f42d33f4sm99014766b.96.2024.11.21.08.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 08:43:04 -0800 (PST)
Message-ID: <c2f80710-7253-4dfb-a275-6698f65ab25c@gmail.com>
Date: Thu, 21 Nov 2024 16:43:56 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
 <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
 <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
 <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
 <9859667c-0fbf-4aa5-9779-dae91a9c128b@kernel.dk>
 <3e6a574c-27ae-47f4-a3e3-2be2c385f89b@kernel.dk>
 <357a3a72-5918-44e1-b84f-54ae093cf419@gmail.com>
 <375a1b30-5e68-439d-be55-444eaa19d7ef@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <375a1b30-5e68-439d-be55-444eaa19d7ef@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 16:20, Jens Axboe wrote:
> On 11/21/24 9:18 AM, Pavel Begunkov wrote:
>> On 11/21/24 15:22, Jens Axboe wrote:
>>> On 11/21/24 8:15 AM, Jens Axboe wrote:
>>>> I'd rather entertain NOT using llists for this in the first place, as it
>>>> gets rid of the reversing which is the main cost here. That won't change
>>>> the need for a retry list necessarily, as I think we'd be better off
>>>> with a lockless retry list still. But at least it'd get rid of the
>>>> reversing. Let me see if I can dig out that patch... Totally orthogonal
>>>> to this topic, obviously.
>>>
>>> It's here:
>>>
>>> https://lore.kernel.org/io-uring/20240326184615.458820-3-axboe@kernel.dk/
>>>
>>> I did improve it further but never posted it again, fwiw.
>>
>> io_req_local_work_add() needs a smp_mb() after unlock, see comments,
>> release/unlock doesn't do it.
> 
> Yep, current version I have adds a smp_mb__after_unlock_lock() for that.

I don't think it'd be correct. unlock_lock AFAIK is specifically
for unlock + lock, you have lock + unlock. And data you want to
synchronise is modified after the lock part. That'd need upgrading
the release semantics implied by the unlock to a full barrier.

I doubt there is a good way to optimise it. I doubt it'd give you
anything even if you replace store_release in spin_unlock with xchg()
and ignore the return, but you can probably ask Paul.


> Will do some quick testing, but then also try the double cmpxchg on top
> of that if supported.
> 

-- 
Pavel Begunkov

