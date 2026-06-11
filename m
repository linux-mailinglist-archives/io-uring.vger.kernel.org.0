Return-Path: <io-uring+bounces-13670-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 7VERAg3UKmrJxgMAu9opvQ
	(envelope-from <io-uring+bounces-13670-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 17:28:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B09673104
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 17:28:11 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2IAczJH;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13670-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13670-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id ED132301C191
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 15:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57300421EE6;
	Thu, 11 Jun 2026 15:26:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A3341C302;
	Thu, 11 Jun 2026 15:26:36 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781191598; cv=none; b=fQQGaiet62j/MOeNXgZnXl9o31KOZMYLZvSuRDaV2m1N78I6bjuqdfvAj2vwnw5w8aEFV6u0mu9cOEnMa/K5Y0vSqEEOmC8wGcdHg0S6iDq0imeDl7TTeXDJb6WUJ5ODCUnxv8+fAaLvEhtiykGyCa1Mn7I4/ra3mCn7REafvVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781191598; c=relaxed/simple;
	bh=DBqicv98CNBfeibSXsJa778cvJt3FtvD4CmXE/vj5ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOEFXRsuPaP3MGSRBPsjbC+zfuc/aBuij2BZtN8WLwIBTrD7H+/J5Y8dPvCz14EMadjxSzPzC/RxclSB+RbmT42b3X9uWQmjWhf8tnSm6DBxW1nvCkvCB0d54os083FXh4ZZQqAeciFD3J0xSLtOE3VHLC7f+unMp2b9K2TgWAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2IAczJH; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6561F0089A;
	Thu, 11 Jun 2026 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781191596;
	bh=DBqicv98CNBfeibSXsJa778cvJt3FtvD4CmXE/vj5ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2IAczJHXaOhDUioPEcN2QaawM0NOCZXvaU1aIYetgS5fjVWWIqAWOjbrZAsr3rKE
	 jPd/i2ZwvdlvJh/zo0EL4NA8he+zSYOcbF2Ry3mvItgl4SM7yIdWSJdmRl8VVL8npl
	 TiDh87bTK5nN/O5mbn5koGg3CGcuDeA8lCSSpADbqs+d5A80RZSAQpES8D59+O90By
	 d3CIoFqaQ6f0xz8Xfmc69fgpZDoeZscXI54uEVP9UsubdcoFIkGHszjhWmK+WWczSh
	 pvbCGd48BX4iJwg+5CkjdbLuGispmUIneoPcMcYIfs0moESl3XKxfOD8F4+XGIBOTZ
	 KLF8QcqX7az7Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Alexey Panov <apanov@astralinux.ru>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Li Zetao <lizetao1@huawei.com>
Subject: Re: [PATCH 5.10] io_uring: prevent opcode speculation
Date: Thu, 11 Jun 2026 11:26:24 -0400
Message-ID: <20260611-stable-reply-0106@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260610172203.27999-1-apanov@astralinux.ru>
References: <20260610172203.27999-1-apanov@astralinux.ru>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:stable@vger.kernel.org,m:gregkh@linuxfoundation.org,m:sashal@kernel.org,m:apanov@astralinux.ru,m:axboe@kernel.dk,m:asml.silence@gmail.com,m:activprithvi@gmail.com,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:lvc-project@linuxtesting.org,m:lizetao1@huawei.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13670-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,astralinux.ru,kernel.dk,gmail.com,vger.kernel.org,linuxtesting.org,huawei.com];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E7B09673104

On Wed, Jun 10, 2026 at 08:22:03PM +0300, Alexey Panov wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> commit 1e988c3fe1264708f4f92109203ac5b1d65de50b upstream.
>
> sqe->opcode is used for different tables, make sure we santitise it
> against speculations.

The 5.10 backport itself looks fine, but I can't take it on its own:
1e988c3fe126 is still missing from 6.6.y and 6.12.y (it's present in
7.0, 6.18, 6.1 and 5.15), and we don't add a fix to an older tree while
a newer one is missing it. Once 6.6.y and 6.12.y carry it, I'll queue
the 5.10 backport.

--
Thanks,
Sasha

