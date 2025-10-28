Return-Path: <io-uring+bounces-10276-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DCDC17355
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 23:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14DCD402618
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 22:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 925913557FF;
	Tue, 28 Oct 2025 22:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="opqRAjGn"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684B42FFFA3;
	Tue, 28 Oct 2025 22:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761691102; cv=none; b=abyyLGRWbPzwsd0JbFYUiNF3tKlbfeiNzq+BGZdQG0BTjLymmAmehXtKP/TzqJxHRJdkEUA0o9wPSpRV9AEeQU+RfAyWeoEBsxT1I4rUxzX7Qcc9GfVEv5NL2RYopBi1Vbav17GWzrY0b1P1EsXqLT/tvEeShpbEBGYBMTag4+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761691102; c=relaxed/simple;
	bh=cSronspnQ353mSwFCtOYM5GBrBApOt74sWD+UA22Xyo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lFyZ7jsLi8CwBs6VRguisQFC3TIEtjQiVcsBGYsAQe+/z2luA65zZqoD2Dl47CFu0RzzOQCVCqLXxZFdAuRtmsCHNCNZ83hhqT1qG8pBLFdEU0rqLlc9CH6N/d+WEfw+F0/KyewUNoHn2UhOBZzNKn2A4UHuiiPetm17iwX8low=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=opqRAjGn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2FCC4CEE7;
	Tue, 28 Oct 2025 22:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761691102;
	bh=cSronspnQ353mSwFCtOYM5GBrBApOt74sWD+UA22Xyo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=opqRAjGnl5e25OfOQNfCN5V5OCZeXEYaqOQFpe0iEKdcOR/eCIq4Xhd+iNqcHnpmo
	 do8H5EG6T9FkiJpzmVNN8Klus1mvhaM6H2xO1EL8z/ze11KD3x7rmFud/u9pY+EDXl
	 tZtO4vrnEWb+VILaNkatZi7yL19z1G4UtzJZQpab630hofwqXG9zyYdbaA7x8ff8VD
	 5UxXWCd6uH3tGguYBlFSowLVgZMjmXPzb5N4DM/XHzaKNVsskrps4uOmIfdPwSg5ti
	 hD6qjO7x83e+ZuI2ZfbGDs4k5J2dfSTVfR5TyVjw4+t31Sw8QTst+C7zm6wHVTSizx
	 Cow7QPHqMpzjQ==
Date: Tue, 28 Oct 2025 15:38:20 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net v1] net: io_uring/zcrx: call
 netdev_queue_get_dma_dev() under instance lock
Message-ID: <20251028153820.414b3956@kernel.org>
In-Reply-To: <20251028212639.2802158-1-dw@davidwei.uk>
References: <20251028212639.2802158-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Oct 2025 14:26:39 -0700 David Wei wrote:
> netdev ops must be called under instance lock or rtnl_lock, but
> io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().
> 
> Fix this by taking the instance lock.
> 
> Opted to do this by hand instead of netdev_get_by_index_lock(), which is
> an older helper that doesn't take netdev tracker.

Fixes tag missing.

netdev_get_by_index_lock() + netdev_hold() would be a better choice indeed.
Just a reference doesn't hold off device shutdown.

Is there a chance to reorder the io_zcrx_create_area() call, keep
holding the lock and call __net_mp_open_rxq() ?

