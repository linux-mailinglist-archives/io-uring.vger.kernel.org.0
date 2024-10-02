Return-Path: <io-uring+bounces-3365-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B32998CCB1
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 07:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD2AF1C21011
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 05:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F5C80038;
	Wed,  2 Oct 2024 05:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XkwQjuUP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC1B7DA9C;
	Wed,  2 Oct 2024 05:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848624; cv=none; b=SZ/COzFrYsWs/kBU4ntO/tBy8QttduXEwT1ka5Nv50coxWWhhjwmTDhsc4taJ+7m6jqsB0mMDMwjOeOf7GHuaw7xNwcAe/7w3SC688Pu5sFLrqPEKrVsj8Y+Uzj32Q+IP18L6F9x4W85Z83DO+iLLx72YgUyMUr88s8eJu7OfE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848624; c=relaxed/simple;
	bh=ZJgod9jCaZTOf2Xb+cc2mR2x5l4xy9OSjEnk/a/ifp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5WoSu4aBTXjziqcdnkUnPxWIiGkLNKFeXXJTr1aUhOAqYotNS7/LFAG6o/0v1TYKqv1uc+LuowNAOJpp2yyutM8eaQWFF9oytcr3EGFN25IfLZWBKLoX2iG4SwlCaWLDp0uWPBIr11+kG6yOx0NqVBqXrNHr0bj0/md3E1mTZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XkwQjuUP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CC7C4CEC5;
	Wed,  2 Oct 2024 05:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727848624;
	bh=ZJgod9jCaZTOf2Xb+cc2mR2x5l4xy9OSjEnk/a/ifp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XkwQjuUPuHy98cK3/ieAcyoh2ZPnRpwmRuvydZKqS3Cs+nqNAVccE/MFp6OmWqpOw
	 zN9OE3Lcp2GHIwBFfyemJp0RroxYK/WOT9N9q7Vu/1V7/HYb1Zjf9+RsMPow9fstrq
	 QZZGnli2OTFLl7CL6f7NZzIcjAZuhrv5VPSPV9gBygU2R1zBE0eeLT8SfVKhgEau6n
	 GWZkecgNqmM95AMeDQuFCElXr9AiiDyYjI0zGin6THSIa2hu8cNh5oiaXEqNOOBYCy
	 Q6kMNBBe+LPepGwA5hzpPcKkd/DyXaL0aLg3/o7S1AmShlKChmmld3vhHabQ+7H4Vv
	 L7QEMb0jGcwxA==
Date: Wed, 2 Oct 2024 07:57:00 +0200
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	cgzones@googlemail.com
Subject: Re: [PATCH 3/9] io_[gs]etxattr_prep(): just use getname()
Message-ID: <20241002-abweichen-leitplanke-57958d9e4ccf@brauner>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-3-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241002012230.4174585-3-viro@zeniv.linux.org.uk>

On Wed, Oct 02, 2024 at 02:22:24AM GMT, Al Viro wrote:
> getname_flags(pathname, LOOKUP_FOLLOW) is obviously bogus - following
> trailing symlinks has no impact on how to copy the pathname from userland...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>

