Return-Path: <io-uring+bounces-1918-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A3E28C8BBF
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 19:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15885284D2C
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 17:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA44913E419;
	Fri, 17 May 2024 17:48:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8F113E40B;
	Fri, 17 May 2024 17:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715968094; cv=none; b=lFnKrgookhOgcn8vA4fQ/6Swm8jZydG2RzUdYhAqQcUnHKNOflsCQ3CJxyAEs2JU11qHOM+zxRO0bGVwUhWuAFepAzvB+hgmGsS2pMca59lL1RJL9zUG27FYOYdnwn+YidGMftMaO7Yz1pDdQ0jVSCFXSqFpR1JUNf09y1MhEj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715968094; c=relaxed/simple;
	bh=gAAJJFKRq7ZuXBKuhjvNoKHrIa1D3KibBfY1qYrv3Ys=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YaX6YbjwexKJK35JXhMSWL4SGWOba3YpVqmK90Aprk9dIxmcCy2FA0yhv11mnkhbqAKT0UaGg9FSteQIA6eVq8tHil5EHi2L5fTYnXKlWTjEmqG5rLjnSR3h8R2uTiDVYJB/U1YRBVK2UV4mVh+OGo9EyCAeuc7V75VKBeP6XcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424EAC2BD10;
	Fri, 17 May 2024 17:48:06 +0000 (UTC)
Date: Fri, 17 May 2024 13:48:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux trace kernel
 <linux-trace-kernel@vger.kernel.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-block@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 amd-gfx@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, virtualization@lists.linux.dev,
 linux-rdma@vger.kernel.org, linux-pm@vger.kernel.org,
 iommu@lists.linux.dev, linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
 linux-hyperv@vger.kernel.org, ath10k@lists.infradead.org,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 ath12k@lists.infradead.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-usb@vger.kernel.org,
 linux-bcachefs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-edac@vger.kernel.org,
 selinux@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-hwmon@vger.kernel.org, io-uring@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-wpan@vger.kernel.org, dev@openvswitch.org,
 linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net, Julia
 Lawall <Julia.Lawall@inria.fr>
Subject: Re: [PATCH] tracing/treewide: Remove second parameter of
 __assign_str()
Message-ID: <20240517134834.43e726dd@gandalf.local.home>
In-Reply-To: <5080f4c5-e0b3-4c2e-9732-f673d7e6ca66@roeck-us.net>
References: <20240516133454.681ba6a0@rorschach.local.home>
	<5080f4c5-e0b3-4c2e-9732-f673d7e6ca66@roeck-us.net>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 May 2024 10:36:37 -0700
Guenter Roeck <linux@roeck-us.net> wrote:

> Building csky:allmodconfig (and others) ... failed
> --------------
> Error log:
> In file included from include/trace/trace_events.h:419,
>                  from include/trace/define_trace.h:102,
>                  from drivers/cxl/core/trace.h:737,
>                  from drivers/cxl/core/trace.c:8:
> drivers/cxl/core/./trace.h:383:1: error: macro "__assign_str" passed 2 arguments, but takes just 1
> 
> This is with the patch applied on top of v6.9-8410-gff2632d7d08e.
> So far that seems to be the only build failure.
> Introduced with commit 6aec00139d3a8 ("cxl/core: Add region info to
> cxl_general_media and cxl_dram events"). Guess we'll see more of those
> towards the end of the commit window.

Looks like I made this patch just before this commit was pulled into
Linus's tree.

Which is why I'll apply and rerun the above again probably on Tuesday of
next week against Linus's latest.

This patch made it through both an allyesconfig and an allmodconfig, but on
the commit I had applied it to, which was:

  1b294a1f3561 ("Merge tag 'net-next-6.10' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next")

I'll be compiling those two builds after I update it then.

-- Steve

