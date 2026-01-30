Return-Path: <io-uring+bounces-11992-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2PfvNcRJfGktLwIAu9opvQ
	(envelope-from <io-uring+bounces-11992-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 07:03:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 50052B78DF
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 07:03:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D4A833003BCE
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 06:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C9728980F;
	Fri, 30 Jan 2026 06:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nOn+wIhf"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E122561AB
	for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 06:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769753023; cv=none; b=M6/isCL0kLQbyKBd3qVw5D4NHGmwfiLlHI7JHh9pVErsv4xcmB746axqYocwFSD2RrrbLimwc99xjFCgk3eKZiYnLpNZCvvM2cZJuSzT74EI4CGXg7Y2T40BoefeFqOzR1yJcNCQH2avLigFaZaKW1sf8etJbdo8awD+mzNi8BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769753023; c=relaxed/simple;
	bh=d4zik4vcj/lFgKgGzJVjhTVh1ELgPPd4ldOEv4d4QqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=upOQNiJTgmH6sc9zkNwzERYwenyNLZttJY88ZP8egYJShpZHPApgH9pyTWYaBXFzmaRGBcipLrcdIO8oYcTWV7k1uE6bEakdwouCu3gjeMbwFEc8MwajDjkiSzmZ+B08Jt5mstMZTAry0rdr3SVsVfPWjvB4wAQjSgcaP4tCuWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nOn+wIhf; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769753021; x=1801289021;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d4zik4vcj/lFgKgGzJVjhTVh1ELgPPd4ldOEv4d4QqA=;
  b=nOn+wIhfbQ8zcKyD9rEbl0l3VUYSl+l+4vAWP3rO7Irp/Dx+2LYt2xV8
   enNaTPjZ3SdoWmiXEatsQQZO3FdmcK2XhOlnxRDb1+7rNgbeb4m6rAwpn
   +L7/Oxj5r5P9FSym6487hsju+fztEca7DikDRenKrk9xfFdj95Tp0PMvN
   uNmp1wnFqe8TWeurXHO8HWDZG9mV5t7TvHXiQcROCv2xXuV8D2Cu9ftvG
   0fvL0NLC/yxhUSTYWcHWXUAIaM3ZENwoZzvRRArIqvNmJQ2bOcQeQ7YW3
   ztywXIF28nqDxhm0TcABIak9Oox5vbPRJIKEdag05Z5lJlQhToPC25IGB
   g==;
X-CSE-ConnectionGUID: l0SM4R8sRqSh/N81yr7fPg==
X-CSE-MsgGUID: ji6WB3osTFGKKp8ycUpd4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="82370910"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="82370910"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 22:03:36 -0800
X-CSE-ConnectionGUID: ttM0Q5NSTXeQgqv1POVyHA==
X-CSE-MsgGUID: fxTlaGG2QMeqO2AFywjFiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="208689582"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 29 Jan 2026 22:03:32 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vlhbO-00000000cFI-12EF;
	Fri, 30 Jan 2026 06:03:30 +0000
Date: Fri, 30 Jan 2026 14:03:20 +0800
From: kernel test robot <lkp@intel.com>
To: Gabriel Krisman Bertazi <krisman@suse.de>, axboe@kernel.dk
Cc: oe-kbuild-all@lists.linux.dev, io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 2/2] io_uring: introduce IORING_OP_MMAP
Message-ID: <202601301341.PTetVieu-lkp@intel.com>
References: <20260129221138.897715-3-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129221138.897715-3-krisman@suse.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11992-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,git-scm.com:url,01.org:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 50052B78DF
X-Rspamd-Action: no action

Hi Gabriel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v6.19-rc7]
[also build test WARNING on linus/master]
[cannot apply to axboe/for-next next-20260129]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Gabriel-Krisman-Bertazi/io_uring-Support-commands-with-optional-file-descriptors/20260130-061445
base:   v6.19-rc7
patch link:    https://lore.kernel.org/r/20260129221138.897715-3-krisman%40suse.de
patch subject: [PATCH 2/2] io_uring: introduce IORING_OP_MMAP
config: m68k-randconfig-r122-20260130 (https://download.01.org/0day-ci/archive/20260130/202601301341.PTetVieu-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260130/202601301341.PTetVieu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601301341.PTetVieu-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> io_uring/mmap.c:116:36: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __user *addr @@     got void * @@
   io_uring/mmap.c:116:36: sparse:     expected void [noderef] __user *addr
   io_uring/mmap.c:116:36: sparse:     got void *
   io_uring/mmap.c:125:44: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __user *addr @@     got void * @@
   io_uring/mmap.c:125:44: sparse:     expected void [noderef] __user *addr
   io_uring/mmap.c:125:44: sparse:     got void *
   io_uring/mmap.c:130:28: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __user *addr @@     got void * @@
   io_uring/mmap.c:130:28: sparse:     expected void [noderef] __user *addr
   io_uring/mmap.c:130:28: sparse:     got void *

vim +116 io_uring/mmap.c

    83	
    84	int io_mmap(struct io_kiocb *req, unsigned int issue_flags)
    85	{
    86		struct io_mmap_data *mmap = io_kiocb_to_cmd(req, struct io_mmap_data);
    87		struct io_mmap_async *data = (struct io_mmap_async *) req->async_data;
    88		int i, mapped, ret;
    89	
    90		if (unlikely(mmap->flags & MAP_HUGETLB && req->file &&
    91			     !is_file_hugepages(req->file))) {
    92			ret = -EINVAL;
    93			goto out;
    94		}
    95	
    96		for (i = 0; i < data->nr_maps; i++) {
    97			struct io_uring_mmap_desc *desc = &data->maps[i];
    98	
    99			if (copy_from_user(desc, &mmap->uaddr[i], sizeof(*desc))) {
   100				ret = -EFAULT;
   101				goto out;
   102			}
   103		}
   104	
   105		mapped = 0;
   106		while (mapped < data->nr_maps) {
   107			struct io_uring_mmap_desc *desc = &data->maps[mapped++];
   108			unsigned long flags = (mmap->flags | desc->flags);
   109			unsigned long len = desc->len;
   110			struct file *file = req->file;
   111	
   112			/* These cannot be mixed and matched.  need to be passed
   113			 * on the SQE.
   114			 */
   115			if (unlikely(desc->flags & (MAP_ANONYMOUS|MAP_HUGETLB))) {
 > 116				desc->addr = ERR_PTR(-EINVAL);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

