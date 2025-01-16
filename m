Return-Path: <io-uring+bounces-5898-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54F3CA13002
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 01:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7FEF3A3402
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 00:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4AA1C69D;
	Thu, 16 Jan 2025 00:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgyV8mAQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB4912E7F;
	Thu, 16 Jan 2025 00:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736987503; cv=none; b=lYYqYaMB08G6DGWRbiGdsjXYpjgEoMm2k9PaPc3Lgy9R+1u3zEKCz82IIwKv6KQSq0TfiG0wnsPXqpuaBT3Lomeah6Q140VfPkXBOh1rCj9c22yN8GWXma3eq4v3gM94k1PmitGzut4lY4LR2LnhmPqBbBEGiM69I6xwT8LJ40E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736987503; c=relaxed/simple;
	bh=JpdHeFYrUzOsmEV8Ag/S6kjj+qN2n9spX+IXVLEYab8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H2IQrSrqGQLKnefVTPnYiWwjfniD0iqyYBRTB9RvqFSRKJWBhhi3dYgcv0ZwhVOms8WD9s4R8V9E7sC4LhBi9WPomwnRuFOOnUgglWY/fNcS6/9X/x1ZwUCD3uMKvT+KM9MADxyvzcxVxCDytKABZ+RSbnNsiEB2kJyet9QShzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgyV8mAQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A41C4CED1;
	Thu, 16 Jan 2025 00:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736987503;
	bh=JpdHeFYrUzOsmEV8Ag/S6kjj+qN2n9spX+IXVLEYab8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QgyV8mAQTcsBPvU+j5Fzz52jqaFliILZKfljiAPzB7HwgGPj8QtvC7cDjV67bN4LJ
	 EiLlBTLNqef7PFfjhWDOYdxvI3hTmsNTOsTo5mQ+iQfW1ozewxg4hFMPJJ4hBY61jN
	 WRf313jgY/YwjSJ4OxG9d50cKFj054vvFT2I8/7Th5qPdva91IJUlIRJfMDZXk5K+D
	 YCMEpWyxaho1eGXDpFcA3VJl5Mt6iGwrirgrUgtnIJsm8rCvkeoW/cj3aepPFPhpvJ
	 GGsA5Vei8xdOPcXxy0ignKLpUdxFvqXfzoxfLfgV+V9QcGv0/I8TpdQrbwiZKnII30
	 kvxDJr+PUA3bw==
Date: Wed, 15 Jan 2025 16:31:41 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 04/22] net: generalise net_iov chunk owners
Message-ID: <20250115163141.14feb403@kernel.org>
In-Reply-To: <20250108220644.3528845-5-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-5-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  8 Jan 2025 14:06:25 -0800 David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> Currently net_iov stores a pointer to struct dmabuf_genpool_chunk_owner,
> which serves as a useful abstraction to share data and provide a
> context. However, it's too devmem specific, and we want to reuse it for
> other memory providers, and for that we need to decouple net_iov from
> devmem. Make net_iov to point to a new base structure called
> net_iov_area, which dmabuf_genpool_chunk_owner extends.

Acked-by: Jakub Kicinski <kuba@kernel.org>

