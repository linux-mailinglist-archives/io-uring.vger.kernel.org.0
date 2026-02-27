Return-Path: <io-uring+bounces-12460-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IP4vFtXQoWkfwgQAu9opvQ
	(envelope-from <io-uring+bounces-12460-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 18:13:57 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C01A91BB462
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 18:13:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4190E300A7F8
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 552613612DC;
	Fri, 27 Feb 2026 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLQpR9hm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319F935F8D2;
	Fri, 27 Feb 2026 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772212427; cv=none; b=lGNMfQg6Q6CV6wImP3feuJG5v2/QVYaqRRt4KHbqvFDyoKou0TUokFzyUXXPXuWVHBzo0kb1YZ+lBJOBQFl7fltZUtg2UlcoWNm5SyDJvB7TCTAISozdp8XFANBT1QuAoNq9dZgh31BGjJWrCSzuY7gCP8BviokG1XuVA2rZ82g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772212427; c=relaxed/simple;
	bh=QWSMk22yfiY5fjmuUAaedsDL4Qt7NFKhxV+lWmuLTvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pc+duxR161Hai+k9rryhMnI9P6EawTo3IkM7Q9d90xLVE2Qcvp46r674GMH7t1IkGcjQbsvT/jGuvw5bVwYh8c3GqhcF+C/hlOuDwuPsD2CGXyTg0pSkQc7+fEyZh6aJxFVkaaNyPus3XZyUCvf2x2ZNFlPH6RXybgU40NJfDE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLQpR9hm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704FFC19421;
	Fri, 27 Feb 2026 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772212427;
	bh=QWSMk22yfiY5fjmuUAaedsDL4Qt7NFKhxV+lWmuLTvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLQpR9hmg5qAtPfjquPREE5LYNkC6D1iXDko5fGBGtq31Dfhok/2RmeVRkOsHd+61
	 PPnFIj0i+0pZaUtcgSWu+73l+O1Ubx+FO72UxK7UTttWMl8gxG2eAI8+uypJTujKIH
	 dy+yq209m7DWW39pXaZ9g3vEcTtSjSCRFVSP+wpAfSiokF7DfpgQVaQ1W92cEmCbn0
	 a0BJn5mLn+J5/eR4/bzzzNNiL3CsLkp936+RUR185wyTGVrRTF+048WOlrnnDXMTeN
	 l2RMK0+hKP8+4NJa05vBv2oSzDS8KAgqorGo1/aqQrv33wm3hWdgnO2miEZs9SDXdp
	 Uq9MacZWwpzqg==
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
Subject: [PATCH net-next 1/3] selftests: drv-net: iou-zcrx: wait for memory provider cleanup
Date: Fri, 27 Feb 2026 09:13:03 -0800
Message-ID: <20260227171305.2848240-2-kuba@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,davidwei.uk,fastly.com,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-12460-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,davidwei.uk:email]
X-Rspamd-Queue-Id: C01A91BB462
X-Rspamd-Action: no action

io_uring defers zcrx context teardown to the iou_exit workqueue.

  # ps aux | grep iou
  ...    07:58   0:00 [kworker/u19:0-iou_exit]
  ... 07:58   0:00 [kworker/u18:2-iou_exit]

When the test's receiver process exits, bkg() returns but the memory
provider may still be attached to the rx queue. The subsequent defer()
that restores tcp-data-split then fails:

  # Exception while handling defer / cleanup (callback 3 of 3)!
  # Defer Exception| net.ynl.pyynl.lib.ynl.NlError:
      Netlink error: can't disable tcp-data-split while device has
                     memory provider enabled: Invalid argument
  not ok 1 iou-zcrx.test_zcrx.single

Add a helper that polls netdev queue-get until no rx queue reports
the io-uring memory provider attribute. Register it as a defer()
just before tcp-data-split is restored as a "barrier".

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: shuah@kernel.org
CC: dw@davidwei.uk
CC: jdamato@fastly.com
CC: linux-kselftest@vger.kernel.org
---
 .../selftests/drivers/net/hw/iou-zcrx.py       | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
index c63d6d6450d2..c27c2064701d 100755
--- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
@@ -2,14 +2,27 @@
 # SPDX-License-Identifier: GPL-2.0
 
 import re
+import time
 from os import path
 from lib.py import ksft_run, ksft_exit, KsftSkipEx, ksft_variants, KsftNamedVariant
 from lib.py import NetDrvEpEnv
 from lib.py import bkg, cmd, defer, ethtool, rand_port, wait_port_listen
-from lib.py import EthtoolFamily
+from lib.py import EthtoolFamily, NetdevFamily
 
 SKIP_CODE = 42
 
+
+def mp_clear_wait(cfg):
+    """Wait for io_uring memory providers to clear from all device queues."""
+    deadline = time.time() + 5
+    while time.time() < deadline:
+        queues = cfg.netnl.queue_get({'ifindex': cfg.ifindex}, dump=True)
+        if not any('io-uring' in q for q in queues):
+            return
+        time.sleep(0.1)
+    raise TimeoutError("Timed out waiting for memory provider to clear")
+
+
 def create_rss_ctx(cfg):
     output = ethtool(f"-X {cfg.ifname} context new start {cfg.target} equal 1").stdout
     values = re.search(r'New RSS context is (\d+)', output).group(1)
@@ -46,6 +59,7 @@ SKIP_CODE = 42
                                 'tcp-data-split': 'unknown',
                                 'hds-thresh': hds_thresh,
                                 'rx': rx_rings})
+    defer(mp_clear_wait, cfg)
 
     cfg.target = channels - 1
     ethtool(f"-X {cfg.ifname} equal {cfg.target}")
@@ -73,6 +87,7 @@ SKIP_CODE = 42
                                 'tcp-data-split': 'unknown',
                                 'hds-thresh': hds_thresh,
                                 'rx': rx_rings})
+    defer(mp_clear_wait, cfg)
 
     cfg.target = channels - 1
     ethtool(f"-X {cfg.ifname} equal {cfg.target}")
@@ -159,6 +174,7 @@ SKIP_CODE = 42
         cfg.bin_remote = cfg.remote.deploy(cfg.bin_local)
 
         cfg.ethnl = EthtoolFamily()
+        cfg.netnl = NetdevFamily()
         cfg.port = rand_port()
         ksft_run(globs=globals(), cases=[test_zcrx, test_zcrx_oneshot], args=(cfg, ))
     ksft_exit()
-- 
2.53.0


