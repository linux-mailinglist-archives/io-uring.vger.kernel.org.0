Return-Path: <io-uring+bounces-3524-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 365D19975E6
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:47:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38CDC284588
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 19:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05ED61E1312;
	Wed,  9 Oct 2024 19:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nQjeCFZo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1A81A070D
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 19:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728503229; cv=none; b=u1W+gYvuq47XLfpFE1R9RH8vzFRlxfrl5uQgAxcqClm7TlrAhyJCwHK1aV06ua+zge/HTqfZHMyQRLs9LuAcgZWTlhFF3XJIWeMn/Edwj12cdz+heIch2+C0P4nz0CU9bNU+F6zKp8hycthW+VbzMcYS6FDz5VvaSVYhfA2dY3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728503229; c=relaxed/simple;
	bh=Dh7ga/d2XBooyaAMvZCuDhAvR4tizM34H0vmH3WkLhc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LZIzlOScVD1AH/G+ZKvxk3KGKuFgbnPrUvVZu+A9/aHocPYKalley86gAqlh50/oIM3cvqNeMbp8F6OCCOhyWkyLG0z3zlMx3roQDbzQ3lRISiItIAqrgp/wI3l8NkbJnSyJ1E3Gkhfm24bHEQ/hWNNI2JUBhoxa5ZrIu+5ttdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nQjeCFZo; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-835496c8d6fso3284239f.0
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 12:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728503227; x=1729108027; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uvh4iiBnc9GABk//+8Yu7eZY3YdReIvqE1OIgwzNQzA=;
        b=nQjeCFZo9JZEw7Zrjt2DjMlr/odecgJv2+uk+CrzjjYjD9Kon+ANoMpLtQnHYkhl9r
         n+EMaONTG0PKXw8LhpGTu/zY96jzgCndnrYIFJjpKT4cx/M5GURUaTffouMv/gNWTp6B
         MM3v4PhtAacTFPdjTbBS0AAyLolG9faRrclq/TUj0BjNZBGFjuRLLOmOXIR3PK0EhB4R
         P8eHb56VPZdepRiAP4ycC948UIXKjyVD54MobNIKMlg0TJ2o/zo7xWmRK7ev7ER81cph
         68rd9zFPUboaqWseUET6/hsn1dbEasASSNOTe4GtOMsuo8xWhxddP4DYGAiAFLmBI+B7
         wHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728503227; x=1729108027;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uvh4iiBnc9GABk//+8Yu7eZY3YdReIvqE1OIgwzNQzA=;
        b=PrZ8U7Mha/4jokqE7SLv4iE/xg3f24my5OWD3sjGvFBlhZk7Ft9HwzYYdzEqeCelyz
         mZ+rTVwG/YMn/3MQM3biw89e3HShAY2Ebkf3kodEfvUH6Zj1Br1QltiL7haLyCA22YrU
         qd9ksqzoHXx4gvVDCmdQucMf9dIMSOMaQ9hsDZOdz/JmxJTfV3Ncm9fhdYJzK8Z7Ms79
         jPpN6ETtlq24fyA4uPKwPbka/G+4VQJQe8ITNSdlY8mVKhGsCXDB6uK+avW4Ci6CBPhQ
         vugyL4yZiekEtUACi+LnC+TFQjHfisGgojDeI52XqBnYqu3FdzutMMttv5FukQbMKT8I
         h7xw==
X-Forwarded-Encrypted: i=1; AJvYcCWO/J7LfzoA05mwOzXfjvf3D/Cf7+jZSpZcodikbGcOatbPQjk20b8EZ0TtHpoRcriVKZXb/0mlVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVmeBJeqlSGyXj66mCi6Lmzew0sZMh78zpV1cm7Yv1j0BuE4TS
	2R9fy2i3HaGrZneb2oOeRQS+fPn85w0eo9HXyufwHIdAmTlxH5CvGX4XhsMd70efDbgfIUFYjlC
	9sy0=
X-Google-Smtp-Source: AGHT+IE4DISKPdJFVavkJwzDHlSsP2fmiZpSHCq1oOWVHTivsRFg25EslSrR91RJPeMtqolWMudZ9w==
X-Received: by 2002:a05:6602:27d2:b0:82d:38d:1362 with SMTP id ca18e2360f4ac-8353c07a5admr490036439f.0.1728503227650;
        Wed, 09 Oct 2024 12:47:07 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83542c042d8sm34222639f.35.2024.10.09.12.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 12:47:07 -0700 (PDT)
Message-ID: <a1d6c6da-b20d-4891-9aa0-36e0c3fcc0e9@kernel.dk>
Date: Wed, 9 Oct 2024 13:47:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
 <016059c6-b84d-4b55-937c-e56edbedc53a@kernel.dk>
 <CAHS8izOF5dM7WUrzDhGrR_UP7t_Mg7=sgti_TSbqG4x00UBfXA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHS8izOF5dM7WUrzDhGrR_UP7t_Mg7=sgti_TSbqG4x00UBfXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 1:32 PM, Mina Almasry wrote:
> On Wed, Oct 9, 2024 at 9:57?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 10/9/24 10:55 AM, Mina Almasry wrote:
>>> On Mon, Oct 7, 2024 at 3:16?PM David Wei <dw@davidwei.uk> wrote:
>>>>
>>>> This patchset adds support for zero copy rx into userspace pages using
>>>> io_uring, eliminating a kernel to user copy.
>>>>
>>>> We configure a page pool that a driver uses to fill a hw rx queue to
>>>> hand out user pages instead of kernel pages. Any data that ends up
>>>> hitting this hw rx queue will thus be dma'd into userspace memory
>>>> directly, without needing to be bounced through kernel memory. 'Reading'
>>>> data out of a socket instead becomes a _notification_ mechanism, where
>>>> the kernel tells userspace where the data is. The overall approach is
>>>> similar to the devmem TCP proposal.
>>>>
>>>> This relies on hw header/data split, flow steering and RSS to ensure
>>>> packet headers remain in kernel memory and only desired flows hit a hw
>>>> rx queue configured for zero copy. Configuring this is outside of the
>>>> scope of this patchset.
>>>>
>>>> We share netdev core infra with devmem TCP. The main difference is that
>>>> io_uring is used for the uAPI and the lifetime of all objects are bound
>>>> to an io_uring instance.
>>>
>>> I've been thinking about this a bit, and I hope this feedback isn't
>>> too late, but I think your work may be useful for users not using
>>> io_uring. I.e. zero copy to host memory that is not dependent on page
>>> aligned MSS sizing. I.e. AF_XDP zerocopy but using the TCP stack.
>>
>> Not David, but come on, let's please get this moving forward. It's been
>> stuck behind dependencies for seemingly forever, which are finally
>> resolved.
> 
> Part of the reason this has been stuck behind dependencies for so long
> is because the dependency took the time to implement things very
> generically (memory providers, net_iovs) and provided you with the
> primitives that enable your work. And dealt with nacks in this area
> you now don't have to deal with.

For sure, not trying to put blame on anyone here, just saying it's been
a long winding road.

>> I don't think this is a reasonable ask at all for this
>> patchset. If you want to work on that after the fact, then that's
>> certainly an option.
> 
> I think this work is extensible to sockets and the implementation need
> not be heavily tied to io_uring; yes at least leaving things open for
> a socket extension to be done easier in the future would be good, IMO.
> I'll look at the series more closely to see if I actually have any
> concrete feedback along these lines. I hope you're open to some of it
> :-)

I'm really not, if someone wants to tackle that, then they are welcome
to do so after the fact. I don't want to create Yet Another dependency
that would need resolving with another patch set behind it, particularly
when no such dependency exists in the first place.

There's zero reason why anyone interested in pursuing this path can't
just do it on top.

-- 
Jens Axboe

