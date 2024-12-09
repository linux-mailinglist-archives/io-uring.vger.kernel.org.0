Return-Path: <io-uring+bounces-5317-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 531989E94D4
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 13:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1761281DEC
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 12:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C232248AA;
	Mon,  9 Dec 2024 12:51:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957292163B5;
	Mon,  9 Dec 2024 12:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733748700; cv=none; b=Wf6q7TogGWN1FjTCESdgd4CXuQb2796h2dI3ugTpIjP/JmG/O/iVgI9T9qVM2u10qh9ygz8lftNmNVv7zeCEEG23LD7qPvVNAkUXtzReww1bGr2kWDVSUqifEnFR7ZViTGD6XAn+8MXrzavRraby2CxU9WmJcaYCU06ux4dC8BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733748700; c=relaxed/simple;
	bh=RE85zvcWsHYYRWwdh+rcsRyrlZVndsgijOMo5PCCN8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXjxxN0Gcrjpe6Up7NkkfEB9spCNrSPgZORKTLyiF/6UypQFSXoNuYYx9XEv56Frt712cUgZLoxXCoaIEhX9zLSTIwoNRncq/dnvF9ZWtu/1JKni+LK7q/vg4CKvKbcqnjV0yNIw7NiFW0oJ5e+6C/BgyQ8kK/0TAQOZOZKECmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BB78D68D09; Mon,  9 Dec 2024 13:51:33 +0100 (CET)
Date: Mon, 9 Dec 2024 13:51:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv11 00/10] block write streams with nvme fdp
Message-ID: <20241209125132.GA14316@lst.de>
References: <20241206015308.3342386-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241206015308.3342386-1-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Note: I skipped back to this because v12 only had the log vs v11.

On Thu, Dec 05, 2024 at 05:52:58PM -0800, Keith Busch wrote:
> 
>  Not mixing write hints usage with write streams. This effectively
>  abandons any attempts to use the existing fcntl API for use with
>  filesystems in this series.

That's not true as far as I can tell given that this is basically the
architecture from my previous posting.  The block code still maps the
rw hints into write streams, and file systems can do exactly the same.
You just need to talk to the fs maintainers and convince them it's a
good thing for their particular file system.  Especially for simple
file systems that task should not be too hard, even if they might want
to set a stream or two aside for fs usage.  Similarly a file system
can implement the stream based API.


