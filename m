Return-Path: <io-uring+bounces-11582-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE34BD11B5F
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 11:05:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 07FEE30B785F
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 10:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0419E28727F;
	Mon, 12 Jan 2026 10:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDO/f+uj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBF7281531;
	Mon, 12 Jan 2026 10:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768212015; cv=none; b=SjQu0CYa0fkhND3nlYv9yAH1imKuTDJsIRp5FwpVPcdvVqrIQrIu+CnKeR6C/v67jIBPwqrZ1b/xgSLI0h4KvPNJKLp6TF2JYqDckzDGXgZQhUCYFbO3Pn5FrGNX9mwsQGscyt9zu1D/rnFpFFP2VMazUM0VeY8iNPwgNaRuB6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768212015; c=relaxed/simple;
	bh=k6Qq4YmJVqbqE4gAtcaB7VytqgVUJn3lvub+moTNfJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HtHvEar0Y+aNV2Nwl/RpUHaQEUu7PaVhs2iCiL3LsBZZvTjDVDlBKiMovqTLxxeP8GUIJ3mkXZ9nR2QQ74/EtlIO8SnQyUV6BT9UArrX43uNmvLXf1qKcAl1k4SCkcEjW7g5c7U2XMbeVy5SAuxctRE30WFdjNvgRA55ds543sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDO/f+uj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E467FC19421;
	Mon, 12 Jan 2026 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768212015;
	bh=k6Qq4YmJVqbqE4gAtcaB7VytqgVUJn3lvub+moTNfJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bDO/f+ujXdt4gCQdEo3X0tWsgc84Jp+eGkgzg3ZB/Eegp57dACkvbzw/eoX/Pfur/
	 jPrVJ1sKnvaF4yIX8qRNSfOyQFHVYWiLqgiBaUcUSg9ErLygxBO6wUEaLEI0hzse9l
	 nmLsIfFOTtn96E482IhJphXUb4bOKHe0ciRItETkYp+ZZt6dmq4m0zJ+TnNvyCV7P0
	 HKtbps1Q3sOlZODongujk4Y4CdYoPPsf9pLzYAq7Tf9gIi+zr9vz9vbA2okp51A4LB
	 9m0ufhQnUayvGYBl09z7vBq/qfPUiCceTwf4cqcoIzGhnIMDBiBWB46jMeWTQZkNm7
	 kR+1Srbqttqlg==
Date: Mon, 12 Jan 2026 11:00:10 +0100
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] experimental struct filename followups
Message-ID: <20260112-manifest-benimm-be85417d4f06@brauner>
References: <20260108074201.435280-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260108074201.435280-1-viro@zeniv.linux.org.uk>

On Thu, Jan 08, 2026 at 07:41:53AM +0000, Al Viro wrote:
> This series switches the filename-consuming primitives to variants
> that leave dropping the reference(s) to caller.  These days it's
> fairly painless, and results look simpler wrt lifetime rules:
> 	* with 3 exceptions, all instances have constructors and destructors
> happen in the same scope (via CLASS(filename...), at that)
> 	* CLASS(filename_consume) has no users left, could be dropped.
> 	* exceptions are:
> 		* audit dropping the references it stashed in audit_names
> 		* fsconfig(2) creating and dropping references in two subcommands
> 		* fs_lookup_param() playing silly buggers.
> 	  That's it.
> If we go that way, this will certainly get reordered back into the main series
> and have several commits in there ripped apart and folded into these ones.
> E.g. no sense to convert do_renameat2() et.al. to filename_consume, only to
> have that followed by the first 6 commits here, etc.
> 
> For now I've put those into #experimental.filename, on top of #work.filename.
> Comments would be very welcome...

Yeah, that looks nice. I like this a lot more than having calleee
consume it.
Reviewed-by: Christian Brauner <brauner@kernel.org>

