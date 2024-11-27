Return-Path: <io-uring+bounces-5098-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5990F9DAF18
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 22:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D46D8B20ADC
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F36202F8A;
	Wed, 27 Nov 2024 21:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ezczi3Mt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A4220125F
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 21:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732744290; cv=none; b=MdhgDEEQIUwxaOqteCHL2jLTNh5sFFLX/gTqCkdyUZDG5PSW/ePrQgJ/RyVvUkaTHaZjfB9y5/gfVAKO7HtnekQ83gmigWtFBkcA1MxvYCuenHvVsivZwFkYrFNkEoOqj+GzaN4ZgMXSREy94iZKOv9Fh70wx29/MScrZ59YvjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732744290; c=relaxed/simple;
	bh=H3U8YysZWzN/tyAM+nPTXamfgtOS/lmXkl1zpBKl1E8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=oJoyZVW3Bi13dHDAv0Yp89NQGLTJhqlUNUahJqA45d9+RnTlzzQaGfIeThIP9OZEtoFvELdN3Z228a4KmXfZXmWz2SS8J/nevkvcRWvr6S3lAVMzkjNPQSJo5dQvF2qy6vIN8GWeF2tfVlQadfFFPtzIS+E6tSiZNQK1u9fBKa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ezczi3Mt; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3ea48624a2aso144605b6e.2
        for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 13:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732744288; x=1733349088; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j/fcWLOC2+4XCfTTSTBHDdct2Q1n6+XII+KClLLeN3E=;
        b=Ezczi3MtSnY9CRtRMl5JlCzXJ6AeidwODssH3G+JLX+XqjyvoyquhDzll4Z7iXWB/L
         8b0Kyo2vaF3RI2tA8PUKkjrSuOjT30XaexcBO4noGYKpFqIulFOMgrFyV0611uIwOxwC
         Aw2GS6E3/YlSascrti+Gav3yOtEZO01EttW5BnLntoI8rZJQo37MF5+BEj/b64RNHdnZ
         yEnTPDL3blh39Bt6LhSOdwU9oANcE++kDRj3Etwcoe/PNPZ3wr96/Dq99cRl+tDryxhh
         AtoiOZD4ng5pwgWZBvIzOXOHMcxlKY0bZXRNzWYdiJQMK6p+7SRNmgnoVhrpVCalrYNu
         MTow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732744288; x=1733349088;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j/fcWLOC2+4XCfTTSTBHDdct2Q1n6+XII+KClLLeN3E=;
        b=i9yecdfETJ/f1q7dxzoISgfIHJF5iLV1igpHCSy9QkG+s1XGXezun8/qAYcxLEX8Kk
         eLUImrW6JXJDYHpkqzRjeAe1uJhU/P+ecj54YxwD9mOCNNYRwUADRBNMgYxkwK9NMXvI
         l0ApoSNI5he8Q3AGsRa0T7wTlbevH5r7Ww0BiOcVEFWl21UTD59a4QfWvD63i0yHdHpY
         E2kBg84/YVmlcqE0n4Mtin0hoRGliyIYLd6ohbR1TFRNx2/1Es5y+DVKecEcuhgfJD3e
         VJyk1Wx7tcvRaylMpqSjYrwvn9CiLA91Jrx30q+14CZSREY8+CJ9Jj2OtenP7XisCYDR
         4SJQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/gX1ZgCYvnVVZyXjqqsN+LWpfwMsAV1UaQAZGt70LkJnRK6xYlDe0L3JMxDVah8gRBHVmerBx+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeZIpACmw/5US1rMHGTKuHPiiTSnmpT4NE5m1c7avNOB0LoYU9
	XuSWgXFE46kkq9daFpnq0C7iRlCh32m3uQkDjt5va7klimrl1Bg6ipCIXmJ9k4w=
X-Gm-Gg: ASbGncus47YAZeejlXddTtjWO3f4qOHnSp34CAOGj9LkPw23YeWL+QoVZW501tmVLAX
	LCCeIddgkfT7/Sj8LeFu8tcACHuYnM3LULMPnsn76dWd5FvX+ECjACT34HkGTmmMvYIAnBU2nav
	OHDeBXquRQPg13Nylqu2RoXjKVzW5yWVcgHZ7Pq+FXemLO4W9fXzeL721MSFMKeX3ETU5gHJ9pw
	I9Jpc1pV2FKMcISJusF4e5cTz8o39sJP+1JnayBE0IoTA==
X-Google-Smtp-Source: AGHT+IF0rman/7RZvDkxI7PbRvYPHmH4FJqmkcyhs1FTMa1Nu6qVjXxeLCstpeUpTTnvbauCMB6Xgw==
X-Received: by 2002:a05:6808:f09:b0:3e6:5f3:f0d8 with SMTP id 5614622812f47-3ea6dc25128mr5976319b6e.24.1732744287861;
        Wed, 27 Nov 2024 13:51:27 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3ea4c06a600sm2074355b6e.8.2024.11.27.13.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 13:51:27 -0800 (PST)
Message-ID: <3c24016e-a24c-4b7f-beca-990ef0d91bfe@kernel.dk>
Date: Wed, 27 Nov 2024 14:51:26 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Jann Horn <jannh@google.com>, linux-bcachefs@vger.kernel.org,
 kernel list <linux-kernel@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
 <3ajlmjyqz6aregccuysq3juhxrxy5zzgdrufrfwjfab55cv2aa@oneydwsnucnj>
 <CAG48ez2y+6dJq2ghiMesKjZ38Rm7aHc7hShWJDbBL0Baup-HyQ@mail.gmail.com>
 <k7nnmegjogf4h5ubos7a6c4cveszrvu25g5zunoownil3klpok@jnotdc7q6ic2>
 <4f7e45b6-c237-404a-a4c0-4929fa3f1c4b@kernel.dk>
 <tt4mrwkwh74tc26nkkeaypci74pcmvupqcdljavlimefeitntc@6tit5kojq5ha>
Content-Language: en-US
In-Reply-To: <tt4mrwkwh74tc26nkkeaypci74pcmvupqcdljavlimefeitntc@6tit5kojq5ha>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Wed, Nov 27, 2024 at 2:27?PM Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Wed, Nov 27, 2024 at 02:16:24PM -0700, Jens Axboe wrote:
> > I'd argue the fact that you are using an mm from a different process
> > without grabbing a reference is the wrinkle. I just don't think it's a
> > problem right now, but it could be... aio is tied to the mm because of
> > how it does completions, potentially, and hence needs this exit_aio()
> > hack because of that. aio also doesn't care, because it doesn't care
> > about blocking - it'll happily block during issue.
>
> I'm not trying to debate who's bug it is, I'm just checking if I need to
> backport a security fix.

Not trying to place blame.

> > > Jens, is it really FMODE_NOWAIT that controls whether we can hit this? A
> > > very cursory glance leads me to suspect "no", it seems like this is a
> > > bug if io_uring is allowed on bcachefs at all.
> >
> > I just looked at bcachefs dio writes, which look to be the only case of
> > this. And yes, for writes, if FMODE_NOWAIT isn't set, then io-wq is
> > always involved for the IO.
>
> Ok, sounds like we're in the clear. I already started writing the
> patch, so it'll just be a "now we can turn on FMODE_NOWAIT" instead of
> a bugfix.

That sounds good - and FMODE_NOWAIT will be a good addition. It'll make
RWF_NOWAIT work, and things like io_uring will also work better as it
won't need to needlessly punt to an io-wq worker to complete this IO.

> By the way, did the lifetime issue that was causing umount/remount to
> fail ever get resolved? I've currently got no test coverage for
> io_uring, would be nice to flip that back on.

Nope, I do have an updated branch since then, but it's still sitting
waiting on getting a bit more love. I suspect it'll be done for 6.14.

-- 
Jens Axboe


