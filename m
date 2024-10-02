Return-Path: <io-uring+bounces-3368-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C37098CCD8
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 08:00:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 729321C20E6C
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 06:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 918E3823DD;
	Wed,  2 Oct 2024 06:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLEOGF6e"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6809781AD7;
	Wed,  2 Oct 2024 06:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848821; cv=none; b=ElLjpo+qmDNk13flFX3lUa2GEMh/lmZM06prFmuxda4bkof575K3yMsqJhzi5WfKgIo4E/6PnuDmDA32anlaLLt3FannBhSR3JtS9acH4Q1/iLg708HHMfrI8FBATCcnDcj5qIZV87TWxON6lcpA7qNLNwtS5biXtrOVX8IEXZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848821; c=relaxed/simple;
	bh=UTtgBssdPxZxD9rtfZWOIVN4OuiGq9/agyo9VXYZsuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zy7QPWKqS5Ris2PFOSXzpbuaf5Znk/bwANuTDxgyhNajjh3lh93FJKDh3gRvWDGr8u1ME7eMcxM8BpNxopFuumYQwRv0UebDPx4tGOBmgbGqcLPCydQ5yhXAABT3/6aHciKm/ApirEOQ6mOOaitJOGy6ze7EX6BbkbdkYG/3XE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLEOGF6e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29F0C4CECE;
	Wed,  2 Oct 2024 06:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727848821;
	bh=UTtgBssdPxZxD9rtfZWOIVN4OuiGq9/agyo9VXYZsuo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cLEOGF6eJ3qWY+tDJgW7BV2pFPkyvhm9x8Ij/hhgYHeHaW/KGhjjXbaorJzUkF1dB
	 jXiAMYzj8OI8SHvBZ/USIlLbDQq17YdkgQtJJWUKQnSIxIIDiW70RESDwt5laAev7a
	 czmOLUg0HnqzjakDRU0L+ia4dFSQq+B/4cqwAQlpKwxwi1WbkaSGQBwpRIhUGGFjg1
	 8KM3+XqJSUqUohtk9ebroxsLsqCZa72tQkprODavl5+AGgsvCcWR2agPLp62uqli9W
	 zgkM61UE1bpCElQHDrKsnwfAoNTQHMW11HJEEOu7mEUJfIGQFnABbnTA9pxsi6PU/H
	 0aLAhkpbv8l9w==
Date: Wed, 2 Oct 2024 08:00:17 +0200
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	cgzones@googlemail.com
Subject: Re: [PATCH 7/9] new helpers: file_listxattr(), filename_listxattr()
Message-ID: <20241002-massieren-handreichung-7f03f7c74fb3@brauner>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-7-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241002012230.4174585-7-viro@zeniv.linux.org.uk>

On Wed, Oct 02, 2024 at 02:22:28AM GMT, Al Viro wrote:
> switch path_listxattr() and flistxattr(2) to those
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>

