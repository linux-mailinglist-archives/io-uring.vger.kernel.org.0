Return-Path: <io-uring+bounces-5783-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCEF1A079DB
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 15:58:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E1E9188B8DA
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 14:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 459C521A459;
	Thu,  9 Jan 2025 14:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O0S/GfAC"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED1221B8E7;
	Thu,  9 Jan 2025 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736434698; cv=none; b=a6bmjRG8ZJpRXWjEvksAyNb3P3gfiX6Pm22lZlnpG/QY0l0vwcpBt2hCE2Mx9i/oAcOHFahbnmqSqoRpyQ0yeL4vNdjuRU7t+vjeljUaNQwVE5SvC82Aq84O0B4B9nyHcJyToNtgekWh65RVSk6VmgBMKrHrC37+EGDAmROEagk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736434698; c=relaxed/simple;
	bh=vefbR+WxUsl6W1mxf4BqpYTUFUuz57yEjCw3Nj1MESk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jOcBy774W4WFzP9OjxIkPzrczwSLEJGl4CQqQ5yDUmf41+OVMvyzocJ0eKi80/R7nTSxRfWdsyiwtcMLjW2KkIXwu8gXbOLeTuIFFVE1EU9zrkW/qJ7JP3AhewtVXBbkAtbXCuZl5FWZvfKozaIM17nEziJ4GXqoTuT9bw3IyuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O0S/GfAC; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736434696; x=1767970696;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=vefbR+WxUsl6W1mxf4BqpYTUFUuz57yEjCw3Nj1MESk=;
  b=O0S/GfACkzTzfNWxJdZV/RDMLKAc9QTiO1ADlXLVE3R8aVQztjZpLXES
   5l3F2mn0eVSjdHAWpZObipNk1T6L8A/hfcH38AAdDhayHMryokusuQSrN
   zLJZshzx+NKdjNs4grPe8khjD1x0DoX0bV6V8MaMQly1r0v4djgeK7xbI
   KuOR9H3mQX+wdyiFSZfIYun85ZUY9Cxh8jLe9TN/EZ9fkqKUOz7ZhtbjO
   Sxmg45pHRaC2XRbiaZOGU+vmKMAC5FP8aZC65dcRKocGXWf0K7+f1EgBn
   S2t2N7ZvbUPwfnU6eyRrZOVIoBtSsXcrHps1xntpuUx6l/6YJbCElzyhM
   g==;
X-CSE-ConnectionGUID: gAf6/7nOR6Wyah7oBzjV+g==
X-CSE-MsgGUID: +v+ygk6vQG2uZwIh2QiiBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="48110945"
X-IronPort-AV: E=Sophos;i="6.12,301,1728975600"; 
   d="scan'208";a="48110945"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 06:58:14 -0800
X-CSE-ConnectionGUID: aAxGFyBISeOF2fi1TGSFDw==
X-CSE-MsgGUID: hUbAKolZSWC8NTenKubm+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="108527826"
Received: from unknown (HELO localhost) ([10.237.66.160])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 06:58:04 -0800
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Joel Granados <joel.granados@kernel.org>, Thomas =?utf-8?Q?Wei=C3=9Fsc?=
 =?utf-8?Q?huh?=
 <linux@weissschuh.net>, Kees Cook <kees@kernel.org>, Luis Chamberlain
 <mcgrof@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
 openipmi-developer@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-serial@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev,
 codalist@coda.cs.cmu.edu, linux-mm@kvack.org, linux-nfs@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, fsverity@lists.linux.dev,
 linux-xfs@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org,
 kexec@lists.infradead.org, linux-trace-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org, apparmor@lists.ubuntu.com,
 linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, Joel
 Granados <joel.granados@kernel.org>
Subject: Re: [PATCH] treewide: const qualify ctl_tables where applicable
In-Reply-To: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>
Date: Thu, 09 Jan 2025 16:58:01 +0200
Message-ID: <87frlsjapy.fsf@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, 09 Jan 2025, Joel Granados <joel.granados@kernel.org> wrote:
> diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
> index 2406cda75b7b..5384d1bb4923 100644
> --- a/drivers/gpu/drm/i915/i915_perf.c
> +++ b/drivers/gpu/drm/i915/i915_perf.c
> @@ -4802,7 +4802,7 @@ int i915_perf_remove_config_ioctl(struct drm_device *dev, void *data,
>  	return ret;
>  }
>  
> -static struct ctl_table oa_table[] = {
> +static const struct ctl_table oa_table[] = {
>  	{
>  	 .procname = "perf_stream_paranoid",
>  	 .data = &i915_perf_stream_paranoid,

For i915,

Acked-by: Jani Nikula <jani.nikula@intel.com>


-- 
Jani Nikula, Intel

