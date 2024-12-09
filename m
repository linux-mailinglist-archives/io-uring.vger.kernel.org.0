Return-Path: <io-uring+bounces-5349-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35DAE9E9CFF
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 18:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D84AE280E0B
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB14814F9F8;
	Mon,  9 Dec 2024 17:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LiG6rHA/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0C0146D57;
	Mon,  9 Dec 2024 17:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733765115; cv=none; b=TvXReE40vLjG7hz98VqwbcVEMUQOxWBCNtFAmZj63NpQDooyHeu13bV5//OjDPw+Cn0bPR41y0G9o1UVek6zhcclnUgS9bwka4hZgNb469lv8eFGOYQn5gSSxMWEfBcWCgdfAGKfoQEEoX+22C+Q5o8qTl04W55F98gHZPE5xpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733765115; c=relaxed/simple;
	bh=UunNpXZLaCyhhmqBaF7F2iv/OIXmf6YTRKMXx11BKOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b90hAtCCfBI8RV5xX69wNzCpmTQZWRWoJyigi8DgXoGOedup14rmOC9VVGEeTCYwrjsuzY8mL8QF35pJlNeVhRL+U/elzRVGZhCfW/jW8Dhfgd8wk4bgs25pyVRuVkuDyOOAQdevH1awwZ+AJztjKevUGSD4J9jtH5NFnSxSck0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LiG6rHA/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5A0C4CED1;
	Mon,  9 Dec 2024 17:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733765115;
	bh=UunNpXZLaCyhhmqBaF7F2iv/OIXmf6YTRKMXx11BKOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LiG6rHA/QSaokIFPmLccdq1P1TnM+ReNY+PAMBZitZU6bcUNzaGsywjVdrb5DLUp3
	 NUirGGGmEW9J9rkt5NvcWYZb6UlY2Cb4LA3sLkAofakmiCoZszJwurL5KODlil0hLy
	 YVpdrmN7MRw7vL03vl7CLJicke/zrv2X6ESnuK5mjj+wQ7e4Q743Pt7QsAv8yDXybt
	 NggcvLEvltT/Us2ctg+vYerMfJYVAXXIZuyaG9NBmuH0vMrll2v+rqbMP3dX0VNcpn
	 cFcWZjlONIAeObu7st/EpKPVb2O3NxJghBoOZs6dH41nciyzO12bfa56gV2eiQLDks
	 TFP+EfUhvm01A==
Date: Mon, 9 Dec 2024 10:25:12 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pierre Labat <plabat@micron.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [EXT] Re: [PATCHv11 00/10] block write streams with nvme fdp
Message-ID: <Z1cn-LLW3pGqJFqC@kbusch-mbp.dhcp.thefacebook.com>
References: <20241206015308.3342386-1-kbusch@meta.com>
 <20241209125132.GA14316@lst.de>
 <DS0PR08MB85414C2FDCFE1F98424C0366AB3C2@DS0PR08MB8541.namprd08.prod.outlook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR08MB85414C2FDCFE1F98424C0366AB3C2@DS0PR08MB8541.namprd08.prod.outlook.com>

On Mon, Dec 09, 2024 at 05:14:16PM +0000, Pierre Labat wrote:
> I was under the impression that passing write hints via fcntl() on any
> legacy filesystem stays. The hint is attached to the inode, and the fs
> simply picks it up from there when sending it down with write related
> to that inode.
> Aka per file write hint.
>
> I am right?

Nothing is changing with respect to those write hints as a result of
this series, if that's what you mean. The driver hadn't been checking
the write hint before, and this patch set continues that pre-existing
behavior. For this series, the driver utilizes a new field:
"write_stream".

Mapping the inode write hint to an FDP stream for other filesystems
remains an open topic to follow on later.

