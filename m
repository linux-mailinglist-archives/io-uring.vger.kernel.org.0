Return-Path: <io-uring+bounces-8853-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA3FB144AB
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 01:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F36793AC8BE
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 23:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E56B202C45;
	Mon, 28 Jul 2025 23:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lm6Y1OJr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81C513790B
	for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 23:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753744941; cv=none; b=HVL3tMQSIyrKtSTHb/XkJnMkGIVverCrdflnuAepB6f71AY3PcDsmuvDkNwJrRcUJWCpZXNetrj7LRjaPAXZPzg+XBncDnSG2tIQZ3WEcgHjlAP0/wLAI/MYO40r6y5DOZaHqVIdmMpKPliJKEHuNOw7Kp1QqLS4ONVKMXep37Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753744941; c=relaxed/simple;
	bh=/1CgAjXF+SqC994Qbvk+0nvigMY1t6TfyD9G27uh+ec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DoYPMR4jvncjXolPzpsCaVJzmCS0AumToN+GW8TYGoJ95gjCsdDLIuT0WypgMTGk5Wb55GaE57pFh7E5319fD2DW0/ts4M/O9R+DJzGK/hEVbULWnXib9s6fNlrJoicfqy2ONDe4Gm+6+Vnb7yBjHY2qUTEbvwLV6S+EixoP18s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lm6Y1OJr; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24070ef9e2eso5145ad.0
        for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 16:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753744939; x=1754349739; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/1CgAjXF+SqC994Qbvk+0nvigMY1t6TfyD9G27uh+ec=;
        b=lm6Y1OJrVeVOkbYBfrK5r4Z9pCepru7yC1Bd3GqiMOsRgDmh9nl75RcxPX3wly1PbP
         v9g6it1A8GsM03eiEZ40XyXlYg+MoB9xy63rCMKekhxhfJ4Y2WbRWFJbCEoJufgvVQpC
         hu8Ya9OCO8oATrE8/2sU0emR5GnS3MXl1BECGYpBaNY+ud4rbPF8J2vfULF3Q7c7s2TX
         RbunSaj7dlXdnhjframlTZOU5MmkEokhLHdzdzgbMfrd3tbjrM+0sf7ONSy3htR2XtyJ
         M9st/p3Hq8gJHNuwVxwg6e6pCg8jYCXH8NNyzYLM0DoLm8/OKq3L6TSMr7QixJpF9YpG
         JrIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753744939; x=1754349739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/1CgAjXF+SqC994Qbvk+0nvigMY1t6TfyD9G27uh+ec=;
        b=Ri3eSU8VNp4ZHszhBlGFke7WX0WE/V51NIkn7fTFgZwQbY+CqVJP/rK2PGa+V8Am6D
         72dG0RGl/zhQAJrWukEabNY3vsHxxx9g55zIVIxReFP/xI3xKAqm+4udJTVw1GfKBPBO
         XRQf0hz1tlfojFaexp3mOZEh2DQJzSa+vLs4yeKMFgvzvDigWkRFe+pkA+9wBUAKH45/
         RG1fRRVT1axcflUJTqpMp/8gfXiNYjELuBIj7DzqH1SoWr9VNIVGe/Jhnw/yC72x6i0h
         3v9kegnTe9NIj51J8G8Hss0OlRPQ+apQgqUCxrRH0UrUEABahGDVens9JM0jRfWefVWh
         KLGA==
X-Forwarded-Encrypted: i=1; AJvYcCXF2gv467vUcy+FC7+gsgg460KJjauX7zwEHJXLQfNamQM+PdYqj8qWrmT1wsz/iOemxCbFEY2E6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxH7nOcxOAOCS6mJ7mq2LgTKbx4LQsWncoISnPvqUfULbdZPEfT
	wBwPxidiIggTZ4mDqyxRCWYF/Gdv7WxRmeUd1mhrunp6zCFDkC2C8W1h0uPVXSEBXGkVPyY2o03
	bKMdwX7ftN+1Z7srSWGDLF622JkIOunVU7gkFH9ln
X-Gm-Gg: ASbGncvn2eSpaTlsBA3t4hH/KcSK7Wwbismzp3F4+ydJD24W2th8fJai1VuGnUGTrU/
	cUTDsoS0C2PlrSHn7Bl5S7DPhROe61SOL5ODyVOd0l1ziVfND+aH9/OEobuUkmrFW7XMqN8ClPT
	zyZoUJcwjD/xopyUQEg1T70x7o0mSxESMWnXc4bckUjwDMF3AJZb8R853Vl63PRmDZ0kwlMC4qT
	d1uG/kGad7uL4Vrjy2V6CCbj+WzCPvvU8RnDw==
X-Google-Smtp-Source: AGHT+IH6hMI7TG+VAJ7fk8Pay6EsuoBcfS5i5NfZR+oG9D8u6rNYPL59FaSFr4fRHRcpB5TnueIDBVBICi1mi3mCN/0=
X-Received: by 2002:a17:903:b45:b0:240:469a:7e23 with SMTP id
 d9443c01a7336-2406797692bmr1401205ad.20.1753744938519; Mon, 28 Jul 2025
 16:22:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1753694913.git.asml.silence@gmail.com> <aIevvoYj7BcURD3F@mini-arch>
 <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com> <aIfb1Zd3CSAM14nX@mini-arch>
 <0dbb74c0-fcd6-498f-8e1e-3a222985d443@gmail.com> <aIf0bXkt4bvA-0lC@mini-arch>
In-Reply-To: <aIf0bXkt4bvA-0lC@mini-arch>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 28 Jul 2025 16:22:04 -0700
X-Gm-Features: Ac12FXyiLuna7Dq1l-5bA5ah7yKNSZg9QV6FcQgwKP6z-_804gVThvLdIILAOTs
Message-ID: <CAHS8izPLxAQn7vK1xy+T2e+rhYnp7uX9RimEojMqNVpihPw4Rg@mail.gmail.com>
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
	Willem de Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, 
	horms@kernel.org, davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 3:06=E2=80=AFPM Stanislav Fomichev <stfomichev@gmai=
l.com> wrote:
>
> On 07/28, Pavel Begunkov wrote:
> > On 7/28/25 21:21, Stanislav Fomichev wrote:
> > > On 07/28, Pavel Begunkov wrote:
> > > > On 7/28/25 18:13, Stanislav Fomichev wrote:
> > ...>>> Supporting big buffers is the right direction, but I have the sa=
me
> > > > > feedback:
> > > >
> > > > Let me actually check the feedback for the queue config RFC...
> > > >
> > > > it would be nice to fit a cohesive story for the devmem as well.
> > > >
> > > > Only the last patch is zcrx specific, the rest is agnostic,
> > > > devmem can absolutely reuse that. I don't think there are any
> > > > issues wiring up devmem?
> > >
> > > Right, but the patch number 2 exposes per-queue rx-buf-len which
> > > I'm not sure is the right fit for devmem, see below. If all you
> >
> > I guess you're talking about uapi setting it, because as an
> > internal per queue parameter IMHO it does make sense for devmem.
> >
> > > care is exposing it via io_uring, maybe don't expose it from netlink =
for
> >
> > Sure, I can remove the set operation.
> >
> > > now? Although I'm not sure I understand why you're also passing
> > > this per-queue value via io_uring. Can you not inherit it from the
> > > queue config?
> >
> > It's not a great option. It complicates user space with netlink.
> > And there are convenience configuration features in the future
> > that requires io_uring to parse memory first. E.g. instead of
> > user specifying a particular size, it can say "choose the largest
> > length under 32K that the backing memory allows".
>
> Don't you already need a bunch of netlink to setup rss and flow
> steering? And if we end up adding queue api, you'll have to call that
> one over netlink also.
>

I'm thinking one thing that could work is extending bind-rx with an
optional rx-buf-len arg, which in the code translates into devmem
using the new net_mp_open_rxq variant which not only restarts the
queue but also sets the size. From there the implementation should be
fairly straightforward in devmem. devmem currently rejects any pp for
which pp.order !=3D 0. It would need to start accepting that and
forwarding the order to the gen_pool doing the allocations, etc.

--=20
Thanks,
Mina

