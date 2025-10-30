Return-Path: <io-uring+bounces-10305-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 44392C22BD0
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 00:50:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 14CAD4E1068
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 23:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E932D5920;
	Thu, 30 Oct 2025 23:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eeofDQwG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72A2186294
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 23:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761868251; cv=none; b=f8DpeOIbCONXJNde3LW0/9c0uDfi9iaVhjez7ZuTU/Dte+MkdVJ2gy9z+37D+pX2Cg/XewW3DUa0+rFwOx2FdYA2Ud3vwuNbkg2t1OHlZs308bFVKlJPQ1ZlJSFPmZJy1p7wr9w9BU7RZtsamQG7oE5a0wACrlznQ2k2MZpVFxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761868251; c=relaxed/simple;
	bh=vVutEoJZmNj1T2Xj29z64MYSeF69ysf7pcVScY532Dg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SvInoS1WKC4LfnwTKrmBMxj0l8r7uNO9p2KxrtRkWZOmj5Mcdg9+46pxCQssfjeY4XC+emySL9IXibyLnkP6Oyouo4IB8ZODF4q8I5x5MIwL9+ZSKgvJADr3SB8LIg+u4/xdCN1nTMIKVLyZDxdRdzKbyOlFkq4ekH2d+VFjBo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eeofDQwG; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ecf30c734eso15019261cf.3
        for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 16:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761868248; x=1762473048; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVutEoJZmNj1T2Xj29z64MYSeF69ysf7pcVScY532Dg=;
        b=eeofDQwGOZCLZ3pKisZGag7MsyCqW3yqS/NQO2PzB3Ffd3WuTkyrLHA4XFTycO/wuQ
         mM0m573UqyocjTr5F2c+/ccHva3kVlMBGV5PpQ9TmuyLEa9sj9gXKwPBELzSv1XeGlDh
         g46eraWsaZbtArkHiNOBWXJNYQmuZhtsszDq+I6Hvo3Vj8C/TgyHq7ihikR5NU/cA4EI
         HoRCtz/twJl9yKhiK2KSasTSiBwAe5Z/35MJ1PXYKRlXXtFshh4kicSzCY/u+YCrGwH4
         t5Y2CmTTnmAdkgg6V6FeLYtcRAH59cb6YpijI5tzouIqOTGcbNEDB95OYuxL8Hxdwv33
         ItaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761868248; x=1762473048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vVutEoJZmNj1T2Xj29z64MYSeF69ysf7pcVScY532Dg=;
        b=w4hQRMnn7uMAJLFc+JeIQJp48jLRaqxYX/2JYqedyFzZrTkJQ8HhWJgBLzurJ+cGps
         NIbPKqE7QkMd++8A1HIFckwe1xurGWPZNbisuNzGVpoXVn5NC/SH7ghlHAjVlUijJEUz
         nQwqPg9jFIVBfHqoRfPTJNX8VcDb9PjKp0UXqyX/3JcUIvkDhtMIpPcZwXoSM/5Wuck1
         jXS+Kih6cQmz/uF9u+uRGKFuUTSZWa/A/i+sYHD+oXAAM9DfhAWt6AhGfc2W2lF2sGnp
         tlKVSjrdDKliDURxVRaqCYco+OCX/ZdGgeyG03a2WvEKz9aObR/6cSl1GNCJuBoOOm7g
         scog==
X-Forwarded-Encrypted: i=1; AJvYcCXrV2JMSSFU8UJb1+ToloiZxSIefioE45MqQkabmFWy0jo+3OVwbtlmPTQDxQmtNMxW0ityrdypJw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXo/VROPm4mOqsytIZNZQWHkt/1AqEqhHRSspoQrUtmPEkI8n9
	7iZ3dF78PiRSBoR+ZIueHbBrEKYrlvr4gBkmSN3PP9WjHFHgoFZtI7NvBJo95Tu0KaiZWOBoICh
	AUoboiwOCQ86jI9KNB6jBmNMfr9eoYsc=
X-Gm-Gg: ASbGncvr99fw7lZ6dcXl21m2ndDZ2Z9Jf6LglSqHRlsMKhFVP0heaQG3AqaxP0WQ4w8
	OhOJMb/JJCv6iEFMLwlle0RXkI0EdsiHhr+4h+VHg4RZskbzQByDNAvtvoCXPgBp8kHy1vy8tIc
	K0iZudMLWhYhwkyM7nNLYLmn263YeH4Q8xe5kkHe22aMcRxo6P3E8Q1TNiJYeFzM0LVNEL07ffI
	4nXrGkYY8s06ulR+owBdBRAAN2w14DmFQiTYjMRORWzLN77HiaLdIYMi9xddP9LsiBvnSktX1Vd
	FDX7F2jaA6VFBho=
X-Google-Smtp-Source: AGHT+IHhxuai3R8JXCa4oArp1P6xppghmdyrkdjIcOLJO/GuWykVPCals4nCRj9LH5gdIb7py6mTIl0tkcSMTibzvu8=
X-Received: by 2002:a05:622a:544d:b0:4ec:76d8:e73f with SMTP id
 d75a77b69052e-4ed30d56d0emr18637591cf.10.1761868248462; Thu, 30 Oct 2025
 16:50:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-2-joannelkoong@gmail.com> <455fe1cb-bff1-4716-add7-cc4edecc98d2@gmail.com>
 <CAJnrk1ZaGkEdWwhR=4nQe4kQOp6KqQQHRoS7GbTRcwnKrR5A3g@mail.gmail.com>
 <9f0debb1-ce0e-4085-a3fe-0da7a8fd76a6@gmail.com> <96c4d33d-4f56-4937-bae7-9bda17f3264f@ddn.com>
In-Reply-To: <96c4d33d-4f56-4937-bae7-9bda17f3264f@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 30 Oct 2025 16:50:37 -0700
X-Gm-Features: AWmQ_bn8sxUTPkGvtX8x09nhmTRPb9iEdoxvSDFRsp686lTAxrG84Kp382dNekU
Message-ID: <CAJnrk1ah68G4NpDj8A41tX6J2M+NB6jNAUYdWEzTD3N_QrDJ_g@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] io_uring/uring_cmd: add io_uring_cmd_import_fixed_full()
To: Bernd Schubert <bschubert@ddn.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, miklos@szeredi.hu, axboe@kernel.dk, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	xiaobing.li@samsung.com, csander@purestorage.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 3:24=E2=80=AFPM Bernd Schubert <bschubert@ddn.com> =
wrote:
>
>
>
> On 10/30/25 19:06, Pavel Begunkov wrote:
> > On 10/29/25 18:37, Joanne Koong wrote:
> >> On Wed, Oct 29, 2025 at 7:01=E2=80=AFAM Pavel Begunkov <asml.silence@g=
mail.com> wrote:
> >>>
> >>> On 10/27/25 22:28, Joanne Koong wrote:
> >>>> Add an API for fetching the registered buffer associated with a
> >>>> io_uring cmd. This is useful for callers who need access to the buff=
er
> >>>> but do not have prior knowledge of the buffer's user address or leng=
th.
> >>>
> >>> Joanne, is it needed because you don't want to pass {offset,size}
> >>> via fuse uapi? It's often more convenient to allocate and register
> >>> one large buffer and let requests to use subchunks. Shouldn't be
> >>> different for performance, but e.g. if you try to overlay it onto
> >>> huge pages it'll be severely overaccounted.
> >>>
> >>
> >> Hi Pavel,
> >>
> >> Yes, I was thinking this would be a simpler interface than the
> >> userspace caller having to pass in the uaddr and size on every
> >> request. Right now the way it is structured is that userspace
> >> allocates a buffer per request, then registers all those buffers. On
> >> the kernel side when it fetches the buffer, it'll always fetch the
> >> whole buffer (eg offset is 0 and size is the full size).
> >>
> >> Do you think it is better to allocate one large buffer and have the
> >> requests use subchunks?
> >
> > I think so, but that's general advice, I don't know the fuse
> > implementation details, and it's not a strong opinion. It'll be great
> > if you take a look at what other server implementations might want and
> > do, and if whether this approach is flexible enough, and how amendable
> > it is if you change it later on. E.g. how many registered buffers it
> > might need? io_uring caps it at some 1000s. How large buffers are?
> > Each separate buffer has memory footprint. And because of the same
> > footprint there might be cache misses as well if there are too many.
> > Can you always predict the max number of buffers to avoid resizing
> > the table? Do you ever want to use huge pages while being
> > restricted by mlock limits? And so on.
> >
> > In either case, I don't have a problem with this patch, just
> > found it a bit off.
>
> Maybe we could address that later on, so far I don't like the idea
> of a single buffer size for all ring entries. Maybe it would make
> sense to introduce buffer pools of different sizes and let ring
> entries use a needed buffer size dynamically.
>
> The part I'm still not too happy about is the need for fuse server
> changes - my alternative patch didn't need that at all.
>

With pinning through io-uring registered buffers, this lets us also
automatically use pinned pages for writing it out (eg if we're writing
it out to local disk, we can pass that sqe directly to
io_uring_prep_rw() and since it's marked as a registered buffer in io
uring, it'll skip that pinning/translation overhead).

Thanks,
Joanne

> Thanks,
> Bernd

