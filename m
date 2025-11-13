Return-Path: <io-uring+bounces-10556-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C674C56BE8
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:05:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 47D6134F89F
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842D429BDB0;
	Thu, 13 Nov 2025 10:05:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB09946C;
	Thu, 13 Nov 2025 10:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763028335; cv=none; b=pSTYc3RKL2KZFFRhmIhm2d08bzFKulzJXUX7iU1mGOhJ9WNx0AwgSBJ2js5hcQvVgFftiuEuB+xbCJIzRNLWMq3KTVAw3tF1RLfdcsOPS+kuqQ3i724CB5hheh+yJY6qyQdKoVLiOHcx6TPZBIT6Y+G9eaJ0IHvWMBAsNlFdRyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763028335; c=relaxed/simple;
	bh=lHvkk12eoUXPcSl0O6xP+UD1MrWYY1K476cz1/kw5nw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZlRiWO2eTU2gPaANpmaAHrV8iiwTr1WUcXbOW5siqst5T2GABsEey9ql1V43L3BLstjlD8GYh5DaGzCmujvKy2hnYYbPxWoDVF4M0LKL2tECtGNL+KISS8jVU68sPO38qnw9Ofc6ozd7h8v6H839OjLsIzH8u+38JiWCKbbsdCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9D04A227A87; Thu, 13 Nov 2025 11:05:27 +0100 (CET)
Date: Thu, 13 Nov 2025 11:05:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Darrick J. Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Avi Kivity <avi@scylladb.com>, Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: enable iomap dio write completions from interrupt context
Message-ID: <20251113100527.GA10056@lst.de>
References: <20251112072214.844816-1-hch@lst.de> <zqi5yb34w6zsqe7yiv7nryx7xl23txy5fmr5h7ydug7rjnby3l@leukbllawuv2>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zqi5yb34w6zsqe7yiv7nryx7xl23txy5fmr5h7ydug7rjnby3l@leukbllawuv2>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 13, 2025 at 10:58:00AM +0100, Jan Kara wrote:
> On Wed 12-11-25 08:21:24, Christoph Hellwig wrote:
> > While doing this I've also found dead code which gets removed (patch 1)
> > and an incorrect assumption in zonefs that read completions are called
> > in user context, which it assumes for it's error handling.  Fix this by
> > always calling error completions from user context (patch 2).
> 
> Speaking of zonefs, I how is the unconditional locking of
> zi->i_truncate_mutex in zonefs_file_write_dio_end_io() compatible with
> inline completions?

It wouldn't, but zonefs doesn't use write inline completions because
it marks all I/O to sequential zones as unwritten.


