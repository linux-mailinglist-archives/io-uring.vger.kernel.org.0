Return-Path: <io-uring+bounces-9790-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1FB4B578EF
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 13:49:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 220C03AA043
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 11:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A33141D9346;
	Mon, 15 Sep 2025 11:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rT/cuUAy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C5B1397;
	Mon, 15 Sep 2025 11:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936919; cv=none; b=qIXZav9yCJCf4VUmUTWoOdBw0Z0ZRc3Plzl4LIR+q6z3nZd6BBlHd+Hgd7ZdbooPp5fuuhNZWsUiM++/c3JDxBmYHiN7Et9t/OXZsEr5ZNjmZf9kShFgIG+sF2xhjUmTj7ecVIShHD+1fTocWQ0iO7OWf3nJOQDfj7/toVUPrAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936919; c=relaxed/simple;
	bh=EFzV0A6vIaZngi/ZXutYPmUuHt4mEkkefaQljnOFnTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBA0y/hItVHpV88mAO2Rd+e0KKupo2J9FKrjLJkGvJdbMPzIo48dhyEknRcA0iuZdAIysqjqK+ZYLiMWpDrMEPOKS1YZp7xVgnV5bCQ+jqj59K+2XfY21v7zrudNEeMXRfRy3Q4mypFj6tWXHRwS30kMFbXvMgVFzVKpWF5j7ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rT/cuUAy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0006BC4CEF1;
	Mon, 15 Sep 2025 11:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936919;
	bh=EFzV0A6vIaZngi/ZXutYPmUuHt4mEkkefaQljnOFnTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rT/cuUAyl7sBs731pqIDPOYaTcziWqUpP1Z34dNuYpSDHEPgweUE8GwXxKPlkKDGz
	 2TVWgxeeqeM8eSxUQhj4aHip459M4enseiwhLgORVeMymtW5RcmglZmxn+WGdUSkQs
	 erXy1Yb5a+uzTKSxle4IPecFz7RO/nT7el5yd70TVbejdZzSEQM6MlUJ2nwahqjCYd
	 uPuo/kGysds0lAx97qA4/cQqbDBL6CWH7quiJKuiXAb+RTtRvUdDxH/imi7/cAok74
	 TugL755/fIJcto9c9kH6MVuPM4e+IuYre7dGJr01z5Pqrl1c6tEvgsdIfH5YtXAWKY
	 6TnAsVuJuEOWg==
Date: Mon, 15 Sep 2025 07:48:37 -0400
From: Sasha Levin <sashal@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	konstantin@linuxfoundation.org, axboe@kernel.dk,
	csander@purestorage.com, io-uring@vger.kernel.org,
	torvalds@linux-foundation.org, workflows@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Message-ID: <aMf9FaDxGY4nYI2f@laps>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <4764751.e9J7NaK4W3@workhorse>
 <aMLlMz_ujgditm4c@laps>
 <4278380.jE0xQCEvom@workhorse>
 <aMMpqojURAZa7cPU@laps>
 <6e25b2e7-67a2-4a92-95d5-adb279e811a7@sirena.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6e25b2e7-67a2-4a92-95d5-adb279e811a7@sirena.org.uk>

On Mon, Sep 15, 2025 at 12:26:41PM +0100, Mark Brown wrote:
>On Thu, Sep 11, 2025 at 03:57:30PM -0400, Sasha Levin wrote:
>
>> We've started[1] the workflows@ list (which is how I stumbled on this thread)
>> about 5-6 years ago when the concern from multiple maintainers was that we all
>> have our magical scripts, they are seriously ugly, and everyone are ashamed of
>> sharing them. So this list was an effort to get the ball rolling on folks
>> sharing some of those ugly workflows and scripts in an attempt to standardize
>> and improve our processes.
>
>> I've shared this very hacky b4-dig script as exactly that: I have a very ugly
>> bash script that addresses some of the issues Linus brought up around being
>> able to find more context for a given patch/mail.  I use that script often, it
>> helps me spend less time on browsing lore (no, dfn: won't find you syzbot
>> reports or CI failures), and it just "works for me".
>
>This seems like a great example of a situation where the suggestions
>from one of the other thread of asking people to clearly mark when patch
>submissions are using these tools would have helped - had the submission
>described the above then the Python level review would've gone a lot
>differently I think.  Realising during review is a totally different
>experience to being told up front.

Do you mean using the Assisted-by tags that were discussed in the other thread?

-- 
Thanks,
Sasha

