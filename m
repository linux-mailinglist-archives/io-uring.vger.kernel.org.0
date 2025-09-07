Return-Path: <io-uring+bounces-9630-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82935B48097
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 00:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F25117F774
	for <lists+io-uring@lfdr.de>; Sun,  7 Sep 2025 22:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6606486348;
	Sun,  7 Sep 2025 22:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="jL2vQz6j"
X-Original-To: io-uring@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44A212B73
	for <io-uring@vger.kernel.org>; Sun,  7 Sep 2025 22:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757282652; cv=none; b=fRE8u1nC3paJhTL17M6nFz2teKwgcNuurNyZWinKWFYCLVllrYbENVFa4cddueyiP29kKuI1BnPIfy7vdZn7DSJtW00GMGDjzNFZ+Q48+CmwkJnAIS9Eejf4C+APoJJepjQna5ePoVhEaXwo5Z51p/tl/TQAWJM5LyC8O1hemGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757282652; c=relaxed/simple;
	bh=MuvNavY7rqb26WNG55L9Yfqn0nKcVjYYA9VZhE65y2I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kI8Vngf2sRrkOsDLuTS/kNtU8HGEAjKRZgjT78eO17g9VK6I97FtSekeb/olRRZkubI4+PwHqsu1uXeataDtu8R8+b9GYtjAQZebAIqE2o0maZCtypALAsUv6XYmp1D6HV2bGRFg0njkkVSs5pQyxhcxeK6K74xg8+PPWc/FQvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=jL2vQz6j; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 652AA40AE2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1757282649; bh=629pRZZlUS4PjmwA4SGvzJAuJYTTNjZObLmPT1vhkio=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jL2vQz6jjR7PH2V/1rZup6Ly3jzCYGkFQqi8ESKVLWxTqthku4MrZImgMvz2wiSSI
	 7kRikpJnqlp+oMYPABDAVirc98xmcuUN7pZXQ2D5VrnvQ4EW68/Dur5jXnBCW3JHzg
	 uVURQ5+OhNqUGtKGWQ9inM3AAmZr6c+Ss9PRN6GD7eaYhb3C95bXXc9py6Fm5iZdLZ
	 BwhxMNgVHe1jVULFrLijxMQQGm1qZUqOSRa/cvYfEqpy2YhaNCEfqEG2/u7Qlo53pu
	 Fv0JXz6y+ZudKnS5T5iujq4nClI0J7xSGMkK44sDiHvNikRA9QBsjDTbS7AKP91HAd
	 ik2fWOik202Lw==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 652AA40AE2;
	Sun,  7 Sep 2025 22:04:09 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>, Linus Torvalds
 <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Caleb Sander Mateos
 <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
In-Reply-To: <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
Date: Sun, 07 Sep 2025 16:04:08 -0600
Message-ID: <87a535zzqf.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Konstantin Ryabitsev <konstantin@linuxfoundation.org> writes:

> On Fri, Sep 05, 2025 at 10:24:17AM -0700, Linus Torvalds wrote:
>> Yes, I'm grumpy. I feel like my main job - really my only job - is to
>> try to make sense of pull requests, and that's why I absolutely detest
>> these things that are automatically added and only make my job harder.
>> 
>> I'm cc'ing Konstantin again, because this is a prime example of why
>> that automation HURTS, and he was arguing in favor of that sh*t just
>> last week.
>> 
>> Can we please stop this automated idiocy?
>
> FWIW, Link: trailers are not added by default. The maintainer has to
> deliberately add the -l switch.

It's worth noting that our documentation suggests adding a Git hook to
add Link: tags automatically: Documentation/maintainer/configure-git.rst. 
I suspect a lot of people add such hooks years ago when it was all the
rage and have long since forgotten about them...  Not that I would be
such a person, of course.

It seems we should remove the recommendation?

jon

