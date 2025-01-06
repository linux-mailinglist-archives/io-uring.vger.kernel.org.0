Return-Path: <io-uring+bounces-5691-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90240A03281
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 23:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 776367A2950
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 22:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F8050285;
	Mon,  6 Jan 2025 22:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZFPItG5M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1CEDDBC
	for <io-uring@vger.kernel.org>; Mon,  6 Jan 2025 22:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736201883; cv=none; b=ASnA7PYwdOJfFiZZsmAjOgDY6ql+D7GIBCL8O6pde4WyDUmRvZyMRC5ZqeLOume5ugbupbzYU0djd6Vpr+tYmWnPMvB7JZebKFQqoZnYNVpCPH03ab0bDeagqricTXLFcjUg2ETx63rGGW4vVjZ8wuBNOhNtEGN5hvWe5WTw8M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736201883; c=relaxed/simple;
	bh=gJE1od7XIRbhji9v6DeiF0Ef9teXeHffiWstwclel+I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hyu35AD6MOCJK/gmdXeQlPwwd2iM/jjQlK345p0/dxpX4th/vl1ZMo67f6qH1Roca/he3GHvUQ1mZJ7s0aS1YEXGQKdHBBeA0kY9Web9ZtpYr7hvwC29fE8cXHTogpJc07pYri+lAAPn3eektWHHsGBKgrgmfu6HwvyaKIxGSg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZFPItG5M; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-467abce2ef9so73251cf.0
        for <io-uring@vger.kernel.org>; Mon, 06 Jan 2025 14:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736201881; x=1736806681; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gJE1od7XIRbhji9v6DeiF0Ef9teXeHffiWstwclel+I=;
        b=ZFPItG5MpUK0AoWOyid7imAK6LTGpudLQp7vB5KSkqpct0mRbKJI5hYslhXmxvOqoL
         qug09W1CTdcSNmHTivjnz1hLzlQQGIQ1jZpe6RaYMyn2qwQ5F5EEY9bMkguP4ou7pLOj
         K/XpC7xWJ5STMhWln6EapEGJ2V3ijMW3GEGUHUunlxMemlHTBMx3Vkxd13tYK8wwY0mt
         Pv7XyhA2eF5bTP/x0d8HUHHlI01XKYqtwO3+4yJoe4Q1ixH4zelLgbCE4NmPnoZY+nW2
         acg9O/i82lyFBvmfRXzGqZeprvdP033pwQRpKyEUZLHUg7VOrjlTFfY7LHmS5IBVhC3S
         4HTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736201881; x=1736806681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gJE1od7XIRbhji9v6DeiF0Ef9teXeHffiWstwclel+I=;
        b=etwkFpXI1ZiswYMP6w44Tt8oDjfTtLj5IjLeyaT8asRCDqiNCpDe7YMdRrYeLdytDj
         tBullBF5Eyf1OEegtOV+zKOfBZlcD0fYFQz69fZCJC7yN9Mq8HpI70H0jjd6le/OBCFB
         cXNavWnyq69pt981qKPEBIFqlOpuCSVGMDPzeUAoibt5H5pIbq3cIoH1GSl5/dVjJfkY
         eDR7fh9Lbw5e19GY0wPBTLFP03d//dao4N0npBTDrj4hDjm0PaOIcN33qJfKb1tu9tCE
         3KwwvSCNvKS356CVRDN/Y1psU2dGzbRm2/F4si3wdllOJj1ExX7D4tB2OqelbZgxI7qH
         H4KQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQWGFe7kzdrDbfAWq3UNPbitNlxZWsBwAf4tVA2DgAwDukZg4U+Q/rAjV7Yh4GdXwZGSIncyItCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyhdHt0ZayFRQoBWcdnw0sn3neeYjNpcKch22UnZvfZM4qOxJeZ
	EXili26pINETU7Hy+6PCRUl9FD/dHIZRlmo8+kzUQV72ovRSkzuwS1kLbbwVtE0NI9FGB/HsoVO
	I8r93LikGsWUUwacMqKoi6724kNMwZrT1iR31
X-Gm-Gg: ASbGncsvpyTWPMzsGP5mcfoZM0vtam2iOBkuAvpOB7CpVgeO+xG9J8pcJ2C6R5vK8C0
	Tk3ertG7BjmTZY5Ug+YZ+CxJisMUJy914KBenKEc5R7Hewj6GLxkeBzGLPBoq7Ut4nbQk
X-Google-Smtp-Source: AGHT+IEnRTy+2atHXl0iAzQt76MhzrYXtK3i4aJK/5JKKY6TwKwKtZqN9PHJ91UWqJEZuwln1K2bthHVvGEGqGBYLmo=
X-Received: by 2002:a05:622a:50d:b0:467:5fea:d4c4 with SMTP id
 d75a77b69052e-46b3c827e44mr179971cf.27.1736201881143; Mon, 06 Jan 2025
 14:18:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241218003748.796939-1-dw@davidwei.uk> <20241218003748.796939-9-dw@davidwei.uk>
 <20241220143158.11585b2d@kernel.org> <99969285-e3f9-4ec8-8caf-f29ae75eb814@gmail.com>
 <20241220182304.59753594@kernel.org> <bcf5a9e8-5014-44cc-85a0-2974e3039cb6@gmail.com>
In-Reply-To: <bcf5a9e8-5014-44cc-85a0-2974e3039cb6@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 6 Jan 2025 14:17:49 -0800
Message-ID: <CAHS8izOb59+Z4phe=nJNVOTjOy2HByuh4N-RBgJd5dvhLC9F0A@mail.gmail.com>
Subject: Re: [PATCH net-next v9 08/20] net: expose page_pool_{set,clear}_pp_info
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 2, 2025 at 8:20=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 12/21/24 02:23, Jakub Kicinski wrote:
> > On Sat, 21 Dec 2024 01:07:44 +0000 Pavel Begunkov wrote:
> >>>> Memory providers need to set page pool to its net_iovs on allocation=
, so
> >>>> expose page_pool_{set,clear}_pp_info to providers outside net/.
> >>>
> >>> I'd really rather not expose such low level functions in a header
> >>> included by every single user of the page pool API.
> >>
> >> Are you fine if it's exposed in a new header file?
> >
> > I guess.
> >
> > I'm uncomfortable with the "outside net/" phrasing of the commit
> > message. Nothing outside net should used this stuff. Next we'll have
> > a four letter subsystem abusing it and claiming that it's in a header
> > so it's a public.
>
> By net/ I purely meant the folder, even though it also dictates
> the available API. io_uring is outside, having some glue API
> between them is the only way I can think of, even if it looks
> different from the current series.
>
> Since there are strong opinions would make sense to shove it into
> a new file and name helpers more appropriately, like net_mp_*.
>

I guess I'm a bit sorry here because I think I suggested this
approach. I think the root of the issue is that the io_uring memory
provider (and future mps) need to set_pp_info/clear_pp_info the
netmems. dmabuf mp has no issue because it's defined under net/core so
it can easily include net/core/page_pool_priv.h.

I guess more options I see here are:

1. move the io_uring mp to somewhere under net/core. Moving only the
mp should be sufficient here I think.

2. Do some mp refactor such that the mp gives the page_pool the
netmems but the page_pool is responsible for
set_pp_info/clear_pp_info.

3. Revert back to earlier versions of the code where page_pool.c
exposed a helper that did all the memory processing. I had pushed back
against that version of the code because the helper seemed like
io_uring mp specific code masquerading as a generic helper that wasn't
very reusable :shrug:

For what little it's worth I'm having trouble imagining how
set_pp_info/clear_pp_info can be abused if exposed, so this approach
is fine by me, but I'm probably missing something if there is huge
concern about this.

--=20
Thanks,
Mina

