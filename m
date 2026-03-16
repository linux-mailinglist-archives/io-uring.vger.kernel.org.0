Return-Path: <io-uring+bounces-12685-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aO8hDhNXt2lsQAEAu9opvQ
	(envelope-from <io-uring+bounces-12685-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 02:04:19 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C42293443
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 02:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AF1363006168
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 01:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BA0A256D;
	Mon, 16 Mar 2026 01:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="CXxcdnDE"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AA083A14
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 01:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773623000; cv=none; b=TdgW1R6SQoOUuuo2x//z/yZaDlVeX2tWpzlPK8lCTimhxmUaZeJGpAMeX6KFIuiTyLGCuTctvg1SGkiKL4k+WEuyuZ1V2HG+wJKWzONzixhwMVofvmomOvqSsCUb+JG+I0FfYdXELKwY496MX37aZWIZScsPiy6nyNiJ6DRK7rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773623000; c=relaxed/simple;
	bh=LnBDd4EKXqsBb5/31t5VJyegrPItwa0g8S7AZj4Xahw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ec7cy+irIEVnWIc5TehxBW14+KQG7pnIMo1YUXa1xUXPXBpyG3GDgBMTitD9lLmqC8eUsWLCFkRW+KGZ2uiHBuaV+lPhTWWyBG2Jkv9Rhu9nghZVjiqxqwrvEHyTc677jnGZEgCmBAsTNkDuhSzC3jvsRvb0aAl0qwY6DsDHRt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=CXxcdnDE; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=MB
	EIDZP12fAfE2s6Be4A/vdNnYszauQdv1KIVnKd9i4=; b=CXxcdnDEXV5IlC6hWf
	Ns7MP5cRRVimrWMr/f1fwJwCNDuaRh/pdkjzSc7H1e38Bb+TvvAtG+fEtz2zQduB
	fkRyikeOLE/ptRgSJQRYRautgyjKCU/IXy2hoVdAeDWRAIIoG5UJXjFO1Ib1FwLf
	P5p7smunlPjZHbLCd9DPKUAnQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wCn75bAVrdpqyTEAw--.0S2;
	Mon, 16 Mar 2026 09:03:04 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 2/2] test/cbpf_filter: skip when openat2.h is not available
Date: Mon, 16 Mar 2026 09:02:54 +0800
Message-Id: <20260316010254.63804-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <3ecf01a7-4057-423e-bafa-881454f6e014@kernel.dk>
References: <20260314083538.791693-1-yangxiuwei@kylinos.cn> <20260314083538.791693-3-yangxiuwei@kylinos.cn> <10b4b9bf-2dc8-41f3-bed2-110170dff236@kernel.dk> <20260315050217.121292-1-yangxiuwei@kylinos.cn> <3ecf01a7-4057-423e-bafa-881454f6e014@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCn75bAVrdpqyTEAw--.0S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruF4kKw15GF1kGF18XFWrZrb_yoWxKrg_Wr
	1vvr97Cr4DGF1xJrZ8Jr1DJFy7JFsavrn7Aw4rW3sxC34YyayYk3Z7Zrn7ZFnxC393G3Z0
	9rn8tr1qyw12vjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRE7PEPUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgkQoGm3VsmlFAAA3L
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12685-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kylinos.cn];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[163.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kylinos.cn:mid]
X-Rspamd-Queue-Id: 47C42293443
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Jens,

On 2026-03-15 14:45 UTC, Jens Axboe wrote:
> I think just defining RESOLVE_IN_ROOT if it's not available should be
> fine. And yes the test will always compile when you stub everything out,
> but it also won't do anything at all. This will prevent running this
> test case on a host with old headers, but with a current kernel. How
> about the below, hopefully that should do it. That'll keep the test
> functional, rather than wrap it all in a define that just disables it
> entirely.
>
> diff --git a/test/cbpf_filter.c b/test/cbpf_filter.c
> ...
> +#ifndef RESOLVE_IN_ROOT
> +#define RESOLVE_IN_ROOT	0x10
> +#endif

Thanks, that works well for me. I'll send v2 with your approach.

Best regards,
Yang Xiuwei


