Return-Path: <io-uring+bounces-999-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5B6187D74D
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 00:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9193D282E1A
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C0DA5A10B;
	Fri, 15 Mar 2024 23:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X21uO+/Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A653A5A10C
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 23:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710544864; cv=none; b=DTa9lNjZRWXhylw6yq/YddXIWMIS5aCwgYOu/st7BoLw5MfBUVew4zDkihksTZYJIqAgebrj9J3KzSzEGkB8fJ+sczIjynjNmV4nGqQv6qjQP9CCXoePPFNowIQTxLIC6XgtPQn0bXEyl5Tjaw38wW7kEqCixIry9NfgCcbMsuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710544864; c=relaxed/simple;
	bh=PL16jiGh2Ifwa/91RRGoRTG/z5pxhz/sF7JZadcUROE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=TeiX+xgF7cwszlFD/Ir8WDYw4+1rDneS/ByTaalRLtVC7clhzltdfnk+Nns82Ga5Ytiap+aEyprd91QsiuRbyvhLX1TmCfWbydDUWSDsVDe6YzmUDIkIs/xBKkEigdrRQKogtC1EUs8bXzJPVZeng2Vxd/wifp7lroBwUc9SdZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X21uO+/Y; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-33ed4cf02ebso643021f8f.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 16:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710544861; x=1711149661; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xl7O5e4UK8CL6KSDJ/A2XeEi2PDkJAjG/NU7VaerdW8=;
        b=X21uO+/Y45XZZRDO1s4F9GLGvw4DBihnIwr77nPHLxb/08FOWxxRijGw7mHmEGzHr+
         SpZerU2RiE+xX/8rSElIgoGNLjZd9IG7JyKZgJS3LQJNgtba33c+hVTnVIvD1Em/yfoO
         b55K8yllQg4KpXvj94Tm7zjTTKe3xJNVi8+3gvGn2zfd/vkLb+rW07kFeat/STvtBJ2v
         d/JrNKwVIXuHyQQxmFHmzypJlm6nLG4gfhQuukcGI+w7oVD64Jteu5YqVDuGAcS6yEzm
         HxgHcA4uw2uT8OUGFSVa3kk0dqmWGvx5m61hkrxsrhC3wWhBvfHZYyB39OSBK68Hzlnm
         jgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710544861; x=1711149661;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xl7O5e4UK8CL6KSDJ/A2XeEi2PDkJAjG/NU7VaerdW8=;
        b=rSJr/K5rU2NJDDEHAvXhK1oJUHEvqv8UDJh47/BVxz7U/daebKsL+B+QtQjG9XeRxa
         +pqExcRG4MS60T4IZ/0lC9IQ+xfe1llbvw6oTpyunUfHL81gOPu7ARecmAzqlv0GBK9R
         /m2A/izqTnmseunAA8aWchEdl++UWmM2VZtgRcU85eBw9E5tKyB4coKdmnXP9xGxrGQb
         RGGUz8KoOTUpA6s5ax07mXTgKgzTDUDdb8D4cCnQ6C0WS970R5tnUukWyYY2GWjPINkX
         1BMVlMKSwlumvYiYwKpR/oCLa4sWeBgq0oYNPycZpGuKweUQ/n0jQaQqE+KArrTh+E6h
         GPDw==
X-Forwarded-Encrypted: i=1; AJvYcCVkrsKIHUDZY2BOtFaRNXUDeRFc2hjPP+ojUr0mgzaqr7LFm1HLiRWAGnDK25M8MwgvS0e97H28IAdItSvutywk0kl0cax1FWc=
X-Gm-Message-State: AOJu0YwUIdCsLyeuYCArx1BNHdB21/5Ht7Yb6yn2wAaxcYZFPDKQyOOZ
	ckfiMxVZCtFBfjMo+AvO6HU0EjFndt2sN0rv0ewem8w7k54N/FzdSuEWMaNJ
X-Google-Smtp-Source: AGHT+IH6dNzHZeyWG1VjVHqdJo7LKevJgQyrRBlbyvLg7+mZQ58ICYKuYH4Tpi+NseLOq9VYNK0y7w==
X-Received: by 2002:adf:f303:0:b0:33e:c677:3278 with SMTP id i3-20020adff303000000b0033ec6773278mr4521926wro.49.1710544860544;
        Fri, 15 Mar 2024 16:21:00 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id bp2-20020a5d5a82000000b0033e43756d11sm1239951wrb.85.2024.03.15.16.20.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 16:21:00 -0700 (PDT)
Message-ID: <2af3dfa2-a91c-4cae-8c4c-9599459202e2@gmail.com>
Date: Fri, 15 Mar 2024 23:19:54 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: ensure async prep handlers always
 initialize ->done_io
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <472ec1d4-f928-4a52-8a93-7ccc1af4f362@kernel.dk>
 <0ec91000-43f8-477e-9b61-f0a2f531e7d5@gmail.com>
 <cef96955-f7bc-4a0f-b3aa-befb338ca84d@gmail.com>
In-Reply-To: <cef96955-f7bc-4a0f-b3aa-befb338ca84d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/15/24 23:13, Pavel Begunkov wrote:
> On 3/15/24 23:09, Pavel Begunkov wrote:
>> On 3/15/24 22:48, Jens Axboe wrote:
>>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>>> async handlers. But if we then fail setting it up and want to post
>>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>>> potential errors, but we need to cover the async setup too.
>>
>> You can hit io_req_defer_failed() { opdef->fail(); }
>> off of an early submission failure path where def->prep has
>> not yet been called, I don't think the patch will fix the
>> problem.
>>
>> ->fail() handlers are fragile, maybe we should skip them
>> if def->prep() wasn't called. Not even compile tested:
>>
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 846d67a9c72e..56eed1490571 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
[...]
>>           def->fail(req);
>>       io_req_complete_defer(req);
>>   }
>> @@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>           }
>>           req->flags |= REQ_F_CREDS;
>>       }
>> -
>> -    return def->prep(req, sqe);
>> +    return 0;
>>   }
>>
>>   static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>> @@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>       int ret;
>>
>>       ret = io_init_req(ctx, req, sqe);
>> -    if (unlikely(ret))
>> +    if (unlikely(ret)) {
>> +fail:

Obvious the diff is crap, but still bugging me enough to write
that the label should've been one line below, otherwise we'd
flag after ->prep as well.


>> +        req->flags |= REQ_F_EARLY_FAIL;
>>           return io_submit_fail_init(sqe, req, ret);
>> +    }
>> +
>> +    ret = def->prep(req, sqe);
>> +    if (unlikely(ret))
>> +        goto fail;
>>
>>       trace_io_uring_submit_req(req);
>>
> 

-- 
Pavel Begunkov

