Return-Path: <io-uring+bounces-13903-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id YXFSLfD0S2q/dgEAu9opvQ
	(envelope-from <io-uring+bounces-13903-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 20:33:20 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 525547148CA
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 20:33:20 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cVDysh2h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13903-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13903-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A0228300B5A5
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 18:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228603B813D;
	Mon,  6 Jul 2026 18:33:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A28357D0E
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 18:33:16 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783362798; cv=none; b=I5+FAT7ljrG6KuTHTMZLavLJLHYqfAvnSe11gUwQAEaNKQZFqW59kHK9dGwkqaMJz93Aj+jUpqZOzwzLl/SPrQhadt58ckldbWCtCrpmnqlhF/kY8IKG9G/ATbIyNRVb7Aa1utkx/qmzEO54zTc35j4XpLlvFV5m2WeacfRjlFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783362798; c=relaxed/simple;
	bh=q3Biw9dVViTriSRGhp9mOH4a90WIr48NK6MQu3wHl5A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GhQXGbSmd9RWbYiOfjxzn2N7i/OhJBPNEVPchScUJN0Tuto22SoY9J+X5uGzQ8JOja6NFeusra/+DCk/os+EtriPlqiXFbE5MchPnyMc4FhNlMnqUauqz9Rrd2fNUn3P0T9kmjGGLmuKS95rUAJNIUNLJw0LYkji7mh896dvThU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cVDysh2h; arc=none smtp.client-ip=209.85.214.179
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cc80b585bfso14631255ad.0
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2026 11:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783362796; x=1783967596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EhzAaTVsqENZ7jpjX8qsNEQ/QhOMPWhppRHzOqJiw64=;
        b=cVDysh2hhOMnR157X/JsBgWaZSQAm+aTsW+9GYH5QQgsY+u3ESwRw5PRfOk13BO5n8
         RRA1JdYo4cKkQVJAoWYnGZk6yvioRq98/zQ0+o+JpxPgX/3Ga8lnDT/ZOFLthg0HUF/J
         4vgA0q4cHXWHCptvGt9RT6eI2VPyYgstJSwQ5SYDmch1Mip9GPnHOupSsoPWd4o6XYX0
         jBmprwSYUbQQ2ISpAsQ+Zf0kzbFhlLDIKtlwJSAq5zJVx7E1DWGr1+1xu4Fcavzr6c3r
         ltilmPh0Gf6KuytG2OEpW34S86jUrVc2V1owQLTXvG+B7ni35cjldELxAL3uj89hFK+n
         ie7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783362796; x=1783967596;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EhzAaTVsqENZ7jpjX8qsNEQ/QhOMPWhppRHzOqJiw64=;
        b=PTUHrU1JYtIEKYZo+FRaVXHgm1yD+2qtqEJVLN8W+Yf2ajzmDK/F3itQyBU5JPiTMA
         COMoD9lgOjaTdbAUh2/olPUpubVT+KgEj8xr/CKCNFrmeF+yQ4Az7Mt3jTgZjdfuA2E6
         P5HFfTLgsB89wMAwuGPMtR8mNMUhupPh0qJfK79bsPUWgWfGSroI8TiJHBhVM3xggTuW
         ryTnDjaPN957z1E8lN/DQyfKpcPxcl9vGsXfg0IV0jGMpqkEHuaUQnoqMgp1DB4Ahty1
         qczdlVrT5D+Qh7/syQ6VfYa8zMVfTX/yzldG9dUoubKSTnVEObl+7AxkvxHqOixoYdIa
         NCng==
X-Forwarded-Encrypted: i=1; AHgh+Roc4tcruPUxZ/+PIIk1acVCfNWRCNaYTpjYKK725SqWPIYRjfoBfM8LwS3z+utLthv9qSxrT5ji6A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxqASqYFcItojnY7VMDwQb39QosdKb/Tqb3xUWKvwOFjDxtNJz+
	g0fNh42m9nvtOmGeVbeVQitj1OxLMyIzaLyvvQaQ54FnmkngI0eAKI1N
X-Gm-Gg: AfdE7clr17Aw3ydZmhp5zyfH3i2hyiGtPDMMEtatLBT7iNRbpMNUci/hBJbpaXPagPt
	y2+5X1d9HpflcD/3rkihYqrrlHY9mysYbclOUkVqrw3ze9ekVK8T0WmWZ6NqI0rIfej7QJ+eiWF
	FDr34c48Lt8rQoI1riAggX5amzTwTg8Ei/Gr1Egl7MAYXrRpltROKiVDHlWavhi4/7cqp7qJ3EF
	5O7LjtuSY7RoC0QU1yPvbyycLQTEUAGi+EvrdvR9fcT54CEX133krSksCzT1wy6jiRte93jrnP8
	cU3i+jujCYGY05iPaIoHPedR85xtM7RZVNjYJYKC3I6Vqswi/w/eal/TioL2ulkG6R2ZElx8NxR
	50XBfUm9dCfMWvSwiVTo/Se6uCxahf+h8wjwTN11gYizishdMY+xTehkv0V5sDDvyz6H9pVDYDF
	xCjcENAYlItt2IdJHiVqcrOKefkv77tPdR3nwesN4KNH+8XQzB3haDaOg=
X-Received: by 2002:a17:903:3845:b0:2ca:ed41:d337 with SMTP id d9443c01a7336-2ccbf189068mr20617915ad.43.1783362796043;
        Mon, 06 Jul 2026 11:33:16 -0700 (PDT)
Received: from naup-virtual-machine.localdomain ([140.113.139.102])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad7894b06sm55235405ad.77.2026.07.06.11.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 11:33:15 -0700 (PDT)
From: Hao-Yu Yang <naup96721@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk,
	io-uring@vger.kernel.org,
	Hao-Yu Yang <naup96721@gmail.com>
Subject: [PATCH v2] io_uring: fix dangling iovec after provided-buffer bundle grow failure
Date: Tue,  7 Jul 2026 02:33:04 +0800
Message-Id: <20260706183304.919275-1-naup96721@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13903-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:naup96721@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 525547148CA

When growing a provided-buffer bundle, the old cached iovec is freed
before the new buffers have all been validated. If validation fails, the
request still points at the freed iovec, which can be freed again during
completion cleanup.

BUG: KASAN: double-free in io_vec_free+0x2c/0x90
Freed by task 73:
 kfree+0x104/0x3b0
 io_vec_free+0x2c/0x90
 __io_submit_flush_completions+0xc03/0x1e40
 io_submit_sqes+0xdb5/0x2310

Allocated by task 73:
 io_ring_buffers_peek+0x559/0xc60
 io_buffers_select+0x1c1/0x460
 io_send+0x770/0x1050

Fix this by deferring the free of the old cached iovec until validation
has succeeded. On failure, free the newly allocated iovec and leave the
request pointing at the original one.

change log:
 v2: slimming v1 patch

Fixes: 46800585ae04 ("io_uring/kbuf: validate ring provided buffer addresses with access_ok()")
Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>
---
 io_uring/kbuf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3cd29477fff2..b6b969b55e12 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -287,8 +287,6 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		iov = kmalloc_objs(struct iovec, nr_avail);
 		if (unlikely(!iov))
 			return -ENOMEM;
-		if (arg->mode & KBUF_MODE_FREE)
-			kfree(arg->iovs);
 		arg->iovs = iov;
 		nr_iovs = nr_avail;
 	} else if (nr_avail < nr_iovs) {
@@ -330,6 +328,9 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		buf = io_ring_head_to_buf(br, ++head, bl->mask);
 	} while (--nr_iovs);
 
+	if (arg->mode & KBUF_MODE_FREE)
+		kfree(arg->iovs);
+
 	if (head == tail)
 		req->flags |= REQ_F_BL_EMPTY;
 
-- 
2.34.1


