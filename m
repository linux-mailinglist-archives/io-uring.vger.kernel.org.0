Return-Path: <io-uring+bounces-3464-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EB149949C2
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 14:27:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30479281E02
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 12:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1741DF97F;
	Tue,  8 Oct 2024 12:25:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC65E1DF96D;
	Tue,  8 Oct 2024 12:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390344; cv=none; b=Lwg5dwNitpp0Zd2+LRLOX2Hx8DKSlZKr9B8kncgtd8jtAluN/MtEKqU0vbl4XRoSWDTV4PpMpKdRs4+oM+KYHpwGsamdL0pPNns5Hla2Yab5BsxsjQ+DC1NtFYg5CHDdqX4n1niamCEPljFc59N6G8QsreXErGRnI52O8EWhRhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390344; c=relaxed/simple;
	bh=B44zCzGUCIX1NtY3r8uI7cSHsIoSsL1pTHE/io/urC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abCmuiwkyYzPFaFl4ychUSHUH++sslDgeQs1xD+btmAJo44E8c2V8PSkW0KebEpKDs73rfjEThNtlkzKYrJGhu/T/m4lHV8SmSsY1hibLs6htuFHqYjid7vLDoEkvJb+qmmxAcrcqvB3oghjJxdTptesqqfvIcNSG7QJZ+D4KMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C8B4F227A88; Tue,  8 Oct 2024 14:25:35 +0200 (CEST)
Date: Tue, 8 Oct 2024 14:25:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241008122535.GA29639@lst.de>
References: <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com> <20241003125400.GB17031@lst.de> <c68fef87-288a-42c7-9185-8ac173962838@kernel.dk> <CGME20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b@eucas1p2.samsung.com> <20241004053121.GB14265@lst.de> <20241004061811.hxhzj4n2juqaws7d@ArmHalley.local> <20241004062733.GB14876@lst.de> <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local> <20241004123027.GA19168@lst.de> <20241007101011.boufh3tipewgvuao@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241007101011.boufh3tipewgvuao@ArmHalley.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 07, 2024 at 12:10:11PM +0200, Javier González wrote:
> In summary, what we are asking for is to take the patches that cover the
> current use-case, and work together on what might be needed for better
> FS support.

And I really do not think it is a good idea.  For one it actually
works against the stated intent of the FDP spec.  Second extending
the hints to per per-I/O in the io_uring patch is actively breaking
the nice per-file I/O hint abstraction we have right now, and is
really unsuitable when actually used on a file and not just a block
device.  And if you are only on a block device I think passthrough
of some form is still the far better option, despite the problems
with it mentioned by Keith.


