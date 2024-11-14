Return-Path: <io-uring+bounces-4692-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D1EC9C89A4
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 13:16:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA9B028346D
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 12:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 346A118DF8C;
	Thu, 14 Nov 2024 12:16:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BDA18B49D;
	Thu, 14 Nov 2024 12:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731586599; cv=none; b=bssN+Kxvu9sTyQhS+mPGBm4IfnkFRIuIf5uj7i+Nm66c8oYOxGm21kIbydvm7LYxnSn6qkFolDhbO/5WM+ULExqZeOXmhNmqDA3wH3DneDvt4iWeevRPmPAM/wFQNomSShkXimQ1XIGtu3YaExNbExqPbwLQoOK7lVA4NBp5rQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731586599; c=relaxed/simple;
	bh=kmRBExqNkFSntpIvkvZZfoizaMEPmX9e/ROqRbM9gOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJBWiRdN9yBJ02Qq/IPpVt5vGPjneste0ZtOrnwICyG2frJoEnTgeIT6ThkRz6fNpqCxg8o0ksnLBhdP+frZ0WIi/5inuhLhUwsDcjKlFUAiuPTRwevx2d6EvQXSDQFS5GJPsQq6vVUG52swJ8NQgyS1m2B8MlEMCzQZxuPa4yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0971C68C7B; Thu, 14 Nov 2024 13:16:33 +0100 (CET)
Date: Thu, 14 Nov 2024 13:16:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241114121632.GA3382@lst.de>
References: <20241114104517.51726-1-anuj20.g@samsung.com> <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com> <20241114104517.51726-7-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114104517.51726-7-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 14, 2024 at 04:15:12PM +0530, Anuj Gupta wrote:
> PI attribute is supported only for direct IO. Also, vectored read/write
> operations are not supported with PI currently.

Eww.  I know it's frustration for your if maintainers give contradicting
guidance, but this is really an awful interface.  Not only the pointless
indirection which make the interface hard to use, but limiting it to
not support vectored I/O makes it pretty useless.

I guess I need to do a little read-up on why Pavel wants this, but
from the block/fs perspective the previous interface made so much
more sense.

