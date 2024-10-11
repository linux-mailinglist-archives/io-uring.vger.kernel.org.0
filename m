Return-Path: <io-uring+bounces-3613-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B50199AEA1
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 00:25:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8643DB23DC3
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 22:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDDF1D1E95;
	Fri, 11 Oct 2024 22:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D2krYZPa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66AD1D1E79
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 22:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728685524; cv=none; b=ezMJthcEOMc88AyYsxCR91hCNQHXc4lrp8EFXi/P6hZaln50+ez0v+EMHAHRaJnHUzmHyKYdf430RaGiIdCqdjHCw44Ugh1E9LvOovFpKHPGLxxdrCK9jT4ru75PbZYpkt5J7bItMq5f8lGn9XYBBhTUy4ms0tMWWonSpeXvfEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728685524; c=relaxed/simple;
	bh=w+c2SiNGG+gLk+w9NxyvDJ39A6vf4qDArBdQMZWltIQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jZ4Fvtkm5mk3ctqXm53wTYNM19CC17oUkX+4ZN6hHgSfHn88rUpsIbanLN+YmOB7NDQNc4qxQWmq+nRRmktpKjC62ezFvqDt7bLJGZJJeOYltPsNmm2QNJmKo9t8bBiSl6c1S3PLxZ6ygj2ixr1WGFk3k77U18VzdhP9nI/aJkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D2krYZPa; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4603d3e0547so78241cf.0
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 15:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728685522; x=1729290322; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+h1NaO52L3keADit4L5nzUma14WANm1zayjXQh4SvHQ=;
        b=D2krYZPagzumVze09YQsC6N1fBm8AgPYtRwsBKHQClvWv4hEDGl+vNaGdnIT+SXB0A
         c5xECfR9HphUh4wZPjBEkAxvaIpIRiwSbnoCwdRE4mmjUrayCpsu/pZH00HW6kL9bZnI
         +JQRVzpxdvxGdAL6a4pRgegFvWEd3OPWlgJVE01dpvCp4IcP68cgM3ZFBpnxpX7oO0ml
         yrjPXTqupKuayqviHyw6q2xr4Hfn/r51KBB/o9rRvap+pR/tkWwPODawDR1d4bU5apFO
         KAGADpMtFvXqBJq4wncL98yYrehsQZgrbQOrQCVjmp4Rmr1g8l/cbFQh4tasdib+OGMq
         kbww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728685522; x=1729290322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+h1NaO52L3keADit4L5nzUma14WANm1zayjXQh4SvHQ=;
        b=U6XD729NfjBumYumYwBNZxwyTesa8emmxWIdYjfF0RZFZkA4tHctSUTOCFsYJdd4WJ
         bxAE5HFHdHNBZL9QPD3Jb/7JfvK92gtzrxWsQ2y+H1/VRHFL3K1HatCIpNTEWVayd+le
         IsbCOFjSxwREPXH/dIbC5R40tUbZaOoyDiCQDh4o6zdL05rk49V9HjBD43aoN7m1TSVp
         8ePKCLWYD0ATNCIyrO5OEm4fhNkhEbd8KTIpboEcB3K8gA90y9yXxrSe76RT9FZH0QWh
         /ttFu/m7x9rTnDi4h0qyUo4DA0yPUUfmlNdh+zQELttJPLqXf6m06Hcm2doWx+dRdtT+
         ByuA==
X-Forwarded-Encrypted: i=1; AJvYcCVP8EWdM6qcl89Ng1hEykJQkXX5WsoFR5SQCw1MQKdPtkVXZ1D+CF7wFWsKuNphNvf141N4sOm94Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YygYzzPLqVo3z8iEO2vgGeCaIZwbq1ARbbi8Tb7dlY8ri+WLu9F
	8CC+BfOsD3wMBRdRyclsR/lAmDLXciMwAfSU+ePOK/4pMd03ALWd9t/RzYGLnsV7WRI2i/q60a5
	wcSAHnB07XnRci/ClkjMQiI1W4FFdSi246LBH
X-Google-Smtp-Source: AGHT+IENA48OF10aYR6nuRZ+tX1ZxiXrHm2fXSiVlqt36ndGljZvf0/XxUlhuguOH+iK73QV9cNSMl03PeEGVd4H0uY=
X-Received: by 2002:ac8:648a:0:b0:460:491e:d2a2 with SMTP id
 d75a77b69052e-46059c4a1f7mr310371cf.17.1728685521286; Fri, 11 Oct 2024
 15:25:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-4-dw@davidwei.uk>
 <ZwVT8AnAq_uERzvB@mini-arch> <ade753dd-caab-4151-af30-39de9080f69b@gmail.com>
 <ZwavJuVI-6d9ZSuh@mini-arch> <b2aa16ac-a5fe-4bab-a047-8f38086f4d43@davidwei.uk>
 <7d321d9e-48bb-4e5f-bca5-6a6c940e3a9a@gmail.com>
In-Reply-To: <7d321d9e-48bb-4e5f-bca5-6a6c940e3a9a@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 11 Oct 2024 15:25:08 -0700
Message-ID: <CAHS8izM4AVsB5+H4p05D_m-cwO5TqHfn28XfNUM-rDAO5=BTew@mail.gmail.com>
Subject: Re: [PATCH v1 03/15] net: generalise net_iov chunk owners
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, Stanislav Fomichev <stfomichev@gmail.com>, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2024 at 3:02=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 10/11/24 19:44, David Wei wrote:
> > On 2024-10-09 09:28, Stanislav Fomichev wrote:
> >> On 10/08, Pavel Begunkov wrote:
> >>> On 10/8/24 16:46, Stanislav Fomichev wrote:
> >>>> On 10/07, David Wei wrote:
> >>>>> From: Pavel Begunkov <asml.silence@gmail.com>
> >>>>>
> >>>>> Currently net_iov stores a pointer to struct dmabuf_genpool_chunk_o=
wner,
> >>>>> which serves as a useful abstraction to share data and provide a
> >>>>> context. However, it's too devmem specific, and we want to reuse it=
 for
> >>>>> other memory providers, and for that we need to decouple net_iov fr=
om
> >>>>> devmem. Make net_iov to point to a new base structure called
> >>>>> net_iov_area, which dmabuf_genpool_chunk_owner extends.
> >>>>>
> >>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >>>>> Signed-off-by: David Wei <dw@davidwei.uk>
> >>>>> ---
> >>>>>    include/net/netmem.h | 21 ++++++++++++++++++++-
> >>>>>    net/core/devmem.c    | 25 +++++++++++++------------
> >>>>>    net/core/devmem.h    | 25 +++++++++----------------
> >>>>>    3 files changed, 42 insertions(+), 29 deletions(-)
> >>>>>
> >>>>> diff --git a/include/net/netmem.h b/include/net/netmem.h
> >>>>> index 8a6e20be4b9d..3795ded30d2c 100644
> >>>>> --- a/include/net/netmem.h
> >>>>> +++ b/include/net/netmem.h
> >>>>> @@ -24,11 +24,20 @@ struct net_iov {
> >>>>>           unsigned long __unused_padding;
> >>>>>           unsigned long pp_magic;
> >>>>>           struct page_pool *pp;
> >>>>> - struct dmabuf_genpool_chunk_owner *owner;
> >>>>> + struct net_iov_area *owner;
> >>>>
> >>>> Any reason not to use dmabuf_genpool_chunk_owner as is (or rename it
> >>>> to net_iov_area to generalize) with the fields that you don't need
> >>>> set to 0/NULL? container_of makes everything harder to follow :-(
> >>>
> >>> It can be that, but then io_uring would have a (null) pointer to
> >>> struct net_devmem_dmabuf_binding it knows nothing about and other
> >>> fields devmem might add in the future. Also, it reduces the
> >>> temptation for the common code to make assumptions about the origin
> >>> of the area / pp memory provider. IOW, I think it's cleaner
> >>> when separated like in this patch.
> >>
> >> Ack, let's see whether other people find any issues with this approach=
.
> >> For me, it makes the devmem parts harder to read, so my preference
> >> is on dropping this patch and keeping owner=3Dnull on your side.
> >
> > I don't mind at this point which approach to take right now. I would
> > prefer keeping dmabuf_genpool_chunk_owner today even if it results in a
> > nullptr in io_uring's case. Once there are more memory providers in the
> > future, I think it'll be clearer what sort of abstraction we might need
> > here.
>
> That's the thing about abstractions, if we say that devmem is the
> only first class citizen for net_iov and everything else by definition
> is 2nd class that should strictly follow devmem TCP patterns, and/or
> that struct dmabuf_genpool_chunk_owner is an integral part of net_iov
> and should be reused by everyone, then preserving the current state
> of the chunk owner is likely the right long term approach. If not, and
> net_iov is actually a generic piece of infrastructure, then IMHO there
> is no place for devmem sticking out of every bit single bit of it, with
> structures that are devmem specific and can even be not defined without
> devmem TCP enabled (fwiw, which is not an actual problem for
> compilation, juts oddness).
>

There is no intention of devmem TCP being a first class citizen or
anything. Abstractly speaking, we're going to draw a line in the sand
and say everything past this line is devmem specific and should be
replaced by other users. In this patch you drew the line between
dmabuf_genpool_chunk_owner and net_iov_area, which is fine by me on
first look. What Stan and I were thinking at first glance is
preserving dmabuf_* (and renaming) and drawing the line somewhere
else, which would have also been fine.

My real issue is whether its safe to do all this container_of while
not always checking explicitly for the type of net_iov. I'm not 100%
sure checking in tcp.c alone is enough, yet. I need to take a deeper
look, no changes requested from me yet.

FWIW I'm out for the next couple of weeks. I'll have time to take a
look during that but not as much as now.

--=20
Thanks,
Mina

