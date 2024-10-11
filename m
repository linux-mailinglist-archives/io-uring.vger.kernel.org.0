Return-Path: <io-uring+bounces-3578-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E6A9997FC
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 02:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C94881F23D91
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 00:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE87D81720;
	Fri, 11 Oct 2024 00:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0gMQQ8Kg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334BB10A1F
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 00:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606770; cv=none; b=SkDdr8yg0/+zWETh4DnG0tA4Yro/G0wH5AWYckREs4YXly1AQNYaMm82GWNDA1SuSYC3+DUAMmKzuhi+egSQ+uagjqGtv7q7NM9o1RYxAQxpIk1vqBWM5ng8CBMSsmG8H4Q9Nx0zOlDcjbPsZbaCHSoY0Icq9WgRcTZI8gfU7ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606770; c=relaxed/simple;
	bh=UEm4w1+/BayVnYEyIYhV9w3Mjz/x786XWJdv52Ozd44=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=caftJwgv8pKTA8vzfyVVa6JOFQp7lhWcI03liBAij/zJB+AmjJe+RBf2C0yh33brKmNPjgPnYjCvZzdWN/Y8oF2T41USwCiwybLr1HndD3kIfTGjddWqXPy+IbW7KjooIJoc4Hklbqm82jS8j3tB+dNsArr6Z4hBfaegGf0xOpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0gMQQ8Kg; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4601a471aecso77601cf.1
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 17:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728606768; x=1729211568; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UEm4w1+/BayVnYEyIYhV9w3Mjz/x786XWJdv52Ozd44=;
        b=0gMQQ8KgXrQRX85BoMveORkRYFrWllAqf5g7PNXYyDxJ4ftIB9hWMKDc8Japsoehn3
         2Wxm2XXuGzUfSrMxwSbZ2Jh/paBp92LRjI5xOEDydzjA3m16PsCAf/R8BX3AqThSxrXK
         qnZOC6moVn5kylGayrcnebFuDjiOYvf+9vvEy6SHxWstJ3YCggyi373VrKkJNIaT/kl4
         lJHVcuh43A3DZM4fald8MR0obCCVDh780SwzglI19jtA0rhcAN419z7Zp6f6aybVJu4m
         wPUXed649J9iMNWBH5GmGLXvWG9ALyo3M1D/CTxdTxd296DR5Z+9Cao+rOoGB3mZxooR
         ZDTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728606768; x=1729211568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UEm4w1+/BayVnYEyIYhV9w3Mjz/x786XWJdv52Ozd44=;
        b=mWRpSPWq69tyjnYsigQ+SGmevOI4Ap3ZvLV3x7wxWnADBfLIrkpEVHyiBrZu1dOmeb
         Hoa9kVB5xXlO2lGDyrIHxAKqsjzaLfDNOP2mdNki9vaAxe3RZjnGLNVmJAG5UYPow87B
         Rt46YT8CQ/9lI0DljTYO27s5hNzCUZZJxxVevQBpWuag7pxC9K7NPiDU5rnbxrioGazR
         Xd6/McrjnSy6gC6s2TxthndTaq76m3x5X3PFb4zSxD1VrcltpWvV+L/6itjoY2iFo1CF
         qZCrCO1mELRyrCfrI/NXrFPSmPCHlwRe8NlrY8x254DGQqOVAK9FJf+T6mph/YYznkSW
         q3hA==
X-Forwarded-Encrypted: i=1; AJvYcCXMvFsPL9t/Zdtp3XuMCEAoGrOBXAivwsjjquqzyRoL/ptfaC1xQO7PGfX2qg7FkWVbJGcK0egyzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxMJK8/E3HkYB6npZk88I8psZtLDv62+X02rEfdolg/MI7SOmfM
	uB5yznxgq6EM7QzV4R+5NpYo1UCp/9DduumoP+8nLbNOLbA0rHKTT3PtASOObMWyD+yGzGE5wWg
	8Fx6G0uQnnolffe1NA5bI+yLnigVAZFdJ6X1T
X-Google-Smtp-Source: AGHT+IFa3X3kXCvbMNV8e/CL1FECdovrHzWeLXI7K0gOLD45vSyGS+b4KWyH5KzMfNcOFtFTiBBiLpw+Z9LcZ01I2vQ=
X-Received: by 2002:a05:622a:7b8a:b0:460:463d:78dd with SMTP id
 d75a77b69052e-4604ac30a33mr1830201cf.4.1728606767741; Thu, 10 Oct 2024
 17:32:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-12-dw@davidwei.uk>
 <CAHS8izO-=ugX7S11dTr5cXp11V+L-gquvwBLQko8hW4AP9vg6g@mail.gmail.com>
 <94a22079-0858-473c-b07f-89343d9ba845@gmail.com> <CAHS8izPjHv_J8=Hz6xZmfa857st+zyA7MLSe+gCJTdZewPOmEw@mail.gmail.com>
 <f89c65da-197a-42d9-b78a-507951484759@gmail.com> <CAHS8izMrPuQNvwGwAUjh7GAY-CoC81rc5BD1ZMmy-nNds3xDgA@mail.gmail.com>
 <096387ce-64f0-402f-a5d2-6b51653f9539@gmail.com>
In-Reply-To: <096387ce-64f0-402f-a5d2-6b51653f9539@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 10 Oct 2024 17:32:34 -0700
Message-ID: <CAHS8izMi-yrCRx=VzhBH100MgxCpmQSNsqOLZ9efV+mFeS_Hnw@mail.gmail.com>
Subject: Re: [PATCH v1 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2024 at 2:22=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> > page_pool. To make matters worse, the bypass is only there if the
> > netmems are returned from io_uring, and not bypassed when the netmems
> > are returned from driver/tcp stack. I'm guessing if you reused the
> > page_pool recycling in the io_uring return path then it would remove
> > the need for your provider to implement its own recycling for the
> > io_uring return case.
> >
> > Is letting providers bypass and override the page_pool's recycling in
> > some code paths OK? IMO, no. A maintainer will make the judgement call
>
> Mina, frankly, that's nonsense. If we extend the same logic,
> devmem overrides page allocation rules with callbacks, devmem
> overrides and violates page pool buffer lifetimes by extending
> it to user space, devmem violates and overrides the page pool
> object lifetime by binding buffers to sockets. And all of it
> I'd rather name extends and enhances to fit in the devmem use
> case.
>
> > and speak authoritatively here and I will follow, but I do think it's
> > a (much) worse design.
>
> Sure, I have a completely opposite opinion, that's a much
> better approach than returning through a syscall, but I will
> agree with you that ultimately the maintainers will say if
> that's acceptable for the networking or not.
>

Right, I'm not suggesting that you return the pages through a syscall.
That will add syscall overhead when it's better not to have that
especially in io_uring context. Devmem TCP needed a syscall because I
couldn't figure out a non-syscall way with sockets for the userspace
to tell the kernel that it's done with some netmems. You do not need
to follow that at all. Sorry if I made it seem like so.

However, I'm suggesting that when io_uring figures out that the
userspace is done with a netmem, that you feed that netmem back to the
pp, and utilize the pp's recycling, rather than adding your own
recycling in the provider.

From your commit message:

"we extend the lifetime by recycling buffers only after the user space
acknowledges that it's done processing the data via the refill queue"

It seems to me that you get some signal from the userspace that data
is ready to be reuse via that refill queue (whatever it is, very
sorry, I'm not that familiar with io_uring). My suggestion here is
when the userspace tells you that a netmem is ready for reuse (however
it does that), that you feed that page back to the pp via something
like napi_pp_put_page() or page_pool_put_page_bulk() if that makes
sense to you. FWIW I'm trying to look through your code to understand
what that refill queue is and where - if anywhere - it may be possible
to feed pages back to the pp, rather than directly to the provider.

--=20
Thanks,
Mina

