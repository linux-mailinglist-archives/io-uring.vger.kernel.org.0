Return-Path: <io-uring+bounces-12461-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJazGuXQoWkfwgQAu9opvQ
	(envelope-from <io-uring+bounces-12461-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 18:14:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B21DE1BB482
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 18:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D9F83300D61D
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1622361DD6;
	Fri, 27 Feb 2026 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUWgMCUp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC81361DBE;
	Fri, 27 Feb 2026 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772212427; cv=none; b=Mn/F6byJvNSZZ7M4GBcrQRpsv5QQ9CVg9aYTisM+o4ER2g3yPGaSS6jrF1fvM1qRvSXwDFEKIhsXzNpAxzvkPQauGYj3jDU1l66OOotfQ5wLJtCgnUxPe5SHU79LYcVC5h08+F+P/yCZKQru5kB7CxTqCKFZyIbOPrBXWIFU//M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772212427; c=relaxed/simple;
	bh=ZJu7dxMaIgjiwMcOUFBFe0tnB3LrvdIbeuwcOXxKVwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+w2whF3Ov2EGTmOUjLX64bY30rpoHfRmaLRRBiJRm/Fdk/R/pdnYGakEWrocjCAPbO40lTvL4vHoP0OwJgZvsspStesvt1kYTO6JO5n10rebU3IaY06+umR2m8eU8ejmMJkEWYXR2jI8Pmnbc6euOMBHTruKqWx4Y/+zkHmxTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUWgMCUp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C6EC2BC87;
	Fri, 27 Feb 2026 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772212427;
	bh=ZJu7dxMaIgjiwMcOUFBFe0tnB3LrvdIbeuwcOXxKVwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUWgMCUpismwHXdyzPE/RI0KotmmOJiuf/zohB34NtkryXTAUo5iI/NJ4ykRhhpI2
	 c+7EyiMTKoYW4z+wCehRY0dJh+O/DXkLAuT2auTzAsPhhSYc4zbpMq7ajbDmOxMCdx
	 kpWN9sKRZc5yyuuv6CZzTPRi/dY/PMxMy3CB5ZIMgWMbgXwNS4LO06vZmsHhffkfMC
	 wDZx8oZo3FRgC0smDWMSQrNaLBSEgaM9eLO8w/43aI+ID83SCkkNeS7iyx2QJNnSs/
	 mze7Sz15twUS1o+pemSsl69YhT697GvVHfdlVVJ1m9NRURbeXn/lxuiCylkrjTAjNv
	 XJM1UL6ED0YDg==
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
Subject: [PATCH net-next 2/3] selftests: drv-net: iou-zcrx: rework large chunks test to use common setup
Date: Fri, 27 Feb 2026 09:13:04 -0800
Message-ID: <20260227171305.2848240-3-kuba@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,davidwei.uk,fastly.com,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-12461-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,davidwei.uk:email,iou-zcrx.py:url,fastly.com:email,cfg.target:url]
X-Rspamd-Queue-Id: B21DE1BB482
X-Rspamd-Action: no action

Commit a32bb32d0193 ("selftests: iou-zcrx: test large chunk sizes")
and commit de7c600e2d5b ("selftests/net: parametrise iou-zcrx.py with
ksft_variants") landed at similar time. The large chunks test was
actually not included in the list of tests, so it never run.
We haven't noticed that it uses the old-style helpers
(_get_combined_channels, _get_current_settings, _set_flow_rule)
that were removed by the other commit.

Rework test_zcrx_large_chunks to reuse the single() setup function
and add it to the ksft_run cases list so it actually gets executed.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: shuah@kernel.org
CC: dw@davidwei.uk
CC: jdamato@fastly.com
CC: linux-kselftest@vger.kernel.org
---
 .../selftests/drivers/net/hw/iou-zcrx.py      | 31 ++++---------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
index c27c2064701d..1649c23e05e2 100755
--- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
@@ -135,36 +135,16 @@ SKIP_CODE = 42
 
     cfg.require_ipver('6')
 
-    combined_chans = _get_combined_channels(cfg)
-    if combined_chans < 2:
-        raise KsftSkipEx('at least 2 combined channels required')
-    (rx_ring, hds_thresh) = _get_current_settings(cfg)
-    port = rand_port()
-
-    ethtool(f"-G {cfg.ifname} tcp-data-split on")
-    defer(ethtool, f"-G {cfg.ifname} tcp-data-split auto")
-
-    ethtool(f"-G {cfg.ifname} hds-thresh 0")
-    defer(ethtool, f"-G {cfg.ifname} hds-thresh {hds_thresh}")
-
-    ethtool(f"-G {cfg.ifname} rx 64")
-    defer(ethtool, f"-G {cfg.ifname} rx {rx_ring}")
-
-    ethtool(f"-X {cfg.ifname} equal {combined_chans - 1}")
-    defer(ethtool, f"-X {cfg.ifname} default")
-
-    flow_rule_id = _set_flow_rule(cfg, port, combined_chans - 1)
-    defer(ethtool, f"-N {cfg.ifname} delete {flow_rule_id}")
-
-    rx_cmd = f"{cfg.bin_local} -s -p {port} -i {cfg.ifname} -q {combined_chans - 1} -x 2"
-    tx_cmd = f"{cfg.bin_remote} -c -h {cfg.addr_v['6']} -p {port} -l 12840"
+    single(cfg)
+    rx_cmd = f"{cfg.bin_local} -s -p {cfg.port} -i {cfg.ifname} -q {cfg.target} -x 2"
+    tx_cmd = f"{cfg.bin_remote} -c -h {cfg.addr_v['6']} -p {cfg.port} -l 12840"
 
     probe = cmd(rx_cmd + " -d", fail=False)
     if probe.ret == SKIP_CODE:
         raise KsftSkipEx(probe.stdout)
 
     with bkg(rx_cmd, exit_wait=True):
-        wait_port_listen(port, proto="tcp")
+        wait_port_listen(cfg.port, proto="tcp")
         cmd(tx_cmd, host=cfg.remote)
 
 
@@ -176,7 +156,8 @@ SKIP_CODE = 42
         cfg.ethnl = EthtoolFamily()
         cfg.netnl = NetdevFamily()
         cfg.port = rand_port()
-        ksft_run(globs=globals(), cases=[test_zcrx, test_zcrx_oneshot], args=(cfg, ))
+        ksft_run(globs=globals(), cases=[test_zcrx, test_zcrx_oneshot,
+                                        test_zcrx_large_chunks], args=(cfg, ))
     ksft_exit()
 
 
-- 
2.53.0


