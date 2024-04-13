Return-Path: <io-uring+bounces-1535-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BEE68A3DEF
	for <lists+io-uring@lfdr.de>; Sat, 13 Apr 2024 19:17:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E70391F21677
	for <lists+io-uring@lfdr.de>; Sat, 13 Apr 2024 17:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04BC8481BA;
	Sat, 13 Apr 2024 17:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SARZIiPL"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F44446AC;
	Sat, 13 Apr 2024 17:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713028637; cv=none; b=RjOGicnV3+sLvakfOhLO83LRHqmG+/6oXm87JDDrCnyH3dRnKgCuTgPUFT1OotFrkyfakqnTkRwtA2unvUKfAOyvzwVfYmTySPb7SRVoeeOvf4I6qc3HpgWzhk36WSQkTjX6tIkm1ZP8PtQXFlv1glvQUHGEVhZfd8JD5KXffbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713028637; c=relaxed/simple;
	bh=x3rE4wBNy+tWRgVeSEAx+Gvkv7OIBsARgmY369a4gMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=onEWCAUNbGYIsWBoZMd1aZoZEGmrvUfPk5OCnu2oNYc01jHeejYbAFP59rwEgyJP0cVJxdDbFGH1P11aYYs0TWisbRGe2j0heEY2sSqWTDpdSpD+AACrvCLbU5lIP57uYQGKomGqA/PUBwgxpGf3bo2AmWG5bFi8YARp3QuHjnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SARZIiPL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8DCC113CE;
	Sat, 13 Apr 2024 17:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713028637;
	bh=x3rE4wBNy+tWRgVeSEAx+Gvkv7OIBsARgmY369a4gMM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SARZIiPL6uNSJHz+Rx/Zl83zr/D0WCfMysNwO2pIQXKa9U1s4ouEOPTF/QGVXxaMU
	 58ch8FTyQIbC7OEkIVeavKt8bU4RB7wtZTRek7j2a/18OZIqvkfG5Tl/5YQuNI2qeO
	 diam3XqdGIJSPl4p+WSGYcawmMMwFPSyRUBBpb8SKKJWLNF/9/VvdwJzv5vt12bSfm
	 QJEfTpDsjYiHBeV7V06MolhbxGUEwVtdD3B+TgnCsvJdBCDys4bucdSHatBeke8xe+
	 w09tbkfb7aeyX3ODlN+k6ot/zolNTId2nBS0AjVJmv66AFkbYmyxqa95Jkzbr6xnGs
	 Y6T3GnWvkF2uw==
Message-ID: <cdfee62d-32fe-4796-8265-d77f678c3d78@kernel.org>
Date: Sat, 13 Apr 2024 11:17:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/6] implement io_uring notification (ubuf_info) stacking
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <cover.1712923998.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/12/24 6:55 AM, Pavel Begunkov wrote:
> io_uring allocates a ubuf_info per zerocopy send request, it's convenient
> for the userspace but with how things are it means that every time the 
> TCP stack has to allocate a new skb instead of amending into a previous
> one. Unless sends are big enough, there will be lots of small skbs
> straining the stack and dipping performance.

The ubuf_info forces TCP segmentation at less than MTU boundaries which
kills performance with small message sizes as TCP is forced to send
small packets. This is an interesting solution to allow the byte stream
to flow yet maintain the segmentation boundaries for callbacks.

> 
> The patchset implements notification, i.e. an io_uring's ubuf_info
> extension, stacking. It tries to link ubuf_info's into a list, and
> the entire link will be put down together once all references are
> gone.
> 
> Testing with liburing/examples/send-zerocopy and another custom made
> tool, with 4K bytes per send it improves performance ~6 times and
> levels it with MSG_ZEROCOPY. Without the patchset it requires much
> larger sends to utilise all potential.
> 
> bytes  | before | after (Kqps)  
> 100    | 283    | 936
> 1200   | 195    | 1023
> 4000   | 193    | 1386
> 8000   | 154    | 1058
> 
> Pavel Begunkov (6):
>   net: extend ubuf_info callback to ops structure
>   net: add callback for setting a ubuf_info to skb
>   io_uring/notif: refactor io_tx_ubuf_complete()
>   io_uring/notif: remove ctx var from io_notif_tw_complete
>   io_uring/notif: simplify io_notif_flush()
>   io_uring/notif: implement notification stacking
> 
>  drivers/net/tap.c      |  2 +-
>  drivers/net/tun.c      |  2 +-
>  drivers/vhost/net.c    |  8 +++-
>  include/linux/skbuff.h | 21 ++++++----
>  io_uring/notif.c       | 91 +++++++++++++++++++++++++++++++++++-------
>  io_uring/notif.h       | 13 +++---
>  net/core/skbuff.c      | 37 +++++++++++------
>  7 files changed, 129 insertions(+), 45 deletions(-)
> 


