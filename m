Return-Path: <io-uring+bounces-9179-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3C5AB30144
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 19:40:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69761AC131B
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 17:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9422EA46C;
	Thu, 21 Aug 2025 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oHzm7hCF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6CE2E3391
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 17:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755798004; cv=none; b=JDwK86ElzM4gsZRwpE5H5Sc7NS1KIM+RJ1APOjZ7ne4ugl56VvbQiQWz7Rh3zUQQMbuwfluS67mbP2RuS36zXZd96mbD+YakgKEj0Hs/U4fPq35qw9mG6f9I59hyMHv0GSsUTxUUklzDG1Ox91zpcrfNFJPZTUQVqBakm9Z/caQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755798004; c=relaxed/simple;
	bh=dEHNyVP7eAZLgGWnsCl5FDUwQJjdInul7pcdpIqo6SM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ClGH/D35YSgRkluCvHqXgdKVCAkGGZGkTKmMPNdWjtYLtFlvX/5NOYkknx7PavPuKP9NAOm6Vq1BLhaDVmVytm3uLv51LmRxIEUtVB4N5RuxIzmfk84iWv80hLOwy5yQuucawkhwM4D6HrxCfevqJHTMMAiApWjtiFiB7Gqu0Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oHzm7hCF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B52C4CEEB;
	Thu, 21 Aug 2025 17:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755798003;
	bh=dEHNyVP7eAZLgGWnsCl5FDUwQJjdInul7pcdpIqo6SM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oHzm7hCFW7MEFESFHtrAD/WpMAVP350yZG//jbx6C3Yo1iF88BSuH5N/fNGUqIhTR
	 kc2iLm8tanrdYq/vGSmDpywyJVk5edfxmDSm3nUlj0PoS94BpHBWuzt9ZKdGhFfRN4
	 30/IK55BLjSs0hfFLsVHWxob9XGN5YhCesPw8UgQk3HpyC5BMJyvSUtowFKygv8Wre
	 E1JM0ev1EtUw9IfiZbp3Av7IHtPmn5F1eqvq4Q0v7nzi2q94REYjvL5CldzZ7TeuSg
	 eRZIYOVf563+Yfz+8Bh1CinWb7KeetHgxOJyCY91+Q4PY8H/dq5Al5+NQxrmJJbUmy
	 HGa1TXR7AxdRg==
Date: Thu, 21 Aug 2025 11:40:01 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>, io-uring@vger.kernel.org
Subject: Re: [PATCHSET v2 0/8] Add support for mixed sized CQEs
Message-ID: <aKdZ8TUE811CBrSn@kbusch-mbp>
References: <20250821141957.680570-1-axboe@kernel.dk>
 <CADUfDZragMLiHkkw0Y+HAeEWZX8vBpPpWjgwdai8SjCuiLw0gQ@mail.gmail.com>
 <6145c373-d764-480b-a887-57ad60f872e7@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6145c373-d764-480b-a887-57ad60f872e7@kernel.dk>

On Thu, Aug 21, 2025 at 11:12:28AM -0600, Jens Axboe wrote:
>
> For the SQE case, I think it's a bit different. At least the cases I
> know of, it's mostly 100% 64b SQEs or 128b SQEs. I'm certainly willing
> to be told otherwise! Because that is kind of the key question that
> needs answering before even thinking about doing that kind of work.

The main use case I can think of is if an application allocates one ring
for uring_cmd with the 128b SQEs, and then a separate ring for normal
file and network stuff. Mixed SQE's would allow that application to have
just one ring without being wasteful, but I'm just not sure if the
separate rings is undesirable enough to make the effort worth it.
 
> But yes, it could be supported, and Keith (kind of) signed himself up to
> do that. One oddity I see on that side is that while with CQE32 the
> kernel can manage the potential wrap-around gap, for SQEs that's
> obviously on the application to do. That could just be a NOP or
> something like that, but you do need something to fill/skip that space.
> I guess that could be as simple as having an opcode that is simply "skip
> me", so on the kernel side it'd be easy as it'd just drop it on the
> floor. You still need to app side to fill one, however, and then deal
> with "oops SQ ring is now full" too.

Yep, I think it's doable, and your implementation for mixed CQEs
provides a great reference. I trust we can get liburing using it
correctly, but would be afraid for anyone not using the library.

