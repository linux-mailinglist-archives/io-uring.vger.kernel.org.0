Return-Path: <io-uring+bounces-1424-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 726D089A94E
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 08:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95B631C20F89
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 06:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F431EEFC;
	Sat,  6 Apr 2024 06:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="U/2s4sfx"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3F21BF31;
	Sat,  6 Apr 2024 06:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712384168; cv=none; b=XUn214X9PM1HM69wWb0eq5pxhv4pVdbjtH8fgzERrAmv70u0GIfHiFNQXYSPX9rLIe8cqgAZVYqIX1RT7LjcHBDTfChrjmqjtpvafq2AtZ6xYrWcnc5QJaDDywQafOLUSFx9kR87LQoIS3LfGuaMlFlZm7+XASTwujSU+rDwvPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712384168; c=relaxed/simple;
	bh=d4itzMhVouPkdWu0TmADzDj09n4phHaCTP/E0VbGXSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pNO+PSMv72WMXsPtOr+QcGkYkhoA/jLkYGdw2Bw+S/xx5wIHYf/y8jxZ8LVAk61+SGDR3ErtA/fvGFhaOmBqBdjj2DYLhG60ynhzFXdu4suAK0Thsa77swyqknpc46CKAcHmFglPWddt4K8j3I5S6VksVINwXfBKsH7DqjSTdyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=U/2s4sfx; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J7a9rJZ9EGUc2sQtJJ07mg5aIkdIfWZISEfnz6UMzAU=; b=U/2s4sfx3FHO/Z21H1TcFEBz8T
	OudxlmWByFG7yLnE933YyBryKm58TQRPlcNtYE7jHjomrNIQncm7ep0D21Ul+B+GjwV+623Qai9q5
	mEYuvJ+oWGWscCcYHa80XqcK9HI6rn432lQNWX8Dr/kTwcV4shTCp8idZqFgmDZgd0NnX4UKIJpVe
	4ZYhkQWDWjQqilkAq9AdEfEA46n4Zc3vSCNlyJ93ICvDpmdgFigmAjcMmwnwEBJ0WKniL2V5hSNS/
	K8sSJd7CEnF8SeTOdH3tsCMn+WmSBTmSAotWf2vpL4pncJQBH4JFyg8+7p5IseJwNg+veGbqaX0PE
	rfGnN0XA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rszLQ-006wTF-0L;
	Sat, 06 Apr 2024 06:16:04 +0000
Date: Sat, 6 Apr 2024 07:16:04 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] fs: claw back a few FMODE_* bits
Message-ID: <20240406061604.GA538574@ZenIV>
References: <20240328-gewendet-spargel-aa60a030ef74@brauner>
 <20240406061002.GZ538574@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240406061002.GZ538574@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sat, Apr 06, 2024 at 07:10:02AM +0100, Al Viro wrote:
> On Thu, Mar 28, 2024 at 01:27:24PM +0100, Christian Brauner wrote:
> > There's a bunch of flags that are purely based on what the file
> > operations support while also never being conditionally set or unset.
> > IOW, they're not subject to change for individual files. Imho, such
> > flags don't need to live in f_mode they might as well live in the fops
> > structs itself. And the fops struct already has that lonely
> > mmap_supported_flags member. We might as well turn that into a generic
> > fop_flags member and move a few flags from FMODE_* space into FOP_*
> > space. That gets us four FMODE_* bits back and the ability for new
> > static flags that are about file ops to not have to live in FMODE_*
> > space but in their own FOP_* space. It's not the most beautiful thing
> > ever but it gets the job done. Yes, there'll be an additional pointer
> > chase but hopefully that won't matter for these flags.
> > 
> > I suspect there's a few more we can move into there and that we can also
> > redirect a bunch of new flag suggestions that follow this pattern into
> > the fop_flags field instead of f_mode.
> 
> Looks sane; one suggestion, though - if we are going to try and free
> bits, etc., it might be a good idea to use e.g.
> #define FMODE_NOACCOUNT         ((__force fmode_t)BIT(29))
> instead of hex constants.  IME it's easier to keep track of, especially
> if we have comments between the definitions.

... or (1u << 29), for that matter; the point is that counting zeroes
visually is error-prone, so seeing the binary logarithm of the value
somewhere would be a good idea.


