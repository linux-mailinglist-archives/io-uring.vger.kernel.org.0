Return-Path: <io-uring+bounces-8879-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D117B18988
	for <lists+io-uring@lfdr.de>; Sat,  2 Aug 2025 01:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D09DB1C24E3F
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 23:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A128D204866;
	Fri,  1 Aug 2025 23:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8I4fvM5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755E1B644;
	Fri,  1 Aug 2025 23:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754091445; cv=none; b=bV1zHb607Ai7fUypXnlsxX8ao+w2h5EVNGQRtd/LK1iuA/jbwK62Fio3fQYkA5hrdJvME1HLYLzvpTGzrheOLpujNBxLWHc2VivUYfmmOJMMYmkGLvi0CfY5eNbLmKcR7HL+OEdziNzMp0bq+og37jqjLqBh2JS/Gc4FVtbY7Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754091445; c=relaxed/simple;
	bh=3Lw6EyKs9DVNBsvmQ6rKjTXElcD33ZmgPSpKAvhbB54=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kvI6Jv4EMsCnideNurjdTPE3EFPMmQN9PXofirTRLc3aceyyqz0xdoeYolF+08YHJPDhtqVB2AlzXwGwEXKBfX3DXpX5F7L6LB3c8kr5rsQdQB2EyPzD63pBKBGRKpax2cVDbGF3D8LW1OD3x4nfiYUtvVoVkQWfx4wBr6tlnpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8I4fvM5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A407C4CEE7;
	Fri,  1 Aug 2025 23:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754091445;
	bh=3Lw6EyKs9DVNBsvmQ6rKjTXElcD33ZmgPSpKAvhbB54=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p8I4fvM5HG0uyAa9UcvV0gQ4hYid7N5kGKfalUfoWGGOcuz0P1f6Bf/HAC9OB1+yR
	 ynIopBbmxK5uPI6eCfkha/2cBFb0ULZPay7PjkpkaACETZH72AZu9K9EtKAnRUz2mm
	 LZPSUi0h8bgOs1tuoJ04H5+2uSJ2z9bGB0iJqm7WA5xCkHiabJ1/k1v5m5Z71OdCZf
	 Qs16J+H86ahq9fynp5DE5L0faLse1ArcXddDzsJD9NnhFlH3j2XA8h0Pc5mNtbdQTu
	 CCVEsCwUpedpy0NVn6jC0wQMHqd4VVkQ5s9lJEZJDMjZeCYPY6wc3FcMOFHyUhWZbH
	 pm0yprFg/oouA==
Date: Fri, 1 Aug 2025 16:37:23 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Willem de
 Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, dw@davidwei.uk, michael.chan@broadcom.com,
 dtatulea@nvidia.com, ap420073@gmail.com
Subject: Re: [RFC v1 17/22] netdev: add support for setting rx-buf-len per
 queue
Message-ID: <20250801163723.1c0facf9@kernel.org>
In-Reply-To: <CAHS8izOZEpe1mDTFFM-LatqwJjXUV_f+ajrVK2S_=oBbpVXUZA@mail.gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
	<4db7b749277d4c0723f448cb143dab66959d618c.1753694914.git.asml.silence@gmail.com>
	<CAHS8izOZEpe1mDTFFM-LatqwJjXUV_f+ajrVK2S_=oBbpVXUZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Jul 2025 16:10:36 -0700 Mina Almasry wrote:
> I don't see this used anywhere.

Good catch, I think I was planning to reuse the full structs from
ethtool. And when I gave up I forgot to re-implement the checks.

> But more generally, I'm a bit concerned about protecting drivers that
> don't support configuring one particular queue config. I think likely
> supported_ring_params needs to be moved earlier to the patch which
> adds per queue netdev_configs to the queue API, and probably as part
> of that patch core needs to make sure it's never asking a driver that
> doesn't support changing a netdev_queue_config to do so?

I may be missing your point, but the "supported_params" flags are just
an internal kernel thing. Based on our rich experience of drivers not
validating inputs the "supported" flags just tell the core that a driver
will pay attention to the member of a struct. We can add new members
without having to go over all existing drivers to add input validation.

The flag doesn't actually say anything about particular configuration
being... well.. supported. It's just that the driver promises to
interpret it.

> Some thought may be given to moving the entire configuration story
> outside of queue_mem_alloc/free queue_start/stop altogether to new
> ndos where core can easily check if the ndo is supported otherwise
> per-queue config is not supported. Otherwise core needs to be careful
> never to attempt a config that is not supported?

The configuration is of the queues. The queue configuration belongs in
the queue APIs.

