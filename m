Return-Path: <io-uring+bounces-2302-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93CD491126B
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 21:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C57461C228EC
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 19:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA2C3C6AC;
	Thu, 20 Jun 2024 19:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMsWWz6m"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCF813AF9;
	Thu, 20 Jun 2024 19:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718912768; cv=none; b=ZXHDojFegC4w8MnzpYml5puz/GmX6DdMj5+0ASvG1+jX9zMFDV6gU7yxctN/5sQcU9BNlzkkdgujnRiipPdu84GHDh6pJGKhIwBKzNBZ9nxZINpD8qQYzLUSQ3ZlSI5pQ+waunUbCv/ZP4CGQN6nPnvhpevBNOy57NctdNmbn4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718912768; c=relaxed/simple;
	bh=kMxWNABFITruZw+TUT+s054RLNenCGCKbp9bHivL/B8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ifgLHOwRxISx0/KJqkjCevthzHDL8unClaJuvDE4whX5pZoaPY7dljVzqpESHEScN863IDFgBSYGGWNGzjkR3qgovkCdMGwepER/uAvWpB20SySxYOizB39qV0EPQzeG31W04rxHTULh57jEcZbGLhLSdRjexUkVGwfmFMdw/f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMsWWz6m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C76FC2BD10;
	Thu, 20 Jun 2024 19:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718912768;
	bh=kMxWNABFITruZw+TUT+s054RLNenCGCKbp9bHivL/B8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EMsWWz6mmR4aR426mOwSJxZM5BkplVD6O6Y1Ze4cOA5gwtHhAXvPMTol9dAiFKn9D
	 5gOTo4hDvm2DXlnDGMvSjzz05Aj3kLdFYbRm5iPAUYVXYqMoqwUfNg1jUusILc+FHA
	 dIWaQtKsiTPy/AU5LZx/rsQzK7g7IavkLhftxgjIx3cZCRrO2/lM/9kqU8of2BmuwU
	 vwZyjS5mgn+7hl1L2Ixu5x1vFSPXbJsHGzgD+uAH7/ycqMqZpXWU20JkG4FVB/Izt6
	 zWwYiFlZ9qHGHk5yuRgSeoEX/ljehr2wNVy6Sib65ImiOem5a74PoDoHGBAew5MCRY
	 IguOii3yzi4Sw==
Date: Thu, 20 Jun 2024 13:46:04 -0600
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
	hare@suse.de, Prasad Singamsetty <prasad.singamsetty@oracle.com>
Subject: Re: [Patch v9 06/10] block: Add atomic write support for statx
Message-ID: <ZnSG_G9PGSUeQ78-@kbusch-mbp.dhcp.thefacebook.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-7-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620125359.2684798-7-john.g.garry@oracle.com>

On Thu, Jun 20, 2024 at 12:53:55PM +0000, John Garry wrote:
> From: Prasad Singamsetty <prasad.singamsetty@oracle.com>
> 
> Extend statx system call to return additional info for atomic write support
> support if the specified file is a block device.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

