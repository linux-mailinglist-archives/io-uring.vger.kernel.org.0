Return-Path: <io-uring+bounces-13667-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id p5A0IWwPKmo3iAMAu9opvQ
	(envelope-from <io-uring+bounces-13667-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 03:29:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EBC166DA38
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 03:29:15 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=Xpl6wv6r;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13667-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13667-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 03D44307BAD1
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 01:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7523E1E9B37;
	Thu, 11 Jun 2026 01:29:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6220040D586
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 01:29:09 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781141353; cv=none; b=qgVmUErBV/8WXeU3KLPlZEQzWu4+jJlCu9LPKMY8rJEmhYPI1ZRj1DZkMTc5avoHiOQ2WXuU5h3TY0cktYPtvPAFnkTWEuUrn5ZXPW6d7y6I3/H11gzvEEyjtBOkN26MtIfrYmDsoWyPsW8s7JUvwq+rkOpjv6qy45cRZUqD6CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781141353; c=relaxed/simple;
	bh=7VxNMoB4q+WcecMqPkRjPe64x9YIkfslx2YfEO4bJSc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LQ/1IexZ78ElAqd2EouSBtZLpxFiVvcD0O4k69ypo5I0+WOn9q7QwSGb/kyfPyYlT9moYfLMR6Q9o2EBTAU9Fi2VDPufYeZFlME7a7pESUINdcv/vX9f7/yd4KkwGrLpYpzoenf1vUlxGOZ6N61cc2ZvRzyUHpLQ+E0fnfWzT+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Xpl6wv6r; arc=none smtp.client-ip=220.197.31.4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=wc
	gqjUB+dyXH+/MZkf0wqRxwIo8DEa/L2B6dF3HsZzQ=; b=Xpl6wv6rd2U0QA/qiG
	Irtr8n6AmnQyVkPmQnDBdVGmJosDx71HpQ4MYkBA+l8O4Quboo7SE0hBKWQYcr4u
	RvMN819E4nqSutfVVAsrN8Xv2Nxqt8Hqw7jEZO3NJluJm0HqNeo4+jNZhsDDoaIP
	AYV73bNJY+xtf/wRkeSDGzac0=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgCHMwNIDypqb8GyBg--.27485S2;
	Thu, 11 Jun 2026 09:28:40 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 0/2] test/link-timeout: add regression tests for link timeout chains
Date: Thu, 11 Jun 2026 09:28:35 +0800
Message-Id: <20260611012837.3032351-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgCHMwNIDypqb8GyBg--.27485S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFyrCw4xCFWfZF48ur13twb_yoW8Aw45pw
	sIqa9rGF18J3WUZ3WkJanxu3yqvFy8Jw4UJrnrKayrAwn8Zr95Jayaqa4vvasxArZFgw4a
	va18Gan8Jw1DJFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UkxhJUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gj6i2oqD0jWQAAA3C
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13667-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:yangxiuwei@kylinos.cn,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3EBC166DA38

This series adds liburing regression tests for read -> link timeout -> nop
chains on pipes.  The tests complement two independent io_uring kernel
changes submitted separately:

  - io_uring/rw: fix link failure on successful pipe short reads
  - io_uring/timeout: cancel pending link timeouts from ltimeout_list

Without the kernel fixes, short pipe reads can incorrectly fail the link
chain and cancel subsequent requests, and TIMEOUT_REMOVE against a pending
link timeout returns -ENOENT because only timeout_list was scanned.

Patch summary
-------------

 1/2 test/link-timeout: add natural disarm chain with short pipe read
 2/2 test/link-timeout: add link timeout remove tests

Test cases
----------

  - test_link_timeout_natural_disarm_chain (patch 1)
    read(LINK) -> link timeout(LINK) -> nop, with a 1-byte pipe write.
    Expect read=1, link timeout=-ECANCELED, nop=0 after natural disarm.
    Requires the kernel short read completion fix.

  - test_link_timeout_remove (patch 2)
    read(LINK) -> link timeout, then TIMEOUT_REMOVE by user_data.
    Expect remove=0 and link timeout=-ECANCELED.
    Requires the kernel link timeout cancel fix.

  - test_link_timeout_remove_chain (patch 2)
    read(LINK) -> link timeout(LINK) -> nop, then TIMEOUT_REMOVE, then
    complete the read with a 1-byte write.
    Expect remove=0, link timeout=-ECANCELED, read=1, nop=0.
    Requires both kernel fixes.

Test plan
---------

With both kernel patches applied:

  $ make -C test link-timeout.t
  $ ./test/link-timeout.t

Without the kernel patches, the new tests are expected to fail on current
upstream kernels.

test/link-timeout: add natural disarm chain with short pipe read
test/link-timeout: add link timeout remove tests
--
2.25.1

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>


