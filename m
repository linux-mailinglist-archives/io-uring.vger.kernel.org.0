Return-Path: <io-uring+bounces-13987-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id r8LLE3OkU2rYcgMAu9opvQ
	(envelope-from <io-uring+bounces-13987-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 16:28:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9359B744FB0
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 16:28:02 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=proton.me header.s=qpyzhihmw5chjncwqtdyqhmbba.protonmail header.b=jfYd0wYg;
	dmarc=pass (policy=quarantine) header.from=proton.me;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13987-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13987-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 378C730107FE
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 14:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F236D23395C;
	Sun, 12 Jul 2026 14:27:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-10629.protonmail.ch (mail-10629.protonmail.ch [79.135.106.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738BB22AE48
	for <io-uring@vger.kernel.org>; Sun, 12 Jul 2026 14:27:21 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783866445; cv=none; b=CebTNmYY6Vizf36WGA578QbmAAmhqJMg5IrLhrswgG+0snKyMyEJTSS+KXSvtOKpQECl8NswaELZOhiwerHxrUS9yI2YABub4SfSutSx9sfHMotmnKLfB9Fp3P6rTINoGYaj6vjGeWsMMeyz7FGN7YoG8wCC2s7GRmkRFe5Ouqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783866445; c=relaxed/simple;
	bh=RFREUUJQmQWdgY0SFW5TvAzo56uLKZIPbzE5cvdGENI=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=XNQbqTOkuh0ZcWKhPi76A9zvc6tmgaChVtNp+hr6Vwn66P3/ScAWJNnb/cSzuHRLReOdt0QjT9/HX1uhqS4tGVxTNZRmbHGudFkEgUkS5X0GJvNWIU8ITTWuoArXuHnvWp9mod1/X/pPx2mMgnK1OqT7mdcCddYi4yUspD3+pjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=jfYd0wYg; arc=none smtp.client-ip=79.135.106.29
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=qpyzhihmw5chjncwqtdyqhmbba.protonmail; t=1783866437; x=1784125637;
	bh=RFREUUJQmQWdgY0SFW5TvAzo56uLKZIPbzE5cvdGENI=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=jfYd0wYgwkf8IPcuNbuXYsHEpCFY79IsZJSripv6YlxjTJbBTYDyOHvDsMBQyb1nx
	 w4H4p4SK9qLEarUybRPE4MPPgyz7YFFUSXAI5JiW6z9+9DF2ur4czUD8GYG1iM4tgn
	 AuPAZm3YHZFQyYh77lHv6W+A210rUKILKHHo8i8LQ/A9OKKq9EJgQw5wiP2sQFmkVu
	 u7uc6QxXrcD8I0YqjuYsbmgk59OQtZ/U8epW//uD4xDUuHidzzTAOoCx7wW0ZTnKTs
	 I104Z7LOWW664RsECzP0KI2kNz4rdtPkqlqeoafsBgA1oUzKw/BxNWuYqER2isbtXJ
	 bTl3s5dQueAEA==
Date: Sun, 12 Jul 2026 14:27:12 +0000
To: Jens Axboe <axboe@kernel.dk>
From: Jaeyeong Lee <iostreampy@proton.me>
Cc: io-uring@vger.kernel.org
Subject: [PATCH] io_uring/kbuf: free the replaced iovec after a successful grow
Message-ID: <20260712142612.188695595-iostreampy@proton.me>
Feedback-ID: 96968035:user:proton
X-Pm-Message-ID: 7e470cc1af18254810af9362e774a5e38c4ba2bf
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[proton.me,quarantine];
	R_DKIM_ALLOW(-0.20)[proton.me:s=qpyzhihmw5chjncwqtdyqhmbba.protonmail];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13987-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER(0.00)[iostreampy@proton.me,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[iostreampy@proton.me,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[proton.me:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9359B744FB0

The provided-buffer validation fix deferred freeing a cached iovec
until validation completed. However, the deferred free uses arg->iovs.
After a grow, that points to the newly allocated array. Without a grow,
it points to the cached array that remains in use.

This leaves the caller with a dangling iovec in both cases and can
result in repeated frees. Only free org_iovs when arg->iovs actually
replaced it.

Fixes: cd053d788c3f ("io_uring: fix dangling iovec after provided-buffer bu=
ndle grow failure")
Assisted-by: Codex:gpt-5.3-codex-spark
Signed-off-by: Jaeyeong Lee <iostreampy@proton.me>
---
 io_uring/kbuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index b6b969b55e12..de0129bceaba 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -328,8 +328,8 @@ static int io_ring_buffers_peek(struct io_kiocb *req, s=
truct buf_sel_arg *arg,
 =09=09buf =3D io_ring_head_to_buf(br, ++head, bl->mask);
 =09} while (--nr_iovs);
=20
-=09if (arg->mode & KBUF_MODE_FREE)
-=09=09kfree(arg->iovs);
+=09if (arg->iovs !=3D org_iovs && (arg->mode & KBUF_MODE_FREE))
+=09=09kfree(org_iovs);
=20
 =09if (head =3D=3D tail)
 =09=09req->flags |=3D REQ_F_BL_EMPTY;
--=20
2.43.0




