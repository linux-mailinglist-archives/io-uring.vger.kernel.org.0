Return-Path: <io-uring+bounces-1518-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B18FA8A26D0
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 08:41:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 489C7B21EE4
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 06:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ABD847773;
	Fri, 12 Apr 2024 06:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iSIG88PM"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B2C481AA;
	Fri, 12 Apr 2024 06:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712904086; cv=none; b=FcEPPII0PjuyIcdaDdrNQgRGh0jHTZJ64CCC+El55BAD71bsFllRqYtMsxuiTRwmIH+6zZnvlB5y5AUl5wH3s1mCNb9YHQCKfE/+3nmyyCL49/KnMMSsVyiBZc7CZmYQuwVd73jZ75sEp6m8ftE0iY0OVcTg9b17N1jRVNm4YZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712904086; c=relaxed/simple;
	bh=nnftp3y20mnefQs/zA7rIGucHoCz77k4ThTY/2DnxXQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WqZ4u2bp1etrmGwN4LvsEPc5P8AJHqF7YOdeX3PUsI0f7yW5353sMQfumFije+dnpo+1RbsV2oEBzu3BzyCh7zMWMGVGqHnsEXXP8w5YLHiRn6isxA0DilztxWv482/N9jaaplh0LdXlp6iYChmbPWluqpwmjkDKYt0JX8kP8AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iSIG88PM; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712904084; x=1744440084;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=nnftp3y20mnefQs/zA7rIGucHoCz77k4ThTY/2DnxXQ=;
  b=iSIG88PM9b2YgdRQ4szSPTsiEdHfMD5rvawOOi/wLLg8jMk/6RvNaAhh
   oT8MCDqfxNcRKZIaxcmdnyc5dZFarta68w/0F5iqI/qjN12Q0xqiv/d3W
   MzpkPrK3w3Kcc1AHe6HVTykvzAnyMk67pILZRjDVT2hnvtRmoe/Cw2Fd+
   /uyq9R6DLLbY1+VPi8oWLD8fXYhTK1fOKpK5axS7YL1HSBv2I+Lw0Wccf
   fe1j1FKLmWJwforIh40KJUeHO8Jk2MX9Ubj2Z2DTWjc8yz7+KWokasxYk
   5t7Q9ylV9NvBLIftWfB78uD0Vkjhd9A4DcbrwRJ02bVl04XgItkgpfDlz
   A==;
X-CSE-ConnectionGUID: Y0HDLEZfStSZpp9NVKZxxw==
X-CSE-MsgGUID: /QL/ha6+TkaFPIYYcUqo0A==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="19059686"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="19059686"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 23:41:22 -0700
X-CSE-ConnectionGUID: gXMdnuYmRRqCKEW6OOQMYA==
X-CSE-MsgGUID: D1rZkMzDT4yyHA2nqy/ldg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="21056020"
Received: from gjantea-mobl.ger.corp.intel.com (HELO localhost) ([10.252.60.121])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 23:41:15 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Thorsten Blum <thorsten.blum@toblux.com>, Dan Carpenter
 <dan.carpenter@linaro.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 speakup@linux-speakup.org, intel-gfx@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-afs@lists.infradead.org, ecryptfs@vger.kernel.org,
 netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-arch@vger.kernel.org,
 io-uring@vger.kernel.org, cocci@inria.fr, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] treewide: Fix common grammar mistake "the the"
In-Reply-To: <193B959E-60A3-499A-BFF3-EA7B2D0B6C12@toblux.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20240411150437.496153-4-thorsten.blum@toblux.com>
 <0bd7ccc2-4d8c-455b-a6c2-972ebe1fcb08@moroto.mountain>
 <193B959E-60A3-499A-BFF3-EA7B2D0B6C12@toblux.com>
Date: Fri, 12 Apr 2024 09:41:10 +0300
Message-ID: <87y19j3wxl.fsf@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, 12 Apr 2024, Thorsten Blum <thorsten.blum@toblux.com> wrote:
> On 11. Apr 2024, at 17:25, Dan Carpenter <dan.carpenter@linaro.org> wrote:
>> 
>> It's tricky to know which tree a patch like this would go through.
>
> The patch is based on the mainline tree. Should I have sent it directly to
> Linus then?
>
> I'm relatively new here and therefore only sent it to the corresponding mailing
> lists.

It's not just about mailing lists, it's also about changes flowing in to
mainline via a plethora of subsystem and driver repos and branches. See
MAINTAINERS. Or this old LWN page [1]. The development happens in those
branches, and if you make treewide changes like this, it's not clear who
should take it, and you also risk unnecessary conflicts if those places
get modified in the individual branches. So it might just be easiest to
split this up to smaller patches sent to the appropriate lists.

Anyway, all that said,

Acked-by: Jani Nikula <jani.nikula@intel.com>

on the i915 changes here.


BR,
Jani.


[1] https://lwn.net/Articles/737094/

-- 
Jani Nikula, Intel

