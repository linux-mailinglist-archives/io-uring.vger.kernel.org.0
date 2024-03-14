Return-Path: <io-uring+bounces-945-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4996087C19B
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 17:58:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4114B212A7
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 16:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF327441A;
	Thu, 14 Mar 2024 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Upxp6VnM"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6584D1EB34;
	Thu, 14 Mar 2024 16:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710435486; cv=none; b=Vcs77zsqIn9OruxtzeUdAOrJhUYLw+iYoFLIzWGw/W1n/H2zKqN5I1yG9u5alCNlf3pNPTfHuREtZOlBEzJS0fzW7a9v20Ko9xJfnrzJbAb1Is7iRYCAwb5GtlzMLZLZdG1Fn3cHee7QZ7COTyOrYZxE6RDu4X1820poWEiZfbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710435486; c=relaxed/simple;
	bh=fcf8GvnNI2NlxwWa/BLBUBs674hhRLyrkoAa66D2RKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nE9Dvb4jlx6h5vXrX4A9HOeg58e+rGh2c7tkkgerxTH4oqbOienOHOVPcy/KYUA6XDZf6V+m6gCBjqy5QTyf7NcGJc9/rDTvrPmiASibu9GsfnMNXtwivmFvh9LqXtIIbs5WA4+yEvd/cAiOkfmsi8qZbL7NfrNIwdhyRUBBxTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Upxp6VnM; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710435484; x=1741971484;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fcf8GvnNI2NlxwWa/BLBUBs674hhRLyrkoAa66D2RKo=;
  b=Upxp6VnMtVVIh5OrjLy1m4x53O33vUT82Px9mA1yIg4XVcMfwTQJFixh
   7LgJMYtNRqx/gFI4UZaFZANBwyUZ2125tyWFO/h/8aNJY3Ssz6Q5mTtSq
   z2Rj4kEpS4nJkn25okzKvdQv4rbbJF9HCHjqQ9B/Jb64bwio9XG/KBlJp
   J699SnKSz1nj/E2RkWAJaF9YVeUpsaCsOXlpHs5uHkESF9K3aOaQpXess
   FCsbM8DPR2tGCmMJCjBmNp+30GvOQOM0FuzvdY/0Dl1c7H5pm+EbBsxtB
   SWZno7PLV95EK9E7rTZWvtAMKbMAY13rhlzTtvMhwYJfdAqn3LBycbVbu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="22731667"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="22731667"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 09:58:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="16952403"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.72.214])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 09:57:59 -0700
Date: Thu, 14 Mar 2024 09:57:57 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-block@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org, linux-pm@vger.kernel.org,
	iommu@lists.linux.dev, linux-tegra@vger.kernel.org,
	netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org, ath12k@lists.infradead.org,
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
	linux-usb@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	linux-cifs@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-edac@vger.kernel.org, selinux@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-hwmon@vger.kernel.org,
	io-uring@vger.kernel.org, linux-sound@vger.kernel.org,
	bpf@vger.kernel.org, linux-wpan@vger.kernel.org,
	dev@openvswitch.org, linux-s390@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net,
	Julia Lawall <Julia.Lawall@inria.fr>
Subject: Re: [FYI][PATCH] tracing/treewide: Remove second parameter of
 __assign_str()
Message-ID: <ZfMslbCmCtyEaEWN@aschofie-mobl2>
References: <20240223125634.2888c973@gandalf.local.home>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223125634.2888c973@gandalf.local.home>

On Fri, Feb 23, 2024 at 12:56:34PM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> [
>    This is a treewide change. I will likely re-create this patch again in
>    the second week of the merge window of v6.9 and submit it then. Hoping
>    to keep the conflicts that it will cause to a minimum.
> ]
> 
> With the rework of how the __string() handles dynamic strings where it
> saves off the source string in field in the helper structure[1], the
> assignment of that value to the trace event field is stored in the helper
> value and does not need to be passed in again.
> 
> This means that with:
> 
>   __string(field, mystring)
> 
> Which use to be assigned with __assign_str(field, mystring), no longer
> needs the second parameter and it is unused. With this, __assign_str()
> will now only get a single parameter.
> 
> There's over 700 users of __assign_str() and because coccinelle does not
> handle the TRACE_EVENT() macro I ended up using the following sed script:
> 
>   git grep -l __assign_str | while read a ; do
>       sed -e 's/\(__assign_str([^,]*[^ ,]\) *,[^;]*/\1)/' $a > /tmp/test-file;
>       mv /tmp/test-file $a;
>   done
> 
> I then searched for __assign_str() that did not end with ';' as those
> were multi line assignments that the sed script above would fail to catch.
> 
> Note, the same updates will need to be done for:
> 
>   __assign_str_len()
>   __assign_rel_str()
>   __assign_rel_str_len()
>   __assign_bitmask()
>   __assign_rel_bitmask()
>   __assign_cpumask()
>   __assign_rel_cpumask()
> 
> [1] https://lore.kernel.org/linux-trace-kernel/20240222211442.634192653@goodmis.org/
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  arch/arm64/kernel/trace-events-emulation.h    |   2 +-
>  arch/powerpc/include/asm/trace.h              |   4 +-
>  arch/x86/kvm/trace.h                          |   2 +-
>  drivers/base/regmap/trace.h                   |  18 +--
>  drivers/base/trace.h                          |   2 +-
>  drivers/block/rnbd/rnbd-srv-trace.h           |  12 +-
>  drivers/cxl/core/trace.h                      |  24 ++--

snip to CXL


> diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
> index bdf117a33744..07ba4e033347 100644
> --- a/drivers/cxl/core/trace.h
> +++ b/drivers/cxl/core/trace.h

snip to poison

> @@ -668,8 +668,8 @@ TRACE_EVENT(cxl_poison,
>  	    ),
>  
>  	TP_fast_assign(
> -		__assign_str(memdev, dev_name(&cxlmd->dev));
> -		__assign_str(host, dev_name(cxlmd->dev.parent));
> +		__assign_str(memdev);
> +		__assign_str(host);

I think I get that the above changes work because the TP_STRUCT__entry for
these did:
	__string(memdev, dev_name(&cxlmd->dev))
	__string(host, dev_name(cxlmd->dev.parent))

>  		__entry->serial = cxlmd->cxlds->serial;
>  		__entry->overflow_ts = cxl_poison_overflow(flags, overflow_ts);
>  		__entry->dpa = cxl_poison_record_dpa(record);
> @@ -678,12 +678,12 @@ TRACE_EVENT(cxl_poison,
>  		__entry->trace_type = trace_type;
>  		__entry->flags = flags;
>  		if (region) {
> -			__assign_str(region, dev_name(&region->dev));
> +			__assign_str(region);
>  			memcpy(__entry->uuid, &region->params.uuid, 16);
>  			__entry->hpa = cxl_trace_hpa(region, cxlmd,
>  						     __entry->dpa);
>  		} else {
> -			__assign_str(region, "");
> +			__assign_str(region);
>  			memset(__entry->uuid, 0, 16);
>  			__entry->hpa = ULLONG_MAX;

For the above 2, there was no helper in TP_STRUCT__entry. A recently
posted patch is fixing that up to be __string(region, NULL) See [1],
with the actual assignment still happening in TP_fast_assign.

Does that assign logic need to move to the TP_STRUCT__entry definition
when you merge these changes? I'm not clear how much logic is able to be
included, ie like 'C' style code in the TP_STRUCT__entry.

[1]
https://lore.kernel.org/linux-cxl/20240314044301.2108650-1-alison.schofield@intel.com/

Thanks for helping,
Alison


>  		}




