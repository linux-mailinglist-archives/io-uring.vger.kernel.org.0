Return-Path: <io-uring+bounces-13678-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id MA2UBetZK2rH7gMAu9opvQ
	(envelope-from <io-uring+bounces-13678-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 02:59:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B6328676071
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 02:59:21 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=WzztUrZi;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13678-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13678-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 741EA316991C
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 00:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0E7258EC1;
	Fri, 12 Jun 2026 00:59:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F5A1BF33
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 00:59:14 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781225959; cv=none; b=BVCQLJmpgwjDxgwzv/+Adti1XleD0i2qiiVkWp1CcGKqoI5a6JJhnSPAs6xKcWZLxgae9j59954goZZyJdOGmnePIKrbXQ4sdnLfoz2+3KN6fVNuMtaUVeQSLntOy4/jLvbr8zVDJ3TvsImr9hTGYKRkOipoi2g2zSZk9CwzEzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781225959; c=relaxed/simple;
	bh=wUlgFH9O0HnBw1nB2QE4k3GmazYKX/xceJ6lUm1W7OI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dXu6cecKwRMa7zwE++YDmHw8uUCGyAyEj39R+gHhGE9oSVOl/uxUEfLzQDx6RdOvE9ilrolXN8OHQlhlKB002B4KtiATm+K/S2UUBxOUYsnCSxas9nN+66mVXipQRWWqY9abjfexr6kMuh8N3G3kVtQ/PurxcQYbt8kG8rCDmkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=WzztUrZi; arc=none smtp.client-ip=117.135.210.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=tY
	s4/JdNPf7Dhi4HJPJSLJK4HNoHaltyDCWi9HG5j78=; b=WzztUrZiQx68WoGd8I
	ybfFdstJDpxvrNjyO9NDBOf91SWRvbloJWW8i9eCobPk6tgVikbfcnKqjBfykC7+
	sGqdTG/4qsyH2pt2T2FFQWOjETuvsvDlVf+d55Jv07t2klmtk1aT0yaRRTXuISNc
	9ApxVaLmMkBc2Pfh2mmZJ1yLE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wB3H83WWStqrVhfCg--.65S2;
	Fri, 12 Jun 2026 08:59:05 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] io_uring/rw: fix link failure on successful pipe short reads
Date: Fri, 12 Jun 2026 08:59:02 +0800
Message-Id: <20260612005902.1369063-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <d75fe34f-dc14-455c-8d80-04d341a9744d@kernel.dk>
References: <20260611012236.3020181-1-yangxiuwei@kylinos.cn> <20260611012236.3020181-2-yangxiuwei@kylinos.cn> <d75fe34f-dc14-455c-8d80-04d341a9744d@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3H83WWStqrVhfCg--.65S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKFW8Jr15uFWrKF1DKFy3Arb_yoWxKFbEvF
	15tan7Cw1ktF13A3W7Kr4Fq3yqqF4Uur1ruw1kKr4ay3y8tF4kWrsIv34Y9Fn0qan3uF15
	ursYqrWDtr1avjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRE7PEPUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwhrxgmorWdqtJgAA3i
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13678-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B6328676071

On Thu, Jun 11, 2026 at 12:36:22PM -0600, Jens Axboe wrote:
> Not sure I follow - the "short read/write is an IOSQE_IO_LINK failure"
> is widely documented. So not sure I agree with this approach.

Thank you for the feedback.

Looking at the history, the IOSQE_IO_LINK short-read behaviour was
documented in 94163513 (Feb 2020), while 9a173346bd9e (Jan 2021) later 
changed __io_read() so that non-regular files no longer retry on short reads.
That issue-path change post-dates the documentation, 
and I am not sure the two were ever reconciled.

Is the documentation still the intended rule for pipes as well? If so, I
will drop this patch and treat the current completion behaviour as
correct.

Thanks,
Yang Xiuwei


