Return-Path: <io-uring+bounces-12545-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oIahDzqAp2lJiAAAu9opvQ
	(envelope-from <io-uring+bounces-12545-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 01:43:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D431F8F8E
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 01:43:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 41F49305DEE4
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2026 00:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70DD62FA0C6;
	Wed,  4 Mar 2026 00:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5mVuyxe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEC02AD10;
	Wed,  4 Mar 2026 00:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772584982; cv=none; b=iJKjVQWXCQdP0xt53jntdu78jR5guZGPscGWwIYqPx8cgXhW1pWfOXZ5wVe26tlO9kZvu5wu8y/Xuo7fJGaM8OFUxVQYvqp5ao+AJeRonGqNAC17Gb6hRlUSXa3nNv8W67i7jYeY46ASbjkSW47ohOWjUwIEsSehWX10NdfJfiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772584982; c=relaxed/simple;
	bh=taZNXrUprFs762MVIbQkVX+AG9HLQwNRzP2C/mqE6i8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=MmcIxxqK+9IRL/h0ajplcgdI+kAqYP85WgzXuXXcqnEilTxycXCd4QdPDoREuOkYsp0TbkV/CdECoKf2RTudkF7dolInRQMKyjFLFX+0oqbEmt669oCWBNFoox8jDLs8lMDeoKtoRAsyZrxHMKWJdtfNgPPp7B44axDPjhX74rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5mVuyxe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE58EC116C6;
	Wed,  4 Mar 2026 00:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772584981;
	bh=taZNXrUprFs762MVIbQkVX+AG9HLQwNRzP2C/mqE6i8=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=d5mVuyxepLVebfCjRPbVSJTMaeapw7y5ttjsaO4XQ3F5aCRfxmv7Y7z1NpEec8+gR
	 ixk6w95UlBz68MwFfparpYX/nWAhpXN0GWwTEviMBscJziEIpDKjYSbqv8y/bYi5MB
	 vQ3AE7ithJDTxNDpFgHD8g7r61mx7/Cfx/gCFRM385J2l5XgwLKqUrO31RpqNuBhZf
	 yr8qpexK76Pd3fd2mDK5iR/KnrXlcKVjCydNeyXsgGkpyG1tFIj++qoNiT5FciLhkP
	 TR4PZRbo4EphVL2sLHKoHLV3XgjaZQeUAix5s9h523ihKYlHkrhKBcBsavSLAQfysq
	 BgjfCskbs00Wg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA77CEDEBF9;
	Wed,  4 Mar 2026 00:43:01 +0000 (UTC)
From: =?utf-8?q?J=2E_Neusch=C3=A4fer_via_B4_Relay?= <devnull+j.ne.posteo.net@kernel.org>
Date: Wed, 04 Mar 2026 01:42:57 +0100
Subject: [PATCH] io_uring/mock: Fix typo in help text
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260304-uring-typo-v1-1-152bd7474dde@posteo.net>
X-B4-Tracking: v=1; b=H4sIABCAp2kC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDYwMT3dKizLx03ZLKgnxdk2RzYwtzE0NjA1NjJaCGgqLUtMwKsGHRsbW
 1ANKff55cAAAA
X-Change-ID: 20260304-uring-typo-4c7387413053
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-kernel@vger.kernel.org, 
 =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.ne@posteo.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772584980; l=792;
 i=j.ne@posteo.net; s=20240329; h=from:subject:message-id;
 bh=DxSaceN2mJMhpNCtrbbBcSl6awZbjwelglsQqQzCSS0=;
 b=ODptXtfvI+TT/uh0ahgieM6+lXSAuyspU2Opa6r04HnFeeZdDnjaFCotU2HBaLsac8aBwna16
 YwadOTwAa1uCJuw6uFMW+pCq9/oTIx5MiGE4K9Xi2buJJjji54m1axl
X-Developer-Key: i=j.ne@posteo.net; a=ed25519;
 pk=NIe0bK42wNaX/C4bi6ezm7NJK0IQE+8MKBm7igFMIS4=
X-Endpoint-Received: by B4 Relay for j.ne@posteo.net/20240329 with
 auth_id=156
X-Original-From: =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.ne@posteo.net>
Reply-To: j.ne@posteo.net
X-Rspamd-Queue-Id: 99D431F8F8E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12545-lists,io-uring=lfdr.de,j.ne.posteo.net];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,posteo.net:replyto,posteo.net:email,posteo.net:mid];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,vger.kernel.org,posteo.net];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[devnull@kernel.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	HAS_REPLYTO(0.00)[j.ne@posteo.net]
X-Rspamd-Action: no action

From: "J. Neuschäfer" <j.ne@posteo.net>

Fix the spelling of "subsystem".

Signed-off-by: J. Neuschäfer <j.ne@posteo.net>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index b55deae9256c70..444ce811ea674a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1902,7 +1902,7 @@ config IO_URING_MOCK_FILE
 	default n
 	depends on IO_URING
 	help
-	  Enable mock files for io_uring subststem testing. The ABI might
+	  Enable mock files for io_uring subsystem testing. The ABI might
 	  still change, so it's still experimental and should only be enabled
 	  for specific test purposes.
 

---
base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
change-id: 20260304-uring-typo-4c7387413053

Best regards,
-- 
J. Neuschäfer <j.ne@posteo.net>



