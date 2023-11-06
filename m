Return-Path: <io-uring+bounces-36-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B6A07E280B
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 16:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42BDF28129D
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 15:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8873028DBD;
	Mon,  6 Nov 2023 15:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IU6+zLSt"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A68028DBB
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 15:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A33C433C8;
	Mon,  6 Nov 2023 15:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699282978;
	bh=mdnasKN++L7iH5e6EPZzJn9sOH6/oy4ZkzaDKp72Z4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IU6+zLStHSVytMX6tJg1kzHdIVLIwVf+659Kn3Bsd27AgQ6bgN0FVk0a/m6EtZgir
	 Z7eL6fs21SfS2wj7A6a6altos0BNWVgUgcCZRa8aHcVTQYF4Bbq4iRjOJc6bFj2ihW
	 FuVegkxQSDOLaFhZA/IBYcLnobbcGy8CjPxGJTS6MNlWRxjWVivIfhba1bw+WSLktq
	 46O/PPGqCzA8gipo5PV7570BE8sGSGWdSScplcVIt5UJ8TkH0eNJkNSebLVuMw9AoO
	 fi5tsJpjgTHOqo9oowhWEnX6SwKhDD0VaFzkpj/Ye4ZzvwI6KgnRihNVPEb1+49Ngo
	 APyeIf7R+RqZg==
Date: Mon, 6 Nov 2023 08:02:55 -0700
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com
Subject: Re: [PATCHv2 1/4] block: bio-integrity: directly map user buffers
Message-ID: <ZUkAH258Ts0caQ5W@kbusch-mbp.dhcp.thefacebook.com>
References: <20231027181929.2589937-1-kbusch@meta.com>
 <CGME20231027182010epcas5p36bcf271f93f821055206b2e04b3019a6@epcas5p3.samsung.com>
 <20231027181929.2589937-2-kbusch@meta.com>
 <40ac82f5-ce1b-6f49-3609-1aff496ae241@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40ac82f5-ce1b-6f49-3609-1aff496ae241@samsung.com>

On Mon, Nov 06, 2023 at 11:18:03AM +0530, Kanchan Joshi wrote:
> On 10/27/2023 11:49 PM, Keith Busch wrote:
> > +	for (i = 0; i < nr_vecs; i = j) {
> > +		size_t size = min_t(size_t, bytes, PAGE_SIZE - offs);
> > +		struct folio *folio = page_folio(pages[i]);
> > +
> > +		bytes -= size;
> > +		for (j = i + 1; j < nr_vecs; j++) {
> > +			size_t next = min_t(size_t, PAGE_SIZE, bytes);
> > +
> > +			if (page_folio(pages[j]) != folio ||
> > +			    pages[j] != pages[j - 1] + 1)
> > +				break;
> > +			unpin_user_page(pages[j]);
> 
> Is this unpin correct here?

Should be. The pages are bound to the folio, so this doesn't really
unpin the user page. It just drops a reference, and the folio holds the
final reference to the contiguous pages, which is released on
completion. You can find the same idea in io_uring/rscs.c,
io_sqe_buffer_register().

