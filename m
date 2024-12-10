Return-Path: <io-uring+bounces-5424-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C503B9EBF20
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 00:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2365188946A
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 23:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 963AB211274;
	Tue, 10 Dec 2024 23:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hSqS1OUX"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832E11F1917;
	Tue, 10 Dec 2024 23:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733872469; cv=none; b=QJgEH1sXS25PvkOQ/zzZ0qH7qN5ulEe5UHSIEVDKwAPQKrvEao4LtjrTHT8SrM5LVnteUDYC/O0Wzro5LtaPr2vpguV7qChH5UjACspArPCx5fxM2734Mu5lLM+0er9TfEIe99tJNd20Qvh5eofzSwh8sY/uzdS5IncQuB0eIrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733872469; c=relaxed/simple;
	bh=QhancFfHEpXah3jU6ipqRKrhjIQ2v4c43WG3bvdT+jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ObE/VzmYlQuCgm2w2i+GGHyDkr1YWNkO6bYmKOaDJGBKi8oy1Vd1j3UvrxP67xmPadC4QTiMgAaZxfnpxgRuvbKmgOtjPGeJ22ryFb5aADhCH3D9v27nNSHXDJDXNe09lNzcEBiUs0VD+XpUtoRs6Pupw9fubOJh6lizrqMldyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hSqS1OUX; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733872468; x=1765408468;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QhancFfHEpXah3jU6ipqRKrhjIQ2v4c43WG3bvdT+jc=;
  b=hSqS1OUXbrgFDhfn0bp5Puyy8DdWJVkyB3vC/CtSNmEMQpq5WiWwUjcu
   MO2vY2UNO4BDXxhaYMIL2TV+tGAJyNf7/ZnS4ez5cqtlYzy2lLCHqtnpn
   WVYuZ3YUYMCz06tX1sn2jlDdmAcVYz4z/IApK/lazWunkQmn8k90dmE6a
   TzWgd/3Btt5PCTlTZj9Mh8rgnjPc0isY4i4zN2SIPJCa4VTo4MQR44s6t
   2bK8YpsKOl/3BkSM64QgR7V5ZqvyBk3rYVASwd3RFTwTGTBaVPKKRBVRz
   ol8t2AG+ywdvsqhnPvS2mvx6nJXwjX3VKgDJZwIfxSUN6eDTjy7U+ldfZ
   g==;
X-CSE-ConnectionGUID: qw4xMLWXQUeR7eYHKiK7FA==
X-CSE-MsgGUID: o56XTxUdTkiGCNnLyynzRg==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="37072627"
X-IronPort-AV: E=Sophos;i="6.12,223,1728975600"; 
   d="scan'208";a="37072627"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 15:14:27 -0800
X-CSE-ConnectionGUID: Uoxh1te9RZm7pk3qzNS0lQ==
X-CSE-MsgGUID: YuExtJVvSTyTHC5eUVxziA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,223,1728975600"; 
   d="scan'208";a="95381244"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 10 Dec 2024 15:14:23 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tL9Qr-00062j-0e;
	Tue, 10 Dec 2024 23:14:21 +0000
Date: Wed, 11 Dec 2024 07:14:02 +0800
From: kernel test robot <lkp@intel.com>
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: oe-kbuild-all@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
	bernd@bsbernd.com, Bernd Schubert <bschubert@ddn.com>
Subject: Re: [PATCH v8 13/16] fuse: Allow to queue fg requests through
 io-uring
Message-ID: <202412110703.cax0xtFn-lkp@intel.com>
References: <20241209-fuse-uring-for-6-10-rfc4-v8-13-d9f9f2642be3@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-13-d9f9f2642be3@ddn.com>

Hi Bernd,

kernel test robot noticed the following build warnings:

[auto build test WARNING on e70140ba0d2b1a30467d4af6bcfe761327b9ec95]

url:    https://github.com/intel-lab-lkp/linux/commits/Bernd-Schubert/fuse-rename-to-fuse_dev_end_requests-and-make-non-static/20241210-003313
base:   e70140ba0d2b1a30467d4af6bcfe761327b9ec95
patch link:    https://lore.kernel.org/r/20241209-fuse-uring-for-6-10-rfc4-v8-13-d9f9f2642be3%40ddn.com
patch subject: [PATCH v8 13/16] fuse: Allow to queue fg requests through io-uring
config: m68k-randconfig-r112-20241211 (https://download.01.org/0day-ci/archive/20241211/202412110703.cax0xtFn-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 14.2.0
reproduce: (https://download.01.org/0day-ci/archive/20241211/202412110703.cax0xtFn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412110703.cax0xtFn-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/fuse/dev_uring.c:33:30: sparse: sparse: symbol 'fuse_io_uring_ops' was not declared. Should it be static?

vim +/fuse_io_uring_ops +33 fs/fuse/dev_uring.c

    32	
  > 33	const struct fuse_iqueue_ops fuse_io_uring_ops;
    34	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

