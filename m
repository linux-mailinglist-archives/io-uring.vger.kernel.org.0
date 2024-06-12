Return-Path: <io-uring+bounces-2192-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D137290578E
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 17:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AC7F28C291
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 15:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3733D181B82;
	Wed, 12 Jun 2024 15:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYWVzenO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8729181312;
	Wed, 12 Jun 2024 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718207758; cv=none; b=TqXTeEeTAyXVbweCTjoWfBrrGZJUwDrCPyIDjVgVE3FZ26jyM9Z3RPxx6/LeAjEp3TsP95CT+n6UP0CUMsRsB8M3+YQyKDh1oR2OoF1wnWNVpe8KaS7+09BcaDD6vEo2GpIVOIzC3TiLZ1xqA9gNc9zEuyE5KGmvuf/A4EuNMZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718207758; c=relaxed/simple;
	bh=OGohKvk0MjWf9+Q8+mvrBX+1BAlKKRyUXLbfH75xyb4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=aVOTTwsJpcctQuUjdTM8dhm19LLOc1Dt6AuwIhKCXrejUHcYcJPE5H4DC9Fzyw6QCAdYqEK0nP0ui81Knrinl0W7LiaUbPTrmLHR1XPSyo1uTsFW2/6YtmNxiP9jkihUCMxy7nnZMPsyNeMQ5f1h0fnSNwiH7kbWlovFqnKdm34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYWVzenO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AEC7C4DDE4;
	Wed, 12 Jun 2024 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718207757;
	bh=OGohKvk0MjWf9+Q8+mvrBX+1BAlKKRyUXLbfH75xyb4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kYWVzenO6v46dav7m+6VeeBQvWtkfZ2ijSROLzZNF2xhVox8NT4g6D7nEQ7Yr1CvD
	 QbMqbzoNwKvtHxN4oOUSJGsdzFSOiqxLCA02gKqMCQ7TCsZzzusBONx5M/RWdCVpV3
	 EiLccKqgRHfAnZUsG10WiKCsIr5ffuOoIqg1qhcsU6IhDG8FGsX5pkowWNVMy10FlC
	 cn2EJB/8N7UtSBq02dCqRuSQs3PZ1MDiLAg7XtxdpzyjShLg11I47hWenlonizyvmL
	 MeVPPNyid+I2VhiIZBpPj5WbK56sRWz78MH6UY8PKtaaCMSFrdgOOixPo+5vEX+bSG
	 8/iqEXeUVgsUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61107C43618;
	Wed, 12 Jun 2024 15:55:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH] tracing/treewide: Remove second parameter of
 __assign_str()
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <171820775738.32393.13116890369510221266.git-patchwork-notify@kernel.org>
Date: Wed, 12 Jun 2024 15:55:57 +0000
References: <20240516133454.681ba6a0@rorschach.local.home>
In-Reply-To: <20240516133454.681ba6a0@rorschach.local.home>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ath10k@lists.infradead.org,
 Julia.Lawall@inria.fr, linux-s390@vger.kernel.org, dev@openvswitch.org,
 linux-cifs@vger.kernel.org, linux-bcachefs@vger.kernel.org,
 linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 io-uring@vger.kernel.org, torvalds@linux-foundation.org,
 iommu@lists.linux.dev, ath11k@lists.infradead.org,
 linux-media@vger.kernel.org, linux-wpan@vger.kernel.org,
 linux-pm@vger.kernel.org, selinux@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-erofs@lists.ozlabs.org, virtualization@lists.linux.dev,
 linux-sound@vger.kernel.org, linux-block@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, mathieu.desnoyers@efficios.com,
 linux-cxl@vger.kernel.org, linux-tegra@vger.kernel.org,
 intel-xe@lists.freedesktop.org, linux-edac@vger.kernel.org,
 linux-hwmon@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 ath12k@lists.infradead.org, tipc-discussion@lists.sourceforge.net,
 mhiramat@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
 freedreno@lists.freedesktop.org, linux-nfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org

Hello:

This patch was applied to jaegeuk/f2fs.git (dev)
by Steven Rostedt (Google) <rostedt@goodmis.org>:

On Thu, 16 May 2024 13:34:54 -0400 you wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> [
>    This is a treewide change. I will likely re-create this patch again in
>    the second week of the merge window of v6.10 and submit it then. Hoping
>    to keep the conflicts that it will cause to a minimum.
> ]
> 
> [...]

Here is the summary with links:
  - [f2fs-dev] tracing/treewide: Remove second parameter of __assign_str()
    https://git.kernel.org/jaegeuk/f2fs/c/2c92ca849fcc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



