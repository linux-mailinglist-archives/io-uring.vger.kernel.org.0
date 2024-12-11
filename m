Return-Path: <io-uring+bounces-5426-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B67149EC0A7
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 01:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BEDD164EC1
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 00:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 245F88489;
	Wed, 11 Dec 2024 00:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IYTNCngH"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5625672;
	Wed, 11 Dec 2024 00:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733876655; cv=none; b=lc7L1qwEKmjYY7KYeB1hvz0GXyA/v5jDSGzHxXqe2VqvpNfximdVbJIdlwsyvg5yaLDdpwndhZrSCsbUqxSjeY7Cv7frFU5jqqzwGQ8XceG6Na1c93SND2XoRZ10W9zwUnHnYZzmbv41VQC39Ftobz3oPA9o+3aHMD2j+oexZKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733876655; c=relaxed/simple;
	bh=RbOrXry18u7MTCeRA/ZHJ8KYwndASIayO+JAAnydo6k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BsB1HiweBNOumw6LGsr9uydCt3BBLvIId9sOOJWHVM1PVBX+hyi39Eu8j/Zume+PoH2Vhkjxf40zw9aVd1qxmWdmopDoY+qMq2qKzhScz4mI/46YTu59KETymocf0E+RxsMBRU2u+XXFIzHLM5gdIspIc31sx0U+uP0LUBe2GSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IYTNCngH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FE6C4CEDE;
	Wed, 11 Dec 2024 00:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733876654;
	bh=RbOrXry18u7MTCeRA/ZHJ8KYwndASIayO+JAAnydo6k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IYTNCngHaoNSPe+ai6ExtR4jlNKw8bc6azWE/ldlPH/7vP01bCbdpr7Tgn7/QD100
	 5UGGpsvV6WvISQTHYPMrZn3S4kZ3VdO0866lFNWnLZiDasZn8YQwiws4bi00/T9JSY
	 ppAI65WUHMR0KnHzsJGzd5joWFSFmow3aABUISd/eyB9GZEguSJQA2hUmv285WiYJo
	 +sqd3Hmv0Pe9ia/JzjvOVuivtdQvgJ1NQdWcfzCigVV4wYEln1k6lysrWK0duhBNEI
	 B8cowDNvW7L2JWOz6ANhgaVok1y0pLI671z8K6IZ3/PsQ16yzoSV/yyrGmucg22MBa
	 /+SESyQ1RR1Ug==
Date: Tue, 10 Dec 2024 16:24:12 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 11/17] io_uring/zcrx: implement zerocopy
 receive pp memory provider
Message-ID: <20241210162412.6f04a505@kernel.org>
In-Reply-To: <aa20a0fd-75fb-4859-bd0e-74d0098daae8@gmail.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
	<20241204172204.4180482-12-dw@davidwei.uk>
	<20241209200156.3aaa5e24@kernel.org>
	<aa20a0fd-75fb-4859-bd0e-74d0098daae8@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Dec 2024 04:45:23 +0000 Pavel Begunkov wrote:
> > Can you say more about the IO_ZC_RX_UREF bias? net_iov is not the page
> > struct, we can add more fields. In fact we have 8B of padding in it
> > that can be allocated without growing the struct. So why play with  
> 
> I guess we can, though it's growing it for everyone not just
> io_uring considering how indexing works, i.e. no embedding into
> a larger struct.

Right but we literally have 8B of "padding". We only need 32b counter
here, so there will still be 4B of unused space. Not to mention that
net_iov is not cacheline aligned today. Space is not a concern.

> > biases? You can add a 32b atomic counter for how many refs have been
> > handed out to the user.  
> 
> This set does it in a stupid way, but the bias allows to coalesce
> operations with it into a single atomic. Regardless, it can be
> placed separately, though we still need a good way to optimise
> counting. Take a look at my reply with questions in the v7 thread,
> I outlined what can work quite well in terms of performance but
> needs a clear api for that from net/

I was thinking along the lines of transferring the ownership of
the frags. But let's work on that as a follow up. Atomic add on 
an exclusively owned cacheline is 2 cycles on AMD if I'm looking
correctly.

