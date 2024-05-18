Return-Path: <io-uring+bounces-1932-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3D948C9005
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 10:32:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CC101F2122D
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 08:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D73B1094E;
	Sat, 18 May 2024 08:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="XBcW6gyz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E25F79F5
	for <io-uring@vger.kernel.org>; Sat, 18 May 2024 08:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716021105; cv=none; b=hFzf/dNcnzOFP4JY1NE6PUO3ejrgv6AogFpUzyoAokHDpoWecbjB9Kqlx5/9GQHVhi8+EdVOWQWYRxNV7YK4D014Bmax+AguYqPnFnbwdUaMzJ/40AihjGq7eOoAdZXUHoQfXF9dEHnp22EOojgWJa0qeW+1IrDZBIywdw28wdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716021105; c=relaxed/simple;
	bh=Lch0CTBgRocbTF3rEdXszR12O4GrBMzi+xNuvAXtOY4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j97ctgq9Ff8BP4TORGuz8Qdtf1auMuagRZro0M6bQfMONMWgywuQbnFQcdn/hhErxiJmLxm/u9BP0LxjcfjNWdeYUw24mHfBnansLgwlBLSi27p1gGa6c2hLGX/t89cPqZt8ERweVkLRRDJ/D2jZQXT56TSWlmcD2jjhG2uhavM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=XBcW6gyz; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1716021101; x=1716280301;
	bh=Lch0CTBgRocbTF3rEdXszR12O4GrBMzi+xNuvAXtOY4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=XBcW6gyzEL5dVI/Xl/upVwzqPYhqv703F/YBanepKcvo5IofbWGTaWpEvbqd/RloR
	 xOFWGklLdCR/CLav/d0Irx52niTtDOeQsQ++n85X24B260x+PfENtDxjh9UMgiLfiG
	 rg8ig4VzT4Xu6FnlHehD7/CP57ek7DcafUfTNmHKOD82t4mMgh6aVxsWlE9BBvQmdn
	 QrPh5tRxKKIh7Xhja4DXYIpvCidAQthCzqG3X0L8AiSlqU72INWHUMj546RzjrlaJs
	 NMPI/yK8KJ6DXSaZFKUPSY/efnqQZqMA5yH8ZjoCENR1rbDouGjY66jtlxdOm072CE
	 T5gXkaidomvmQ==
Date: Sat, 18 May 2024 08:31:36 +0000
To: David Wei <dw@davidwei.uk>
From: Mathieu Masson <mathieu.kernel@proton.me>
Cc: Jens Axboe <axboe@kernel.dk>, Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org
Subject: Re: [Announcement] io_uring Discord chat
Message-ID: <ZkhnYZ28Fl3SkB_N@cave.home>
In-Reply-To: <740aed6f-2ebc-4ad8-807b-bf1cef719313@davidwei.uk>
References: <8734qguv98.fsf@mailhost.krisman.be> <f7367e15-150f-4fbb-b026-73d9407fd863@kernel.dk> <ZkfZIgwD3OgPSJ8d@cave.home> <740aed6f-2ebc-4ad8-807b-bf1cef719313@davidwei.uk>
Feedback-ID: 50044778:user:proton
X-Pm-Message-ID: c790a05889ba030cf53cbb2a93253ea499d3a58e
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 17 mai 17:52, David Wei wrote:
> On 2024-05-17 15:24, Mathieu Masson wrote:
> [...]
> > Not to start any form of chat platform war, but the rust-for-linux comm=
unity has
> > been using Zulip for a while now. At some point they made the full mess=
age
> > history live accessible without an account :
> >
> > https://rust-for-linux.zulipchat.com/
>=20
> This looks and feels more like a chat/forum hybrid with discussion
> threads etc. I strictly prefer chat's lower friction but understand that
> it makes it difficult to archive vs threads.
>=20
> How are the threads created? Is it done at the start by the author? Or
> can someone just type and start a convo in a generic stream e.g.
> Filesystems, then an admin later groups the discussion?
>=20

Yes that is exactly like that. It's a forum hybrid, akin to what Teams is
nowadays, all conversation are tied under a topic. It's at the start of a
conversation that an author starts a thread yeah, by choosing a title for i=
t and
the stream in which it'll take place. This seems to be the trend among chat
platforms nowadays, to have everything under threads. Not that I particular=
y
like it but it has its advantages. If you want a more broader view, you can
combine streams, and there is even a "recent conversation" view that combin=
es
unseen conversations from all streams.=20

I guess discord originating more in the gaming world kept the pure chat
approach. If we want something more lower friction discord is the way to go=
.
(I'd say IRC but I see in another message Jens said it's a no go).


