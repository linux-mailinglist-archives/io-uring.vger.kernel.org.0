Return-Path: <io-uring+bounces-4623-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18AAA9C59FD
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 15:12:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01E71B38ECD
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 13:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 749151DFF7;
	Tue, 12 Nov 2024 13:34:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0405570838;
	Tue, 12 Nov 2024 13:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731418492; cv=none; b=XJ2/Sv7hG1pX8tWQeNiGSENNldwyjp1/nClB2lGLZi3/nECSOHSLS451kHotpHlWwyU3SiWarot+2e0ld13slcJRIfYsE5WDaHkXrZW73FKI4VRWF3Rc2Kk9gyr/ZiaHf3eE3CcGtuweds+DRrNfoikQnOw0WD+SgqK0nKQ0RtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731418492; c=relaxed/simple;
	bh=IohhMWm0GLaqgM1mNYiMqChrCU01LrwRWo24VMDS5z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZbQxniu8qScSPdreN7reORpXxXnHaq5D3IwvBBwM9auk+cRF+M04B/NnyGQjVx0jkH6yh2c58d7+OGSBtcruHKmme39D5PDrh0tePF8ooiYD7tpYLTeQAil5HqbuYKB1WYaoBumN4PiKHsEYJm5F8XCrvKhvYeg32ll4v9ds/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3CDC268D0A; Tue, 12 Nov 2024 14:34:39 +0100 (CET)
Date: Tue, 12 Nov 2024 14:34:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, axboe@kernel.dk,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv11 0/9] write hints with nvme fdp and scsi streams
Message-ID: <20241112133439.GA4164@lst.de>
References: <20241108193629.3817619-1-kbusch@meta.com> <CGME20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b@epcas5p3.samsung.com> <20241111102914.GA27870@lst.de> <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 12, 2024 at 06:56:25PM +0530, Kanchan Joshi wrote:
> IMO, passthrough propagation of hints/streams should continue to remain 
> the default behavior as it applies on multiple filesystems. And more 
> active placement by FS should rather be enabled by some opt in (e.g., 
> mount option). Such opt in will anyway be needed for other reasons (like 
> regression avoidance on a broken device).

I feel like banging my head against the wall.  No, passing through write
streams is simply not acceptable without the file system being in
control.  I've said and explained this in detail about a dozend times
and the file system actually needing to do data separation for it's own
purpose doesn't go away by ignoring it.


