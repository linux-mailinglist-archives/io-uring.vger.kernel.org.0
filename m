Return-Path: <io-uring+bounces-10438-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBCA4C3E53A
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 04:18:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E9D03AD816
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 03:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82043263F5E;
	Fri,  7 Nov 2025 03:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SzdFtJle"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC72F12CDA5;
	Fri,  7 Nov 2025 03:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762485517; cv=none; b=AD5/FoDGciUt3qEXToQH7RGYbIIhzBwVWqlylPoTPU91TgRbfz/Tw4mDYqG/UFTLP0ExXWTwZI5EPU6a6iRbWVXIzOdXuqTU7NMdpV9gpP+WQjXTpYe7zueLwfWUL3Oywu2O+i1QTC3pbjJUN06dqPWyxojT4uaVHeO7OCmLMiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762485517; c=relaxed/simple;
	bh=co3D5bCb1NX6D4M8Dv/GU45fZxnLdO//HvOQOwmnBcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H5FK7uVvshV+s/7cpQPR+A6kMrrHNOeqguhwI3x54P66bGUWPukDaQcYjmcP1R8JKBRFtI8lqz4AAiuY6NjBERjFigGNT36O81SQyiet6E47CqZuMe8N7QqGqy2GgKyBackkvw+GVmtZ0eC79yMfqgj2r89HwXNTlYsJ2YppG4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SzdFtJle; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762485516; x=1794021516;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=co3D5bCb1NX6D4M8Dv/GU45fZxnLdO//HvOQOwmnBcA=;
  b=SzdFtJleNbxcZ3UbX9p1Rx6m2kPpQs2M2IiCfOhEOwFuTq8g8EFj0jx0
   1Jpsbio3ON/I6L8l+6efpmqQl+oNAtP5l5JMvkLZ/BtXPicYvzDNu14Lz
   ipHM7waycQEJFpN20v+Bgr0w+QsrrvsMBa9Ev5xt8l43QRLvJ9JdnWO6h
   Ld7cuFG34/eKfzFu0CJzwIucVL0is8hvatdUnc/NMj7yu8R7Mn9jXpBJ4
   QJYDKxOpByoO5FHvUCt99hwX0QzJ/GjR5OH+89/EgLdgvOI6LtJs31+Ip
   Ocr6Kpa19mZT6iCkdS5uXvskfiQpFn0S1tGMMBNbi0bpBJGEmDQpEZoM5
   Q==;
X-CSE-ConnectionGUID: qzMsmp9/SX+jqc9BRnB1Sg==
X-CSE-MsgGUID: FCslDIO9S9ad62d40mo/XQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="64334020"
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="64334020"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 19:18:35 -0800
X-CSE-ConnectionGUID: v6iMZdAXQC2eCAAjusf8hQ==
X-CSE-MsgGUID: ZAMaWgOaQ9ix8OmGhqlTWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="187184741"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 06 Nov 2025 19:18:31 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vHCzc-000Udk-30;
	Fri, 07 Nov 2025 03:18:28 +0000
Date: Fri, 7 Nov 2025 11:17:52 +0800
From: kernel test robot <lkp@intel.com>
To: Fengnan Chang <changfengnan@bytedance.com>, axboe@kernel.dk,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	asml.silence@gmail.com, willy@infradead.org, djwong@kernel.org,
	hch@infradead.org, ritesh.list@gmail.com,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, ming.lei@redhat.com,
	linux-nvme@lists.infradead.org
Cc: oe-kbuild-all@lists.linux.dev,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: Re: [PATCH v2 1/2] block: use bio_alloc_bioset for passthru IO by
 default
Message-ID: <202511071021.3YIvZw6u-lkp@intel.com>
References: <20251107020557.10097-2-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107020557.10097-2-changfengnan@bytedance.com>

Hi Fengnan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 4a0c9b3391999818e2c5b93719699b255be1f682]

url:    https://github.com/intel-lab-lkp/linux/commits/Fengnan-Chang/block-use-bio_alloc_bioset-for-passthru-IO-by-default/20251107-100851
base:   4a0c9b3391999818e2c5b93719699b255be1f682
patch link:    https://lore.kernel.org/r/20251107020557.10097-2-changfengnan%40bytedance.com
patch subject: [PATCH v2 1/2] block: use bio_alloc_bioset for passthru IO by default
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20251107/202511071021.3YIvZw6u-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251107/202511071021.3YIvZw6u-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511071021.3YIvZw6u-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: block/blk-map.c:365 function parameter 'rq' not described in 'bio_copy_kern'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

