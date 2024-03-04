Return-Path: <io-uring+bounces-823-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A896870FFF
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 23:19:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C5971C20896
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 22:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2021C6AB;
	Mon,  4 Mar 2024 22:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="egl9uj0w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F201C687
	for <io-uring@vger.kernel.org>; Mon,  4 Mar 2024 22:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709590777; cv=none; b=dEy50JgNJqQIfoQh8UKET1drglP4tl/RgNsYsUnfEnXpNOCmXcL6nbDzIgYYPLdM3X98Tpu2yINa+U6M8+id4Uo6Zx2zWtlHJdKee/79cpI/YdYXag4gc7A+pGuQZ9J3uSPJguOLbI0KnGIxGtnq5XQTalzdYONsTSpGyAdvat4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709590777; c=relaxed/simple;
	bh=q6KNAjlCJrBS1azoN74hpsIBKrodhHph3SbkSPw2v90=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=C7DBWxlnJx+DYZ4JTsFYYd4TB4zfqYcCrOJFU9XDBl4+H4npkT3rsNzQeYb3aTYoZRSi/qnwKSlyelijhPQU3y8SrTZSgrSM4ORokRzCuRTby+Cm9KOnbZ1FsGhJ4/WV7rFnkfVvC43tCeoxDp7S3cPOqEN8e4xk3AoZatfTUrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=egl9uj0w; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a4417fa396fso625221666b.1
        for <io-uring@vger.kernel.org>; Mon, 04 Mar 2024 14:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709590775; x=1710195575; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5QxtZ7sjNsm4R5XifJmpK+oh4oo9IWqRfJSM1deFbI0=;
        b=egl9uj0wrrPV3L/cwkYWBlPoQL7WfMJviGs8Mg7f5cvpatftBLHCzSwo8+xbdjh4Yq
         o4kDDtJzHBbopmI+Hhp+wsmNfuN4v34OPcC9rqcRjF2Bt1q69AHj3t3UCy9UOLO/Txw9
         Ec9AjOM1q/5F2yKgFCgQYw0dRZ//puiik6lwsmNg31gxxPKGeLS0RsVnCLUGPQ0oN8BS
         gjEi38GDXybV4hY8ywExi8SG2qLoOzLpZLVeeEebYgnyIzU7p++m469Ouh7Icjt4KRSf
         On9U7UTHaA7fwfLvgW3c1mkoxzMa21nA35Yqn/VuKQa3+gojk46+kDIZ+75KUzR841WU
         /5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709590775; x=1710195575;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5QxtZ7sjNsm4R5XifJmpK+oh4oo9IWqRfJSM1deFbI0=;
        b=bpXBjLaKqXG+i0zs86fwszHQUCoaj09lvrD27wjjpM47iSpheniIc4ZCvp+LAZXQEu
         jVuOVT8TjFheobAC8HUjPmyq2IBrf9C8X1gwBeCZG0m6B9AN3l0GtSbBfskE9HbHxrl5
         ouFOPosNd6pYzhW/P/YM2llr2abkL/iYH4kMFKMZvI97JJqM6RPiFaSJRrptKaMxB98R
         bhcwFHIkgrSi2a8gx7VN4iyI7g/PrYW86YP2wa7m0C0Pdv2c0pny7rlLYeyMJ4SRyg/B
         x4SWeigs9vcYyaGZ/LGHpoTYYjZv526lrLfWalYtBA2AMX4tjk7N/CWjJKTZNO8nOz7e
         L2tQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLGifh5j4/N2MHW1aWkRyAyHQ20LDHUL+XpS7vityj1y2M/xg3A3Ix/d56MIxD2gRXwc/Ob1tuZYsvsBDU23DIULjI87GldVQ=
X-Gm-Message-State: AOJu0YxfcikZ8U/AfZ/UBWdP12h6Pg67MQykxxt0dPH7Gz6Yrz/YoFq+
	6ZPl7D2r1RxoNK4I0PneOkIsYPwHMaVyTZZ3tS365yrzM6y1H2X3
X-Google-Smtp-Source: AGHT+IHGKD9bCQiqxBaoJIz6nIz+S+bdEwE31hNmGzTPfhHIc3nur8IadbVrN4zf4dis/20UCS7AdA==
X-Received: by 2002:a17:906:338d:b0:a45:40aa:b37a with SMTP id v13-20020a170906338d00b00a4540aab37amr2607072eja.13.1709590774547;
        Mon, 04 Mar 2024 14:19:34 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.152])
        by smtp.gmail.com with ESMTPSA id w26-20020a170906385a00b00a4394f052cesm5313861ejc.150.2024.03.04.14.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 14:19:34 -0800 (PST)
Message-ID: <0c4e762f-8deb-4b71-bb55-308435d5f5ee@gmail.com>
Date: Mon, 4 Mar 2024 22:18:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <935d517f0e71218bfc1d40352a4754abb610176d.1709224453.git.asml.silence@gmail.com>
 <1c21f708-ab56-4b5e-bca9-694b954906e5@kernel.dk>
 <27952c09-0a9c-4c74-a2dd-8899033c3873@gmail.com>
In-Reply-To: <27952c09-0a9c-4c74-a2dd-8899033c3873@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 22:07, Pavel Begunkov wrote:
> On 3/1/24 03:45, Jens Axboe wrote:
>> On 2/29/24 9:36 AM, Pavel Begunkov wrote:
>>> With defer taskrun we store aux cqes into a cache array and then flush
>>> into the CQ, and we also maintain the ordering so aux cqes are flushed
>>> before request completions. Why do we need the cache instead of pushing
>>> them directly? We acutally don't, so let's kill it.
>>>
>>> One nuance is synchronisation -- the path we touch here is only for
>>> DEFER_TASKRUN and guaranteed to be executed in the task context, and
>>> all cqe posting is serialised by that. We also don't need locks because
>>> of that, see __io_cq_lock().
>>
>> Nicely spotted! Looks good to me.
> 
> Apparently I'm wrong as "defer" in that function is not about
> defer taskrun, but rather IO_URING_F_COMPLETE_DEFER. Jens, can
> you drop it for now?

One way forward would be to limit the aux fast path to defer
taskrun, I don't really care about other cases, and aux is
mostly useful for multishots hence net, which should preferably
be DEFER_TASKRUN.

In any case the code is a bit unhandy if not smelly, can use
some refactoring.

-- 
Pavel Begunkov

