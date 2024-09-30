Return-Path: <io-uring+bounces-3334-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E644698AC98
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 21:15:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B9B01C20A97
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 19:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15CF7199234;
	Mon, 30 Sep 2024 19:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gXT4V9R"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25321E49F;
	Mon, 30 Sep 2024 19:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727723727; cv=none; b=URxXEt02rqtcnLLyDST8TFuMmBAwex4Rg3Wwr0l9FWyoU+3OZ21YaTcN4f8cV+vMMwsv+DgWnI8TJEkN0CoiKTy0Tj1uNqFhLW02dJtBieahBpkl3dLlJ03e0ISZtctUIFIA3cZ92mIJfBATtR3UCFRpOhHgQPjJwfB2C8NrLj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727723727; c=relaxed/simple;
	bh=82nz+5A7EjVURRYOQrzWWLgwpl58/Y/kvPa3pBGW5P4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GACLJZKyE+62PS91sKkDzH1grcA9Dq1fODQoROb4/rNi86XC0pAFIkcXN6bzm3g/1rYYeYwYzUQ33OVKpeQnfShvAif0dhxjTES8q6NXvpfanOuFHFvSCmEKT5TmVZIYmcPmImJzBPhj9ryieqEM+5aeC6/DFZn4GU+R1Go4U2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gXT4V9R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7ABC4CEC7;
	Mon, 30 Sep 2024 19:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727723726;
	bh=82nz+5A7EjVURRYOQrzWWLgwpl58/Y/kvPa3pBGW5P4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2gXT4V9RudpeiG0lP0J4rt+veiwdjhDXlXzRvQ1iPlIIx+2egAYE8Ekr8odR4Xflv
	 vrrSQwrQjsAnwuuxrBath5HfNPfG/NCedYamf0QjpngVIUZqIGObXk0zvkR9BDlwDl
	 ap3xSwjBkZ4MRNJm2I79xdGa0iy4sgEnm0T+ywp8=
Date: Mon, 30 Sep 2024 21:15:23 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: axboe@kernel.dk, stable@vger.kernel.org, asml.silence@gmail.com,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	cgroups@vger.kernel.org, dqminh@cloudflare.com, longman@redhat.com,
	adriaan.schmidt@siemens.com, florian.bezdeka@siemens.com
Subject: Re: [PATCH 6.1 0/2] io_uring/io-wq: respect cgroup cpusets
Message-ID: <2024093053-gradient-errant-4f54@gregkh>
References: <20240911162316.516725-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911162316.516725-1-felix.moessbauer@siemens.com>

On Wed, Sep 11, 2024 at 06:23:14PM +0200, Felix Moessbauer wrote:
> Hi,
> 
> as discussed in [1], this is a manual backport of the remaining two
> patches to let the io worker threads respect the affinites defined by
> the cgroup of the process.
> 
> In 6.1 one worker is created per NUMA node, while in da64d6db3bd3
> ("io_uring: One wqe per wq") this is changed to only have a single worker.
> As this patch is pretty invasive, Jens and me agreed to not backport it.
> 
> Instead we now limit the workers cpuset to the cpus that are in the
> intersection between what the cgroup allows and what the NUMA node has.
> This leaves the question what to do in case the intersection is empty:
> To be backwarts compatible, we allow this case, but restrict the cpumask
> of the poller to the cpuset defined by the cgroup. We further believe
> this is a reasonable decision, as da64d6db3bd3 drops the NUMA awareness
> anyways.
> 
> [1] https://lore.kernel.org/lkml/ec01745a-b102-4f6e-abc9-abd636d36319@kernel.dk

Why was neither of these actually tagged for inclusion in a stable tree?
Why just 6.1.y?  Please submit them for all relevent kernel versions.

thanks,

greg k-h

