Return-Path: <io-uring+bounces-4830-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 33E539D2619
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:49:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3EE41F238AD
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C0C1C2317;
	Tue, 19 Nov 2024 12:49:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755681C1AD8;
	Tue, 19 Nov 2024 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732020584; cv=none; b=qOI6eXpm+F5rrQmsTaOuOd0JeFZthI+j7hHcC4y5ElV0Yodq/0IZkyhMqgBoV/PQrMMdiJMi5vDSs/m+20EU4tKJVdx0ravG974SxeEuyB6EdzeCCrH5eyhgxs4qKKEDZ29aobsnM3uCn//t6eKeyUvsA1iUuOgoNNtliLZDB94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732020584; c=relaxed/simple;
	bh=TnWZqNO2/O4MYG5QQufdWXx1V0RuqfMZA1g8H4B15eU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eStBEFo/9tYKAUzzh8tF4uPC7vr03Gc1oFcLO/TYSQHuac9poYyBZXhI+m3RNwBX6dD722/qkBMBjEQ8WKevfpYCxmSHPFFmcHevFrAQ3pnbe1jbVv0LEX2fN6PEh3lzLOqQEI9bP3lKowKY8je3wodY7l6JrEl+ZyzsTWIw4UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 62AAE68D81; Tue, 19 Nov 2024 13:49:38 +0100 (CET)
Date: Tue, 19 Nov 2024 13:49:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241119124938.GA30988@lst.de>
References: <20241114104517.51726-1-anuj20.g@samsung.com> <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com> <20241114104517.51726-7-anuj20.g@samsung.com> <c622ee8c-82f0-44d4-99da-91357af7ecac@gmail.com> <b61e1bfb-a410-4f5f-949d-a56f2d5f7791@gmail.com> <20241118125029.GB27505@lst.de> <2a98aa33-121b-46ed-b4ae-e4049179819a@gmail.com> <20241118170329.GA14956@lst.de> <4f5ef808-aef0-40dd-b3c8-c34977de58d2@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f5ef808-aef0-40dd-b3c8-c34977de58d2@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 18, 2024 at 05:45:02PM +0000, Pavel Begunkov wrote:
> Exactly, _fast path_. PI-only handling is very simple, I don't buy
> that "complicated". If we'd need to add more without an API expecting
> that, that'll mean a yet another forest of never ending checks in the
> fast path effecting all users.

Well, that's a good argument for a separate opcode for PI, or at least
for a 128-byte write, isn't it?  I have real hard time trying to find
a coherent line in your arguments.


