Return-Path: <io-uring+bounces-13721-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ueAMBPxuLWomgQQAu9opvQ
	(envelope-from <io-uring+bounces-13721-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 16:53:48 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C5E0A67ED66
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 16:53:47 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R7CHHJqe;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13721-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13721-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4A336306B7EF
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 14:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2204E33F368;
	Sat, 13 Jun 2026 14:51:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D2F33C183;
	Sat, 13 Jun 2026 14:51:43 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781362308; cv=none; b=DZIiftHYtQysRUU5dAj/GECmTzyfDPw9kYvkfSwMbWCXKRv5wXvCGlk+2r04vr+IgljZrapL/OharKkSVJHraTxeUmkFjw2DSPXs4dElWYVWbfkResrh7/EVnHJ3BVw3oeGFiTTe2+jXGDhHtt3Q8yQYCNzgiRDT8CHOgnBqCgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781362308; c=relaxed/simple;
	bh=7VIFNRgQTmLyNLFghQPD7RUIQFlqTNO/3ABuxf+WAk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QD+6NhneFY1rqPRFf2ov6eJznmqJDltb/sgczfe36+YbfDaDDrl06nq4LIc/+EGiQcHmXiPoRF5sZvn7mTTIxe3W9BbPv5Znp4M/mu59BbAZLmJpin9pLlG1WT3mXa5lDijwOtrNe1PXxl65A7bAnSKCMouLHFeuyqa7MrEILAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7CHHJqe; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3C61F00A3E;
	Sat, 13 Jun 2026 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781362303;
	bh=mwtemniNSvRmeuyRdk01RGvMOavihgD5ot1mMgpEysY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7CHHJqeA+n83imcawNSiA2P68SqicleF9o3hL0T85hbBADmCd4BnjYHGEisVk8ZW
	 jxILh7RFy5QJ8ZhYQAOlIh/CW8zotIbDMKm2DzQIop3lJFd/VEvOWxRUrR4LpmbvZm
	 m9COcRV3+XDCMe4L42AhvJeEESSqDgTkcD8oc38cuI5Le2El8OFa4QUXIoTOLQWAqG
	 JBPfGVcmjg3p9dc1QEoppZ/xeSH9caZ12pVI48vlTdT/9rtfRBPhex95FYW0QrXyhB
	 yue/l1zRXcgfpCBMs2KEwCYz4f1hF2rV4pOrAQenWzGb9+S4J2q2abvHvdaiPNqgQX
	 px7v3vIVMozGA==
From: Sasha Levin <sashal@kernel.org>
To: Alexey Panov <apanov@astralinux.ru>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Li Zetao <lizetao1@huawei.com>
Subject: Re: [PATCH 5.10] io_uring: prevent opcode speculation
Date: Sat, 13 Jun 2026 10:51:32 -0400
Message-ID: <20260613143006.0007-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612081720.3632-1-apanov@astralinux.ru>
References: <20260610172203.27999-1-apanov@astralinux.ru> <20260611-stable-reply-0106@kernel.org> <20260612081720.3632-1-apanov@astralinux.ru>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13721-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:apanov@astralinux.ru,m:sashal@kernel.org,m:stable@vger.kernel.org,m:gregkh@linuxfoundation.org,m:axboe@kernel.dk,m:asml.silence@gmail.com,m:activprithvi@gmail.com,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:lvc-project@linuxtesting.org,m:lizetao1@huawei.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,linuxfoundation.org,kernel.dk,gmail.com,linuxtesting.org,huawei.com];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C5E0A67ED66

On Fri, Jun 12, 2026 at 11:17:20AM +0300, Alexey Panov wrote:
> Unless I am missing something, the fix is already present in both trees:
>
>   6.6.y:  b9826e3b26ec ("io_uring: prevent opcode speculation")
>   6.12.y: 506b9b5e8c2d ("io_uring: prevent opcode speculation")

You're right, thanks for checking. Both newer trees carry it now, so the
prerequisite is satisfied. Queued for 5.10.y.

--
Thanks,
Sasha

