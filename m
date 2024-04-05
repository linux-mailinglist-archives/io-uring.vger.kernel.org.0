Return-Path: <io-uring+bounces-1401-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E459A899A2F
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 12:06:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 833EC1F22D3C
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 10:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D6E316132C;
	Fri,  5 Apr 2024 10:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R4E070CU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233C427447;
	Fri,  5 Apr 2024 10:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712311568; cv=none; b=D2+GNGhWbaDKarp12olKjo/Da2oCBrsx+jPtQI1NCYcrm0HYTLVgs3KlxirxDXza+Wb+3nOpikSywUIO7oeULNVExVJD/Zu75at7rMlPj2zf40lPfWk6FCEG610tisUemDGNPj0j1TXTd6cNOkXvrQ2+h0OxbbjxySHHy9y7LnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712311568; c=relaxed/simple;
	bh=Me5fgptfJ8ZJo8giw44Uy7MjFU/XOEw3k5qpoY6sMrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2+uy7d7grQGc2aTaDiBIWyDCBKqoPVSApl7OFASZSuU7clDPLIZOHgVCNm3B/o4fATFVxyzFbg3XzTZ1GqdGTcNKMvjNrpLvx5NWDM0+6Zb080R2bw+OygObQpRgjOlBrBxkPPailk08JZqc1JZTN91RxAk8o/k+vMObvu7mv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R4E070CU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC13DC433C7;
	Fri,  5 Apr 2024 10:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712311567;
	bh=Me5fgptfJ8ZJo8giw44Uy7MjFU/XOEw3k5qpoY6sMrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R4E070CUK5KUGSiaYz9yG8ZzWlVdkWaPDKUdV3QI6Ct9FBruRQu8ky48bav6soBa0
	 uBuiJlSWbUqBGxMzYhvgIih5xYxN4t+RMBrclZG2bHWHpeB0E63hnQ1snIjD4Hn+zH
	 m/C5VFfiWR8RbFSb2Zquf17qDaRClkm2AGpRtgYTzt1+MHn0bgHyPFX/IOcLNnQ78C
	 SsjYloYPJ2eXGHtqpiWTGDnWzEuqNeSQrHr2gJD4UrTp8SuVU2M8sI6ev68TXyuaMZ
	 GL83hvy0eVrkxEo37p6gkji2n/HWLvGiFxdmVA3sUuNIqSbErWguGX0ifn6Wr4rzH0
	 vPhn8kQdELRNQ==
Date: Fri, 5 Apr 2024 12:06:00 +0200
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH v2] fs: claw back a few FMODE_* bits
Message-ID: <20240405-maulkorb-berglandschaft-91fcbd452394@brauner>
References: <20240328-gewendet-spargel-aa60a030ef74@brauner>
 <20240404001823.GP538574@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240404001823.GP538574@ZenIV>

> in the same underlying filesystem the usual way - you wouldn't be able
> to store that in file_operations, simply because the instances with
> identical ->f_op might differ in that flag.

Yeah, good point. I never tried to actually do it otherwise it would've
been quite obvious. Thanks!

