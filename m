Return-Path: <io-uring+bounces-1404-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A058899ACE
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 12:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 072DC283D6D
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 10:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E2C1649D8;
	Fri,  5 Apr 2024 10:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5ed7ZiS"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E3615FD01;
	Fri,  5 Apr 2024 10:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712312867; cv=none; b=rS627ntmMJ76K+/K+RdfBTztndG2hJfQxzlwAH58BH2eui6CyEMHdpfTSxVSp+yBmQ+4oiurdcAbHIXQaKP7FK5pg9cWar2cmxdAndb2r7R5UOtnWne6No42q7X8syuG9pL5fjumQaXAOvG8rvD5DVXNq/ihwSywY7jPKde/iVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712312867; c=relaxed/simple;
	bh=usR1nfgCxnTrQPx2PAw4VOht6WCgJ31zN58wzqgyNS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFa7e9TVffG9JOA8IfqKprzqNDhkMd9b9GYwvmoVW5fhBhm9NH/k9zmLD5QvN/zqtLnGENwmshEZBNKtbXHKpKgcl0Jdk5bc+b0ontNkCkWyslDf7mT7V/i7S/fM/2y30w467HJIfbz/slpaUPqC1TW8i7KSDV5U3h9CiV3sodY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5ed7ZiS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A28C43394;
	Fri,  5 Apr 2024 10:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712312867;
	bh=usR1nfgCxnTrQPx2PAw4VOht6WCgJ31zN58wzqgyNS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b5ed7ZiSlY2HiJNupFupcPOIrwCtabMASI8qzae/gqZHAHhYSYfW89Q13YxkgJ0fv
	 7M6Q44edZDJAWy4qzGpOreUzj6F789PzsdufgPM9Xy22VWbjXRGfnzxPKsBkBnZ/eY
	 JlavoXRoPVPIiaaUGXbXu3xMx/oDgCm9LTvqG0qNyNsVmSeFxcR3D/1wCZSAQLHZo1
	 mrl7gJmVuf53ZVzRTqr2/9l8SLF6goEat4pvIK8P5CaDnc5Pe69EJm9EyUJmn/vOaQ
	 b5Xzn6aaI9gKfkLrxUAMaSLWC0O62StG5GISS2JLQt3g1aSgZutVG9SkdvvMHgvmDZ
	 s02Kd+UFEjtnA==
Date: Fri, 5 Apr 2024 12:27:41 +0200
From: Christian Brauner <brauner@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org, 
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH v2] fs: claw back a few FMODE_* bits
Message-ID: <20240405-vorhof-kolossal-c31693e3fdbe@brauner>
References: <20240328-gewendet-spargel-aa60a030ef74@brauner>
 <9bb5e9ad-d788-441e-96f3-489a031bb387@sirena.org.uk>
 <20240404091215.kpphfowf5ktmouu7@quack3>
 <6fb750e5-650e-42dd-8786-3bf0b2199178@sirena.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6fb750e5-650e-42dd-8786-3bf0b2199178@sirena.org.uk>

On Thu, Apr 04, 2024 at 12:43:30PM +0100, Mark Brown wrote:
> On Thu, Apr 04, 2024 at 11:12:15AM +0200, Jan Kara wrote:
> > On Wed 03-04-24 22:12:45, Mark Brown wrote:
> 
> > > For the past couple of days several LTP tests (open_by_handle_at0[12]
> > > and name_to_handle_at01) have been failing on all the arm64 platforms
> > > we're running these tests on.  I ran a bisect which came back to this
> 
> > Do you have some LTP logs / kernel logs available for the failing runs?
> 
> Actually it looks like the issue went away with today's -next, but FWIW
> the logging for the open_by_handle_at0[12] failures was:

The bug was with:

fs: Annotate struct file_handle with __counted_by() and use struct_size()

and was reported and fixed in the thread around:

https://lore.kernel.org/r/20240403110316.qtmypq2rtpueloga@quack3

so this is really unrelated.

