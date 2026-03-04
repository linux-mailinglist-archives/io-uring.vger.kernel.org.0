Return-Path: <io-uring+bounces-12554-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAY1Drk4qGkTqgAAu9opvQ
	(envelope-from <io-uring+bounces-12554-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 14:50:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D09C7200B7A
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 14:50:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3A8A73013971
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2026 13:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01ECF3148BF;
	Wed,  4 Mar 2026 13:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S7+on1be"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729FB269D18;
	Wed,  4 Mar 2026 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772632235; cv=none; b=JsKhxPhlxuX94nyV6a26OBWdeFNTlecUvouykFuIhT50WyzVM4lTQTIwvHYWTOnXCW7hZWP0t2YQB4eu4KvVnErgiT8KPB9Yrc8iJidOloYBkyuey/ncRoLPA4Ch+6u9GXIcGvCzt2rDt51bU1jhnHbHEEsDQJHelu+wQQn1HRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772632235; c=relaxed/simple;
	bh=CvBFSLoX33HHaYixzYhjVgKTwhFEBX5XLgiyHC53qns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RX3ygvrffLeoYmg80dKISUfkciVlS1ucX7LFeVtvvsHgL7zcaPYenSjuZms4nfVCqophao35QkE6zWaln+bL+Onzr+JorDqAmAHO56IWdw6WVCgaNH4Eiy6zQBEK6kbrFHm+MufQ+SUCJXm3BBE1QkL3Ptoz7YnfIqfHxUsleaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S7+on1be; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772632233; x=1804168233;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CvBFSLoX33HHaYixzYhjVgKTwhFEBX5XLgiyHC53qns=;
  b=S7+on1beXofLBbeVIEHWQBSQSvTQIZjVH7zPoHMfFCXo10CK8cEBzdSc
   hG3MJKLlcP6MBqaMeRHroZNMZdAJhbcd+/7OcubForceGJx8PvnKp5PNr
   RgIr/5VxScDa2XQmVyBDO6pna8buKeH4+zC14ftoUDxAuJk+tTR16y0Yz
   s5ITuoBEGlMMTurngORRPQnb10DOp2Pm4xY+kzX1ZXUU77aJpMzIYDvr3
   rsu073raljIMFHmd7YxH6n32aLkNkVAHI5hu3Bg9hIyzPWzkI/hnTrEhK
   mbNkTWWPNAA38toO4BFfIJpGDqTWXQxdyEx3SK03tGGSkOK/5WWhCXE12
   A==;
X-CSE-ConnectionGUID: kmZ580dGRWimb1hdRaU8Jg==
X-CSE-MsgGUID: 8yJ+VgB8TvqooW/XlzD/pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="72716438"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="72716438"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 05:50:33 -0800
X-CSE-ConnectionGUID: qyz74MoRSr6dtWijARqkUA==
X-CSE-MsgGUID: yyvgiF75S7qCuY+bN4KKCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="217502197"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 04 Mar 2026 05:50:31 -0800
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vxmcN-000000001iR-2yOe;
	Wed, 04 Mar 2026 13:50:27 +0000
Date: Wed, 4 Mar 2026 14:50:07 +0100
From: kernel test robot <lkp@intel.com>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: Re: [PATCH v5 3/3] scsi: bsg: add io_uring passthrough handler
Message-ID: <202603041450.tuj48h9Q-lkp@intel.com>
References: <20260304080313.675768-4-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304080313.675768-4-yangxiuwei@kylinos.cn>
X-Rspamd-Queue-Id: D09C7200B7A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12554-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[01.org:url,intel.com:dkim,intel.com:email,intel.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

Hi Yang,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe/for-next]
[also build test ERROR on jejb-scsi/for-next mkp-scsi/for-next linus/master v7.0-rc2 next-20260303]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yang-Xiuwei/bsg-add-bsg_uring_cmd-uapi-structure/20260304-160717
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20260304080313.675768-4-yangxiuwei%40kylinos.cn
patch subject: [PATCH v5 3/3] scsi: bsg: add io_uring passthrough handler
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260304/202603041450.tuj48h9Q-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260304/202603041450.tuj48h9Q-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603041450.tuj48h9Q-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/scsi/scsi_bsg.c: In function 'scsi_bsg_map_user_buffer':
>> drivers/scsi/scsi_bsg.c:111:71: error: macro "io_uring_sqe_cmd" requires 2 arguments, but only 1 given
     111 |         const struct bsg_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
         |                                                                       ^
   In file included from drivers/scsi/scsi_bsg.c:3:
   include/linux/io_uring/cmd.h:29:9: note: macro "io_uring_sqe_cmd" defined here
      29 | #define io_uring_sqe_cmd(sqe, type)     ({                                      \
         |         ^~~~~~~~~~~~~~~~
>> drivers/scsi/scsi_bsg.c:111:43: error: 'io_uring_sqe_cmd' undeclared (first use in this function); did you mean 'io_uring_sqe'?
     111 |         const struct bsg_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
         |                                           ^~~~~~~~~~~~~~~~
         |                                           io_uring_sqe
   drivers/scsi/scsi_bsg.c:111:43: note: each undeclared identifier is reported only once for each function it appears in
   drivers/scsi/scsi_bsg.c: In function 'scsi_bsg_uring_cmd':
   drivers/scsi/scsi_bsg.c:137:71: error: macro "io_uring_sqe_cmd" requires 2 arguments, but only 1 given
     137 |         const struct bsg_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
         |                                                                       ^
   include/linux/io_uring/cmd.h:29:9: note: macro "io_uring_sqe_cmd" defined here
      29 | #define io_uring_sqe_cmd(sqe, type)     ({                                      \
         |         ^~~~~~~~~~~~~~~~
   drivers/scsi/scsi_bsg.c:137:43: error: 'io_uring_sqe_cmd' undeclared (first use in this function); did you mean 'io_uring_sqe'?
     137 |         const struct bsg_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
         |                                           ^~~~~~~~~~~~~~~~
         |                                           io_uring_sqe
   drivers/scsi/scsi_bsg.c:203:21: error: assignment to 'enum rq_end_io_ret (*)(struct request *, blk_status_t,  const struct io_comp_batch *)' {aka 'enum rq_end_io_ret (*)(struct request *, unsigned char,  const struct io_comp_batch *)'} from incompatible pointer type 'enum rq_end_io_ret (*)(struct request *, blk_status_t)' {aka 'enum rq_end_io_ret (*)(struct request *, unsigned char)'} [-Wincompatible-pointer-types]
     203 |         req->end_io = scsi_bsg_uring_cmd_done;
         |                     ^


vim +/io_uring_sqe_cmd +111 drivers/scsi/scsi_bsg.c

   106	
   107	static int scsi_bsg_map_user_buffer(struct request *req,
   108					    struct io_uring_cmd *ioucmd,
   109					    unsigned int issue_flags, gfp_t gfp_mask)
   110	{
 > 111		const struct bsg_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
   112		struct iov_iter iter;
   113		bool is_write = cmd->dout_xfer_len > 0;
   114		u64 buf_addr = is_write ? cmd->dout_xferp : cmd->din_xferp;
   115		unsigned long buf_len = is_write ? cmd->dout_xfer_len : cmd->din_xfer_len;
   116		int ret;
   117	
   118		if (ioucmd->flags & IORING_URING_CMD_FIXED) {
   119			ret = io_uring_cmd_import_fixed(buf_addr, buf_len,
   120							is_write ? WRITE : READ,
   121							&iter, ioucmd, issue_flags);
   122			if (ret < 0)
   123				return ret;
   124			ret = blk_rq_map_user_iov(req->q, req, NULL, &iter, gfp_mask);
   125		} else {
   126			ret = blk_rq_map_user(req->q, req, NULL, uptr64(buf_addr),
   127					      buf_len, gfp_mask);
   128		}
   129	
   130		return ret;
   131	}
   132	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

