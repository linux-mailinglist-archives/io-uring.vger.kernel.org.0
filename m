Return-Path: <io-uring+bounces-6138-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3EE0A1D9BB
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 16:43:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3116E18883FF
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 15:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C1B13AA2E;
	Mon, 27 Jan 2025 15:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pyozw0ts"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F368A19BBA;
	Mon, 27 Jan 2025 15:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737992581; cv=none; b=hlKJ084b+wIEqZXyGUKaz7+c0w8WaWn5o0hoAaeubRTleSjf1mswjJTKsK59jZOs2Vz3B0rrY+AlvAbz449SGJkZ/003U2pbuza3vd4wk/cmUUvDjhUAXv8nqfyaARgsKu+LYmanLs4LbwRrC0GtHk4l/nVs0yDkh941/nwwHR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737992581; c=relaxed/simple;
	bh=754tTQ0Xv0FV1pAPiQ7XMzOqvV5Ru3eT2/4MtIxHkKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pcxjjWPHVuwrYIY3AW5zCkXqNuIvI2fQQ0VJx0xLK3WwbCAoyoO1pu4yLS/kX6gczLJqYNs4V2wyhB3ULJzgKjwL/IDvffeq1CbImkTFPDwGY7ajdNyjpUetqcdWx+dtSyOqy04rVVlQvjLsKbrQIrM+Zsrco896Xe2Q6pjCfmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pyozw0ts; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=754tTQ0Xv0FV1pAPiQ7XMzOqvV5Ru3eT2/4MtIxHkKc=; b=Pyozw0tsKLD9gp97o+N6ZbHkTo
	Il8/2Vpa4F0aqTQ5eLNtncdojFavxqC+3hOoMyt2pPZYgpxoa7oSXp+1z19h2FwdJ9ksectEr6L5y
	pdndzuM9IJbuYbMGyY8OnttTeia0ZsfUEQN3vE3Kvu3ywzVzVm7PiaoVN1j+XGx7cGtNMyIWcHM2K
	IHU9EJmiTnsw2atKedPjlIYgnndG3plYffG/psV0clxoDlPsLg9vBJ8MCt7RCyZQNR2Rl4uIk2hOI
	SGpvgckCCBw+KC2Pto4K/lzMPYNt+Lyqoqjs99RL8H5P/AQH7nlJDuMDpJ1IZ/IMsyAIp8YsG+ytq
	PlpOQ/eA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tcRG3-00000009b8r-2Zcd;
	Mon, 27 Jan 2025 15:42:39 +0000
Date: Mon, 27 Jan 2025 15:42:39 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Joel Granados <joel.granados@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-hyperv@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev,
	codalist@coda.cs.cmu.edu, linux-mm@kvack.org,
	linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	io-uring@vger.kernel.org, bpf@vger.kernel.org,
	kexec@lists.infradead.org, linux-trace-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	Song Liu <song@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Corey Minyard <cminyard@mvista.com>
Subject: Re: Re: Re: [PATCH v2] treewide: const qualify ctl_tables where
 applicable
Message-ID: <Z5epb86xkHQ3BLhp@casper.infradead.org>
References: <20250110-jag-ctl_table_const-v2-1-0000e1663144@kernel.org>
 <Z4+jwDBrZNRgu85S@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <nslqrapp4v3rknjgtfk4cg64ha7rewrrg24aslo2e5jmxfwce5@t4chrpuk632k>
 <CAMj1kXEZPe8zk7s67SADK9wVH3cfBup-sAZSC6_pJyng9QT7aw@mail.gmail.com>
 <f4lfo2fb7ajogucsvisfd5sg2avykavmkizr6ycsllcrco4mo3@qt2zx4zp57zh>
 <87jzag9ugx.fsf@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jzag9ugx.fsf@intel.com>

On Mon, Jan 27, 2025 at 04:55:58PM +0200, Jani Nikula wrote:
> You could have static const within functions too. You get the rodata
> protection and function local scope, best of both worlds?

timer_active is on the stack, so it can't be static const.

Does this really need to be cc'd to such a wide distribution list?

