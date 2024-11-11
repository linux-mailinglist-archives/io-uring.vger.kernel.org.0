Return-Path: <io-uring+bounces-4591-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17EA99C389B
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 07:49:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0FDF281194
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 06:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5680F12F59C;
	Mon, 11 Nov 2024 06:49:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4F217F7;
	Mon, 11 Nov 2024 06:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731307791; cv=none; b=ATUOKb5a/6rDAWSnCMeDC5mjmYz1IgqY+D5ia6k83NXIRQJtKfKxmHulMYWg79L6hMj6pvou/RclUFRoUFeAsCUExFDhde0kPb4iYDU6LkdHLiwdfko+4ZRmPJtLaJ9DCyNsHF2b5elEgCKkq1YHRNa+dNc3uty1v9H/ldL34j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731307791; c=relaxed/simple;
	bh=qkYFkWpskSsb4NujsW5PiL0aplaDaJnVE7UyypbLDpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k01xo4/ngpA368xa3PCx5VtJGbZ4ZMI/cx3su8nqLM3tT8zKygsEkQ9bOcRe4afzehuo6dbTxNuCzoWY23JbaHFO0OPiW2x/5n6kxnTl+20GsfEq/r109vaymAAuGOYQZIqZElakv7SAhI7OF3Haz5glNkpnrPFXzj0+XXXb0gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 94AC968C7B; Mon, 11 Nov 2024 07:49:46 +0100 (CET)
Date: Mon, 11 Nov 2024 07:49:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241111064945.GB24107@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com> <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp> <20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp> <Zy5CSgNJtgUgBH3H@casper.infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zy5CSgNJtgUgBH3H@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 08, 2024 at 04:54:34PM +0000, Matthew Wilcox wrote:
> I like the idea of using copy-offload though.

FYI, the XFS GC code is written so that copy offload can be easily
plugged into it.  We'll have to see how beneficial it actually is,
but at least it should give us a good test platform.


