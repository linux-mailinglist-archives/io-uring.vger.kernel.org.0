Return-Path: <io-uring+bounces-12131-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aJFfKZKKimn4LgAAu9opvQ
	(envelope-from <io-uring+bounces-12131-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 02:32:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 91894116017
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 02:32:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E5D1E300B1AF
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0570D24A069;
	Tue, 10 Feb 2026 01:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bQM4hgoJ"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CC317ADE0
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 01:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770687119; cv=none; b=aVbqvdW+DpzMzWr4SdPrGQ+p3VDdNHNBKgVXh+ExYXyZp6USrovhj+pzLRJhq2pAKegd60QeQF2WJghrfJbmI9KOvTkGSiJEYupO45c0+z8OPEnn+O1c8kMdto4Z1qKwK4Neru9PHta3Lm32EpgkcEFqli8M91z/6X2LPbbG7Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770687119; c=relaxed/simple;
	bh=u6m2OQ8v9A8iYMnTuCWrjin+eZxWYbavpErrahEP2b8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jPMl/l9/LKjjH1Oleex4cl6XKK0mWp/yNUHsNCsgYKcwL48lzyMtVUSB0XKTvORpzSo3M3SJPcro9hwCst4rrEjoVqMcyQWjqfY//A2Jzzg+GGkUl+xr+LN2rPWQgt9/0lV7kSQ5qsOd3pAQpJ5QmZbrnJ3xDu+1tWTaahqLpO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bQM4hgoJ; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=u6
	m2OQ8v9A8iYMnTuCWrjin+eZxWYbavpErrahEP2b8=; b=bQM4hgoJBP4aFZSZnE
	7HN8YBAtLpu8Go/NnjIhGuPnQ4GoRUkPAgOpL/D5aXlc2Rb92FvnvmG4Z0XF3ONz
	INhBRJf88MdsrPUBOhuUMv86VCqYvXnvQjVxJCOqdc+0mG/BI3a5QDBJSEe6i/J/
	5xCsEqaGXczua3AYtD5s2Jdm8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wBHLq2AioppGzsIKw--.558S2;
	Tue, 10 Feb 2026 09:31:46 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring/tctx: prevent loop variable modification
Date: Tue, 10 Feb 2026 09:31:43 +0800
Message-Id: <20260210013143.1791381-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <63b52c5d-5c8c-4085-9d90-12374da974e3@kernel.dk>
References: <20260209061919.425074-1-yangxiuwei@kylinos.cn> <63b52c5d-5c8c-4085-9d90-12374da974e3@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHLq2AioppGzsIKw--.558S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4RCbyZDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QK-UGmKioLjKAAA3k
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12131-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWO(0.00)[2];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kylinos.cn:mid]
X-Rspamd-Queue-Id: 91894116017
X-Rspamd-Action: no action

On 2/9/26 5:42 AM, Jens Axboe wrote:
> I think this is fine as a cleanup as it makes it more clear, but I fail
> to see how you can ever have this cause an issue.

You're right - this isn't a bug fix. The current callers already validate
bounds, so there's no actual issue.

My intention was code cleanup: avoiding loop variable modification in the
loop body improves clarity by separating the logical index from the
sanitized array index.

Sorry for the misleading commit message. Should I send a v2 framing it
as a cleanup?


