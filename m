Return-Path: <io-uring+bounces-13568-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0KVaOZYmG2qf/ggAu9opvQ
	(envelope-from <io-uring+bounces-13568-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2026 20:04:06 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA08610E96
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2026 20:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D512A3016CE4
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2026 18:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11703B7B72;
	Sat, 30 May 2026 18:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XkU7k0Sk"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744DE2FDC5E;
	Sat, 30 May 2026 18:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164227; cv=none; b=Dx+txqBDdoxgm1bk3j6qnKS+GJ1LyL7D7UqONImM4LWW1yfU/HHMCRGMjBsUy4NqDbwz01gsPXFuwOq+ku9QfnUDdczqYbTj3NEJGJ8M9MAVHH5JGua9EtaVkw8VtdBkkNJezNjTiyi3wuLn31I4yjabU1EfmwgfmIBa+Svdsh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164227; c=relaxed/simple;
	bh=OqNA2skOn5pRwMZwWulbW5b96RksUG9RppDGaZAT2ek=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=myOcIKbOSJ+sfvqIYPVe+gGg03GJH9UNpa3wtvOwC3xYi+0ey0dTVu0EUiOqeM5kJGA1ZvL3bHKSeUb3zU35NHLLMTuYbb7Uel+lAg5FjXdFZVkO4CNnTMg1u+DCsvUqVyZyC7ZVYQWrX98p58wxekdpHbaUTM70QfoqXrHVkms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XkU7k0Sk; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Oq
	NA2skOn5pRwMZwWulbW5b96RksUG9RppDGaZAT2ek=; b=XkU7k0SkVaWrQlokr4
	mqPGY618gKgB0d3bzy9Orf1YFbk2v2qS3tu564zkBYlDL1CEgvGJLQydTH9BXYqx
	JqOHzmmenPwwp3OWWSA2k0+Tt8zISzqVkBeRb7PycOYfkQtL7HUOfm2D1teK8dmJ
	35G0/qqvnyfIOlakvp6/a9sf0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDnr5o5JhtqllXLAQ--.2025S2;
	Sun, 31 May 2026 02:02:35 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: rc@rexion.ai
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	axboe@kernel.dk,
	fujita.tomonori@lab.ntt.co.jp,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	csander@purestorage.com,
	stable@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: Re: [PATCH v2] scsi: bsg: read io_uring command fields once
Date: Sun, 31 May 2026 02:02:08 +0800
Message-Id: <20260530180208.3588677-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260527191817.142769-1-rc@rexion.ai>
References: <20260527191817.142769-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnr5o5JhtqllXLAQ--.2025S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUoVbkDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRv4iWobJjt7zQAA3x
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
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13568-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:mid,kylinos.cn:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 4EA08610E96
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Rahul,

Thanks for the report and for v2.

Reviewed-by: Yang Xiuwei <yangxiuwei@kylinos.cn>


