Return-Path: <io-uring+bounces-4119-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C8F39B4DD4
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E561728464C
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5CB7192D84;
	Tue, 29 Oct 2024 15:24:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FBA192D83;
	Tue, 29 Oct 2024 15:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215484; cv=none; b=rzdBbepI79S3g7k+dEmFjt7NEoxFz19YCMQYNOo72mDFgYIk7P/HBG7g+8InncRXe2X78OBRO7m6q1qjU/VmVeinOh3Psva8kJzpBSc5nhTQ3LhFw4ZbD8xhWcRV5X6YV6FiH7d3JVvarXsYju+nxkXiL0Uo3gcUDAxluOVhKxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215484; c=relaxed/simple;
	bh=I5XQ9PqLQOoFW6msA46LNw/i6tCPvW4825X1enqJV/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PgmxNBNt69VEKN1fDdLRM87n8QQtY+AuOL5o/2IsdX0XonVz0Zc5AWzEujdl4SnnxMDkF/oQGta4q6xKlSntbUANzSQ5gbJCW4DXx7ALjLDMrCBFAWo1aybOLCcE24veGk1ZZICaZw9UEOaEXdieUFV1nPLIH+kiHW/zlCfgYWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 856E2227A88; Tue, 29 Oct 2024 16:24:39 +0100 (CET)
Date: Tue, 29 Oct 2024 16:24:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241029152438.GB26431@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029151922.459139-1-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 29, 2024 at 08:19:13AM -0700, Keith Busch wrote:
>   Return invalid value if user requests an invalid write hint
> 
>   Added and exported a block device feature flag for indicating generic
>   placement hint support

But it still talks of write hints everywhere and conflates the write
streams with the temperature hints which are completely different
beasts.


