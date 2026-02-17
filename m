Return-Path: <io-uring+bounces-12274-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Q280MIf7k2n4+AEAu9opvQ
	(envelope-from <io-uring+bounces-12274-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 06:24:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 42469148C6C
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 06:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 635483017052
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 05:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4988261B70;
	Tue, 17 Feb 2026 05:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cqUHBRWI"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F55E13B293;
	Tue, 17 Feb 2026 05:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771305858; cv=none; b=SD1kXWvWTZrnKC70puwZsbqs3ZhkeLov0MspbpyKfRWtl7WzYErbLsvOXJHSD2a5EK5If8E1brJ0F1lM5jUyF+TTQkYwvHAded3nQLs514+rG76PZuiw1pkTp8TQTzZ+S5z2lutEjX5fQ2tJ8ksTxzHdW+HEsbLvYMyx0WYD8Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771305858; c=relaxed/simple;
	bh=xnzvI0dvY1F6SzS6tkE5JdjTYwIWYLKs5Ofc48sGVdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxAnSE6MKWdACM0o+giDX1Es9tfYymyAmukMONqcNejatCa23UAnz8eys4M+UpGTbg4PnMYIlEXJJerfIOJyVC1vhm/wlDp/62I3rXWk88N5t6PxEmlfpR45PR9ZDphBkDyeD1U3B/AIRZIU113VDP/H526H6815VnO3d5Nh/cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cqUHBRWI; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771305857; x=1802841857;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xnzvI0dvY1F6SzS6tkE5JdjTYwIWYLKs5Ofc48sGVdA=;
  b=cqUHBRWIwFMth5YZgu/vEncNfPXq3aKmxyL4jal3FnE7DChJjetLsRmA
   1jTx/EFvoMqvzMyyAVGywHaTNZm39i0FOYKWJSG9HS8zj99rrCjwz+sbc
   VzMwbHLWT51XPzhsiWHOH54nvuPFvaPyuGI2gcRb5JJYh55aPOiGQp4YZ
   BRjiRwhmS7Oxm/p22t5Je/AWkPEQOJS5cNDfL/QnO0G2oL6Rqm4w1orcQ
   LcCgtpQaD747NHSMMnu5iTYOn48xXwkI+xKHR/xQ5TroToW8wzliR2YAA
   d0/dDMEkkyNyg5TEheVpmLfy6rAU1V7RV8AMm8DHhBL6MefjFsiAbDWOT
   Q==;
X-CSE-ConnectionGUID: /2O2lvHHS168sZ0zOAKVyA==
X-CSE-MsgGUID: xdX3OfQrSmqQDlgOxNRxuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11703"; a="72279700"
X-IronPort-AV: E=Sophos;i="6.21,295,1763452800"; 
   d="scan'208";a="72279700"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 21:24:17 -0800
X-CSE-ConnectionGUID: +RfV6L2hToyQWGU8Gz6V9w==
X-CSE-MsgGUID: mkNANzXsT9ydo831Z9v36A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,295,1763452800"; 
   d="scan'208";a="212869103"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 16 Feb 2026 21:24:15 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vsDZE-000000010do-3W9j;
	Tue, 17 Feb 2026 05:24:12 +0000
Date: Tue, 17 Feb 2026 13:24:03 +0800
From: kernel test robot <lkp@intel.com>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, asml.silence@gmail.com,
	bpf@vger.kernel.org, axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v7 2/5] io_uring/bpf-ops: implement loop_step with BPF
 struct_ops
Message-ID: <202602171315.iJKYSSFe-lkp@intel.com>
References: <ec7d21e6e16c49165fa1e8af2aa09d01c111ea97.1771260487.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec7d21e6e16c49165fa1e8af2aa09d01c111ea97.1771260487.git.asml.silence@gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[lists.linux.dev,gmail.com,vger.kernel.org,kernel.dk];
	TAGGED_FROM(0.00)[bounces-12274-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email,01.org:url]
X-Rspamd-Queue-Id: 42469148C6C
X-Rspamd-Action: no action

Hi Pavel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe/for-next]
[also build test WARNING on linus/master next-20260216]
[cannot apply to shuah-kselftest/next shuah-kselftest/fixes v6.19]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavel-Begunkov/io_uring-introduce-callback-driven-main-loop/20260217-005705
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/ec7d21e6e16c49165fa1e8af2aa09d01c111ea97.1771260487.git.asml.silence%40gmail.com
patch subject: [PATCH v7 2/5] io_uring/bpf-ops: implement loop_step with BPF struct_ops
config: parisc-randconfig-r071-20260217 (https://download.01.org/0day-ci/archive/20260217/202602171315.iJKYSSFe-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
smatch version: v0.5.0-8994-gd50c5a4c

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602171315.iJKYSSFe-lkp@intel.com/

smatch warnings:
io_uring/bpf-ops.c:45 bpf_io_btf_struct_access() warn: always true condition '(off >= $expr_0x7fb415932650(30)) => (s32min-s32max >= 0)'

vim +45 io_uring/bpf-ops.c

    37	
    38	static int bpf_io_btf_struct_access(struct bpf_verifier_log *log,
    39					    const struct bpf_reg_state *reg, int off,
    40					    int size)
    41	{
    42		const struct btf_type *t = btf_type_by_id(reg->btf, reg->btf_id);
    43	
    44		if (t == loop_params_type) {
  > 45			if (off >= offsetof(struct iou_loop_params, cq_wait_idx) &&
    46			    off + size <= offsetofend(struct iou_loop_params, cq_wait_idx))
    47				return SCALAR_VALUE;
    48		}
    49	
    50		return -EACCES;
    51	}
    52	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

