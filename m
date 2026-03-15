Return-Path: <io-uring+bounces-12681-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aJBwAHU9tmn8/AAAu9opvQ
	(envelope-from <io-uring+bounces-12681-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 06:02:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 48EEE28FFAC
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 06:02:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6F012302DA86
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 05:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E741C84DC;
	Sun, 15 Mar 2026 05:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="GEZTbz11"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D164A32
	for <io-uring@vger.kernel.org>; Sun, 15 Mar 2026 05:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773550961; cv=none; b=Vdwj+Ji8pgPzBeLqa567WmZMQCYWXuk66QPZiBKFBjPl8tNqXrQIiEq4aL5O12ZPIf5O2MrZIwKBpvjDDCEydmPR+ljDISRa7QnLV1+uDYqQ5H31fI8Xq04xo0ZzTmglYpFeXcGG4TeRLMwL6RpjYq6sszqMN/5GhaZqdeYcwj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773550961; c=relaxed/simple;
	bh=94gL0QhlWjUJWjxQeXmbZH6wRRiZR+Slpj8l+cP9dYA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hEvti1pdXO4t16Fn5ieP00zxwxldUfsqVc9JVULinNyIFRqaSxfN7rZGlrUVA5s1HhbAfUCllJbvKHSlPqC19fq9PRIH4vv0vEn7CC+lssApmSvyBrTPq9d3gUky5DHqTkc5kj49l1XfgrvwpyPUJJ8338f4Fg6R28TTYx7cr4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=GEZTbz11; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=94
	gL0QhlWjUJWjxQeXmbZH6wRRiZR+Slpj8l+cP9dYA=; b=GEZTbz11YkO5nG16pV
	bfbR0yeTavqHaqS9uW8VgSvKPtTHlh9pBU6gzOW/7uoN83DHjogZuBNF6AQ2OPKG
	kmbR7O3aq0lDv50iUwXAtSX3mYiHQ5PZKW+6MNalSZ14WVmZuobnKTOOAYHSJp+C
	oOBgKOvi5RTcDFwsZ4kt197Bo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wAXn+pZPbZpKtVLBA--.1614S2;
	Sun, 15 Mar 2026 13:02:19 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 2/2] test/cbpf_filter: skip when openat2.h is not available
Date: Sun, 15 Mar 2026 13:02:17 +0800
Message-Id: <20260315050217.121292-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <10b4b9bf-2dc8-41f3-bed2-110170dff236@kernel.dk>
References: <20260314083538.791693-1-yangxiuwei@kylinos.cn> <20260314083538.791693-3-yangxiuwei@kylinos.cn> <10b4b9bf-2dc8-41f3-bed2-110170dff236@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXn+pZPbZpKtVLBA--.1614S2
X-Coremail-Antispam: 1Uf129KBjvJXoWruFWUCr13uFyfJF48Kw43GFg_yoW8JF45pF
	W3G3WDKr1DZr13Xrn7Zr4fZrySvrs7Ga45JF93XrZ0ya45W3ZFqFWIya1Y9FyDCa1FgF10
	qF10v3WY9a15XaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRxOz-UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRtt-Wm2PVsnaQAA39
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12681-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[kylinos.cn];
	RCPT_COUNT_TWO(0.00)[2];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[163.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 48EEE28FFAC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Jens,

On 2026-03-14 13:35 UTC, Jens Axboe wrote:
> liburing defines open_how if it's not in the system headers. I feel
> like all you need to do here is remove the openat2.h include, rather
> than disable the test entirely?

Thanks for the suggestion. I had actually tried that first: removing only the
#include <linux/openat2.h> and relying on liburing's compat for struct open_how.
It turned out that this test also uses the RESOLVE_IN_ROOT macro (and the
filter logic is built around it). Without the header, the build fails with
'RESOLVE_IN_ROOT' undeclared. RESOLVE_IN_ROOT and the other RESOLVE_* flags
come from <linux/openat2.h>; compat.h only provides struct open_how when the
header is missing, not those constants.

Defining RESOLVE_IN_ROOT (and friends) ourselves in compat or in the test
would duplicate kernel UAPI and could get out of sync if the kernel ever
changes them. So I went back to the more conservative approach: wrap the
test in #ifdef CONFIG_HAVE_OPEN_HOW and provide a stub main that returns
T_EXIT_SKIP when openat2.h is not available. The test then always compiles;
on systems without the header it simply skips at runtime.

If you have a better approach in mind, I'd be glad to follow that instead.

Best regards,
Yang Xiuwei


