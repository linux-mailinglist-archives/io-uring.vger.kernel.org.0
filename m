Return-Path: <io-uring+bounces-8443-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7510AE22F5
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 21:46:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 486141BC6450
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 19:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7931E47B7;
	Fri, 20 Jun 2025 19:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNvAgwdr"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8AA1E1E06;
	Fri, 20 Jun 2025 19:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750448804; cv=none; b=Uw5SlvfNkCeDq/Cuywb43sMWgDg61jfE1Pa4q/5VATVVr6w/BVHenLdhV1VY5DvK7bxyU8rB7SaIutZHpb97lTk8o2bLh4r2TL6AGnxV/atOM1zUFahlsZieSWmWhjNQ7Gpt6Qv7QK9Tg+U7jw/HiDZNcNYEp28I3oHVCI7zHiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750448804; c=relaxed/simple;
	bh=XKQy1eijsuIkPNtOtV8tjevslqQaXuxXOozf5ccMQpw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qr1Nu4AGoJ2WWiozK8Q4esTwgwLGJ6NHpsbo+1VWxZZmP3cTuiV/tHaLJPSEaVWiQaqJwn+44t7DSzURbApLJKDV70AnikY/eCPm/BmPzTsKAcS1RI8ZkCt/oyTehyCxTsUTnvEX3szzMJ5pnVq/SoPgk4wHKP7vFxJINUTK28A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNvAgwdr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F27C4CEE3;
	Fri, 20 Jun 2025 19:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750448804;
	bh=XKQy1eijsuIkPNtOtV8tjevslqQaXuxXOozf5ccMQpw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kNvAgwdrMIVpOvYDpPK9sZZvfBH6W9oEjjZRT64vlj3NnxRuxDpCEIrPDF6PgC/zH
	 q+M2Wd7z0k6jGeyzghSmx+0ZxOg6hblddQ+hv4UhnNgUVgFCYUJzdklaGi8r8Gjgdy
	 o1c4+pCPnGo7/7IffxhBtUvaQz4LQDOcA3fMjRS0LZmVKZ13OBggBhAWZjmgBqF/Hi
	 DpfFIxH67WBigFg5577dRdye+n+yTf0bdeBn8Z8vwRMDhubziEUzW6l4w7aZQtyso3
	 XrZMVMlOIr1Ivc4Lqpxn9iE2NDQFFQMaewS3QsbOVwRZP7E0ffjdszQdak0kgweI6i
	 zVxXOIWnx1csg==
Date: Fri, 20 Jun 2025 12:46:43 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, Vadim
 Fedorenko <vadim.fedorenko@linux.dev>, netdev@vger.kernel.org, Eric Dumazet
 <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni
 <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, "David S .
 Miller" <davem@davemloft.net>, Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing
 <kerneljasonxing@gmail.com>
Subject: Re: [PATCH v5 0/5] io_uring cmd for tx timestamps
Message-ID: <20250620124643.6c2bdc14@kernel.org>
In-Reply-To: <1fb789b2-2251-42ed-b3c2-4a5f31bca020@kernel.dk>
References: <cover.1750065793.git.asml.silence@gmail.com>
	<efd53c47-4be9-4a91-aef1-7f0cb8bae750@kernel.dk>
	<20250617152923.01c274a1@kernel.org>
	<520fa72f-1105-42f6-a16f-050873be8742@kernel.dk>
	<20250617154103.519b5b9d@kernel.org>
	<1fb789b2-2251-42ed-b3c2-4a5f31bca020@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Jun 2025 08:31:25 -0600 Jens Axboe wrote:
> On 6/17/25 4:41 PM, Jakub Kicinski wrote:
> > On Tue, 17 Jun 2025 16:33:20 -0600 Jens Axboe wrote:  
> >> Can we put it in a separate branch and merge it into both? Otherwise
> >> my branch will get a bunch of unrelated commits, and pulling an
> >> unnamed sha is pretty iffy.  
> > 
> > Like this?
> > 
> >  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git timestamp-for-jens  
> 
> Branch seems to be gone?

Ah, I deleted when I was forwarding to Linus yesterday.
I figured you already pulled, sorry about that.
I've pushed it out again now.

