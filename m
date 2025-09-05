Return-Path: <io-uring+bounces-9604-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64CB5B4637F
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 21:22:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BDA15A6D7B
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 19:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02AF82741A6;
	Fri,  5 Sep 2025 19:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ek3nPnwE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6803A225A29
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 19:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757100121; cv=none; b=o7l4646I4b0/7ZQg9vrpnD/NdlzpIPJjPiJjjjjtFz2sBNgC0bM+FVG9GlkQ3J56Hsu8d6iJXfA93U5OoJ8Hs/DDFufTxUhkggozMsdxEA0NNTFfgo+WduGQC3sRhU0TUhyFlwghlXl2yCIS2cecaYXNeA+tUIocmY+MxYc3TNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757100121; c=relaxed/simple;
	bh=R6ooe08nC2EWpv3FSCHgeNCtc8UkNLPlvlgfCM1aciE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d5HTLMa5foaiWHc82SsFW8ljyHOSDDJ4sq5PfUno6AWVXRva598xIq6BTdJsPVGRyN4Bhrso+uey9GLS1UWpu5WEkZ/Gkm3v9kk8jyPv9oiN3X945bSGqMwmyK/tWwV5GWpeNnZz0iYs66L+mzYpnkAyOjh6v7UJ8/pQ9XtcSGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ek3nPnwE; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-61d7b2ec241so2961296a12.0
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 12:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757100117; x=1757704917; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TxlnLct1A8sIha5mqHO/QsisosQcW7PWcvbt4ZguHk0=;
        b=Ek3nPnwEjg2FmGWUvEXiEX1GPC6cr2ay+dmIlmQxZPJ5/AUaHivW4RjADVtkodDWum
         40csRzryWElME9xGEu18wByIGJXcTLIU0pRb+GK6Bs9tMxkjAN+wamIiNXjw2+KxaET1
         SDYuTq4bAyXG0QmPDexlPnRQTJaNKRsQ75kWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757100117; x=1757704917;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TxlnLct1A8sIha5mqHO/QsisosQcW7PWcvbt4ZguHk0=;
        b=t+fwJ1OcJrQ+xB1lkWapVObJ887Hsmeuvj1v9Ac3chNazPfgYTGFNHV/XAHO+LyvWZ
         Q8C0OTnk2u1pTJjUAgZQLcxGFmOgQMLkf0eq5+H5rZZYhIV1weIfAykVXfJ+eERuVBF0
         tBhiMlLD0V5IfzPtFQJ6H0h16GdowQYDp6G0smbYdg5nZEWM8ZibJeFM+c9OT+UVIOUt
         8o+S+ZFet8/WcLHmRZZ9MmCigVmA8KiBsbYJz1tY2Ip3jlkE02vBW3Lb+Q5d1LLdo1jN
         LghZ8nCE1m+2atz/PHxlppAUae2nX0RH7LTN3oArzB9eLKF2bphH5c4BgT8c0k/lysi/
         8+Rw==
X-Forwarded-Encrypted: i=1; AJvYcCUxz4gP3IHB5otTRoowotyYJh8+N3w7NYwkZUb+Dl6kPOtpSIMAZM7rcFCiM6Qo/3WNf1G3ZGMRwg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwXOjtOMfeDE85xou517IXGSrihtrMB+IgbWSRv5MtgEnobaNNT
	5ScVOYofEEen6cKvvlKHC7RWuMw1d1z+zY+kgzMKx0lODZoRn6t+IJEknuRmERNAqLGyrZTrS4M
	2i6p9f34=
X-Gm-Gg: ASbGncs+G/eNu5G0hvOdOt0V0rDkzgf9Fwng8M0+l4+2KJlKH4mby3Ynix3HvZTD0ZO
	2bZXUjoY7cNQVHDqF9Yc2hM/+7Sp+wlrNMOGIOApqz1v54URBnp87rx53zaHb7HeuI6lTi+osoT
	NkFTxMHgzoAi89RUIlaStrYby1GZLRcj3aySgcuac7mqMleOeZMnY9c4ZVMmq3AqVmYiGJUdecW
	wRGFMQ8IV6WokjmZr6VrjQbVuh3fvr9HwPhksnvBhw0JIMI00ZYFMFiAZAMRiJ3wovtCtjv8mYc
	GOcON+Mm50Q8+jAaRtW1EOcr1QlkBeKNt2xN0zTMsTqPRz0NttqyDQ65511FOtvEizulYHsNHXP
	JxLD2u2y6EFn7vErPt9hBBDZ9T16v7c0bNaiMLeWHqAgYywuan+/y5K3wmaF4zj4imdR4b2TdSO
	qQi8zIVq9QaHu2uBKXPA==
X-Google-Smtp-Source: AGHT+IFtd5A3dlTIuf79VdsksxGDwNDDfQgE7O1A5yOsbhfQIaui6bRBB1x39ffB/jfuT7clYlAvQQ==
X-Received: by 2002:a17:907:9815:b0:b04:3a69:eba4 with SMTP id a640c23a62f3a-b043a69f41dmr1952995866b.39.1757100117305;
        Fri, 05 Sep 2025 12:21:57 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b04189de5b5sm1426968066b.10.2025.09.05.12.21.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 12:21:56 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b0472bd218bso444690866b.1
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 12:21:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXa3bQdoNdtET8uxlKDPvtNAbcysAzrFS1PH4jn795ZOB4S04lq8c9fT7BW9TE+ByVvb+xPHZKk3w==@vger.kernel.org
X-Received: by 2002:a17:907:c27:b0:afe:63ec:6938 with SMTP id
 a640c23a62f3a-b01d8a308b8mr2375796766b.7.1757100116274; Fri, 05 Sep 2025
 12:21:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com> <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
In-Reply-To: <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Sep 2025 12:21:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgkgSoqMh3CQgj=tvKdEwJhFvr1gtDbK7Givr1bNRZ==w@mail.gmail.com>
X-Gm-Features: Ac12FXygnYtRIH9nr5tXEV1QvaMdVOZ264tcotmz50PfCGumA8novTsiKdvSe8c
Message-ID: <CAHk-=wgkgSoqMh3CQgj=tvKdEwJhFvr1gtDbK7Givr1bNRZ==w@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Sept 2025 at 12:04, Jens Axboe <axboe@kernel.dk> wrote:
>
> What is the hurt here, really, other than you being disappointed there's
> nothing extra in the link?

And just to clarify: the hurt is real. It's not just the
disappointment. It's the wasted effort of following a link and having
to then realize that there's nothing useful there.

Those links *literally* double the effort for me when I try to be
careful about patches.

So the "what's the hurt here" question is WRONG. The cost is real. The
cost is something I've complained about before.

I'm tired of having to complain about this, and I'm really really
tired of wasting my time on links that people have added with
absolutely zero effort and no thinking to back them up.

Yes, it's literally free to you to add this cost. No, *YOU* don't see
the cost, and you think it is helpful. It's not. It's the opposite of
helpful.

So I want commit messages to be relevant and explain what is going on,
and I want them to NOT WASTE MY TIME.

And I also don't want to ignore links that are actually *useful* and
give background information.

Is that really too much to ask for?

                 Linus

