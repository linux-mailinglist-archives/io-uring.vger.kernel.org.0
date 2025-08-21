Return-Path: <io-uring+bounces-9134-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A5EFB2EAC3
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 03:37:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0930684F18
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 01:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DB7242D62;
	Thu, 21 Aug 2025 01:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S112F9kW"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772B924167A;
	Thu, 21 Aug 2025 01:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755740233; cv=none; b=G3qXyZf1d5q10/PAhwzwpey7yX9vFZEOeqbPyYiuPS6kPFpXygFfGWXaI8IHjcMZU1ZL6IZsC03EiNA11szsIsp5evV46dX0KDz8HhJNTqR2R4b9Rw6vlqroUI0pqz8xazZyLSLptUgJixRXnAdngHogQ6WwNAcQWQ3U5/hY4p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755740233; c=relaxed/simple;
	bh=N0XCA6eoElM2GHMVUFBlv8c3qmMMno3R+pQmAkikF+w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aeq7Af4F68eZjUfgvquLsksbd7rwguuMwjJ30WRx3zqIojPqt+jvmQ76Js0eTWMR4GWdy5rngeEaDbiiTtJ8c3hVX1ZkS/hjIacGfInnubX6IzoYlU/P4r7HNrVZlSVBBG5+ohX6DN1IdYAnNCfiet2JfJYTpUFevG2so4tziSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S112F9kW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FC5C4CEE7;
	Thu, 21 Aug 2025 01:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755740233;
	bh=N0XCA6eoElM2GHMVUFBlv8c3qmMMno3R+pQmAkikF+w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=S112F9kWmHQjxzdAGtwDE/fZztkPFSeFLm1rc7m/vWoyfx0BeZRY8iFX/f3k5AA4r
	 kDtWmqtoVZs7yyvBi+qvmaKcqqgXBCiRJespZJwQexiU+Tllp7NTUB6D1s8Xahp4Gt
	 J4vM6TG6xeQMCKXWgHq+DFP1CpmeQ36+e3HCdXMUsEHI3ovALMFWZ2LiN360TtDZxs
	 LIrBfycDQLW7OGoMhWBkePdPNcSDudGDIrylahQuFqxU5KMM3is2mvA1niFJMwVyR1
	 2HRUvhkiOjz88HUFDrqtScrUWmF4DC4JOSeXdlARpe01kbV6gfInZcPIcvoI7MoHtD
	 uleXau7kG14OQ==
Date: Wed, 20 Aug 2025 18:37:11 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Willem de
 Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, almasrymina@google.com, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/23][pull request] Queue configs and large
 buffer providers
Message-ID: <20250820183711.6586c1c6@kernel.org>
In-Reply-To: <fb85866c-3890-41d2-9d5c-27549c4b7aa3@gmail.com>
References: <cover.1755499375.git.asml.silence@gmail.com>
	<20250819193126.2a4af62b@kernel.org>
	<fb85866c-3890-41d2-9d5c-27549c4b7aa3@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 Aug 2025 14:39:51 +0100 Pavel Begunkov wrote:
> On 8/20/25 03:31, Jakub Kicinski wrote:
> > On Mon, 18 Aug 2025 14:57:16 +0100 Pavel Begunkov wrote:  
> >> Jakub Kicinski (20):  
> > 
> > I think we need to revisit how we operate.
> > When we started the ZC work w/ io-uring I suggested a permanent shared
> > branch. That's perhaps an overkill. What I did not expect is that you
> > will not even CC netdev@ on changes to io_uring/zcrx.*
> > 
> > I don't mean to assert any sort of ownership of that code, but you're
> > not meeting basic collaboration standards for the kernel. This needs
> > to change first.  
> 
> You're throwing quite allegations. Basic collaboration standards don't
> include spamming people with unrelated changes via an already busy list.
> I cc'ed netdev on patches that meaningfully change how it interacts
> (incl indirectly) with netdev and/or might be of interest, which is
> beyond of the usual standard expected of a project using infrastructure
> provided by a subsystem.

To me iouring is a fancy syscall layer. It's good at its job, sure,
but saying that netdev provides infrastructure to a syscall layer is
laughable.

> There are pieces that don't touch netdev, like
> how io_uring pins pages, accounts memory, sets up rings, etc. In the
> very same way generic io_uring patches are not normally posted to
> netdev, and netdev patches are not redirected to mm because there
> are kmalloc calls, even though, it's not even the standard used here.

I'm asking you to CC netdev, and people who work on ZC like Mina.
Normal reaction to someone asking to be CCed on patches is "Sure."
I don't understand what you're afraid of.

> If you have some way you want to work, I'd appreciate a clear
> indication of that, because that message you mentioned was answered
> and I've never heard any objection, or anything else really.

It honestly didn't cross my mind that you'd only CC netdev on patches
which touch code under net/. I'd have let you know sooner but it's hard
to reply to messages one doesn't see. I found out that there's whole
bunch of ZC work that landed in iouring from talking to David Wei.

