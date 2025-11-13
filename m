Return-Path: <io-uring+bounces-10557-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EBB1C56C00
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:07:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 756E835015A
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D249A2E1F02;
	Thu, 13 Nov 2025 10:06:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4CA2D739A;
	Thu, 13 Nov 2025 10:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763028396; cv=none; b=bvWcPoI0JWf6gaPjwHdimxWW6Oz4/kg4hDJ1QPfOlxO0TL1K2dq0Gfj9GsEiH8Kdx27Zf0TqwP5ju6WvXUVwiX6ym2jov9GCtlh/RqiXBx0om9+stGCX9HWrgkhbLOATneVAUASoHNUoaASzos6YmtV9rPAaT13kw4nmKO9C4J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763028396; c=relaxed/simple;
	bh=lPNmA52aTdyUEu5+nFfkMkxORbM+xtw164ICWepDdEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVz5XlludwJPXHjLhDBYuBfmXsRgo2TR1s/5W4w8GghE61Yi4CXa9ZtSHRmcpv9gHdPSsFc/xRObfJV5J8ibJnhUddGVrikE3Zw5PPphzJrCPZ5dnNlwG0KmfzXfhLRfau4NTL4/FNMelyaiKQZ73kNHRqCY0xMdLdqzvhOne9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 062C2227A87; Thu, 13 Nov 2025 11:06:31 +0100 (CET)
Date: Thu, 13 Nov 2025 11:06:30 +0100
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
Message-ID: <20251113100630.GB10056@lst.de>
References: <20251112072214.844816-1-hch@lst.de> <20251112072214.844816-5-hch@lst.de> <nujtqnweb7jfbyk4ov3a7z5tdtl24xljntzbpecgv6l7aoeytd@nkxsilt6w7d3> <20251113065055.GA29641@lst.de> <x76swsaqkkyko6oyjch2imsbqh3q3dx3uqqofjnktzbzfdkbhe@jog777bckvu6>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x76swsaqkkyko6oyjch2imsbqh3q3dx3uqqofjnktzbzfdkbhe@jog777bckvu6>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 13, 2025 at 10:54:46AM +0100, Jan Kara wrote:
> > You mean drop the common helper?  How would that be better and less
> > fragile?   Note that I care strongly, but I don't really see the point.
> 
> Sorry I was a bit terse. What I meant is that the two users of
> iomap_dio_is_overwrite() actually care about different things and that
> results in that function having a bit odd semantics IMHO. The first user
> wants to figure out whether calling generic_write_sync() is needed upon io
> completion to make data persistent (crash safe).

Yes.

> The second user cares
> whether we need to do metadata modifications upon io completion to make data
> visible at all.

Not quite.  It cares if either generic_write_sync needs be called,
or we need a metadata modification, because both require the workqueue.


