Return-Path: <io-uring+bounces-3737-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F21D59A112B
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 20:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C8D01C20E82
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 18:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB2518C028;
	Wed, 16 Oct 2024 18:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TuDATJsA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3B516C687;
	Wed, 16 Oct 2024 18:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729101837; cv=none; b=DVyGHbEIHj/Hyw59SL9K/omUiqrmn9F9EcDtDqEgzyHqjzK7Ty/UZk70AKAyUTHUjW33za92LbCTL/HD12/3gjZfrNga2MTZuYmDZvXNvMHPOExJOUdMOtq5WkjLRppcLwLPi9gYXG0kpMUpULcxDFdUeGtygNrLcwcOrEFb6w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729101837; c=relaxed/simple;
	bh=FfW6BMSQjS9cLZjwGvsIbkEwyd+h+0W9gybsj/7xrRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1HH1bEkbofvJjPbcN4rfLL7b74kq3NOMIDLOtbWkTRchZsDsz8LcDTh1u055f0MJ9heMOfkSvQSR3wj2ReFg0XHG457u4EKKRp4iOT7xjL7JieBzzTEFRnohXTa2kU0CCpMLdovFqhG0s8XejGJTDGTudBY+Q3aFFdtdyBIsjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TuDATJsA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6429EC4CEC5;
	Wed, 16 Oct 2024 18:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729101837;
	bh=FfW6BMSQjS9cLZjwGvsIbkEwyd+h+0W9gybsj/7xrRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TuDATJsAFovwyNvQ34eIJZzZWrXhNLf5X8JgZkQZhoyEhqkvlKS/9kIjGba9VPe2O
	 xBaXyAEB1gFN5Cpk2MuP6oFCFn8hHnc9LJeFqtxs5jyGYwtXPfe9tK1SmwMpeVraBp
	 gL7irO9NPe8khmUsIIxsn/33iByg12ERL5Uf8pAA1y+luXUyiygjTLBlbrpf/H/kCT
	 UpMUUmc4EJci4gEunUebQN8pg/qbleR3xVwIwPvRE+3UPu9o4bbSNnSrkGV9a4u8vs
	 w3MbjTGEcL+2wZI9gBL10kyEScW7gG6EpwazzDaYcD02i52hQSNfgiMmTj+m8Dz1c+
	 ZUsd3R4FS03Tw==
Date: Wed, 16 Oct 2024 12:03:53 -0600
From: Keith Busch <kbusch@kernel.org>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com
Subject: Re: [PATCH v4 01/11] block: define set of integrity flags to be
 inherited by cloned bip
Message-ID: <ZxAACWqEh99pPhz_@kbusch-mbp.dhcp.thefacebook.com>
References: <20241016112912.63542-1-anuj20.g@samsung.com>
 <CGME20241016113724epcas5p191ccce0f473274fc95934956662fc769@epcas5p1.samsung.com>
 <20241016112912.63542-2-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016112912.63542-2-anuj20.g@samsung.com>

On Wed, Oct 16, 2024 at 04:59:02PM +0530, Anuj Gupta wrote:
> Introduce BIP_CLONE_FLAGS describing integrity flags that should be
> inherited in the cloned bip from the parent.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

