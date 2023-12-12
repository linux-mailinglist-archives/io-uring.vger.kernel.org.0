Return-Path: <io-uring+bounces-279-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2547880E1F4
	for <lists+io-uring@lfdr.de>; Tue, 12 Dec 2023 03:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CED821F21C18
	for <lists+io-uring@lfdr.de>; Tue, 12 Dec 2023 02:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02C964A;
	Tue, 12 Dec 2023 02:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pvZhoUu/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E760635;
	Tue, 12 Dec 2023 02:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9748DC433C8;
	Tue, 12 Dec 2023 02:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702348795;
	bh=jvOydkmuG+WGAV/nIotwSEo9P4ftz6ecbBENc5et68U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pvZhoUu/Y1EkfEFFvgaY9O+s0rBZfaIOWe59+aOk3I02wkHoPmFdJ6EDdhrJr2g+k
	 2aCKzZlw4fw0S4E4meAD3Npr7IxYH2v0dobC8h8M8ZExAggbmyAzfQ6baTlVx+iIJd
	 Cz/rnJ5fGp0y2o2ZO5Qx++yeaYAPTZxo9tmP5LGKRF1EVPONspJhDkPYRkKI3j08QR
	 4ozmZ6Pn62XckjaqtU1aUUUM/sEUQHtCgcQVrBXUdiufiCDalEMGCpV45u3tI1AxBT
	 I+za3U0s49hvv9HJCi2sFQdlGFmXgE2eECH2kFT9C75o+V2fj9rWAhiYkvfkQGbIBx
	 I6iucYRon6CqA==
Date: Mon, 11 Dec 2023 18:39:53 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: patchwork-bot+netdevbpf@kernel.org, io-uring@vger.kernel.org,
 axboe@kernel.dk, jannh@google.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND] io_uring/af_unix: disable sending io_uring over
 sockets
Message-ID: <20231211183953.58c80c5c@kernel.org>
In-Reply-To: <c60213c2-572f-47cb-ba7c-812de9a8519f@gmail.com>
References: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
	<170215742325.28655.3532464326317595709.git-patchwork-notify@kernel.org>
	<c60213c2-572f-47cb-ba7c-812de9a8519f@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 10 Dec 2023 01:18:00 +0000 Pavel Begunkov wrote:
> > Here is the summary with links:
> >    - [RESEND] io_uring/af_unix: disable sending io_uring over sockets
> >      https://git.kernel.org/netdev/net/c/69db702c8387  
> 
> It has already been taken by Jens into the io_uring tree, and a pr
> with it was merged by Linus. I think it should be dropped from
> the net tree?

Ugh, I think if I revert it now it can only hurt.
Git will figure out that the change is identical, and won't complain 
at the merge (unless we change it again on top, IIUC).

If I may, however, in the most polite way possible put forward 
the suggestion to send a notification to the list when patch is
applied, it helps avoid such confusion... I do hate most automated 
emails myself, but an "applied" notification is good.

