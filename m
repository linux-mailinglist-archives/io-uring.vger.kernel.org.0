Return-Path: <io-uring+bounces-77-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5831C7E5C45
	for <lists+io-uring@lfdr.de>; Wed,  8 Nov 2023 18:19:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CF900B20D8F
	for <lists+io-uring@lfdr.de>; Wed,  8 Nov 2023 17:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2A131A78;
	Wed,  8 Nov 2023 17:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdg0tia1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81219315AB;
	Wed,  8 Nov 2023 17:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C447BC433C8;
	Wed,  8 Nov 2023 17:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699463980;
	bh=8WcnBJph0nMP59ZVY5tLRagWAAWuVVxQRfQlzNm6mRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fdg0tia1FBXF/KLhUIKMag4zrdSAYyQ+HQSZVYM9Qv4uAR0Cx5ol1WoZiqYgcBWU8
	 eDSTN0qYHoVkwsZc8Bh25K2gzGUP/GumjOZ20y15Ig3SK1Efz4SYck8IL5+g7qnxki
	 aPFDxwJ22kM6hNCuwVWQAZQANymORWWF9dXjnVP75M9G6ypqVqgfqadlWYWe1tWwpf
	 NAnlHre/NYaEQOCTpP7cD5B741VlO6PnAfmMWK1OAwPWfOjRyIkkPnQPjznhfsSqsh
	 VE2ZkGBNis9L333ci426+aYSN9nxn1ZY7mxZPUT5/7ij+9VX2e+5ycGLRl80odVeiY
	 T4d+3Q9R0y1kA==
Date: Wed, 8 Nov 2023 10:19:37 -0700
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com
Subject: Re: [PATCHv2 1/4] block: bio-integrity: directly map user buffers
Message-ID: <ZUvDKbe87fhYajcT@kbusch-mbp.dhcp.thefacebook.com>
References: <20231027181929.2589937-1-kbusch@meta.com>
 <CGME20231027182010epcas5p36bcf271f93f821055206b2e04b3019a6@epcas5p3.samsung.com>
 <20231027181929.2589937-2-kbusch@meta.com>
 <40ac82f5-ce1b-6f49-3609-1aff496ae241@samsung.com>
 <ZUkAH258Ts0caQ5W@kbusch-mbp.dhcp.thefacebook.com>
 <1067f03f-e89b-4fc8-58bb-0b83b6c5c91d@samsung.com>
 <ZUpS150ojGIJ-bkP@kbusch-mbp.dhcp.thefacebook.com>
 <3e14f4c8-482d-df2c-f802-ebc74bd12664@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e14f4c8-482d-df2c-f802-ebc74bd12664@samsung.com>

On Wed, Nov 08, 2023 at 05:45:19PM +0530, Kanchan Joshi wrote:
> On 11/7/2023 8:38 PM, Keith Busch wrote:
> > On Tue, Nov 07, 2023 at 03:55:14PM +0530, Kanchan Joshi wrote:
> >> On 11/6/2023 8:32 PM, Keith Busch wrote:
> >>> On Mon, Nov 06, 2023 at 11:18:03AM +0530, Kanchan Joshi wrote:
> >>>> On 10/27/2023 11:49 PM, Keith Busch wrote:
> >>>>> +	for (i = 0; i < nr_vecs; i = j) {
> >>>>> +		size_t size = min_t(size_t, bytes, PAGE_SIZE - offs);
> >>>>> +		struct folio *folio = page_folio(pages[i]);
> >>>>> +
> >>>>> +		bytes -= size;
> >>>>> +		for (j = i + 1; j < nr_vecs; j++) {
> >>>>> +			size_t next = min_t(size_t, PAGE_SIZE, bytes);
> >>>>> +
> >>>>> +			if (page_folio(pages[j]) != folio ||
> >>>>> +			    pages[j] != pages[j - 1] + 1)
> >>>>> +				break;
> >>>>> +			unpin_user_page(pages[j]);
> >>>>
> >>>> Is this unpin correct here?
> >>>
> >>> Should be. The pages are bound to the folio, so this doesn't really
> >>> unpin the user page. It just drops a reference, and the folio holds the
> >>> final reference to the contiguous pages, which is released on
> >>> completion.
> >>
> >> But the completion is still going to see multiple pages and not one
> >> (folio). The bip_for_each_vec loop is going to drop the reference again.
> >> I suspect it is not folio-aware.
> > 
> > The completion unpins once per bvec, not individual pages. The setup
> > creates multipage bvecs with only one pin remaining per bvec for all of
> > the bvec's pages. If a page can't be merged into the current bvec, then
> > that page is not unpinned and becomes the first page of to the next
> > bvec.
> > 
> 
> Here is a test program [2] that creates this scenario.
> Single 8KB+16b read on a 4KB+8b formatted namespace. It prepares 
> meta-buffer out of a huge-page in a way that it spans two regular 4K pages.
> With this, I see more unpins than expected.

I understand now. The bip_for_each_bvec is using single page vector
iterators. Will fix it up for next time.

