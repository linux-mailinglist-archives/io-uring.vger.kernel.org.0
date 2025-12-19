Return-Path: <io-uring+bounces-11228-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 78EE1CCE894
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 06:34:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 83909300EAD6
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 05:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98EF72367D3;
	Fri, 19 Dec 2025 05:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vAPMzXe2"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6113621B9D2;
	Fri, 19 Dec 2025 05:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766122440; cv=none; b=FwlaUVJp46LuKjR/3UuSzAMJQApDdQCY3iU9wSXwcJg9676dUj7otyUU+YOxwoYUoZjCPvk8r+7oubfB0v1XDmTSgT/1dWPjrlkUXPE+RiZ+tHs/nTQRLu1+00Dnef6iLT3BDll4nQOL9geIfFixEGRIrmHRWC+rBsdxDZuZn9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766122440; c=relaxed/simple;
	bh=Rg+099W57W1ofAWnKhjl5iBz6zo9GeW/p9eaj5a/QAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IN5NJMNwlMk0HyxIwUHyBW81T8rM6VYAhHDzxszAzLsh03maaoxpD29oHmFCMuEaqKCCfodmwxpZXaKSyE7CebgPuqnP+HtfZ3n/+WAuI/22/ZOxKvy4RKzV8B+naFoeYxy5MDNDQBVMEQpWJHH9B6e5H4P1w6TUl7vmd3pYSKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vAPMzXe2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Hot21NtE8rkT/NoFTu3RN9Z/lmIEJQZ8Peygp08A7jc=; b=vAPMzXe2S0HrbMVww178pmHcJ6
	nD7Ac8fLHLkDrJXQcWEy36eQOBvndfukWO5198MIin+7K9qRow4FAY4PcCVrqy0/g7TUfkvZKBaKF
	4nEtNN8PI1p0xkUCGrJYFjIuHI2ku40eFq15qcZAELWN9N+UZ26jRYTVUbPGWY/Apww5ptu+1wBQ1
	+LqS0sH8IVXxjEerU9RzJ+eZhovpFXbqNZSV7rcu9y1rA0rEEpfZblbLyvWQZWFeNFnNBsRFHjKVJ
	CL4J5493l9DbPkGbpjMGxx1bNNmnm/dxeVaue1QUxiqeGO+uBvAMd3yGVb4R+0EePSqrVrjQ23Ptd
	G7D20Tiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWT7k-00000009eS8-37Wa;
	Fri, 19 Dec 2025 05:33:56 +0000
Date: Thu, 18 Dec 2025 21:33:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <kbusch@kernel.org>
Cc: veygax <veyga@veygax.dev>, Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	Caleb Sander Mateos <csander@purestorage.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in
 io_buffer_register_bvec
Message-ID: <aUTjxJEDYYfOT_QG@infradead.org>
References: <20251217210316.188157-3-veyga@veygax.dev>
 <aUNLs5g3Qed4tuYs@fedora>
 <f1522c5d-febf-4e51-b534-c0ffa719d555@veygax.dev>
 <aUNRS1Qiaiqo1scX@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUNRS1Qiaiqo1scX@kbusch-mbp>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 18, 2025 at 08:56:43AM +0800, Keith Busch wrote:
> On Thu, Dec 18, 2025 at 12:37:47AM +0000, veygax wrote:
> > 	/*
> > 	 * Add pages to bio manually.
> > 	 * We use physically contiguous pages to trick blk_rq_nr_phys_segments
> > 	 * into returning 1 segment.
> > 	 * We use multiple bvec entries to trick the loop in io_buffer_register_bvec
> > 	 * into writing out of bounds.
> > 	 */
> > 	for (i = 0; i < num_bvecs; i++) {
> > 		struct bio_vec *bv = &bio->bi_io_vec[i];
> > 		bv->bv_page = page + i;
> > 		bv->bv_len = PAGE_SIZE;
> > 		bv->bv_offset = 0;
> > 		bio->bi_vcnt++;
> > 		bio->bi_iter.bi_size += PAGE_SIZE;
> > 	}
> 
> I believe you're supposed to use the bio_add_page() API rather than open
> code the bvec setup.

The above is simply an open coded version of doing repeated
__bio_add_page calls.  Which would be rather suboptimal, but perfectly
valid.


