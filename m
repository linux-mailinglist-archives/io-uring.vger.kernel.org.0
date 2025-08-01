Return-Path: <io-uring+bounces-8877-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5594FB18965
	for <lists+io-uring@lfdr.de>; Sat,  2 Aug 2025 01:18:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E85711C854CA
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 23:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C1322B5A3;
	Fri,  1 Aug 2025 23:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JaB5CaOK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A719B2236E3;
	Fri,  1 Aug 2025 23:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754090331; cv=none; b=A9Z8iWGg5EOADx6f8hFlCoZKknKGnQNSMfSVpDKT5Crp/utX3txgWDcRT2NHJRjH7Cab1ewFI8Aa2QQKg5Yq3mpydruQ6niV9uWHeh+pAYO8+f0SYvcD8caZnrUGfnbl1OscMZcH5f9rDTkacLKsgUxaDMlPI8Fpi5LS5fk3H7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754090331; c=relaxed/simple;
	bh=MmhCSPbJzUpfniWpGXr5QqW45kuj8DvqUNJzGo5NNlc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AfBSV7ZyjKvfatfSPWCl3HSRtkFuJxY8K8Okh/UFQq5j323iG74dNvWMAkYfx2eDra9cp2ZssYkkBt326rZGK6V8+79mW9m98ZN0KyziznoRRbwfz6a8ib5ciYRlQ/zl5z7JeattmTb5aAql2urtFQT24lxopWMJH5OC6mwxqiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JaB5CaOK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAE0C4CEE7;
	Fri,  1 Aug 2025 23:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754090331;
	bh=MmhCSPbJzUpfniWpGXr5QqW45kuj8DvqUNJzGo5NNlc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JaB5CaOKzbv+9FUhzhxvYqV3da/UJdei2GAQe98KG3sdef2vTMuB5Jn+PsYv0xZ6X
	 4zDS7oMJZmKrNNnUWUvbPBNKId77XY/TWp4CmNhuH91O3o933Z5Ac1rW/dAqIazBYg
	 +tYORDIRsKP+pmr7RAMPS3ozTwxrlebYjCluiChzgZC/jXj5ed72kRBi0bWXwfO9gb
	 lrnpT+eSXn5pd1BcwbVVnL0H/9lJCmUMjX8hyBMWkNlgxoceEsrvUzGG7wAFVF7cCy
	 P552SKEf7l77NREnkStRVkuFlEYZVrYdDFoPEDaX2yRVPp91Kg2MZORv5LSdKH/I7v
	 eAcpqDNxvU8vg==
Date: Fri, 1 Aug 2025 16:18:50 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Willem de
 Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, dw@davidwei.uk, michael.chan@broadcom.com,
 dtatulea@nvidia.com, ap420073@gmail.com
Subject: Re: [RFC v1 05/22] net: add rx_buf_len to netdev config
Message-ID: <20250801161850.0ea0a5f1@kernel.org>
In-Reply-To: <CAHS8izOx5p2hw7OxhKZNUUmC5uJaM0PKw_4UdELe8LQ1QkuLyw@mail.gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
	<261d0d566d3005a3f2a3657c40bf3b3f7a9fdc98.1753694913.git.asml.silence@gmail.com>
	<CAHS8izOx5p2hw7OxhKZNUUmC5uJaM0PKw_4UdELe8LQ1QkuLyw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Jul 2025 14:50:12 -0700 Mina Almasry wrote:
> On Mon, Jul 28, 2025 at 4:03=E2=80=AFAM Pavel Begunkov <asml.silence@gmai=
l.com> wrote:
> > Add rx_buf_len to configuration maintained by the core.
> > Use "three-state" semantics where 0 means "driver default".
>=20
> What are three states in the semantics here?
>=20
> - 0 =3D driver default.
> - non-zero means value set by userspace
>=20
> What is the 3rd state here?

I just mean a value with an explicit default / unset state.
If you have a better name I'm all ears ..
> > diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> > index a87298f659f5..8fdffc77e981 100644
> > --- a/net/ethtool/common.c
> > +++ b/net/ethtool/common.c
> > @@ -832,6 +832,7 @@ void ethtool_ringparam_get_cfg(struct net_device *d=
ev,
> >
> >         /* Driver gives us current state, we want to return current con=
fig */
> >         kparam->tcp_data_split =3D dev->cfg->hds_config;
> > +       kparam->rx_buf_len =3D dev->cfg->rx_buf_len; =20
>=20
> I'm confused that struct netdev_config is defined in netdev_queues.h,
> and is documented to be a queue-related configuration, but doesn't
> seem to be actually per queue? This line is grabbing the current
> config for this queue from dev->cfg which looks like a shared value.
>=20
> I don't think rx_buf_len should be a shared value between all the
> queues. I strongly think it should a per-queue value. The
> devmem/io_uring queues will probably want large rx_buf_len, but normal
> queues will want 0 buf len, me thinks.

I presume that question answered itself as you were reading the rest=20
of the patches? :)

