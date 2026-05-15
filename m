Return-Path: <io-uring+bounces-13361-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WIVFNy03B2rftQIAu9opvQ
	(envelope-from <io-uring+bounces-13361-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 17:09:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D27551E9A
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 17:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 33F8A30254D6
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 15:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 607C048B36F;
	Fri, 15 May 2026 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sg9NYjZ1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D57448AE3E;
	Fri, 15 May 2026 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778857768; cv=none; b=B3lGEnmgTfUjftJhgRvsimFaLmqmUpormFPQ0WOWxcaPtHbFgQW3Mb2MInpoVc2vABtlD38Ij4pzdsh+9w2ZKjmpSgiYseKnESAYj8h9gQUJUKUUrH3t0BYYKvJEyJTCG0UC0H9FCPVVPUU2NOF0e8jWSZ6+lrRDztOrP15j43o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778857768; c=relaxed/simple;
	bh=rF8fC0Rifkqz+kpXltmxnDtG7PRnvjHwvsNd7SFFe9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pbZORXoILhggqpMqxJIPbsBFsB79eGjDadyQuJu2rkwCcDyu2+O/7qs49PeamYqxJO6U/a7xeW4PGOzaJcJr0RfXXZ43ID/hng7a4Pg6axSQeR+STcSz9fBObx8oUHxI5W/KdrvqMf5DL/53AWiNEeyuZ9yVWTFwQMFBkcZlGUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sg9NYjZ1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84302C2BCFB;
	Fri, 15 May 2026 15:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778857768;
	bh=rF8fC0Rifkqz+kpXltmxnDtG7PRnvjHwvsNd7SFFe9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sg9NYjZ1kIKUngNgibfSUat16nDH+dtu09w4bNnaS+uwQsB652ooMpD30qxV8Ka5u
	 2+jVK0p1MnPXmCerbnJuMV5n54Og1UWj7GPoRoXZN3XgtEMifwJrwY1UwSdanTsdR3
	 cqDRT5G8KmURCJZX82aQY+IwDA8RF85dJ1xXpBUr4YU11/HHSc4QR+9VQcka0Lpb2P
	 vp0x/CsPjTqRiSJ7H4boHdMo3vAcfzb1NmUzZFRjIUMM8pIqc1EIQRRq5NBks7Ol2/
	 D73P2Q/lCDWIu/UxhX8LrEvwJWG7sAnsbejb9FD7pIBYJkDN07MNBbYABsesc9Vto/
	 ATtM8KcgAeueA==
From: Christian Brauner <brauner@kernel.org>
To: io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Subject: Re: (subset) [PATCHSET v2 0/6] io_uring related epoll cleanups
Date: Fri, 15 May 2026 17:08:11 +0200
Message-ID: <20260515-lachnummer-havarie-c6e68d7fe5ef@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140817.623026-1-axboe@kernel.dk>
References: <20260514140817.623026-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1860; i=brauner@kernel.org; h=from:subject:message-id; bh=rF8fC0Rifkqz+kpXltmxnDtG7PRnvjHwvsNd7SFFe9A=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSxmyt9PiTWUOj2pqvfJo81cU+RybS5Da4l9TW/Dtk2z +m1ejyzo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCKXyxgZOszDGW+kmr/k3qZo sCv20OUckcqKFeWCdgvnvEy2X/f9LMN/55Bq3hZmC8818jKx/7fxcy8K2zZTpOR1ubNaXe7ZFRe YAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 97D27551E9A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13361-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.966];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Thu, 14 May 2026 08:07:16 -0600, Jens Axboe wrote:
> One of the nastier things about epoll is how it allows nesting contexts
> inside each other, leading to the necessity of loop detection and the
> issues that have come with that.
> 
> I don't believe there's any reason to support nesting on the io_uring
> side, in fact IORING_OP_EPOLL_CTL is a historical mistake, imho. But
> let's at least try and contain the damage and disallow nested contexts
> from our side.
> 
> [...]

@Jens, I added the epoll specific change to vfs-7.2.eventpoll. There
were quite some merge conflicts now that I had to fix up. Please take a
look and make sure it's sane. Otherwise I'm going to push this and will
keep the branch stable.

---

Applied to the vfs-7.2.eventpoll branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.eventpoll branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.eventpoll

[1/6] eventpoll: pass struct epoll_filefd through ep_find() and ep_insert()
      https://git.kernel.org/vfs/vfs/c/a5b8d2cc7243
[2/6] eventpoll: export is_file_epoll()
      https://git.kernel.org/vfs/vfs/c/1a113455c097
[3/6] eventpoll: add file based control interface
      https://git.kernel.org/vfs/vfs/c/f6547914f5bc
[4/6] eventpoll: rename struct epoll_filefd to epoll_key
      https://git.kernel.org/vfs/vfs/c/8176d6935d79

