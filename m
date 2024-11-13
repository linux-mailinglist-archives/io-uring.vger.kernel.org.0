Return-Path: <io-uring+bounces-4636-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F381F9C6837
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 05:47:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8455284299
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 04:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3688433CE;
	Wed, 13 Nov 2024 04:47:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638BE17C;
	Wed, 13 Nov 2024 04:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731473263; cv=none; b=tlMWLO673EwIxXtDxmWXCdGkrsyXnBfEtLjiATPZUJTwpnVni/G4ps9oUUE8ozDaZH55R0AlCST0WCLokpFdVkTHfekD9PaOMWyadEvNQGV77SedhvZJHsCj9oF+P8rCUXukatm8MUuWQrxGjJmSsrpmvfkbcI2ELs/H9M8pa+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731473263; c=relaxed/simple;
	bh=eUgBbOs7DpNrhujAIe1XqDToAGAPVDPG/3tghnEfufY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IzBfBkm26zxLnHSOsdOhkOLCzIMz6DCqqSyeEVKykbvdZ1y2Tpze/sKc1Uu0+enIYraV48yldh5scSzfh58i8x5xIyj9MThbS40pAonSVHmVFobxFkJQpWexvIJL+awWxEBt0QGHGfzf+lRLUJfscMUBTR/rIcGBZi/ejILtyTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9E9B968AFE; Wed, 13 Nov 2024 05:47:36 +0100 (CET)
Date: Wed, 13 Nov 2024 05:47:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pierre Labat <plabat@micron.com>
Cc: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [EXT] Re: [PATCHv11 0/9] write hints with nvme fdp and scsi
 streams
Message-ID: <20241113044736.GA20212@lst.de>
References: <20241108193629.3817619-1-kbusch@meta.com> <CGME20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b@epcas5p3.samsung.com> <20241111102914.GA27870@lst.de> <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com> <20241112133439.GA4164@lst.de> <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com> <DS0PR08MB854131CDA4CDDF2451CEB71DAB592@DS0PR08MB8541.namprd08.prod.outlook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR08MB854131CDA4CDDF2451CEB71DAB592@DS0PR08MB8541.namprd08.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 12, 2024 at 06:18:21PM +0000, Pierre Labat wrote:
> Overall, it seems to me that the difficulty here comes from 2 things:
> 1)  The write hints may have different semantics (temperature, FDP placement, and whatever will come next).

Or rather trying to claim all these are "write hints" is simply the wrong
approach :)

> 2) Different software layers may want to use the hints, and if several do that at the same time on the same storage that may result in a mess.

That's a very nice but almost to harmless way to phrase it.

> About 1)
> Seems to me that having a different interface for each semantic is an overkill, extra code to maintain.  And extra work when a new semantic comes along.
> To keep things simple, keep one set of interfaces (per IO interface, per file interface) for all write hints semantics, and carry the difference in semantic in the hint itself.
> For example, with 32 bits hints, store the semantic in 8 bits and the use the rest in the context of that semantic.

This is very similar to what the never followed up upon Kanchan did.

I think this is a lot better than blindly overloading a generic
"write hint", but still suffers from problems:

 a) the code is a lot more complex and harder to maintain than just two
    different values
 b) it still keeps the idea that a simple temperature hint and write
    stream or placement identifiers are someting comparable, which they
    really aren't.

> About 2)
> Provide a simple way to the user to decide which layer generate write hints.
> As an example, as some of you pointed out, what if the filesystem wants to generate write hints to optimize its [own] data handling by the storage, and at the same time the application using the FS understand the storage and also wants to optimize using write hints.
> Both use cases are legit, I think.
> To handle that in a simple way, why not have a filesystem mount parameter enabling/disabling the use of write hints by the FS?

The file system is, and always has been, the entity in charge of
resource allocation of the underlying device.  Bypassing it will get
you in trouble, and a simple mount option isn't really changing that
(it's also not exactly a scalable interface).

If an application wants to micro-manage placement decisions it should not
use a file system, or at least not a normal one with Posix semantics.
That being said we'd demonstrated that applications using proper grouping
of data by file and the simple temperature hints can get very good result
from file systems that can interpret them, without a lot of work in the
file system.  I suspect for most applications that actually want files
that is actually going to give better results than trying to do the
micro-management that tries to bypass the file system.

I'm not sure if Keith was just ranting last night, but IFF the assumption
here is that file systems are just used as dumb containers and applications
manage device level placement inside them we have a much deeper problem
than just interface semantics.

