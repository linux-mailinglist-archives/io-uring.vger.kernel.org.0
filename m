Return-Path: <io-uring+bounces-3520-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADA49975B5
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D89DA285028
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 19:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDD8817F505;
	Wed,  9 Oct 2024 19:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1P7Idaee"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D98A178CCA
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 19:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728502374; cv=none; b=mPDJ0PCMbwjNuzZ1vkFHH49fWBk5oJHWMlKDFNL4J3+zvcol1CXtOJOUFlbEAsYmiWVD8caQdVbnMq7aEanysQeI0vizLt3hiPdW22wyyANge6HdbFoc03u2nvXE44Jhlklj4M4p+f80pRH3Dg2148Dp8vRtF4OqYJ7X2I2+VH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728502374; c=relaxed/simple;
	bh=2Cvp7Z0BO4ZCgzPNjWv2x823Ve/JFfbBH8uEE2NOshI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hr62yxuxLJ22F2bV/RKFb3aSDrhLsrKXiay3yWTzEzh+h7c9w26pCL+R45zMrxYPL5pKyt4AP9s0btSiYSFzBQmbqdDJty5/9z9RlVlhAkp9S1ZdDbFkRRse1O8/Nl5mRWBR3T1+hvXdCjCcrRvwnskWpfGnb1J2cOSHfYX8jL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1P7Idaee; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4601a471aecso2111cf.1
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 12:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728502372; x=1729107172; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Cvp7Z0BO4ZCgzPNjWv2x823Ve/JFfbBH8uEE2NOshI=;
        b=1P7IdaeeYGwJDzFCA9UQ5SOHfL8aLEnQvhUh16EgUX5if539PEt3wvz0SYc8LsVtxS
         6L/+Abx1n2GpnIfRWS31l7yEdlj/Uroh/r7BVjoZYbeBVVFexvhPHNkXHKmbUW9AmDA+
         bfxnKKtERdHzR9oe4lrOG5tWjZAf7QUa9KLvgQGrDzFX/QCCpMfHe4rU4c9vqEKyGtcK
         NZ0TDdHtAVoZbdbZ1/xUzP1bwFfAOG19XUtA//uzjGrVxTvqGKQyKDZ0zGBVB2zFZ4Ai
         1NhmO/iQiCH7m8iFUWuu9Uac0JKhdy4F3nzPp4+cKf9wOjn7opoPGg/QxWyQtqrSqQjx
         F/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728502372; x=1729107172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Cvp7Z0BO4ZCgzPNjWv2x823Ve/JFfbBH8uEE2NOshI=;
        b=ei82YOSL2y4YLCbuPJX8D5W+YHYsjHycTTjxeBcDHmPz0NNYgPRe5cN3QdInOs7y+J
         e7CEuOnJpiS71Fqi+GQLoy+flcG0jYw10XDiNLttsPF+81kfUgTZ7DTERjM4vbyjKKyf
         j8mOzby15UmG+4sXvTIff2bHYS/hyYldF9fHhcpZTAYCMVSNJvHAWtCnlKxz4VLEdtYS
         gYxLoP4V49lTrhiuUCVFU/xeVAhbh/0/Hpo2wQ5kKJyfyFX4xQ4GY58uYSojRkhIib29
         jY3a6Yx4d81WeUM5xt8xyPegK+0PJPvu7XDT2rqw5/CMyOVhaw73RTOuvOi0bI9nm4eD
         9wuA==
X-Forwarded-Encrypted: i=1; AJvYcCXAYvTVijzwKs+2VcinhxJvhtWYKW5uJnDm8s31WSbrDbyPJ8iJ7fV/mwrA49xoh3HGrTLq78BFug==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXjnnnh7JHtI9TcMZcpb5eyDJ3ASi9B9flQUtrfWD0YdFZOQdf
	Gfj7JbLDhl8hI7GvvoFrZbVuqWw/L76V9J2yEEtBpHlyCiMoLnhXJ+KTU5N7wKgFs8pd29gATt0
	Ui8/AsjKnlBYKr7XuBDRH0ywPmNDBXR5+L6Gev1DWISKR0XnefQzhSug=
X-Google-Smtp-Source: AGHT+IHLWvU627n5aUnUIgUnk5bcyJ1UsZTeTdc5R2gxTZL5uDVqsEQL4xxDfqML+gZJPjOCoiXlqMAevpEHowZSwNM=
X-Received: by 2002:a05:622a:a609:b0:45f:506:4d08 with SMTP id
 d75a77b69052e-460404743acmr543851cf.28.1728502371714; Wed, 09 Oct 2024
 12:32:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
 <016059c6-b84d-4b55-937c-e56edbedc53a@kernel.dk>
In-Reply-To: <016059c6-b84d-4b55-937c-e56edbedc53a@kernel.dk>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 9 Oct 2024 12:32:37 -0700
Message-ID: <CAHS8izOF5dM7WUrzDhGrR_UP7t_Mg7=sgti_TSbqG4x00UBfXA@mail.gmail.com>
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: Jens Axboe <axboe@kernel.dk>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 9, 2024 at 9:57=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 10/9/24 10:55 AM, Mina Almasry wrote:
> > On Mon, Oct 7, 2024 at 3:16?PM David Wei <dw@davidwei.uk> wrote:
> >>
> >> This patchset adds support for zero copy rx into userspace pages using
> >> io_uring, eliminating a kernel to user copy.
> >>
> >> We configure a page pool that a driver uses to fill a hw rx queue to
> >> hand out user pages instead of kernel pages. Any data that ends up
> >> hitting this hw rx queue will thus be dma'd into userspace memory
> >> directly, without needing to be bounced through kernel memory. 'Readin=
g'
> >> data out of a socket instead becomes a _notification_ mechanism, where
> >> the kernel tells userspace where the data is. The overall approach is
> >> similar to the devmem TCP proposal.
> >>
> >> This relies on hw header/data split, flow steering and RSS to ensure
> >> packet headers remain in kernel memory and only desired flows hit a hw
> >> rx queue configured for zero copy. Configuring this is outside of the
> >> scope of this patchset.
> >>
> >> We share netdev core infra with devmem TCP. The main difference is tha=
t
> >> io_uring is used for the uAPI and the lifetime of all objects are boun=
d
> >> to an io_uring instance.
> >
> > I've been thinking about this a bit, and I hope this feedback isn't
> > too late, but I think your work may be useful for users not using
> > io_uring. I.e. zero copy to host memory that is not dependent on page
> > aligned MSS sizing. I.e. AF_XDP zerocopy but using the TCP stack.
>
> Not David, but come on, let's please get this moving forward. It's been
> stuck behind dependencies for seemingly forever, which are finally
> resolved.

Part of the reason this has been stuck behind dependencies for so long
is because the dependency took the time to implement things very
generically (memory providers, net_iovs) and provided you with the
primitives that enable your work. And dealt with nacks in this area
you now don't have to deal with.

> I don't think this is a reasonable ask at all for this
> patchset. If you want to work on that after the fact, then that's
> certainly an option.

I think this work is extensible to sockets and the implementation need
not be heavily tied to io_uring; yes at least leaving things open for
a socket extension to be done easier in the future would be good, IMO.
I'll look at the series more closely to see if I actually have any
concrete feedback along these lines. I hope you're open to some of it
:-)

--
Thanks,
Mina

