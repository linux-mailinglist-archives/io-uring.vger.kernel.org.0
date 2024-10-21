Return-Path: <io-uring+bounces-3857-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B70B89A6EA9
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 17:47:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0CD71C21B91
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 15:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD5C1C68A7;
	Mon, 21 Oct 2024 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uJ6O3/Eg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C2B1C3F0B;
	Mon, 21 Oct 2024 15:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729525671; cv=none; b=cZupPjluSRBRm7JZhvqY9d68BwDdjDOe+++UXwgqp9vebuhO6O+NII8TZnd4i0K8h+BaF4xovv50H0UCgPhd/V37ZfE6Jkpteux8ufePbYHuurFyR/SpYrW++gnHdnO74lOKjVPNQhOEr1BvowNmvNUXPQ5coQYmIfAiccE+AIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729525671; c=relaxed/simple;
	bh=eoIDTD70jGHK8rQg1tI8OpdE3wiIkzDwBZrBOvTpqTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpcJ9wc/F13Cd+anVu8nkbpTPrkgzkOkUTLtg3P8UKFJx6dEtwioZRoJ2U0aLjcfqIAbb8u3LOUaBSRmwaMuZy0voxxL3SIx3IdDMjLuaUSmb3sEwKUTAm61KAR3WDomTVmz+De3jLmSKwjEZoy6gWK4dLgiHhYm6qjyBVz/Gqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uJ6O3/Eg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF50BC4CEC3;
	Mon, 21 Oct 2024 15:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729525670;
	bh=eoIDTD70jGHK8rQg1tI8OpdE3wiIkzDwBZrBOvTpqTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uJ6O3/Eg6LuZBVbvEhmJGmq5UhlraJjHuFScrTmXpEbKNqxl3qPWCqW9og//FdOw7
	 hfp0NqrPLYmgYPdeXpezpTfJ04KOnUCv9G2+czs7PPHV9dRShcsBk0Q0WxJs0GNuN8
	 UkrpQv50sacx/D8D/8C+f0jcf6P3LDBdaNzUpIRwJSpQvs865Cy65GK9ctVP75vriQ
	 pDZLbes5RePbk2QSNN9Iy3AUxFmd/e7JxGwLvMQkGwvigIA7axQxf1FoApGbxeavpO
	 Sb9UIt0xyMQQgHX4r+mr52vXegSrJlMS1/CVz9gmB5OVwVuaP9K70NWGxZICWFwf+g
	 7RwmJfZ2RfFfQ==
Date: Mon, 21 Oct 2024 09:47:47 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, axboe@kernel.dk,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv8 1/6] block, fs: restore kiocb based write hint
 processing
Message-ID: <ZxZ3o_HzN8HN6QPK@kbusch-mbp>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-2-kbusch@meta.com>
 <20241018055032.GB20262@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018055032.GB20262@lst.de>

On Fri, Oct 18, 2024 at 07:50:32AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 17, 2024 at 09:09:32AM -0700, Keith Busch wrote:
> >  {
> >  	*kiocb = (struct kiocb) {
> >  		.ki_filp = filp,
> >  		.ki_flags = filp->f_iocb_flags,
> >  		.ki_ioprio = get_current_ioprio(),
> > +		.ki_write_hint = file_write_hint(filp),
> 
> And we'll need to distinguish between the per-inode and per file
> hint.  I.e. don't blindly initialize ki_write_hint to the per-inode
> one here, but make that conditional in the file operation.

Maybe someone wants to do direct-io with partions where each partition
has a different default "hint" when not provided a per-io hint? I don't
know of such a case, but it doesn't sound terrible. In any case, I feel
if you're directing writes through these interfaces, you get to keep all
the pieces: user space controls policy, kernel just provides the
mechanisms to do it.

