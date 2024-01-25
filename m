Return-Path: <io-uring+bounces-486-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E76CA83CA6C
	for <lists+io-uring@lfdr.de>; Thu, 25 Jan 2024 19:01:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F7EBB23D15
	for <lists+io-uring@lfdr.de>; Thu, 25 Jan 2024 18:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8A410A12;
	Thu, 25 Jan 2024 18:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sldGpjMo"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FBB133409;
	Thu, 25 Jan 2024 18:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706205693; cv=none; b=g4Ls/PDnl/eXYyi4lOi/yoMUOYO5v6ENUmoJts+UlvNNlkM7ubtL5DaDR4ivkyneXF/bRAPwAokMkMzLcbPblWYbshP1USDzSSOA+bky2+EzJwanNsdtvTie7zVa8Lc8y/UcdFzEDTHtlZN6Ob2WkPU4TFQTR2c2ejMcL+WQ7+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706205693; c=relaxed/simple;
	bh=G9ev1zDgwMg6TX6m5BWJgmzHpQYXZHl9CDge2drsH8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GCHDE5W8pqCvEBSOfTirfXPfaAioIVuBITmfSTdjOBRc0nNyOD9Y6tlp53VeirCaL38o0vGhll3iMXxsjHdF3Hobtkayn+I7rmWkRJbl5CL2uluj3Wy5vs84itfXZAIISuBiCaaWneRuH3D6EbjoojjRER5b6x00YPZW+vitVMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sldGpjMo; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iSdxvLBi+ax0JQ7b12EwNjqdV9uTQsr6c8/7EwUzYJo=; b=sldGpjMo0Brt3Al/smTxc7iFzl
	cikVySvonik+9w4ZSihN1C/9nR1K2WDQQGraDfwmCTmuv76Te0WMj0TcnXMosn/8WMhS4OdMzUpUC
	RmWjnyeBlxknVJJqpYsS7qOPRdTFRLPcv7R6m2YLDL+FqqxF7LAG85+VABWKp6HQWnQNJrjrRuJve
	wLB3WSuytwhjzjSD0TM9fwWUnTsCzQQgTSEHRQ+KYrcPIQBEiy/cLU1hTLT7J3EweYV05BCegCbWM
	mTsl3sVrc6xx2K/ikHqjTPCqYFYbAa0z/Vviwz6HbcVJrp+S9kTgk46yZBHwJQDp7A2I2iB3jOdp0
	GlKrP3uA==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rT42V-0000000AiYf-1XMC;
	Thu, 25 Jan 2024 18:01:23 +0000
Date: Thu, 25 Jan 2024 18:01:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com, axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] Add ftruncate_file that truncates a struct file
Message-ID: <ZbKh8-EH1SVzR3qI@casper.infradead.org>
References: <20240124083301.8661-1-tony.solomonik@gmail.com>
 <20240124083301.8661-2-tony.solomonik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124083301.8661-2-tony.solomonik@gmail.com>

On Wed, Jan 24, 2024 at 10:33:00AM +0200, Tony Solomonik wrote:
>  	/* explicitly opened as large or we are on 64-bit box */
> -	if (f.file->f_flags & O_LARGEFILE)
> +	if (file->f_flags & O_LARGEFILE)
>  		small = 0;
>  
[...]
>  	/* Cannot ftruncate over 2^31 bytes without large file support */
>  	if (small && length > MAX_NON_LFS)
> -		goto out_putf;
> +		return -EINVAL;

I'd leave this in do_sys_truncate().  No need for ioring to care about
this ancient problem.


