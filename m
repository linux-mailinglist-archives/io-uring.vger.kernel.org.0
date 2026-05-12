Return-Path: <io-uring+bounces-13293-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4OkFNbKEA2ot6wEAu9opvQ
	(envelope-from <io-uring+bounces-13293-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 21:51:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C6F528D5A
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 21:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DCDB130BB74C
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 19:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C01F3502A7;
	Tue, 12 May 2026 19:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sjNWo1WT"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C0225B0BF;
	Tue, 12 May 2026 19:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778615433; cv=none; b=IWK6ZpqNL6DRdqgBmiEqsuervOO38pPlywbt4SomywOxVOYwG4SEw88Srb3/pVhk9bRhgUQQRA2/Foe7IR0FDa2ripR2Xx6wuWhJ7LdNdrd4Yk7dStIo8nrBTpeF9ummidmfZyBP4OSfvBa2cWOzXasyrXDo+HoGvUmFV9fk/pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778615433; c=relaxed/simple;
	bh=ueTjcatTsr99WKN5k9sgqczsfjpovapH2vxvjrhe5gg=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=rmyoGkKFqAcJw/xKz08O8UXjc2a30pIypn0F8Im8sHTI0eCHSG2htVR9hErm/ZX6EEvjSQMqMdh3WGjhdZw1b/nv+PiWJWjA+WpK3nhmUbwRbT1Rlj54NNPPg/OlBDETxsQjgS+tYpBMA0762kh+RNqHxp7IiCGloYDWOCvHyfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sjNWo1WT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB934C2BCC7;
	Tue, 12 May 2026 19:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778615432;
	bh=ueTjcatTsr99WKN5k9sgqczsfjpovapH2vxvjrhe5gg=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=sjNWo1WTd9P4KVvbpXOhBxq9rnE2qnOGTKwUMQRthj5YcgX/L3ZeqCyEMxmxiYYPX
	 Vw5uw/vqgvFh+7xX2XanzGBgKjIoeNlNQHEAiWj0E6iP02A8cAkMGtxaJoq21fjA0r
	 QpP7urDW/girfNqh3gV79EKIsvMLc0KQqdt1KXOOSXDbCEaS8ZtraEnVTBh9EpSha3
	 Vv+P4wK8S518Q3/OsGEMumpPhdsI7pF64d/lZdsL3tdF/roKuS47t4lKOKNdO2EUJR
	 fcJBOEYxvXXUuwZI8rHpwXXYP9BqbIblbyrrNCB91SQQ85jVV4QziF/Yz03o3wAYhW
	 zxM5xo/DeEobg==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5/5] io_uring/epoll: disallow adding an epoll file to
 an epoll context
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 brauner@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20260503085101.112698-6-axboe@kernel.dk>
References: <20260503085101.112698-1-axboe@kernel.dk>
 <20260503085101.112698-6-axboe@kernel.dk>
Date: Tue, 12 May 2026 21:50:21 +0200
Message-Id: <177861542131.846060.10743549776459529700.b4-review@b4>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=708; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ueTjcatTsr99WKN5k9sgqczsfjpovapH2vxvjrhe5gg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQxtzTOKGrZMf2CdM3P/c43NF4eY9zb+VLptdHR9W2K5
 77ubZ6o2FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARR1VGhmZz85X1ZbbG6RvX
 sPDKy1pkuiUF/04/+UHjsXwM+8HlnxkZ9oYe/ej+Ov7Azr9h/5Zt4975wXud0ctQQY8bfZfe6vo
 +4QQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 28C6F528D5A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13293-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Sun, 03 May 2026 02:49:16 -0600, Jens Axboe <axboe@kernel.dk> wrote:
> diff --git a/io_uring/epoll.c b/io_uring/epoll.c
> index 59cd4f009648..42057aab9124 100644
> --- a/io_uring/epoll.c
> +++ b/io_uring/epoll.c
> @@ -62,6 +62,9 @@ int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
>  	CLASS(fd, tf)(ie->fd);
>  	if (fd_empty(tf))
>  		return -EBADF;
> +	/* disallow adding an epoll context to another epoll context */
> +	if (ie->op == EPOLL_CTL_ADD && is_file_epoll(fd_file(tf)))
> +		return -EINVAL;

This is the same pattern in epoll itself.
Might be worth also adding a tiny helper for this that both codepaths
can reuse.

-- 
Christian Brauner <brauner@kernel.org>

