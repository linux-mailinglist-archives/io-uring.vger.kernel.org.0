Return-Path: <io-uring+bounces-13290-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eDS4CZCEA2ot6wEAu9opvQ
	(envelope-from <io-uring+bounces-13290-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 21:50:40 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 91C86528D3C
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 21:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DCA4A3091087
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 19:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97125368D5D;
	Tue, 12 May 2026 19:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8EPf6iO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732172F8E9B;
	Tue, 12 May 2026 19:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778615428; cv=none; b=f5a2uSuBzH0nH77GHVzWBJge4rBF8ueFdHLNyBBYbjQcTR/9Ggi1/4n+Ltm4oqF2bSBigpuRpAqMRF2SlZFFyz1vpkHMLKaWDSmtoz9oVMqccorqqQXas/QMwIoZzmuNG9o9u8S5DTwgj3AIEQN8j4yXfUyV2ONeJrh1NYlIGwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778615428; c=relaxed/simple;
	bh=Xundm1ZvBUu8C0lnbevb9XS7y1iy6fczD2c2YLf6/q8=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=oRQw1XQfG6dYGueckWt7uFGW0kCZZEpDbkDBsH7Jppsfj+0n5Hkw8FFeAn9hye5kGNtXbnOab5HS9zYtre1i7Kj1grcZQZqpNYswyK9SNE4bQnLsPl66b8qw8Knn9nF/ZOSoJ5m9DiZQMR8D2tblRDT0yymuxoXoxeE2+ZbF424=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8EPf6iO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418C2C2BCC7;
	Tue, 12 May 2026 19:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778615428;
	bh=Xundm1ZvBUu8C0lnbevb9XS7y1iy6fczD2c2YLf6/q8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=C8EPf6iOax3Z/mxxoMfMoQfHDYn4EEFkEAH0UkAxgZugUe2KA2PE7H/Xj/EPFhFx9
	 0kb4vycZLNTrguui2Gu5ldjxC/nbLM6nIHahCkUJhXcCaQhja3b8dH7u5mvQPLUqgr
	 lM0nFFLosSwO3yhQFOBcGjqzg4jsUvW1bVZa9Z9e6cT94Tx8gOGaIGSr0mI41K8Sk5
	 lg3gQYiKN99qsFJHh/VsmYrvR5j7ivjYOfHIcsFs+p3NOB+Mw64SBnBYmPTAHZZSWY
	 dUhLz3nnR3jcTXCzkZ1UXT9kLxfqi+cJVzJ7Us+w+56msWCGNQeSRaImgrqYplNYHg
	 veMvtwpCh1SIA==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/5] eventpoll: pass struct epoll_filefd through
 ep_find() and ep_insert()
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 brauner@kernel.org
In-Reply-To: <20260503085101.112698-2-axboe@kernel.dk>
References: <20260503085101.112698-1-axboe@kernel.dk>
 <20260503085101.112698-2-axboe@kernel.dk>
Date: Tue, 12 May 2026 21:50:21 +0200
Message-Id: <177861542128.846060.10688550014394641030.b4-review@b4>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=663; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Xundm1ZvBUu8C0lnbevb9XS7y1iy6fczD2c2YLf6/q8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQxtzRKbot4EOISfGDjkrxD9iuV5l443/xdhffmi5us3
 hzqtnaqHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOZfp/hf6bKjY3KS6Kf+nn1
 NIXrR/bdvvpavuDi3DbtwAkv7/65Hs7IsHHKxM2NNtEnZa1ay+T6mCrFO4U8jSKuXA9q2vD6is4
 5HgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 91C86528D3C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13290-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Sun, 03 May 2026 02:49:12 -0600, Jens Axboe <axboe@kernel.dk> wrote:
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index a3090b446af1..f464f2f39e0e 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -339,14 +339,6 @@ static inline int is_file_epoll(struct file *f)
>  	return f->f_op == &eventpoll_fops;
>  }
>  
> -/* Setup the structure that is used as key for the RB tree */
> -static inline void ep_set_ffd(struct epoll_filefd *ffd,

I wish this was named "struct epoll_key" instead of this completely
weird "epoll_filefd" thing,

Reviewed-by: Christian Brauner <brauner@kernel.org>

-- 
Christian Brauner <brauner@kernel.org>

