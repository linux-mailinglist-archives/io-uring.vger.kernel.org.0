Return-Path: <io-uring+bounces-3851-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 697BF9A6DAA
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 17:08:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 211B52821EE
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 15:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30DF1E7677;
	Mon, 21 Oct 2024 15:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHHwG50f"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9451D318A;
	Mon, 21 Oct 2024 15:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729523290; cv=none; b=kzJBNHKWESljfgYRVdoNLdj6ltaUYlBNn+VARYJ0ovmxwwxJpbBwZmsaZ2fN7U3zjHOHCsJtU4856ztVdGI9pjTuW+ByDQqEbcpvvhM7x8cPDxyadPqMZCJ6FHHWgiEp6HUWM/GF5p1Z4+krzklURV0vDf1tEBfDpfdGm66E9+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729523290; c=relaxed/simple;
	bh=ReDL3ufF8xB34lUBND8ER2zp/tzHMXqwl2b0BMRiFlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uX3BT4GGeYmXzIpDeE4bemnO/Du9/m7MvUstaOEmQSIM9uvCt8psRaDxos0ffdlkKkYo2UUUw6T+1YrSYJtApcNoeMoBE5iTPqueA0pXV2S1lejlVWK0wDMlkf341OSJetqvc6zcQAp2pO1o7LfBJAgfgLuiNN/BnJGgJqatIG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHHwG50f; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E82CC4CEC3;
	Mon, 21 Oct 2024 15:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729523290;
	bh=ReDL3ufF8xB34lUBND8ER2zp/tzHMXqwl2b0BMRiFlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jHHwG50fipS1cWs6q0NWC5JzV1tgFDLB49GWxMwYiuJtR2QzwHZ+xEkBGp7NLloBf
	 aAxT+dwH97OWjJ7WuBE/1ektMGpuezO5/ZIV/rOvjW7U64lYdIox9bmniMlYoMwoqO
	 CEqJMun2yuzWK9KVH/YXoti/6ktOkwdy7G6FrDu+wL9RC0mrkfZMZ08meJzzrROVaj
	 J7BhgObQSS0Ye0DFNrisLOiXzZQg0EGgN0iNcMJmoWYyPwyI946cT4XMfc0h/sIKmx
	 MrWi1MreXE/CYwf+vzKBM//agLH14PIg51ZInXlMmVojCKEDO15kFMmo1gXuHh955A
	 vWypV/7h0Ro2Q==
Date: Mon, 21 Oct 2024 09:08:07 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, axboe@kernel.dk, hch@lst.de,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	javier.gonz@samsung.com, Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv8 6/6] nvme: enable FDP support
Message-ID: <ZxZuV0Uzn5qNmwAc@kbusch-mbp>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <CGME20241017161628epcas5p1006f392dc6c208634997f3a950ec8c67@epcas5p1.samsung.com>
 <20241017160937.2283225-7-kbusch@meta.com>
 <77feb398-d6af-4f07-93bc-b12165604f04@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77feb398-d6af-4f07-93bc-b12165604f04@samsung.com>

On Fri, Oct 18, 2024 at 04:18:17PM +0530, Kanchan Joshi wrote:
> On 10/17/2024 9:39 PM, Keith Busch wrote:
> >   
> > +#define NVME_MAX_PLIDS   (NVME_CTRL_PAGE_SIZE / sizeof(16))
> > +
> 
> Seems you intended sizeof(u16).

Ha, yes, that's the intended type. I don't have anything close to 1k
placement hints, so would have never noticed this was the wrong size.

