Return-Path: <io-uring+bounces-1924-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E89C8C8E47
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 00:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C02CD1C21252
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 22:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577D31A269;
	Fri, 17 May 2024 22:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="eGgTVsyw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510EE140E34
	for <io-uring@vger.kernel.org>; Fri, 17 May 2024 22:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715984690; cv=none; b=NHAqn6AKtRgJD10v1PrJ7u/bASgiHfPwJ+XDDINDZjd4korG0v9JIenndx7N99LEjbVN4EQcZGJnDJ1VzWkIvGjeDBQ9KoFyou7mwnF7Y4ucT5Ojyd4Tb9gHBgF7ay5wPfad+2ca77A3S9+cDMfnmXVlTXFWyigo1gwPv8OwzQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715984690; c=relaxed/simple;
	bh=Vr2E3L84X6W8QO9W7fZ0is5R/Djkd+dnT+eQqsi4FRo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HG3/JeUtrKN5Va/lbjx4FCCY7AQwhzj4b9Do4Z7IATxIpCvVyJNV3E4VbKFNPwxrRpHsneAK/4vHKNQ1XRvfgt+BS/Bqhgmiy0PIEH/ure5KFrPJJ3pgWyGdUkeyqhqwmL+pnR+oI0K1hss3lPoYSd8FwF+8qLo/kf0Txv/IHyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=eGgTVsyw; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1715984681; x=1716243881;
	bh=tB/fkv1BlgaesKor1YgA8aRQH5n4cjPxsJaqx6gHVuI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=eGgTVsyw7V+lLhbIK7GIACjV0q2ym7Kd5RJ3scdf03K9SRsQOvK/c7Tlb0QyfHc8c
	 bz4Zgmat30Nc9rfz1ddbt65ONmKiVRttszK1Xerm4OJ8gtzAFv8LYNTt69E2rBMvSm
	 AH7RYWlkTPUNuZ8YRK0iIitxu8BSVxL/Vqeiy8t24a+HPvjwDIfPn4UJZ+4u4kaish
	 MIVs8+9d13pjElYlgRs62cDoz+OdHJryZu6SkKieohKT5Av7NQeDtmhc6jgA8bnkRZ
	 5Y6JBj2e5d9lYdadOeoGzbH2BxO9UdLDsaT/xdbtkdl0SxuAYwkXwq+CAdz59a+eEz
	 5f8c9rDoXCVSw==
Date: Fri, 17 May 2024 22:24:37 +0000
To: Jens Axboe <axboe@kernel.dk>
From: Mathieu Masson <mathieu.kernel@proton.me>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org
Subject: Re: [Announcement] io_uring Discord chat
Message-ID: <ZkfZIgwD3OgPSJ8d@cave.home>
In-Reply-To: <f7367e15-150f-4fbb-b026-73d9407fd863@kernel.dk>
References: <8734qguv98.fsf@mailhost.krisman.be> <f7367e15-150f-4fbb-b026-73d9407fd863@kernel.dk>
Feedback-ID: 50044778:user:proton
X-Pm-Message-ID: f5674f023f49ed58d2548141a89fbe2b06c0b66c
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 17 mai 13:09, Jens Axboe wrote:
> On 5/17/24 12:51 PM, Gabriel Krisman Bertazi wrote:
> > Following our LSFMM conversation, I've created a Discord chat for topic=
s
> > that could benefit from a more informal, live discussion space than the
> > mailing list might offer.  The idea is to keep this new channel alive f=
or a
> > while and see if it does indeed benefit the broader io_uring audience.
> >
> > The following is an open invite link:
> >
> >  https://discord.gg/8EwbZ6gkfX
>=20
> Great initiative!
>=20
> > Which might be revoked in the future.  If it no longer works, drop me a=
n
> > email for a new one.
> >
> > Once we have some key people around, I intend to add an invite code to
> > the liburing internal documentation.
>=20
> Is it public - and if not, can it be? Ideally I'd love to have something
> that's just open public (and realtime) discussion, ideally searchable
> from your favorite search engine. As the latter seems
> difficult/impossible, we should at least have it be directly joinable
> without an invite link. Or maybe this is not how discord works at all,
> and you need the invite link? If so, as long as anyone can join, then
> that's totally fine too I guess.
>=20

Not to start any form of chat platform war, but the rust-for-linux communit=
y has
been using Zulip for a while now. At some point they made the full message
history live accessible without an account :

https://rust-for-linux.zulipchat.com/


It is even search-able apparently, which is quite appreciable as an outside=
r
who just wants to follow a bit in a more informal way than the ML.

Mathieu.


