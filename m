Return-Path: <io-uring+bounces-1357-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E018894587
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 21:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC1D02817C4
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 19:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F0CD52F70;
	Mon,  1 Apr 2024 19:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZi0dxgU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA4947A76;
	Mon,  1 Apr 2024 19:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712000116; cv=none; b=WikevgIFHGNPhc7gwVJ558vaCDTcwTyeO4GoIgdsBH60c+hjWN85av17DDkD6nJHEmetRcFK7TVDmKqRCsqg6LkhpCxVqivs6DeIF/8CO3AxAUvtn9dAkokga28A5f8R3eHBV9sIlSV6OYaJQOjafOz5d0sZ0nnkcV5icFUkQwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712000116; c=relaxed/simple;
	bh=8+8DMvn8H/rEx87hcTx4tH/GOEGymkbhk4P8ku15sRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4FOsymgTV0i3LqYfHV39RFPelyd6KogIvqv3iNM3+nJ+T6P9tBYIwaoccD7zqg0ODrDMpML4JkCGLiPDcM7okDTX9nIqG5UbMNRbC7uogjYQMXlgppslwygZ+aI0DixoXZmOCG4ksHMdaCKzoDoe9fGn0uROtxuEkNpKtqtc10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZi0dxgU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411C9C433F1;
	Mon,  1 Apr 2024 19:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712000115;
	bh=8+8DMvn8H/rEx87hcTx4tH/GOEGymkbhk4P8ku15sRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aZi0dxgUZgiApySUQV/d8HVdp9F2H+iaImfhPmb3uZqg/+R/LNgR0AXm/xE0EodaC
	 f0pbd9A52N+ui13wMNc4sofbRJq84HpEy7axt1t9O2V10eM9l1nSOqBHNEjqWz1ip3
	 yE4QLJticm5ZZQwQ4DuAVbeg0dMBQI3RwvcqE1dN5Fmubu4A/KqlHm96oh++3y03b1
	 m3DSfKQFjpVxcjKeGxxjQXVzr8PYjxs2pDLjJ55j+t1c+kTjPdKS0IKJs6DlPpmPry
	 PK+HMgTEZR5eN+7X/nxYJtzFT+K6a6Nt2/G+plhBiNJHK+m4hY58Aozfeqx1QcT7Do
	 Lpafk3fUIcC3g==
Date: Mon, 1 Apr 2024 12:35:13 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
	llvm@lists.linux.dev, io-uring@vger.kernel.org
Subject: Re: [axboe-block:for-6.10/io_uring 42/42]
 io_uring/register.c:175:24: warning: arithmetic between different
 enumeration types ('enum io_uring_register_restriction_op' and 'enum
 io_uring_register_op')
Message-ID: <20240401193513.GA132793@dev-arch.thelio-3990X>
References: <202403291458.6AjzdI64-lkp@intel.com>
 <87h6go66fm.fsf@mailhost.krisman.be>
 <940f0842-194d-4799-8bb2-2024e6903608@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <940f0842-194d-4799-8bb2-2024e6903608@kernel.dk>

On Fri, Mar 29, 2024 at 05:15:44PM -0600, Jens Axboe wrote:
> On 3/29/24 4:04 PM, Gabriel Krisman Bertazi wrote:
> > kernel test robot <lkp@intel.com> writes:
> > 
> > [+ io_uring list ]
> > 
> >>>> io_uring/register.c:175:24: warning: arithmetic between different
> >> enumeration types ('enum io_uring_register_restriction_op' and 'enum
> >> io_uring_register_op') [-Wenum-enum-conversion]
> >>      175 |         if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
> >>          |                               ^~~~~~~~~~~~~~~~~~~~~~~
> >>    io_uring/register.c:31:58: note: expanded from macro 'IORING_MAX_RESTRICTIONS'
> >>       31 | #define IORING_MAX_RESTRICTIONS (IORING_RESTRICTION_LAST + \
> >>          |                                  ~~~~~~~~~~~~~~~~~~~~~~~ ^
> >>       32 |                                  IORING_REGISTER_LAST + IORING_OP_LAST)
> >>          |                                  ~~~~~~~~~~~~~~~~~~~~
> >>    14 warnings generated.
> > 
> > hm.
> > 
> > Do we want to fix?  The arithmetic is safe here.  I actually tried
> > triggering the warning with gcc, but even with -Wenum-conversion in
> > gcc-12 (which is in -Wextra and we don't use in the kernel build), I
> > couldn't do it.  only llvm catches this.
> > 
> > can we explicit cast to int to silent it?
> 
> I don't think we care, there are others like it in the kernel already.
> Plus you need some magic warning incantation to hit it, clang by default
> is not going to be enough.

The magic incantion would be W=1 after commit 75b5ab134bb5 ("kbuild:
Move -Wenum-{compare-conditional,enum-conversion} into W=1") but yes,
there are plenty of other instances of this warning in the kernel and if
the arithmetic is safe, ignoring the warning is perfectly fine in my
opinion. The primary reason it is in W=1 rather than off by default is
to see how many current instances may be bugs and see what new instances
may pop up, as they may be unsafe conversions. We will have to come up
with some way to annotate safe conversions if we want to turn this on by
default (which is still being determined at this point). You do also
have to have a tip of tree Clang to see this at the moment as well.

Cheers,
Nathan

