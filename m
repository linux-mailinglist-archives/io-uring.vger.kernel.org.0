Return-Path: <io-uring+bounces-3413-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5BD9902F0
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 14:32:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1B26B20EDD
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 12:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A6C532C8B;
	Fri,  4 Oct 2024 12:32:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A4F18E1F;
	Fri,  4 Oct 2024 12:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728045132; cv=none; b=Nyd4Qr6cK4vFHr66LKvfTKzfONZw3hB2s8aP6W02uSRCnBCgl5WdkrAlG+lbi1nYOaDJR2ssHdTx3cQtPwBRUMpCj9PVsb5I79oUNo9NVmVmdII6aR7q3dUPKCjmJGJfoGrTsZRaAa2jdJKi92QcKOa050JMnUVBooAqIGEnrDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728045132; c=relaxed/simple;
	bh=H7wiKG/H/1a9IW9aYw1sxlxUizrqajj6cxkw+Im4NGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EetFerwsrzTBSVRK2V3xriiwH+vdoWE0s8oeXA9AToHXUPZ0UQiKX8hUDpK5XNQeKQAOfUihbHXB4N9btpBM8yJi4JS3p8w8Lf5u27GUYbe/kq6QFoLU69VxU2HCxNsFA7WdVJB6FyN8sMD1S5Wi/ZaCCwbKFCf9Fl9KcQ9kMk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 87712227A87; Fri,  4 Oct 2024 14:32:06 +0200 (CEST)
Date: Fri, 4 Oct 2024 14:32:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Kanchan Joshi <joshi.k@samsung.com>, hare@suse.de, sagi@grimberg.me,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241004123206.GA19275@lst.de>
References: <20241002151344.GA20364@lst.de> <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com> <20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com> <a8b6c57f-88fa-4af0-8a1a-d6a2f2ca8493@acm.org> <CGME20241003125523eucas1p272ad9afc8decfd941104a5c137662307@eucas1p2.samsung.com> <20241003125516.GC17031@lst.de> <20241004062129.z4n6xi4i2ck4nuqh@ArmHalley.local> <20241004062415.GA14876@lst.de> <20241004065923.zddb4fsyevfw2n24@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241004065923.zddb4fsyevfw2n24@ArmHalley.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 04, 2024 at 08:59:23AM +0200, Javier González wrote:
> FDP has authors from Meta, Google, Kioxia, Micron, Hynix, Solidigm,
> Microship, Marvell, FADU, WDC, and Samsung.
>
> The fact that 2 of these companies are the ones starting to build the
> Linux ecosystem should not surprise you, as it is the way things work
> normally.

That's not the point.  There is one company that drivers entirely pointless
marketing BS, and that one is pretty central here.  The same company
that said FDP has absolutely no іntent to work on Linux and fought my
initial attempt to make the protocol not totally unusable ony layer system.
And no, that's not Samsung.

