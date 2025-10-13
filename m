Return-Path: <io-uring+bounces-9973-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F682BD1AC7
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 08:28:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C31A318946D3
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 06:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 055642E22BF;
	Mon, 13 Oct 2025 06:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JTEuXZ4R"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5783F2DD60F;
	Mon, 13 Oct 2025 06:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760336893; cv=none; b=otRCfQm0NHMzLgP/i27B9F93QU+gKsOKt9u6FAaAaG+9b0NkZ2w5NgXxcHMVqkhc+KgSRj5RZyTVndRI7m8jFFOG4+C1AYZMpuV/zEnVGqIXFKn8OEcTf7oPdVfAZKVmZ3nGxyu8lyMagBw3E3A46FjIlmj/ber1HRt9/9vxkF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760336893; c=relaxed/simple;
	bh=t2wTMKKO4ssVUXq+IB+NkSmcXWByEhkt844Hz0StKR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rpaBK+RRmf3qwmkvNlk6TQY2KPzSsLR6EVAvfWM5R45D8ZpMgAt2gPxUsQkEuf1GdkyFEEhStnIGl7+OrPUGtrxi+h7m/XeH90TqM0qT25ZuHC8YFU0jBMKK0k3Zs6z7SpfdEjeHJUOOY6+bBvALNGXlJNEpZHxFhlFXH89H+e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JTEuXZ4R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C5b1JVWJxyJY0P7iS2qQASAGD/AgiaXpXDvD2N6N4UA=; b=JTEuXZ4RFAGkc0gsO+ULGdXAxB
	4Gx3OGa6t3dH3J01RvZmdGknWruNr/HfAPaQn+s5SIuXjtb99xZq5BHgYjdMNNPCcON1LsnmaLm4S
	Ynt4JevQs/ezaTQGWYq8pJ3BMIl0kO7Atz2MX+1NWFsytR2rTBfNG1ndRhTIYcPVClZ4lSW7KKVWB
	Mc+ogxk7gg2VNwGZhaXhhei0tTOuiYK0uWof2X+21zxZpaMlkqzt0QMdDAmrNauDtgMUVV8xBPZ+D
	TGrSERWjpf5BRlnDQsxKKJvJU48NSAawuCquZugaze8xjGfLsYlNhlCK6ZCLP0SU8PHbOj5kuIyxC
	5WrIYbnA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8C2S-0000000COBz-3IUH;
	Mon, 13 Oct 2025 06:28:08 +0000
Date: Sun, 12 Oct 2025 23:28:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: fengnan chang <fengnanchang@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Fengnan Chang <changfengnan@bytedance.com>, axboe@kernel.dk,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	asml.silence@gmail.com, willy@infradead.org, djwong@kernel.org,
	ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] block: enable per-cpu bio cache by default
Message-ID: <aOyb-NyCopUKridK@infradead.org>
References: <20251011013312.20698-1-changfengnan@bytedance.com>
 <aOxxBS8075_gMXgy@infradead.org>
 <CALWNXx8pDOvDdNvw+v0rEyi33W8TL+OZW1YiFbF6Gns3PeWOLA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALWNXx8pDOvDdNvw+v0rEyi33W8TL+OZW1YiFbF6Gns3PeWOLA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 13, 2025 at 01:42:47PM +0800, fengnan chang wrote:
> > Just set the req flag in the branch instead of unconditionally setting
> > it and then clearing it.
> 
> clearing this flag is necessary, because bio_alloc_clone will call this in
> boot stage, maybe the bs->cache of the new bio is not initialized yet.

Given that we're using the flag by default and setting it here,
bio_alloc_clone should not inherit it.  In fact we should probably
figure out a way to remove it entirely, but if that is not possible
it should only be set when the cache was actually used.

> > > +     /*
> > > +      * Even REQ_ALLOC_CACHE is enabled by default, we still need this to
> > > +      * mark bio is allocated by bio_alloc_bioset.
> > > +      */
> > >       if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <= BIO_INLINE_VECS)) {
> >
> > I can't really parse the comment, can you explain what you mean?
> 
> This is to tell others that REQ_ALLOC_CACHE can't be deleted here, and
> that this flag
> serves other purposes here.

So what can't it be deleted?


