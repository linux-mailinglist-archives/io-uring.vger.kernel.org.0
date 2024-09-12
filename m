Return-Path: <io-uring+bounces-3174-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C5B8B976EA5
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 18:25:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5241EB236F1
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 16:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446771448DC;
	Thu, 12 Sep 2024 16:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GGeSbvVy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D49C126C0E;
	Thu, 12 Sep 2024 16:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726158341; cv=none; b=QTrUDNcJjuVDDciD9szkOLzCQRHEzrpT6VAi5ZMS8iskUnqME5PE/3ixcC1f+ldhBiGPcmKcBKLcSVzF9NmfaUKdiMgApI7sS2rFTZvjaSe7kjtJd8rlkZerEnoFNmMXmdc61EBqpgzDgVSFIdU/I/ru0m1vQz5BoYR2YJ/XAdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726158341; c=relaxed/simple;
	bh=iE1Efp2l/GR0xIqg1eb42bxiW+b3eDrXYmNuu6MJ0d8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eWv8GHhAunYDw+2OxwCEMb4wTqEyjF9ghSp/wrmSOO66lzNAHIYNg3ZR/1LlPE+vXedSleaQRqCtNC1A3P0sxXHqH03NPk/2uITXL9ASfP7nLL5jZeboZBJuq4KOX1ootWHHdNJFNTfBZ/aTE2hnykst4tV1b6x6rARQ2vRfKZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GGeSbvVy; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-428e1915e18so9910495e9.1;
        Thu, 12 Sep 2024 09:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726158338; x=1726763138; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G7CTvQcMV7Vg/CdXkgmBv+zYvwedvth8CuG0vxBi0xI=;
        b=GGeSbvVyXZGh86dUYseEyHoGDMH4Fdh0O0EjV8Rq8pYFRKSk2SQcd+48GJwEHjh9vj
         Vnk3y1z/la7inHkNenU1G0UNgl9iBJHAeNuZWd1DcTnIDyLZFVLihLUSVgHVhKzj5CsB
         enDiVESWcFdEObDF1ZwNUOljbKmDLdQ1lTnYNBoZXAGitZlzqleUIBQt2LDNBcb8nE8K
         BxBK/L18T46uRvfLXrQrMd2Ys0+uT5cnc2zDsUYRnwDOiLBs+4a8mZD9U+Mfl6KeO1DG
         sV6RaAkw/6cN9GeV0EMza/4k93nb7oyt2eU8jyPvMTBknfjmyokEkNhpKAuMaH89T4p1
         Taig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726158338; x=1726763138;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G7CTvQcMV7Vg/CdXkgmBv+zYvwedvth8CuG0vxBi0xI=;
        b=SiR8Kypy4caPPCQav6RLNnYtOtwCB2gAx/MpCja9VBsXnp+Gth69W3YSsaJQlSx545
         5Pdvo18z38P3o/mkmqm8mpp81xsXXpCeh7T/gBHkHpcUO4WmvnzdxUa2Jdu/iT8biuhJ
         gRZ6hciARjRxPukz0Yo9P0sY1EHEmOW9J2JSj4Dse9hfJmkAq+bhv4enCVKo9lQSLbRY
         mewHZT+WEGzXPTv+Cum93TUu4TZsGBbuSmpYOjfGCq5MYcm91p74d2me5UEMkxz4gkkl
         JvgR5215oQ3lzbbgTHB3keGshLj4iEXBR+whSCgyLJIeGKPbdyIABzn34zt7nH+3Z+RK
         VotA==
X-Forwarded-Encrypted: i=1; AJvYcCXnas7xxi4XaKc3pxxh1KcyKw0Y6UR4R6GhhUQX7u2F7rT7/a/mS0rOzeBdajitNvn11q8VS+rJpvLeSg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQVzMxAacoFKKErIJ6oYdvlCv5FBVIZ6f72Aovh09QiExho/Nr
	JBNDYIrYvg/8VABc2cHi+8MiZ8TPNDxTRNBGsSBS6+oagekLChzN
X-Google-Smtp-Source: AGHT+IEYjsGFRmRxM2lE8dlGubF0aLspYjSbRzQuTzRHFWjylEfEXSoItu3kA3+dEZurCLzy9VYPQw==
X-Received: by 2002:adf:e551:0:b0:374:ae04:c7c5 with SMTP id ffacd0b85a97d-378c2d48eabmr2011639f8f.36.1726158337499;
        Thu, 12 Sep 2024 09:25:37 -0700 (PDT)
Received: from [192.168.42.65] ([148.252.141.246])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb8182dsm179570045e9.36.2024.09.12.09.25.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 09:25:35 -0700 (PDT)
Message-ID: <707bc959-53f0-45c9-9898-59b0ccbf216a@gmail.com>
Date: Thu, 12 Sep 2024 17:25:59 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/8] block: implement write zeroes io_uring cmd
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-mm@kvack.org,
 Conrad Meyer <conradmeyer@meta.com>
References: <cover.1726072086.git.asml.silence@gmail.com>
 <8e7975e44504d8371d716167face2bc8e248f7a4.1726072086.git.asml.silence@gmail.com>
 <ZuK1OlmycUeN3S7d@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZuK1OlmycUeN3S7d@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 10:32, Christoph Hellwig wrote:
> On Wed, Sep 11, 2024 at 05:34:42PM +0100, Pavel Begunkov wrote:
>> Add a second io_uring cmd for block layer implementing asynchronous
>> write zeroes. It reuses helpers we've added for async discards, and
>> inherits the code structure as well as all considerations in regards to
>> page cache races. It has to be supported by underlying hardware to be
>> used, otherwise the request will fail. A fallback version is implemented
>> separately in a later patch.
> 
> Except that as far as I can tell it doesn't implement a fallback, but

I could've worded it better, but it doesn't say anything about
implementing fallback for this opcode.

> an entirely different command leading to applications breaking when
> just using the command and the hardware doesn't support it.
> 
> Nacked-by: Christoph Hellwig <hch@lst.de>
> 
> to this incomplete API that will just create incompatbilities.

That's fine, I'd rather take your nack than humouring the idea
of having a worse api than it could be.

-- 
Pavel Begunkov

