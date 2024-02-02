Return-Path: <io-uring+bounces-517-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D14C84752B
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 17:43:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24E501C24DD9
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 16:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F8F1487F9;
	Fri,  2 Feb 2024 16:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ObdbWcEg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE73148306
	for <io-uring@vger.kernel.org>; Fri,  2 Feb 2024 16:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706892160; cv=none; b=RFGLgWWHQ6r6SCHR3dqXV/HDch2aXHWhgmQ3BAaFMF/UIAiJc6Z6Y7B9TMLapW2cezj+zAz+tVMcvqkK8S2L2Fv1xkUabjGa+QY9TONUqIqdWxf3bSjJN1z5bfaq6jjkVeLquNS69cNcEnuU+goRL2crocoRnYygR1zRVJxcvjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706892160; c=relaxed/simple;
	bh=H4BUpPP/BbfSYrBSXsunFM2hJu/N7MVd5h5ZNxhtgEw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gEnswKtTscqiJOvJ+guGmq8CtTir1704CygBZ+qFZ3ou7Y9nde9CLlnweR/WCo2ZKAc9/d0bxJxxJNFMhPCNuDc3vbkQIyqtPM9vMxAVfJOogGG2voUgpbWDxBKVNWInmrIOOl1aT6/5bea8qG1zwTOSHLhOhZndXB2P1J2mArA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ObdbWcEg; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-35d374bebe3so1403625ab.1
        for <io-uring@vger.kernel.org>; Fri, 02 Feb 2024 08:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706892153; x=1707496953; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rERVtf5tv7Clyc6ToKF3yV6fDxC9BLC81JcOE+x1HIU=;
        b=ObdbWcEgAp40L0rqGTG8qzrkkJ0WNKiuAIiimORyAPNu+LYx9qk0XpDs8ZPIZHYrRI
         3T05G+kzb9Q1o6/3KjZhBpj2Ezpr/QrLd4C1/Yvp92c6IVxm3j35U5qcveZLodmlh92y
         wN9RBToNvVwrMjueXYzR9t/7Z9DeOfx2ur+tdaT+VKu6XfBbxhDwODUdMXw2mDj9jVgG
         G5q7H+YEU+KaNF52LtQSiLCZ1RgMoXaehrkXiia+/Wmx129BMWLlWZ19/Y7y4YZrOqW/
         fXIPz1gyudx5BbUlCq0VWVL1nxMbKjOA39yTUd34HQKkuUIeGs/qq5RcuPmTWMFfLpDg
         8Pyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706892153; x=1707496953;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rERVtf5tv7Clyc6ToKF3yV6fDxC9BLC81JcOE+x1HIU=;
        b=vTlSKQRLof0mtQXQMPDRSX56OHCHRcukH12CKmX3pwYm22QuSjSGAR93Rtji+CI9YY
         Ga+A/Om+5EZxHmSOkjGmp1jpLixxs5nL966rkMDaceTs314uKbtLmFFzULF5aQtIrVhv
         UaHKKb2QkX1jZ8562s8jqjoGbCz32xHjLqGWkrWugngqjLwbQOWpLYlCpJ3oxNJ1ceQh
         5MlvDrBCYRT5GeVfz82XGVGpaZ89TO9TIhBRmgYlwOwAjV5vJMbxjcGSj7JYNewHWUpX
         B7Q7SoWajwp8qKOzCPjPT6PxXXvDyxJo+Hf8Dzf7DE3tAf4LynCh2dqFi86ppv4azklK
         uV3g==
X-Gm-Message-State: AOJu0YyYTY2p7R/3XWSYUzn/iy7r+CvkdNaIn6GfcZdIahEZcPJN117+
	I5KLutyZaJsfsDOnZXjCnlgDt1xjXQXo2iPnkUMJOdaMBmARt+JOlk3+Zj37En8=
X-Google-Smtp-Source: AGHT+IG2uPp+Vfm/KeGKIuUvt/8X34YdDXvH+QE1pyfWGKMGdXTvL2yW8278eUBB8MSCFDicfFCBUQ==
X-Received: by 2002:a05:6e02:194e:b0:363:9de9:7063 with SMTP id x14-20020a056e02194e00b003639de97063mr7931919ilu.2.1706892153197;
        Fri, 02 Feb 2024 08:42:33 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUleGNKJLGwJqeDahdPvs6MbSNIJ7xWkT3rlfiE+UIxgdC9/cHr2gxhta4xqfUm3Y2wTlC7FvTLa83HSvwE1fY1ofGRnhexH8QYo6feAcSv8env7LU2ipsWsqpffiRI968DB4aO3npfpLpVbuEKBA==
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v5-20020a056e020f8500b003638fc7aaa5sm668596ilo.37.2024.02.02.08.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 08:42:32 -0800 (PST)
Message-ID: <747624da-70d1-4488-ba14-ac79185ef247@kernel.dk>
Date: Fri, 2 Feb 2024 09:42:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/4] liburing: add api to set napi busy poll settings
Content-Language: en-US
To: Olivier Langlois <olivier@olivierlanglois.net>,
 Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
 kernel-team@fb.com
Cc: ammarfaizi2@gnuweeb.org
References: <20230425182054.2826621-1-shr@devkernel.io>
 <20230425182054.2826621-2-shr@devkernel.io>
 <d78b0ed1ca8e1ff3a394bac4ae976232486a2931.camel@olivierlanglois.net>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d78b0ed1ca8e1ff3a394bac4ae976232486a2931.camel@olivierlanglois.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/2/24 9:41 AM, Olivier Langlois wrote:
> On Tue, 2023-04-25 at 11:20 -0700, Stefan Roesch wrote:
>> +
>> +int io_uring_register_napi(struct io_uring *ring, struct
>> io_uring_napi *napi)
>> +{
>> +	return __sys_io_uring_register(ring->ring_fd,
>> +				IORING_REGISTER_NAPI, napi, 0);
>> +}
>> +
>> +int io_uring_unregister_napi(struct io_uring *ring, struct
>> io_uring_napi *napi)
>> +{
>> +	return __sys_io_uring_register(ring->ring_fd,
>> +				IORING_UNREGISTER_NAPI, napi, 0);
>> +}
> 
> my apologies if this is not the latest version of the patch but I think
> that it is...
> 
> nr_args should be 1 to match what __io_uring_register() in the current
> corresponding kernel patch expects:
> 
> https://git.kernel.dk/cgit/linux/commit/?h=io_uring-napi&id=787d81d3132aaf4eb4a4a5f24ff949e350e537d0

Can you send a patch I can fold in?

-- 
Jens Axboe



