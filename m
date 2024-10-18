Return-Path: <io-uring+bounces-3805-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14AE09A34CF
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 07:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8AA91F2510C
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 05:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9BB317F505;
	Fri, 18 Oct 2024 05:53:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1833717E01C;
	Fri, 18 Oct 2024 05:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230832; cv=none; b=DqgSGSCrn0LrcFW/FGS7QAbZcwaC1/UXpfswBc9eeyZKFKfiocSVJMWuO76bSP5fRAF46adXvttCa71P5zRW9spboeFwFgkmzVNDnNhAKeEG+zAoo25SllQG0bR719fhjccbtgNT8asTt/HHOqH3XQQVmViTXjHQQLTGRQRjYKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230832; c=relaxed/simple;
	bh=GQqb32SOvKRAmDPdQBnIumkswy7Rq+xxzhIoulCG7yU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TeuxCdtdqmxlj+WtQK2aNFYaZqr+l/W+WEpTCfSJSFrwL/iwbKv3wVg+r1yGFejvMddzgndbkLo8BaeQhg3CcYDmLD1A2aKv8kJxOEmG1hqjB8DrZmRIaBKI4SVTIFK+3T6RDmjbwJvaU2gN6xRfliNvTg0qgTTTwRcqVHfks3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 19FA0227AAF; Fri, 18 Oct 2024 07:53:48 +0200 (CEST)
Date: Fri, 18 Oct 2024 07:53:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv8 5/6] io_uring: enable per-io hinting capability
Message-ID: <20241018055347.GE20262@lst.de>
References: <20241017160937.2283225-1-kbusch@meta.com> <20241017160937.2283225-6-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017160937.2283225-6-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Same hint vs write stream thing here as well.

> +	if (ddir == ITER_SOURCE &&
> +	    req->file->f_op->fop_flags & FOP_PER_IO_HINTS)
> +		rw->kiocb.ki_write_hint = READ_ONCE(sqe->write_hint);
> +	else
> +		rw->kiocb.ki_write_hint = WRITE_LIFE_NOT_SET;

WRITE_LIFE_NOT_SET is in the wrong namespae vs the separate streams.

Either use 0 directly or add a separate constant for it.


