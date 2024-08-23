Return-Path: <io-uring+bounces-2916-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B57F95CBB6
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 13:52:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5ACE51C2061A
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 11:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1851017C211;
	Fri, 23 Aug 2024 11:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="clBokW3K"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7158315382E;
	Fri, 23 Aug 2024 11:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724413953; cv=none; b=cVgLS2HUskjw4Y7A9w0P7k6HaCtkMsnnzNf49aMiyxTonFqYGDWsvt61pLYVlOa/yuAIabZK0Ew8g9B2Ps0f0Zee6HwLfBkUNQeHdZO8Z3EGLgPZi0frdsLyu4JkIQKS5ijb0ttKqmGoDRODc7BNeCwt9UVWes4wOiJkpd1EY6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724413953; c=relaxed/simple;
	bh=kP3UTFPUFiMRuzjw0NtIkUGta53xGim7YAAoqarAvsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lrxO1QxAHimqJ+j4ZCJiIr5bia6GCBPcEmH7cdida1ArRhSSap8iwHef8yTTZHsFxVTnpu8/4aHOcYxLBjYgb9CH+jp1DbGSM4F8Za+dDc/xZ5PlUfcMM/gOMK04zvftsGlOPeUqcNYtKdkNJsKFHrq7rS7PImGHp6ULyoQeCjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=clBokW3K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M+Hzg1MI+serm3CFml7ogJSnhKAh6iB/HMhTOhekVsQ=; b=clBokW3Ksos18zF4kfDs0qwiMu
	cQAmK+/eekYPGhMJ9u2VVe0mUW+WSDFjBowSFjsFwkuatkWwMNlsMJbf80YDd8oT1pPxW1lWDy9fj
	sv2gd0X9qVosr8o+2vhAXOZH5S9sdQx2EWRzCbpbtmGcx1VeR6MegtXeOLYL4+rfglqdMzCxAKgHY
	1SLsqeTMfXXfIBk7OfEX28U1HxvawuvduXMveNboMpDs4YECzx9CtD1KALY8IbvkkwfXl4pd840h+
	fmEZtF6NaZkogsjyrjkleh7ck/YVQhee7K6294u70OmDKj+waOAgdyw7hEMgHlf1RXY4dWushmkPb
	YdQuAc9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shSqD-0000000GaR5-2G14;
	Fri, 23 Aug 2024 11:52:29 +0000
Date: Fri, 23 Aug 2024 04:52:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 4/7] block: introduce blk_validate_write()
Message-ID: <Zsh3_XsVCa5_-Pfr@infradead.org>
References: <cover.1724297388.git.asml.silence@gmail.com>
 <2ef85c782997ad40e923e7640039e0c7795e19da.1724297388.git.asml.silence@gmail.com>
 <ZsbbzDxV2mN29CYh@infradead.org>
 <d83350f4-f361-479d-b626-97cf699a0026@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d83350f4-f361-479d-b626-97cf699a0026@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 01:36:10PM +0100, Pavel Begunkov wrote:
> It's used for other commands in the series, all of them are
> semantically "writes", or modifying data operations if that's
> better. How would you call it? Some blk_modify_validate_args,
> maybe?

Maybe just split the writability checks out and rename the rest
blk_validate_byte_range, that way the usage is pretty clearly
defined.  Bonus points for writing a kerneldoc other other
comment header explaining it.


