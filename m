Return-Path: <io-uring+bounces-10356-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 498BAC2E79A
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 00:49:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE5C03B58D0
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 23:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40AC82FF15D;
	Mon,  3 Nov 2025 23:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZayl1BE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160972EDD75;
	Mon,  3 Nov 2025 23:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213650; cv=none; b=h6CcZ0fnr6urMZuaZnSCgWNocOEKrNH48yooGr7AyydfF1ec+QMpph6y6aLXx/Znja0Gb6uiz1Yxib1g9o+50h8CgSh68n++oD9jlCZ/lPYNwjFTKH3YB/9SpPUCGWU7DY9UBXDjMS2UsF6RX00Y1RjGS0Y+Rx73W5rQGOg//UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213650; c=relaxed/simple;
	bh=iUzoFwDTLo00PycpPPKZbu7zUwSW01hDKgdUob39h1E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DMCSU/7XU6wMuEyFcIWPC9hp2vGciLDbBhgW9xXoobKzALZyevjSu7DieopHpT4Uamzq8+J+pOscqZxTHslP32BbDOQDS8zAbFTV6vl/gauiefnbjZwHF+euNyGBLBdlE4QGsTqY+8fmdfgFxmcBsSYgMNxrZUwSrYm1yQU32v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZayl1BE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB8CC4CEE7;
	Mon,  3 Nov 2025 23:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762213649;
	bh=iUzoFwDTLo00PycpPPKZbu7zUwSW01hDKgdUob39h1E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AZayl1BE1ZhjdSHn4NcjUYUF0A2aySVZKd3OXwppgZTxufCoQOKUSzCl7DDBqj4J3
	 HoEud+Dlrqark+qhsQt+DD0qkSyoOu4FkH8Pu1UI0WIjL7LHvGyoDVflAYun7gal1n
	 QCQZ9JmAphf+H8PKiTM96iovL49SqmWjpsedh7fjapzgln5QwI3jtez3gatmO0RHwl
	 +Kh6ULySp27Cwf2mUooQQWDnoWYA4X0tdUDWVPdRvKR3iRBg6v7QdLRx4vyLkwM4MP
	 hVCys3RzzpmIYFtXRJzznzcemsXyHQuiqv+RVx/mo8pYC/MfCCvFWxABFlmK668jIS
	 61elpKr5Zc5ZA==
Date: Mon, 3 Nov 2025 15:47:28 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH v3 1/2] net: export netdev_get_by_index_lock()
Message-ID: <20251103154728.79c8eee4@kernel.org>
In-Reply-To: <20251101022449.1112313-2-dw@davidwei.uk>
References: <20251101022449.1112313-1-dw@davidwei.uk>
	<20251101022449.1112313-2-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Oct 2025 19:24:48 -0700 David Wei wrote:
> Need to call netdev_get_by_index_lock() from io_uring/zcrx.c, but it is
> currently private to net. Export the function in linux/netdevice.h.
> 
> Signed-off-by: David Wei <dw@davidwei.uk>

Acked-by: Jakub Kicinski <kuba@kernel.org>

