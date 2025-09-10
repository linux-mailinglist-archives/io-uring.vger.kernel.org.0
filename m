Return-Path: <io-uring+bounces-9698-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB9A0B50A45
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 03:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 533F37B8124
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 01:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B098919755B;
	Wed, 10 Sep 2025 01:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4wI8OdG"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DB72E403;
	Wed, 10 Sep 2025 01:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757467985; cv=none; b=HoZu3bz2L8IHmhHg4V80cesHFzzhH86jP9pLZe4rHXzstFLPpoEtUpuAzEcxUVtjdJ7GUc7MX0GjOwYW0LDAAhcvvGpIdG9nRDTwvxPdzJLNJnH/0W5Dhd9+zT2CuPAqftDIiZpM1iv+GuAykAIdQHNDXx+9bp26gm+sKWs5ymo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757467985; c=relaxed/simple;
	bh=baLUnX0AXCRDgPI3/TGamIRtNzlWQifunDhD/ve97zQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbdRQxyy19TJtOhzuiOCP4XilMFqAHHTG9kdioHd1OlzUCSW83mxbzFOFnTDLKQ9rRsfj7CJeNwuszQTpn9RgUPkUpr+IKi+NIt+zCUJ2iSDMmwI4w5Y5xFRYoVoZf5JEh/xnYSXOo0DPPDuFgCfhvPpAmj4IYOLYXA4b1ToDzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4wI8OdG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF82C4CEF4;
	Wed, 10 Sep 2025 01:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757467985;
	bh=baLUnX0AXCRDgPI3/TGamIRtNzlWQifunDhD/ve97zQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S4wI8OdG1BeoiHimCAH3TcunFuCJWGI0i7Smfb4Or4PhW/TWe8AU5T7hcVv1kZFmh
	 XqP3Z9WnlZuSuaL1wuF97YHIaYj+/Btjg12kQ3ShAAjXk5X3Ux3V2rBTwaB0YxD2wh
	 eHGim5098H8i0/RucAC4ih/QM+1haqzuzjy3u5Bs=
Date: Tue, 9 Sep 2025 21:33:02 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <20250909-fast-mastiff-of-agility-55c3a7@lemur>
References: <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
 <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz>
 <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
 <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
 <e09555bc-4b0f-4f3a-82a3-914f38c3cde5@suse.cz>
 <CAHk-=wgfWG+MHXoFG2guu2GAoSBrmcdXU2apj+MJpgdCXxwbwA@mail.gmail.com>
 <ad587c82-cc9c-43ef-89c5-d208734a4c7f@suse.cz>
 <22523fec-5745-40f9-8242-1c340bac843a@sirena.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <22523fec-5745-40f9-8242-1c340bac843a@sirena.org.uk>

On Tue, Sep 09, 2025 at 10:05:16PM +0100, Mark Brown wrote:
> > Fine, maybe b4 could help here by verifying if patch-id works on commits in
> > the maintainer's branch before sending a pr, and for those where it doesn't,
> > the maintainer can decide to add them. It sounds more useful to me than
> > adding anything "AI-powered" to it.
> 
> I think ideally if there's tooling for this it should have both a
> verification feature like you mention and also be supported by b4 mbox
> so that you can say "b4 mbox ${COMMIT}" or whatever and have it download
> a mailbox like can currently be done with a message ID.  That'd keep the
> usability we currently have, the tool could look in the message for a
> link and use that if it needs it.

Yeah, this is actually a neat idea -- I'll put that on the menu. We'll try
both --myers and --histogram when looking it up and then try a few other
tricks if we don't find anything (query by subject+author, etc).

I'll let you know when it's ready to test out.

-K

