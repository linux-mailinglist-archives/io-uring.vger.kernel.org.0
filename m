Return-Path: <io-uring+bounces-13871-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id /G0KFqMkRmqmKgsAu9opvQ
	(envelope-from <io-uring+bounces-13871-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 10:43:15 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F343B6F4EAD
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 10:43:14 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=jiqnZea9;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13871-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13871-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C729930D08FA
	for <lists+io-uring@lfdr.de>; Thu,  2 Jul 2026 08:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7A71420E83;
	Thu,  2 Jul 2026 08:30:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635DE42E8D6
	for <io-uring@vger.kernel.org>; Thu,  2 Jul 2026 08:30:20 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782981023; cv=none; b=tEqrshnav1rPllCuiaz+Z8CbGwK2F7iBnVFuDXex8ugMBgok1ySD69PDC9LRWHL5tpv7/xHqYsbSzfxf0ZFqjwt724bgLA6MBWrPj76+PUXK8oMN7C467rS/XZrsodS7GM3hZACJ6ONWxBxy3QyllKvrUKrpixFdFhRIFxn+d7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782981023; c=relaxed/simple;
	bh=5wZlGS4YhLti1YkSq19P+yAeHLvlDrgwEVzypPJR6LQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NUIEuOrzRNDcDY8Lz7SjPIiWhv6JVe24fe8DlMrDD254Wd69e7joThfhj+hzmTlZQIsXL9ESqWmx78usOGpXh50xF5yJ5mpqqrpNHTpeFJVmOJrkxxykcA+1MeBPabyqubLG9akDXWZUoFDKUTAam8s35FGGor/cF5Zv1TMykjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=jiqnZea9; arc=none smtp.client-ip=220.197.31.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Kq
	hNVbw0oRAGTaqcxuJURD7Mw0BrvUPgywmWCqxbj3w=; b=jiqnZea9qhVG/Fgtn+
	f7ko9EeFkUe7WGzj+sxJFlMxhsuLXcgjcLloUyrxegCmq+LXzVZ8zq2vUSvC+oXk
	VsAHba1y3ShxJcA9ENgKM978e1LJoLHrTZAPGkawrqjPDrdqTUWJIDuk1L3CPu0o
	wO20/CvoMyPKXrag9mLFBkQIA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnH0R0IUZqmPUCHA--.22854S2;
	Thu, 02 Jul 2026 16:29:41 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 0/2] io_uring/uring_cmd cleanups
Date: Thu,  2 Jul 2026 16:29:35 +0800
Message-Id: <20260702082937.3707134-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnH0R0IUZqmPUCHA--.22854S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GrWUtr4UCr1kAry8ZF4fZrb_yoW3Xrg_Cr
	Z5G3yxWrW7XFWqv3W7Cw1rXr1rK3y7AFWUXr1fJry7Ar17AFykG395Gr4fJFsagF1IqF13
	GFZ8A3sayryagjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRR_HUtUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6RaRImpGIXZiqAAA39
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13871-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:yangxiuwei@kylinos.cn,s:lists@lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: F343B6F4EAD

Two small io_uring/uring_cmd cleanups:

- copy the SQE into async data in io_uring_cmd_issue_blocking()
  before punting to io-wq, as the -EAGAIN and fallback punt paths
  already do (discussed in May [1])
- fix comment typos in io_uring_cmd_mark_cancelable() and correct
  the memory-ordering note in __io_uring_cmd_done()

The sqe_copy fix still has not made it to mainline; sending this series
in case it is still useful.

[1] https://lore.kernel.org/io-uring/56388741-f507-44e3-a144-5512a1fd99cb@kernel.dk/

Yang Xiuwei (2):
  io_uring/uring_cmd: copy SQE before issue_blocking punt
  io_uring/uring_cmd: fix uring_cmd.c comments

 io_uring/uring_cmd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

-- 
2.25.1


