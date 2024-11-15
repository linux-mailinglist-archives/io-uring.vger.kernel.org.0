Return-Path: <io-uring+bounces-4749-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 755589CFAF4
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 00:14:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02F851F2298B
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 23:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9250F192D6B;
	Fri, 15 Nov 2024 23:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BwrObFAi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2D37346D;
	Fri, 15 Nov 2024 23:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731712470; cv=none; b=TBKjQtfA9nV7uN1WIs6Qeta6uxQKVuwIPh1gBZ5pT6DW3jp3pHk+qX5NszJCol9YU4M/PN8xqWKzfXoapjUlSD4qjXEvfdx2BjW5KQR3FC6neZdgusKx9T+lH9Sdd40gd37+/34N4FqcF3wXzR5P6Q5Z9Od0+wmapSq03trwNf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731712470; c=relaxed/simple;
	bh=J1PCIr/PU/DXaWzOtmgtsPvaZQwvafBBPKoR46EfPcg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=txEgYgRaL/ShfneDwvl5LGDkv8YQP7S8QONyDskOy/gGCq9dJ6mavDdkpv7D1IYKnXvXx/P1ZuBJPKbUTLvVtnXLX/Zn3K6JyniBUtVLx4Pt7klcMsMqFlrKohuFNGWPQTOO/C1FbitsGqevElaWA+xR0rxy/XNzh1+BKgiLUF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BwrObFAi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7363EC4CECF;
	Fri, 15 Nov 2024 23:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731712469;
	bh=J1PCIr/PU/DXaWzOtmgtsPvaZQwvafBBPKoR46EfPcg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BwrObFAieGavwTj03Tqnx2NrxNzFDbvP7p7kzo9PEG6foBBkkiDolALWhrPI8Pa+1
	 ji0004+YMYdq/VVxSZOvCbpi8/BShNdmIN7TFa/uv9ab7cE06utouqFxUhg+rhTBEL
	 q9uVIEoiX2Ti3q6BcsFe8kWoP0SrgcucfSfMGzoYliHF8MIw7OlGK+WrQw81Wdhqkx
	 SuR1YB/5cHX+9Z1S5PPaBRfK25mPeT4/ykwSMLpBEkbZljUUzm3ghuHeZCaJJB6Xe0
	 YWzWAT5q5YbNzHeSSDN6wmncbME88iR7ZfweDU1WkZRZBq/TyIsuGQhPnUBRcYZvmi
	 9fyu1JGKQ6ygA==
Date: Fri, 15 Nov 2024 15:14:28 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jesper Dangaard
 Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, Stanislav
 Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, Pedro
 Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH v7 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
Message-ID: <20241115151428.6f1e1aba@kernel.org>
In-Reply-To: <CAHS8izND0V4LbTYrk2bZNkSuDDvm2gejAB07f=JYtCBKvSXROQ@mail.gmail.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
	<20241029230521.2385749-12-dw@davidwei.uk>
	<CAHS8izNbNCAmecRDCL_rRjMU0Spnqo_BY5pyG1EhF2rZFx+y0A@mail.gmail.com>
	<af9a249a-1577-40fd-b1ba-be3737e86b18@gmail.com>
	<CAHS8izPEmbepTYsjjsxX_Dt-0Lz1HviuCyPM857-0q4GPdn4Rg@mail.gmail.com>
	<9ed60db4-234c-4565-93d6-4dac6b4e4e15@davidwei.uk>
	<CAHS8izND0V4LbTYrk2bZNkSuDDvm2gejAB07f=JYtCBKvSXROQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Nov 2024 12:56:14 -0800 Mina Almasry wrote:
> But I've been bringing this up a lot in the past (and offering
> alternatives that don't introduce this overloading) and I think this
> conversation has run its course. I'm unsure about this approach and
> this could use another pair of eyes. Jakub, sorry to bother you but
> you probably are the one that reviewed the whole net_iov stuff most
> closely. Any chance you would take a look and provide direction here?
> Maybe my concern is overblown...

Sorry I haven't read this code very closely (still!?) really hoping=20
for next version to come during the merge window when time is more
abundant :S

=46rom scanning the quoted context I gather you're asking about using=20
the elevated ->pp_ref_count for user-owned pages? If yes - I also
find that part.. borderline incorrect. The page pool stats will show
these pages as allocated which normally means held by the driver or=20
the stack. Pages given to the user should effectively leave the pool.
So I'm guessing this is some optimization. Same for patch 8.

But let me not get sucked into this before we wrap up the net-next PR..

