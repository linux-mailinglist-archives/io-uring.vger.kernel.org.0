Return-Path: <io-uring+bounces-10603-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D76CCC57727
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 13:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0800E3BE9A8
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F20340A4A;
	Thu, 13 Nov 2025 12:35:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0A62D94A3;
	Thu, 13 Nov 2025 12:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763037341; cv=none; b=RjJcaqYQN49OYIaEfnqBiaerIYQQNmwEHkWWAkKucZDQxWRopEnu/YS2ZsiJEWTSQV0Hc2yesYNS3JFR444hNLc4psqCtzvCqq3QftZJ3U1Gc0mF25rH3vOqjUaE4ctM3Pc00uWrQ7NrKqTJku0XvrafZHnD+1EiLIHrRCnH0MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763037341; c=relaxed/simple;
	bh=ePxJvEbztbjKYCAVyd7deFPKSp7j62o+wMmttRco0HE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dh/N62Gsns32IrATUuOkhO2rha+QNBBxZoMsHVZ1OfKYrFDoqh5abOnwu/Odiq2gV5+f+IszBz+yaw0L95pk9/9N+yEE+LX6PVTetnRCSum2bvs+bIBO25S+BPIsmcShb23q9Y1xZR5zDNlEaAGmYSMlXh6qRrQ+hw/FhMZigjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2D9D3227A88; Thu, 13 Nov 2025 13:35:33 +0100 (CET)
Date: Thu, 13 Nov 2025 13:35:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Darrick J. Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Avi Kivity <avi@scylladb.com>, Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 4/5] iomap: support write completions from interrupt
 context
Message-ID: <20251113123532.GA21292@lst.de>
References: <20251112072214.844816-1-hch@lst.de> <20251112072214.844816-5-hch@lst.de> <nujtqnweb7jfbyk4ov3a7z5tdtl24xljntzbpecgv6l7aoeytd@nkxsilt6w7d3> <20251113065055.GA29641@lst.de> <x76swsaqkkyko6oyjch2imsbqh3q3dx3uqqofjnktzbzfdkbhe@jog777bckvu6> <20251113100630.GB10056@lst.de> <ewzcc5tots6ughnbqlqmvje4ex2eb5tug2mapzvcf4zstb7fxn@qruu4xs4nblt>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ewzcc5tots6ughnbqlqmvje4ex2eb5tug2mapzvcf4zstb7fxn@qruu4xs4nblt>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 13, 2025 at 01:06:34PM +0100, Jan Kara wrote:
> On Thu 13-11-25 11:06:30, Christoph Hellwig wrote:
> > On Thu, Nov 13, 2025 at 10:54:46AM +0100, Jan Kara wrote:
> > > > You mean drop the common helper?  How would that be better and less
> > > > fragile?   Note that I care strongly, but I don't really see the point.
> > > 
> > > Sorry I was a bit terse. What I meant is that the two users of
> > > iomap_dio_is_overwrite() actually care about different things and that
> > > results in that function having a bit odd semantics IMHO. The first user
> > > wants to figure out whether calling generic_write_sync() is needed upon io
> > > completion to make data persistent (crash safe).
> > 
> > Yes.
> > 
> > > The second user cares
> > > whether we need to do metadata modifications upon io completion to make data
> > > visible at all.
> > 
> > Not quite.  It cares if either generic_write_sync needs be called,
> > or we need a metadata modification, because both require the workqueue.
> 
> I agree but generic_write_sync() calling is handled by 
> 
> +       else if (dio->flags & IOMAP_DIO_NEED_SYNC)
> +               dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> 
> in your patch. So I assumed (maybe wrongly) that the second call to
> iomap_dio_is_overwrite() in iomap_dio_bio_iter() is only about detecting a
> need of metadata modification. And my argument is that the patch could use
> IOMAP_DIO_UNWRITTEN | IOMAP_DIO_COW the same way as it uses
> IOMAP_DIO_NEED_SYNC instead of calling iomap_dio_is_overwrite().
> 
> But if you don't like that I don't think it makes a huge difference and the
> code is correct as is so feel free to add:

I'll take a look if there is a way to clear thing up a bit.


