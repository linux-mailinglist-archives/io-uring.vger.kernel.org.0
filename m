Return-Path: <io-uring+bounces-1610-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B0D48ADB11
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 02:27:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C6581C20CD1
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 00:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FFAF22EE4;
	Tue, 23 Apr 2024 00:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c7ugc2X7"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D509225DD;
	Tue, 23 Apr 2024 00:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713831629; cv=none; b=TJaTMYTEoRY1s8Fn2SJWFRAUzV190AgvElfpIOcixtm0aFqisSz6p8kCSAR59+DCttu75D7N9LOAmK9J43CnczxMc1RboER6gz85i6I4Sks08y1lsaI+N/lFEDoeZ3cZVlcPV0qOIJML2bNQebPM3B9jRp64LzuQGaY5S9p2+9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713831629; c=relaxed/simple;
	bh=nJGAdOsdxMFruesh3otRdPG+Ht1wDcOMr82PxGSWAnk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=XZZtgwPo60zwm4ZSdVQLl+GR8OaTg5rpz9hagGz43LwLRMNHrJXWIJABc9PCz1vBxmNre8YBl8y7V7MHseJo60fBDReOlhdKqMHFyfP2dHT2RAQBN9B8AWgqP+ZFx+CmlJdK42KDFLSMByQYf/JS2QPpe6dLoK5aaltbhq491zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c7ugc2X7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 358B3C3277B;
	Tue, 23 Apr 2024 00:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713831629;
	bh=nJGAdOsdxMFruesh3otRdPG+Ht1wDcOMr82PxGSWAnk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=c7ugc2X7dHeJldLg8Co0ipOSwNbiMfXWf0J9o75SttFerU4GC1FiHVRdYtcQ8evjw
	 +qGe6GDTZpCtf/FsduqDc3PKpO0kxKkaMYBJ4OIsXRs/g7B3tL+IgqE2aHmtovhFLV
	 Rcrd7NPSaT3vD3QUZZI/ELoiz/990yTcOENRoII51YNEgRP9H8LrOJvaiH+UEPqkCG
	 1PKan/7teo1eKV95we6CkgiGcj4SXGmq8/aaWwaB4jM5kZLUtNS4Wk6okxCJ20Qqa3
	 26OItwB2wYMdNq1b9efepdmGPDrj5SBBWMvwsa47h3BV0J22FFKOnEyiQaUiDBjs9I
	 0NIWxLTVIYCkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2132FC43440;
	Tue, 23 Apr 2024 00:20:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH io_uring-next/net-next v2 0/4] implement io_uring notification
 (ubuf_info) stacking
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171383162913.28674.10529865050261202154.git-patchwork-notify@kernel.org>
Date: Tue, 23 Apr 2024 00:20:29 +0000
References: <cover.1713369317.git.asml.silence@gmail.com>
In-Reply-To: <cover.1713369317.git.asml.silence@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, axboe@kernel.dk,
 davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
 edumazet@google.com, willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
 wei.liu@kernel.org, paul@xen.org, xen-devel@lists.xenproject.org,
 mst@redhat.com, virtualization@lists.linux.dev, kvm@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 19 Apr 2024 12:08:38 +0100 you wrote:
> Please, don't take directly, conflicts with io_uring.
> 
> To have per request buffer notifications each zerocopy io_uring send
> request allocates a new ubuf_info. However, as an skb can carry only
> one uarg, it may force the stack to create many small skbs hurting
> performance in many ways.
> 
> [...]

Here is the summary with links:
  - [io_uring-next/net-next,v2,1/4] net: extend ubuf_info callback to ops structure
    https://git.kernel.org/netdev/net-next/c/7ab4f16f9e24
  - [io_uring-next/net-next,v2,2/4] net: add callback for setting a ubuf_info to skb
    https://git.kernel.org/netdev/net-next/c/65bada80dec1
  - [io_uring-next/net-next,v2,3/4] io_uring/notif: simplify io_notif_flush()
    (no matching commit)
  - [io_uring-next/net-next,v2,4/4] io_uring/notif: implement notification stacking
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



