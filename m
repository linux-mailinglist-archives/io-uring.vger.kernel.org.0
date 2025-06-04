Return-Path: <io-uring+bounces-8199-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 972B7ACD7F5
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 08:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCB4318985AD
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 06:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2AC1EDA0B;
	Wed,  4 Jun 2025 06:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NTTkSrUg"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E093146447;
	Wed,  4 Jun 2025 06:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749019199; cv=none; b=Tj1GwEK3q6vh1dV+IsgzpK91REUTacTPuLsLkAcpQ2TE3VY6vumH9t8JL0VKmiS0TKO+g4wyXJSCDYBWaTXj2k62WT6CKXzRn/FXPorOjk4kuAo094U3RdQ8p0G6rUGx7WBh8WDri6Ae+0bgOnD7csMdPkZgUfNTf0+fcjpSTqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749019199; c=relaxed/simple;
	bh=gAtNlfTa8CjhIyQFjnINER2l/QhNyKuN+O64uD4vOkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aehTmdeKEIYzDSz+rHp9i0om1GS86zPGyfawFRYP51YYDXHRRphrrZ7ayfT1Id+FyJorpuMnYZhSQ06GkCALL+uM0d6tbLcEdhZhWK5tj8n/XyvY+1Xd+OgqCeigZfJy/R3Y3g9FmgGva1uJ11Tv+HSs9/ZZQZujxe3GOebO08g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NTTkSrUg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=pe1qJeegvXBPluoOlMRYoHImqkwDQRENHFRDQIDQpsY=; b=NTTkSrUgpjgM/V/3ioGpL3/x1Z
	2CxMMtmNvfQCOqeWRlfFKfGVhWrhlWY5gK6pjM79rFwTcVyu9SWSzkHHygVX9cez/zYGNMg6FYOOY
	TiEg3FAz6BOLfIBKq64da7xdXOuC3ASKfolqOF34fVu7/OqN1+ZzDywnQVlaTMyNw6h2CLX3KTn6T
	MN43a5PYxj09xbdQvytmRFNFYJUuKRsJUYyj9Ertm97WlaIsXXm6QdYlVOAUykYmZuq93ut0to2xS
	WeXfa7gTdZ5+fWOAQ991PQdFRY6Ma15CQ/Cvz5MKiCssjbGYiXM1ddnQLwmWhOP4/E2ehYqXPEl9f
	0zv/dWOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uMhmx-0000000Ch1g-32G7;
	Wed, 04 Jun 2025 06:39:51 +0000
Date: Tue, 3 Jun 2025 23:39:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v11 00/10] Read/Write with meta/integrity
Message-ID: <aD_qN7pDeYXz10NU@infradead.org>
References: <CGME20241128113036epcas5p397ba228852b72fff671fe695c322a3ef@epcas5p3.samsung.com>
 <20241128112240.8867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241128112240.8867-1-anuj20.g@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 28, 2024 at 04:52:30PM +0530, Anuj Gupta wrote:
> This adds a new io_uring interface to exchange additional integrity/pi
> metadata with read/write.
> 
> Example program for using the interface is appended below [1].
> 
> The patchset is on top of block/for-next.
> 
> Testing has been done by modifying fio:
> https://github.com/SamsungDS/fio/tree/priv/feat/pi-test-v11

It looks like this never got into upstream fio.  Do you plan to submit
it?  It would also be extremely useful to have a testing using it in
blktests, because it seems like we don't have any test coverage for the
read/write with metadata code at the moment.

Just bringing this up because I want to be able to properly test the
metadata side of the nvme/block support for the new DMA mapping API
and I'm ѕtruggling to come up with good test coverage.


