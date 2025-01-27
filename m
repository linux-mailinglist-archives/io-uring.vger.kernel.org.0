Return-Path: <io-uring+bounces-6135-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FBB8A1D780
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 14:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39FD83A7D24
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 13:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1761C1FF7A5;
	Mon, 27 Jan 2025 13:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITreSYYk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9505E1FFC68;
	Mon, 27 Jan 2025 13:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737985801; cv=none; b=F7MeqUMwDh9AqnAbz9VTF0CPfrtHPsda2VMB/wELMoluxT+jFHPryUKSs55sirg/JaTbiKeoQpZC3XaV1emjPPZwTa8TM8aRf86wN60F8WHhSeBnTDqVBvObJDdcZ4JhtUPpTYgZMMl2hmaEjlJP4yTS7NtSLLMEC6CGc9+GtpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737985801; c=relaxed/simple;
	bh=laZX1iWKmTFe6EBXe6dQ6V5dBHky9feUPubV8bbHYy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rMORzqWZio7hChDXr3/Qm5jAoxmn3zfTl1CgvY0LxIyhoT2v86KB7bEl152QlrUFCUzkwCK29e3++AnjuJnmM48HlKCBcmgXNkS2Mxz1JA1n2RJFuhe8lXQwgO9o9FcUCrsk0Ls4rQo8d942Fvsaj2FBbZIzb3I4Q4SunH6SlLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITreSYYk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881ACC4CED2;
	Mon, 27 Jan 2025 13:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737985800;
	bh=laZX1iWKmTFe6EBXe6dQ6V5dBHky9feUPubV8bbHYy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ITreSYYkYqJo0yzT/NmeCNaU8ylN9fF82uixbVQhbAMNhn/x1ksvsdeN2BZIjx7Av
	 6jRzLOfnz1KOiZ8BN/+a6yzSKjX86nOzP6ewnKK12LbyYoLRgr6MitIVZMs+Q9nRjt
	 1O56sOuQWf9/oW9JBeL1K1Ep9SPnbGRY0gAqf1BfWdrmsV6P6rbrAzrEzJaWATIpCg
	 PxgyGHOSh+1Dp+na/sGNdWcGsgzNCRs4/nnMHS16Kt8UOkwJO9cYsDiIOKruHAZkDs
	 tuJVwo0MPlNeiRHuQkLVgJEWRQ8mSboCfx8PwGZonQ0+bdJkEjI8BLPDWS5oZchNDY
	 iBi9Q4ViZ4cfA==
Date: Mon, 27 Jan 2025 14:49:55 +0100
From: Joel Granados <joel.granados@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, 
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>, Kees Cook <kees@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org, 
	openipmi-developer@lists.sourceforge.net, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, 
	netfs@lists.linux.dev, codalist@coda.cs.cmu.edu, linux-mm@kvack.org, 
	linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev, fsverity@lists.linux.dev, 
	linux-xfs@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org, 
	kexec@lists.infradead.org, linux-trace-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	keyrings@vger.kernel.org, Song Liu <song@kernel.org>, 
	"Steven Rostedt (Google)" <rostedt@goodmis.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Jani Nikula <jani.nikula@intel.com>, 
	Corey Minyard <cminyard@mvista.com>
Subject: Re: Re: Re: [PATCH v2] treewide: const qualify ctl_tables where
 applicable
Message-ID: <f4lfo2fb7ajogucsvisfd5sg2avykavmkizr6ycsllcrco4mo3@qt2zx4zp57zh>
References: <20250110-jag-ctl_table_const-v2-1-0000e1663144@kernel.org>
 <Z4+jwDBrZNRgu85S@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <nslqrapp4v3rknjgtfk4cg64ha7rewrrg24aslo2e5jmxfwce5@t4chrpuk632k>
 <CAMj1kXEZPe8zk7s67SADK9wVH3cfBup-sAZSC6_pJyng9QT7aw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEZPe8zk7s67SADK9wVH3cfBup-sAZSC6_pJyng9QT7aw@mail.gmail.com>

On Wed, Jan 22, 2025 at 01:41:35PM +0100, Ard Biesheuvel wrote:
> On Wed, 22 Jan 2025 at 13:25, Joel Granados <joel.granados@kernel.org> wrote:
> >
> > On Tue, Jan 21, 2025 at 02:40:16PM +0100, Alexander Gordeev wrote:
> > > On Fri, Jan 10, 2025 at 03:16:08PM +0100, Joel Granados wrote:
> > >
> > > Hi Joel,
> > >
> > > > Add the const qualifier to all the ctl_tables in the tree except for
> > > > watchdog_hardlockup_sysctl, memory_allocation_profiling_sysctls,
> > > > loadpin_sysctl_table and the ones calling register_net_sysctl (./net,
> > > > drivers/inifiniband dirs). These are special cases as they use a
> > > > registration function with a non-const qualified ctl_table argument or
> > > > modify the arrays before passing them on to the registration function.
> > > >
> > > > Constifying ctl_table structs will prevent the modification of
> > > > proc_handler function pointers as the arrays would reside in .rodata.
> > > > This is made possible after commit 78eb4ea25cd5 ("sysctl: treewide:
> > > > constify the ctl_table argument of proc_handlers") constified all the
> > > > proc_handlers.
> > >
> > > I could identify at least these occurences in s390 code as well:
> > Hey Alexander
> >
> > Thx for bringing these to my attention. I had completely missed them as
> > the spatch only deals with ctl_tables outside functions.
> >
> > Short answer:
> > These should not be included in the current patch because they are a
> > different pattern from how sysctl tables are usually used. So I will not
> > include them.
> >
> > With that said, I think it might be interesting to look closer at them
> > as they seem to be complicating the proc_handler (I have to look at them
> > closer).
> >
> > I see that they are defining a ctl_table struct within the functions and
> > just using the data (from the incoming ctl_table) to forward things down
> > to proc_do{u,}intvec_* functions. This is very odd and I have only seen
> > it done in order to change the incoming ctl_table (which is not what is
> > being done here).
> >
> > I will take a closer look after the merge window and circle back with
> > more info. Might take me a while as I'm not very familiar with s390
> > code; any additional information on why those are being used inside the
> > functions would be helpfull.
> >
> 
> Using const data on the stack is not as useful, because the stack is
> always mapped writable.
> 
> Global data structures marked 'const' will be moved into an ELF
> section that is typically mapped read-only in its entirely, and so the
> data cannot be modified by writing to it directly. No such protection
> is possible for the stack, and so the constness there is only enforced
> at compile time.
I completely agree with you. No reason to use const within those
functions. But why define those ctl_tables in function to begin with.
Can't you just use the ones that are defined outside the functions?

Best


-- 

Joel Granados

