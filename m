Return-Path: <io-uring+bounces-3103-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93D269736F8
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 14:17:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6A551C21450
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 12:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AEDF18C021;
	Tue, 10 Sep 2024 12:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l3Xvwr73"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FF9184535;
	Tue, 10 Sep 2024 12:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725970650; cv=none; b=Er0DiE06wXL8tar0tRmRk+1hRH17woy+BSPvERxCF/r7TONv9StrVoYgM3xMDSgvlffWZ4mmtFs+PzR1oLCWW/IvpSdCPo7HiuAU8NPwsaPkK6VIWp5xfYaEXSaAnnalPvqRzQb6j1fOUwpAIIGExwzbnA54ySB2MCbOFkFHDTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725970650; c=relaxed/simple;
	bh=vBbcLtpq/Fkpn9CcUi3sjaW4HYduRr1cKYig8p3uFz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XC6rCjZmFkVJazkicMHtVROAhEGlj483We7at5hW0JCyA0JtVkjg8KDOH9cX1u9lF9WLpXQpd15t8YkoVVRFw5xsN73qszqUbTJNZhYptAuOOxfbJpAKh/rc8ws8vssWYHA40p39P7twcXa4axWRMz5S5bAmk4AMxEW0vVrxLZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l3Xvwr73; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c3d209db94so5991669a12.3;
        Tue, 10 Sep 2024 05:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725970648; x=1726575448; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B5DPIEmhfcFK/wmXZkZn8+119vQ+vEDZcvMKdE6RVNc=;
        b=l3Xvwr73Fq+XdHnhZ3co54sq02OXEw+Ps2Wm8EHItmq3EpfV+TzKQIuSrPW9Hlwpn4
         ZMPXEk48Y8sTdR7FOFmhmlHFV7VB22/MwwZYEIXQKZE3zbHh/rloK7mwhNEJlLOqDLYF
         rGD5f2V2jvLhzQLFxP+kD5KtxazmPt8YyKKvKJfBdP4UcpfPtm0Z9JsV3bXVlsp20I1f
         fpNF63N35lyHCOpxSbXJmINi7ztGFqsiSw/lQfxPilopLXy5K6c/bmIPp2woZLg3XBM1
         hyIMiKL0JQvcbHLheyHAls1SA3lkbgfdeaYoySHT6zFAhlyoOOERlTPPdvd9uElK7eu5
         DChw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725970648; x=1726575448;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B5DPIEmhfcFK/wmXZkZn8+119vQ+vEDZcvMKdE6RVNc=;
        b=CuDZxgFz1HrwtVAce1tbVHxyx6LjknHyzYH2iNwVXMBw7mwW1kOyKrae9IWFHNoEUj
         R+vxTxHYK0zS0T7hzdbpvkuiKSjaJNjazMlPQslnYnVuieepXR/j8FJnBFftBJLDOnHC
         mBJjlUA+JlY1Wka/6td9WTPgqwLkXd6hFTTFxjym7bzgPwSkIvaouZOoibYKwiiyH0t8
         DKHWBEmvalKRJS748lRfq/gmfSZI5Lx3d4eJnBoIRYW74F6DQ6f/7ch5lRYUzBMoEP3x
         H5FXFbbu5yXYvzXRKdPtmZUZpdwFZWGCD6UzhoqcnvvyU0wBWiZf/HY61lBjP2Lt8xM8
         C88w==
X-Forwarded-Encrypted: i=1; AJvYcCVvZwqTiuXX10GE4HxeqWgv0rU9PnJVLcoaKKuZtSUdSJATgkv1N0kzy5OH9fHbM9arCKkVR0wYyCahtQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpuzCYvdUj3kbB1ygQvc9C42VL1Q9L5l/nnTC8zKhoqZMhHB+0
	5mYBflUR8QN1v1SN0vQVlqP68HszAp015qFUfGf5Mpk2xc/qOq2D
X-Google-Smtp-Source: AGHT+IGHgFXvFqhW46dxw/Rl6tc8g6NF17PuqJzB9Ts9iesmgZYFqjPLcEVz/kCVwFwT2vrIUj1Yrg==
X-Received: by 2002:a05:6402:4015:b0:5c3:d251:e4ad with SMTP id 4fb4d7f45d1cf-5c3e963695dmr11804171a12.22.1725970646719;
        Tue, 10 Sep 2024 05:17:26 -0700 (PDT)
Received: from [192.168.42.252] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd8c4d4sm4175886a12.82.2024.09.10.05.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 05:17:26 -0700 (PDT)
Message-ID: <d205d118-8907-4da1-8dd8-2c7c103d2754@gmail.com>
Date: Tue, 10 Sep 2024 13:17:48 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/8] block: implement async write zero pages command
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1725621577.git.asml.silence@gmail.com>
 <c465430b0802ced71d22f548587f2e06951b3cd5.1725621577.git.asml.silence@gmail.com>
 <Zt_9DEzoX6uxC9Q7@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zt_9DEzoX6uxC9Q7@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 09:02, Christoph Hellwig wrote:
> On Fri, Sep 06, 2024 at 11:57:25PM +0100, Pavel Begunkov wrote:
>> Add a command that writes the zero page to the drive. Apart from passing
>> the zero page instead of actual data it uses the normal write path and
>> doesn't do any further acceleration, nor it requires any special
>> hardware support. The indended use is to have a fallback when
>> BLOCK_URING_CMD_WRITE_ZEROES is not supported.
> 
> That's just a horrible API.  The user should not have to care if the
> kernel is using different kinds of implementations.

It's rather not a good api when instead of issuing a presumably low
overhead fast command the user expects sending a good bunch of actual
writes with different performance characteristics. In my experience,
such fallbacks cause more pain when a more explicit approach is
possible. And let me note that it's already exposed via fallocate, even
though in a bit different way.

-- 
Pavel Begunkov

