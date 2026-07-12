Return-Path: <io-uring+bounces-13988-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id al0RAlH3U2rEgQMAu9opvQ
	(envelope-from <io-uring+bounces-13988-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 22:21:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 569B7745CFD
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 22:21:36 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WPn7vj5N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13988-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13988-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2163C3009B32
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 20:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E9B437475B;
	Sun, 12 Jul 2026 20:21:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E3113D51E;
	Sun, 12 Jul 2026 20:21:22 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783887682; cv=none; b=ieahMMpu2tijUkCbmQsUv8lOxe1QXhNQ0P7wMig61YsOqiE3yHSuk/pK+ZVaPHEhLqf2Ch7SMflq95ueBQeiS4KvYFlwhGKwHUf0ufDPG8R4D9P3q+UvXp67V7ZWPuZyaWgTFISvRZfcS8ZSlqaIdK6OjQKVzicElvmbSA7EW7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783887682; c=relaxed/simple;
	bh=as4ecKyATLLiLU+K7q++TXoFW9MaeyuRw24AA9b8bIc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=I3ObEqCs8mtPbokH8SCZBqtFlNuD6BKQI3Njl6+qTI8+oi/4btEiz/Iw5pFTHcd0QM6fFljMXZx+LYxsWk5UCfqYsISkmQxSxDNj5dCxN2/HatTIoUOEm1nO79+85jDfiDlsU+5jg1GvaCQ7CQLSfAogBsq0Q/yPpT9U/i5YltI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WPn7vj5N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE0B3C2BCC7;
	Sun, 12 Jul 2026 20:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783887681;
	bh=as4ecKyATLLiLU+K7q++TXoFW9MaeyuRw24AA9b8bIc=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=WPn7vj5Nqp1BQQaCvblGuoiIlqgQDzGxoxPTp81YWe3ssHCC7DVFqjok+meJkO5Ut
	 DLuFJ58iLvjvmT5qB7q4a+ZiQ4aGSiY0kHlNfj3JwxQRltsxtXrE7rsKlVBq1imgdg
	 zyWu66eiJBfe+BPV4+E5ho/5NZ+v0hf8ARhSE2BR1xCzfYYdSsg2AdrWWzQvwYEL4/
	 DJB7pUzEd4doZrbMvrDBEhoGBqGvNGNxbVBaHMXlQExQAbje+zbdHECT34GG4HIinW
	 x47vEedBxb6krkED73xcEGoaiIoHX31xPE/87S5jVmp+deoVupvDvhLxpB9YrJK9Qd
	 vNjwU5YEHsO0w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7B3C43458;
	Sun, 12 Jul 2026 20:21:21 +0000 (UTC)
From: Junye Ji via B4 Relay <devnull+jijunye1.outlook.com@kernel.org>
Date: Sun, 12 Jul 2026 13:21:16 -0700
Subject: [PATCH] io_uring/kbuf: free cached iovec only after replacement
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260712-io-uring-kbuf-iovec-lifetime-v1-1-23028d00b6cf@outlook.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqDMBAF0KvIrDswRlHwKqULjTP6aY0lURHEu
 zd0+TbvoqQRmqgrLop6IGENGeWjID/3YVLGmE1OXCNt6Rgr7xFh4vewW9ahnj8w3bAo12a1NL0
 M4ivKxTeq4fz3z9d9/wDEzSBTbgAAAA==
X-Change-ID: 20260712-io-uring-kbuf-iovec-lifetime-4ff406a0b0c3
To: Jens Axboe <axboe@kernel.dk>
Cc: Hao-Yu Yang <naup96721@gmail.com>, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Junye Ji <jijunye1@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783887681; l=1694;
 i=jijunye1@outlook.com; s=junyeji-20260712; h=from:subject:message-id;
 bh=OUMgENWWWxoEYLpXsl1Dvxz32F/77rmlxtHsMQSj9/Y=;
 b=TSSzKm2z/AWaYArbGY9qOOLdCpQS9h+8be9MPINfJhHTSCbE8TshWzpdnMC5oTz/CyRHsUlhp
 DrNq9Q1YNl2D4Q6ekaJSJmmd+ZShhWihtonMqyUwggKJW4opLSwBzea
X-Developer-Key: i=jijunye1@outlook.com; a=ed25519;
 pk=aKIN8hT1V9oSVC83K2q1NNzawUnDaybDxbYJltmwvGE=
X-Endpoint-Received: by B4 Relay for jijunye1@outlook.com/junyeji-20260712
 with auth_id=865
X-Original-From: Junye Ji <jijunye1@outlook.com>
Reply-To: jijunye1@outlook.com
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	FREEMAIL_REPLYTO_NEQ_FROM(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:naup96721@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:jijunye1@outlook.com,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13988-lists,io-uring=lfdr.de,jijunye1.outlook.com];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,outlook.com:replyto,outlook.com:mid,outlook.com:email];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_REPLYTO(0.00)[outlook.com];
	FORGED_SENDER(0.00)[devnull@kernel.org,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,outlook.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	HAS_REPLYTO(0.00)[jijunye1@outlook.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[devnull@kernel.org,io-uring@vger.kernel.org];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 569B7745CFD

From: Junye Ji <jijunye1@outlook.com>

io_ring_buffers_peek() saves the incoming iovec array in org_iovs, then may
replace arg->iovs while expanding a provided-buffer bundle. With
KBUF_MODE_FREE set, the success path frees arg->iovs instead of org_iovs.
It either frees a replacement before the caller uses it or, when no
replacement was needed, frees the cache still owned by the request. Cleanup
later frees the same cache again.

I reproduced the stale read and double free on the no-growth and
successful-growth paths with two completions from one multishot receive.
The fixed KASAN kernel completed 100 runs of both triggers and both
liburing bundle tests without a report.

Fixes: cd053d788c3f ("io_uring: fix dangling iovec after provided-buffer bundle grow failure")
Assisted-by: Codex-Security:unspecified
Signed-off-by: Junye Ji <jijunye1@outlook.com>
---
I can send the reproducer and full trace/KASAN logs privately if needed.
---
 io_uring/kbuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index b6b969b55e12..07d81dc7cbe2 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -328,8 +328,8 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		buf = io_ring_head_to_buf(br, ++head, bl->mask);
 	} while (--nr_iovs);
 
-	if (arg->mode & KBUF_MODE_FREE)
-		kfree(arg->iovs);
+	if ((arg->mode & KBUF_MODE_FREE) && arg->iovs != org_iovs)
+		kfree(org_iovs);
 
 	if (head == tail)
 		req->flags |= REQ_F_BL_EMPTY;

---
base-commit: 44696aa3a489d2baf58efa61b37833f100072bee
change-id: 20260712-io-uring-kbuf-iovec-lifetime-4ff406a0b0c3

Best regards,
-- 
Junye Ji <jijunye1@outlook.com>



