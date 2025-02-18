Return-Path: <io-uring+bounces-6518-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53F42A3A9FD
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 21:52:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC50F16A615
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 20:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4AF31C5486;
	Tue, 18 Feb 2025 20:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UriOXX0s"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCA91C07C2;
	Tue, 18 Feb 2025 20:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910844; cv=none; b=iiBXefbGMiI+bDkCSCCG9gkZP4M6RDfR4ifNf4sprX/yMc752RKhD40/gWO3WcVJ4+ZCXkSg0nc6KfC1pwnXKf/dzL5L/zHS0KJ6vfvfdSJCM4Cj3S1yFCboqucssit06XmqEg2K/ngqqDxiAcjPGSwg8Dcgn3ohwBAHfH65Aq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910844; c=relaxed/simple;
	bh=JN0ksCF72F9oER8wNZ2sKfI418X/k/qZw/uNmf/O1+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ChqbEBJAhkhauk0wpCBZUCevCvTVm3msBSJyEvS1NyTu09ySgpDlgH/p1gkvYVMI4Jbq5vS7o6MlKkXpiJsJwsaxwBrQvecrK/QdWQNFxjmYNdGMQttXCRTJNslNxRZTj++gtvsz2D7C9xaRuWyua+hgkCV582fsT0+WCIxhBqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UriOXX0s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0248C4CEE2;
	Tue, 18 Feb 2025 20:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739910844;
	bh=JN0ksCF72F9oER8wNZ2sKfI418X/k/qZw/uNmf/O1+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UriOXX0stxUoIiP1dWc8iQcRYvGOA9bAxQaGHd4qz1FwNS4aDUG3ybYw5vbXweMJR
	 DXudett2LtYw2iXOTR1Zf+rKtqpJOyqgAPwYZ4plLJRPECcAIjT1qZPBPCRj+3H3iD
	 n25LccKfigaifaXHS98+03qvEQCB5HvMIsHMZLRc4y5pd7T3vt9/7nWqYBgRJLukyY
	 Leo4UHaTC7KGiYW+5eevtGYAZTYmsFtfwRmrH9PCoWdZ1vxdPijU957YNWfyVCho3X
	 mAJs5ztJ/lCKh6tb8kfssjkQvSXiJZ9uV4/DetO8JIPi365PBofnhSd2tXaqflcKkK
	 Tgjd1YzKV8J1w==
Date: Tue, 18 Feb 2025 13:34:01 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv2 3/6] io_uring: add support for kernel registered bvecs
Message-ID: <Z7Tuudpxk8WuTUw1@kbusch-mbp>
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-4-kbusch@meta.com>
 <Z664w0GrgA8LjYko@fedora>
 <Z69gmZs4BcBFqWbP@kbusch-mbp>
 <Z6_vMvwv3ncTvi7e@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6_vMvwv3ncTvi7e@fedora>

On Sat, Feb 15, 2025 at 09:34:42AM +0800, Ming Lei wrote:
> > I suppose we could add that check, but the primary use case doesn't even
> > use those operations. They're using uring_cmd with the FIXED flag, and
> > io_uring can't readily validate the data direction from that interface.
> 
> The check can be added to io_import_fixed().

Good point, will incorporate this change.

