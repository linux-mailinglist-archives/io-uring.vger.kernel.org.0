Return-Path: <io-uring+bounces-13693-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 6ha2DoOnK2oGBgQAu9opvQ
	(envelope-from <io-uring+bounces-13693-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 08:30:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB39676EC3
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 08:30:26 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=bc5jLU7f;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13693-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13693-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 09FBE30298E2
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 06:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1C736C9EB;
	Fri, 12 Jun 2026 06:30:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACCF399004
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 06:30:18 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781245823; cv=none; b=Gyls5IxIZzbIepaM1Fcj7Vk35E7Vb6bIMJHo3VolgG+nORhmu/cR8LhEYYSu1OQJPv/hwKGHUC2ZIUd6bH9Dg5l1CpU2F2nQdHTVqin9Kp7OAag4D/4bXl4ugQIKKnweFwTW/Va3Pc6nY8aSNIoGnHN/7LExH7hMaITIhHAEVlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781245823; c=relaxed/simple;
	bh=WVrtwcSuRzYCvKOWX+X6qmHWjyskeK6f68NE24q0XJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tlg1p2nB54xDAoe/rERAgGrMb2hkUIHFoSUcvpexRtgbFXHJEALw4wxQ1OcnZlSc/+Zl1lmqEIqbGLi3rH0ElAIjrgpopQZHboJZrK995Gh0sxfuo96Zf/5EioTvfTCZ0kE4D0mvozCY67AJntllJJTrX8Z2XjZlnSU8KrHCMDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bc5jLU7f; arc=none smtp.client-ip=220.197.31.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=WV
	rtwcSuRzYCvKOWX+X6qmHWjyskeK6f68NE24q0XJc=; b=bc5jLU7flzA2EdCtqa
	ikgkhi206/9PJR444zKwlmJ3nZxrBLyvExb+UahnrH4EjvyRRkAPxwDwCU2Ghh+z
	6T+coDX8pnpkwYDJfTbx3Bn/MX8Bd3uhYhDeU5hsJxb9oiGcTzZ/bdg8ncyS9iQ/
	WyUeRx3wWT80SKMOaOYIRue9A=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgB3Mv9ZpytqyaGQBg--.31250S2;
	Fri, 12 Jun 2026 14:29:46 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] io_uring/rw: fix link failure on successful pipe short reads
Date: Fri, 12 Jun 2026 14:29:44 +0800
Message-Id: <20260612062944.1968425-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260612005902.1369063-1-yangxiuwei@kylinos.cn>
References: <20260611012236.3020181-1-yangxiuwei@kylinos.cn> <20260611012236.3020181-2-yangxiuwei@kylinos.cn> <d75fe34f-dc14-455c-8d80-04d341a9744d@kernel.dk> <20260612005902.1369063-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgB3Mv9ZpytqyaGQBg--.31250S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrurW8Gw4fAF48Ww1UKw47CFg_yoWfZFcEgr
	yvkwn7Gw4ayF9xJw43CF40vrZxur429r18u348WrWxG3yrJFyfWws0vasxXryxGa1kAF17
	KrZagr17KryI9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRE7PEPUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6Rpl9Worp1pYXwAA3Y
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13693-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8BB39676EC3

Hi Jens,

Following up on my note below.

Patch 1/2 was motivated by __io_read() returning short reads on pipes
and sockets without retrying, while __io_complete_rw_common() still
failed the link chain. I had not fully understood IOSQE_IO_LINK at the
time. When a chain depends on reading a full buffer from a pipe or
socket, a short read means that dependency is not met and the chain
should fail. IOSQE_IO_HARDLINK is the right option when later requests
must still run despite a short read. Sorry for the confusion. I will
drop patch 1/2.

Regarding patch 2/2: the current code does not handle TIMEOUT_REMOVE
against pending link timeouts on ltimeout_list, while
IORING_LINK_TIMEOUT_UPDATE already has a separate path for them. Was
leaving ltimeout_list out of the remove/cancel path intentional, or
simply an oversight? If the current behaviour is intended, I will drop
patch 2/2 as well.

Thanks,
Yang Xiuwei


