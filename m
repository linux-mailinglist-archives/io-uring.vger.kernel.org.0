Return-Path: <io-uring+bounces-3364-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0758698CCAF
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 07:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 391AB1C2108C
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 05:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2504080038;
	Wed,  2 Oct 2024 05:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnpUD/Tp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6187DA9C;
	Wed,  2 Oct 2024 05:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848605; cv=none; b=GzCfUtzmYapjr1BMBCy5jdtY3MylWVi3dsqo69tkRG62MYsSpr9zSySHEAxTwG6iklmhDjBBlnscKZA2r8zA82lvmLxl4qrbuoijQVjcyFvXpudEVi2aVrP+KgyJd45ZgLWmMuWR5DtykuF4cG9jiGHB2vT+WsNRwdTVEUjyPBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848605; c=relaxed/simple;
	bh=ssSG15alL7c7M3YXO7v5OlwbQZKMBDgJ+6fYl805aes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TnYBvwYQgho5SGDaLOdG2Utv2UGt+AMlprLx0IJ+0Qso1tEKb/zYAq3H5IOEPNqiuf8LZ/uvrPaneBrV4DFq3synn5J6nw1WdIILWbUo646/MpzzjsWTPqnj5/J5WQex4v9i6JJkORuTHM5zKX90N5OTLm/JlXJ4Z3ptRR0noHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnpUD/Tp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C5DC4CEC5;
	Wed,  2 Oct 2024 05:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727848604;
	bh=ssSG15alL7c7M3YXO7v5OlwbQZKMBDgJ+6fYl805aes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lnpUD/TpETgpFkAECbsZCoXSFuqJbtttRu+7uE2gmVwDKfrVkqeCvoG2ecthNiR6F
	 6MJg3allPNQMQElXXlz9M8gh/fOXlC9zmZH7iSqoYcXboGJzeZ3B4/1iVmcvZ4jZBD
	 B/taIS8rP1jqlA6EdW5LHF5F+XPtzojKZJXaB3honqvPCOzVudxlAXItOqKyxJGKy/
	 lj+/uh22v2STkvJ7IXYk9ZSr7XTuG+v9TVKcm/hPWFvdpVYVlnz9yBy7M5D8w8eCZO
	 xySJJXCFR2QzcupxeGP062x7voJ1aVzNeKaMK6ZYwL+wBqeuJuU1hHKCmHOKAQ67eA
	 dC9Yu0j8XBZtw==
Date: Wed, 2 Oct 2024 07:56:40 +0200
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	cgzones@googlemail.com
Subject: Re: [PATCH 2/9] fs: rename struct xattr_ctx to kernel_xattr_ctx
Message-ID: <20241002-geknickt-endstadium-ee87e5361491@brauner>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-2-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241002012230.4174585-2-viro@zeniv.linux.org.uk>

On Wed, Oct 02, 2024 at 02:22:23AM GMT, Al Viro wrote:
> From: Christian Göttsche <cgzones@googlemail.com>
> 
> Rename the struct xattr_ctx to increase distinction with the about to be
> added user API struct xattr_args.
> 
> No functional change.
> 
> Suggested-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
> Link: https://lore.kernel.org/r/20240426162042.191916-2-cgoettsche@seltendoof.de
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>

