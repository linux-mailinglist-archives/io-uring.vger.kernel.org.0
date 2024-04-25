Return-Path: <io-uring+bounces-1640-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4970B8B2934
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 21:56:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05FE128481E
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 19:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031CC15252B;
	Thu, 25 Apr 2024 19:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ik5PM278"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC25E152166;
	Thu, 25 Apr 2024 19:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714074982; cv=none; b=JQpY1q8ay1Oi7nO8Q5xHrpNtZ73JItsbv9q/gZdQnNkaUGZ36NuM+XMa1TeYZbIMuK7iqCK0b3VAz6vt/ifnPZ3Zjy42cR3t/2Gsukr/fW+yzJTmAxQid5SfaXPxMjvwJVwvOdGbUEjwTV8Ju+5fnrANEjkWR7ljn818BkEM1IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714074982; c=relaxed/simple;
	bh=jRDCwVrYt2H58LrOmfq2qqQ9i26N0/R2CS8tLOWwxg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGSxOkLljegn08DNTJajo9WdCtnpadRhmajf9djbT4IqNbjlqbW2G65UbBzYfJ2JxW14TNz09vLgqdxjcS59tvheraWN54XMECModEfLwdxQCI8ZC1ur63r3DHzqecWWF14qNBhAoPkGQiwlqsl3xTat2C8gE8QZSNq91BSTnf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ik5PM278; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A127AC113CC;
	Thu, 25 Apr 2024 19:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714074982;
	bh=jRDCwVrYt2H58LrOmfq2qqQ9i26N0/R2CS8tLOWwxg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ik5PM278k/0Dn4Ku2Xs4MsrxBfCcjn5SVd6gyo33cC0iXmxHhyxavUahU4+Ov42wU
	 G0LJ7wJ41xn1+1y+s1m80EXAKTyUjbrePGe8GJ3rb2dLhbEvBLFNubeSSC0NQfnPJm
	 FXp5FY1g29XRCDIAbWmMcucGQRuFJss1E/oFj2s1/eebACK8U7SxLsgn0EKne9laxO
	 DiRvxXMF3VCULRMoqyPVHPQTKrhuDa5LpNmPGOuyWNsNOwVMYmR00cOi8GLh48Qle7
	 vp/eayhnQMkuA905oKSEz2iQDmLMrARuBsk4949idWQcTf6kzB3cOx5VXgcbsfCnrD
	 deLAbtCgbHifA==
Date: Thu, 25 Apr 2024 13:56:19 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, hch@lst.de,
	brauner@kernel.org, asml.silence@gmail.com, dw@davidwei.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH 10/10] nvme: add separate handling for user integrity
 buffer
Message-ID: <Ziq1YsqbS18N0u-q@kbusch-mbp.dhcp.thefacebook.com>
References: <20240425183943.6319-1-joshi.k@samsung.com>
 <CGME20240425184710epcas5p2968bbc40ed10d1f0184bb511af054fcb@epcas5p2.samsung.com>
 <20240425183943.6319-11-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425183943.6319-11-joshi.k@samsung.com>

On Fri, Apr 26, 2024 at 12:09:43AM +0530, Kanchan Joshi wrote:
> @@ -983,6 +1009,14 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
>  			if (WARN_ON_ONCE(!nvme_ns_has_pi(ns->head)))
>  				return BLK_STS_NOTSUPP;
>  			control |= NVME_RW_PRINFO_PRACT;
> +		} else {
> +			/* process user-created integrity */
> +			if (bio_integrity(req->bio)->bip_flags &
> +					BIP_INTEGRITY_USER) {

Make this an "else if" instead of nesting it an extra level.

> +				nvme_setup_user_integrity(ns, req, cmnd,
> +							  &control);
> +				goto out;
> +			}

And this can be structured a little differently so that you don't need
the "goto"; IMO, goto is good for error unwinding, but using it in a
good path harms readablilty.

This is getting complex enough that splitting it off in a helper
funciton, maybe nvme_setup_rw_meta(), might be a good idea.

