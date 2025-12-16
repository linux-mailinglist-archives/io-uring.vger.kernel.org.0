Return-Path: <io-uring+bounces-11129-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D7121CC519A
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 21:31:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D3C930133A6
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 20:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B918D331213;
	Tue, 16 Dec 2025 20:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="wja1avNh"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA1032570E;
	Tue, 16 Dec 2025 20:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765916930; cv=none; b=krQD+XOdztsQ5D+wZ8a6a1gJgVqjTU0tlSfK9oWJCVUGpj6YKRbJ+7U+v1P8j9DYtEJ5K+X9XV0bo+JP6kEguKwbVUuOe/6Q03BzdFpp4Sn8v8P1F7QQx9eEkuB+3Pu8b/Ydd/jhQ9q1ORIgJ93Now00Fv36+XxL7mHCrtiLgyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765916930; c=relaxed/simple;
	bh=cZ9J0yCtRRvW8MLul0aNvzOyQ7FCswFchJ7kRazNs9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AwKDM3/9daBfzmfG8RHLCFLAD4w6UT86X1fRphHjSiluzMIymoPiAKguB8kbjcyrXovlfWAIYgGCS35Bg37zc7G3/bSm6zHLGV3VWlnJWttcOvWd4dJi11+LCEE1KftNlI0cRBnAHhloutqzxqRAer6RvyugYbN+6Mg02oJKA/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=wja1avNh; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZXGbBAGtFTGJQu6DvlRW8lD9k2adw+/xutbdi2KbdyA=; b=wja1avNh1ZdhJI8IajB25YJZWJ
	sROXCUBsZ6EkpL/Yc8QlhGgWPf+IHDU1NU4NnSLXQXNWBPo2H0GLxtRsoWLya5ViBQOGkXWSnlNW/
	bQCLnBEl0J+vczdTaI4X6y0ItsYhMXZfXztBm98XmEv1/PxCBtNLUxmWS1HdckCkz8uJpJcFIR15R
	5hC+pjbKGrF6EFq6j1Ad/6YFcwExWR2KzplC3srCw1uV2grOs+tqv86ViTtDYRNWpCQdhLAzmuCPa
	r5aDs4RNwB72D3Oz/AzhvDxT9cXtRU3KZNYHtlWHjt0Lx7oZYmeGPNYcdsD1+M3PnV/F2pnZS42ch
	CD3U2HVQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVbff-0000000HQE6-33GP;
	Tue, 16 Dec 2025 20:29:23 +0000
Date: Tue, 16 Dec 2025 20:29:23 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Askar Safin <safinaskar@gmail.com>
Cc: audit@vger.kernel.org, axboe@kernel.dk, brauner@kernel.org,
	io-uring@vger.kernel.org, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	mjguzik@gmail.com, paul@paul-moore.com,
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH v3 27/59] do_sys_openat2(): get rid of useless check,
 switch to CLASS(filename)
Message-ID: <20251216202923.GR1712166@ZenIV>
References: <20251216035518.4037331-28-viro@zeniv.linux.org.uk>
 <20251216200858.2255839-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216200858.2255839-1-safinaskar@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Dec 16, 2025 at 11:08:58PM +0300, Askar Safin wrote:
> Al Viro <viro@zeniv.linux.org.uk>:
> > do_file_open() will do the right thing is given ERR_PTR() for name...
> 
> Maybe you meant "right thing if given"?

d'oh...

