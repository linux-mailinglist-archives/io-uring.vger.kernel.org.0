Return-Path: <io-uring+bounces-946-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A2E87C2B1
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 19:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5944B1C219D2
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 18:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8261873515;
	Thu, 14 Mar 2024 18:32:01 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39117350B;
	Thu, 14 Mar 2024 18:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710441121; cv=none; b=EZoUVEHF++UUYYt9fb4/hpjdkwvysB7w0VUIEI9O2BDkfjP0eTCf6ipD2zul41ZM0Vay59ZbvyxbNemQA6K2KZ/JiceRnVHizaFGaAt7qQxyvwHP8orXEaXHYptopGpdU5Qq6kM/b2cyAyj/DouG1jAfxb0+2g+ND+dPzIeYFjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710441121; c=relaxed/simple;
	bh=mvdnoLfy3ROkxmfR7t2H/wROfPIdheF/nBqPtCWPX4A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=caLa/U/pxbHZR3c2cgLYTWNfRiA+6oquCYVT0Zmwd3BR/OrkH/rbhZk1lY5pP3oWRjph2JZwAmOZLHBdGaQYp7AYEQdESRFcyNEAwWBKfS3IFbfttuB+96ugNrUdTjPMYwMOfjTBCQ7G8BRIlMWMFp5hWA2G/VbK2/563kweVw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A243FC43390;
	Thu, 14 Mar 2024 18:31:55 +0000 (UTC)
Date: Thu, 14 Mar 2024 14:34:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Alison Schofield <alison.schofield@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-block@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 amd-gfx@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, virtualization@lists.linux.dev,
 linux-rdma@vger.kernel.org, linux-pm@vger.kernel.org,
 iommu@lists.linux.dev, linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
 linux-hyperv@vger.kernel.org, ath10k@lists.infradead.org,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 ath12k@lists.infradead.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-usb@vger.kernel.org,
 linux-bcachefs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-edac@vger.kernel.org,
 selinux@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-hwmon@vger.kernel.org, io-uring@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-wpan@vger.kernel.org, dev@openvswitch.org,
 linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net, Julia
 Lawall <Julia.Lawall@inria.fr>
Subject: Re: [FYI][PATCH] tracing/treewide: Remove second parameter of
 __assign_str()
Message-ID: <20240314143406.6289a060@gandalf.local.home>
In-Reply-To: <ZfMslbCmCtyEaEWN@aschofie-mobl2>
References: <20240223125634.2888c973@gandalf.local.home>
	<ZfMslbCmCtyEaEWN@aschofie-mobl2>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 14 Mar 2024 09:57:57 -0700
Alison Schofield <alison.schofield@intel.com> wrote:

> On Fri, Feb 23, 2024 at 12:56:34PM -0500, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > [
> >    This is a treewide change. I will likely re-create this patch again in
> >    the second week of the merge window of v6.9 and submit it then. Hoping
> >    to keep the conflicts that it will cause to a minimum.
> > ]

Note, change of plans. I plan on sending this in the next merge window, as
this merge window I have this patch:

  https://lore.kernel.org/linux-trace-kernel/20240312113002.00031668@gandalf.local.home/

That will warn if the source string of __string() is different than the
source string of __assign_str(). I want to make sure they are identical
before just dropping one of them.


> 
> > diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
> > index bdf117a33744..07ba4e033347 100644
> > --- a/drivers/cxl/core/trace.h
> > +++ b/drivers/cxl/core/trace.h  
> 
> snip to poison
> 
> > @@ -668,8 +668,8 @@ TRACE_EVENT(cxl_poison,
> >  	    ),
> >  
> >  	TP_fast_assign(
> > -		__assign_str(memdev, dev_name(&cxlmd->dev));
> > -		__assign_str(host, dev_name(cxlmd->dev.parent));
> > +		__assign_str(memdev);
> > +		__assign_str(host);  
> 
> I think I get that the above changes work because the TP_STRUCT__entry for
> these did:
> 	__string(memdev, dev_name(&cxlmd->dev))
> 	__string(host, dev_name(cxlmd->dev.parent))

That's the point. They have to be identical or you will likely bug.

The __string(name, src) is used to find the string length of src which
allocates the necessary length on the ring buffer. The __assign_str(name, src)
will copy src into the ring buffer.

Similar to:

	len = strlen(src);
	buf = malloc(len);
	strcpy(buf, str);

Where __string() is strlen() and __assign_str() is strcpy(). It doesn't
make sense to use two different strings, and if you did, it would likely be
a bug.

But the magic behind __string() does much more than just get the length of
the string, and it could easily save the pointer to the string (along with
its length) and have it copy that in the __assign_str() call, making the
src parameter of __assign_str() useless.

> 
> >  		__entry->serial = cxlmd->cxlds->serial;
> >  		__entry->overflow_ts = cxl_poison_overflow(flags, overflow_ts);
> >  		__entry->dpa = cxl_poison_record_dpa(record);
> > @@ -678,12 +678,12 @@ TRACE_EVENT(cxl_poison,
> >  		__entry->trace_type = trace_type;
> >  		__entry->flags = flags;
> >  		if (region) {
> > -			__assign_str(region, dev_name(&region->dev));
> > +			__assign_str(region);
> >  			memcpy(__entry->uuid, &region->params.uuid, 16);
> >  			__entry->hpa = cxl_trace_hpa(region, cxlmd,
> >  						     __entry->dpa);
> >  		} else {
> > -			__assign_str(region, "");
> > +			__assign_str(region);
> >  			memset(__entry->uuid, 0, 16);
> >  			__entry->hpa = ULLONG_MAX;  
> 
> For the above 2, there was no helper in TP_STRUCT__entry. A recently
> posted patch is fixing that up to be __string(region, NULL) See [1],
> with the actual assignment still happening in TP_fast_assign.

__string(region, NULL) doesn't make sense. It's like:

	len = strlen(NULL);
	buf = malloc(len);
	strcpy(buf, NULL);

??

I'll reply to that email.

-- Steve

> 
> Does that assign logic need to move to the TP_STRUCT__entry definition
> when you merge these changes? I'm not clear how much logic is able to be
> included, ie like 'C' style code in the TP_STRUCT__entry.
> 
> [1]
> https://lore.kernel.org/linux-cxl/20240314044301.2108650-1-alison.schofield@intel.com/

