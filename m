Return-Path: <io-uring+bounces-13216-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gLfEF4KM92mIiwIAu9opvQ
	(envelope-from <io-uring+bounces-13216-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 19:57:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D15E14B6DE2
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 19:57:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 005AC3005653
	for <lists+io-uring@lfdr.de>; Sun,  3 May 2026 17:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5282E1DF27D;
	Sun,  3 May 2026 17:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TkHfwYmX"
X-Original-To: io-uring@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA1F399013
	for <io-uring@vger.kernel.org>; Sun,  3 May 2026 17:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777831039; cv=none; b=Wv1ZXZSR3qQmtptbfbnLhyRO6ldQW7FDv/s8FvoXandG7IsLTadjBaneI016yj7Uhah1RlHjwHMcvaP4MNPrQujhC4VtdAVAjBmlegAR93v1NhEHXwdjH28IAJ709vUlGcUfKqHdw1Us1jVlLHe7v0dLBx+gxpeaI9BkVublQ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777831039; c=relaxed/simple;
	bh=FzHs+94uTFT4cVjKIzOzCn7gnM5Jt6SfgpXcUuSXMVU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BfsZ5v+ezBaanNdvEH6fn7CXFWxhgYN7plBmGQAiz45wckZ0rxLzyYXnvqzbhSs61dYFPqRJe29UcYJqRtGpT6zkzNEXRgFYWc7CblnjlbeLd7eYc807rZ76/OkXrDySC09a3oFXursKlBZHXitUUAkxt0eMet4EAaS8G5bUaww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TkHfwYmX; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777831036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=p6L8IlxAGVA0SFEKAQm1XqS4T65AoVI5DWrbixUi4tc=;
	b=TkHfwYmX8UGtRxA0SOG3L2BrJlfYrCbjqOHn1Dni9YzE+TpAOP1xWVfwdhPED2x3Cs6g/I
	MGqa2pVy9rLoqVRTK+t4l7PW/6TthObMYxLm7aKuGRvq3WEekqBgMW4RV2IhiptMLG+Yji
	NxnhoCbiz/pGH8SgEog6Jbet7R3HV8M=
From: Yufan Chen <yufan.chen@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yufan Chen <ericterminal@gmail.com>
Subject: [PATCH] io_uring/eventfd: reset deferred signal state
Date: Mon,  4 May 2026 01:57:10 +0800
Message-ID: <20260503175710.37209-1-yufan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1336; i=ericterminal@gmail.com; h=from:subject; bh=V82d6lRsNuUybyUKYpe9jREanrhNRHFkcRXeCczThME=; b=owGbwMvMwCXWM/dCzeS3H+sZT6slMWR+71pecbngbtHZg0rKrmunVuUX3c6dvuph8MHbm4p1z s7b6q/8vWMiC4MYF4OlmCLL3f/75uZ63ZpznftwLswcViaQIdIiDQxAwMLAl5uYV2qkY6Rnqm2o Z2ikY6BjzMDFKQBTPcOc4a/A8fniqmatHozmUzqqq+eYNs3cmynHGSci+LXk9cyphgcZGR4z/Ag 7pGzmal0uXWd8e8nPh1Ztu0/4lsTHhD7VYv/bwA8A
X-Developer-Key: i=ericterminal@gmail.com; a=openpgp; fpr=DDFFBE9D6D4ADA9CD70BC36D8C9DD07C93EDF17F
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D15E14B6DE2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13216-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yufan.chen@linux.dev,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:dkim,linux.dev:mid]

From: Yufan Chen <ericterminal@gmail.com>

Recursive eventfd wakeups must defer io_uring eventfd signaling because
eventfd_signal_mask() rejects reentry from eventfd wakeup handlers. The
io_ev_fd ops bit tracks an outstanding deferred signal so that the same
rcu_head is not queued twice.

That bit is only set today. Once the first deferred callback runs, later
recursive notifications still see the bit set and skip queueing another
deferred signal. This can leave new completions without a matching eventfd
wake after the first recursive deferral.

Clear the pending bit before issuing the deferred signal. If the wakeup
path recurses while the callback runs, a new signal can be queued for the
next RCU grace period while the current callback keeps its reference until
it returns.

Signed-off-by: Yufan Chen <ericterminal@gmail.com>
---
 io_uring/eventfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 3da028500f7..d656cc2a0b9 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -43,6 +43,7 @@ static void io_eventfd_do_signal(struct rcu_head *rcu)
 {
 	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
 
+	atomic_andnot(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops);
 	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 	io_eventfd_put(ev_fd);
 }
-- 
2.47.3


