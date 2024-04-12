Return-Path: <io-uring+bounces-1532-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C790A8A35AF
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 20:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 825092813AD
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 18:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B81BD14E2ED;
	Fri, 12 Apr 2024 18:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g4enleGk"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C915514E2E0;
	Fri, 12 Apr 2024 18:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712946532; cv=none; b=Yjwwik/8yFHONX3FX+7g4NNsec0lgCUQwvhuLFAM75dCsxooWBMgCygOBsV05PLOM01k4H++fTlKU3D3gq8VCMS5v1NsOfzOcMkKYQG3aGes1uPA/ZFb3c1l9/SJvA29cPGEgBuTPE84CnvRoixQeriJwmXUNrkJtl6UiW2CXlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712946532; c=relaxed/simple;
	bh=X9j9yFm/65nRAckgOYZMNKOekN37E9FIFTz7phVScao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VFMbdsFJLpawZEWS+H6Zz6WLBy2u42TVNfzxw0/i2Y5LDy5ZV0l6Ss2iBjFHIsnod+UE1cE/GCF5Yk2XtApUmYqSiGlZInjlcVPKULkwfUm15N2uNZ2qsVUUtozX3uBvPGbLaMUVViSQfbGik8Rbd/abymDlJfFhcG5Gs3dFDZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g4enleGk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=s9uyMrI2kBzD/jir8Kf5BQ4KLVX7ZmHiKzONe0aRyLQ=; b=g4enleGkCJEEwc71HQKni0x9GL
	WQaciMczjdvFq3ggaGdSSVerJPZOnRP70tf/jJYONFwjo9AoRzjwNg1jZ9M6ngZW5iMlU+zpXLUW+
	C9zDOOJMqEmOd6JzljE5sC7YvKO8mFIzOpi+wuvjAXUVr9SZ358OD4vWFo034mtRdmCrH29tnhQbE
	dlN7RuMr4Fvg37WpbT3NYaYZIyDt4GuGQ41syaaAGsXyHbnvtFukS0XAo6x8EtzXWRmXwg5RtczDq
	HV/tchkMzR/ZAUM21RhtdRQJLJo86VziZRS8/dEaVWKErEijWWzQNAFfc4tuKo+/zMQHY52RRcbZU
	tAwukUoA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rvLdf-00000000rhY-0qAo;
	Fri, 12 Apr 2024 18:28:39 +0000
Date: Fri, 12 Apr 2024 11:28:39 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: John Garry <john.g.garry@oracle.com>,
	Dan Helmick <dan.helmick@samsung.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com
Subject: Re: [PATCH v6 00/10] block atomic writes
Message-ID: <Zhl9VxTVxIEYc4cF@bombadil.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>
 <Zg7Z4aJtn3SxY5w1@casper.infradead.org>
 <f3c1d321-0dfc-466f-9f6a-fe2f0513d944@oracle.com>
 <ZhQud1NbO4aMt0MH@bombadil.infradead.org>
 <b0789a97-7dcf-48aa-9980-8525942dabfa@oracle.com>
 <Zhg0_Pvlh9zy4zzG@bombadil.infradead.org>
 <6d8e98bb-24d1-49be-8965-b6afa97dfdaa@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d8e98bb-24d1-49be-8965-b6afa97dfdaa@oracle.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

+ Dan,

On Fri, Apr 12, 2024 at 09:15:57AM +0100, John Garry wrote:
> On 11/04/2024 20:07, Luis Chamberlain wrote:
> > > So if you
> > > have a 4K PBS and 512B LBS, then WRITE_ATOMIC_16 would be required to write
> > > 16KB atomically.
> > Ugh. Why does SCSI requires a special command for this?
> 
> The actual question from others is why does NVMe not have a dedicated
> command for this, like:
> https://lore.kernel.org/linux-nvme/20240129062035.GB19796@lst.de/

Because we don't really need it for the hardware that supports it if the
host does the respective topology checks. For instance the respective
checks for NVMe are that atomics respect AWUN as the cap as the drive
already can go up to AWUN, and the limit for power-fail is implicit by
checking for AWUPF / NAWUPF. The alignment constraints can be dealt with
by the host software.

> It's a data integrity feature, and we want to know if it works properly.

For drives which already support this integrity is ensured already for
you. An NVMe specific atomic write command could be useful for for
existing drives for other reasons or future uses but its not a requirement
with the existing use cases if the NVMe alignment / atomic are respected by
the host.

> > Now we know what would be needed to bump the physical block size, it is
> > certainly a different feature, however I think it would be good to
> > evaluate that world too. For NVMe we don't have such special write
> > requirements.
> > 
> > I put together this kludge with the last patches series of LBS + the
> > bdev cache aops stuff (which as I said before needs an alternative
> > solution) and just the scsi atomics topology + physical block size
> > change to easily experiment to see what would break:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=20240408-lbs-scsi-kludge
> > 
> > Using a larger sector size works but it does not use the special scsi
> > atomic write.
> 
> If you are using scsi_debug driver, then you can just pass the desired
> physblk_exp and sector_size args - they both default to 512B. Then you don't
> need bother with sd.c atomic stuff, which I think is what you want.
> 
> > 
> > > > > To me, O_ATOMIC would be required for buffered atomic writes IO, as we want
> > > > > a fixed-sized IO, so that would mean no mixing of atomic and non-atomic IO.
> > > > Would using the same min and max order for the inode work instead?
> > > Maybe, I would need to check further.
> > I'd be happy to help review too.
> 
> Yeah, I'm starting to think that min and max inode would make life easier,
> as we don't need to deal with the scenario of an atomic write to a folio >
> atomic write size.

And aligments constraints could be dealt with as well.

  Luis

