Return-Path: <io-uring+bounces-11813-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0B1D3AEEE
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 16:24:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B59E530124DF
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 15:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D68338A9A1;
	Mon, 19 Jan 2026 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zDO36wkM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com [209.85.210.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940F5235BE2
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768836133; cv=none; b=mGew8edmhN3M+2EowTx2xfMspH6KbNmQYAakyYJwcd5NP57Niud81EpWT/9hzWMu4FJ/2RTX17ZgBAlixV4okpeiYyHUbNzW1jog3rtFtCQxBbB1bESfHupKpPsRs6W5xlbv+E5vGXzNbHI8JpvSL5FLg1ij57zcZ68Lf/wOTkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768836133; c=relaxed/simple;
	bh=GxOZEYGA76bJHdvdmNh9m9B9ugmbf0yOGkt+P4vLre4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=NonYFjC4wTxSbBm3x9wVlbKWoNxcgdbCgg0iCCjb1Ib8sxaDF8fYYBs6omjvWkSGnp/NWkVBMBeJF0v1XwmwBGC1VBm/xmavmKROfQgGnFmhoIkyqExSY/F7Cxw3PMLyzI9j2StYivFhXZxfFCRyxr2Enj0xAoBPMQ9vQbfS1V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zDO36wkM; arc=none smtp.client-ip=209.85.210.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f65.google.com with SMTP id 46e09a7af769-7cfd2be567bso2698234a34.2
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 07:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768836130; x=1769440930; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lUFD55+Kt87AlwhomERgXdEYs+eGxfqziPcFxLUpDFA=;
        b=zDO36wkMLe1rUzO3vYySmO5amNIFYvy4VDP2gLXkBaynR0cZaLPBuzC0QV3vMY1KMU
         C+khSJAVBZXuw1IFAAQ/GS9cpUAo6MbeyFxHv7EZBRftDQeT1bpotCiw56OFVtpPGSdR
         Vwi49riCPkPyJsQDoG+18OKQQH5ImW/UMz4g5hkflMwEL7/du96dMh0Bwu/LIbSS3zQB
         M78gO5vJgr+10SxgW/G5DW1wIyPFK8AEFN1VAFLcIdngYVlUH0M9JVoovnqEOL5TqBQp
         Fc4fvg1lH08ThWv3ySwn5fTyTPPUx4Gk55+bcwOUHIZoxcMEQdvlEWM1uygFLZA0Si7u
         ZLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768836130; x=1769440930;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lUFD55+Kt87AlwhomERgXdEYs+eGxfqziPcFxLUpDFA=;
        b=tjcKi70vg53b9Sy8KkaWybCRsP7/z0u0Htc6JDiH9T28h1rj6Z59oap5Myj5qfCs6L
         S7mGfjvGzY5rP9ypzlb4qERGmbJOgIf45yFl9hfMFlGoxgNvKb+wQF/b/L7U2EqPVm/g
         LoJX0H9hLoO32FP6IyQE5ZVFA5Zg3tiaMInxGC47I5liEGVRSGAosQloCsY8WW3L90fZ
         XpVNb/e7dNK9KbgAanWgP+KZ+F+02Xatf8EFWEbpUBmaBygCR9IgsUK7t7lhX/8c2vG7
         Xesx2PxOeEoBKAlUoDVc8mJ2/IYvTkXYmPOVu+9+jN6ZznZZZZQZTY9augB/Im6yank+
         FiIw==
X-Forwarded-Encrypted: i=1; AJvYcCVF0AtAHP6I6UKFM0BmVqmgSaTdHwDUq9ZeXyMGO9BodSODH26fzT6kEU/J+I9rL6uMyJtk3/mzhw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1jnwEyf88pRwkNQncGjgjcXvk52kShQBc227o+0ddFYbR5xkk
	82meLMiwh7TWk81DdrlHVzBZ+q0AATwIBrUI0M5OQKoyEUBxQ5zmtBrSgRj9h/Z/HgFcTyOdOGH
	13HGo8Mg=
X-Gm-Gg: AY/fxX6FPslsitYC0DoHJp2V3n96jwI4iUPbqc9C77QdoUSQ1EJS4+928NZs52QQra+
	OhwVxSF5e0S8iz8S1eY5oHhjj8/0AagiP0bIFUVko5LNrg81KOPY/HPKiy3msrmfgnepOA+Elpw
	xWr++GEr3qHkH8Wobdf6x9/bX6kF5zjyf5u7Cp+bl4AHPqfvdCM8J97vIYTkPTu/Okw5qK2+hHr
	ImMZu4LXb9PnYCqiKRuB7uukEvvVrDuVzoNXuN1U/sMXtKM8U1s43zAwkvtxLf6G53U2YHUbi/p
	YLPcJ/eja/xNgIquUiZmClkye96dVb6FO29h0dmvu+67IrnyyjTLFFKjmgHGI4WBX/y0E22Qq55
	ToahhpiHxIBFQuX9KcYMbxlCehd5IB5CZ1jS/2S86ufxNxDCFe86mDzgKBvNSPDucPeE1gj7OFL
	AxK2p3Z6qFGdoKAxUHgGa+vB7+akhHfaUCWx+jEK/hiwCNwzRBIfGYifHoRUWMT2axcVbfKg==
X-Received: by 2002:a05:6830:6d23:b0:7c7:2e9d:aee1 with SMTP id 46e09a7af769-7cfdee13230mr7336893a34.19.1768836130500;
        Mon, 19 Jan 2026 07:22:10 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf000b80sm6856840a34.0.2026.01.19.07.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 07:22:09 -0800 (PST)
Message-ID: <6f703719-ee33-4fd9-bcbf-afb15967a494@kernel.dk>
Date: Mon, 19 Jan 2026 08:22:09 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] nvme: optimize passthrough IOPOLL completion for
 local ring context
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20260116074641.665422-1-ming.lei@redhat.com>
 <9859f637-d8f9-48e0-98ba-42cc6255c73b@kernel.dk>
Content-Language: en-US
In-Reply-To: <9859f637-d8f9-48e0-98ba-42cc6255c73b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/19/26 8:19 AM, Jens Axboe wrote:
> On 1/16/26 12:46 AM, Ming Lei wrote:
>> Hello,
>>
>> The 1st patch passes `struct io_comp_batch *` to rq_end_io_fn callback.
>>
>> The 2nd patch completes IOPOLL uring_cmd inline in case of local ring
>> context, and improves IOPS by ~10%.
>>
>>
>> V2:
>> 	- pass `struct io_comp_batch *` to ->end_io() directly via
>> 	  blk_mq_end_request_batch().
> 
> This is a much better approach indeed. Looks good to me.

Forgot to mention, Keith can you let me know if this looks good to you
too?

-- 
Jens Axboe

