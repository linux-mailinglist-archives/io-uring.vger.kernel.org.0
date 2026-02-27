Return-Path: <io-uring+bounces-12459-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oLPpIVjRoWkfwgQAu9opvQ
	(envelope-from <io-uring+bounces-12459-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 18:16:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DA63B1BB4CF
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 18:16:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5DAD33070B1A
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BADDC3542CF;
	Fri, 27 Feb 2026 17:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="On5ff6dj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9892A2C2349;
	Fri, 27 Feb 2026 17:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772212426; cv=none; b=djx7kTix1x34wgAr/lSH1M8gE/uxMdWsLJbsHIwvOIuF/65tvbzNd7q/H1d7BX42FsW9WEy7bdIfyHJOCJyWEm1PnIJLC5RldsId7TZ1dcjnl4MBgaLNkW8T0aKetHrez5dwjH738/5+gIlCFvgvH7znLz6l40cJxSwjQdWzCfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772212426; c=relaxed/simple;
	bh=yjedRM/ZBFr2Y3sRnzCg+CW51fCSaBa+EMj3kFmGv/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cMUthTdoyb+visdlEuoslJCM+LITrBrAe0WCDc/nl2b1lqmf5iy7poq8cpyfQBLrSpT55bF/cUH+GCa48vU74CHpVNNLTuzyxwuer/Aw382fTZH2xC9r+4JP+2ybIo1FWyE572KZ2AK0m8GAOkqNmkrvBuh2r2/5DPxehQm1jxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=On5ff6dj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7715C116C6;
	Fri, 27 Feb 2026 17:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772212426;
	bh=yjedRM/ZBFr2Y3sRnzCg+CW51fCSaBa+EMj3kFmGv/Y=;
	h=From:To:Cc:Subject:Date:From;
	b=On5ff6dj8ELh2vHmTQkiOM1eO9EigtdNTBlnmqJsNGpOCGs8EApObURmW+3vuqY9V
	 Xn4OVn77rs73X8d3XrwWvP2FxzObG1rc+QMtOvh5Z7qBwXsuVI44AoYX6iO3F8/q2F
	 1qNiNjrA+ic75z/AjBHC2lmyIVAl1TfHQ3gp4+kWJiwAfbpizQTVq2Xg4dW+1RV+/9
	 u46PvdCPkLB6dDGh32rICZ3oNSUqxG6EbAHP7sFjsyJblcoEbx4+lxZ1jwDWBxrYHW
	 gE+Ojw2MQw7LpeSNgQkQEidPhfCbInKsTyblriUU8oMsi57bsq2iENZsKM5nOcLqd/
	 mJRcF+XTRko0A==
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
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] selftests: drv-net: iou-zcrx: improve stability and make the large chunk test work
Date: Fri, 27 Feb 2026 09:13:02 -0800
Message-ID: <20260227171305.2848240-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
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
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,davidwei.uk,fastly.com,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12459-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DA63B1BB4CF
X-Rspamd-Action: no action

The iou-zcrx test hasn't been passing in NIPA, I assumed it's because
we're missing iouring changes, but it's still failing after the merge
window. Turns out there was a bug in the implementation which was fixed
separately via the iouring tree. With that out of the way the tests
are passing but flaky. Patch 1 deals with the flakiness.

While looking at this I also noticed that the large chunk test isn't
running at all. So fix and enable it (patches 2 and 3).

Jakub Kicinski (3):
  selftests: drv-net: iou-zcrx: wait for memory provider cleanup
  selftests: drv-net: iou-zcrx: rework large chunks test to use common
    setup
  selftests: drv-net: iou-zcrx: allocate hugepages for large chunks test

 .../selftests/drivers/net/hw/iou-zcrx.py      | 57 ++++++++++---------
 1 file changed, 31 insertions(+), 26 deletions(-)

-- 
2.53.0


