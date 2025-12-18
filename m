Return-Path: <io-uring+bounces-11225-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C69ECCDE4B
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 00:00:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6760B3008BEB
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 23:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DEA52F0C7E;
	Thu, 18 Dec 2025 23:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FU8rfcco"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED14D2BEC45;
	Thu, 18 Dec 2025 23:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766098806; cv=none; b=sQSxxR0r549pAprKdsHeYkMcY1PcuMopf4axh7Yw1RJ71nNsAqGGEjm5DniiBrMgJwQDzBkCCxXJKs4fanp366TivIXsRFi43W9gb/HAfe1LHC6srKV911JrmaEbOQAuwGVCQspDCp/VtrayoEcTFxegcrcXl9dsToHNPezAbp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766098806; c=relaxed/simple;
	bh=fwDRVmIKSE7TBfzLjkhOsEq5hqK0HBNW65Vc73l4l4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rU7yKFEwTwuXa+R9IQXiCd5pXYJD3mDUkwMyAb4iXivzKiGdqJdmJKZCtSBItmduuB9mIjqwx621XDVI6Pn11nXlozfGb/7ah2Yhg1Q2jIM5tK3vL1Mlscj+ZzaYjQ2ym2IRfQ6i3aY03Dbx37qwTbEuwBZD9sZb9DzBU3qwobE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FU8rfcco; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4B7C116B1;
	Thu, 18 Dec 2025 23:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766098805;
	bh=fwDRVmIKSE7TBfzLjkhOsEq5hqK0HBNW65Vc73l4l4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FU8rfccorPvtcoV4+tJJMChOQQ8yb5XwYO8+v3u9fJB5+uvV74XAKIcXCC1lcymEG
	 wcp/z2CahMpA7gHzD/FHAHWf7nFPUFEu62ixOKp6EfD5Iz9GpIJwbd3SRlngRUu7F8
	 z7cjHHn9W04Vq5Usy4qR7WvSPSEOTvX7BzLrlQx02J9B0r57J3k4V6QQomZiYqkEhK
	 pXGN8PdXd3Dbrf5K6RaRpxJF0ILbepLLHeO1Q/P1XEItACPdW/hRWa+fYut2hlMVKX
	 UJcVd/ejc+lmbdwLJ2c3kh7vpyh3Pq3zJs31F8CXnSsP5T2j9oOwas6c4Npggmj9zW
	 76Z67PMyGpoiw==
Date: Fri, 19 Dec 2025 07:00:00 +0800
From: Keith Busch <kbusch@kernel.org>
To: veygax <veyga@veygax.dev>
Cc: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	Caleb Sander Mateos <csander@purestorage.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in
 io_buffer_register_bvec
Message-ID: <aUSHcH9TccvzgQkG@kbusch-mbp>
References: <20251217210316.188157-3-veyga@veygax.dev>
 <aUNLs5g3Qed4tuYs@fedora>
 <f1522c5d-febf-4e51-b534-c0ffa719d555@veygax.dev>
 <aUNRS1Qiaiqo1scX@kbusch-mbp>
 <80a3a680-e42c-4d4e-b613-72385d3f46d5@veygax.dev>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80a3a680-e42c-4d4e-b613-72385d3f46d5@veygax.dev>

On Thu, Dec 18, 2025 at 01:13:11AM +0000, veygax wrote:
> On 18/12/2025 00:56, Keith Busch wrote:
> > I believe you're supposed to use the bio_add_page() API rather than open
> > code the bvec setup.
> 
> True, but I wanted fine control to prove my theory

But doesn't that just prove misusing the interface breaks things? Is
there currently a legit way to get this error without the misuse? Or is
there existing mis-use in the kernel that should be fixed instead?

