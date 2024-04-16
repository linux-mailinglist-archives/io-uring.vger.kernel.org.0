Return-Path: <io-uring+bounces-1577-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D308A6F12
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 16:54:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 49B24B24C9B
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 14:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B30BC131733;
	Tue, 16 Apr 2024 14:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnshtU9S"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABC013172A;
	Tue, 16 Apr 2024 14:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713279006; cv=none; b=WAhEOwzAPsd96X1RcYqqYJSrzjxI6s/KkUKG5GNkZGLb7zTrEVLykJGZo5Ko4s0JdraEuvmEOqirAnTtUaFHw+i+ISr0SYFNWODKBjsjwOiOMurKVBNZN74uCrMZsoDj46lmkIrlO74a3dHewV0foRZdz+jm8DHuobc22vSMotg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713279006; c=relaxed/simple;
	bh=dHq2TQSuOJ7OrY8KhpXk6oNmx6FsOkorWYiOVPylDwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lm8OdE1FnoOU0UvAqHrR13DRXJF3dKSMVGHovQiT6M7x0jyNDCXFufL7ksRrIR+4uWqUuOuzY07eqKccUn2REDywudEsIzKcC0E3V//VN1KwQ1UTs2S9F3IBhR1SvqtsG78YM2AX5ytLXDuugbAsNzOtlFsNuR8KoXW4IjQYvoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnshtU9S; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC42C2BD10;
	Tue, 16 Apr 2024 14:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713279006;
	bh=dHq2TQSuOJ7OrY8KhpXk6oNmx6FsOkorWYiOVPylDwE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gnshtU9SaSwZzp/Mjfat+zy9zM353gx95DE1j9mRZPCC8rOwdxsPH7tkmBBkNa814
	 N681ZFdfC28NpfiWcWcEvPnyeyy819vWaqqU5foEFdpvE75L29CugisyMzv8P2SY9L
	 s9uAoxCk23kws2T+AjKjRT2sXxdpf+0iidPOntPVS2OdcYbZd5tNbEBrpIb3ozx4O2
	 42wOrQKnF2aDhew1aXDa78vjtZLoiUIfqz3VAq64/9dNJu5ozv8N55QCOtRXvXp7r3
	 GVT9N+29zdSGhJePeWzUdpcNS11kI/K/jwRPyzUAJ1WZtbQfILPG5lDJhwJERVve1D
	 hEv3d56+Sy3bg==
Message-ID: <502a2cfc-b4b1-4903-a6eb-3cbe2369047d@kernel.org>
Date: Tue, 16 Apr 2024 07:50:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/6] net: extend ubuf_info callback to ops structure
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <62a4e09968a9a0f73780876dc6fb0f784bee5fae.1712923998.git.asml.silence@gmail.com>
 <661c0d589f493_3e773229421@willemb.c.googlers.com.notmuch>
 <8b329b39-f601-436b-8a17-6873b6e73f91@gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <8b329b39-f601-436b-8a17-6873b6e73f91@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/14/24 6:07 PM, Pavel Begunkov wrote:
> On the bright side,
> with the patch I'll also ->sg_from_iter from msghdr into it, so it
> doesn't have to be in the generic path.

So, what's old is new again? That's where it started:

https://lore.kernel.org/netdev/20220628225204.GA27554@u2004-local/

