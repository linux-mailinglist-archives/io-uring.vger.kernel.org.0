Return-Path: <io-uring+bounces-13856-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 78fdENaJQ2q9agoAu9opvQ
	(envelope-from <io-uring+bounces-13856-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 11:18:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 873B36E207F
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 11:18:13 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=Pcks8zuF;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13856-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13856-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 93602311ECA5
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 09:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA46A3E168F;
	Tue, 30 Jun 2026 09:11:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9BE261B8D
	for <io-uring@vger.kernel.org>; Tue, 30 Jun 2026 09:11:03 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782810667; cv=none; b=lh9+f/LL1lRq/a3DFmup6TA1lI+m+Z3QUruFAIiZkA6MTwTgf+O/1rLT20vTh5NMojLYURsKIVMeBzwnoDFuuvLGwg0kcEbK5Qtmt8ngZ0/BSYzvd71pxp3AJ1/q7oKbjHUOlt8PoVihh4YRvBlJuipdPFKN0S5v3axN+aWewzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782810667; c=relaxed/simple;
	bh=nKQ6l91PIJzZhKyKinKW8v/oM+jEdCEC/HgrZY2A19A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bySD06DBuhIFRY72VLlA7tV72VIXQhv8MSm4c9bFLp4hPfjux86EDfiL66/ogGv8PJGmV6zlrEMQPAwOZ0uzmXW7fj/beU3pLx5GNmH7xZOGj0ukCxEoBSc9r1YrngrEZmhExFkZzVRIVVGLmSsdtyQpKqJbmVxjpwDkJVjRUcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Pcks8zuF; arc=none smtp.client-ip=220.197.31.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Wa
	lhfPxv7+dqsGRk46VFpbPHDrgaAPEhEA/oldE5bBo=; b=Pcks8zuFhItHP7EK/6
	UxrJRnTjHmPZKk2Hs0RF5zafoUPGzdDIQ9Jr/TFnfwYnknpTsqV+28o1LYOsON4U
	o3Wt+3FLMRCb/XoYRNHWFE592TNiTGi4cVL41xyqblx+GA+Y1awC0Dd+0c/cyhMV
	RDLIZ3yg7vXK0bgejEIXe5tx0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wCH75EZiENqEWaKGA--.13722S2;
	Tue, 30 Jun 2026 17:10:50 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: xieyi@kylinos.cn
Cc: axboe@kernel.dk,
	io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring/rsrc: bound io_coalesce_buffer() page array allocation
Date: Tue, 30 Jun 2026 17:10:43 +0800
Message-Id: <20260630091043.522534-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260630071017.100436-1-xieyi@kylinos.cn>
References: <20260630071017.100436-1-xieyi@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCH75EZiENqEWaKGA--.13722S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr18tF1kCry5tr1fZryrZwb_yoWxurg_uF
	WkAa42yw43GF47Ga1qkFWfXFyDtw43Wr4xuFy5uFsrAFyrXFZIvw18Xas7Zr17Kws2yFZF
	yr9a9a1jyryYgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRGZXr7UUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRqTJGpDiBoRagAA3s
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13856-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:xieyi@kylinos.cn,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,kylinos.cn:mid,kylinos.cn:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 873B36E207F

---

Hi Yi,

On Tue, 30 Jun 2026 at 15:10 +0800, Yi Xie wrote:
> kvmalloc_objs() in io_coalesce_buffer() does not check for size overflow
> when nr_folios is large.  Mirror the check used in memmap.c before
> allocating the page pointer array.

Thanks for the patch. I don't think this check is needed on the current call path.

io_coalesce_buffer() is only called from io_sqe_buffer_register() after
io_pin_pages() succeeds. io_pin_pages() already rejects:

	nr_pages > INT_MAX / sizeof(struct page *)

io_check_coalesce_buffer() only increments nr_folios when it walks across
folio boundaries in the pinned page array, so we always have:

	nr_folios <= nr_pages

Thanks,
Yang Xiuwei


