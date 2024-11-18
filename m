Return-Path: <io-uring+bounces-4779-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A1C9D1758
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 18:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5044F283039
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 17:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260AF1BE226;
	Mon, 18 Nov 2024 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J1IbuvfC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5098F1B0F24;
	Mon, 18 Nov 2024 17:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731951858; cv=none; b=gBmOi+d7A4pQWqlow+xu5v2fEB5dEJwnVYTH9l5ZmUoTywsYjOfne/nqBv2IXB5b2VEPghE6/gqD8V9GrOwRnO+ShlOxS6re5nZVNPdUs/8LDbTGXZ8+GSCxkOKjxFE7yYbWKh7QDQilDaM7jcf5MYHzChLeBGQqXCO1bx2bKZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731951858; c=relaxed/simple;
	bh=63XIO8sRABg67XicxNbfY6QsDQLmc5CXskO87BQUG6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UJBtedq4Lxi38p4qEGCrzSpTyfTUonwmLKW8MjdCoV3R6GsMwynQ9roQzht4NvEIW0Az0aJlTjlZWcgnuRWmwn78aIvEuezMfdZRDVrj6+Gi3HHrJMn7BmnzlyobK+PtNGATlQ6AJVfIyIMUJtHocPFK9Ts7UBcJ6wJOQ9gRBis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J1IbuvfC; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539fb49c64aso3000957e87.0;
        Mon, 18 Nov 2024 09:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731951854; x=1732556654; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bVO8qk3DSHDvk4oNuHMVMR5RvZCXGNXgG4n2Q5ZEl4o=;
        b=J1IbuvfCm2KEWiNuEMRh1r6WpspKXvlECfVe/BPUCc5RinVHnODC2uO3ltSb9b7bbc
         ho4UJ9G30hHgq93Y2Yb5Cy7Bd0N9c3WfJ5pbwXcsB0OVZK/sQdVnqagb1pV7YGieCz+N
         4i1oib0SjH7HUuc/4jDMQrEbYFqgLQHTJumazJMhERm4DZs2zO8S7cFF0K9VcrwbuH7i
         q2bopH2XCB8kLUakqEmvid0GpCW6PwT10tGBXBeZu0o7uGj3bxcg4vSs3Qi7PL5l4hoD
         6qwULt2WvDHhErD25Mil4vtrkDPbZGl9lyN7+hQrulMmzX0HQdl+JVFqJBDC40w+7zL8
         qzmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731951854; x=1732556654;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bVO8qk3DSHDvk4oNuHMVMR5RvZCXGNXgG4n2Q5ZEl4o=;
        b=rEE5pJk3oiKz6meITOJ0CMxboI7JC9LDjaD9yuiu4DW6wGZmPpURsuyv08QQdkWSFB
         /7fDisuBWU75GaJTTsiEqgPFPgFfYHWzb79XAgK1dHNy7czHJBL9X7KXJaHXb7MOjOHn
         VZEPWNc1Zv7PFcXxhXjhJ82QCyFJTzHaY++sw1FjSI6wFqA0TWsUlP9TpZtuY1kt1uQd
         XImUB0v3G2QbSMnmFoSbCNvBAIG5JHGbyVqeJ5j/o5Aro9Ie56GSah1Exm3fAgIR+txb
         vVRi1huI87+iHhXTbSmBZh1Vl44pRyOs+sD+Uln4pIWYHtfkpwSpzInZi/c5+7uH8myz
         k1FQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbKD2TAp6MpPUKFHxPPADiT1N5EKtBiYZFGPS19NysRUuwJBznXQ5eGPK4wg5LhHjxYUuD8EB8BHJFmk1nBQ==@vger.kernel.org, AJvYcCVS8ssonJ3ZM/NCjuV7tBoxIuBlf50tpCt3J8lJMzpzclCGcHAT3Jp3sHz8OXSeGp9YjcIoyl0QT6GkRys=@vger.kernel.org, AJvYcCWGAO75wx0gXCujhPhSgacWKNq+WewiuGFNcS9tyDig2ASgQdGoG/Xjl1YDBSXVCAJhGxwe4EbKwg==@vger.kernel.org, AJvYcCWJbN8vLrtmRPkdeooFQy/vQJkKuZxoymdPvaQIrZC9WJ/dBg444wFtaGjQAHq+SRXHqO7I/uEiAFUWAw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyhpvmgF9jkOWJcvYYZYvwPch12FXIdqsRxltF44dkf/uABQqB0
	gNHFpwqxlvuMOP6HdymKi9Wk3kCNpc8y2/Wy13SvEyMJmhwK3BMG
X-Google-Smtp-Source: AGHT+IE8deZQbEFmLxsNjvaQHppwSiVlfb/JcEO8eBT8Er4XhuZQWQlwrAn+B4VtBktpYvCn9ldPGA==
X-Received: by 2002:a2e:b896:0:b0:2ff:566e:b597 with SMTP id 38308e7fff4ca-2ff606fb54fmr81123891fa.38.1731951854002;
        Mon, 18 Nov 2024 09:44:14 -0800 (PST)
Received: from [192.168.42.187] (82-132-219-237.dab.02.net. [82.132.219.237])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e045270sm561214266b.146.2024.11.18.09.44.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 09:44:13 -0800 (PST)
Message-ID: <4f5ef808-aef0-40dd-b3c8-c34977de58d2@gmail.com>
Date: Mon, 18 Nov 2024 17:45:02 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 martin.petersen@oracle.com, anuj1072538@gmail.com, brauner@kernel.org,
 jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241114104517.51726-1-anuj20.g@samsung.com>
 <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com>
 <c622ee8c-82f0-44d4-99da-91357af7ecac@gmail.com>
 <b61e1bfb-a410-4f5f-949d-a56f2d5f7791@gmail.com>
 <20241118125029.GB27505@lst.de>
 <2a98aa33-121b-46ed-b4ae-e4049179819a@gmail.com>
 <20241118170329.GA14956@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241118170329.GA14956@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 17:03, Christoph Hellwig wrote:
> On Mon, Nov 18, 2024 at 04:59:22PM +0000, Pavel Begunkov wrote:
>>>
>>> Can we please stop overdesigning the f**k out of this?  Really,
>>
>> Please stop it, it doesn't add weight to your argument. The design
>> requirement has never changed, at least not during this patchset
>> iterations.
> 
> That's what you think because you are overdesigning the hell out of
> it.  And at least for me that rings every single alarm bell about
> horrible interface design.

Well, and that's what you think, terribly incorrectly as far as
I can say.

>>> either we're fine using the space in the extended SQE, or
>>> we're fine using a separate opcode, or if we really have to just
>>> make it uring_cmd.  But stop making thing being extensible for
>>> the sake of being extensible.
>>
>> It's asked to be extendible because there is a good chance it'll need to
>> be extended, and no, I'm not suggesting anyone to implement the entire
>> thing, only PI bits is fine.
> 
> Extensibility as in having reserved fields that can be checked for
> is one thing.  "Extensibility" by adding indirections over indirections

I don't know where you found indirections over indirections.

> without a concrete use case is another thing.  And we're deep into the
> latter phase now.
> 
>> And no, it doesn't have to be "this or that" while there are other
>> options suggested for consideration. And the problem with the SQE128
>> option is not even about SQE128 but how it's placed inside, i.e.
>> at a fixed spot.
>>
>> Do we have technical arguments against the direction in the last
>> suggestion?
> 
> Yes.  It adds completely pointless indirections and variable offsets.

One indirection, and there are no variable offsets while PI remains
the only user around.

> How do you expect people to actually use that sanely without
> introducing bugs left right and center?

I've just given you an example how the user space can look like, I
have absolutely no idea what you're talking about.

> I really don't get why you want to make an I/O fast path as complicated
> as possible.

Exactly, _fast path_. PI-only handling is very simple, I don't buy
that "complicated". If we'd need to add more without an API expecting
that, that'll mean a yet another forest of never ending checks in the
fast path effecting all users.

-- 
Pavel Begunkov

