Return-Path: <io-uring+bounces-13455-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SFzJKFzIDWr93AUAu9opvQ
	(envelope-from <io-uring+bounces-13455-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 16:42:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A009E58FDE6
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 16:42:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A307030AFBB9
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 14:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF223ED3B5;
	Wed, 20 May 2026 14:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUTse8DT"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17573EDAA7;
	Wed, 20 May 2026 14:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779287507; cv=none; b=UgzV7sZe5Z50BtKAGU0+iOkGyO3Mqa158nnePYkZAAodoWDquUYaaG3spNkKiFxhHcq9tt4vsSfYnQWBruln+WIkIqxQAzq4YnO/femGs6rCRcX/MSLcJbL52bKb/c8En8i1a2VmHKsn48ZakdHeDLUO3nfssF0nZSPf6c5WV5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779287507; c=relaxed/simple;
	bh=W6SayE5aVoIzZ3A++FC2ibv9iTntNnzWRBYYXewEc3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4qEdxfq/FMKXwNM3sQ3wUEkDCJ7ZSHwjj+4aCQBnztJkfXBU+/P2MUrzTDWo9WIbUr0F2iFp7oVZtA0HtdNr4ZLj0vtF1qeObYJFXFZlgyR2H88WKy4sRZCpC+W4kgCtc1VvMt38/WAKUcyihR02HlQpdMjqy1wm9yGDHPfQG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUTse8DT; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F9E1F00893;
	Wed, 20 May 2026 14:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779287505;
	bh=W6SayE5aVoIzZ3A++FC2ibv9iTntNnzWRBYYXewEc3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUTse8DTj/xm6YiZ2kx7xXqMNuWAtOsjigQFCKMcavjbCqYqd9Y6irNRCB+NtjHsr
	 Y3F6kMdFCKNxtnAAvh64kpI99n/EJVVYl8xeyTNSzi2F8UzUKeNmGEnXtWtSWo9EJA
	 a79Lcs4lnyNPFW42zhp6BCpilhDc/oQ4dZMT1upC76BoAf1dJWoCC7kD0WeSbVuTCV
	 5qJHmlAp5GOqR1pIj1OvSpwh3V87t5/p/5+Xc0Oo3LQj2QSTBmk3MnLZaL6YnRAeAR
	 Hyw0utdUJAOb0SO7GN80wKygrCwy1jQ+0i5QUkZvvMue1cpLEOAmf1dozoQtfTKIx6
	 lB+RBr21aaIQg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Li Zetao <lizetao1@huawei.com>,
	Robert Garcia <rob_garcia@163.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15.y] io_uring: prevent opcode speculation
Date: Wed, 20 May 2026 10:31:38 -0400
Message-ID: <stable-reply-0003-io-uring-opcode-5.15@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520062833.2563847-1-rob_garcia@163.com>
References: <20260520062833.2563847-1-rob_garcia@163.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,kernel.dk,huawei.com,163.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13455-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: A009E58FDE6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

> From: Pavel Begunkov <asml.silence@gmail.com>
>
> [ Upstream commit 1e988c3fe1264708f4f92109203ac5b1d65de50b ]
>
> sqe->opcode is used for different tables, make sure we santitise it
> against speculations.
[...]
> [ Use req->opcode instead of opcode here. ]
> Signed-off-by: Robert Garcia <rob_garcia@163.com>

Thanks for the backport. Upstream 1e988c3fe126 is currently queued or
present on 6.6, 6.12, 6.18 and 7.0, but it is missing from both 5.15
and 6.1 - we should not skip 6.1 when backporting a Cc:stable fix to
5.15.

Could you send a matching backport for 6.1 as well? Once we have
coverage from 6.1 onwards I'll queue both together.

--
Thanks,
Sasha

