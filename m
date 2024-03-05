Return-Path: <io-uring+bounces-830-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38EC2872AD3
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 00:10:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E19151F22AA2
	for <lists+io-uring@lfdr.de>; Tue,  5 Mar 2024 23:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB6412D20C;
	Tue,  5 Mar 2024 23:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ALzypJ1Y"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC0C1862F;
	Tue,  5 Mar 2024 23:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709680250; cv=none; b=i1tHi4ayq1XS0Nd35eeJzQGIls0Q5KLCL2LDUxhgfh00XSH/kbiyQ81FUwW7btrL6ijeIhhelG8FKFNNg3kM729et8dEo6orwM5nsUZAR+ISdCvRcJ571jiOLDrUx+uUoxgA7V1cMmCviPqjNugaVgkcwGITfKbAomcBdeaMh8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709680250; c=relaxed/simple;
	bh=Fnc41JWcp8TTwdV5+CSs8TOdfZ7zF3uSK0ml0Rjhis8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRcHEyBZh0+9Nz3kAIYT6xcNQ2wYrbzI460DEtOYJqYNyE6o4no3bwATB7WE8QRo8X80uZc4i0CDgOXZEmu+2ihwcDE5Szmo1UQoKYspnOlGcSTmZba+O/BUhaSogJYDXMKkI/yfut3zBtghTNvdEudnH+xGIH6OPuU/OAp8LhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ALzypJ1Y; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AzfcVf2MD8/p0Amw/4NcH7l9FF7lH9l9bZ/XM70hcPY=; b=ALzypJ1YFStiacKMqydGBmTVlP
	YTUVF1xHkoLghzjq7E/lbRgZid3uLJgiw49Sp1jQSAbYyCKb/gHZMWM7rMZZ/ONKXA2F5NEYs1r5D
	8rRucP/IpKNjKJvvm/ETL/0cyT38RtE/zLgQMIkzWtVsfvdDVbGQOR6RbD6iml2tFlK5drIE+zn3u
	HDMMCHitk0ECIe6gGAct543Vsjs58lZLCwbCkHGfUwjkxVC8Llrg7L34j7VDvW8OtAtTaNNVNAALm
	vAUi8qtmJCzc4FlJFblT4FQx2Ur6z8c4WsYyG0tZ8NsFvpA010d5uBs3He6ENJnN7GLLTUPdpFV0N
	hTuYo/4w==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhdvh-00000005Saj-2rlV;
	Tue, 05 Mar 2024 23:10:37 +0000
Date: Tue, 5 Mar 2024 23:10:37 +0000
From: Matthew Wilcox <willy@infradead.org>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com
Subject: Re: [PATCH v5 00/10] block atomic writes
Message-ID: <ZeembVG-ygFal6Eb@casper.infradead.org>
References: <20240226173612.1478858-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226173612.1478858-1-john.g.garry@oracle.com>

On Mon, Feb 26, 2024 at 05:36:02PM +0000, John Garry wrote:
> This series introduces a proposal to implementing atomic writes in the
> kernel for torn-write protection.

The API as documented will be unnecessarily complicated to implement
for buffered writes, I believe.  What I would prefer is a chattr (or, I
guess, setxattr these days) that sets the tearing boundary for the file.
The page cache can absorb writes of arbitrary size and alignment, but
will be able to guarantee that (if the storage supports it), the only
write tearing will happen on the specified boundary.

We _can_ support arbitrary power-of-two write sizes to the page cache,
but if the requirement is no tearing inside a single write, then we
will have to do a lot of work to make that true.  It isn't clear to me
that anybody is asking for this; the databases I'm aware of are willing
to submit 128kB writes and accept that there may be tearing at 16kB
boundaries (or whatever).


