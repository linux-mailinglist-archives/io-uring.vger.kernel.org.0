Return-Path: <io-uring+bounces-3403-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D976798F9BF
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 00:18:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 439E0B22178
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 22:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E4D1CB514;
	Thu,  3 Oct 2024 22:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1QLLbA/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA171C9EBE;
	Thu,  3 Oct 2024 22:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727993868; cv=none; b=mWxzwENydelETHLQhZkV0EwrYU5rStZMpm7q/trgKU9MJx4YUo/1au1IFqD26c7GIDuHDyNp3kjJL0h3zqo7ucOmRAak4m+9ls/bxbw8A2elpGel5Svfgyk9/edRnMT3zc8VIObHQ6LOqsaaPjqK+Q8u0cV1GBVRViuCZCN4JPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727993868; c=relaxed/simple;
	bh=0TbLr7PEK0+8ZHCM/bRv8RnmYwcLf2s4vLPJ99IQmwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sUeWLd092Jkcv7rn+ecklrOQLIdjoboYVYHKEFqCV7Ei9DBhmEKBhqQWu/iviJh5AcWKkJgdvD0Vd9ximfTnTjaspDgk8rD+oqGhEE63PMpfWFYT/s3EpqKa50cNcbBGu3VLQ0ZdJu8bRYnyz/mRLwc4GvmeF4oWBoaNRtmk/R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1QLLbA/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CFDC4CEC5;
	Thu,  3 Oct 2024 22:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727993867;
	bh=0TbLr7PEK0+8ZHCM/bRv8RnmYwcLf2s4vLPJ99IQmwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d1QLLbA/9L0fikcnrZuItErUo72FCpOtJ1AUJZu0xdB7zk59VRLak7TX2g+Ld//z/
	 ieXkpFk2+O1ssw5HSZtcP3bJqe+f2eQR6n2k2yV1NAQm9akg+1RKaGGu9Okqyy4XpD
	 rASUEd4PDE7ceib6Xh89G+Hsrn5ikYgx3hon/QOY55JaRr51jqTwxjxnerlh74oyct
	 5wjLPn0N2nyGCxdhtn4PTqm7vq4pkcqoQ0G1U7SII8IZ44D4aOD2Rmmqxz0lyC7YIe
	 SkMdyc2rZptHXgzrZQ8DkaQBHbMcH7NEqaXMgAES4Lzs4PECYFQAVPqWO5lBXg4TUz
	 BA/EVoIza/ckg==
Date: Thu, 3 Oct 2024 16:17:44 -0600
From: Keith Busch <kbusch@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
	hare@suse.de, sagi@grimberg.me, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com,
	javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <Zv8YCFhJJZ_UtKOQ@kbusch-mbp>
References: <20241002075140.GB20819@lst.de>
 <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
 <20241002151344.GA20364@lst.de>
 <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
 <20241002151949.GA20877@lst.de>
 <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
 <a8b6c57f-88fa-4af0-8a1a-d6a2f2ca8493@acm.org>
 <20241003125516.GC17031@lst.de>
 <Zv8RQLES1LJtDsKC@kbusch-mbp>
 <abd54d3a-3a5e-4ddc-9716-f6899512a3a4@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abd54d3a-3a5e-4ddc-9716-f6899512a3a4@acm.org>

On Thu, Oct 03, 2024 at 03:00:21PM -0700, Bart Van Assche wrote:
> On 10/3/24 2:48 PM, Keith Busch wrote:
> > The only "bonus" I have is not repeatedly explaining why people can't
> > use h/w features the way they want.
> 
> Hi Keith,
> 
> Although that's a fair argument, what are the use cases for this patch
> series? Filesystems in the kernel? Filesystems implemented in user
> space? Perhaps something else?
> 
> This patch series adds new a new user space interface for passing hints
> to storage devices (in io_uring). As we all know such interfaces are
> hard to remove once these have been added.
> 
> We don't need new user space interfaces to support FDP for filesystems
> in the kernel.
> 
> For filesystems implemented in user space, would using NVMe pass-through
> be a viable approach? With this approach, no new user space interfaces
> have to be added.
> 
> I'm wondering how to unblock FDP users without adding a new
> controversial mechanism in the kernel.

I really like the passthrough interface. This is flexible and enables
experimenting with all sorts of features.

But it exposes exploits and pitfalls. Just check the CVE's against it
(ex: CVE-2023-6238, note: same problem exists without metadata). The
consequences of misuse include memory corruption and private memory
leakage. The barriers for exploits are too low, and the potential for
mistakes are too high. A possible h/w solution requires an IOMMU, but
that's a non-starter for many users and only solves the private memory
vulnerabilities.

Passthrough also skips all the block layer features. I just today added
statistics to it staged for 6.13, but even that requires yet another
config step to enable it.

tl;dr: no one wants to use nvme passthrough in production long term.

