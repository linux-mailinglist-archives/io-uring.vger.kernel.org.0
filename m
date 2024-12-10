Return-Path: <io-uring+bounces-5405-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A356E9EAEE8
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 11:59:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C765188B5B7
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 10:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B8A2080EE;
	Tue, 10 Dec 2024 10:58:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0EC2080C6;
	Tue, 10 Dec 2024 10:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733828316; cv=none; b=NBsQtVd0bOeWcmy6Rgqar4sO9DrnQKuoC9OXhz71N3teorLORsRPP7di3QqrcLyaJoJdn/vRxA83FU3eE2JVhm6cJk5rPVPPwm7/uhpiRkqPdDRJJdFxOw0JkRsFGOSYzUiNFqLmAwO4JDZBL6gbi5PI1tjlDXCEruIU8kQa+AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733828316; c=relaxed/simple;
	bh=d9G4uh5kXI0bl5+4qhmaObA8jCmdOFmW5rrC+dcx+lM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KmsAC1MFui3Jp5tY9twB7Rx4qfyOw/lVSwS4eDSgEqesvd7+VF6Fn8CM7r6w31HqNk5KSJHSmAW//HO8iO+dmOQ2v+5Ro7p/jKd1XeANrhontM3uLUSkXQBUXsnCM6cHu0XixQ6YKGTruG8wLxAkiKAX7z9DAB7qof/3ZCa0P3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B1E4368CFE; Tue, 10 Dec 2024 11:58:22 +0100 (CET)
Date: Tue, 10 Dec 2024 11:58:22 +0100
From: hch <hch@lst.de>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: hch <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Javier Gonzalez <javier.gonz@samsung.com>,
	Matthew Wilcox <willy@infradead.org>,
	Keith Busch <kbusch@kernel.org>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241210105822.GA3123@lst.de>
References: <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com> <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org> <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com> <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org> <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com> <CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com> <20241205080342.7gccjmyqydt2hb7z@ubuntu> <yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com> <20241210071253.GA19956@lst.de> <2a272dbe-a90a-4531-b6a2-ee7c4c536233@wdc.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a272dbe-a90a-4531-b6a2-ee7c4c536233@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 10, 2024 at 08:05:31AM +0000, Johannes Thumshirn wrote:
> > Generally agreeing with all you said, but do we actually have any
> > serious use case for cross-LU copies?  They just seem incredibly
> > complex any not all that useful.
> 
> One use case I can think of is (again) btrfs balance (GC, convert, etc) 
> on a multi drive filesystem. BUT this use case is something that can 
> just use the fallback read-write path as it is doing now.

Who uses multi-device file systems on multiple LUs of the same SCSI
target ơr multiple namespaces on the same nvme subsystem?

