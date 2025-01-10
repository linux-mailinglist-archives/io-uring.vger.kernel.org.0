Return-Path: <io-uring+bounces-5808-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 028BFA09834
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 18:14:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C265188DF02
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 17:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 192132135D3;
	Fri, 10 Jan 2025 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hWvPm9S9"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998202135CD;
	Fri, 10 Jan 2025 17:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736529242; cv=none; b=YHA6WPjai2AXfv8OxCgDNDW8FylN1NKdGUqRSC6O90OLumH01NHdj+tExkim4UrVuEpaBrxeWW0ai5/asBXa+KLeTLSlafDwEeWsl0l1YfvFTA4OtmWaTR8GkMDHj6MlmRNRch3FGSU6NMqpvnx9EzlQs2pxJYVBC7vEqR5Jwe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736529242; c=relaxed/simple;
	bh=zCD9wMt7oj+kJBhlIcsVVTGT43QE2wPIyfO0mHZuo3E=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AAjN4aD1+LG9tm4CDTT98hANfLwZOwpT1esfVG5PUP6rD7p7JWcTczqfDiExaoNz3ll+vgd7jPhqO5SOXaqsiL0jBTIJg7zQs17Fy/X+gzZ7qpj2jCYmpz0HK+OUtxEG5+vAlk3BL/j4o23sXW2dz9yvHfZw2tUEfPpwytLLdGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hWvPm9S9; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736529240; x=1768065240;
  h=date:message-id:from:to:cc:subject:in-reply-to:
   references:mime-version;
  bh=zCD9wMt7oj+kJBhlIcsVVTGT43QE2wPIyfO0mHZuo3E=;
  b=hWvPm9S9gyyWflhxezAJQ0/Zw5EZKsCuAkNL9pt9ibrxvKhfx8igBLau
   BqAxt/w+4WkhB7JJeGhd2XKu7BTEUI/u+ZCjJZLax3klENzioM0Ogu8lV
   PfZO/Ur9FgiISKQAktuwXDv+fKDWBBLhsHE3nTEvd7HEfk5ILPMEy+C+i
   v7E/Bn3dcZExGuv+WXwcKSpdB8KGwD5qn3eKJp4zYHR+m82wlFlpFSVej
   Zj+F+2HJbkF1YqnKygWuQDJ/VUu15h2UnCLWYzcjwzwNjZ/0bri7MxpqP
   ws6x4YtpsaSIYSiiMKXJNlfXHbNtrSTP7okJPY7QFGY+mFzAY/yI1B5Pm
   Q==;
X-CSE-ConnectionGUID: eETlnapHTZaJYZoWsWncOQ==
X-CSE-MsgGUID: kcx024AdTVSnnR8CHTt/pw==
X-IronPort-AV: E=McAfee;i="6700,10204,11311"; a="36712482"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="36712482"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 09:13:58 -0800
X-CSE-ConnectionGUID: d+N1H3FPQryemumCSoERgQ==
X-CSE-MsgGUID: skCK+1HISZSgobnkHZdoJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="127073384"
Received: from orsosgc001.jf.intel.com (HELO orsosgc001.intel.com) ([10.165.21.142])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 09:13:57 -0800
Date: Fri, 10 Jan 2025 09:13:56 -0800
Message-ID: <8534hqvbfv.wl-ashutosh.dixit@intel.com>
From: "Dixit, Ashutosh" <ashutosh.dixit@intel.com>
To: Joel Granados <joel.granados@kernel.org>
Cc: Thomas =?ISO-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,	Kees Cook
 <kees@kernel.org>,	Luis Chamberlain <mcgrof@kernel.org>,
	linux-arm-kernel@lists.infradead.org,	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,	linux-crypto@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,	intel-xe@lists.freedesktop.org,
	linux-hyperv@vger.kernel.org,	linux-rdma@vger.kernel.org,
	linux-raid@vger.kernel.org,	linux-scsi@vger.kernel.org,
	linux-serial@vger.kernel.org,	xen-devel@lists.xenproject.org,
	linux-aio@kvack.org,	linux-fsdevel@vger.kernel.org,	netfs@lists.linux.dev,
	codalist@coda.cs.cmu.edu,	linux-mm@kvack.org,	linux-nfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,	io-uring@vger.kernel.org,	bpf@vger.kernel.org,
	kexec@lists.infradead.org,	linux-trace-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,	keyrings@vger.kernel.org
Subject: Re: [PATCH] treewide: const qualify ctl_tables where applicable
In-Reply-To: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>
References: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?ISO-8859-4?Q?Goj=F2?=) APEL-LB/10.8 EasyPG/1.0.0
 Emacs/28.2 (x86_64-redhat-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII

On Thu, 09 Jan 2025 05:16:39 -0800, Joel Granados wrote:
>
> diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
> index 2406cda75b7b..5384d1bb4923 100644
> --- a/drivers/gpu/drm/i915/i915_perf.c
> +++ b/drivers/gpu/drm/i915/i915_perf.c
> @@ -4802,7 +4802,7 @@ int i915_perf_remove_config_ioctl(struct drm_device *dev, void *data,
>	return ret;
>  }
>
> -static struct ctl_table oa_table[] = {
> +static const struct ctl_table oa_table[] = {
>	{
>	 .procname = "perf_stream_paranoid",
>	 .data = &i915_perf_stream_paranoid,
> diff --git a/drivers/gpu/drm/xe/xe_observation.c b/drivers/gpu/drm/xe/xe_observation.c
> index 8ec1b84cbb9e..57cf01efc07f 100644
> --- a/drivers/gpu/drm/xe/xe_observation.c
> +++ b/drivers/gpu/drm/xe/xe_observation.c
> @@ -56,7 +56,7 @@ int xe_observation_ioctl(struct drm_device *dev, void *data, struct drm_file *fi
>	}
>  }
>
> -static struct ctl_table observation_ctl_table[] = {
> +static const struct ctl_table observation_ctl_table[] = {
>	{
>	 .procname = "observation_paranoid",
>	 .data = &xe_observation_paranoid,

For i915 and xe:

Acked-by: Ashutosh Dixit <ashutosh.dixit@intel.com>

