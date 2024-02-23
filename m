Return-Path: <io-uring+bounces-683-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CB68861C09
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 19:45:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B97B5B24B81
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 18:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F02D21448E5;
	Fri, 23 Feb 2024 18:45:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C4F143C7F;
	Fri, 23 Feb 2024 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708713908; cv=none; b=ORTvMd3ACEcf13KXOpCUTkzInyjX3JMog5Y6o3gk0NtvoCD8VAXTimEYAR3rYCrSsibTxh++P2TjKTWhF2lrZQ3JOVfs6VDDjeia5Up6yd5IgKwvG0zUWb4HNLx3TCTYTeZMIzmk+4eJsEryVq5UNfI1mHdo8M9Kb8vCWz9G5/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708713908; c=relaxed/simple;
	bh=HNxDQrAqfHomkkBAL+GsWJU+Nkbn4bLBCPF0LWecwlI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mH8XCKDle3MAUNNmPjBhTAoJf8lgWMqqOLY/1IwskOvfca79pAs0qZuk2PuwroASSBLtVEASVc4GEm+gPccW/cTRU4/KsGBsxuHoONvRWQiKYbckgjgSWIfTFSZdmDXKmLMVL7vnDSd8oo4QUUv8u/SljNoZDDP/KBLdJowgpIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3ACC433C7;
	Fri, 23 Feb 2024 18:45:01 +0000 (UTC)
Date: Fri, 23 Feb 2024 13:46:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
 <linux-block@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
 <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
 <amd-gfx@lists.freedesktop.org>, <intel-gfx@lists.freedesktop.org>,
 <intel-xe@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
 <freedreno@lists.freedesktop.org>, <virtualization@lists.linux.dev>,
 <linux-rdma@vger.kernel.org>, <linux-pm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-tegra@vger.kernel.org>,
 <netdev@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
 <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
 <ath11k@lists.infradead.org>, <ath12k@lists.infradead.org>,
 <brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>,
 <linux-usb@vger.kernel.org>, <linux-bcachefs@vger.kernel.org>,
 <linux-nfs@vger.kernel.org>, <ocfs2-devel@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
 <linux-edac@vger.kernel.org>, <selinux@vger.kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-hwmon@vger.kernel.org>,
 <io-uring@vger.kernel.org>, <linux-sound@vger.kernel.org>,
 <bpf@vger.kernel.org>, <linux-wpan@vger.kernel.org>, <dev@openvswitch.org>,
 <linux-s390@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
 Julia Lawall <Julia.Lawall@inria.fr>
Subject: Re: [FYI][PATCH] tracing/treewide: Remove second parameter of
 __assign_str()
Message-ID: <20240223134653.524a5c9e@gandalf.local.home>
In-Reply-To: <0aed6cf2-17ae-45aa-b7ff-03da932ea4e0@quicinc.com>
References: <20240223125634.2888c973@gandalf.local.home>
	<0aed6cf2-17ae-45aa-b7ff-03da932ea4e0@quicinc.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 23 Feb 2024 10:30:45 -0800
Jeff Johnson <quic_jjohnson@quicinc.com> wrote:

> On 2/23/2024 9:56 AM, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > [
> >    This is a treewide change. I will likely re-create this patch again in
> >    the second week of the merge window of v6.9 and submit it then. Hoping
> >    to keep the conflicts that it will cause to a minimum.
> > ]
> > 
> > With the rework of how the __string() handles dynamic strings where it
> > saves off the source string in field in the helper structure[1], the
> > assignment of that value to the trace event field is stored in the helper
> > value and does not need to be passed in again.  
> 
> Just curious if this could be done piecemeal by first changing the
> macros to be variadic macros which allows you to ignore the extra
> argument. The callers could then be modified in their separate trees.
> And then once all the callers have be merged, the macros could be
> changed to no longer be variadic.

I weighed doing that, but I think ripping off the band-aid is a better
approach. One thing I found is that leaving unused parameters in the macros
can cause bugs itself. I found one case doing my clean up, where an unused
parameter in one of the macros was bogus, and when I made it a used
parameter, it broke the build.

I think for tree-wide changes, the preferred approach is to do one big
patch at once. And since this only affects TRACE_EVENT() macros, it
hopefully would not be too much of a burden (although out of tree users may
suffer from this, but do we care?)

Now one thing I could do is to not remove the parameter, but just add:

	WARN_ON_ONCE((src) != __data_offsets->item##_ptr_);

in the __assign_str() macro to make sure that it's still the same that is
assigned. But I'm not sure how useful that is, and still causes burden to
have it. I never really liked the passing of the string in two places to
begin with.

-- Steve

