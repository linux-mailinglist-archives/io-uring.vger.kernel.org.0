Return-Path: <io-uring+bounces-5422-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EDF09EBB93
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 22:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FB631881B73
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 21:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C0B422ACEB;
	Tue, 10 Dec 2024 21:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b="Bxhp7W/b";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="f7CjgoS1"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43AA153BF6
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 21:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733865031; cv=none; b=hxLrgDFuXE4DQ1y86pztdbRxl/h/ivvi56mW4V+85WQQPWqTJuXorbbq4A+oY4C1SAttiPyM1tmjrfnEqkdn6xldwmQtCH9wLyxsqaLEKj0UkKndGgIKLE1KNaL3HRtwW0qkU/OocgUg5aNZo7g1J75N6nrlvz3mK0oF3ja8XMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733865031; c=relaxed/simple;
	bh=+3jLMgZgbh8yot9KYgPMAi+HB6M2rWTRujHmRSL6if0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6KKZCkCNbj7ueboE8wf/UR64b5froI/d2tj/PU84IgS+V+8wkOpcL5+c7BT0nA5jzZ3yfUIroJlY+xKWrvjp19VfTCz4mNEDJ/G0WyTXSm71UIJ/ATqdq4SNV+xd+L33kTi+z86aFAc5aayxZOjBgoFi7crqJDpzNTgOsyXBbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org; spf=pass smtp.mailfrom=joshtriplett.org; dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b=Bxhp7W/b; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=f7CjgoS1; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joshtriplett.org
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 8B7E61384162;
	Tue, 10 Dec 2024 16:10:28 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 10 Dec 2024 16:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	joshtriplett.org; h=cc:cc:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1733865028;
	 x=1733951428; bh=D6yl6AKQQfo41prlpgrs/8Iwq8MM0I0neQRRXdBEsH4=; b=
	Bxhp7W/bTOyBv3qpuvtBmylPRvtpPDZowGkfCGUAXNs1v2I8ELnPOrvr/cbaWGds
	chA+coY5ORk4oiLnWiigQmqASUhHc9J23VpBlAIJdhlnheOmRiVhdl1djgYj0ZO+
	kse53pe7iSeOF6+N+A20lYOkrcCM5ayGiSelnLlKHKuad9eMciaJMuktL4FwlAVy
	kjM9ZLJYsfTCenzgUJ4Ei4s3XPzuuU1ZmiDWGGlEzTftHfzIcJitCHuAgPFHV017
	11fbH5Eoz0ywHlNIfb5pmFDDUTGn3c9DPRXZfmg1B6YndyS1ihLWpdC3Gvltu1v3
	0tEat7hwXwKClg8+5HmwBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1733865028; x=1733951428; bh=D6yl6AKQQfo41prlpgrs/8Iwq8MM0I0neQR
	RXdBEsH4=; b=f7CjgoS1yUlQVABwqfAber6yuMbT726RjqF8ixkfWZIeQO7iXW2
	GC0IdHP4LGaxEltzxwWYuCM2ddF3fobdVXRegyh20KwFT/MQYf0MI5UqIv+KIxeP
	GWlz2NTeX5ii+qX7WOp6wTP3/e62dDJHpBKl8SjOLgizNZOMD7l8cEei3FRW1+6D
	+yeBH4GLzlf66o1s9AvLbpLodAe3hmiBnumctm8aakMKl/iIW2UHRquNh1RG81EP
	hqq5qW+H1S31w1HjJGKXPAR9Kz55erajqPc/cLshXYDEchKZ934Cw0zqjeizQH8m
	YRM6jWA9PDGqmvOtu8qhfnKCNhGUB2EUy9A==
X-ME-Sender: <xms:RK5YZ52rqTjNBB70G2OriPKabrwteHlWA9XfZVau5dHD1yC-F419lg>
    <xme:RK5YZwE8HzOLZS_dnmyvgklWJ5HXjHKZkF0d2vV6qQbhpcVTmz5ZT8Vqjt-V0DZ39
    3XfchCriIX5qdeZZ4g>
X-ME-Received: <xmr:RK5YZ57KgfqUEc225aPlTntiGjeOgVsGK73JyUZptvIvw-EmuM8-EaXaMXW3Q3xMJptM7q1llrzz2O9byNAiElJ4T5aPWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrjeekgddugeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvden
    ucfhrhhomheplfhoshhhucfvrhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplh
    gvthhtrdhorhhgqeenucggtffrrghtthgvrhhnpeduieegheeijeeuvdetudefvedtjeef
    geeufefghfekgfelfeetteelvddtffetgfenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhg
    pdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehkrh
    hishhmrghnsehsuhhsvgdruggvpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgu
    khdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtph
    htthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:RK5YZ22l2FevXWB1jTOslJEYja_b33khxeZzFC2nWn1yJYKC6MPAhA>
    <xmx:RK5YZ8Ehnk7YXVndnlJsHDsm8ZWPQBOUKgvusSLsik6KTI-uVRYK3A>
    <xmx:RK5YZ39heohC-ABaePC-AkI2suWcQsD9EQvp9zpum44Jdg13hwtisw>
    <xmx:RK5YZ5kuZYXvbvmKI2DKirGDCBbsD2bu84ySki_xuBKns4GkNFczUQ>
    <xmx:RK5YZ4iXCiJHiN41KY7m-_EgOFMuA_g5KoqCtjeJTSWnSRgDejNk6-4j>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Dec 2024 16:10:27 -0500 (EST)
Date: Tue, 10 Dec 2024 13:10:26 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] Launching processes with io_uring
Message-ID: <Z1iuQmXYNxmaAA6f@localhost>
References: <20241209234316.4132786-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209234316.4132786-1-krisman@suse.de>

On Mon, Dec 09, 2024 at 06:43:02PM -0500, Gabriel Krisman Bertazi wrote:
> During LPC 2022, Josh Triplett proposed io_uring_spawn as a mechanism to
> fork and exec new processes through io_uring [1].  The goal, according
> to him, was to have a very efficient mechanism to quickly execute tasks,
> eliminating the multiple roundtrips to userspace required to fork,
> perform multiple $PATH lookup and finally execve.  In addition, he
> mentioned this would allow for a more simple implementation of
> preparatory tasks, such as file redirection configuration, and handling
> of stuff like posix_spawn_file_actions_t.
> 
> This RFC revives his original patchset.  I fixed all the pending issues
> I found with task submission, including the issue blocking the work at
> the time, a kernel corruption after a few spawns, converted the execve
> command into execveat* variant, cleaned up the code and surely
> introduced a few bugs of my own along the way.  At this point, I made it
> an RFC because I have a few outstanding questions about the design, in
> particular whether the CLONE context would be better implemented as a
> special io-wq case to avoid the exposure of io_issue_sqe and
> duplication of the dispatching logic.

Thank you for updating and debugging this! Much appreciated.

