Return-Path: <io-uring+bounces-5897-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC40A12FFD
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 01:32:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FE633A6CC1
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 00:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C4E374D1;
	Thu, 16 Jan 2025 00:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJcQNRIQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9F0282F1;
	Thu, 16 Jan 2025 00:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736987421; cv=none; b=NpXtEYkFUMcxkThH4hAgjW6P+UoEi1VCq18bvU0Up3mp9dFmy+Im04w17TlvO9BQHKSz054WxxcZPyf/MpVIdjfz8bFiP/r531pmMHxDcpZOcvNIK/PNCA28K1CfPlO2aAlmhL3doipqzTcLSjjva494KdDx9YFAhrHTicJ+obo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736987421; c=relaxed/simple;
	bh=uu2rCKKiIYmq6AmFkw5b6WTtR4XPsPV22gSCA/qjWR0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HJizMPsSWotK9+HAjy3WtKNsjCC1d15DYOh0Vm1fwTwJWBdfwLHxM18MVXXYWcB8Ss/XeZ+C2kuQSJVMnnCuxr1Nj2tf8TaLWU06GTZViD1L5TsmW90EC1RX8bQh4kdhxy4Eam2UJfT+wAGnufCYW5ZdwQUNZkMhDj62VG9SwIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJcQNRIQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4117FC4CED1;
	Thu, 16 Jan 2025 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736987420;
	bh=uu2rCKKiIYmq6AmFkw5b6WTtR4XPsPV22gSCA/qjWR0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GJcQNRIQiaw1qZVVVOjwGXS7kyIoRRELFPBbmxJ95wg9SMyfPbHCQ0TnCZ7yJ4AkW
	 sQaayfMnrRzogL/m/pCZs8OcHpgjkzuMRUf2KslswQ9c6zytD1aBrPYoqu/xo6YtEI
	 QJtcZzROX42XNPc4RISnHOmeTtG2cD6fSxOUK69mf882CM0C/ZRzl/gRhBj9T+hw66
	 78LwOEDJtfLW74BELfkCe2u/o4UzcNxTCwI0aAeX0xgnq5/c4vjOm17cR/vjouGu7V
	 sD/4hhIHym27oCQCwjT5fhH2Vn1tQp4BFVvRvMKBMDjMmq0NmX4PCLG/GSpsWVbPuk
	 BadF7WjPZUV/Q==
Date: Wed, 15 Jan 2025 16:30:19 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 01/22] net: make page_pool_ref_netmem work
 with net iovs
Message-ID: <20250115163019.3e810c0d@kernel.org>
In-Reply-To: <20250108220644.3528845-2-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-2-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  8 Jan 2025 14:06:22 -0800 David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> page_pool_ref_netmem() should work with either netmem representation, but
> currently it casts to a page with netmem_to_page(), which will fail with
> net iovs. Use netmem_get_pp_ref_count_ref() instead.

This is a fix, right? If we try to coalesce a cloned netmem skb 
we'll crash.

