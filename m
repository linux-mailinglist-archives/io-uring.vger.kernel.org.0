Return-Path: <io-uring+bounces-13217-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2B6/CP6R92lhjAIAu9opvQ
	(envelope-from <io-uring+bounces-13217-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 20:20:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C464B6FB0
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 20:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 34C81301AD1F
	for <lists+io-uring@lfdr.de>; Sun,  3 May 2026 18:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2BDD3CFF72;
	Sun,  3 May 2026 18:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gICHH0If"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE2F2C15BE;
	Sun,  3 May 2026 18:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777832393; cv=none; b=Qa9tyd8DGzTXN4CUyvitqgMVrU6e+P4sSBi02ZT0ZeVVMtXO5ZfVxC0PdBKed5mmtDgvfmi1vL+yh7TxBtD/qVifCzHlufG/7aETfeTB7g+R3dmiVgtWcMjlhdPlw9pdA8e5MdUDVxoIQRexQxJ1dOI6bsAv5aPOCUUIjv1cvME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777832393; c=relaxed/simple;
	bh=x6/jzFtvnboS2oji7yoTnnp4xznSSVFBzySF6aCx/hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4zPPl5n1JSMoaXRlkRRTLYLi/NP7RjE+VGcbI9PwcOFIcBtPLkrgSFPYn4ffyCQxxfGSamMlywQbLimgew3EkKbLojnK9dH9qLZRC9mHI02b5rByEKKzXaPTZofQRqEjzVjvRf67TFV5ItHv1rcXY8ODa5ogZA4zSMuzlYpIQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gICHH0If; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B93C2BCB9;
	Sun,  3 May 2026 18:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777832393;
	bh=x6/jzFtvnboS2oji7yoTnnp4xznSSVFBzySF6aCx/hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gICHH0IfndpZNdW0HUkvlhme6illPCMSHYzu851P/vUa4N2NFlwPBaEbbksLeSI6I
	 aFTyeW3mdvSVWGqRamMCW+nnk9Qpwfr5MqmnDTzBhh8O47NZFLIjepcwvt/nCYJfax
	 QzXS4vNKrMbwAD2wxSem8YlIauIZ08ojMDFkDgyaEcVuorra/k4auj3kogPPjDaPBx
	 Y+eQTRLWGPKEUqRASPjM0jzwFmZFJ8VFpeLyn9Qoz353a8wXlxNWt94EujFPTuyj31
	 b1ilIUqihbUCRtRol4E1ycDkHjKSaLNw8L0KZdn7RuiKh7iBctWW6wgPKnO9Fe9Qze
	 POAzyfDd3bA3A==
From: Sasha Levin <sashal@kernel.org>
To: Kai Aizen <kai.aizen.dev@gmail.com>
Cc: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	axboe@kernel.dk,
	io-uring@vger.kernel.org
Subject: Re: [PATCH 6.12.y/6.6.y/6.1.y] io_uring/poll: fix multishot recv missing EOF on wakeup race
Date: Sun,  3 May 2026 14:19:49 -0400
Message-ID: <20260503143410.item006-iouring-multishot-combined@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501225250.90152-1-kai.aizen.dev@gmail.com>
References: <20260501225250.90152-1-kai.aizen.dev@gmail.com> <20260501225250.90152-2-kai.aizen.dev@gmail.com> <20260501225250.90152-3-kai.aizen.dev@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A4C464B6FB0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13217-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.993];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Sat, May 02, 2026 at 01:51:54AM +0300, Kai Aizen wrote:
> [PATCH 6.12.y] io_uring/poll: fix multishot recv missing EOF on wakeup race
> [PATCH 6.6.y]  io_uring/poll: fix multishot recv missing EOF on wakeup race
> [PATCH 6.1.y]  io_uring/poll: fix multishot recv missing EOF on wakeup race

Queued for all three branches. Thanks!

--
Thanks,
Sasha

