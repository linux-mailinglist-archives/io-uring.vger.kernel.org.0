Return-Path: <io-uring+bounces-4154-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C98749B5553
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 22:52:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F18E1F23E44
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 21:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E205D194AD6;
	Tue, 29 Oct 2024 21:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jd9mHMte"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B341A1422AB;
	Tue, 29 Oct 2024 21:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730238766; cv=none; b=hL+lenHuTghEf05ZH/Yv6EFdWqqAIkXqgVtDipwLWvn5zc1hT1GiJ/jGuDQJ2gWAppjRFEw7v7JchLHRhB/Dd5Yl63gc/jBlUIlDUWtZLZWjZgG2VRbpnWUGmgVLfxMgMcH1Szr+ajMzfnIFvklwgrBdEeCjqOE+FtyZvoX/4Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730238766; c=relaxed/simple;
	bh=aQ4snfpqU8/cP5h4360AM/aNhQUoNlVkuZ5R6R5m2QU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ad/A83hAuYSkG7rmaDBudphtdAZkJI5d5nvAo7+K3UaX4JfBER1SMCRJ78fXwuEhoBJpW4/tBUYIQIBUXM0Ic/fv5uI30aIEpwFAanBZHu0uHp6toj6+WnNR6/hmHWjOORTa3QhcNznURUmoQc+fZ5Im8iA0zXGVxqPlCBDtdkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jd9mHMte; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FE7C4CECD;
	Tue, 29 Oct 2024 21:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730238766;
	bh=aQ4snfpqU8/cP5h4360AM/aNhQUoNlVkuZ5R6R5m2QU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jd9mHMteIVmcMbTaE3uwEugAGddfJddGcYP16SY3RjAJbJTHVVyuEpJoA8haaDdeV
	 MbpBDStbLtcbFjfL+MfXyB4/Wyb8YVufy6WdIfNab2QLmbU1tL3LJSOs2qc6rNkqVt
	 3NnEe9/aLQ9mOc0zUcM6jmP3Yw+nLMsDtFELguWmSjqBZZhbCicBnV6i7tbgdZ3bMW
	 uGbGq64Z02SpC76xDyfd8h36MIz7LoAinxHMf06p91m/K5FdUvuT9S27GwXg5rsHke
	 L73fnEIM2MuntOef2uFX5WwjmlpJFgbIo8kfAtEf61LFPxGux4oAaCTkyGa9ty1zm0
	 uYl6HV1LYpUiw==
Date: Tue, 29 Oct 2024 15:52:42 -0600
From: Keith Busch <kbusch@kernel.org>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v5 10/10] block: add support to pass user meta buffer
Message-ID: <ZyFZKmM5ALFaFGRd@kbusch-mbp.dhcp.thefacebook.com>
References: <20241029162402.21400-1-anuj20.g@samsung.com>
 <CGME20241029163235epcas5p340ce6d131cc7bf220db978a2d4dc24c2@epcas5p3.samsung.com>
 <20241029162402.21400-11-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029162402.21400-11-anuj20.g@samsung.com>

On Tue, Oct 29, 2024 at 09:54:02PM +0530, Anuj Gupta wrote:
> From: Kanchan Joshi <joshi.k@samsung.com>
> 
> If an iocb contains metadata, extract that and prepare the bip.
> Based on flags specified by the user, set corresponding guard/app/ref
> tags to be checked in bip.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

