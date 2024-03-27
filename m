Return-Path: <io-uring+bounces-1269-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B10C988F333
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 00:32:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 409D2B2137B
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 23:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB5112E5B;
	Wed, 27 Mar 2024 23:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="B1grv3zb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30CB152500
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 23:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711582346; cv=none; b=nuaxQYcTDmLhL8sbXGXkRDQcBFKpKXe+EDL8mAHm5vqA3Hr5elm9oQRxMBv+3GMOU8s+Di/7pws90XsorDzedAwDrQDmsqBd5lBU3xPNP6Ry1SuLVVN32ggar+yDTxKrKQxagLUUNorwoVckjPvs8Sf1CuyRkCeL5mM+bBiwZ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711582346; c=relaxed/simple;
	bh=VmxtqgUrzE93Q/Wz1sL1pFYQgikUHYUnYZlsNQquL8A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Kk4vP1jO6kLUODGv5FuDxDGXVHw/IEi26+GyoYD/iK09omUGJ4Iw+/ABcK1V24nqcTrhUzkrEmMMXlCnWOolUPCnbYD+UgjP/NxvMr6Sxv92GgGuL7QQ7eV11qfYp7125pw0bWGvIOteGl5cCHivKcgLyRaC5YI5J9STTIl14Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=B1grv3zb; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-368a603adc3so1242195ab.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 16:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1711582343; x=1712187143; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cd+bLnuIrzo5BL75P35HbQa9bf0AJcROp8J6EUCroDE=;
        b=B1grv3zbrHDFhas79oUEMfE+jABAzqxXHgZkTFxsZQFfSG1qT0Jj76d/lkCi3Dchpq
         WJ2DKxmmLCoat7rmbC004lGFGIwtEIb4a37kjFiXvXVyE/AN95Ir/RguAps4Isr12wbT
         FlM/S+41c2lRWUnz3sMidTo3+uoMn3HcrMr34uVlJTj62/ElGo/VUf9K7JJshhT/AGwY
         b4QfyD4/0LMsqA+iQPEu9MOunaxKxL40RLBaJc6Twmpy2AbJAzwsYCrJTi/LwatswPqT
         qcwzYyjpASBWwQAyHusG3vupyX/zMRb12asi/c1yEbf6GIcMPzRN0YLqzOdUfi3Wleih
         CtFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711582343; x=1712187143;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cd+bLnuIrzo5BL75P35HbQa9bf0AJcROp8J6EUCroDE=;
        b=Qd7kv+mrhYJtbJh+st0vT8vmuA6vgEeS7OwLJoH8zymVc7TU56m3o4oM8Gdi2HIrwS
         zb+RZ+nMFrVz9RKt5eTjKrVb/o2ia/LvA6GN13IPucfgcvqRyFh9HKtoA2TU5zqvpE6D
         82oVwSSM3Rr/GN/Zrk8SESq5yNeLzIQBUZQBc0yNP1Or34rStjhhpceMpPgTMTNkeEPH
         dUXwfyRXVYlyRSnImbNC/9Vd2ml1SMhLooW1PukZfUp9fdtK4LUFzMAbhr5nKDYuKQUa
         8xEpJjoV4fZLsIKok1FbXBpRFiO2aj4JtlQ5tpx0MxysYMJCmRmh39psugLV3i2Xi7kf
         9VXg==
X-Gm-Message-State: AOJu0YyFrRnqzkPwmeljhVbHafPQQOHpOy9R4pmAjHbpasSlqWeNQi2B
	lf0JlFhH82spWRalv2uQwfiRVv+gtd68wApwwgiWRFYhPNJcL8TaPViJV79vC2g=
X-Google-Smtp-Source: AGHT+IE03vHmTzxQG9QLpdQbmSqGVQrY7PdAbqyHjUU+tR8mWE3FVtLUmfvgcJCOs/V/EwuTnJXiBA==
X-Received: by 2002:a92:511:0:b0:366:93eb:fbaf with SMTP id q17-20020a920511000000b0036693ebfbafmr1468432ile.11.1711582343034;
        Wed, 27 Mar 2024 16:32:23 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1151:15:40a:5eb5:8916:33a4? ([2620:10d:c090:500::7:1d1f])
        by smtp.gmail.com with ESMTPSA id bw28-20020a056a02049c00b005dcaa45d87esm53837pgb.42.2024.03.27.16.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 16:32:22 -0700 (PDT)
Message-ID: <78e206c6-111f-4482-83ba-cbdd5ad8b61e@davidwei.uk>
Date: Wed, 27 Mar 2024 16:32:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] io_uring/rw: Get rid of flags field in struct
 io_rw
Content-Language: en-GB
From: David Wei <dw@davidwei.uk>
To: Kanchan Joshi <joshi.k@samsung.com>, martin.petersen@oracle.com,
 axboe@kernel.dk, kbusch@kernel.org, hch@lst.de
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
References: <20240322185023.131697-1-joshi.k@samsung.com>
 <CGME20240322185731epcas5p20fc525f793a537310f7b3ae5ba5bc75b@epcas5p2.samsung.com>
 <20240322185023.131697-2-joshi.k@samsung.com>
 <c31b0c71-dc6a-4481-b2d2-c41f5cf6371f@davidwei.uk>
In-Reply-To: <c31b0c71-dc6a-4481-b2d2-c41f5cf6371f@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-03-27 16:30, David Wei wrote:
> On 2024-03-22 11:50, Kanchan Joshi wrote:
>> From: Anuj Gupta <anuj20.g@samsung.com>
>>
>> Get rid of the flags field in io_rw. Flags can be set in kiocb->flags
>> during prep rather than doing it while issuing the I/O in io_read/io_write.
>>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> ---
>>  io_uring/rw.c | 22 +++++++++++-----------
>>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> This patch looks fine and is a no-op on its own, but I think there is a
> subtle semantic change. If the rw_flags is invalid (i.e.
> kiocb_set_rw_flags() returns an err) and prep() fails, then the
> remaining submissions won't be submitted unless IORING_SETUP_SUBMIT_ALL
> is set.
> 
> Currently if kiocb_set_rw_flags() fails in prep(), only the request will
> fail.

Sorry, that should say fails in _issue()_.

