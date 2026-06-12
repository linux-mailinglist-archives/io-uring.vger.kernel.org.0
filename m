Return-Path: <io-uring+bounces-13694-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id HoOrGLPAK2p3EQQAu9opvQ
	(envelope-from <io-uring+bounces-13694-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 10:17:55 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E544B677BBC
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 10:17:54 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=astralinux.ru header.s=mail header.b="i//JWAfY";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13694-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13694-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=astralinux.ru;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5B69C3017AEC
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 08:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A35137A4B8;
	Fri, 12 Jun 2026 08:17:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9433659F9;
	Fri, 12 Jun 2026 08:17:47 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781252273; cv=none; b=U/LVWVVyJecNhP7uttwDruk44+fNPOPExxoXdSBoprcJQi6/fZGTHJQN2nAGcwTCMUYgrgE+6S7OrUBoHI1F7j0Q4o1KbBCoadNtDlbLPo1Q5bzWni3w418BKEEbVG0tgA0zAP5/XlFwGHdpPlPpd62UnvDOgRtuNy1698ND89w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781252273; c=relaxed/simple;
	bh=TxJTtvUFQGiGeIsHQ/Y8ukaeDA+u3Xj/pL//b+ibwEk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pyLbi8ETzkNgUpBZLynmQfrcv0VM5pDJ1/WTi4+1PTrdyy9PtN+FZ25RTvJv3e/SHC38YzLFipRg+65zaD7BQb6Bwb4ANKZSnQ0hTEbysNI5NO9OP13xJwwsglUGakyjtipb2xTdzwNb/pieBtyN7jV7EHXdXAJdUGdJYT8ocP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=i//JWAfY; arc=none smtp.client-ip=93.188.205.243
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1781252257;
	bh=TxJTtvUFQGiGeIsHQ/Y8ukaeDA+u3Xj/pL//b+ibwEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i//JWAfYarjzo/tMRnjWIgQ9/CvkPb551veH9RktaKftyuKyE7uDNpVPEduZci6xl
	 UEMLNmhCy7tr0d/FOo5lvOwGjgTHjzJjrVAJ/nFaKINPq8e/wE0czstcZdNCF8MwYj
	 0vRRGFxHZsuzUpYpQksNR1S5hbJYGMoa3yfFBP0ISH5vKoa9a2ASNBAKBzcS5KkMZ7
	 OpE29ZP0Jv/2sp479LnbG3o6Oeg9yzoqIhfjPLaV94ZuRQPy2nrrDkRX13Mxd1WpiR
	 nCVzqrVnX29LYM1oEFGIicZ3MQfcZ8FXeaNf24tx/sKL3PDeYzUI2Uhor1ug3RdzBD
	 cs6uk/FOIBsIg==
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id 737CA1F95A;
	Fri, 12 Jun 2026 11:17:37 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Fri, 12 Jun 2026 11:17:35 +0300 (MSK)
Received: from rbta-msk-lt-156703.astralinux.ru (unknown [10.198.16.160])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4gcC724lH1zwQNq;
	Fri, 12 Jun 2026 11:17:34 +0300 (MSK)
From: Alexey Panov <apanov@astralinux.ru>
To: Sasha Levin <sashal@kernel.org>
Cc: Alexey Panov <apanov@astralinux.ru>,
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
Date: Fri, 12 Jun 2026 11:17:20 +0300
Message-Id: <20260612081720.3632-1-apanov@astralinux.ru>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260611-stable-reply-0106@kernel.org>
References: <20260610172203.27999-1-apanov@astralinux.ru> <20260611-stable-reply-0106@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: apanov@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 107 0.3.107 575e75fe8e3b9d45c142d144823c5de38605099e, {Tracking_internal2}, {Tracking_from_domain_doesnt_match_to}, new-mail.astralinux.ru:7.1.1;astralinux.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 203816 [Jun 11 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.22
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/06/12 03:36:00 #28231850
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[astralinux.ru,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[astralinux.ru:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[astralinux.ru,vger.kernel.org,linuxfoundation.org,kernel.dk,gmail.com,linuxtesting.org,huawei.com];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13694-lists,io-uring=lfdr.de];
	FORGED_SENDER(0.00)[apanov@astralinux.ru,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:sashal@kernel.org,m:apanov@astralinux.ru,m:stable@vger.kernel.org,m:gregkh@linuxfoundation.org,m:axboe@kernel.dk,m:asml.silence@gmail.com,m:activprithvi@gmail.com,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:lvc-project@linuxtesting.org,m:lizetao1@huawei.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[astralinux.ru:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[apanov@astralinux.ru,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,astralinux.ru:dkim,astralinux.ru:mid,astralinux.ru:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E544B677BBC

On Thu, Jun 11, 2026 at 11:26:24AM -0400, Sasha Levin wrote:
> The 5.10 backport itself looks fine, but I can't take it on its own:
> 1e988c3fe126 is still missing from 6.6.y and 6.12.y (it's present in
> 7.0, 6.18, 6.1 and 5.15), and we don't add a fix to an older tree while
> a newer one is missing it. Once 6.6.y and 6.12.y carry it, I'll queue
> the 5.10 backport.

Hi Sasha,

Unless I am missing something, the fix is already present in both trees:

  6.6.y:  b9826e3b26ec ("io_uring: prevent opcode speculation"),
          included since v6.6.80
  6.12.y: 506b9b5e8c2d ("io_uring: prevent opcode speculation"),
          included since v6.12.17

Both commits explicitly reference upstream commit 1e988c3fe126 and were
committed on February 27, 2025.

Could you please re-check and queue the 5.10 backport?

