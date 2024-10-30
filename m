Return-Path: <io-uring+bounces-4210-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE1109B6837
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 16:46:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5ACDF1F23ACB
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 15:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FA8F1F4FA0;
	Wed, 30 Oct 2024 15:46:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AD6213EDE;
	Wed, 30 Oct 2024 15:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730303170; cv=none; b=ey0hjTT+D8lKFcCIrY/7BaDZxicbMQ6HKFYTtFivUjZJmQruTGgQlMh5C78lCQdt3ZWOq90HLS3OtxD8BnXxYqRm/l2plrdcWVUNsIXZ4xCGv60Oc8lfVzszY9k4z2lbbPwzL0j0SkleFP6AuD8VoUiPLn2aSvrRoF1BR6nYD/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730303170; c=relaxed/simple;
	bh=kmmA6i2XmNySckuQm2GGz4DMYTvTFjFCkmnEujkxHhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNn5ElvOoXP7+mglZh1Okj+VSYr6aoLJF6KfLAMBh9S2uog0e2uRIciP9PznVbS3VpfnQFuUOIurOt7hP6T4zhQFp7bKlTrgZrhTz1w2UAkd77SEKYUNROmdfAjE89pMgYRqdTUD+WEd7Mha/cvjBgZIVd94qGYc+U7Mc+UdEZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6AE83227AAC; Wed, 30 Oct 2024 16:45:56 +0100 (CET)
Date: Wed, 30 Oct 2024 16:45:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <20241030154556.GA4449@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com> <20241029151922.459139-10-kbusch@meta.com> <20241029152654.GC26431@lst.de> <ZyEAb-zgvBlzZiaQ@kbusch-mbp> <20241029153702.GA27545@lst.de> <ZyEBhOoDHKJs4EEY@kbusch-mbp> <20241029155330.GA27856@lst.de> <ZyEL4FOBMr4H8DGM@kbusch-mbp> <20241030045526.GA32385@lst.de> <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 30, 2024 at 09:41:39AM -0600, Keith Busch wrote:
> On Wed, Oct 30, 2024 at 05:55:26AM +0100, Christoph Hellwig wrote:
> > On Tue, Oct 29, 2024 at 10:22:56AM -0600, Keith Busch wrote:
> > 
> > > No need to create a new fcntl. The people already testing this are
> > > successfully using FDP with the existing fcntl hints. Their applications
> > > leverage FDP as way to separate files based on expected lifetime. It is
> > > how they want to use it and it is working above expectations. 
> > 
> > FYI, I think it's always fine and easy to map the temperature hits to
> > write streams if that's all the driver offers.  It loses a lot of the
> > capapilities, but as long as it doesn't enforce a lower level interface
> > that never exposes more that's fine.
> 
> But that's just the v2 from this sequence:
> 
> https://lore.kernel.org/linux-nvme/20240528150233.55562-1-joshi.k@samsung.com/
> 
> If you're okay with it now, then let's just go with that and I'm happy
> continue iterating on the rest separately. 

That's exactly what I do not want - it takes the temperature hints
and force them into the write streams down in the driver with no
way to make actually useful use of the stream separation.

