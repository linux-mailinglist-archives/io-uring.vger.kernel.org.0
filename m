Return-Path: <io-uring+bounces-12686-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AA2OI71et2nZQQEAu9opvQ
	(envelope-from <io-uring+bounces-12686-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 02:37:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F1FC72936C4
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 02:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EC2F130094E7
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 01:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3089A23507C;
	Mon, 16 Mar 2026 01:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="NccG6VOi"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B20922D785
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 01:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625019; cv=none; b=hOWndkNG74D4qOA/BhaE5qy7veqJ+73zCp3Cs6YkQFkoW6QdtyCEkFi4vABPwmRelsSksTe1YyEdI6sdDwRlFQ8Dtt/ltqHYFWj9TPV0AvWuGfrgkoWKdu/Nbcg398uU7gna982bxqbnGGJ3VGTqiNp9+HaV0EeADtgRp17J+lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625019; c=relaxed/simple;
	bh=CqbG/H8XX4z/oLeo4j7dkS87UwksdpQKiJG7OgNTP78=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H6ITlIJHxur+kdi8oKbxnPLriYUfZzB3EkeD2Eu0FTV1cbpdqOH7WuIog95exgnwkwlWUdtHTO81JQV0Rsi0s2AoNnFDaYYWfc10MTDsqziEApyHu1YXGSr6wi192+bU/veJY0Xv+l/gMBQdI/xQ6OW2XLsX3Qv+K5/m7yXKPk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=NccG6VOi; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=47
	5KiEzpdzHQUi5iuxlgzt0ghMx8b0xQBQ/60E3Vte8=; b=NccG6VOi0YbQBFlpKs
	zDQ9zt6Vm32F7YtHeAAEaZ4bt62DJZEFkVr0kSEqCOFlICjexxltgYHw1JqUVJ6d
	VvnBujA2YmddelYlhiiV+XstxlYRLka1UaRnn0B8TdrMiB9v1ioD9Qx/xBr5TEpg
	4d8N1eRCf2hYFdptZ+BFFSmdY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wB3LduWXrdpW5DGBA--.28271S2;
	Mon, 16 Mar 2026 09:36:24 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v2 0/2] build and compiler warning fixes
Date: Mon, 16 Mar 2026 09:36:19 +0800
Message-Id: <20260316013621.115939-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3LduWXrdpW5DGBA--.28271S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZry8CF4UCF1UJF17Xr1UKFg_yoWxAwc_Kr
	WfKr4xJwn3tF4jya1fuF18Xa4qka4rKrsa9w4qya4UArZ8Zws7GF4DKr10gr4UuF93Ja4a
	yrn0yF4jqw17ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbwvKUUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6RoGlmm3Xpp49QAA30
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12686-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kylinos.cn];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:mid]
X-Rspamd-Queue-Id: F1FC72936C4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Fix two issues: (1) send-zerocopy -Wstringop-truncation on ifr.ifr_name;
(2) cbpf_filter build failure when kernel headers lack openat2.h.

Changes since v1:
  - Patch 2/2: Per Jens's suggestion, use RESOLVE_IN_ROOT fallback instead
    of stubbing the test. 
  - Patch 1/2 unchanged.

  v1: https://lore.kernel.org/io-uring/20260314083538.791693-1-yangxiuwei@kylinos.cn/

Yang Xiuwei (2):
  examples/send-zerocopy: fix -Wstringop-truncation on ifr.ifr_name
  test/cbpf_filter: fix build when openat2.h is not available

 examples/send-zerocopy.c |  2 +-
 test/cbpf_filter.c       |  5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.25.1


