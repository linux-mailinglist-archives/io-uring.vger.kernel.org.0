Return-Path: <io-uring+bounces-1986-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5E4F8D2A09
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 03:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E21351C22FE1
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 01:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560CA1E522;
	Wed, 29 May 2024 01:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FYmmfqVB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E03F29A0
	for <io-uring@vger.kernel.org>; Wed, 29 May 2024 01:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716946530; cv=none; b=VpRLLYDQjKLo6NX7W1eQqOZjdok29cwUa9O1eFkpJV333lPEk7yfjwTpUrQXjbAeLxlsa5YnBHf2m6HStJ+0HP0Ju7rqlbm6U1r82UMCjLLpbSDZ7GzIDLlgID96GXrCIJHfTJM8IUb2FlC+nwQ3upMABR+EsVfRDLLfo1I9Fak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716946530; c=relaxed/simple;
	bh=0sHZyCnrBdpZ+LM0bGM/Do/pZfUrsQAW3Cx5BDU3mVA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=iJuNmDz97iFCrnnHfi86AnYKyaeuEJq02FkdxoN4yQB2JqZDlmM5EMVkiNywJ0zpi/Rue4trkuz2yUjMNvUClC0qDVVkXOT5K4dpYPSmk5JjpprqaHhkTv7tZcC43nOw1YjEartIGeYyJDiXsDZQRme0/up8Y1okE5G40/d0NXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FYmmfqVB; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2bdd6b73a3aso262118a91.3
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 18:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716946525; x=1717551325; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8w+3XUHOYs+LfN9cx+psUse7MxEW/IuSiHdcOJb0IFc=;
        b=FYmmfqVBfc1VhEFU1U0hjOT2qmqlkUzEd9UEBXG2O2Pb86FWPoZTwGsA6B5RHL/q0p
         gLaULSNdYfyviIEADfGaX2zgBfOWzjjZI8joY/3DST83YI+9FiFmpMhsZ1wv2pN1xF3u
         tUHnDQo2rushhLF2sOTeUPu6dpf92/32gwT4gOhRSdBtAm3sER8oLk4BC2hbzT1zd+Od
         MD2BUOTDsOFEqloPecJRkyuVn249abrBS+TccZ57H0KAUmpChKUaRrhN3HtvLt7KjaOA
         kFP76OZGA/eDXoAtilLbOACRpU7fWQqdKgbW1NAljU5zTdxzGNxLUTrz2L4SNRyL9Nyy
         VX4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716946525; x=1717551325;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8w+3XUHOYs+LfN9cx+psUse7MxEW/IuSiHdcOJb0IFc=;
        b=PwjLk6lKXQqSPwTkY9sbl+MXfHJB2nuYELcVha2/44w5D252KDM47HSKeyNaVBTC45
         qnlYI2E5/KRsPoZchD+QvLBsiGp9NgMOZFxr9xk5S/ZqSfzO5sO0kz6J7U13A0+suRpK
         1lAE0eXP/nxW7DjCFrxxp/Wh5UUW2hfmGiHBPMkn/XWTiG4OOpXuaNfv4t+KDB6RXhyh
         7jSl7j8bWe9vQyEjUx9pdPE1FSbNcB/9GhwavngxuNoFavO8D5Jxb15XKF9Uh2ZhaqhC
         zrsX7l01oqzxLCz7NCvRrq5ZbLB/cKD8OxIbR2vKBjPy8fpVqofLv4nHgn4BdW2UyXQ8
         1MXA==
X-Forwarded-Encrypted: i=1; AJvYcCU8xj9LhLFyhN/tgfpTCilWpVnvfvoSPwQDQK6IvaFvfm8rTUo5Y/vcGAmzfBbI9UISUE3lAtSJdRZsdmD2qtBwZRjNq9cWL9I=
X-Gm-Message-State: AOJu0YyLrg47EbKrDNbqi2qSNSHAKDtYbOfUYCPnOvWMsa7ej8ntugRN
	0mJlIZ88TJrcBahF2T0+gkR73cHPSW+W4iXAKWSzy59jFKJGGzqLldl/ENvSQLFCPeVf21Mnlq8
	I
X-Google-Smtp-Source: AGHT+IHWCN623jylxBUZr3xW7txHLwMhBwc2jGlFjr+q6K99DBejYsnUJQ2vYJMvxL6zlf33c3E9rg==
X-Received: by 2002:a05:6a20:9784:b0:1af:cd45:59a9 with SMTP id adf61e73a8af0-1b212ce5134mr13812690637.2.1716946525424;
        Tue, 28 May 2024 18:35:25 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f4bcf3a0besm29377225ad.306.2024.05.28.18.35.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 18:35:24 -0700 (PDT)
Message-ID: <18a96f04-bb30-4bd8-82ca-e72f1c954dac@kernel.dk>
Date: Tue, 28 May 2024 19:35:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/3] Improve MSG_RING SINGLE_ISSUER performance
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <3571192b-238b-47a3-948d-1ecff5748c01@gmail.com>
 <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
 <d3d8363e-280d-41f4-94ac-8b7bb0ce16a9@gmail.com>
 <35a9b48d-7269-417b-a312-6a9d637cfd72@kernel.dk>
 <d86d292a-4ef2-41a3-8f54-c3a1ff0caad7@kernel.dk>
 <6ceed652-a81a-485f-8e6e-d653932bb86d@kernel.dk>
Content-Language: en-US
In-Reply-To: <6ceed652-a81a-485f-8e6e-d653932bb86d@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/24 5:04 PM, Jens Axboe wrote:
> On 5/28/24 12:31 PM, Jens Axboe wrote:
>> I suspect a bug in the previous patches, because this is what the
>> forward port looks like. First, for reference, the current results:
> 
> Got it sorted, and pinned sender and receiver on CPUs to avoid the
> variation. It looks like this with the task_work approach that I sent
> out as v1:
> 
> Latencies for: Sender
>     percentiles (nsec):
>      |  1.0000th=[ 2160],  5.0000th=[ 2672], 10.0000th=[ 2768],
>      | 20.0000th=[ 3568], 30.0000th=[ 3568], 40.0000th=[ 3600],
>      | 50.0000th=[ 3600], 60.0000th=[ 3600], 70.0000th=[ 3632],
>      | 80.0000th=[ 3632], 90.0000th=[ 3664], 95.0000th=[ 3696],
>      | 99.0000th=[ 4832], 99.5000th=[15168], 99.9000th=[16192],
>      | 99.9500th=[16320], 99.9900th=[18304]
> Latencies for: Receiver
>     percentiles (nsec):
>      |  1.0000th=[ 1528],  5.0000th=[ 1576], 10.0000th=[ 1656],
>      | 20.0000th=[ 2040], 30.0000th=[ 2064], 40.0000th=[ 2064],
>      | 50.0000th=[ 2064], 60.0000th=[ 2064], 70.0000th=[ 2096],
>      | 80.0000th=[ 2096], 90.0000th=[ 2128], 95.0000th=[ 2160],
>      | 99.0000th=[ 3472], 99.5000th=[14784], 99.9000th=[15168],
>      | 99.9500th=[15424], 99.9900th=[17280]
> 
> and here's the exact same test run on the current patches:
> 
> Latencies for: Sender
>     percentiles (nsec):
>      |  1.0000th=[  362],  5.0000th=[  362], 10.0000th=[  370],
>      | 20.0000th=[  370], 30.0000th=[  370], 40.0000th=[  370],
>      | 50.0000th=[  374], 60.0000th=[  382], 70.0000th=[  382],
>      | 80.0000th=[  382], 90.0000th=[  382], 95.0000th=[  390],
>      | 99.0000th=[  402], 99.5000th=[  430], 99.9000th=[  900],
>      | 99.9500th=[  972], 99.9900th=[ 1432]
> Latencies for: Receiver
>     percentiles (nsec):
>      |  1.0000th=[ 1528],  5.0000th=[ 1544], 10.0000th=[ 1560],
>      | 20.0000th=[ 1576], 30.0000th=[ 1592], 40.0000th=[ 1592],
>      | 50.0000th=[ 1592], 60.0000th=[ 1608], 70.0000th=[ 1608],
>      | 80.0000th=[ 1640], 90.0000th=[ 1672], 95.0000th=[ 1688],
>      | 99.0000th=[ 1848], 99.5000th=[ 2128], 99.9000th=[14272],
>      | 99.9500th=[14784], 99.9900th=[73216]
> 
> I'll try and augment the test app to do proper rated submissions, so I
> can ramp up the rates a bit and see what happens.

And the final one, with the rated sends sorted out. One key observation
is that v1 trails the current edition, it just can't keep up as the rate
is increased. If we cap the rate at at what should be 33K messages per
second, v1 gets ~28K messages and has the following latency profile (for
a 3 second run)

Latencies for: Receiver (msg=83863)
    percentiles (nsec):
     |  1.0000th=[  1208],  5.0000th=[  1336], 10.0000th=[  1400],
     | 20.0000th=[  1768], 30.0000th=[  1912], 40.0000th=[  1976],
     | 50.0000th=[  2040], 60.0000th=[  2160], 70.0000th=[  2256],
     | 80.0000th=[  2480], 90.0000th=[  2736], 95.0000th=[  3024],
     | 99.0000th=[  4080], 99.5000th=[  4896], 99.9000th=[  9664],
     | 99.9500th=[ 17024], 99.9900th=[218112]
Latencies for: Sender (msg=83863)
    percentiles (nsec):
     |  1.0000th=[  1928],  5.0000th=[  2064], 10.0000th=[  2160],
     | 20.0000th=[  2608], 30.0000th=[  2672], 40.0000th=[  2736],
     | 50.0000th=[  2864], 60.0000th=[  2960], 70.0000th=[  3152],
     | 80.0000th=[  3408], 90.0000th=[  4128], 95.0000th=[  4576],
     | 99.0000th=[  5920], 99.5000th=[  6752], 99.9000th=[ 13376],
     | 99.9500th=[ 22912], 99.9900th=[261120]

and the current edition does:

Latencies for: Sender (msg=94488)
    percentiles (nsec):
     |  1.0000th=[  181],  5.0000th=[  191], 10.0000th=[  201],
     | 20.0000th=[  215], 30.0000th=[  225], 40.0000th=[  235],
     | 50.0000th=[  262], 60.0000th=[  306], 70.0000th=[  430],
     | 80.0000th=[ 1004], 90.0000th=[ 2480], 95.0000th=[ 3632],
     | 99.0000th=[ 8096], 99.5000th=[12352], 99.9000th=[18048],
     | 99.9500th=[19584], 99.9900th=[23680]
Latencies for: Receiver (msg=94488)
    percentiles (nsec):
     |  1.0000th=[  342],  5.0000th=[  398], 10.0000th=[  482],
     | 20.0000th=[  652], 30.0000th=[  812], 40.0000th=[  972],
     | 50.0000th=[ 1240], 60.0000th=[ 1640], 70.0000th=[ 1944],
     | 80.0000th=[ 2448], 90.0000th=[ 3248], 95.0000th=[ 5216],
     | 99.0000th=[10304], 99.5000th=[12352], 99.9000th=[18048],
     | 99.9500th=[19840], 99.9900th=[23168]

If we cap it where v1 keeps up, at 13K messages per second, v1 does:

Latencies for: Receiver (msg=38820)
    percentiles (nsec):
     |  1.0000th=[ 1160],  5.0000th=[ 1256], 10.0000th=[ 1352],
     | 20.0000th=[ 1688], 30.0000th=[ 1928], 40.0000th=[ 1976],
     | 50.0000th=[ 2064], 60.0000th=[ 2384], 70.0000th=[ 2480],
     | 80.0000th=[ 2768], 90.0000th=[ 3280], 95.0000th=[ 3472],
     | 99.0000th=[ 4192], 99.5000th=[ 4512], 99.9000th=[ 6624],
     | 99.9500th=[ 8768], 99.9900th=[14272]
Latencies for: Sender (msg=38820)
    percentiles (nsec):
     |  1.0000th=[ 1848],  5.0000th=[ 1928], 10.0000th=[ 2040],
     | 20.0000th=[ 2608], 30.0000th=[ 2640], 40.0000th=[ 2736],
     | 50.0000th=[ 3024], 60.0000th=[ 3120], 70.0000th=[ 3376],
     | 80.0000th=[ 3824], 90.0000th=[ 4512], 95.0000th=[ 4768],
     | 99.0000th=[ 5536], 99.5000th=[ 6048], 99.9000th=[ 9024],
     | 99.9500th=[10304], 99.9900th=[23424]

and v2 does:

Latencies for: Sender (msg=39005)
    percentiles (nsec):
     |  1.0000th=[  191],  5.0000th=[  211], 10.0000th=[  262],
     | 20.0000th=[  342], 30.0000th=[  382], 40.0000th=[  402],
     | 50.0000th=[  450], 60.0000th=[  532], 70.0000th=[ 1080],
     | 80.0000th=[ 1848], 90.0000th=[ 4768], 95.0000th=[10944],
     | 99.0000th=[16512], 99.5000th=[18304], 99.9000th=[22400],
     | 99.9500th=[26496], 99.9900th=[41728]
Latencies for: Receiver (msg=39005)
    percentiles (nsec):
     |  1.0000th=[  410],  5.0000th=[  604], 10.0000th=[  700],
     | 20.0000th=[  900], 30.0000th=[ 1128], 40.0000th=[ 1320],
     | 50.0000th=[ 1672], 60.0000th=[ 2256], 70.0000th=[ 2736],
     | 80.0000th=[ 3760], 90.0000th=[ 5408], 95.0000th=[11072],
     | 99.0000th=[18304], 99.5000th=[20096], 99.9000th=[24704],
     | 99.9500th=[27520], 99.9900th=[35584]

-- 
Jens Axboe


