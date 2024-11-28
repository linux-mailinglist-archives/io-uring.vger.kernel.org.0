Return-Path: <io-uring+bounces-5124-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2581E9DBA62
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 16:21:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0EEE163BE0
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 15:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5954C19DF81;
	Thu, 28 Nov 2024 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lmnj3M7d"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289D8847B;
	Thu, 28 Nov 2024 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732807279; cv=none; b=ayeb/SWKGCLdI7RBl5cJBv8T647BMBJ/bxx4joY6g6rWkgJjdkyvES3q/Lr863INjY2bi2qlSkPK2cZ3rp/OxS5ObuXYveP6IKJR705pERiaFo3RHx6mXgj6DZ46yQT7AM63cSGHO/ZamFx0psg4JC+Xq834CCe6AxfWtZUtJIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732807279; c=relaxed/simple;
	bh=/nSe3ZP6/cW6ZZ443hUUzhIFmIVs0MMT0pZaG0rgKu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQ0JS35vAN2quiI6W9//9uNC4vai5VaAVMF0RvSv3WR/BzHNWU7TlK8Ou+Y23qH817O7409wx+KaISnZotYapU334kbUhskApwzfAVKS6wZ5RHjo+98rrYxSrzW46kJr+Tnz81Yv5XLo9Q9n8MKOCKb0z2BjgDVU7ogqcVbZDMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lmnj3M7d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C136C4CECE;
	Thu, 28 Nov 2024 15:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732807278;
	bh=/nSe3ZP6/cW6ZZ443hUUzhIFmIVs0MMT0pZaG0rgKu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lmnj3M7doVBuYQ8q8gw9XIER9vFoguEqjNoFujC1M9rhe81JiCtiS9YueIRKzisa+
	 +1GnX+9fEztBfGD8dYyOxjG6nErXDlWPaCh+B1TLNqOEQOEJKBVtIw6zVKxqNcludc
	 wZ95bKfK/4UNA1hRNXHtrej0lrEJLbXwkV4C7inyxxwPVfBh8iLUUh7/FkxJCasdwh
	 SNLxTOuB3kfmumLRjOpcieXC0l8nvZZ/6lX7dDjrlpGoUNm+coGeUoKwZS7oirEAZq
	 E6bbVzsCIhBbjdFx4alBWtNqzM/vqSe+DXshajJobxUY5adSz6iziHUiYZQ9ABGikl
	 fBMxvS+aX2yAg==
Date: Thu, 28 Nov 2024 08:21:16 -0700
From: Keith Busch <kbusch@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Javier Gonzalez <javier.gonz@samsung.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <Z0iKbPttERXaiexO@kbusch-mbp>
References: <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
 <2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
 <20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
 <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
 <20241112135233.2iwgwe443rnuivyb@ubuntu>
 <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
 <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
 <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
 <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
 <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>

On Wed, Nov 27, 2024 at 03:14:09PM -0500, Martin K. Petersen wrote:
> 
> Bart,
> 
> > Submitting a copy operation as two bios or two requests means that
> > there is a risk that one of the two operations never reaches the block
> > driver at the bottom of the storage stack and hence that a deadlock
> > occurs. I prefer not to introduce any mechanisms that can cause a
> > deadlock.
> 
> How do you copy a block range without offload? You perform a READ to
> read the data into memory. And once the READ completes, you do a WRITE
> of the data to the new location.
> 
> Token-based copy offload works exactly the same way. You do a POPULATE
> TOKEN which is identical to a READ except you get a cookie instead of
> the actual data. And then once you have the cookie, you perform a WRITE
> USING TOKEN to perform the write operation. Semantically, it's exactly
> the same as a normal copy except for the lack of data movement. That's
> the whole point!

I think of copy a little differently. When you do a normal write
command, the host provides the controller a vector of sources and
lengths. A copy command is like a write command, but the sources are
just logical block addresses instead of memory addresses.

Whatever solution happens, it would be a real shame if it doesn't allow
vectored LBAs. The token based source bio doesn't seem to extend to
that.

