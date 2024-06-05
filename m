Return-Path: <io-uring+bounces-2128-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA198FD64B
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 21:13:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 582321C20F49
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 19:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A529613C699;
	Wed,  5 Jun 2024 19:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JiMujTwK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A4413C667
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 19:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717614808; cv=none; b=rOJJ1wwBLqyYcaxGE8oABJOJ2vTKn+fbmyvD3j7UtrzY3Sm2qXvOqGbwcosRx39Po87bdYL0kURmPAUrqXFFachsn74LFBp+6NmOTrGfBBpYaKY0CClcGRIluT6z4MNUoYvIrwOMu/vJHeoz7OLbKh7HD45yv8dMyeIus2SCTtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717614808; c=relaxed/simple;
	bh=SiiekjoZAB0cQwzbazRrCOJuhj+O/XMBNv9/aYs9Bbc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=C9u9jLSfQTJpK3fYDfB1Jqs1NI/Weow5icmCmI9Le1HtLB2p+rc+sMLFvGxa8vh5SwdP5H7IvFIRd6lkqKjz2srHbkQ8nwKDBL5gWdIkfsRixM+zhzuzRNJCaP9Xz8GvScpZPFjc5SY1sYOg6CedGYFcUBgzPGYPVjyMi9azqVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JiMujTwK; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a68c8b90c85so23344666b.2
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 12:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717614805; x=1718219605; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y/kwaaTe+isHSAHwyD2FDQMaVXBf+5BGgFW/tYaqJWo=;
        b=JiMujTwK9XlF7de1GTC2RCkRkx9pRYCecCPgFDEl/fwOoIwOqpIRC5GLLknabsSlUr
         +cARyEovL4DIKZ11a8ia+b9gWJKmSj5MDxnFoQFo8XSMIRq5MaDzX75lT1ktco5pi7bh
         J3vyjDtVzQuUpO7zxWiLO9uatS6N4xe4ey25/QbvnKyf9s2YpYgrLwkFhfAEh7lG97mg
         3DRTgbkRC40ChcalkLXHEUmfbMPmmORroFXT8cIed4CGLfA7egu7nAwj+4hk//g2qPRV
         015mgw1bazMTPQOoW3+SRN0yHvYbnRLt2rPsG0JSkzfljWQwXBXK1oJDGiRY3q+Zeaa5
         PurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717614805; x=1718219605;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y/kwaaTe+isHSAHwyD2FDQMaVXBf+5BGgFW/tYaqJWo=;
        b=IhhQRvVNTFwUwVM3ex+l2L1SKdrkx6/XJBzhhIw3uqnIAECYWLGIGHTI2tBstvm5XJ
         KaFLElbuK0onOodnI1OiBx0+QE1QJrpmIDXXc/+gtPMjHjBGSVcwhsoCuUXHYGyevmIY
         pVHPQcVg3xV2qW0nCZnkms/NT276BFHDcNlNJk6QV/Q04b1bTaJvIh6NtQ3pXv6G41sF
         d/XvtMYVv68MpRyrlFEBQt2qaGplEAWYZV3f7QV5YZ1W3lnT68fJWfr+aBZQlSMwrjW+
         YJ2ON4BnMU29KDmoDuP4rzobumKh3AJZ7yiAAqw5W/h3mK24ip3nbpBPZgIaOg/+Ao0j
         9DlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyy5c3sOGWbeRv50kfRat+QpY7MH9ZxtM78dkAdX72XuYSVVmoJWnwPwqgug/7wLq8bpVDKQml1O9e4Tb4e9caPFC012OHr7Y=
X-Gm-Message-State: AOJu0Yy3v5WV99m5q/LLzhgRjUrFUxuaNbHsfeCiqVcIWs9oEmZ4nRna
	dvogc3RO+Zb15TaTqmpfjW2He+3nU8xQ7vQRTHg69P+NVfyKybIv
X-Google-Smtp-Source: AGHT+IEfX6yIhfehWqHJdnVZiZ/e/D9TXFzAlxR0byXKJA112eU9t62Sns+BgqheOdAVxHKH0wHZ0w==
X-Received: by 2002:a17:906:f10d:b0:a69:134f:53fe with SMTP id a640c23a62f3a-a699f666343mr245073266b.24.1717614805087;
        Wed, 05 Jun 2024 12:13:25 -0700 (PDT)
Received: from [192.168.42.249] (82-132-237-201.dab.02.net. [82.132.237.201])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68e3ff633fsm618201066b.14.2024.06.05.12.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 12:13:24 -0700 (PDT)
Message-ID: <04539e03-da04-47d9-9363-59c2f4ba0b03@gmail.com>
Date: Wed, 5 Jun 2024 20:13:28 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: move to using private ring references
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240604191314.454554-1-axboe@kernel.dk>
 <20240604191314.454554-4-axboe@kernel.dk>
 <138bf208-dbfa-4d56-b3fe-ff23c59af294@gmail.com>
 <7ac50791-031d-453f-9722-8c7235573a21@gmail.com>
Content-Language: en-US
In-Reply-To: <7ac50791-031d-453f-9722-8c7235573a21@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/24 17:31, Pavel Begunkov wrote:
> On 6/5/24 16:11, Pavel Begunkov wrote:
>> On 6/4/24 20:01, Jens Axboe wrote:
>>> io_uring currently uses percpu refcounts for the ring reference. This
>>> works fine, but exiting a ring requires an RCU grace period to lapse
>>> and this slows down ring exit quite a lot.
>>>
>>> Add a basic per-cpu counter for our references instead, and use that.
>>
>> All the synchronisation heavy lifting is done by RCU, what
>> makes it safe to read other CPUs counters in
>> io_ring_ref_maybe_done()?
> 
> Other options are expedited RCU (Paul saying it's an order of
> magnitude faster), or to switch to plain atomics since it's cached,
> but it's only good if submitter and waiter are the same task. Paul

I mixed it with task refs, ctx refs should be cached well
for any configuration as they're bound to requests (and req
caches).

> also mentioned more elaborate approaches like percpu (to reduce
> contention) atomics.
> 
>> Let's say you have 1 ref, then:
>>
>> CPU1: fallback: get_ref();
>> CPU2: put_ref(); io_ring_ref_maybe_done();
>>
>> There should be 1 ref left but without extra sync
>> io_ring_ref_maybe_done() can read the old value from CPU1
>> before the get => UAF.
>>
> 

-- 
Pavel Begunkov

