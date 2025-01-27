Return-Path: <io-uring+bounces-6136-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EA114A1D8D3
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 15:56:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 353D27A1819
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 14:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C399355897;
	Mon, 27 Jan 2025 14:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WVed1oKV"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E4538DE9;
	Mon, 27 Jan 2025 14:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737989776; cv=none; b=V5GBqUkDNOeZWitYA2XfvQY+fSpuuSzJX10edxhXNQQRk/IdKek95ROewjYlFbQw3WbBtSyfITVYEY0iqeD1KfbBVNzl0SiIi8c7WAzuMqNcrCdJzQm/FviB1MVhnv1AYeGxAGKENg/3q140Y3ph94OMeVJTeZnLlB/jAL3K5L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737989776; c=relaxed/simple;
	bh=jgZ2GO8S3cXCdWyE6ZvOdFoqm0rhCqZC3ICQKad44uQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qESKVxqOrAXe9OgMwi4km3msue6Z+bStm5HR/sKuHk705JFMXZO/XF4UIO2wht6UtiU7QZzQmMSPdFyJ0eJKeisPSCmuESl0ZAL5Xo8WCRf0A7gE1UM7D9hrBwdkvYeoN/jxu7Qa37qygysMiCtB8+/QlkTDXAc5mWlqoKi8VnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WVed1oKV; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737989775; x=1769525775;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=jgZ2GO8S3cXCdWyE6ZvOdFoqm0rhCqZC3ICQKad44uQ=;
  b=WVed1oKVFkzK/oETPO0J8VpsIwi4ypJTg0lX+AcJEgqH+erXdJNaC/zx
   vwuxJ5EvFrKw8crBjfrH3OrZkmYyiIBfNFMF7HidrQkt6uq0J8zqSAp/C
   45ZUNEiKIjk56k4gUxBaq3cmZw4dCPXjJfc0nYZR7zJGhVo2kmA6NEUXR
   0KWBG3Cls9htsZqhlU+aXWYz+V2nSgl8rO7BSXBFLVrHPboFTM4jos7U7
   sXSVvlfFUG6DsyEBbPRooxxmuhyYGXhs3SfVRgtB3m5OhDLEzWHgORxHb
   nG6Ys7jT0v1Ol5wgE5vgBrxk+WOrx/f94U1RMMbUu5Eo/yUWua9d7E6Dh
   w==;
X-CSE-ConnectionGUID: 6HP7/vAvQ/yiDPBSiq3Asw==
X-CSE-MsgGUID: yhqiLSZiQVmyFVnUzK1mOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11328"; a="49104680"
X-IronPort-AV: E=Sophos;i="6.13,238,1732608000"; 
   d="scan'208";a="49104680"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2025 06:56:13 -0800
X-CSE-ConnectionGUID: Z9Coz29cQ6uqfPwc/L4sHg==
X-CSE-MsgGUID: XE2pskZGQO2Q6A9y4rThjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="113598177"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.14])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2025 06:56:01 -0800
From: Jani Nikula <jani.nikula@intel.com>
To: Joel Granados <joel.granados@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, Thomas =?utf-8?Q?Wei=C3=9F?=
 =?utf-8?Q?schuh?=
 <linux@weissschuh.net>, Kees Cook <kees@kernel.org>, Luis Chamberlain
 <mcgrof@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-crypto@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-hyperv@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-aio@kvack.org,
 linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev,
 codalist@coda.cs.cmu.edu, linux-mm@kvack.org, linux-nfs@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, fsverity@lists.linux.dev,
 linux-xfs@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org,
 kexec@lists.infradead.org, linux-trace-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org, apparmor@lists.ubuntu.com,
 linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, Song Liu
 <song@kernel.org>, "Steven Rostedt (Google)" <rostedt@goodmis.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, "Darrick J. Wong"
 <djwong@kernel.org>, Corey Minyard <cminyard@mvista.com>
Subject: Re: Re: Re: [PATCH v2] treewide: const qualify ctl_tables where
 applicable
In-Reply-To: <f4lfo2fb7ajogucsvisfd5sg2avykavmkizr6ycsllcrco4mo3@qt2zx4zp57zh>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20250110-jag-ctl_table_const-v2-1-0000e1663144@kernel.org>
 <Z4+jwDBrZNRgu85S@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <nslqrapp4v3rknjgtfk4cg64ha7rewrrg24aslo2e5jmxfwce5@t4chrpuk632k>
 <CAMj1kXEZPe8zk7s67SADK9wVH3cfBup-sAZSC6_pJyng9QT7aw@mail.gmail.com>
 <f4lfo2fb7ajogucsvisfd5sg2avykavmkizr6ycsllcrco4mo3@qt2zx4zp57zh>
Date: Mon, 27 Jan 2025 16:55:58 +0200
Message-ID: <87jzag9ugx.fsf@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, 27 Jan 2025, Joel Granados <joel.granados@kernel.org> wrote:
> On Wed, Jan 22, 2025 at 01:41:35PM +0100, Ard Biesheuvel wrote:
>> On Wed, 22 Jan 2025 at 13:25, Joel Granados <joel.granados@kernel.org> wrote:
>> >
>> > On Tue, Jan 21, 2025 at 02:40:16PM +0100, Alexander Gordeev wrote:
>> > > On Fri, Jan 10, 2025 at 03:16:08PM +0100, Joel Granados wrote:
>> > >
>> > > Hi Joel,
>> > >
>> > > > Add the const qualifier to all the ctl_tables in the tree except for
>> > > > watchdog_hardlockup_sysctl, memory_allocation_profiling_sysctls,
>> > > > loadpin_sysctl_table and the ones calling register_net_sysctl (./net,
>> > > > drivers/inifiniband dirs). These are special cases as they use a
>> > > > registration function with a non-const qualified ctl_table argument or
>> > > > modify the arrays before passing them on to the registration function.
>> > > >
>> > > > Constifying ctl_table structs will prevent the modification of
>> > > > proc_handler function pointers as the arrays would reside in .rodata.
>> > > > This is made possible after commit 78eb4ea25cd5 ("sysctl: treewide:
>> > > > constify the ctl_table argument of proc_handlers") constified all the
>> > > > proc_handlers.
>> > >
>> > > I could identify at least these occurences in s390 code as well:
>> > Hey Alexander
>> >
>> > Thx for bringing these to my attention. I had completely missed them as
>> > the spatch only deals with ctl_tables outside functions.
>> >
>> > Short answer:
>> > These should not be included in the current patch because they are a
>> > different pattern from how sysctl tables are usually used. So I will not
>> > include them.
>> >
>> > With that said, I think it might be interesting to look closer at them
>> > as they seem to be complicating the proc_handler (I have to look at them
>> > closer).
>> >
>> > I see that they are defining a ctl_table struct within the functions and
>> > just using the data (from the incoming ctl_table) to forward things down
>> > to proc_do{u,}intvec_* functions. This is very odd and I have only seen
>> > it done in order to change the incoming ctl_table (which is not what is
>> > being done here).
>> >
>> > I will take a closer look after the merge window and circle back with
>> > more info. Might take me a while as I'm not very familiar with s390
>> > code; any additional information on why those are being used inside the
>> > functions would be helpfull.
>> >
>> 
>> Using const data on the stack is not as useful, because the stack is
>> always mapped writable.
>> 
>> Global data structures marked 'const' will be moved into an ELF
>> section that is typically mapped read-only in its entirely, and so the
>> data cannot be modified by writing to it directly. No such protection
>> is possible for the stack, and so the constness there is only enforced
>> at compile time.
> I completely agree with you. No reason to use const within those
> functions. But why define those ctl_tables in function to begin with.
> Can't you just use the ones that are defined outside the functions?

You could have static const within functions too. You get the rodata
protection and function local scope, best of both worlds?

BR,
Jani.


-- 
Jani Nikula, Intel

