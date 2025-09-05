Return-Path: <io-uring+bounces-9598-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 433F1B46092
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 19:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A5721C203C5
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 17:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD452741C3;
	Fri,  5 Sep 2025 17:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kYabEX+K"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBFE309EFA
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757094353; cv=none; b=rMdQk+7AbnJwsbFJN7eFhGDhD0w/ZE+SG9zlSyyMSNWEHcfxRPO6OE4zng3PFMIjqOUGSmSpJhHDBCExF4z8H91CKmoEI+qZp2NuTURVLcS4ePiLQbDDxS0ABSmtF50ghsK8pp+o68Nyx3VF6sUXFLRZwhcy1lnzCXd2HpMoLOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757094353; c=relaxed/simple;
	bh=yqW3FdRJC32oCkJ/oKS4lZ7+MZ71hnFD24XVoeXbGTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZBDCUr0GaJ5IS6/vEUmIwXm+KVtnpCGGsEsM2982pJCFElxooPBhdl0HLZ35KWa6mZ5VvdZ8vXzhes2/tsrc45MgGqeo5GPfzWObpmrNzY8jwMagbj4t4HczMM6Rt68MXRezfwAwtGfJ2WSOAoIyJCBSokj2aV/A8+hFVVJMBG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kYabEX+K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E43C4CEF1;
	Fri,  5 Sep 2025 17:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757094352;
	bh=yqW3FdRJC32oCkJ/oKS4lZ7+MZ71hnFD24XVoeXbGTc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kYabEX+KYsup7xkAfUrczW0rMktG8mxD0hc9YrHp+V/BtOGIeVfaBwl9IQp/7UDA5
	 zZZ51qbh9CviWqEN0V2Sun/VDlQc/Zw69CtE6cmSVS+y7Sq9ELONxvurfB5QUIc5Rv
	 f+E4nA9QARBkOkrKQXjJLKQkFtvOK3i7V9ac6EBg=
Date: Fri, 5 Sep 2025 13:45:48 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
Message-ID: <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>

On Fri, Sep 05, 2025 at 10:24:17AM -0700, Linus Torvalds wrote:
> Yes, I'm grumpy. I feel like my main job - really my only job - is to
> try to make sense of pull requests, and that's why I absolutely detest
> these things that are automatically added and only make my job harder.
> 
> I'm cc'ing Konstantin again, because this is a prime example of why
> that automation HURTS, and he was arguing in favor of that sh*t just
> last week.
> 
> Can we please stop this automated idiocy?

FWIW, Link: trailers are not added by default. The maintainer has to
deliberately add the -l switch.

Do you just want this to become a no-op, or will it be better if it's used
only with the patch.msgid.link domain namespace to clearly indicate that it's
just a provenance link?

-K

