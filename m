Return-Path: <io-uring+bounces-13996-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id uuQRC1ffVGq2gAAAu9opvQ
	(envelope-from <io-uring+bounces-13996-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2026 14:51:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B0AF574B1FA
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2026 14:51:34 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gveA3B7n;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13996-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13996-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=debian.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 89F603014753
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2026 12:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F7E37BE93;
	Mon, 13 Jul 2026 12:51:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2163840BCD2;
	Mon, 13 Jul 2026 12:51:17 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947083; cv=none; b=CCm46F0xGONp2Cm92LCyLjeKJRe1betPIDVMp7FQbs4mLiqugZKOsDv35CtTNRD7nHT4nUgQ3cAe/HolMW+hfnhsn9Spyerq0yCNotw3GGNLSJqUHvRDKx3kuLLKq7vogTY9QEPJtwjPEpyMSPBBySRFCvJnFF9vJvEW/JwDUF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947083; c=relaxed/simple;
	bh=moPgrszvV0964G3VTWpVvuEC6kwV9PytXHcZOov9llE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ciINinlqWoTrNy14LiSeDqDAUv9Q3TjJrbsSkgftibc/yrT3zkHhPupKTXicgjsIIjUAqZul4Wg4tnbfQFeoTkfwCzuKnVgtSl73F5hZwjMhChcb2VgdghGXDZPiZpLdm2TAF+GrGRQRSeRx/yUmVLrvwiwwouWICNvMSrEGsG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=gveA3B7n; arc=none smtp.client-ip=82.195.75.108
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=E7Tq8EwVWjmXsEi4MzM7BUX4QKWNx0sPNYqYBv/0ADw=; b=gveA3B7nb4GlA+ArP3sI7oIKhO
	ff3IsVNsFW30jPwX4BrHLkxJU7kuKc+/a9Lg1+O6ZJvhUu1PhTH0HAEoqS3xkS46flO9rfadz8yC1
	EATaWRn934vsxB6zAXkf+v9vpoIJtau35o8ST7CPDOF5lN2ugDWaXk0YhVzpd+MPD7xglgv2swATE
	51PXb5lbhwdATDsIgAEEhcnkxMglEQbKReEFbv0ciCBaQgN6b0j8U6C+6LTHSbGho9YFwWdDgcHX/
	3vhb+WUYS3vJELGwA5wU3gKyiuT8bHHo2WI1BsVgwAhtBLg6nIQ95K/BDs6pCLAsQ57burzd+mVKb
	MUi9E9lg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjG7t-001Vny-0t;
	Mon, 13 Jul 2026 12:51:13 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 13 Jul 2026 05:51:06 -0700
Subject: [PATCH] io_uring/kbuf: fix use-after-free of new iovec on bundle
 grow
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-io_uring_dangling-v1-1-b9bdc0f0e776@debian.org>
X-B4-Tracking: v=1; b=H4sIADnfVGoC/x3MYQqEIBAG0KsM3++EVLLwKssikZMNxLQoGwvR3
 Rd6B3gXGlfhhkgXKp/S5FBEsh1h2WYtbCQjElzvQj9ab+RI3ypaUp617KLFTOPifB7CZP2AjvC
 pvMrvOV/v+/4DcErsXGMAAAA=
X-Change-ID: 20260713-io_uring_dangling-87c23d568135
To: Jens Axboe <axboe@kernel.dk>, Hao-Yu Yang <naup96721@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-team@meta.com, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2019; i=leitao@debian.org;
 h=from:subject:message-id; bh=moPgrszvV0964G3VTWpVvuEC6kwV9PytXHcZOov9llE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqVN8+uaROUoiUZj+JYMrOJROHLVyHqukjb4yoz
 GO6A07kEymJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalTfPgAKCRA1o5Of/Hh3
 bWKUEACw84QGsfLIW9b89KSsDAlY2HZlFfTXxJl3kb6pCTOHpBhpN8z0OzN8s1wUe47ye9udukL
 e3quYmp10+RucFSQv2LWQYeLhpjwJeR5TyfGliTNc1mx/CyvEnnBcZgyadrAN2XgHyEzPX4Ajhs
 +pejc60LVGKk+MOYzNpRU2zxBoej88C/9o/FL9yP5wTsbWJ7WLpve3UORo/7kWAUyMYZ83hN36B
 VjbzB6oouIj3V0kdIXf4VOtYdRn5sya4VBYq4duhGRmqGRFdun39BnOIl6PNP+JdeU0+WMUj2P+
 eYR8E9sxNWbMjC0xj5R58r/lESJYEsYLeELAl3T9c2p5m9r0W1Ltf5yegZ8PK4qHl6GM5sOU3c6
 Bhtusb7NrV+zM54HQ2OA6AOKxP/JpiioZtgBwgKbgnEITi9hIGIFAWpwqdfBO2IYdNFPtbXP2wK
 nAr5V4bQBRSTPOPHu12kpP8hWuYE0nr5hqN6f4U9FkNw27Jx+yVWU1mbdTv2CD9n+FIWCFp5l20
 aWOCb59H4CaShJu9+9spP9TLPYWnmEjC1xIn3DY++ICO9yFbUw5SC7YVeH4T71anHt9Za27ip1C
 bVHqt4yuw5VnM3ZdUk6xjnEyhy+1XEFGD9lDnAkg9vgznSL5rhyfU/to4qB5S5nrqQSdMA+8KcY
 sbvEU2L9uuuLJ2w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[debian.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:naup96721@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:kernel-team@meta.com,m:leitao@debian.org,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13996-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B0AF574B1FA

When io_ring_buffers_peek() grows a provided-buffer bundle, it allocates
a new iovec array and points arg->iovs at it. The KBUF_MODE_FREE cleanup
added at the end of the function then does kfree(arg->iovs), which frees
this freshly allocated array that is about to be returned to and used by
the caller, instead of the old cached iovec (org_iovs) it was meant to
release. The caller reads the now-freed array, resulting in a
use-after-free, easily triggered by the liburing recv-bundle-short-ooo
test:

  BUG: KASAN: slab-use-after-free in io_recv+0x4bc/0xc60
  Read of size 8 at addr ffff00037b20c240 by task recv-bundle-sho
   io_recv
  Allocated by task:
   __kmalloc_noprof
   io_ring_buffers_peek
   io_buffers_peek
   io_recv
  Freed by task:
   kfree
   io_ring_buffers_peek
   io_buffers_peek
   io_recv

Free org_iovs instead, and only when it was actually replaced by a new
allocation. On the access_ok() failure path the new array is already
freed and the request is left pointing at the original iovec, so nothing
needs to be released at this point in that case.

Fixes: cd053d788c3f ("io_uring: fix dangling iovec after provided-buffer bundle grow failure")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/kbuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index b6b969b55e122..07d81dc7cbe29 100644
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
base-commit: bee763d5f341b99cf472afeb508d4988f62a6ca1
change-id: 20260713-io_uring_dangling-87c23d568135

Best regards,
--  
Breno Leitao <leitao@debian.org>


