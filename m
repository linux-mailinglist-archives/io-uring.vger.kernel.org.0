Return-Path: <io-uring+bounces-6495-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F00A3904E
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 02:22:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EF3618952F9
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 01:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B5613AD05;
	Tue, 18 Feb 2025 01:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YI8v6LbE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DEC535D8;
	Tue, 18 Feb 2025 01:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739841621; cv=none; b=DV/wpv7OobPVY944MqODoFbE8b5pdfDASJ9zT6Vi8+U+XH/IWuGt3KQ324jmQab/7FqO8Dk3TDKkMfbIZ515jznzCNVzoQjTzWKgh80+cml3TZA3D80aYK9+XxZhWQ9AUt+TunS7X9UGQR8pjkC4aHTpKpWWfHESEXz+ioYhp04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739841621; c=relaxed/simple;
	bh=8i5EzvgnuwmAcqM63aUDdHmNwVXXBuRgmWGHPilRF9U=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=A8LHPbeLyg7lknDlCK8AqCBaNrEKqzsJ7ktp3BPmoFJTZ9CVwNe+ytNBHq+MH1AkDoBs7iFvmk0a58YhPq1VRKXdKbn42EluhSmNt/Kp6uftiqkWVnSn9jaPF9X255AnQYjzdG9CpspMmEeIcbDidluI3wajXc46TOxb2Z6+vQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YI8v6LbE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3120C4CED1;
	Tue, 18 Feb 2025 01:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739841619;
	bh=8i5EzvgnuwmAcqM63aUDdHmNwVXXBuRgmWGHPilRF9U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=YI8v6LbEt33RLv1NqMaX63UvO4n/5ObtU7uXWYJzgXA69ub7rITOB1lWJ0zSZK1g3
	 6oUDMCTZpoyWV3eQ1245CgZeod/fM1Fie7kVF8kVlssVly1rRKmyjKgLjW5K4hzizp
	 USSJ+PIUxorkQGN8qZwCdPBbyUYcb/oYRyGTSPT1yPFgGaMye93/WdAO6HtAX9cDwB
	 6u517jCj0slLG4aePEgcHaHbJf0Xqf0XkGQR9pMdtrDwSPq/IyBY6T/LQWPDyBfUxk
	 gSvnerONFss+3fGUrg+7ipYnkBLTS9cxyOFOCyJ8H1ZdqAAZiLqKCLTunpcBLIJjw0
	 +5xSvGZdi3OVw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33E53380AAD5;
	Tue, 18 Feb 2025 01:20:51 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: use napi_id_valid helper
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173984164983.3591662.13758871479871036513.git-patchwork-notify@kernel.org>
Date: Tue, 18 Feb 2025 01:20:49 +0000
References: <20250214181801.931-1-sjordhani@gmail.com>
In-Reply-To: <20250214181801.931-1-sjordhani@gmail.com>
To: Stefano Jordhani <sjordhani@gmail.com>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, jdamato@fastly.com,
 axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, horms@kernel.org,
 asml.silence@gmail.com, kuniyu@amazon.com, willemb@google.com,
 bjorn@kernel.org, magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 jonathan.lemon@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 hawk@kernel.org, john.fastabend@gmail.com, bigeasy@linutronix.de,
 aleksander.lobakin@intel.com, xuanzhuo@linux.alibaba.com,
 almasrymina@google.com, dw@davidwei.uk, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 14 Feb 2025 18:17:51 +0000 you wrote:
> In commit 6597e8d35851 ("netdev-genl: Elide napi_id when not present"),
> napi_id_valid function was added. Use the helper to refactor open-coded
> checks in the source.
> 
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Stefano Jordhani <sjordhani@gmail.com>
> Reviewed-by: Joe Damato <jdamato@fastly.com>
> Reviewed-by: Jens Axboe <axboe@kernel.dk> # for iouring
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: use napi_id_valid helper
    https://git.kernel.org/netdev/net-next/c/b9d752105e5f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



