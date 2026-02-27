Return-Path: <io-uring+bounces-12462-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2FMeEPvQoWkfwgQAu9opvQ
	(envelope-from <io-uring+bounces-12462-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 18:14:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E031BB499
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 18:14:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7AFD33039301
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B8D36D4EC;
	Fri, 27 Feb 2026 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgaayLEn"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CA135BDAF;
	Fri, 27 Feb 2026 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772212428; cv=none; b=tBvOQrkr+tIlSHjCCGxvOYNRnNNREpU4RqJlGFsiFL13qe2herc8MCD3eKh/3/GZUkHGfPheilnDSmIfpKT/9AHRBgXo3YSycAiV7Dtqo1YgWpeNrFNunQQO9xpy1nWGWZTDKnaL9C3l/XwLW+Jbmt3ZVwhS6XSCr95daZS1ubg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772212428; c=relaxed/simple;
	bh=N45sXiuxe+FZCdGi0FyZZPJ65pd2QE3MQ8t83TuxlfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAuYXEl+yPWyEaT+s+e+wNb4N82yfgiOHPwL19kgOX3DtV5A35QRJ2dsA/AcBxI095sU2ppXjx0VxSnDiTwqXhCDmCTAKb29W0+zrbsYtNyPopTNPRQOpVrj26k6WC1v8f9K/tVUlBLpHvIwD57LQXKknh9BnChD1LmWxOwahG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgaayLEn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDE4C2BCAF;
	Fri, 27 Feb 2026 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772212428;
	bh=N45sXiuxe+FZCdGi0FyZZPJ65pd2QE3MQ8t83TuxlfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgaayLEn83G7zx/Kxl9Tp6DCtjruzFV5qZjMM8s6IBx8Ck60pPzGjAaYgadyagSaT
	 05Opgrqgk45s5B/0l5h1FEyllZqe/Efb5WGeC+FcTTk2hLYLZBapQoh4ag3X9fInOV
	 cYUviq18dLk90O7dkCAycHKgq4Ij273WsxcHVyEuSFF557VDiPX7YWBlbOmg9q9GsY
	 R7qESQCkfG0+96XaJsX1zmXgRsTcwuQS0OgkgpAhIHqQaEZahoWBa4wD2XI8m0NMH9
	 mRkA5+LeLoJVJZJopnGOT/p0Bi0WPOWiHi3qk6e/mZPBUV3QB6CwSWsLFCb6g0+DFU
	 6d/H2ABRI6fyQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	dw@davidwei.uk,
	jdamato@fastly.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 3/3] selftests: drv-net: iou-zcrx: allocate hugepages for large chunks test
Date: Fri, 27 Feb 2026 09:13:05 -0800
Message-ID: <20260227171305.2848240-4-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260227171305.2848240-1-kuba@kernel.org>
References: <20260227171305.2848240-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,davidwei.uk,fastly.com,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-12462-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[cfg.target:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,fastly.com:email,davidwei.uk:email]
X-Rspamd-Queue-Id: A3E031BB499
X-Rspamd-Action: no action

The large chunks test needs 2MB hugepages for its mmap allocation,
but the test system may not have any pre-allocated. Ensure at least
64 hugepages are available before running the test, and restore the
original value on cleanup.

While at it strip the stdout, it has a trailing new line.

Before:
  ok 5 iou-zcrx.test_zcrx_large_chunks # SKIP Can't allocate huge pages

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: shuah@kernel.org
CC: dw@davidwei.uk
CC: jdamato@fastly.com
CC: linux-kselftest@vger.kernel.org
---
 tools/testing/selftests/drivers/net/hw/iou-zcrx.py | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
index 1649c23e05e2..66dd496ec5cf 100755
--- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
@@ -135,13 +135,21 @@ SKIP_CODE = 42
 
     cfg.require_ipver('6')
 
+    hp_file = "/proc/sys/vm/nr_hugepages"
+    with open(hp_file, 'r+', encoding='utf-8') as f:
+        nr_hugepages = int(f.read().strip())
+        if nr_hugepages < 64:
+            f.seek(0)
+            f.write("64")
+            defer(lambda: open(hp_file, 'w', encoding='utf-8').write(str(nr_hugepages)))
+
     single(cfg)
     rx_cmd = f"{cfg.bin_local} -s -p {cfg.port} -i {cfg.ifname} -q {cfg.target} -x 2"
     tx_cmd = f"{cfg.bin_remote} -c -h {cfg.addr_v['6']} -p {cfg.port} -l 12840"
 
     probe = cmd(rx_cmd + " -d", fail=False)
     if probe.ret == SKIP_CODE:
-        raise KsftSkipEx(probe.stdout)
+        raise KsftSkipEx(probe.stdout.strip())
 
     with bkg(rx_cmd, exit_wait=True):
         wait_port_listen(cfg.port, proto="tcp")
-- 
2.53.0


