Return-Path: <io-uring+bounces-13834-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 3A+rBvufPGqQpwgAu9opvQ
	(envelope-from <io-uring+bounces-13834-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 05:26:51 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3DD6C2926
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 05:26:50 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b="j/P8uM5O";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13834-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13834-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E906530193B0
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 03:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A2E2BEC43;
	Thu, 25 Jun 2026 03:26:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6271E29346F;
	Thu, 25 Jun 2026 03:26:40 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782358006; cv=none; b=s7qRT+4V7yCLspzCPNdc3Y9VwXs9be1iHX7jwo82KQRexOVQa3JIGD4VsNnsD+3dx4WJsuYyL6AM2H9HKhQepVqqImyJS3ZKXxNiXzf4axVp6I+kOAsBHu7h4Tw+w4kk67zMPvM2J1PhFWzjSwxnzrRRPB84C1k27FVtJZ3eRug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782358006; c=relaxed/simple;
	bh=qABgI6ZUKqRLjlxYBCvtaOLGDoZbhoLruRVYCHjb8qo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iBF2BpqmBVQ4XlIsnZBi1F2D8btfOGNf5fXIY5EvEjFwDhErXYGkWK6rknhLIclh3zkcShsOHouSCW4F56OQa2w3qk7jnQ2I5wLc+wTy3im/9k1CIKwj9+6d0cMfi8nW0Pk8VZcx7XC0r3oEoeK5ps1z1oWWYz5l3vzwKww/xFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=j/P8uM5O; arc=none smtp.client-ip=220.197.31.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=qABgI6ZUKqRLjlxYBCvtaOLGDoZbhoLruRVYCHjb8qo=;
	b=j/P8uM5OEP5ghj5mouWvNsX3ybkzaQaB51hW6z/DAWYPJwWFNmA3meXjJX7/1b
	ZBkOkrmqPxk+HN5wWsOLYXA9FSVG0rgTj7T9dDmxRfcuvB8jHjW6b/hqyrCCWNQw
	kBr8PCQEEuesQTgLGxTCLt2Js1euGs2CcDKCzg++xAQTM=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAHrPqvnzxqLrauDg--.57902S2;
	Thu, 25 Jun 2026 11:25:37 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Rahul Chandelkar <rc@rexion.ai>,
	Jens Axboe <axboe@kernel.dk>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH v2] scsi: bsg: read io_uring command fields once
Date: Thu, 25 Jun 2026 11:25:35 +0800
Message-Id: <20260626020000.0000000-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260527191817.142769-1-rc@rexion.ai>
References: <20260527191817.142769-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAHrPqvnzxqLrauDg--.57902S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUoVbkDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRG9Tmo8n7EZrwAA3t
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:James.Bottomley@HansenPartnership.com,m:martin.petersen@oracle.com,m:yangxiuwei@kylinos.cn,m:rc@rexion.ai,m:axboe@kernel.dk,m:fujita.tomonori@lab.ntt.co.jp,m:linux-scsi@vger.kernel.org,m:linux-block@vger.kernel.org,m:io-uring@vger.kernel.org,m:bvanassche@acm.org,m:csander@purestorage.com,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13834-lists,io-uring=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[163.com:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:mid,kylinos.cn:from_mime,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3E3DD6C2926

Hi James, Martin,

Friendly ping on v2 — anything else needed before pick-up?

Thanks,
Yang Xiuwei


