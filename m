Return-Path: <io-uring+bounces-6841-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A01C6A48AC4
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 22:46:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA94B16BBE4
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 21:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524931EB5C0;
	Thu, 27 Feb 2025 21:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvPKRT5X"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2729C1CEAA3;
	Thu, 27 Feb 2025 21:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740692790; cv=none; b=eIoZWt0pH54Wa402k2kbC8JuM7pRKYo3xxB0lt8oTLaA1xe3xjYP0u9YdJtnpA67DmE4up3UcmFzfzWaP/h24D8s8q6RocwlViBm8pT7rekywg1as+WaxXvMvKNJD9ndjjfLphT5Q4+zvc1CQEdVfj21vfPc47AT6BYAkwv2Za8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740692790; c=relaxed/simple;
	bh=/nEA92N9pwlqDw/LpZqyfnJstLMztmSrMkJcI7BZnHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDOFlSwP3vuaGYWpfQsKLwzrPxyUPWPgPKMY6Xp5r8c0SArJKIyWh9/xSSbtU+6E/wXFJH95o9cVdrTcUgb5dm8mOeRflCwkMSPfBhJzl5zI69VCg8eOR7vpXupYS5d5N8DQ7pGhUYt8or6znJsWAWJdM8e7lSrCgR4b59KrNDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvPKRT5X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5796C4CEDD;
	Thu, 27 Feb 2025 21:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740692789;
	bh=/nEA92N9pwlqDw/LpZqyfnJstLMztmSrMkJcI7BZnHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dvPKRT5XKK86/yRCU7aGSRVF27Udij5AYbKVsRnHG6PUTWKHtcOSZDPFVar/JcZnl
	 yI2O72/iRm/uWkTxyqukHDz42HyvYTdT1ePpe83e2VZBl7oblC8giZJiQy9LKcuqCO
	 jy40JQgHG9VAO8fI/ShTXr4lxoaqrCZaKjuS1E6WUf/sjNJ1kvMTYDbivrkQCPJyhT
	 T7MDIGAsJkFd6Cej7EeboSyF7jkAVdbCoQTRkw22bby8sSJBcTXItn+70S/EaW/1DQ
	 C4FYt8vlwiLzjOVop89VMtMWuisR3lspQCEB4QUzM0j4YX3DeL1VuWqWTBpbVhZvX+
	 7IU+5xeEjSujg==
Date: Thu, 27 Feb 2025 14:46:26 -0700
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
	asml.silence@gmail.com, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com, linux-nvme@lists.infradead.org
Subject: Re: [PATCHv7 1/6] io_uring/rw: move fixed buffer import to issue path
Message-ID: <Z8DdMoScpHMzYrrh@kbusch-mbp>
References: <20250226182102.2631321-1-kbusch@meta.com>
 <20250226182102.2631321-2-kbusch@meta.com>
 <8b65adec-8888-40ae-b6c8-358fa836bcc6@kernel.dk>
 <d1ff0d23-07a4-4123-b30f-446cf849814a@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1ff0d23-07a4-4123-b30f-446cf849814a@kernel.dk>

On Wed, Feb 26, 2025 at 01:20:24PM -0700, Jens Axboe wrote:
> +static int io_rw_do_import(struct io_kiocb *req, int ddir)
> +{
> +	if (!io_do_buffer_select(req)) {
> +		struct io_async_rw *io = req->async_data;
> +		int ret;
> +
> +		ret = io_import_rw_buffer(ddir, req, io, 0);
> +		if (unlikely(ret))
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
> +		      int ddir)
> +{
> +	int ret;
> +
> +	ret = __io_prep_rw(req, sqe, ddir);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	return io_rw_do_import(req, ddir);
> +}

...

>  static int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  		       int ddir)
>  {
> -	const bool do_import = !(req->flags & REQ_F_BUFFER_SELECT);
>  	int ret;
>  
> -	ret = io_prep_rw(req, sqe, ddir, do_import);
> +	ret = io_prep_rw(req, sqe, ddir);
>  	if (unlikely(ret))
>  		return ret;
> -	if (do_import)
> -		return 0;
> +	if (!(req->flags & REQ_F_BUFFER_SELECT))
> +		return io_rw_do_import(req, ddir);

Not sure if I'm missing something subtle here, but wanted to point out
I've changed the above in the version I'm about to send: io_prep_rw()
already calls io_rw_do_import(), so we can just return 0 here.

