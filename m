Return-Path: <io-uring+bounces-3343-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BA1798B618
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 09:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E066A1F225A1
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 07:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD451BD516;
	Tue,  1 Oct 2024 07:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLb2gS3l"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E7063D;
	Tue,  1 Oct 2024 07:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727769012; cv=none; b=XSx/eiKnhkNJ/XiV4wA0WjHTaUih6YlpbY4lsh3BVUX2fHrEn/ik3SDNeLnEGaK0mDb6YSGROIFRj976dtSbFsS6QgJ/h2aAd01LT7ap6gCY1ZmKLMvIK+uBioDjbIQAFmt/+TzNQEglVoVpXMulmOPaC/KhVP75OB3LuBqdTWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727769012; c=relaxed/simple;
	bh=b45yf7L4WkxZYJGLw7J41JUR3kvqxzDmEvQaBCcHb6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EAua2HvwAZnc9DcG7PbOX6lELgVS2l1b1aASCwtPJHncdjit79ba8KEFK8i65KOLhRvESf2SIwFzRVwvj6Hd3CFPr3/jAaa8g4BVQCVihPEa7po3ZcRPa/qSpCnC3vgVoljkn1L5InEQnTTs5dyagMh3VyMit0c8wXY7hFheLMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLb2gS3l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61480C4CECE;
	Tue,  1 Oct 2024 07:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727769011;
	bh=b45yf7L4WkxZYJGLw7J41JUR3kvqxzDmEvQaBCcHb6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DLb2gS3l3OOZtE4xKvml4BpO6YzOqYyIyno6XXd9hUC9qgHuLFp8tzEoFAk/wucSx
	 nFZoSLFigCo1f/ZV7iOV+3Gx5Pmo0mw59gWFFbS2sNG4izwR4qK1PmrFeffwkqlM2w
	 mW3xkPmKteT4iz26NgbzbJoosDnrYwkzEhWDgXZE=
Date: Tue, 1 Oct 2024 09:50:09 +0200
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
Cc: "Schmidt, Adriaan" <adriaan.schmidt@siemens.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"Bezdeka, Florian" <florian.bezdeka@siemens.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"longman@redhat.com" <longman@redhat.com>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"dqminh@cloudflare.com" <dqminh@cloudflare.com>
Subject: Re: [PATCH 6.1 0/2] io_uring/io-wq: respect cgroup cpusets
Message-ID: <2024100108-facing-mobile-1e4a@gregkh>
References: <20240911162316.516725-1-felix.moessbauer@siemens.com>
 <2024093053-gradient-errant-4f54@gregkh>
 <db8843979322b9a031b5d9523b6b07dca9c13546.camel@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db8843979322b9a031b5d9523b6b07dca9c13546.camel@siemens.com>

On Tue, Oct 01, 2024 at 07:32:42AM +0000, MOESSBAUER, Felix wrote:
> On Mon, 2024-09-30 at 21:15 +0200, Greg KH wrote:
> > On Wed, Sep 11, 2024 at 06:23:14PM +0200, Felix Moessbauer wrote:
> > > Hi,
> > > 
> > > as discussed in [1], this is a manual backport of the remaining two
> > > patches to let the io worker threads respect the affinites defined
> > > by
> > > the cgroup of the process.
> > > 
> > > In 6.1 one worker is created per NUMA node, while in da64d6db3bd3
> > > ("io_uring: One wqe per wq") this is changed to only have a single
> > > worker.
> > > As this patch is pretty invasive, Jens and me agreed to not
> > > backport it.
> > > 
> > > Instead we now limit the workers cpuset to the cpus that are in the
> > > intersection between what the cgroup allows and what the NUMA node
> > > has.
> > > This leaves the question what to do in case the intersection is
> > > empty:
> > > To be backwarts compatible, we allow this case, but restrict the
> > > cpumask
> > > of the poller to the cpuset defined by the cgroup. We further
> > > believe
> > > this is a reasonable decision, as da64d6db3bd3 drops the NUMA
> > > awareness
> > > anyways.
> > > 
> > > [1]
> > > https://lore.kernel.org/lkml/ec01745a-b102-4f6e-abc9-abd636d36319@kernel.dk
> > 
> > Why was neither of these actually tagged for inclusion in a stable
> > tree?
> 
> This is a manual backport of these patches for 6.1, as the subsystem
> changed significantly between 6.1 and 6.2, making an automated backport
> impossible. This has been agreed on with Jens in
> https://lore.kernel.org/lkml/ec01745a-b102-4f6e-abc9-abd636d36319@kernel.dk/
> 
> > Why just 6.1.y?  Please submit them for all relevent kernel versions.
> 
> The original patch was tagged stable and got accepted in 6.6, 6.10 and
> 6.11.

No they were not at all.  Please properly tag them in the future as per
the documentation if you wish to have things applied to the stable
trees:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

thanks,

greg k-h

