Return-Path: <io-uring+bounces-6513-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CA6A3A844
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 21:00:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A13516A3F7
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 19:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C891EB5CA;
	Tue, 18 Feb 2025 19:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FilE+vTV"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECF71E51E3;
	Tue, 18 Feb 2025 19:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739908784; cv=none; b=gNNgSEZyC79pGCqxUdR6Vl3gZIPSH+SNiQlsjSbYVPU6uqTeO+mXo+BpWc0ne9kti48k5oNVXIV+nNyFTG6+bpIgBy5hkdMCsdROo4bpriW7sf/N5WORZStamMYtSj6oF+BFZm35HVY8HIhWEgvH88ccpxkV5jPXLLfJbyW0Vds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739908784; c=relaxed/simple;
	bh=jVF4ZN9u5ImJ/DMzO4MFVAWJCV9i8sdMon9m7RXuRi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i5ZEOOo+B85HN2vGuT8nJKfdqwDfJstVpT6teviF0HkdKJkCNE9RVWyUpKTe8x70FJjCGYYp3DT68sHEIKl8hXkMOCWqSZXm9L0WtxK632EQr9J09APdd9LzTiFGc2GsyAPnMOFpWDjJPaSH5PNgSQI0VOflk5ZF/parVcQBVx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FilE+vTV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AA1C4CEE2;
	Tue, 18 Feb 2025 19:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739908783;
	bh=jVF4ZN9u5ImJ/DMzO4MFVAWJCV9i8sdMon9m7RXuRi4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FilE+vTVE/xvJrudsSQNsoCNIKj9+PL0te1Bkq9aFE/UZJDa6r4OtERnr16nrkFuZ
	 e/UP8CoP0OqkYPddUP6jUiFxBGTzOvFXzjQ4jwKn226/uSqy5a+m76I/TSoo31SuSE
	 oBedlb71ty5SCVwyNt9F2YRX0dyaE1UhXNNDwrP36HeUme5Ys9q3/QqN8dFasu5doR
	 3i9YzSwQEnlxuSkw4gBv8iVr2u7UnScDY0RzUsnAxxX0LEl4bx+QguwLSGuhn8viIc
	 sZduh4mAagpglUHS310NdfmBSd7JRcsM+6lP0kRPEkczriNjzUjOFkht4fw5Hvi4ux
	 HmOhuxPb5EH1w==
Date: Tue, 18 Feb 2025 12:59:40 -0700
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
	asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv3 2/5] io_uring: add support for kernel registered bvecs
Message-ID: <Z7TmrB4_aBnZdFbo@kbusch-mbp>
References: <20250214154348.2952692-1-kbusch@meta.com>
 <20250214154348.2952692-3-kbusch@meta.com>
 <CADUfDZpbb0mtGSRSqcepXnM9sijP6-3WAZnzUJrDGbC0AuXTrg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZpbb0mtGSRSqcepXnM9sijP6-3WAZnzUJrDGbC0AuXTrg@mail.gmail.com>

On Fri, Feb 14, 2025 at 12:38:54PM -0800, Caleb Sander Mateos wrote:
> On Fri, Feb 14, 2025 at 7:45 AM Keith Busch <kbusch@meta.com> wrote:
> > +
> > +       nr_bvecs = blk_rq_nr_phys_segments(rq);
> 
> Is this guaranteed to match the number of bvecs in the request?

Yes.

> Wouldn't the number of physical segments depend on how the block
> device splits the bvecs? 

Also yes.

>lo_rw_aio() uses rq_for_each_bvec() to count
> the number of bvecs, for example.

Hm, that seems unnecessary. The request's nr_phys_segments is
initialized to the number of bvecs rather than page segments, so it can
be used instead of recounting them from a given struct request.

The initial number of physical segments for a request is set in
bio_split_rw_at(), which uses bio_for_each_bvec(). That's what
rq_for_each_bvec would use, too. The same is used for any bio's that get
merged into the bio.

