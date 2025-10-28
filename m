Return-Path: <io-uring+bounces-10258-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2001DC1283E
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 02:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 89252351E70
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 01:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC4522128B;
	Tue, 28 Oct 2025 01:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ifj6enJj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEF41FE44B
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 01:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761614305; cv=none; b=ny7iZAsYn84jm+KGOWw2e7BVcyPYZk2VOXEsAZkgQ1i4bYFIiaN9rw96iPAqyRS3KKKd035ThN7M33Tj11K0iXjbPelHMBc1NJRfC9a3NzOpzJv8rM8iwJCBOpEWfSfJ4/CLYnMxNvycmWE2Ga8y+MOtagwaB1vzihqwNJcePn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761614305; c=relaxed/simple;
	bh=ZT+8rXdhOqtuUN4exkm+U/zGybqTdoTMFRS4ezhp7PQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9g1SZ5szYeZydj/bx7pgJzAtfi4cOSZJCAoqbtp25FUL7p3A30XJrQGVPsihLg637YPQhx4Y1pWOUoKzdq6Dh8kx4nXG5/IhcD+2JpySLQP8ICGsgukBsmlS06jTpoNQ13pat/YZQJO2cA49h0rNO11YMYw0bZpZBCo9vXu9zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ifj6enJj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6D9C4CEF1;
	Tue, 28 Oct 2025 01:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761614304;
	bh=ZT+8rXdhOqtuUN4exkm+U/zGybqTdoTMFRS4ezhp7PQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ifj6enJjB/IAQdi+Im/6H0srwfChWH4V3vQgFwvx9dGMN+JV2jNtRVcDMv4dnbOVr
	 GhFE+WHR2QUOjiZZuB8EwKFX3sazHKLxKbjXkCPINyk9xZVNkXLhJ3sA+9l0Kz4W0Z
	 g73+TPTDxA5w7Q2xbL3YQZClcZq9wbUln/IiOO7XV/kdVqwaBIkNvOTBKDYgZvoOPA
	 Jvy1/f1ZEhwIQOqmsjZ2csRISo+V8kr4BTYNNDFoABj8kCrDEgcS17HEZ4cImyqZVM
	 Htc+b8P6jWsn+fMumUws75ogV3hysD0svuPkkyewYueIoA3PUDvc/5XEAShLoG7Wp1
	 7tNDItLtGjg6w==
Date: Mon, 27 Oct 2025 19:18:22 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/fdinfo: cap SQ iteration at max SQ entries
Message-ID: <aQAZ3oCSkQFmbyPi@kbusch-mbp>
References: <85801cc1-082a-4383-877d-67cc181a50c6@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85801cc1-082a-4383-877d-67cc181a50c6@kernel.dk>

On Mon, Oct 27, 2025 at 07:12:08PM -0600, Jens Axboe wrote:
> A previous commit changed the logic around how SQ entries are iterated,
> and as a result, had a few bugs. One is that it fully trusts the SQ
> head and tail, which are user exposed. Another is that it fails to
> increment the SQ head if the SQ index is out of range.
> 
> Fix both of those up, reverting to the previous logic of how to
> iterate SQ entries.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

