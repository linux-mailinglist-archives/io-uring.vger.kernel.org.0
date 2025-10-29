Return-Path: <io-uring+bounces-10288-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B9E5C1DCE1
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 00:51:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id ED89934D1CC
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 23:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E852BD02A;
	Wed, 29 Oct 2025 23:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CURIbAjj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B332253A0;
	Wed, 29 Oct 2025 23:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761781905; cv=none; b=nY9Iy9rgSltSrmEg3efGtjbi7MknuGg71GjsUFdiyk6xhb9ne9TwGpx68p7FCqGpsPFySPeW3naAUi3YkxlxKbk4hVCZJONkdXPLax/Kd6H3LJFI0NN9wBUKUvY1+eBgX1qQS1kQUi4UnxAaIcx2zsuvFWkeB9x88d3NW1ApAX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761781905; c=relaxed/simple;
	bh=bemvtufsqEuublejEd0iHnY077YL2bDIHuKx8v68uLs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U8s7RWDn6VY2ro8KbIox1RQN2+vo1A2dQpsMDGZbNxUUq1GSdGhjprpKIlO0zlO0lygLIlRxjEvbvbZBnP/eAbyGkc2dpdi3N/ZyWGK/H6hL3OgeDuaXwy/H3k0Oz3KxyxTn2Gf9ZaNRjtJyapSI/qfMAZUO3Jb6Ums/D3F6ILc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CURIbAjj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CD9C4CEF7;
	Wed, 29 Oct 2025 23:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761781904;
	bh=bemvtufsqEuublejEd0iHnY077YL2bDIHuKx8v68uLs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CURIbAjjJcvJMiB89JuWBFPHPKX8FLZ4XVvsvd41U5D8v1+Iqo+KDyUmDJ4lvgPXZ
	 wIAQNOECZTj4TITgFeGuDsTTbuoP2oxVoPHZ6XG05zx/O4tFiuNlarljKUklmp1qCf
	 moaLrS+CJDJZmAfdtftIV8VdIYuj+BTnxBN1l7jHmK7gp2O6cqKV7RidQ/S5/LW6xB
	 8cL1dWabhEuR2545w4xz2k9orIBU664aRy2rbOTkeuq/UM10O/ZZssJgwAqPtsbDXO
	 +4ujTxbssbmd4neU3I2t0l0MSL0iJDUUluV1Sl9WFBElR3feCKRyz5w4TMo31oEEOA
	 RTuJB0JsjxOaQ==
Date: Wed, 29 Oct 2025 16:51:43 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH v2 1/2] net: export netdev_get_by_index_lock()
Message-ID: <20251029165143.30704d62@kernel.org>
In-Reply-To: <20251029231654.1156874-2-dw@davidwei.uk>
References: <20251029231654.1156874-1-dw@davidwei.uk>
	<20251029231654.1156874-2-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Oct 2025 16:16:53 -0700 David Wei wrote:
> +EXPORT_SYMBOL(netdev_get_by_index_lock);

I don't think io_uring can be a module? No need to export

