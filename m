Return-Path: <io-uring+bounces-4915-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 395919D4AB9
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 11:22:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3D8D284460
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 10:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FF01CFEA7;
	Thu, 21 Nov 2024 10:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WqOtcATb"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB2A1CB322;
	Thu, 21 Nov 2024 10:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732184355; cv=none; b=qIlWwEP2jpRnfX6F4Iirk3LsCgPszsxQwvE3FbFhGJYHCFctGBv/uPwG94eiwYv6l/sCmA576zx5u3AYhNFvNjueBtGbu7xi+4ee30BUgCtl7gHGzSiiJBOLwf8qyEX9JuwcmVSYue23M5cYoxparRtL2JeGRzl8TM3X0UcI3vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732184355; c=relaxed/simple;
	bh=vdU01yydMwwx3sSdNOgVdvAm97pz89kQ5OB0TAdlmVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ifN0dU2FuQpCAIHpkAFC8tkbUK//HBI0aO2oUwUrPq+l1Rtm0jYOg+jld6N+aHQWety9kdVo2Irf2HWygwji0y++wHFTci0NGp9gCjoZ+dvAN+6riFqZifZRtfst5yX4iPPel3x5VQcTRcoURjx7jgl24WiUTpB7CwtSGnDSjMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WqOtcATb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7484C4CECC;
	Thu, 21 Nov 2024 10:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732184355;
	bh=vdU01yydMwwx3sSdNOgVdvAm97pz89kQ5OB0TAdlmVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WqOtcATb1VkKmyUI/NcRWkuA09JLY/gsuhqTD+gzFS/qKpmoOPMzMk0ePxX4ocACb
	 4EB2TRDNyFEsdXY/NDfvGyD/DDcn+EWCl0wSIVE237WWygYuKiQmzyjvaAdawtPcnW
	 GIXmpkzJ/DAw+y1awNeD3VlflRD6cofwoz7W1h1+UyRUcTCG8lU0j7Tle69F7M/9f0
	 6BprUazlD8s8yrLdQo3ENUYufgH+duQqZkYYO+/J1Md3k5fPj0JJTU42PR2X4Bt23u
	 M0pR0eGQLP+bRB/bTXbueKJPYPptDJ1eT1a9lN0cWG8VG8GFCFIGs1UNwyZYIYYF1Q
	 wFsfNy8pTVlhw==
Date: Thu, 21 Nov 2024 11:19:07 +0100
From: Christian Brauner <brauner@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Mike@rox.of.borg, 
	Rapoport@rox.of.borg, Guenter Roeck <linux@roeck-us.net>, 
	Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	io-uring@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
Message-ID: <20241121-zwietracht-klugheit-4acf0bb07f2b@brauner>
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>

On Wed, Nov 20, 2024 at 01:46:21PM +0100, Geert Uytterhoeven wrote:
> On m68k, where the minimum alignment of unsigned long is 2 bytes:
> 
>     Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
>     CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-atari-03776-g7eaa1f99261a #1783
>     Stack from 0102fe5c:
> 	    0102fe5c 00514a2b 00514a2b ffffff00 00000001 0051f5ed 00425e78 00514a2b
> 	    0041eb74 ffffffea 00000310 0051f5ed ffffffea ffffffea 00601f60 00000044
> 	    0102ff20 000e7a68 0051ab8e 004383b8 0051f5ed ffffffea 000000b8 00000007
> 	    01020c00 00000000 000e77f0 0041e5f0 005f67c0 0051f5ed 000000b6 0102fef4
> 	    00000310 0102fef4 00000000 00000016 005f676c 0060a34c 00000010 00000004
> 	    00000038 0000009a 01000000 000000b8 005f668e 0102e000 00001372 0102ff88
>     Call Trace: [<00425e78>] dump_stack+0xc/0x10
>      [<0041eb74>] panic+0xd8/0x26c
>      [<000e7a68>] __kmem_cache_create_args+0x278/0x2e8
>      [<000e77f0>] __kmem_cache_create_args+0x0/0x2e8
>      [<0041e5f0>] memset+0x0/0x8c
>      [<005f67c0>] io_uring_init+0x54/0xd2
> 
> The minimal alignment of an integral type may differ from its size,
> hence is not safe to assume that an arbitrary freeptr_t (which is
> basically an unsigned long) is always aligned to 4 or 8 bytes.
> 
> As nothing seems to require the additional alignment, it is safe to fix
> this by relaxing the check to the actual minimum alignment of freeptr_t.
> 
> Fixes: aaa736b186239b7d ("io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache")
> Fixes: d345bd2e9834e2da ("mm: add kmem_cache_create_rcu()")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>

