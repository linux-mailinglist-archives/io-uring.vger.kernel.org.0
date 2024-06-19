Return-Path: <io-uring+bounces-2280-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD5BE90F1AA
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 17:06:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 548CC1F22363
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 15:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC51359147;
	Wed, 19 Jun 2024 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KzHjdBzu"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914AD34545;
	Wed, 19 Jun 2024 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718809489; cv=none; b=a1usbc4kMybaTnGPsS5oDTaHaY/X2gjS0ANygrl3hsZ7gers/0fc4ryAuEaOeTfJWdsG4lTlNaFXjti8HpDxJcwGYve+b1PLPdHRMbpDYxRQZFfytR+hGT9jtNCOn44aeKa2I+QNa2dEQpnX3Q0wKhHzqaNKdUoJtqdFnLhFbEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718809489; c=relaxed/simple;
	bh=DkvJTGPV8A8fKrUIaG/Py32b8898z0kZ4iLjsRm6Qe0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o8PWS2b4ERJxr0XaSCda/s1wjkSEkWXNyi7qRoa0ogMl9rtoqRiU1nx8UXX7U3261/mdK6vUQ3NhvU8j21x4LJEsO92ngApKXjfMFyWFMRbCD6aGZNFsphIR3ia+zDmLRGO46OCjwr3NcL08N7EAVx9Hrke9ZTYEXfgQWh0imhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KzHjdBzu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7127C32786;
	Wed, 19 Jun 2024 15:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718809489;
	bh=DkvJTGPV8A8fKrUIaG/Py32b8898z0kZ4iLjsRm6Qe0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KzHjdBzuVD4BbfwvB0nB+0oRoM5tn6GVD6fQ7+6kziSIXBP0Mr+wyXMgHgUvUmTMb
	 eDjFcyEcZy5Doi05B5uVzgLVSHK3hc2f3etRZRHS2bV9vcOjA9+17YKs/LD1GQNV7/
	 CVeiCSI09OzgmZOCWtkq52WnTPa1PFa1md8h1GIxFJJBqKly0LJcFo7RaiUqRVEG6L
	 FzqNEeNxcil59CDHzFwyx2UPMYdQq/ylQTvtJELbYdSbZyYZK4lolpL7GI42Wqd6so
	 tiZp83AXD8q/6FzRGEKaPWmjJwVXf7GKNMe6t1akurHm22vBpkv9McCXRso0P5646B
	 tvdRpwJPr7twg==
Date: Wed, 19 Jun 2024 08:04:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/4] net: Split a __sys_bind helper for io_uring
Message-ID: <20240619080447.6ad08fea@kernel.org>
In-Reply-To: <68b482cd-4516-4e00-b540-4f9ee492d6e3@kernel.dk>
References: <20240614163047.31581-1-krisman@suse.de>
	<20240618174953.5efda404@kernel.org>
	<68b482cd-4516-4e00-b540-4f9ee492d6e3@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Jun 2024 07:40:40 -0600 Jens Axboe wrote:
> On 6/18/24 6:49 PM, Jakub Kicinski wrote:
> > On Fri, 14 Jun 2024 12:30:44 -0400 Gabriel Krisman Bertazi wrote:  
> >> io_uring holds a reference to the file and maintains a
> >> sockaddr_storage address.  Similarly to what was done to
> >> __sys_connect_file, split an internal helper for __sys_bind in
> >> preparation to supporting an io_uring bind command.
> >>
> >> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> >> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>  
> > 
> > Acked-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Are you fine with me queueing up 1-2 via the io_uring branch?
> I'm guessing the risk of conflict should be very low, so doesn't
> warrant a shared branch.

Yup, exactly, these can go via io_uring without branch juggling.

