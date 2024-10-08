Return-Path: <io-uring+bounces-3462-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC0CF993DCC
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 06:08:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AE861F2234C
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 04:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9FBB37171;
	Tue,  8 Oct 2024 04:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="tGDqaCka"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C7534CF5;
	Tue,  8 Oct 2024 04:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728360506; cv=none; b=SD9zSfli2pgdhfvEbC0fTPopAAbOSWFBTwDRUCO7LiDYmO34hIj9P8UVw8RVjUAu7a71nEOSBxnrsi6/dOZDhZuDNtha7RbAdf9JGCL7Yi0rfqgqXCKUvA0jp000tppWPbDO61Eigsjuju28ksP8jWvYp1ucpTFPpnR1f34GzEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728360506; c=relaxed/simple;
	bh=bGSSXqkDC77L/jHqbWDlsIj40Y3cHU10KamYolKowtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NaGqKb9qvNxM7FlvnXi36mPQPKKbZpY3kKGG+jwe+pjVv5R4P2fQIEM3UDHderQIr61JQajuncPv4INWkHRp6kJHq74yqWOrLfid9niEVabQDNCQRPCMBsA5xpC46esLFkfWGOcuG5j5SxkNlZlzglehBdhEaTTnV/WyZkA+0nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=tGDqaCka; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P3U3gCku+Che5liNxFQp/S+uDp0nZCeCL5rN6L7yXA8=; b=tGDqaCkag+5y/ySMD7tm3K2El9
	tGQWSI8Sxq0drlCMUhmo3njCprnYBGGsaI6ocIBDd2hZwPrp9oy8vXr64Rhrna+O4dTU9pWmIPNmT
	LSB1KnzDvchQOy8E1hwNCojL3yxX0ltw1FIKjtJ4EfTbFae271xQCnYIkDnyRTjvOeB6iEOn6+0dj
	lWOOg5uXGQjNFwlCEuY0SzKCzfUBLcin6U1ojkoz7RMpVoElUemIMxayekAY4bvEfcl62dmVW+MqA
	WyxGRz5KjQPmC0M/8vPkvm9O9jt7DWvRr9m69Dw3RFGTsUcQqnH2ITPyXaEk+e/4yt28a4Nvuy/pI
	Nk5lpzCg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sy1WD-00000001lWg-3ofk;
	Tue, 08 Oct 2024 04:08:17 +0000
Date: Tue, 8 Oct 2024 05:08:17 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	io-uring@vger.kernel.org, cgzones@googlemail.com
Subject: Re: [PATCH 5/9] replace do_setxattr() with saner helpers.
Message-ID: <20241008040817.GU4017910@ZenIV>
References: <a2730d25-3998-4d76-8c12-dde7ce1be719@kernel.dk>
 <20241002211939.GE4017910@ZenIV>
 <d69b33f9-31a0-4c70-baf2-a72dc28139e0@kernel.dk>
 <20241006052859.GD4017910@ZenIV>
 <69e696d7-637a-4cb2-912c-6066d23afd72@kernel.dk>
 <965e59b5-615a-4d20-bb04-a462c33ad84b@kernel.dk>
 <20241007212034.GS4017910@ZenIV>
 <2da6c045-3e55-4137-b646-f2da69032fff@kernel.dk>
 <20241007235815.GT4017910@ZenIV>
 <10fe7485-a672-4a66-9080-c8824b79a030@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10fe7485-a672-4a66-9080-c8824b79a030@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Oct 07, 2024 at 07:58:15PM -0600, Jens Axboe wrote:

> > OTOH, I'm afraid to let the "but our driver is sooo special!" crowd play
> > with the full set of syscalls...  init_syscalls.h is already bad enough.
> > Hell knows, fs/internal.h just might be a bit of deterrent...
> 
> Deduping it is a good thing, suggestion looks good to me. For random
> drivers, very much agree. But are there any of these symbols we end up
> exporting? That tends to put a damper on the enthusiasm...

	You wish...  init_unlink() et.al. are not just not exported, they
are freed once the system is booted.  Doesn't stop that kind of magic being
attempted.

