Return-Path: <io-uring+bounces-5950-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC25A147BA
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47B11188AF84
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 01:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6DB413D509;
	Fri, 17 Jan 2025 01:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWobnlhp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6B31442F4;
	Fri, 17 Jan 2025 01:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737078396; cv=none; b=MqeDjkK17MPiABsbtKv2+JSUfJb6WY/XKdVveHnSVL13KMUHyOA6IkJtz5lYOjl7knb9VE2uTsI6p2i0BqTZR1e6UJnB79K0RS6eJc9fonrz7UQMmAhHBkIO4/csMn05Yc9A5B38KJW9iOgYGgfGOEPWSInhp3il1DhMAlfhp2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737078396; c=relaxed/simple;
	bh=mhlfksy1xaml6LoQlTsKrIRqYevxA+r+vcoIHtgZaFk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cMNfOsSZXr15JRz/hUwDctaZK2vflXayqqj6EYWECtVOik+Z/WU3bOO3+08YFrt07pNEt/t4vbZ/2FJHojm8N5S4L1Y9W30hvEkyoVhx/5eQZm33gzk6qaKc4qyI8OCb0mBVeoLJfRVhDXUalbOHdjuGe02x6AVNoWm4wmA4hNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWobnlhp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E26CC4CED6;
	Fri, 17 Jan 2025 01:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737078396;
	bh=mhlfksy1xaml6LoQlTsKrIRqYevxA+r+vcoIHtgZaFk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aWobnlhp6fdH4kj5RtRwBfnYuXhY4X3bwrgwBCEIJska+acfd9kbAG+yfiQVJnmyK
	 KuikqDzosDq6wOLOCCh/ADswfsu+POHSu+YAfNoZXKNr1hvJYRs9UmZFbX+ozX2LMz
	 O71z5lrSnqLP8B3EvAZIhyhfZNNEa44vjy/DAHcZkTFwwrbdCDiNFcS8mVAkhUHNMI
	 MenCoTNRTR5K6myfYcENuWkzFKh+4BuayVIgzmGaF/f4vtdhVz9IWz9QUDl8bNfLQi
	 JEWq2AYB0eWldp37wADGz/eNJvIOl8V3Rs8KTmlWUORf2u/hI2JndjSz32zre56dYP
	 0nko7ww5uO6mA==
Date: Thu, 16 Jan 2025 17:46:34 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v11 04/21] net: page_pool: create hooks for
 custom memory providers
Message-ID: <20250116174634.0b421245@kernel.org>
In-Reply-To: <20250116231704.2402455-5-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
	<20250116231704.2402455-5-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jan 2025 15:16:46 -0800 David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> A spin off from the original page pool memory providers patch by Jakub,
> which allows extending page pools with custom allocators. One of such
> providers is devmem TCP, and the other is io_uring zerocopy added in
> following patches.
> 
> Co-developed-by: Jakub Kicinski <kuba@kernel.org> # initial mp proposal
> Link: https://lore.kernel.org/netdev/20230707183935.997267-7-kuba@kernel.org/
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

FWIW you still need to add my SoB for Co-developed-by.
Doesn't checkpatch complain?
I guess not a deal breaker here if I'm the one applying it...

