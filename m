Return-Path: <io-uring+bounces-10108-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F507BFC8D3
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:32:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F2CE74E2F0A
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 14:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7D832B994;
	Wed, 22 Oct 2025 14:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQRK0H4/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7095B2ED161;
	Wed, 22 Oct 2025 14:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761143458; cv=none; b=sd8wI/1TLikST+an+hEsCQe1gfwAFvN8ipkvv0axvlloc0E3tR6HDQCTufmdIWb05tPuPqKPL8l1OIJ67YpWj7gEs7X25nUN6r8u5rQ1RwSRQxfw2lqvYy5C14TfMgtLjwHi69Co/7DznCMYGZWD6zq3T0QC8s6vkq8QilxeG20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761143458; c=relaxed/simple;
	bh=GA8qvF2o7C2MaqXDTf3c/TUftPeR4pzwJK8Gi65e6F8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nSeXKq2PRCXWzKafn9NoTK8boZDZr8YuaodWQejg3xIvouF3XCRWA2VZtPnpc7J3JANguQ878m8/X8VFkGb2HemzoroNZ+xIVXmby3YGSL28g82K5dLY0WdSxumKPnOXu0VIMV7qhk29iX7d9Apc5KO2bBGAHKsvFEg7M5lzqY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQRK0H4/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AFCC4CEE7;
	Wed, 22 Oct 2025 14:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761143458;
	bh=GA8qvF2o7C2MaqXDTf3c/TUftPeR4pzwJK8Gi65e6F8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hQRK0H4/KsDYb6Iw/JbmxwLy3Zi2EsN3HY+oGg4fSpZkxB23/hDPd6bNsz1v7rKvj
	 tTioIQyd5wMZdsRFi6NwYlRgJapc6gy7gsh1CFj/Gj8Se3ckAb1GNZQTxgRqinqlqk
	 x5X71rmLDzlQoAD5tcRJJwwdax2KfXOogTGOfYVnJVhMubBcllwMXUgmX51B/8o3+t
	 louBS25Vld4JBTW5Spl0vqsLq5l0ZehNAo8RvrWU6csGctCgFXWbeEkzHc22TsYlzS
	 +tot2KYVos2V5x4fAj/Q5hRpvPwphOjfAkPRaRgYtNP15qoSMAKv8jE4gsiPdBRTNt
	 1P+QOn1bAFMkg==
Date: Wed, 22 Oct 2025 08:30:55 -0600
From: Keith Busch <kbusch@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH 1/1] io_uring zcrx: add MAINTAINERS entry
Message-ID: <aPjqn2kdgfQctr-0@kbusch-mbp>
References: <20251021202944.3877502-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021202944.3877502-1-dw@davidwei.uk>

On Tue, Oct 21, 2025 at 01:29:44PM -0700, David Wei wrote:
> +IO_URING ZCRX
> +M:	Pavel Begunkov <asml.silence@gmail.com>
> +L:	io-uring@vger.kernel.org
> +L:	netdev@vger.kernel.org
> +T:	git https://github.com/isilence/linux.git zcrx/for-next
> +T:	git git://git.kernel.dk/linux-block

Is git.kernel.dk still correct? Just mentioning it since Jens recently
changed io-uring's tree to git.kernel.org. I see that kernel.dk is
currently up again, so maybe it's fine.

