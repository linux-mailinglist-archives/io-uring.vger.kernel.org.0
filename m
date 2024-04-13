Return-Path: <io-uring+bounces-1536-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3AB88A3DF1
	for <lists+io-uring@lfdr.de>; Sat, 13 Apr 2024 19:17:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8BD88B20F9A
	for <lists+io-uring@lfdr.de>; Sat, 13 Apr 2024 17:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75BFF482D7;
	Sat, 13 Apr 2024 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekO2CgZ2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A51347A2;
	Sat, 13 Apr 2024 17:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713028656; cv=none; b=Z0+x/GeGCqAra5JRgkcP1mIFcAsU67Q4q8H4jIATTqxvSyuditbgfdCLp/GAi9m9meMewSmUkPPxD5qwd6yWOWtmBRA45tFvqbJ1ZM2Sc8Byz5zmDKOfxVhzDsXVniBBQyntEo9bPod9tYhhcQNSvpsmpOIldttin+yk5/pSkuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713028656; c=relaxed/simple;
	bh=CII9OqIqrFgpc64F3nIMi3xnrBOJPuIJefG9B6+yzGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T1Nj0kLcbpllr23QzhQnVCpJxVZkBZgGOlmyfzr8t+eBi6S+ShtlIn9sQwf9DmvCb72zCmpP4gAdfVPwlPQR2LS/PIzvVoboPbTolcTHJ3oynf4ljPbHxZ5Q4oOvwFNESPjQ7IYPjuZ4hF2kOK+0m4ttfORV9BJDN4zsbmpuGTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekO2CgZ2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF18C113CE;
	Sat, 13 Apr 2024 17:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713028655;
	bh=CII9OqIqrFgpc64F3nIMi3xnrBOJPuIJefG9B6+yzGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ekO2CgZ2OMNPYf5rtwXXCn3OimJEfZmrc1Cqasd59ZBmAxH7bKWD3rz0o82EpHxM9
	 ejc3WoqVCpgHWw/umQ1Vt6KQfJGX/Rk/HQox4R5WVyWG/cEvCF0lSQLJxQKXymgvx0
	 nor43eJizW4HbVw3otwtmu6KX7+xxmDqKLab8xZAFcycXnmrOKqfYLzG6eOB+GGMml
	 AufA10an5YpymEsxI7V+jebd1DMWc+Saw7d3esu/Jojxo6I3rPx0UVQZpHmrP8JWa2
	 D3PHXOYlX+UcA+J3jcumSS8Bls6GW1VHVrDT56Sx7PnN0xe2TKqR7PzZWfOKNzraki
	 En017dMh4SFiA==
Message-ID: <bc204a07-4ba0-4645-b531-4ebfb62302a1@kernel.org>
Date: Sat, 13 Apr 2024 11:17:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/6] net: extend ubuf_info callback to ops structure
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <62a4e09968a9a0f73780876dc6fb0f784bee5fae.1712923998.git.asml.silence@gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <62a4e09968a9a0f73780876dc6fb0f784bee5fae.1712923998.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/12/24 6:55 AM, Pavel Begunkov wrote:
> We'll need to associate additional callbacks with ubuf_info, introduce
> a structure holding ubuf_info callbacks. Apart from a more smarter
> io_uring notification management introduced in next patches, it can be
> used to generalise msg_zerocopy_put_abort() and also store
> ->sg_from_iter, which is currently passed in struct msghdr.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/net/tap.c      |  2 +-
>  drivers/net/tun.c      |  2 +-
>  drivers/vhost/net.c    |  8 ++++++--
>  include/linux/skbuff.h | 19 +++++++++++--------
>  io_uring/notif.c       |  8 ++++++--
>  net/core/skbuff.c      | 17 +++++++++++------
>  6 files changed, 36 insertions(+), 20 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



