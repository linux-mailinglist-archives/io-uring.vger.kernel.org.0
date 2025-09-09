Return-Path: <io-uring+bounces-9665-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E997B4FF27
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 16:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2802C3A3414
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 14:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9723E342C89;
	Tue,  9 Sep 2025 14:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ci695d5T"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D89B2EDD52;
	Tue,  9 Sep 2025 14:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757427500; cv=none; b=uyz01oZZ+w/uIgEvMlb/sD+kAxpuiELYl37k6Oz8qPP8x28IKUvHVwD9RoGxs2//DJ2DrNmilQCKuwlQlFypW0bF5BFRRDDW2Qt92ikRRKlWy+gDDne0U87oOiZfG4CFLGs6PI1SgB0tACFECgggt3rFTaNMoFc/wRph9ip41Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757427500; c=relaxed/simple;
	bh=L3qH5tnuygJ0kC75f4V1VnsxdNy60kwL27d9IJFGMLk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a2lTz8XK0yjJxolx0kkW2rZaobZrsq3HrZMlXQsaG2EGNK2Id7w/jp9EJyOWJZBVfuJSO7ZQYRZyt8AK4Nzl5HMPlQlq4xEGA/AeKobALhGqBXclFmf9nRb6HbK6Xhzrc/hita5b4MbUMK4i7vpNhJySFaPpbl0mb/km8S8uj2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ci695d5T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A690C4CEF4;
	Tue,  9 Sep 2025 14:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757427500;
	bh=L3qH5tnuygJ0kC75f4V1VnsxdNy60kwL27d9IJFGMLk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ci695d5T5gWqGp7j7eEywyf2j3kP9Sj4VfSVxD6/0CK/aht/zvdHh1sW9mgxHIufY
	 d6lM5AtIjjcQZcUP4lKcBDJtC5qm21avaRs8DOMHNPV85qhtUUVSul+kzXq3aLHkKl
	 6I6GI6cwAzmw/G3mEFKxMcGW/a4ut/i97KjOF4l7YgCxf9GASynV8n3aFbMbgINDeN
	 Edu+QqtGsxAnzDLS8E4shhjPmud9jLNc44US+QCcjlfuDeSxh/onYxdXJGrTKKeNFj
	 zf5dhionb/yEAgwYxKqrJL8EAzhWMvVglhLc4eGrRW67f3qlRioNTNZ4vHMAxRiSQM
	 nf1Qnpm0x+AQA==
Date: Tue, 9 Sep 2025 07:18:18 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>, Linus Torvalds
 <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com, Jens
 Axboe <axboe@kernel.dk>, Caleb Sander Mateos <csander@purestorage.com>,
 io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <20250909071818.15507ee6@kernel.org>
In-Reply-To: <5922560.DvuYhMxLoT@rafael.j.wysocki>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
	<20250905-sparkling-stalwart-galago-8a87e0@lemur>
	<68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
	<5922560.DvuYhMxLoT@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 09 Sep 2025 15:17:15 +0200 Rafael J. Wysocki wrote:
> > > We do support this usage using `b4 shazam -M` -- it's the functional
> > > equivalent of applying a pull request and will use the cover letter contents
> > > as the initial source of the merge commit message. I do encourage people to
> > > use this more than just a linear `git am` for series, for a number of reasons:  
> > 
> > For me, as a subsystem downstream person the 'mindless' patch.msgid.link
> > saves me time when I need to report a regression, or validate which
> > version of a patch was pulled from a list when curating a long-running
> > topic in a staging tree. I do make sure to put actual discussion
> > references outside the patch.msgid.link namespace and hope that others
> > continue to use this helpful breadcrumb.  
> 
> Same here.
> 
> Every time one needs to connect a git commit with a patch that it has come from,
> the presence of patch.msgid.link saves a search of a mailing list archive (if
> all goes well, or more searches otherwise).
> 
> On a global scale, that's quite a number of saved mailing list archive searches.

+1 FWIW. I also started slapping the links on all patches in a series,
even if we apply with a merge commit. I don't know of a good way with
git to "get to the first parent merge" so scanning the history to find
the link in the cover letter was annoying me :(

