Return-Path: <io-uring+bounces-4922-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6CFF9D4EA3
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:24:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AF4E1F25888
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 14:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71531B0F0C;
	Thu, 21 Nov 2024 14:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ats4N3D+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4CA4A02
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732199069; cv=none; b=s4v3jnapIS3Wnf8nZPwD/fxt5TtveiqSeb5YYe0UVYpVds4BBPD7U2Lq88jN/cFqMsWwWqAKfQmWL4Km+gqAO5pJmIysNTLn4NC33xh5ji/v+s/xoRdCkqub/j043RENobG+sI0gwn2t95SdpFTEOeVphmgMWNlaHCs0318bVRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732199069; c=relaxed/simple;
	bh=gEug+CXdVegaVuS5bq0qONNfsp8FPbRUCYXlKO/1v6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=D3008d7gLTJNlQW1yeifzOTdyJ2klloxW2/0mlyZcNoWx7AdkkMhyki3+85ExsiCkKAF0EBJD5jNSh/GX/CdK+OP3epT/JzSCV8gSPt8BXasgvQlHMnVqdCS+qV25FIlSErTRFFsVvJYoWAxYv2Asu58bwBIIEps1VoKIS6X1fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ats4N3D+; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9a6b4ca29bso148277366b.3
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 06:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732199066; x=1732803866; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j8OS1tx0dbRVEPPNsr4CZ487Rluhlofzh+rbsIejhSU=;
        b=ats4N3D+GjxTSzhsDtrQ930ECnQB35NVHTaHrol61hqn2ubOZKsPFtf82IUDSYCgGi
         6PksN/PCb0GUJxlbToCg3Su7K/NN9p/DpYenA0LQHofm7d3xFfjW0kVn8FuG9S6qwaLT
         3CMeCnZIN6ppgfePKSrExxFh1zKD7Jj9Xf0Nb4kKBwLSpGWlUtjfuHolSMIpGP5U3Xdb
         PxLJDtzZwYL3lG+GkxVKxaHypUh2a4urEtrUCbhyuVpfMj/MjUoJ/eEJX+th/Ed5ZgIo
         8MogkhdZQS6YFPvipr9klJdugG4wPQrolyIvferCjjOYvdlX3RL3ZPyMlKbvhR89GZrl
         g0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732199066; x=1732803866;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j8OS1tx0dbRVEPPNsr4CZ487Rluhlofzh+rbsIejhSU=;
        b=WlynDeHd3SQGstJ+/7LIPHJoKlutQQ4W/FTo87dBWDF26GTxFpWLq4LaOXXn8hKLlq
         myXyz4ld8YOM2YpBiiszvrFglO5htsKCuLgYL0u18HfKsBhTnHAnXsWPXqQSrPB7dsWO
         +JaBoRn1mF9YHSkaxhHm7XuWqZ5RuGdWBPWi3H8zCB0TGMpLm7BnhWGwZ8Hp5UgUIbFd
         Ge4xWaFQFqHSWVEkn0R47V15JaDoqmI+rlurDDbdY/ca/Iq0TVuHu+YIDMEwgI1jI7RG
         stJCiba5t7hav60dZj7+6EOJ5FP+dahYbn6HKPfsQTnY3mpBOTejvYEoNVNB87xxaEy1
         XTlw==
X-Forwarded-Encrypted: i=1; AJvYcCV3f5D0dSMK4WIBj4lz9i/3CJ201syS64CZBoOjrwbNhndHc+PWU7yjJwbZSCBnfVz+ItY9Q44wDg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/kFSBSrXx2raU0rZ2petNYW/BOcxx8NfUhoL3/7O5ByKK7qmr
	aZFk6iQWJyRfpMUEo6sYl45yW6vlYTzW2bdGnuBERKSfVXFRxCmO2WE85w==
X-Gm-Gg: ASbGnctxdxjW3D53BhtAnNqyo6/9xk9s8KPwQoCMXAI8N+ul67KT4exIO+1PUUKK3DW
	0C+L2voMp1qj6S2/ls5iP1J2nBPgfXkbh4Af0KD3ydyp2rUqYT0V8PZTzQRCq3uZ9RTP0kEzwDZ
	yNMiYAiHDJ4H3EyqQ8HWXjRZizpIx4f46ucfqBX/3Pz1xGiv3GxYL01q+xDfvSn+3ZF1drCEejn
	lcW06YXPNE40tfUKf6HAfrz9JSAR38p9owEix/7Ggu7q4RxVo4J4+/d6wyr7Q==
X-Google-Smtp-Source: AGHT+IG7vDNQSz+FtuHJTgtAYVY+rgK5/Fw5zWQhiW6JpfzXdfykiOREcp74BMxDLd1REmjJN1upOg==
X-Received: by 2002:a17:907:84c:b0:aa4:9b6a:bd77 with SMTP id a640c23a62f3a-aa4dd551bbcmr693017866b.17.1732199066124;
        Thu, 21 Nov 2024 06:24:26 -0800 (PST)
Received: from [192.168.42.195] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f417ca79sm86376366b.43.2024.11.21.06.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 06:24:25 -0800 (PST)
Message-ID: <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
Date: Thu, 21 Nov 2024 14:25:17 +0000
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 01:12, Jens Axboe wrote:
> On 11/20/24 4:56 PM, Pavel Begunkov wrote:
>> On 11/20/24 22:14, David Wei wrote:
...
>> One thing that is not so nice is that now we have this handling and
>> checks in the hot path, and __io_run_local_work_loop() most likely
>> gets uninlined.
> 
> I don't think that really matters, it's pretty light. The main overhead
> in this function is not the call, it's reordering requests and touching
> cachelines of the requests.
> 
> I think it's pretty light as-is and actually looks pretty good. It's

It could be light, but the question is importance / frequency of
the new path. If it only happens rarely but affects a high 9,
then it'd more sense to optimise it from the common path.

> also similar to how sqpoll bites over longer task_work lines, and
> arguably a mistake that we allow huge depths of this when we can avoid
> it with deferred task_work.
> 
>> I wonder, can we just requeue it via task_work again? We can even
>> add a variant efficiently adding a list instead of a single entry,
>> i.e. local_task_work_add(head, tail, ...);
> 
> I think that can only work if we change work_llist to be a regular list
> with regular locking. Otherwise it's a bit of a mess with the list being

Dylan once measured the overhead of locks vs atomics in this
path for some artificial case, we can pull the numbers up.

> reordered, and then you're spending extra cycles on potentially
> reordering all the entries again.

That sucks, I agree, but then it's same question of how often
it happens.


-- 
Pavel Begunkov

