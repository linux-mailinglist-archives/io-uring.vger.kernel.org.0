Return-Path: <io-uring+bounces-9667-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A737B4FFBB
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 16:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7F944E06A7
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 14:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BACF2EDD52;
	Tue,  9 Sep 2025 14:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K15USek9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62A71F0E2E;
	Tue,  9 Sep 2025 14:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757428966; cv=none; b=eP8+2ZpeVYRJE0pW2HmlgzvtG4ROV4AnOx8yTh2zVuB4OCl/0b+mZ+GaT35yr8F1yiAq+/jwNPjGYi3TZe5ju3MUbebt7Wcib1quQiqs8fcJnWTQKI+UFLpSPY7MaqG8CCsvAqca25s/2UI78OgylyvaYkyjQVx9KH2i6qhJzk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757428966; c=relaxed/simple;
	bh=yswqqtHRFfmdynkmFeRMH6eFXkkhcbu28VuZarxyqig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNVd9A9WfgDfPRRyPnhNRXNhnRm/JqApWgJsbS+ltpDvMYC8lv9OndhC0ZcSOwEfFQyMQvU3xmY/jGX10ABw41TaNPvuzOyulPQwUu4/z+Vh62KS2dmNvOsHX+lpL/NytN7HbvNDz3LPYqwYW1o3TbzmDdgqNLQxCTZVZnbwiTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K15USek9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B9FC4CEF4;
	Tue,  9 Sep 2025 14:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757428965;
	bh=yswqqtHRFfmdynkmFeRMH6eFXkkhcbu28VuZarxyqig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K15USek9aU4bh3Rmt2buh0AJob5KQKmVZL8x8O1lsuXtPurGEfUpDs646xg3lR+Vu
	 kbJwMwRTnwysF0WqSij1djhctIIygYGnfNu/LftQV8+9FPFJc7cEGIARCi6ovr6uCA
	 hAWa/18TBnCrhpjsTq1FU7mlHFQcfkLchYzvMoH0=
Date: Tue, 9 Sep 2025 10:42:43 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jakub Kicinski <kuba@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	dan.j.williams@intel.com, Caleb Sander Mateos <csander@purestorage.com>, 
	io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <20250909-green-oriole-of-speed-85cd6d@lemur>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki>
 <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>

On Tue, Sep 09, 2025 at 08:35:18AM -0600, Jens Axboe wrote:
> >> On a global scale, that's quite a number of saved mailing list archive searches.
> > 
> > +1 FWIW. I also started slapping the links on all patches in a series,
> > even if we apply with a merge commit. I don't know of a good way with
> > git to "get to the first parent merge" so scanning the history to find
> > the link in the cover letter was annoying me :(
> 
> Like I've tried to argue, I find them useful too. But after this whole
> mess of a thread, I killed -l from my scripts. I do think it's a mistake
> and it seems like the only reason to remove them is that Linus expects
> to find something at the end of the link rainbow and is often
> disappointed, and that annoys him enough to rant about it.
> 
> I know some folks downstream of me on the io_uring side find them useful
> too, because they've asked me several times to please remember to ensure
> my own self-applied patches have the link as well. For those, I tend to
> pick or add them locally rather than use b4 for it, which is why they've
> never had links.
> 
> As far as I can tell, only two things have been established here:
> 
> 1) Linus hates the Link tags, except if they have extra information
> 2) Lots of other folks find them useful
> 
> and hence we're at a solid deadlock here.

I did suggest that provenance links use the patch.msgid.link subdomain. This
should clearly mark it as the source of the patch and not any other
discussion. I think this is a reasonable compromise that will only mildly
annoy Linus but let subsystems relying on these links continue to use them.

-K

