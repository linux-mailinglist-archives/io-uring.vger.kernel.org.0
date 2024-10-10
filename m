Return-Path: <io-uring+bounces-3566-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D440E998F36
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 20:02:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FB9D1F25DC4
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 18:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F0219AA6B;
	Thu, 10 Oct 2024 18:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0+TrZIQU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C4138396
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 18:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728583297; cv=none; b=mimYEnVWJa5/yJMKq7pXkcUWNsSymZM9Jc26RGC9SJu5PThINp/Cc7i/g2Mt7fd/jATbRpKGJBBmeAeLknuLdUZe8/Rhh8TAKWLSHbMyyy20VB294/i42AMiY8STVLTpvW8aDOgoH8i0/tqaVJeuUyUFZdQY9r7c5Q4iv0q+J0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728583297; c=relaxed/simple;
	bh=h4p6/oEJeeULQeOwzxT6gK43puyM2unadqeu1J64YA0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fS+tsBal3XSTXlRX8rSEpeIeFzfpm4SLXuoUwSKrrxm3YwqdQvWpr/HsovawoCCJIkKa+dXS6vsWS73ZFiIVz40MQDztzggvWZTgX9u578IyoPBjmzGAPM149byXXkWabJCvt8Dwuqda1mXHeERXJACaNoH/KT4BpbJVARIOSEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0+TrZIQU; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4603d3e0547so30441cf.0
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 11:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728583295; x=1729188095; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h4p6/oEJeeULQeOwzxT6gK43puyM2unadqeu1J64YA0=;
        b=0+TrZIQU8bz3nlGvlw803qjqKzOMtDbfkowS1m9LybsRMobQsJAX9u5M3XlUcHmsKP
         fjutNkmVUGWERLkXfkcfGTUeF7cOizU2NF0WnYI0N6M2qQyioDt4EDOgNTkGGCM1qwwW
         RIJlNCtKq4SEoWTBM0d3WIDoikN/Atah57DmuocJuq+HgMuSsp3DD9/IkWYBiCOlHWiU
         /4DASB8OpTgekVByE+DEQzqLjI13Awx2RxMkGQIWYVF8dr4DBnT1DD/R07pZQoc8t0QU
         VhIQzs5epXMeZrjTFqyjE9MISPhQkNLT6p06i5S9T60gGPpBupMgGjHdTGyIBmzTiToJ
         c7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728583295; x=1729188095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h4p6/oEJeeULQeOwzxT6gK43puyM2unadqeu1J64YA0=;
        b=vTx2PNwBuzoSiywiShZx0NiPoQwpguG8TOp93F51+zDXte02iGVWbOzCY2iN1EysRh
         LOfZnIDJypMwiJVRh/VJWtMT2SJ4SBIdIhXkZuy+2tjnzPKaFR1cmGnQEdoglNKfinDS
         /0ZE3f0o+0p8USQX6NIgL3AUvFpl3SJBLWcj8Ly/kY6+5VP1ydaerIRvcj7ObbglPnrC
         mq4tHvFm6KDhF0hQ+JyK8G4TRW+OqHP6JG7RBI7Cwy4bQ/Kws95jUNkFYHArTDkI5vOW
         mfHmVQ+bizvFzCwBB748FPVIL/VVDIz0AKDEZQKtMBrhX15+D9j2z4Ue4AtnR6TSBYNB
         J8XQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVro+H2jMOM5q6aPGgDQ1PJmIjhV4eaSx8Jearwoh/pKIb9eX+773hq6dCd5RqR4HIOOFJplMLRQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YynOVPGPnXtXA43tFcLOcpGx6ONGrUYJT/SMZLslHH1TaIsCcXW
	0eRVXa4OGc7saAIP4zA8il/LZyIhS21sBgNdVNmVVMbX2y3ChiO/c9JcwZLugpisMZtj5gU5elg
	ENma28z33lLR0WoW+2bHc24Xq/opPw7AV+RKY
X-Google-Smtp-Source: AGHT+IE1Co5d9FOgO1g5et54dnmdPYt/7A6Q5DwteQLTHpos6fidELAlf4jiFP4oYabOZqoHCxX2MnXbXIIvb5OVky8=
X-Received: by 2002:a05:622a:a28c:b0:460:48f1:5a49 with SMTP id
 d75a77b69052e-4604ac61976mr238341cf.14.1728583294536; Thu, 10 Oct 2024
 11:01:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-2-dw@davidwei.uk>
 <CAHS8izMHmG8-Go6k63UaCtwvEcp=D73Ja0XfrTjNp_b5TUmUFA@mail.gmail.com> <ed21bca5-5087-4eff-814c-39180078a700@gmail.com>
In-Reply-To: <ed21bca5-5087-4eff-814c-39180078a700@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 10 Oct 2024 11:01:20 -0700
Message-ID: <CAHS8izNGdFTr789fFhV_NvYK0ORKPwn_KHu0CeaZp_xhg9PgCA@mail.gmail.com>
Subject: Re: [PATCH v1 01/15] net: devmem: pull struct definitions out of ifdef
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 9, 2024 at 4:16=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 10/9/24 21:17, Mina Almasry wrote:
> > On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> wrote=
:
> >>
> >> From: Pavel Begunkov <asml.silence@gmail.com>
> >>
> >> Don't hide structure definitions under conditional compilation, it onl=
y
> >> makes messier and harder to maintain. Move struct
> >> dmabuf_genpool_chunk_owner definition out of CONFIG_NET_DEVMEM ifdef
> >> together with a bunch of trivial inlined helpers using the structure.
> >>
> >
> > To be honest I think the way it is is better? Having the struct
> > defined but always not set (because the code to set it is always
> > compiled out) seem worse to me.
> >
> > Is there a strong reason to have this? Otherwise maybe drop this?
> I can drop it if there are strong opinions on that, but I'm
> allergic to ifdef hell and just trying to help to avoid it becoming
> so. I even believe it's considered a bad pattern (is it?).
>
> As for a more technical description "why", it reduces the line count
> and you don't need to duplicate functions. It's always annoying
> making sure the prototypes stay same, but this way it's always
> compiled and syntactically checked. And when refactoring anything
> like the next patch does, you only need to change one function
> but not both. Do you find that convincing?
>

To be honest the tradeoff wins in the other direction for me. The
extra boiler plate is not that bad, and we can be sure that any code
that touches net_devmem_dmabuf_binding will get a valid internals
since it won't compile if the feature is disabled. This could be
critical and could be preventing bugs.

--=20
Thanks,
Mina

