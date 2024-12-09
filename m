Return-Path: <io-uring+bounces-5358-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 568529EA2D5
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:31:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9898318822C6
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF73D212F84;
	Mon,  9 Dec 2024 23:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dpnRolIA"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522F5212B1F;
	Mon,  9 Dec 2024 23:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787091; cv=none; b=KTnF4HGtF3fL1SgQglQkuPIDfryYkBVSrptlzucUsGrH0QfVt+DiDzpGlCGHj/iiBiNm4pCLpPliFmEB9318tDTwL0tAamzOyrMn+UOjIwtj99gJCoFxI7lTUnv1wIaGNn48pveK2/YYVCTMIma70ofkNjF1vWF5wp6+2SwWj7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787091; c=relaxed/simple;
	bh=8kHGzy49CBa7AuLHPCglNjjHwr1xdjiGB6GiRtwNVhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAUivXaCJ1k2Dc9XN6RlvRz6eYwY+CBpC3xp1VVtmoEQheqOGWStiPxyKMbLS275f/jtWXl8oSeWCLZ2zSxjtji2eR/7vMNC/aEq89uhWrlRAkv98LZtlu7o4SAeEkV9G9VYUOxZlCqsSCiSlB2MbgHIOR525DYHyZtY4/YEWyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dpnRolIA; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=hnYryxs5fAFAEeNlJ/22fquHamymjdpDvKQADj8yK+k=; b=dpnRolIAhWJAxtAgvTts6JqV0x
	0Xn709vr5TWG4JYGpD+UA41WayzULhAiKkL9s13N/kBcYYtzF+mJ9GEqGuRzmdcxIxLXEx/fudB6O
	i4vID4WHc+whH9Tx2SzTdhqlOPZ/wRAm+YZDaby2YdFx/q09MuSAjoLZ2ZZEdPfx8OykViN87fMJy
	HeXRDdkmIHyLxnSaq+6kBN0vmzR5XvSHc8NIqhPeqggAsioGb9qWyZYKzvS7kilnU4zVXkT4elpMa
	HN2FIeHIQXZNuIIFQwvroG+gb+A1WWq0s4TnXFACj1QclXjfZrIRxSPXam2RZdRaov3TLIiR72NqP
	gZiUg44w==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKnDh-00000005Nat-1gls;
	Mon, 09 Dec 2024 23:31:17 +0000
Date: Mon, 9 Dec 2024 23:31:17 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Nitesh Shetty <nj.shetty@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Javier Gonzalez <javier.gonz@samsung.com>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <Z1d9xfBwp0e8jxf4@casper.infradead.org>
References: <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
 <20241112135233.2iwgwe443rnuivyb@ubuntu>
 <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
 <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
 <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
 <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
 <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
 <CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
 <20241205080342.7gccjmyqydt2hb7z@ubuntu>
 <c639f90f-bdd1-4808-aeb7-e9b667822413@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c639f90f-bdd1-4808-aeb7-e9b667822413@acm.org>

On Mon, Dec 09, 2024 at 02:13:40PM -0800, Bart Van Assche wrote:
> On 12/5/24 12:03 AM, Nitesh Shetty wrote:
> > But where do we store the read sector info before sending write.
> > I see 2 approaches here,
> > 1. Should it be part of a payload along with write ?
> >      We did something similar in previous series which was not liked
> >      by Christoph and Bart.
> > 2. Or driver should store it as part of an internal list inside
> > namespace/ctrl data structure ?
> >      As Bart pointed out, here we might need to send one more fail
> >      request later if copy_write fails to land in same driver.
> 
> Hi Nitesh,
> 
> Consider the following example: dm-linear is used to concatenate two
> block devices. An NVMe device (LBA 0..999) and a SCSI device (LBA
> 1000..1999). Suppose that a copy operation is submitted to the dm-linear
> device to copy LBAs 1..998 to LBAs 2..1998. If the copy operation is

Sorry, I don't think that's a valid operation -- 1998 - 2 = 1996 and 998
- 1 is 997, so these ranges are of different lengths.

I presume you're trying to construct an operation which is entirely
reading within the first device, and then is going to write across both
devices.  So let's say you want to read 1-900 and write to 501-1400.

> submitted as two separate operations (REQ_OP_COPY_SRC and
> REQ_OP_COPY_DST) then the NVMe device will receive the REQ_OP_COPY_SRC
> operation and the SCSI device will receive the REQ_OP_COPY_DST
> operation. The NVMe and SCSI device drivers should fail the copy operations
> after a timeout because they only received half of the copy
> operation.

... no?  The SRC operation succeeds, but then the DM driver gets the DST
operation and sees that it crosses the boundary and fails the DST op.
Then the pair of ops can be retried using an in-memory buffer.

I'm not quite clear on the atomicity; whether there could be an initial
copy of 500-900 to 1000-1400 and then a remap of 1-499 to 501-999.

