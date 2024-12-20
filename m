Return-Path: <io-uring+bounces-5580-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD449F9C88
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 23:04:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B82BC169192
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 22:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42CBB226529;
	Fri, 20 Dec 2024 22:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rFX7Q1vE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF29225A5C;
	Fri, 20 Dec 2024 22:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734732278; cv=none; b=UTqZ2W7OrcCsHnU9F10bdhedmIeaQY5XfxTcvETexn1tLUgfhe+IpcGwRsDVLsaTkR57R2uZRN3b3DMhhplP9pmeiQE8ilMO+esAJzFh4hp+D0SUhFM7yk8OPvsJDcLBf1VdxHWfLFsNMZi9VPPhtCaYUmca/Om5Co1+PurBHgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734732278; c=relaxed/simple;
	bh=UEpo/KDU/IQvfM9Ecia/UVFKntjlaPRONeKIf74s0Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MC5O0gTR2X9lQVjfMn2NtMEe4AfTmqn9LALwtLTWoCKoIR1pKeI008n+Nmd8YutWGxVkPtHoKJuKb6UQ7pCRUUSyqIQsI9CYC7pqI6BNDQ0Kv/0/hqjI9fEVSlmWooqRyEqnaPDdJGi/qZnjODaSA6ip/ueJ9AacuhgcgaPBqKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rFX7Q1vE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DB6C4CED6;
	Fri, 20 Dec 2024 22:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734732277;
	bh=UEpo/KDU/IQvfM9Ecia/UVFKntjlaPRONeKIf74s0Ew=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rFX7Q1vEQaTIbiF+2ETvkMBDuX7gAgdNjgD//QsgdYIpw/uLz+o7DK9VLkbKIhyno
	 IVCq1dIRxxqJ7cUDNYtgwO6u0p6PbSjAfE+vDSSFpcePZUCN41pE9l2eD3DTBkXSwN
	 uSxys+u/XY/H+VUfAU9Cary0Zj/uYQlmcyvp7P3/mfGXzTNiCZgEhWj/6GojxVoJtj
	 2fBWTCrx2o97+Q7eBZJlqPZgkGu700b/Nxc/T7LjPULm72GlEOl4FQqYH+jrlG4o22
	 N+Vyh9KnZDdqQ2jS801R2E9XiIj1BbR55LeIpVxO8kaopnm3JKDLlrOQUVgRmakTUI
	 fsC+3D3D3k0Gw==
Date: Fri, 20 Dec 2024 14:04:36 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v9 01/20] net: page_pool: don't cast mp param
 to devmem
Message-ID: <20241220140436.20f18e35@kernel.org>
In-Reply-To: <20241218003748.796939-2-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
	<20241218003748.796939-2-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Dec 2024 16:37:27 -0800 David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> page_pool_check_memory_provider() is a generic path and shouldn't assume
> anything about the actual type of the memory provider argument. It's
> fine while devmem is the only provider, but cast away the devmem
> specific binding types to avoid confusion.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

