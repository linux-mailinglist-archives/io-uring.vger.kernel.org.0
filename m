Return-Path: <io-uring+bounces-7705-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A87FA9AFE3
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 15:56:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94FCA18839E6
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 13:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51D04189916;
	Thu, 24 Apr 2025 13:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caXyGGzf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B94F142E86;
	Thu, 24 Apr 2025 13:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745502965; cv=none; b=oZYgucnOqLBSCdfFzdRYgm/mvoyV2IIwK1N1aZiawNhw03ipTf9XW1l4/1thdhp9uh3A3BHN4JYSfqFeowTmtF/m2X/KxoqYE2TBuKNk4nySipSAJO1rWoJ/+eOnZKTnbLlt1sbyS39Y5KBt6F8ior06ducKVrYrmggoo0BVhq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745502965; c=relaxed/simple;
	bh=HWkc+qPU5fZq58kwYodrIwEOOO/WI8snzEht9GrmZAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TE0qoYO5OkrfWoWg7qJAoTE2cyF7AYP5y5YNNgNUZCYumDmZ7S8/BtkfB0j6h4yJQQdFKGff4S2Di9yMW8fTZKEgFInDRaLndbDSsRt+SpHnp1bIgoPziiaXw+Txsj+HEpHfHRqHfiS4VWEj76Wbvu44L73cAeZHdaePjrPc7g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=caXyGGzf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A07C4CEE3;
	Thu, 24 Apr 2025 13:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745502964;
	bh=HWkc+qPU5fZq58kwYodrIwEOOO/WI8snzEht9GrmZAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=caXyGGzfz/rUf1xlEWxkSV0FJzxRsJYwH8B1TpR8Ou4ccWE/nBza0gh1N11qw/ceL
	 x4YZ7CDFUSl/HtsSZ+IbYShaN2zizpdZTLRKXbz4rxMVQ6kQNC/afDiweoAdepbakd
	 SI0GKy+6SwTKxRojL5+fuhNltAPEwJCQIzuU3Pr47i0xFw9uRM/YpoFyZElHhX13Wu
	 UrOF4ZFZ4nZDHUFPBJi8HU1c+Ia13uwRNlIeZ72HzEZvWkbudSpegocLBu93rH+znL
	 gB0jHSPL/1WFLkboj+my+PLm9Qyy/DJ517od+8VI2AquAWT4M/asn1Yvs12cjwtf3W
	 Bxe0DSUzuzvIg==
Date: Thu, 24 Apr 2025 14:55:59 +0100
From: Simon Horman <horms@kernel.org>
To: Haiyue Wang <haiyuewa@163.com>
Cc: io-uring@vger.kernel.org, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>, David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] selftests: iou-zcrx: Get the page size at runtime
Message-ID: <20250424135559.GG3042781@horms.kernel.org>
References: <20250419141044.10304-1-haiyuewa@163.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250419141044.10304-1-haiyuewa@163.com>

On Sat, Apr 19, 2025 at 10:10:15PM +0800, Haiyue Wang wrote:
> Use the API `sysconf()` to query page size at runtime, instead of using
> hard code number 4096.
> 
> And use `posix_memalign` to allocate the page size aligned momory.
> 
> Signed-off-by: Haiyue Wang <haiyuewa@163.com>

Reviewed-by: Simon Horman <horms@kernel.org>


