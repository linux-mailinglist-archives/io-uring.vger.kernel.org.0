Return-Path: <io-uring+bounces-2303-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A5791127E
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 21:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAEBDB26131
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 19:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1FC47A7C;
	Thu, 20 Jun 2024 19:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iF7Jf0V6"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5100B43156;
	Thu, 20 Jun 2024 19:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718912807; cv=none; b=QzrFgoXJiFyIZBnsyZeTY48xHNFVvrQkKW7/UMq9N4R6aftIHPXC7A/FqtN48sdlOfwUAyqDLiue2iLJ1+KDqKRyQJdbVjJMikcHRgao6AbypL4ZXzH5Aq08zokj80WAmy0YkLgJUI8NAjHTmZfTduJ/l2WMfxGzVvGK6un3lPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718912807; c=relaxed/simple;
	bh=NOXrZZ78IGZVhFJah42haGiQhcKtgPlchliubLibNbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q2uEVNB7LWxOpMk7t9EiACMxIKJV97ACnBn0XfK342r+p+S+kXS/ni1wGNLYtfSlwnRyP2W021zXy5hwmh0kUN0QsFE7DENeH0VdchtUrc4Dc+5mD1V167HUo9rPMwDF19YsEapnaKEeagIUXS6TQFl8KUZLtq3VdMi+QJaCP58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iF7Jf0V6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58F6C2BD10;
	Thu, 20 Jun 2024 19:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718912805;
	bh=NOXrZZ78IGZVhFJah42haGiQhcKtgPlchliubLibNbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iF7Jf0V6MxMlfrr5Rgpz7hsN47YbOthkjXFvJso/wh76d7mGGy7OuHpHvTuiSXzQx
	 dv//qW5Xxsd3CpYXOBgfZznlroKttBOwPJz3r47EHcsL5cF8eRuK5Tfcas30TmFyls
	 Tr1uUb5KjKCdnNO3zm0C254rZFe5QeK7ngeONnl5FwUln1Rwst9PvqjEIUxUfrZL+3
	 993k0ImdQ8LalafeFDgz8knEEnBOIMMFVeUvuJvGZSSFhb+80jqfB/o02kb959m/fm
	 N6rEEvbwS5SAkyii0YsbFb3yNNkDWCmwwMitjTkHXxIJKPomps4I11fbaW0rfb18Tj
	 6aCxakGyMlmAA==
Date: Thu, 20 Jun 2024 13:46:41 -0600
From: Keith Busch <kbusch@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
	djwong@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	hare@suse.de
Subject: Re: [Patch v9 07/10] block: Add fops atomic write support
Message-ID: <ZnSHIWVeMlpZ-OJb@kbusch-mbp.dhcp.thefacebook.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-8-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620125359.2684798-8-john.g.garry@oracle.com>

On Thu, Jun 20, 2024 at 12:53:56PM +0000, John Garry wrote:
> Support atomic writes by submitting a single BIO with the REQ_ATOMIC set.
> 
> It must be ensured that the atomic write adheres to its rules, like
> naturally aligned offset, so call blkdev_dio_invalid() ->
> blkdev_atomic_write_valid() [with renaming blkdev_dio_unaligned() to
> blkdev_dio_invalid()] for this purpose. The BIO submission path currently
> checks for atomic writes which are too large, so no need to check here.
> 
> In blkdev_direct_IO(), if the nr_pages exceeds BIO_MAX_VECS, then we cannot
> produce a single BIO, so error in this case.
> 
> Finally set FMODE_CAN_ATOMIC_WRITE when the bdev can support atomic writes
> and the associated file flag is for O_DIRECT.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

