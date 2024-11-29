Return-Path: <io-uring+bounces-5129-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D069DBF71
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 07:19:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E021281CA1
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 06:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B146B1537CB;
	Fri, 29 Nov 2024 06:19:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB78333C5;
	Fri, 29 Nov 2024 06:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732861189; cv=none; b=hHoct4W3Oho/fVPgt0OnXuAcFfOVxtFw4lxw4mvp9eTKCoz3a/cXG+Gffv57VSuezEL+hWccOgbonFAlhWgXhQtQWxYIupO5I0b7UnD2Pr16w1YVOln1m41lo/IGBm0gGxuxTohVH1QstdlYmB+ZbamqosH0qjFMc0qtPig7aDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732861189; c=relaxed/simple;
	bh=qSqLb7BZcVT2uKGBag8OryyBOgcsQgYjO4br+Pg3knY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RQp3UhE6lZ0cOeBwTbwTWjRnSIKQhugvSeXlWN+Uapx1vBroZxq26AmoFQCaCJOfwCuYc5Zh+WDGdUaTJbNaMs05kPA0oEoulv8fdE/SOW9NnQMkfMlX+Sdp+fclzgmwO5fZNT3xoLZYt5aCGA/a+q3YZbCREuIOlzWXevhGZyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 29B9D68D1C; Fri, 29 Nov 2024 07:19:42 +0100 (CET)
Date: Fri, 29 Nov 2024 07:19:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Javier Gonzalez <javier.gonz@samsung.com>,
	Matthew Wilcox <willy@infradead.org>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241129061941.GA2545@lst.de>
References: <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org> <20241112135233.2iwgwe443rnuivyb@ubuntu> <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com> <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org> <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com> <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org> <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com> <7835e7e2-2209-4727-ad74-57db09e4530f@acm.org> <yq1ed2wupli.fsf@ca-mkp.ca.oracle.com> <9e9ca761-6356-4a97-a314-d08bd5ea0916@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e9ca761-6356-4a97-a314-d08bd5ea0916@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 28, 2024 at 05:51:52PM +0900, Damien Le Moal wrote:
> > Maybe. But you'll have a hard time convincing me to add any kind of
> > state machine or bio matching magic to the SCSI stack when the simplest
> > solution is to treat copying like a read followed by a write. There is
> > no concurrency, no kernel state, no dependency between two commands, nor
> > two scsi_disk/scsi_device object lifetimes to manage.
> 
> And that also would allow supporting a fake copy offload with regular
> read/write BIOs very easily, I think. So all block devices can be
> presented as supporting "copy offload". That is nice for FSes.

Just as when that showed up in one of the last copy offload series
I'm still very critical of a stateless copy offload emulation.  The
reason for that is that a host based copy helper needs scratch space
to read into, and doing these large allocation on every copy puts a
lot of pressure onto the allocator.  Allocating the buffer once at
mount time and the just cycling through it is generally a lot more
efficient.


