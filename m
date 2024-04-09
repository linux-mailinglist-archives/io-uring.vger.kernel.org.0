Return-Path: <io-uring+bounces-1473-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D9F89D52B
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 11:12:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71C31282652
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 09:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0637E794;
	Tue,  9 Apr 2024 09:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NE6kKh+x"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329C776020;
	Tue,  9 Apr 2024 09:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712653969; cv=none; b=s4oAqw0/SZmMqFnhfPWnyfqJxg5kmfzSlBUs0RKw7HeDPl1921Ei7edOHGli++mV2z7tKU4AJgaxoz7IG/UisPHtNJJSvlx0vyfSTICnVuH1FU5L/syIn5R5SF1Mforn/6Bh6VtwIm8B4INmU/8tenkAXuOz2Vu8XJ6h/o7ogEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712653969; c=relaxed/simple;
	bh=kQPF6T3t2dgBZkOXgWb9q6oOpIuyIoHqNG2JlvWDOz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TvNKBG6ZMJ5H1YxpOhGlW9CHFlhR0sgek8dz3OGxqHaLb2GZWP1xRUUemcxtydli6/FQtHDtnprqsS6ld5/y8NtYvKR1MCHkUBS8M0WJEFeCmsxxLuXCM83NazpEVCiOLhu1Hxx16cl+bmMJ+w+c7SFLxUobFERXkpIKgD8QaI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NE6kKh+x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8DEC433C7;
	Tue,  9 Apr 2024 09:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712653968;
	bh=kQPF6T3t2dgBZkOXgWb9q6oOpIuyIoHqNG2JlvWDOz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NE6kKh+xC25D1q84GnsBi5H+KikoYzF8OoClDoQcXD9VpTz0+SX8mQMlb0GxJP6Uw
	 VUqbZOmdNH+0XBrCXg/v+ZCdKUC2VH+i40cDd9rPUlx6CV9d6RX6HQVq3aQGdy13Cm
	 5jaz2gp8Zfo7WVcFLmjkzeV+7CFosjAQUFxiwMMV2MdIn2a0HOqnkXp0h4mi6CIj+b
	 GyEW9JksqrQX4KBlvyWEm/91sH3JynRNiPFCJKmyLRIIItKYrxU9UmuHX1M8A+Ki9j
	 nsJZy4SCfJ0NNI+OsBV8ypq78FD85eNFbk5qRxbxX2dWp8lmlZwLBOQP5Lfq4zba6D
	 WinPa2wSrHJvg==
Date: Tue, 9 Apr 2024 11:12:43 +0200
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH v2] fs: claw back a few FMODE_* bits
Message-ID: <20240409-autokauf-kniebeschwerden-c0452289cc08@brauner>
References: <20240328-gewendet-spargel-aa60a030ef74@brauner>
 <20240406061002.GZ538574@ZenIV>
 <20240406061604.GA538574@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240406061604.GA538574@ZenIV>

On Sat, Apr 06, 2024 at 07:16:04AM +0100, Al Viro wrote:
> On Sat, Apr 06, 2024 at 07:10:02AM +0100, Al Viro wrote:
> > On Thu, Mar 28, 2024 at 01:27:24PM +0100, Christian Brauner wrote:
> > > There's a bunch of flags that are purely based on what the file
> > > operations support while also never being conditionally set or unset.
> > > IOW, they're not subject to change for individual files. Imho, such
> > > flags don't need to live in f_mode they might as well live in the fops
> > > structs itself. And the fops struct already has that lonely
> > > mmap_supported_flags member. We might as well turn that into a generic
> > > fop_flags member and move a few flags from FMODE_* space into FOP_*
> > > space. That gets us four FMODE_* bits back and the ability for new
> > > static flags that are about file ops to not have to live in FMODE_*
> > > space but in their own FOP_* space. It's not the most beautiful thing
> > > ever but it gets the job done. Yes, there'll be an additional pointer
> > > chase but hopefully that won't matter for these flags.
> > > 
> > > I suspect there's a few more we can move into there and that we can also
> > > redirect a bunch of new flag suggestions that follow this pattern into
> > > the fop_flags field instead of f_mode.
> > 
> > Looks sane; one suggestion, though - if we are going to try and free
> > bits, etc., it might be a good idea to use e.g.
> > #define FMODE_NOACCOUNT         ((__force fmode_t)BIT(29))
> > instead of hex constants.  IME it's easier to keep track of, especially
> > if we have comments between the definitions.
> 
> ... or (1u << 29), for that matter; the point is that counting zeroes
> visually is error-prone, so seeing the binary logarithm of the value
> somewhere would be a good idea.

Sounds good. I've converted all FMODE_* flags to use <<.

