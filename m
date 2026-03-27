Return-Path: <io-uring+bounces-12875-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0HuXMJbtxWlTDQUAu9opvQ
	(envelope-from <io-uring+bounces-12875-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 03:38:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E85CD33E6C1
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 03:38:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 66D9D30E1FA6
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 02:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B38346E5E;
	Fri, 27 Mar 2026 02:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=carlini.com header.i=@carlini.com header.b="tWgVCkSY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="b/fnW9Zf"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C1F346AC6
	for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 02:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774577908; cv=none; b=Gw6B9vhYiDfGsEYuVquZn09GADnJMGtFiZyVG5Xdod5MIHbur9R70f5YXSpwYzm+0bx+LF5YKGLwjggC15NuRYd9PrCEpsX6nRnG3gzDWdCoyuk3qTsx0jsnNZMMCKM9Xvg2Na/tgsgYwqmkHZ1JEO3ssyO7pwKFK3j3vxp0N3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774577908; c=relaxed/simple;
	bh=V2paLFxzlaRJBVM4Gv5VCShG8jC+vTGiEONfo2xBj7g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r4E6YuXY70uBGjer0VemgUZfN5whYQCRyBmZuogrBxKLykAXgFQdEIJmcFKvI9xIldKVGHp7jcWxaTRokaV7JJMKFHgA4j2FPGN7hAsrlbIJXOAn4toVx/m99jX85NhTB1d3em+XowBJPbaOstfeNsg4rL9Wmx1hiqNycwnm3vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=carlini.com; spf=pass smtp.mailfrom=carlini.com; dkim=pass (2048-bit key) header.d=carlini.com header.i=@carlini.com header.b=tWgVCkSY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=b/fnW9Zf; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=carlini.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlini.com
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8B0001400280;
	Thu, 26 Mar 2026 22:18:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 26 Mar 2026 22:18:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=carlini.com; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1774577905; x=1774664305; bh=iOFN5K3RVjBjQS53+oJpb
	WyBOcTQQsip2+L54ScJ9C4=; b=tWgVCkSY40E60kJPbI6B0tR24si1RrEC/LKAV
	f9REDRM4iDQ+dTAnW3qH6VVIJXGXqLvBaF4tRolp44N75GMQe7xuwvpeJ35OuZ2I
	tSqMnwQCiQc5sEbcjy979P/est2j5wh1gO59xwUi16mSjUyOtto2SASpXrvs6p/C
	sXGGmXFFvxGHUoWxAB9UEAipD5jvlBT1VaO0Tcf/3FxJgO4RRq7aODSkty6hA3r5
	pyseYF3DHoCDBmUWWIUXddJpjiBoFu6g22jWoRL8sUF3RipfLuO96nmiDkeXJdo0
	Crt1i5uwb5ajcVVEHmmOAPrCDxHF82t4voZY+OzGxVRXThHLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1774577905; x=1774664305; bh=iOFN5K3RVjBjQS53+oJpbWyBOcTQQsip2+L
	54ScJ9C4=; b=b/fnW9ZfhXzlh41sLirxtv22rSTS6g27w9X3n33XtV3m7qxNt2H
	wzsklCN40lrNf0noVIXNlpnirPjkGnuTiVaLpThb5NtnlUjvPHnGeR6ccMLrcB8V
	jiiJv2pEkADqER8lnGxRv0SM/jUDxvBO0zatsdztZL6VwK8jtfVqnnihcUKWikth
	MUBq6wXc+I34u0IKhBJTMJrlmW1MSOIltjZ/YKw509PY6DN+27ivWYJzbLh9M6R+
	a9ep+Bj5gU1f25vSkrSpsi7kHBCK9Qbf897uzfpx8SHURuFvDAPU2lgkQPjiE3Hw
	T5ANzFn7TA41gdkm043/l8lKYpD7jjYSWPA==
X-ME-Sender: <xms:8OjFaQPm9HCvikb1eOCBAWSAL8mkKygGwtWxmNbGSKshIFVLu34guw>
    <xme:8OjFad9h3ybKh0lXtT2EVqQiTFkg6loWU7Z_B7lVk68zdud3y2FXkuWSfsAHV5hdR
    fq4FzBVjcIkA-_quCyX4e2HbNCIV7nQ9ZjJototKzKWR3bp4icSYg>
X-ME-Received: <xmr:8OjFacQTiUgO0fpWOvEK0GIxlPuGerPnhxge1FOvu4kqu9SrxC0goFbHJ284NLRpMy19AZ06GfIIJI76uz4mE4KrWCj3bwlxxNLodzYILrgjUjAaFkDJHi2lBWmd480HO1rc2pZG8u5fWcTh5IY68Nw99hfa3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdeltdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepnhhitghhohhlrghs
    segtrghrlhhinhhirdgtohhmnecuggftrfgrthhtvghrnhepjeelfeeuieduheehheefje
    ffvdetvdefuedttedvheefteffvdefveelheffgfejnecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepnhhitghhohhlrghssegtrghrlhhinhhird
    gtohhmpdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegrgi
    gsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtohepkhgsuhhstghhsehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehnihgthhholhgrshestggrrhhlihhnihdrtghomh
X-ME-Proxy: <xmx:8OjFaXmQ7xOpX5wa8cVulqLz6SqPyz8xBLIjQgE_wSfujzracjOI6w>
    <xmx:8OjFaURvmoOwe4F1wHXeKgu_v79TzMxWkEU1g4Tjf35sHK7Ge0rmfw>
    <xmx:8OjFadPF_qHqXSnz5VpsXnS8Q4e1e5TqmoliOHmT1sRfsrrE2kCyqg>
    <xmx:8OjFaVXgpL_18i4TNIfp8b0YV1SrS3x1c_FK9FVC3IfVf_0-BNnRKw>
    <xmx:8ejFacaDjJyyZTmLBFJqumD-14jCIUthgzE4rPOf7lyD7KEkqeptU7-P>
Feedback-ID: i78b949e2:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Mar 2026 22:18:24 -0400 (EDT)
From: nicholas@carlini.com
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Nicholas Carlini <nicholas@carlini.com>
Subject: [PATCH] io_uring/fdinfo: fix OOB read in SQE_MIXED wrap check
Date: Fri, 27 Mar 2026 02:18:23 +0000
Message-ID: <20260327021823.3138396-1-nicholas@carlini.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[carlini.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[carlini.com:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12875-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[carlini.com:+,messagingengine.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nicholas@carlini.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,messagingengine.com:dkim,carlini.com:dkim,carlini.com:email,carlini.com:mid]
X-Rspamd-Queue-Id: E85CD33E6C1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Nicholas Carlini <nicholas@carlini.com>

__io_uring_show_fdinfo() iterates over pending SQEs and, for 128-byte
SQEs on an IORING_SETUP_SQE_MIXED ring, needs to detect when the second
half of the SQE would be past the end of the sq_sqes array. The current
check tests (++sq_head & sq_mask) == 0, but sq_head is only incremented
when a 128-byte SQE is encountered, not on every iteration. The actual
array index is sq_idx = (i + sq_head) & sq_mask, which can be sq_mask
(the last slot) while the wrap check passes.

Fix by checking sq_idx directly. Keep the sq_head increment so the loop
still skips the second half of the 128-byte SQE on the next iteration.

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Signed-off-by: Nicholas Carlini <nicholas@carlini.com>
---
 io_uring/fdinfo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 80178b69e05a..6b5609f1db60 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -119,12 +119,13 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
                     sq_idx);
                 break;
             }
-            if ((++sq_head & sq_mask) == 0) {
+            if (sq_idx == sq_mask) {
                 seq_printf(m,
                     "%5u: corrupted sqe, wrapping 128B entry\n",
                     sq_idx);
                 break;
             }
+            sq_head++;
             sqe128 = true;
         }
         seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu, "
--
2.39.5

