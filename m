Return-Path: <io-uring+bounces-3766-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42E9F9A1CE5
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 10:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE0AB1F27A0A
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 08:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3B51D54DA;
	Thu, 17 Oct 2024 08:15:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5CB1D45FB;
	Thu, 17 Oct 2024 08:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729152922; cv=none; b=Na0CzhgmxtYN38ZydzpTHqneliH5x6i2PcYLzvPdI6ykkZGw6NWP64X8oFFcvwiKoh4hp7sgN9+FPVZh/RTsxTUrdnsWe84YMiazt2c4kuWXhJMP5rBAD5JrzOqpE1y7piGCh0S0fv3FgKbZkO6M4EAfJxcUroKjk3teYhSZ8Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729152922; c=relaxed/simple;
	bh=o/6Kwr60CefBcIkM/Gw+YU/l2kDsya/Gg773xA0biks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zt55o58XE6W4MrYpp6o01pUCv98dfgHf71HdWDbz2qXGKELEHcE8EFaQc7btKnw3qDPzjsnqPjiBKRX437hhERiispMOLG7r71Fgz4S1EoSJcfwQJDucGgKv+KO1LUU32l71eEEDOBJvLwJb5uVfGilEH1mk7iTYqoMRLyLbBXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CE633227A87; Thu, 17 Oct 2024 10:15:15 +0200 (CEST)
Date: Thu, 17 Oct 2024 10:15:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com
Subject: Re: [PATCH v4 11/11] scsi: add support for user-meta interface
Message-ID: <20241017081514.GD27241@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e@epcas5p4.samsung.com> <20241016112912.63542-12-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016112912.63542-12-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 16, 2024 at 04:59:12PM +0530, Anuj Gupta wrote:
> Add support for sending user-meta buffer. Set tags to be checked
> using flags specified by user/block-layer user and underlying DIF/DIX
> configuration.

The patch itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

again this should move to before the user is added.

But we still seem to lack an interface to tell the userspace application
what flags are actually supported.  Just failing the I/O down in the
sd driver still feels suboptimal.


