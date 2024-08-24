Return-Path: <io-uring+bounces-2933-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4557B95DCE9
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 10:25:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8E92B222F9
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 08:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFD725762;
	Sat, 24 Aug 2024 08:24:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543F3186A;
	Sat, 24 Aug 2024 08:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724487895; cv=none; b=HB1ypFig5DqRAa6s6hNPhLuc3beU97H8iu4qpERqoC3otKVFU+rMtAvMgbnaSXBIKL12UsHyKZsdFoV3ZJ+EKXdAIYsumaSuAQ7KLgqD8GU5FS/GuO3PwaTUyPmOdlW2vPEvdmvk79Nkr9fqR7rUmCUSMJqnk70Jdh6Dkf/2jEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724487895; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5sZh9LgGVlcF9LXP+5XJ46ocCd+QaVXZ22iONZeWhlrkJwUN8hOzg/eT7wxDL+eHKtYbP8KgoyLElf7nKKa1ipiuQ9xEgTErWuLs0gQcJHh2JpQDGGP37u3msc18GHJF699mj9Jyj8rvxC+X+ETVqSYxBihTVAVKLExq5pacWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C72F5227A87; Sat, 24 Aug 2024 10:24:50 +0200 (CEST)
Date: Sat, 24 Aug 2024 10:24:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 02/10] block: introduce a helper to determine
 metadata bytes from data iter
Message-ID: <20240824082450.GB8805@lst.de>
References: <20240823103811.2421-1-anuj20.g@samsung.com> <CGME20240823104618epcas5p4b9983678886dceed75edd9cbec9341b2@epcas5p4.samsung.com> <20240823103811.2421-3-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823103811.2421-3-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


