Return-Path: <io-uring+bounces-11315-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CDE0CE51E5
	for <lists+io-uring@lfdr.de>; Sun, 28 Dec 2025 16:35:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B79C3009F84
	for <lists+io-uring@lfdr.de>; Sun, 28 Dec 2025 15:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E545240855;
	Sun, 28 Dec 2025 15:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5LpUZfC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78892AE77;
	Sun, 28 Dec 2025 15:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766936121; cv=none; b=Uc2VsyIe6+xbwbv3Pj7NXlRJlTYhO6XLVl5bNrIQRj0Urcu3+rwfZGuGapCDynmsX41WBAc/fVcEznlKs9Z2nOjxS+OBPkX01xWiUGjdZeqrPkC39+KgldhXZsQmNOWJHgWTJX+RkCn7FARjYwN9irvgP3QUv9JtvxxASk2O/is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766936121; c=relaxed/simple;
	bh=J+DOjfHDpSUYmE+cqPtUVfa5kOnN9R4ejXVpwvZ9HK4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=qSByQhWCEXRBMFJZC0Xt+Q1J7UQVagCwWQLyvz+raCuOPMNEdIZs9TxDjdQCxfESDjzlt2AKdPbvg+Cp6pSe6SWttgP9ujXLBEjWEGsGQnWDydLxobTU0Xj4GjPmWCzu9sIqnsSBtmriDgcVbhFOZ9rz5Bj6nozYG0K8pAG+TZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E5LpUZfC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4835FC4CEFB;
	Sun, 28 Dec 2025 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766936121;
	bh=J+DOjfHDpSUYmE+cqPtUVfa5kOnN9R4ejXVpwvZ9HK4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=E5LpUZfCbusyoecN3Y87ivbaw99btZLNJnkl66ls0GzSbTWKQSm+bjyPqlE8fcvrE
	 z4I8sY7Tfc+kWPsSUpAeYPmjlki/aynfWFKD41zpyO+/4s7kEYknz58W4tiqGH9ZDC
	 1bnS37TM6rSzYjxAHJqtWZEhufKBqKl/KBVPYVV2d5+RdlArvEmliQTBvN1sVRKLyE
	 9RYRsPiuIj+KNtZzUp8dajNRXCDwu4z1wGcIX3vK/tXoygv58sh0HXu8VZXVVnOvQE
	 QQ0Ead3sR2zW2V5eT25jtVT35Kmx/dnu7RIRssrVXcHfBy1ukWWxomoViFDpfvFywq
	 JVWN9ZTMcVwtA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B58033AB0932;
	Sun, 28 Dec 2025 15:32:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] af_unix: don't post cmsg for SO_INQ unless explicitly
 asked for
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176693592455.2340895.15053745260316730629.git-patchwork-notify@kernel.org>
Date: Sun, 28 Dec 2025 15:32:04 +0000
References: <07adc0c2-2c3b-4d08-8af1-1c466a40b6a8@kernel.dk>
In-Reply-To: <07adc0c2-2c3b-4d08-8af1-1c466a40b6a8@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
 willemb@google.com, kuniyu@google.com, ju.orth@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 18 Dec 2025 15:21:28 -0700 you wrote:
> A previous commit added SO_INQ support for AF_UNIX (SOCK_STREAM), but it
> posts a SCM_INQ cmsg even if just msg->msg_get_inq is set. This is
> incorrect, as ->msg_get_inq is just the caller asking for the remainder
> to be passed back in msg->msg_inq, it has nothing to do with cmsg. The
> original commit states that this is done to make sockets
> io_uring-friendly", but it's actually incorrect as io_uring doesn't use
> cmsg headers internally at all, and it's actively wrong as this means
> that cmsg's are always posted if someone does recvmsg via io_uring.
> 
> [...]

Here is the summary with links:
  - [v2] af_unix: don't post cmsg for SO_INQ unless explicitly asked for
    https://git.kernel.org/netdev/net/c/4d1442979e4a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



