Return-Path: <io-uring+bounces-385-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F74882A064
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 19:46:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D13282867EF
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 18:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 742C8D51C;
	Wed, 10 Jan 2024 18:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oexaswOe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4434CE05
	for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 18:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F64C43601;
	Wed, 10 Jan 2024 18:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704912383;
	bh=3sZbPwQ1UDxh+oBKPpBulcOz9IsZKopDz5c/h4RqvVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oexaswOeYj231+q8yUaF6dGMg+w7AAMhf7FNRkBIQ5RVHMu97JCxUoXea50ZU2w2F
	 Yr2UymtQlpcGHNKHo706AgTP2G7Tb0038NVs1lhc2w3C5TZpA9j7kQiRv/m9om23QC
	 IgbjRjUaQZaV6frPUR3n91R/lGwNXL2hbvve87t6r2+KKwtNvJGifhWda3aPqDnTEO
	 MTgg7mo9l/WCCGjOnRvXRCEXU6KL5xKl+BbNJMvNGLavzyy7FOmW1XXVnNxpVAjjXp
	 vBrgCoxFRBwCzoyGdO0jyNH+AyCbcpg7ABRbSuXVcLTkmV/i0KN2V8PS99ELGwZHRc
	 MDNAjSzqTD1KA==
Date: Wed, 10 Jan 2024 11:46:21 -0700
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v2] io_uring/rw: cleanup io_rw_done()
Message-ID: <ZZ7l_VnxD0D4snKO@kbusch-mbp>
References: <cbc9efdd-9b38-4f6a-8cdf-b603d26db6a3@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbc9efdd-9b38-4f6a-8cdf-b603d26db6a3@kernel.dk>

On Wed, Jan 10, 2024 at 11:38:02AM -0700, Jens Axboe wrote:
> This originally came from the aio side, and it's laid out rather oddly.
> The common case here is that we either get -EIOCBQUEUED from submitting
> an async request, or that we complete the request correctly with the
> given number of bytes. Handling the odd internal restart error codes
> is not a common operation.
> 
> Lay it out a bit more optimally that better explains the normal flow,
> and switch to avoiding the indirect call completely as this is our
> kiocb and we know the completion handler can only be one of two
> possible variants. While at it, move it to where it belongs in the
> file, with fellow end IO helpers.
> 
> Outside of being easier to read, this also reduces the text size of the
> function by 24 bytes for me on arm64.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Looks good!

Reviewed-by: Keith Busch <kbusch@kernel.org>

