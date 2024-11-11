Return-Path: <io-uring+bounces-4592-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F7EC9C38A3
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 07:52:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 277021F211B9
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 06:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B562512F59C;
	Mon, 11 Nov 2024 06:51:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7B150276;
	Mon, 11 Nov 2024 06:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731307915; cv=none; b=rXn0Mkr41eYYidPe30T+sukrb3YgsO5oG7f7mwmIWxYuJ56SZvbjSiK0Q06ipFy+12AjA7fHngiECQkFrpwUrH5Tm7LKqA2sX3bfql1ZHFiUCAX9FMFFHETjZCkLNyawSQ3hYrAP3KNPtX1Ywo1vyQgHclKGn+tIXXZBLqOIJps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731307915; c=relaxed/simple;
	bh=dNg5OUTs7eYh41E8GdwTE3yqH4TylN03QsfQRqUTRY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Re1YvX1wFSwv+I0Yjwv6D1Mm/56fDUlmMsx3MLfdIYloLO5D9TGLl4wSup/ei18oOKJ0NAdpXV3ql5k6ufR/bDhpfZ3XrGbgQ5m1uL9cdSdfwFcexA7K06/GmJ6EH2ccSacV/pE+iXLXlzxnnoOcvVeg9MurAFf5AwMCxS0deL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EBD4668C7B; Mon, 11 Nov 2024 07:51:48 +0100 (CET)
Date: Mon, 11 Nov 2024 07:51:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Javier Gonzalez <javier.gonz@samsung.com>
Cc: Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241111065148.GC24107@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com> <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp> <20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp> <CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com> <Zy5CSgNJtgUgBH3H@casper.infradead.org> <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 08, 2024 at 05:43:44PM +0000, Javier Gonzalez wrote:
> We have been iterating in the patches for years, but it is unfortunately
> one of these series that go in circles forever. I don't think it is due
> to any specific problem, but mostly due to unaligned requests form
> different folks reviewing. Last time I talked to Damien he asked me to 
> send the patches again; we have not followed through due to bandwidth.

A big problem is that it actually lacks a killer use case.  If you'd
actually manage to plug it into an in-kernel user and show a real
speedup people might actually be interested in it and help optimizing
for it.


