Return-Path: <io-uring+bounces-3679-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 588A699D9EF
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 00:59:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1815628332B
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 22:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 069691D9A51;
	Mon, 14 Oct 2024 22:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YFMHE/P5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CD91D968E
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 22:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728946747; cv=none; b=F4Zee0sGImDtbe16UpebbzJOB2hsufLZ2xphNAlkE+j+c33EEAWGoAOaZOjDUxKorGZr77Zj5zlAqg8ZY0WznYb9EWxlDFyWxkrb0vVoRdHWIIpnPWIqtLFRnuv+X9qZKo11KCZyXnJk4NomeJ2XsBpJcYgOwHObb6ygT15mgHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728946747; c=relaxed/simple;
	bh=kgyxeDiq/TF18phQu3LIBibupFlnc/6lG6nTp6V5Drk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pWXPfjb97yYFXiUBE+iKQGC7FmQSJbDs0ZwGgeodQE2RRW9C6pOZKH8dHCF0BbuSq50Sqkb6HDbCYZUvC70ibjQ3rVM13k0VQ4HQYiYcxXN95l05lPN5LTKqKvMUR9Jqvr1sRQOzAqtYb4CU/KUFnRRGqSht1I47MClfHbA+mSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YFMHE/P5; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4601a471aecso530131cf.1
        for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 15:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728946745; x=1729551545; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jigxX/V8cRx+fhdhBLrAQEYbLCMTieORk5qB+lhWQw=;
        b=YFMHE/P52lKiTKNOXUjWd+lqYguSzDMeVQte0zantUUeCl5Yx/m4kSkVf79bh0Bkd+
         1hShER09gnYbxZzQnr2fIdhIIKxUMpKoYAUXc1WXr9EL1FH4hdCZbwJ/jc5iK8oBF7Ya
         ir0b1+5y4FYlnTPOpCgNzhvEvzA2I7BpmE2zHA72cgawXSybzOJD2cuy8wvgAPZ2ilYe
         xTPrro/I6EqO3fB/m2Ry5gMehWkPrj1Wj9hsSCA6z7Rj5X4LQqgy1YVylni3ZINPKWfw
         tW9uq9xRpyCGheYx7iI2MZHMSWEUMiMHwVlDmY1ne+SBc1iEWsdRyMW/E9CjAjeraB43
         BBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728946745; x=1729551545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1jigxX/V8cRx+fhdhBLrAQEYbLCMTieORk5qB+lhWQw=;
        b=VvUIgBaTQSFOgbnBd3JrhKbTvb0/799lGVFHQze9/n+c6xiXI9b1zt6oQxIXMOWbBN
         5njdRQrHyenl9TOjO0SeuF1N9pEBQvcgdgyPf5zD7Tdn1ZANxoJGIM1WXEPa5NKhcndR
         p4QVwTLusGoOVg5SBhLbOR+ccfCsAlmp6IHAikRhFXx3l/mKCVjDMCKdpyjFFtdLgI8v
         sJZ4lRsqlMkKlfhqlA0z+lAiGgwjMaliCUe+eLlOW05kN6fMX9snXQPaJEPv2QT8J7hu
         ag3LPa5XjaDPXUIOm78uiDGTPVMHwk6AZC9zmuS3cI2mKHfta4daR5qT5YBtBSDWu3LB
         BoaQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7QOjRKtZaZMIh7xAbOCblqDXGGWcyhyu6ItaA33HI0xnYlGRok6ytTXLzqq5JBeyIO848y+nOLw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyun4eI9ByxoRcZaDacSeWfaFefmFTGD5rFcVl7XpUM8vq786ZX
	WjylsOFaur7phoQiJBmNamcC9oY04JGzxRe3TrDT3rzA5+S5ltOH2I6l8xJg0D/9h8Vh3DRWjgb
	JeXtS0rCp2u7+Z/hto5Z/7ITHulx6/vExwc8U
X-Google-Smtp-Source: AGHT+IEoIx7F4bjtbUEULIjiw+M1oASHOtYx8yzJC1dGrDni6q/NIslrip9C6AI4B4Zq8cHmSWZHu8NyzVgr4DflpuM=
X-Received: by 2002:a05:622a:758f:b0:460:371b:bfd9 with SMTP id
 d75a77b69052e-46059bf49ddmr5870781cf.5.1728946744923; Mon, 14 Oct 2024
 15:59:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-7-dw@davidwei.uk>
 <CAHS8izPFp_Q1OngcwZDQeo=YD+nnA9vyVqhuaT--+uREEkfujQ@mail.gmail.com>
 <9f1897b3-0cea-4822-8e33-a4cab278b2ac@gmail.com> <CAHS8izOxsLc82jX=b3cwEctASerQabKR=Kqqio2Rs7hVkDHL4A@mail.gmail.com>
 <5d7925ed-91bf-4c78-8b70-598ae9ab3885@davidwei.uk>
In-Reply-To: <5d7925ed-91bf-4c78-8b70-598ae9ab3885@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 15 Oct 2024 01:58:52 +0300
Message-ID: <CAHS8izNt8pfBwGnRNWphN4vJJ=1yJX=++-RmGVHrVOvy59=13Q@mail.gmail.com>
Subject: Re: [PATCH v1 06/15] net: page_pool: add ->scrub mem provider callback
To: David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 13, 2024 at 8:25=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> On 2024-10-10 10:54, Mina Almasry wrote:
> > On Wed, Oct 9, 2024 at 2:58=E2=80=AFPM Pavel Begunkov <asml.silence@gma=
il.com> wrote:
> >>
> >> On 10/9/24 22:00, Mina Almasry wrote:
> >>> On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> wro=
te:
> >>>>
> >>>> From: Pavel Begunkov <asml.silence@gmail.com>
> >>>>
> >>>> page pool is now waiting for all ppiovs to return before destroying
> >>>> itself, and for that to happen the memory provider might need to pus=
h
> >>>> some buffers, flush caches and so on.
> >>>>
> >>>> todo: we'll try to get by without it before the final release
> >>>>
> >>>
> >>> Is the intention to drop this todo and stick with this patch, or to
> >>> move ahead with this patch?
> >>
> >> Heh, I overlooked this todo. The plan is to actually leave it
> >> as is, it's by far the simplest way and doesn't really gets
> >> into anyone's way as it's a slow path.
> >>
> >>> To be honest, I think I read in a follow up patch that you want to
> >>> unref all the memory on page_pool_destory, which is not how the
> >>> page_pool is used today. Tdoay page_pool_destroy does not reclaim
> >>> memory. Changing that may be OK.
> >>
> >> It doesn't because it can't (not breaking anything), which is a
> >> problem as the page pool might never get destroyed. io_uring
> >> doesn't change that, a buffer can't be reclaimed while anything
> >> in the kernel stack holds it. It's only when it's given to the
> >> user we can force it back out of there.
>
> The page pool will definitely be destroyed, the call to
> netdev_rx_queue_restart() with mp_ops/mp_priv set to null and netdev
> core will ensure that.
>
> >>
> >> And it has to happen one way or another, we can't trust the
> >> user to put buffers back, it's just devmem does that by temporarily
> >> attaching the lifetime of such buffers to a socket.
> >>
> >
> > (noob question) does io_uring not have a socket equivalent that you
> > can tie the lifetime of the buffers to? I'm thinking there must be
> > one, because in your patches IIRC you have the fill queues and the
> > memory you bind from the userspace, there should be something that
> > tells you that the userspace has exited/crashed and it's time to now
> > destroy the fill queue and unbind the memory, right?
> >
> > I'm thinking you may want to bind the lifetime of the buffers to that,
> > instead of the lifetime of the pool. The pool will not be destroyed
> > until the next driver/reset reconfiguration happens, right? That could
> > be long long after the userspace has stopped using the memory.
> >
>
> Yes, there are io_uring objects e.g. interface queue that hold
> everything together. IIRC page pool destroy doesn't unref but it waits
> for all pages that are handed out to skbs to be returned. So for us,
> below might work:
>
> 1. Call netdev_rx_queue_restart() which allocates a new pp for the rx
>    queue and tries to free the old pp
> 2. At this point we're guaranteed that any packets hitting this rx queue
>    will not go to user pages from our memory provider
> 3. Assume userspace is gone (either crash or gracefully terminating),
>    unref the uref for all pages, same as what scrub() is doing today
> 4. Any pages that are still in skb frags will get freed when the sockets
>    etc are closed
> 5. Rely on the pp delay release to eventually terminate and clean up
>
> Let me know what you think Pavel.

Something roughly along those lines sounds more reasonable to me.

The critical point is as I said above, if you free the memory only
when the pp is destroyed, then the memory lives from 1 io_uring ZC
instance to the next. The next instance will see a reduced address
space because the previously destroyed io_uring ZC connection did not
free the memory. You could have users in production opening thousands
of io_uring ZC connections between rxq resets, and not cleaning up
those connections. In that case I think eventually they'll run out of
memory as the memory leaks until it's cleaned up with a pp destroy
(driver reset?).


--=20
Thanks,
Mina

