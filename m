Return-Path: <io-uring+bounces-5125-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 229339DBB5F
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 17:40:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC65B163B86
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 16:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409AF1B415C;
	Thu, 28 Nov 2024 16:40:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA6A3232;
	Thu, 28 Nov 2024 16:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732812022; cv=none; b=CEtQGXeI2/EBaN4tcl36qYDZ04DQdSNVPc2HQ3UTmsIZGHKj9BeAsROICBq9Y8btoma8T9gpuAg2E+pgiClMZxnXUbAuFpUE2B1tpawNIELlhR3TSlT+ZSY9JNMHU+13c6qpIyWgYJrvT2LpMhieMui9MRUOa96S7lARw+GGpgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732812022; c=relaxed/simple;
	bh=2KNWJz+dCprzlzJ06B46V4J0MqyaE43k6Qpg1qYPkJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mGCOuDT7RR4fodx/myS7G9e2p8U8SO1toZ+ACs5+1qjZpjz8DNET7W9+Q5aYrRH5gBfArxzalyEbznu2vNtLBbTce9EuqkqJh0f1gh9PmUfMrv56yJKYOM1A+0sIslMElAdyJrvpXOBkqIx2LIS6eJSl4uOWaqz7W3O/Qwb5CgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7A7A568D96; Thu, 28 Nov 2024 17:40:04 +0100 (CET)
Date: Thu, 28 Nov 2024 17:40:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Javier Gonzalez <javier.gonz@samsung.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241128164002.GA26959@lst.de>
References: <2b5a365a-215a-48de-acb1-b846a4f24680@acm.org> <20241111093154.zbsp42gfiv2enb5a@ArmHalley.local> <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org> <20241112135233.2iwgwe443rnuivyb@ubuntu> <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com> <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org> <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com> <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org> <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com> <Z0iKbPttERXaiexO@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0iKbPttERXaiexO@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 28, 2024 at 08:21:16AM -0700, Keith Busch wrote:
> I think of copy a little differently. When you do a normal write
> command, the host provides the controller a vector of sources and
> lengths. A copy command is like a write command, but the sources are
> just logical block addresses instead of memory addresses.
> 
> Whatever solution happens, it would be a real shame if it doesn't allow
> vectored LBAs. The token based source bio doesn't seem to extend to
> that.

POPULATE TOKEN as defined by SCSI/SBC takes a list of LBA ranges as
well.

