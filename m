Return-Path: <io-uring+bounces-6857-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71ED7A498EC
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 13:14:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AC9B3BCBCB
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 12:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CB926B2DD;
	Fri, 28 Feb 2025 12:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="czAGJ5tO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE37E26A1B8;
	Fri, 28 Feb 2025 12:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740744787; cv=none; b=A15tNytCwNeyC9mQsKkLK9sWtEha5lra1LfGctiU9zoTOg7VbOBU7il+L1QCIZ/TN5e/NL1AhsAHLc9UlQdrrUC+y7hklQYoINSpfI92Syt9J7B/AXxYyZBdcMNWMieTFQ0spzCfIg0Uzja/czcZm+7McORV8diLZV7ckoY+lBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740744787; c=relaxed/simple;
	bh=FpHzOeapDEDiHpFGTjC8NOwiA9Xt7qV9cJfzT82rJZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eijPub0DIKDrIsJR72nV+gIKsYWVpIb5y83FQq/BkTPcvDr0Z2zOkVlQVp9C8SJciQ8vvVeldk7fEGS/Z1B+rBHnMV28723Zva6NPB5EAHKyFstLmco8JWHitsMgjMRA8wI5RFrUIbYW6/ggJyza0LTizYHmd+xeqdzRc2LYPgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=czAGJ5tO; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e095d47a25so3386989a12.0;
        Fri, 28 Feb 2025 04:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740744784; x=1741349584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Bq8LDhar54MRPSFAhgDGLP8Fgo5fT+8EgstYHu3wH0=;
        b=czAGJ5tOs0VM2sswCKMnV7dV8Eck98+0kV2gMT1PxSedrZTJ+ba3S2QJw5bhvNDztN
         9PavAMJgwbccX3MEcvumesPul0qGsOpweBl+eulEWnF767yERSeL6xDD0gRgUtG70N5P
         XbZvTEq5RNidB5K/wAFydp7XlV52O60mTqCYY1yPSgzlB2r9nJmB3YPPHxz5pk5HgorF
         +FAXVEB6oZMmWQh/fxlJC2cf/Abpg70QT8rslp9NRDIRpZD6u3AcDvtRJ7ZCunLLWgAB
         JKc2/zdW/JJndaq7f2mO7eEtHGENxx/XF1KS5m5uCRE1/kh17pNXEE2XX5T26ar19esb
         JXiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740744784; x=1741349584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Bq8LDhar54MRPSFAhgDGLP8Fgo5fT+8EgstYHu3wH0=;
        b=qAXFndYzakGntBqWPY2zjNDYjqm9ZR8UuzYQcQIrpyd+xJYqZD0yxtxiapWG8i526+
         ZEQE67Gk/a7QPt6l2RXZAGcerAai7J9Mdh1ZvN/Rafbhx5YV5Mz2qR8StNAC68N//Ctx
         QNStiDLrYj4K6M7fXAxkrNOzi1TEAJrJl3G0MH+lxGkuRns3auu2JR5W93mT9LNzxDd+
         o4Hv7GthzLzhGiQOOpIm8fCDu2o6bz90RenlrhHEIxktZyzptarU8XcINonX9/1nwXnh
         7RDfjTr8Bd8z+bQy/Eh81sf6Xjn8mhW64qtKE72aeD5Nij/FRNDWMuBq42IlsMefl+xd
         Hi7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVyC0za8ggo/V+GV/7xhoVK4NtSLDR7eZx3z3Ey2zX8vFxSFp7/r+LNjojcJsSTctvdPrPuMFqPVcUUe9Tm@vger.kernel.org, AJvYcCWQFIc9pZtvXB5+sa6fFwq4YOrekvyiVYSj4O/9eCKlePD9O0JbDxBt5ldmH4DnxwY/TwmGgx0iHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZjpTCoN7xHaKT3pFu0B8dSGRIYuPTfGMEPbeAOjTA33Xp0eIo
	7EH1l/l90NnNu8bsYewRX7G3g+P7vLYBHrWWOthkacnTmpD9tr44iAgXlw==
X-Gm-Gg: ASbGncskVcEDhzB2lRiHzouZMJdsYUThoV8zmvfeTP0RZJoab447/IWrZ2Xi4VZ2nX0
	YA7iG1V4aNkdNoywGqSWuSg0hA+gTHBtr1WuNpczn38DBmwFkG+3/f0il6n/qsG/V1JsD9+Hyyr
	BLAD5vO85cyW6Lz1Vy6GthPR+irXD7Mv8HV2zAlUPxXqi4E6P9/BcMyzWNjTzykiMhx0evjFBpj
	2HktDCUo2/wR6p+/Q92JJJx2UbH/WKYG468mIOd0Rxaa9RZ4tm8/nRMaxFPuQ1Qr26TO0aP6vML
	ZOmbtCqT9wlQCu1P/7Q5c7Y6rdkDJvUnfbJqEp23EIe66aM6wfIobFyITTw=
X-Google-Smtp-Source: AGHT+IFwJJNmHexcBrTOSnzNLDu/+LZZbiRhNDz0f/WLhH0avUCbNu7aRq+MLznexU+6kRiQYS7VTw==
X-Received: by 2002:a17:907:969f:b0:abb:6259:477e with SMTP id a640c23a62f3a-abf2683e49fmr315112466b.55.1740744783818;
        Fri, 28 Feb 2025 04:13:03 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:aa16])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf245cc3dbsm147041366b.160.2025.02.28.04.13.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 04:13:03 -0800 (PST)
Message-ID: <98c54e34-ae65-4492-8e2f-9601b477a8c6@gmail.com>
Date: Fri, 28 Feb 2025 12:14:11 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: fix build warning for !CONFIG_COMPAT
To: Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
 Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250227132018.1111094-1-arnd@kernel.org>
 <275033e5-d3fe-400a-9e53-de1286adb107@gmail.com>
 <9ef40a88-6243-4baf-8774-e4b72bfbb2f3@app.fastmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9ef40a88-6243-4baf-8774-e4b72bfbb2f3@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/25 13:58, Arnd Bergmann wrote:
> On Thu, Feb 27, 2025, at 14:49, Pavel Begunkov wrote:
>> On 2/27/25 13:20, Arnd Bergmann wrote:
>>>         |                      ^~~
>>>
>>> Since io_is_compat() turns into a compile-time 'false', the #ifdef
>>> here is completely unnecessary, and removing it avoids the warning.
>>
>> I don't think __get_compat_msghdr() and other helpers are
>> compiled for !COMPAT.
> 
> They are not defined without CONFIG_COMPAT. My point in the
> message is that io_is_compat() turning into a compile-time
> 'false' value means that they also don't get called, because
> compilers are really good at this type of dead code elimination.
> 
>> I'd just silence it like:
>>
>> if (io_is_compat(req->ctx)) {
>> 	ret = -EFAULT;
>> #ifdef CONFIG_COMPAT
>> 	...
>> #endif CONFIG_COMPAT
>> }
> 
> That seems even less readable. If you want to be explicit
> about it, you could use
> 
>       if (IS_ENABLED(CONFIG_COMPAT) && io_is_compat(req->ctx)) {
> 
> to replace the #ifdef, but as I wrote in the patch
> description, the compile-time check is really redundant
> because io_is_compat() is meant to do exactly that.

I do like getting rid of #ifdef, just a bit surprised that we're
relying on dead code elimination, even though it's what any
reasonable compiler must do.

Btw, sth went wrong with the reply: (delivered after 24733 seconds)

-- 
Pavel Begunkov


