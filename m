Return-Path: <io-uring+bounces-13664-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 8wXvBfYNKmrThwMAu9opvQ
	(envelope-from <io-uring+bounces-13664-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 03:23:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 162CF66DA07
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 03:23:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=mwFzfIDF;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13664-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13664-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 040023019827
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 01:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFEAB15B971;
	Thu, 11 Jun 2026 01:22:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EFD2AD16
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 01:22:54 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781140978; cv=none; b=AqpBpFBe5Bkv0llwZ/kNIEVEhx1zc7WBpZ01jQU0I3pSQwR2jBneZWVTj8zaE8Jo04zmXUDLsx1J8e7KT+iT9hjQP1EW7tS79uujQ4YaCbowjCB8VqsG+w5ZhVdlGiQQi5a8pl9zxKJ43ySkOdp9mEPtDJ24V1RMqSBKHAX5FxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781140978; c=relaxed/simple;
	bh=zdK2an+eoXKmfFbgSjFJ6WW7OSXR9OKiGWwoxwj9P4M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lBTv+dO3YdWJLGHt38AJo1q7EWOFDWUapslmgUwHvEe36gbEUAQ1xFcSLffO/rDypRZbhmAJPGMYfI0aOCRk80XS7HbjZLeyihWkmmjV1LHzYcO7W8vX30DA5qISfJE349FbagFJf9zHmqjqa9EG5iYmosi+VBdRsdt/SlHO+vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mwFzfIDF; arc=none smtp.client-ip=220.197.31.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=9K
	trIFS0+0lDWt//uxf0shKoTGecysxb4lZ3pRnkgck=; b=mwFzfIDFJ2rAsctZq4
	TjoUSYtZG3/wkqOzR0xrhmBVxnxhSDPWijPfIzLyQs4TBf2h3glszZqEYyYj7UiQ
	AImtYq4RyLleSYP1MvdefsaXRI+HsrCtDuVz400ZCnZnZtVU/7hjgUMCH6FLcepn
	fuYX7Q4Glh7DEGIXsJB0XIuEs=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDH773gDSpqbsY_Bg--.28099S2;
	Thu, 11 Jun 2026 09:22:41 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 0/2] io_uring: fix short read links and align link timeout cancel
Date: Thu, 11 Jun 2026 09:22:34 +0800
Message-Id: <20260611012236.3020181-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDH773gDSpqbsY_Bg--.28099S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZrW7CFWUAr4xZrW3ZFW7CFg_yoW8ZFW5pw
	sI93srCr1kAF1jv3WkAa98Ga1vqF15Aa1UJr98Kry0yF1DZr1kArW2qa4vva47JrWqkr4a
	9a1Iga1kuw4UAF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uymh7UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgKgMWoqDeJmdgAA3u
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:yangxiuwei@kylinos.cn,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13664-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[163.com:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 162CF66DA07

This series addresses two independent issues affecting linked requests
behind a link timeout, found while exercising read -> link timeout ->
nop chains on pipes.

1) Short non-regular file read completion (patch 1, bug fix)

__io_read() treats a short read on non-regular files as success and
returns without filling the iov.  __io_complete_rw_common() still
treated ret != cqe.res as failure and set REQ_F_FAIL.  The head request
could therefore post a successful CQE while internally failing the link
chain, incorrectly canceling subsequent linked requests.

2) Pending link timeout cancel (patch 2, behavior alignment)

TIMEOUT_REMOVE and IORING_OP_ASYNC_CANCEL use io_timeout_cancel(), which
only scanned timeout_list.  Pending link timeouts live on ltimeout_list
instead, so cancel/remove by user_data returned -ENOENT even though the
timeout was still armed.

IORING_OP_TIMEOUT_REMOVE with IORING_LINK_TIMEOUT_UPDATE already handles
link timeouts through a separate path.  Extend io_timeout_cancel() to
fall back to ltimeout_list and reuse __io_disarm_linked_timeout(), so
plain remove/cancel behaves consistently.

The two patches are independent and may be applied separately, though
both are needed for full link-timeout chain test coverage.

Patch summary
-------------

 1/2 io_uring/rw: fix link failure on successful pipe short reads
 2/2 io_uring/timeout: cancel pending link timeouts from ltimeout_list

Test plan
---------

Matching liburing tests are submitted separately.  With both kernel
patches applied:

  $ make -C test link-timeout.t
  $ ./test/link-timeout.t

Expected highlights:

  - test_link_timeout_natural_disarm_chain: read=1, lt=-ECANCELED, nop=0
  - test_link_timeout_remove_chain: remove=0, lt=-ECANCELED, read=1,
    nop=0

io_uring/rw: fix link failure on successful pipe short reads
io_uring/timeout: cancel pending link timeouts from ltimeout_list
--
2.25.1

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>


