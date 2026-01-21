Return-Path: <io-uring+bounces-11857-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oJBQOEw4cGmWXAAAu9opvQ
	(envelope-from <io-uring+bounces-11857-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 03:22:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A06DD4FAF5
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 03:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 13223B8207E
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 02:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BFD833C53A;
	Wed, 21 Jan 2026 02:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M3jssdC3"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA20331A52;
	Wed, 21 Jan 2026 02:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768962021; cv=none; b=dmEYJGhrAifqovWi8Zgxz+accf6ufoaVWFBDuELEa01ux/LlTUUvJ+0a6zs8iD18kkmDcY/pA2fJyKYbayMiKbf8x7VDGdE2XyjGGUsBVdTIc10XY65aTpbwYw0etcfzXaTyoFt1rBvzxB+5lsO4/PFa81gdnQdwyP3cWWt+XM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768962021; c=relaxed/simple;
	bh=u5UM1f2N1exM9SUsP/57HOH1ZH5KhYC3HtwPUwd286I=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Pj8l9AU6mW+AIa26yRAVAkuZF7a+Ye27AWL83ZkVX5N8prjtZU7W8hEUM47VZ1bmson3lC7vmpkz5pS8Ng0pMxHLkFOqf3ODr7He0pThg5gNWuHCG1u6uiS716ernMeOuEk0j/PP/iMMhIgBM+62e7IAoaBqsz5dTJb4kJMCfms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M3jssdC3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD4DC16AAE;
	Wed, 21 Jan 2026 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768962021;
	bh=u5UM1f2N1exM9SUsP/57HOH1ZH5KhYC3HtwPUwd286I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=M3jssdC3slzXQ+UDR/4TeC/7OtXb4ppyZ2a8SdcUQ/PYKmNGKdVxjS65ltqiwRchn
	 LajGVq9t+H2IeSCPBYgobRWUtngg530H0RbC0UlwQ6sUkRUm5ZDHAaFJx4hK/m98lf
	 VkXwW6U0Iq9jv1xZ8E9Cguk9LONBsdVF4F+E6M5zewa+A0dGdlET2+9fuVFVciUFIR
	 k9s0x33CZgFDLCSR9SVmwp80yznwgFvGVSmwDJALTH4uWJUNVkq1OU0K/9/i2RFDzt
	 AzLlIR0svltDAH8l1NlHVPqZ7JqfTzxocL2yYMjymuIRt4R0P32VvrXFmrh57wLxCm
	 ghcIpQgzf4qTw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 11D88380820D;
	Wed, 21 Jan 2026 02:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v9 1/9] net: memzero mp params when closing a
 queue
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176896201859.692363.6085050032197437366.git-patchwork-notify@kernel.org>
Date: Wed, 21 Jan 2026 02:20:18 +0000
References: 
 <7073bb4b696f5593c1f2e0b9451f0120ca624182.1768493907.git.asml.silence@gmail.com>
In-Reply-To: 
 <7073bb4b696f5593c1f2e0b9451f0120ca624182.1768493907.git.asml.silence@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, andrew+netdev@lunn.ch,
 ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, joshwash@google.com, hramamurthy@google.com,
 saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 alexanderduyck@fb.com, ilias.apalodimas@linaro.org, shuah@kernel.org,
 willemb@google.com, nktgrg@google.com, thostet@google.com,
 alok.a.tiwari@oracle.com, ziweixiao@google.com, jfraker@google.com,
 pkaligineedi@google.com, mohsin.bashr@gmail.com, joe@dama.to,
 almasrymina@google.com, dimitri.daskalakis1@gmail.com, sdf@fomichev.me,
 kuniyu@google.com, skhawaja@google.com, aleksander.lobakin@intel.com,
 dw@davidwei.uk, yuehaibing@huawei.com, haiyuewa@163.com, axboe@kernel.dk,
 horms@kernel.org, vishs@fb.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
 dtatulea@nvidia.com, kernel-team@meta.com, io-uring@vger.kernel.org
X-Spamd-Result: default: False [-0.46 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,davemloft.net,google.com,kernel.org,redhat.com,lwn.net,broadcom.com,lunn.ch,iogearbox.net,gmail.com,nvidia.com,fb.com,linaro.org,oracle.com,dama.to,fomichev.me,intel.com,davidwei.uk,huawei.com,163.com,kernel.dk,meta.com];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_NEQ_ENVFROM(0.00)[patchwork-bot@kernel.org,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-11857-lists,io-uring=lfdr.de,netdevbpf];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[52];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: A06DD4FAF5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello:

This series was applied to netdev/net-next.git (main)
by Pavel Begunkov <asml.silence@gmail.com>:

On Thu, 15 Jan 2026 17:11:54 +0000 you wrote:
> Instead of resetting memory provider parameters one by one in
> __net_mp_{open,close}_rxq, memzero the entire structure. It'll be used
> to extend the structure.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  net/core/netdev_rx_queue.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next,v9,1/9] net: memzero mp params when closing a queue
    https://git.kernel.org/netdev/net-next/c/7073bb4b696f
  - [net-next,v9,2/9] net: reduce indent of struct netdev_queue_mgmt_ops members
    https://git.kernel.org/netdev/net-next/c/92d76cf96dcb
  - [net-next,v9,3/9] net: add bare bone queue configs
    https://git.kernel.org/netdev/net-next/c/efcb9a4d32d3
  - [net-next,v9,4/9] net: pass queue rx page size from memory provider
    https://git.kernel.org/netdev/net-next/c/c0b709bf438b
  - [net-next,v9,5/9] eth: bnxt: store rx buffer size per queue
    https://git.kernel.org/netdev/net-next/c/f57efb32aae1
  - [net-next,v9,6/9] eth: bnxt: adjust the fill level of agg queues with larger buffers
    https://git.kernel.org/netdev/net-next/c/c55bf90a2112
  - [net-next,v9,7/9] eth: bnxt: support qcfg provided rx page size
    https://git.kernel.org/netdev/net-next/c/f96e1b35779e
  - [net-next,v9,8/9] selftests: iou-zcrx: test large chunk sizes
    https://git.kernel.org/netdev/net-next/c/a32bb32d0193
  - [net-next,v9,9/9] io_uring/zcrx: document area chunking parameter
    https://git.kernel.org/netdev/net-next/c/d1de61db1536

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



