Return-Path: <io-uring+bounces-13997-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id KffhLgQvVWoulAAAu9opvQ
	(envelope-from <io-uring+bounces-13997-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2026 20:31:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C44A674E7F9
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2026 20:31:31 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=fail ("headers rsa verify failed") header.d=0sec.ai header.s=google header.b=RaXZ0HFF;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13997-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13997-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 758F23043531
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2026 18:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050E11DED5B;
	Mon, 13 Jul 2026 18:31:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21768EAC7
	for <io-uring@vger.kernel.org>; Mon, 13 Jul 2026 18:31:27 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783967489; cv=none; b=r2VxCRcksEkHy6271Ncdgce4I4ejgbTU8TRZX0qSZYQGD9NZhKWpi+bX5KcNkEjQexcXb1flpQi+rS2+Mek3TxItDub+GzRXIsg1jG4we3TL6nxpsuYiIypPOp00hTy1haEjuCBU5In1KkZnWDePrwGnDq15arsm190KN53UZjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783967489; c=relaxed/simple;
	bh=95oOiJdu3a9OfAuqQbchxv4PpiKvLM2iB6tkG3Eobgg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hP7AzhB9VtJ/qR5KhZTJ7sqfVfcM6yPW7T0MzKfgaJqjUwvdXhrMwHgdRo+2H4+0EEz46MsKm4AuwSrBZ63rVBknsblOvkMRa1NWxTG8YKfEeDGz8JlDuJ5WnLkwoJ37FutxR/6Gq7/eu2oeow/xDJn3yqcfPJmy7eWIcm6ggLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0sec.ai; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=RaXZ0HFF; arc=none smtp.client-ip=209.85.221.45
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-471eeac43bfso3415524f8f.3
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2026 11:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1783967486; x=1784572286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oR/f7encpZVkiKBTK1olxsoJ4tgqYqikW+d6n0bDAg4=;
        b=RaXZ0HFFJ3NoTZlgEgTs+9X6vVl6SfJ3PgHg5iOhe1VUPId2VLmHsOhc3+aZDQULUQ
         VMbyoKXwtv2jTSfc2lpSLnnpA/QPqNNRmNs+1QHOXMkhz+zG6dg0KnQ8JQGwzkRvW9Dm
         VejG9Fe3dw2C+ipbZiQOUoxynso6XMGbwxOcdSUYQDZPeF1RO7tLNAbAFBk2mskL7d/L
         wCkFoGSDTytLHjTZvPi5FaZcHStmlpMngUTtTE9HJYGJvT2El8NX+2pHTz8SGl47n1AS
         tl8cUuUbhBrB2wxN4fHmT1Y7HvmGFZRJHbt6TEO3R5YHEINU+q1KpuwoaJyCwpTZzvo3
         ButQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783967486; x=1784572286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oR/f7encpZVkiKBTK1olxsoJ4tgqYqikW+d6n0bDAg4=;
        b=njn+qXUhh8KOCk2rvgE6RiVq3DXmbUi3M9dupeYweYrTJqH+yNkmuruXYcBefeFuJ2
         L/+zSrowA+k6xXNrnWaqCD36qKvSWWywLlZnKk7MqNL54RBB4DVBQz6fgqiooJ8WoWZC
         Y4V46norPkunvG9Vv1kh60kfKjUsQIXxXJF5najuHBY2zBORRzec1bGXdJwe6etHpb+e
         p6wgY9jJ1N36lQeJeybpC9r5QhFjxncQQxGRVl+gseCAohrRCA4kwSVLJDTJk/7AanTb
         t0M5RFELjw6R3rZbni9mzWLO+uc185w+WQfyOWJRqVYAEgQR1BQEBftzFS7ovGTH0osR
         6BIQ==
X-Gm-Message-State: AOJu0Yx/KKjUGhV+wpolSb9pIz8C4uSCGmv7qzb9Scd1VyAGoOo2N7SB
	wTclkoJIpA2DjHu6zueuSS/m0x1xYyYGhmr7kF5JqMgS083eGiOtxf7WPWEGT7wNjpiRtU+ntfT
	p0/n9UyXV
X-Gm-Gg: AfdE7ckJN9HW4MKMsIpBQOCuLzaAw/oaXkbY9PqoJ4JC362/ouxyWzYF81jqnev4CoQ
	m2vqO0+Ir7iHd8jpBvnSv7xl+DWrOwsqL7quuU8kRESERa0if/2isL8GW5h09y/iUGPrL+czNi9
	xGCtH/ZKu4vJfPlIAHtV5kpiCdp85iUUoMSwGoR39qIAQMJ/ja0j/UDboAMmUBPR6GeSMEeOFYZ
	m6hejEXuzIfyeGNw+6qIZttXP80pCP9aCi/mArLkpwp9clCCF8b88Fqq0iKdtktpa+1hp5GFUcx
	fI67I6diCd1tCq/JwCSaHM9FIfmCOOC0FiN2eYBDxxlDuYfO96hrttAAsQUQglv3+S3/34mFS0H
	kIR77rtP+a9SAEuVOvtBcI6PIW9upUjfgRLDO6+wWfvmOGrXegHpPuKMtKBdv2tD2Uicie0yhXI
	H+iMxoFuB86N1XvgwRC9fhWodRp7S58v98GLFXG6o0eAasJzJXQVY6cIkvXdGZ0lkwpIH7tFlOp
	cfkxs+hOIq3KXEVWBrsBDYvlub7B6fgZNY=
X-Received: by 2002:a5d:5846:0:b0:472:79bc:3919 with SMTP id ffacd0b85a97d-47f2dceac0cmr11350573f8f.39.1783967486402;
        Mon, 13 Jul 2026 11:31:26 -0700 (PDT)
Received: from PeakBook-Mini.tail8e484.ts.net ([178.197.218.188])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a9cesm1314729f8f.14.2026.07.13.11.31.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Jul 2026 11:31:25 -0700 (PDT)
From: Doruk Tan Ozturk <doruk@0sec.ai>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Doruk Tan Ozturk <doruk@0sec.ai>
Subject: [PATCH] io_uring/kbuf: free the old cached iovec, not the returned one, on bundle grow
Date: Mon, 13 Jul 2026 20:31:24 +0200
Message-ID: <20260713183124.4217-1-doruk@0sec.ai>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_REJECT(1.00)[0sec.ai:s=google];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13997-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[0sec.ai];
	FORGED_SENDER(0.00)[doruk@0sec.ai,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:doruk@0sec.ai,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[0sec.ai:-];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[doruk@0sec.ai,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,0sec.ai:from_mime,0sec.ai:email,0sec.ai:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C44A674E7F9

Commit cd053d788c3f ("io_uring: fix dangling iovec after provided-buffer
bundle grow failure") moved the KBUF_MODE_FREE kfree() out of the expand
branch to after the validation loop, so the old cached iovec is only
released once the new buffers have been validated. However, by the time
control reaches the post-loop free, arg->iovs has already been reassigned
in the expand branch to the freshly allocated array that is about to be
returned to the caller:

	iov = kmalloc_objs(struct iovec, nr_avail);
	...
	arg->iovs = iov;		/* now the array we return */
	...
	if (arg->mode & KBUF_MODE_FREE)
		kfree(arg->iovs);	/* ... but this frees it */

On a successful grow, io_ring_buffers_peek() therefore frees the very
iovec array it returns. io_recv_buf_select() then builds an iov_iter over
that freed array and caches it in kmsg->vec.iovec, giving a
slab-use-after-free read during the recv copy and a later double free of
the iovec array on request cleanup. The array is a kmalloc() whose size is
controlled by the number of ring buffers the caller commits, so the freed
object lands in an attacker-influenced kmalloc cache.

KBUF_MODE_FREE is meant to release the *old* cached iovec once it has been
replaced by a larger one. Free the captured org_iovs instead, and only
when a grow actually happened (arg->iovs != org_iovs) so the no-grow case
still returns the reused array. The -EFAULT failure path already frees the
new array and leaves org_iovs for the caller, so it is unaffected.

Reproduced on next-20260710 with KASAN by an unprivileged IORING_OP_RECV
using IORING_RECVSEND_BUNDLE over a provided-buffer ring: a first
(expanding) bundle caches a small iovec, and an in-request bundle retry
grows again under KBUF_MODE_FREE, triggering both the UAF read and the
double free. The change eliminates the KASAN splat.

Fixes: cd053d788c3f ("io_uring: fix dangling iovec after provided-buffer bundle grow failure")
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
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
-- 
2.43.0


