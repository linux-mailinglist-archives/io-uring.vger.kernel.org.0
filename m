Return-Path: <io-uring+bounces-9701-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E4C6B5149A
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 12:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C427548384D
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 10:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0260F3148D1;
	Wed, 10 Sep 2025 10:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TbdYXix5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA964313E3A;
	Wed, 10 Sep 2025 10:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757501757; cv=none; b=VSW2Ris1nUT8d6gOHlV/FVl2DSlhF9Q2k8XXKAe2FNLm9SWEyxyak00vTb2oMfJWbJYeFe7Cwf9uwAwADfJj/K/gzaYDRgL2Flya3/UuxPhatIp3UajyW5o0ThwRm+4x7mteRIp5OnQw70xgNOxHn/QbwIezgl2Z0bxCjMuHsJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757501757; c=relaxed/simple;
	bh=tsSBIpHdakcXHPvAGSyYjic7W9pbJfh7J6hCd32e9+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LVIzs9MU8QM4Wp6qJ3DtpuldH8ayVNQeInXp6WUcGgNEvCBw5PKwdGrqsiCzrw7pSicPjeqwvRJjsc33k8JTo/pPgBfvAYKAfjJ9G9iLXKDxpyQDqjqPqdUesDq2CihOWoXgA6VTPF/1/Of4bqmJE4xC8emJ67YimYm7pWHzj9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TbdYXix5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDD3C4CEF0;
	Wed, 10 Sep 2025 10:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757501757;
	bh=tsSBIpHdakcXHPvAGSyYjic7W9pbJfh7J6hCd32e9+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TbdYXix57MI3tx9jghRLDuTu80ifiu+dJLF21A2ga2ld969DD6rfoCiQ/WyE4YpkN
	 E2z+ZbO3eYtX6tu+uO2+u9FyKP2FI+3F2qw0X6fDbhYnSEM3BSyNbAcjC7EYGv98Wc
	 ygueXUPeXdVZBJxOlRzranrLf7xxWNEm/TqRxM2bIhA7IHIqgb3bza6EwMleObMHh/
	 /Djl5iahx/Xa1oUG82OTH3jhFhDcRA3g6HSi6K0WwRgd91ukpBx4jdXwXxCJAbbOmH
	 8aFceCWUt0fUyELidoBiYZM3si+UJIq8XDaK80cR/dFMzTKhtk9x/wsDQN+Snl6IBh
	 AIgyzYpnzqEHg==
Date: Wed, 10 Sep 2025 06:55:55 -0400
From: Sasha Levin <sashal@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jens Axboe <axboe@kernel.dk>, konstantin@linuxfoundation.org,
	csander@purestorage.com, io-uring@vger.kernel.org,
	torvalds@linux-foundation.org, workflows@vger.kernel.org
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Message-ID: <aMFZO6g2L5YCKR_O@laps>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <20250909163214.3241191-1-sashal@kernel.org>
 <20250909172258.GH18349@pendragon.ideasonboard.com>
 <72dd17ad-5467-49d3-9f40-054b1bf875d5@kernel.dk>
 <aMB3_VgB4mwp-bzP@laps>
 <20250910101342.GD20904@pendragon.ideasonboard.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250910101342.GD20904@pendragon.ideasonboard.com>

On Wed, Sep 10, 2025 at 01:13:42PM +0300, Laurent Pinchart wrote:
>On Tue, Sep 09, 2025 at 02:54:53PM -0400, Sasha Levin wrote:
>> On Tue, Sep 09, 2025 at 11:26:19AM -0600, Jens Axboe wrote:
>> > On 9/9/25 11:22 AM, Laurent Pinchart wrote:
>> >> On Tue, Sep 09, 2025 at 12:32:14PM -0400, Sasha Levin wrote:
>> >>> Add a new 'b4 dig' subcommand that uses AI agents to discover related
>> >>> emails for a given message ID. This helps developers find all relevant
>> >>> context around patches including previous versions, bug reports, reviews,
>> >>> and related discussions.
>> >>
>> >> That really sounds like "if all you have is a hammer, everything looks
>> >> like a nail". The community has been working for multiple years to
>> >> improve discovery of relationships between patches and commits, with
>> >> great tools such are lore, lei and b4, and usage of commit IDs, patch
>> >> IDs and message IDs to link everything together. Those provide exact
>> >> results in a deterministic way, and consume a fraction of power of what
>> >> this patch would do. It would be very sad if this would be the direction
>> >> we decide to take.
>> >
>> > Fully agree, this kind of lazy "oh just waste billions of cycles and
>> > punt to some AI" bs is just kind of giving up on proper infrastructure
>> > to support maintainers and developers.
>>
>> This feels like a false choice: why force a pick between b4-dig-like tooling
>> and improving our infra? They can work together. As tagging and workflows
>> improve, those gains will flow into the tools anyway.
>>
>> It's like saying we should skip -rc releases because they mean we've given up
>> on bug free code.
>
>I really have trouble thinking this is a honest argument. We're
>discussing the topic in the context of a project where we reject
>thousands of patches all the time when they don't go in the right
>direction.
>
>Throwing an LLM at the problem is not just a major waste of power, it
>also hurts as it will shift the focus away from improving the
>deterministic tools we've been working on. Using an LLM here only
>benefits the companies that make money from those proprietary tools.

Really? Elsewhere in this thread I've already pointed out that something like
this is very helpful because having to review hundreds of commits for
backport/CVE assignment using our current scheme of Link: just pointing to the
original submission and not any discussions is a major pain and a time waste.

Both Linus and Greg echoed the same concern. Heck, this thread started because
Linus complained about how much of a human time waste our current scheme is.

So when presented with a real problem and a tool that can help mitigate it,
you're still choosing to attack because it's LLM based and you have something
personal against that.

Sorry, I'm done with this argument. Use it if you like, don't use it if you
don't.

-- 
Thanks,
Sasha

