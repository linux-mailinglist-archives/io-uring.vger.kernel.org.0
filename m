Return-Path: <io-uring+bounces-11369-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A0CEDCF540D
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 19:41:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 33D42307E94A
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 18:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8CD3358D9;
	Mon,  5 Jan 2026 18:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2aAY+763"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069FC2FF148
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 18:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767638491; cv=none; b=JAhN6l2XMS8NsKxrOn7K2WGBuPaFfLvgqrsCymhIEQF4xnsOKMDIwcUhAi64n6psKV5GMmGk4/tc0RYlrv/rWWCHxzw7AaFNFIIgkmQA+hl3EYe8LFIYBDLXH7b8Xkkkce+pSm0eJWbFhw5diV03MQxxrD0vOAK7NFycCzuRLf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767638491; c=relaxed/simple;
	bh=/a1Hy0kLuaRJiGHHXojKNH+dCMvtyXRV2yRpqLLOWfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TRikTV1c0tn8i4mzHg7MNLhU5DcNq54Mw8vZDCnqG5qLThEtTs3Y/joT/4G94fII75vudo4/2U3+uJcO2IUy/FxREvyr8HX0le3ACAw005kdkSqGW6jGSdcK5/ub011/zhrF9hbll5eNYYUHQmXN61BggGHGPM3kwlTmiAhXWsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2aAY+763; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-3e83c40e9dfso157277fac.1
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 10:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767638488; x=1768243288; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jin//z/qrm0DaBLbU0nDgSt3JPs+pPrI/vpnGlSatUQ=;
        b=2aAY+763TZsZoBIf02G6wGzpwtSNFEAeEfqJzPhuleGKu1IuyuXG28LWx59OylRwcs
         RC6dHnMpgN6ye5NSYGx0QcfVLVJvCso84wWEAFE5DtrrTFF6oLaqUn4ITBLHKoFlyMf2
         DwEY2l+G9xU+a1Syu43l5fGPMjYkvBSUKh3+6nrHXHMMHInTeZ7TT5AIKsUcEs87SZRR
         4XwwTF4v49eANM2sxuTYEihSmlxGDWIQtVp2IyYjkGmGxyXYIw2CxlK0hTaMrJ04dgKK
         swtrCSwiLJCu0Bvst3QWGPaDha8c2p+CEXhA6A3VHhHDEkV5lx+tcd31TLTRVGtpk4Q1
         aF+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767638488; x=1768243288;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jin//z/qrm0DaBLbU0nDgSt3JPs+pPrI/vpnGlSatUQ=;
        b=jzrrpYWDK3FLqNDHYNl5FbuTuf7uVodM6IUeFLEgzGWOVfuYnqJyc+9RwXmjZhxdE4
         zXp+s5xf9/SmtP6QP1w/8Bahf8bEkrskMWUetwlgLmIOkXBnv4LEDhmhtUs8XsH3vcJH
         WOnMvET7F35LZ8xOeY/eVNS47SoqVdnfUTzGYC+HGuFarkW7jZneN7wWXVRG05d9PHz7
         v/gqiBk8ksO0P+PwUwGORVEiE+czchI/03wEWUvKmf1bq8KlWsSWdCDgSaom+NNGgFES
         2aOblYxHmFZX/HyRRqCwSD3nCnBmZwLuck4H7Qs9rGRmgq7veXOB74DwP0PrleGDu0ne
         7pRQ==
X-Gm-Message-State: AOJu0YzTR8k1RO6sGm7JK/mZLqR1Qt+AVrdQ6yQruKX0sTQl4k9MbaOb
	C2IEFlAVxJRMD0jfLJHoliMBrwgvLm75be9gmhlKwJGhZCoQ+j80bnPak+epiQX3nQ/hKPmyk6u
	ne0um
X-Gm-Gg: AY/fxX6nfBRfG3FfOw096tPSZYK1wKNlzE07Duki+KV+JauBz8Xqc52WDOtXk5xn/Tp
	7dAeVGqX806dNYDhVsMLToEK/eqGOG9mQ/h/uR6Z0t6WWCHibtBd9RWOOBCPFpvWlx9bkLEti/z
	zfGhybqVGWd8YB7NLE7+L8MlrUg05/V7WxeqkSs3oNo3R/EbVNtRBzNnRn1Gjwk4w14SOz4Q5n8
	tAYhn38KtlVrB0u9bJIRRDkw+lW+r3ZFT5zsKQv7prTGl4bIhwB3n+PMvj0HWvsKNeJnfm16JRP
	igLStHJ/BjYv8yzwkvwhN0m2+PD6MVUVSaHxe8385MhGk/ay/zB0omXen7wZEbxmIdED83ME8O/
	Kxplc4FNIz8jwgUVfXxLXPFqbysvv9pVyOVceIyX3QLa6PkrlV7kCbDJyQl+NxsWC0y9vriV3Nm
	npBiIb/XjOpaEysQQ2aNw=
X-Google-Smtp-Source: AGHT+IFXlkV/NcG47wl9HukcJ/KALKQjje/qBV4E28fpcFe/+qNGNY5jsQk9+vVstBM0Q2VRcnBzxQ==
X-Received: by 2002:a05:6871:7bc9:b0:3f5:5af:c9de with SMTP id 586e51a60fabf-3ffa0d5b2bamr174665fac.51.1767638487809;
        Mon, 05 Jan 2026 10:41:27 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa0365dc4sm231425fac.18.2026.01.05.10.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jan 2026 10:41:27 -0800 (PST)
Message-ID: <53244a6d-75ca-4fa0-90f6-8d2952d85b46@kernel.dk>
Date: Mon, 5 Jan 2026 11:41:26 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/io-wq: fix incorrect io_wq_for_each_worker()
 termination logic
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring <io-uring@vger.kernel.org>,
 Max Kellermann <max.kellermann@ionos.com>
References: <f98f318f-0c3b-4b01-afb2-2b276f3fe6cd@kernel.dk>
 <87y0mc6ihs.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87y0mc6ihs.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/5/26 11:07 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> A previous commit added this helper, and had it terminate if false is
>> returned from the handler. However, that is completely opposite, it
>> should abort the loop if true is returned.
>>
>> Fix this up by having io_wq_for_each_worker() keep iterating as long
>> as false is returned, and only abort if true is returned.
> 
> The fix is good, but the API is just weird.
> 
> io_acct_for_each_worker returning true indicates an error that will
> abort the wq walk.  It is a non-issue, since all the two callers cannot
> fail and always return false for success :-)
> 
> Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

Thanks for taking a look! Was going to post a followup just killing
the return value of io_wq_for_each_worker() to void as nobody uses
it. Only the cancelation side with its matching will use a true
return, most of iterations want to iterate all of them.

-- 
Jens Axboe

