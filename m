Return-Path: <io-uring+bounces-8407-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD2B5ADDF0F
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 00:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BAC07A9B55
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 22:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A04420D4FF;
	Tue, 17 Jun 2025 22:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NIB5aJbV"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDF52F5316;
	Tue, 17 Jun 2025 22:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750200066; cv=none; b=I7GkYcW4k0+V598kr1V+eYPFAFoahVqi9ybEBRN1csBtQVnJcLB5RCDV60K+sHmSlBCTEILzPfQIN2pWIit4pRfnp12jupaQ9NqjjrUDz7R4oAtCDC3c1rLHcY5wUEb62GntBwysJuvVSy0gu0B7ftxfri9X7bGHaeMGW65X6rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750200066; c=relaxed/simple;
	bh=tQo8KDmbcmwwW3t38wbwAKEqD0oRAHN2BseOqSPMUBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fWlLg5ZnbmTXoB7FpSlf/80ZDJBBryXYjlYqlyZxmpUv4SuEEvp0E11VzlzXq56TU+o9noRi24RdOVeqWs+0kt7lT2EDMlaf7rMNc9gJWljyw1mnmJTBiRxLDYGKrp6SiYG24RZX4pVLnJcxA53zAi3E5nuUDJbf6yzBAqFRtlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NIB5aJbV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B5CC4CEE3;
	Tue, 17 Jun 2025 22:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750200064;
	bh=tQo8KDmbcmwwW3t38wbwAKEqD0oRAHN2BseOqSPMUBQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NIB5aJbVTxhengcICaOuhkZLgPegniWqPyTqGMNi8s5uWVi0GX9wY0GxvdF87yhii
	 TdUQZMHvMdTH398/8wC5wJ0pJMonILMMNareHpntTQHok1x39b2s3VcmjtI+wTc8c1
	 EcGMv0m1HAcdTEM4wI/xc6sZWu04bGj4ZCi73dXARz4+PzcWxyrqnhyC8BlbPRhoxF
	 gXXhdwAocZJqVsa3Jx3C153xSNRpZcalPyfIskB80TTH84jBZSD08ofdn2AmMqyIXq
	 5morCmWG0OjTvUDVNKV1TZ291b8tAzXbX7aV4CnmShPUo7oA13UYGnXwqc/G94Gh68
	 UHZ1JaYUohvUw==
Date: Tue, 17 Jun 2025 15:41:03 -0700
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
Message-ID: <20250617154103.519b5b9d@kernel.org>
In-Reply-To: <520fa72f-1105-42f6-a16f-050873be8742@kernel.dk>
References: <cover.1750065793.git.asml.silence@gmail.com>
	<efd53c47-4be9-4a91-aef1-7f0cb8bae750@kernel.dk>
	<20250617152923.01c274a1@kernel.org>
	<520fa72f-1105-42f6-a16f-050873be8742@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Jun 2025 16:33:20 -0600 Jens Axboe wrote:
> >> Sounds like we're good to queue this up for 6.17?  
> > 
> > I think so. Can I apply patch 1 off v6.16-rc1 and merge it in to
> > net-next? Hash will be 2410251cde0bac9f6, you can pull that across.
> > LMK if that works.  
> 
> Can we put it in a separate branch and merge it into both? Otherwise
> my branch will get a bunch of unrelated commits, and pulling an
> unnamed sha is pretty iffy.

Like this?

 https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git timestamp-for-jens

