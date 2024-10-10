Return-Path: <io-uring+bounces-3565-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E883998EF5
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 19:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 013CC283BA1
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 17:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9481619CD07;
	Thu, 10 Oct 2024 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h1mbn/i9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DA919D087
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728582861; cv=none; b=W7+GOBNBU2SGakVeTsqIQQ0DKQQXo3uNkONq4E3rBfyvbE4ageI0Sg4KmGo0PDaVqTt6+FSzWCzEf0iuw8mk8k5K0CO4vS+ecVnfktx3QJn0AgWhSPX7fJpK9yALIphRrHbAuw04MEJS8p3tLhzcLNABHCguoU5PdKBEAhQon0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728582861; c=relaxed/simple;
	bh=ZW9HmnHolJg/LLgpuCO5NuvmDeeRr46LFSiQHdTmiI0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XZiJczM/KAAjb79Dh7M1I+8M5ZZU4dAAAMd2L2wisYKV2FddYhsSvbD889Z0EigZlYW6IHlZLpPuuXcaizlCXdZzSKTqX99ZMz2P1z/yw02+pzFeWFM3GFtimtobH2UGMBRtFG2irfEz7xGoreo1Msgw8YZy/yfJp5ilMecNZRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h1mbn/i9; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-460395fb1acso32231cf.0
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 10:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728582859; x=1729187659; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZW9HmnHolJg/LLgpuCO5NuvmDeeRr46LFSiQHdTmiI0=;
        b=h1mbn/i9g/VXr2kQi0u52EAm79XWv7ovua9Er4Mmmrs7rXP6dlBITzZ4hhk0OYd/Xt
         dUJ6jYMl495X3gdt9SwCGjJC51cWrb1dCSES4a6Ab1GC0u0Iyh9ateJs8+Y6FTALNMGN
         pFHuCe5fSbal4x0q2mknn8SZQSmp5Ia5KnO3z670BxDRaW6xYHXcz3z28G6RuhGrz1kn
         C+L/LGHBLCJwIatKlzWbfG+8H48qgGnJ9gw38kKofX2DR+bH7A8CrdOUr+neZ9idX3eZ
         UyzHmMsDVXx2g7hvVckVLk3cHkJR0ltEtT6Ag5oogz6kwfiqVX0mrW1GnGl38PpWvcb7
         Bbsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728582859; x=1729187659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZW9HmnHolJg/LLgpuCO5NuvmDeeRr46LFSiQHdTmiI0=;
        b=ZZL8uw4NoE3uZMNcodCGv27owXe5eDgc8NYoSZa0XU6wpGS+nV9uEGCAIXQr6nM4ys
         K+84OPWVk27d6eTj9FsZNQ4owUMGNjdC8VpQmLCvd8RHHmMISbtJ5+brxcqQUyaXHRbY
         rbwp45L+AYaWOUqhUPXnfyKYBOjr5mS6sSJI2PEFM0UEgrILvLmbOeiHw5/H+3y8oQCb
         M3o9s4Q/R7KSsOLiDH3b56O4CGdYXsuac0WpD+K8n1Aablcw/XGo25A+fsMW8i2jGD3i
         W6zdUd6Vgr6p0cFA9U69iPSqMIWiFQaoaY+WgLWV6si/8mAEQgZUQf5NJfBrwS2T3wa6
         mWwg==
X-Forwarded-Encrypted: i=1; AJvYcCW/8mEZLJZs1GmAH6lTcVMPmcze00bmSrUfAExlEP3tWSXHqgDwrprU17DqXpGlE3HQeBpIspifcQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4u7gDozp7qBdHQ9IoJZMSZLQo4sn4dswl6/vjb+KhMAXo7wCd
	JpTT44RuIgNkIP0OHtSCCzMkYiTcl47LLMlZq8D9qiETz0AMB80buWbyTvmi0zNiM5WGm9Si9H8
	LZkHaKOvw5HZK0FiJewprWtQ1wqK6QzjdusIm
X-Google-Smtp-Source: AGHT+IFoFOh5E6DMEbh1pCja/UyuJ4Nb4Q2wewSDJNAMu+Qapmq9K1pBPstKAJMuxmH2Et0n0YgSgpq3NSHvP8MHfdk=
X-Received: by 2002:a05:622a:4e04:b0:458:14dd:108b with SMTP id
 d75a77b69052e-4604b132706mr26531cf.13.1728582858210; Thu, 10 Oct 2024
 10:54:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-7-dw@davidwei.uk>
 <CAHS8izPFp_Q1OngcwZDQeo=YD+nnA9vyVqhuaT--+uREEkfujQ@mail.gmail.com> <9f1897b3-0cea-4822-8e33-a4cab278b2ac@gmail.com>
In-Reply-To: <9f1897b3-0cea-4822-8e33-a4cab278b2ac@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 10 Oct 2024 10:54:04 -0700
Message-ID: <CAHS8izOxsLc82jX=b3cwEctASerQabKR=Kqqio2Rs7hVkDHL4A@mail.gmail.com>
Subject: Re: [PATCH v1 06/15] net: page_pool: add ->scrub mem provider callback
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 9, 2024 at 2:58=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 10/9/24 22:00, Mina Almasry wrote:
> > On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> wrote=
:
> >>
> >> From: Pavel Begunkov <asml.silence@gmail.com>
> >>
> >> page pool is now waiting for all ppiovs to return before destroying
> >> itself, and for that to happen the memory provider might need to push
> >> some buffers, flush caches and so on.
> >>
> >> todo: we'll try to get by without it before the final release
> >>
> >
> > Is the intention to drop this todo and stick with this patch, or to
> > move ahead with this patch?
>
> Heh, I overlooked this todo. The plan is to actually leave it
> as is, it's by far the simplest way and doesn't really gets
> into anyone's way as it's a slow path.
>
> > To be honest, I think I read in a follow up patch that you want to
> > unref all the memory on page_pool_destory, which is not how the
> > page_pool is used today. Tdoay page_pool_destroy does not reclaim
> > memory. Changing that may be OK.
>
> It doesn't because it can't (not breaking anything), which is a
> problem as the page pool might never get destroyed. io_uring
> doesn't change that, a buffer can't be reclaimed while anything
> in the kernel stack holds it. It's only when it's given to the
> user we can force it back out of there.
>
> And it has to happen one way or another, we can't trust the
> user to put buffers back, it's just devmem does that by temporarily
> attaching the lifetime of such buffers to a socket.
>

(noob question) does io_uring not have a socket equivalent that you
can tie the lifetime of the buffers to? I'm thinking there must be
one, because in your patches IIRC you have the fill queues and the
memory you bind from the userspace, there should be something that
tells you that the userspace has exited/crashed and it's time to now
destroy the fill queue and unbind the memory, right?

I'm thinking you may want to bind the lifetime of the buffers to that,
instead of the lifetime of the pool. The pool will not be destroyed
until the next driver/reset reconfiguration happens, right? That could
be long long after the userspace has stopped using the memory.

--=20
Thanks,
Mina

