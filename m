Return-Path: <io-uring+bounces-5058-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 113E99D9A96
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 16:44:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4CEA282E2A
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 15:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D61C1D89E4;
	Tue, 26 Nov 2024 15:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cpzRVcYr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67B11D7E4A;
	Tue, 26 Nov 2024 15:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732635866; cv=none; b=BJI127WUi51YyfhEQEkSBQKBfKM5Y8GskB6e/6e11V1C3FQzwToNdIoVHUjmrqDAe6/HXHT6VRtf5JAiZL1PINgUjppQqcgvGKVwp1cWoIrIMPIpZTgx2FTa5FFPmmZNj1AuK/Nu0PhrLTByLi8QtQUleUSxzmnSgRKE4XXsLi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732635866; c=relaxed/simple;
	bh=TAw7U5vFpAcrO4h1WG+4U3ymUEZ4YD3HUDBY13jUiLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WbzPTHikRI2Uw/eJg4L6sFL0cZk/JKwefpXhnX8pvWsv+zdP2N5EnW0BSlEFB4+Xp8N9sXQaTMl41ClhWcOK1pM7S/P7kHmTLqp0ky03H68mNaEhF7REC8wIhBEEe0/pA04wldQ/BscZdUn/w5hLrUYUrnEifslCtEP340sas0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cpzRVcYr; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53deeb6d986so604033e87.0;
        Tue, 26 Nov 2024 07:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732635863; x=1733240663; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yVDOYNO+iQ6ZhvMztIaukFD/X8oZpaR2llnamKczTuE=;
        b=cpzRVcYruggUWQfXA37VSuH33y9te0s09KqCtMOsm6Yu5Y95ePmnH/ssvN9CbotelK
         F0izLVsirlxI/yBsqrLM3auxrCoUF1GTI8L13spP306lVAyDrcpL4AOb6SJBnSjF5U1P
         75Zrqekl9ONbDjKoGcriDRJ0+7ZB9l/uPdtjNhrT9LTczhRe7G48nCHPKBOD4D7FofQV
         NvVMA42UccTg2+DVzFwnIEZz05PoXfvWCaVV3VUjp0XpjnV7gcbJ1lNqxZmpm0GBsyV0
         66XRH2pMq9Ll/4PdXh0PsHAE6Jti/ua4RtYFxbbdI+Y7EzVY6ROSN1HtBOcUibXHhK1D
         1Kdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732635863; x=1733240663;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yVDOYNO+iQ6ZhvMztIaukFD/X8oZpaR2llnamKczTuE=;
        b=OOkwriAFb0CVkdqlPINmd9tEA7sLFEWDD8aaKWcTXZYLafqs9Jkv2k5jV+hjEEkn0z
         /xYGtJx8f4vWHaMYG9ZKgBx69I2bPjscSW7s2G4hXpp8yaJ4c4G17tPQqYTE6fVHPIc7
         lRBnvzlOGrwvwXeotNgq9uknH+mA72oOgbhmYiuIR+zFZwzF8p01AO6VZ4Wlj09DHXKs
         Pe4xkpccLRbkVCdM5wSPQyVEfUaldybaL7Fx6S57iyDze6yMDZEHlpe2xfdGmw61JZIj
         hL4qxx0vfWeddoCjcEwjLYYJIHcxvuLOXMzHD4H1z0Od2z+Va0rGp/qVR2NPzMD9MDzN
         sOfg==
X-Forwarded-Encrypted: i=1; AJvYcCUoEj1b0a6Ta/o90zoUm7/JaKfGIQ6jNUGdl2O7dVDBdckfaVYbfKzAHSmEREPFwrbGvKWDeoe9G5TCruU=@vger.kernel.org, AJvYcCWJs9zhxB1P2nYYkAbq5c7YyPSNZ+nOXUHUv/RSKnuLBG5cYv7dJbP4Q2cYyy67fe8jxabhEqbM6pvHdA==@vger.kernel.org, AJvYcCWUtRFo0pbDqJAMbJ5IDK7X6y0pPEeqU4OPo6KES7CvUgV4cU4kYIB1ro8klQGoA0HQ6UgqlDHZKg==@vger.kernel.org, AJvYcCWkTMsmW7/v828hwcHw3qFhXmwk444FnvIxmrJiwhUZeUKbUKCC7Pb35sFF2FGn4P0H5hlZwTxnproXjQyHNw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw01YOmR40yBeG8B6LCMlnOX582WFzgV3lCJaWM/CltCGyFS3YY
	l23xNAZnqlHeyeUlcxFgkXSA0yJYpi5qTYY+ZpHvp8hwUac7wtR2
X-Gm-Gg: ASbGncv6+n/6759ewgo6IXm6uCl8E0vIagmTFvsKH+E6UeJBbWVX+LJgZd5K8VF1oT+
	kMEVMTRnc1NMjcuf3RuF954FlqEPETOSipp40iLpAEWXSD4nTpp1SQOyKSGTj5KQARZUmYL3ECU
	twe5AsT4So7PwoBZsLc7CAC58p0MbQNdoD2chUVq82v4LxBadvuULD7DVUY3oiRNgnmLr+sk63G
	i6wBiCqkLqrDedTWjGJx649qzYjCH8QnRB8FgLxE1EycRmwm7Wh+2T+lGBA
X-Google-Smtp-Source: AGHT+IGWo3MB+7Gb6yHS+bWnq0pFj0SiM5AqaPTVwcxWz0pNUpAyD9lUojQtu9SrCdednPlE58PNpA==
X-Received: by 2002:a05:6512:400c:b0:53d:eefc:2b48 with SMTP id 2adb3069b0e04-53deefc2f0amr555039e87.33.1732635862546;
        Tue, 26 Nov 2024 07:44:22 -0800 (PST)
Received: from [192.168.42.58] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b28fe55sm602396866b.4.2024.11.26.07.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2024 07:44:22 -0800 (PST)
Message-ID: <a9d500a4-2609-4dd6-a687-713ae1472a88@gmail.com>
Date: Tue, 26 Nov 2024 15:45:09 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/10] io_uring: introduce attributes for read/write
 and PI support
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
 martin.petersen@oracle.com, anuj1072538@gmail.com, brauner@kernel.org,
 jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241125070633.8042-1-anuj20.g@samsung.com>
 <CGME20241125071502epcas5p46c373574219a958b565f20732797893f@epcas5p4.samsung.com>
 <20241125070633.8042-7-anuj20.g@samsung.com>
 <2cbbe4eb-6969-499e-87b5-02d19f53258f@gmail.com>
 <20241126135423.GB22537@green245>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241126135423.GB22537@green245>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/24 13:54, Anuj Gupta wrote:
> On Tue, Nov 26, 2024 at 01:01:03PM +0000, Pavel Begunkov wrote:
>> On 11/25/24 07:06, Anuj Gupta wrote:
>> ...
>>> +	/* type specific struct here */
>>> +	struct io_uring_attr_pi	pi;
>>> +};
>>
>> This also looks PI specific but with a generic name. Or are
>> attribute structures are supposed to be unionised?
> 
> Yes, attribute structures would be unionised here. This is done so that
> "attr_type" always remains at the top. When there are multiple attributes
> this structure would look something like this:
> 
> /* attribute information along with type */
> struct io_uring_attr {
> 	enum io_uring_attr_type attr_type;
> 	/* type specific struct here */
> 	union {
> 		struct io_uring_attr_pi	pi;
> 		struct io_uring_attr_x	x;
> 		struct io_uring_attr_y	y;
> 	};
> };
> 
> And then on the application side for sending attribute x, one would do:
> 
> io_uring_attr attr;
> attr.type = TYPE_X;
> prepare_attr(&attr.x);

Hmm, I have doubts it's going to work well because the union
members have different sizes. Adding a new type could grow
struct io_uring_attr, which is already bad for uapi. And it
can't be stacked:

io_uring_attr attrs[2] = {..., ...}
sqe->attr_ptr = &attrs;
...

This example would be incorrect. Even if it's just one attribute
the user would be wasting space on stack. The only use for it I
see is having ephemeral pointers during parsing, ala

void parse(voud *attributes, offset) {
	struct io_uring_attr *attr = attributes + offset;
	
	if (attr->type == PI) {
		process_pi(&attr->pi);
		// or potentially fill_pi() in userspace
	}
}

But I don't think it's worth it. I'd say, if you're leaving
the structure, let's rename it to struct io_uring_attr_type_pi
or something similar. We can always add a new one later, it
doesn't change the ABI.

-- 
Pavel Begunkov

