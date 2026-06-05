Return-Path: <io-uring+bounces-13616-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id D+QsHWglI2qwjQEAu9opvQ
	(envelope-from <io-uring+bounces-13616-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 05 Jun 2026 21:37:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B965964AFB8
	for <lists+io-uring@lfdr.de>; Fri, 05 Jun 2026 21:37:11 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b="lpo//D0Q";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13616-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13616-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 78874300363D
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2026 19:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD1D257ACF;
	Fri,  5 Jun 2026 19:37:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83702416CF3
	for <io-uring@vger.kernel.org>; Fri,  5 Jun 2026 19:37:06 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780688229; cv=none; b=uOqExJi5kVg8ZyyidES6+cBz8W+t/7Vfu5xjmZ3J/9si0h+vJzAX90/aLJcZNcvxYQ7jE+JqQ5bxhDGivSTSpXgtiHereAOrpCObK6/JalULmHYLxYnMlsaklnAtsxeu9rhdlV1IyxnmL/l/KSeBOkDGgiIKILWA+JhuRp92foM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780688229; c=relaxed/simple;
	bh=+9D8worfVBBXRAM6Sf4/c8sftGl8fRLdj9NMNhWv6dM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=gMD80Ez/0oDecqXVszVQq5o2eX9DFa8zei+6dwsZuaKIzvmhQWvKorNNJtM49QDdv+1v/8fyWpGEJa4clB3eRXLOeXRm+Zh7TJWkQLBiR/OLLqQok7FNBslw5od2FwW6s61wEQTD8mBGavhltEwroS5zS/hfDt3BN1NCRjU6j0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=lpo//D0Q; arc=none smtp.client-ip=209.85.160.43
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-4414d76270cso549299fac.1
        for <io-uring@vger.kernel.org>; Fri, 05 Jun 2026 12:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780688225; x=1781293025; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QOlCcgmCBn9tYeJTbEHCkKxBBlh9vdruQOgZ+vUzrIc=;
        b=lpo//D0QeC8ocIlfWL2Z/tWFO3Wz9obS21GEFV2fMMCHdlumn1nDdmjxoD9k3WzYch
         oLfVskqyqeElvU8CKYtFGlhXF0i1WIjhoVPGB/B6ktmOt7O/4gaXtjrvZSnGWeZkEcEq
         LS/doP9luPWXjKEFBv85ejJ+/XejUmYWLH7agPqz0h1fStePQbP/V2s0MZu2JZhlyhtb
         sTl6GwS9ab4FY4NDzwPVxc7/eTP5Ys8Sb3MW73DHndvtgIhzVbtpGh740+T8yjgHiZH9
         V+3gW1p7jn/iVKzulwx61NGB9vYhc6YyyUI8bssCirvIAyvczLHKPT+pmv1tpht77uC+
         cyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780688225; x=1781293025;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QOlCcgmCBn9tYeJTbEHCkKxBBlh9vdruQOgZ+vUzrIc=;
        b=gfdJCOWOG7u4d09hEWb9YYd3KIWk/5mIZtWxyQddCQYQcFv33udLScsVoWagvFp+Cd
         9TOQYh9gLREVGcEqOvUWPdsbethW8lPcIFwgdapCog+uDDNE7P5oNZrykm3wXxHH06c6
         Qmk8Wd7Le5/DVGWSspJd0nRHbABbPrjyT+U09zOcvI8Xta4oxlIAXsAVI16nsXAgPjHx
         4Dp/ygDEQJzHBMlsXfkc3x+hWKqXi5cLSfU2OjhPbyuckw9LM4dfZKz5Rp8TBkAXiP6Y
         HGN7Z7w8F+iCRTA0vH9qwn645ZYLuqXskrh6ofOgmpaAI7KPDxS89MuH1x8CtQwaWkTm
         QpQg==
X-Gm-Message-State: AOJu0Yy+7tqQaQ8lTl5YUirdKGzBX84oW7QZFNk95bfUbWANb8Bu9jhA
	3KR4XMpNcBIhkbla5rZ+NNCdKYmE6TBeAIwkqMv50+Lebh5BSmzP2Eu2gB5Oc8y0I26oRyGGWXM
	X3V0b
X-Gm-Gg: Acq92OH+j+D5rQVeSHRvQ+h67TooMLfZqpYaqB54rmAnZNfTZhrsnOcSOkk3u4PrOdz
	P0m+6jc610KrC3CUJrxs/imuXnFnMwgf9wMnLscnh7dpSVbmTpJHralknXhpXvzWasEn1+5clc1
	dusIOV+mdt9AcdtHMXIasLbp5jeRToGq2XYRhCNqnEprbXO7p1FEJmP7JJ13ivUIzwuEbt0OK7r
	TKBeRtLa9x2l+frM9FDjPPF9C+lIGOMyz3Czzp1/4NEzIZXAYIEd04raRYasfPK6aDEJSAJ130/
	n8x5Xoi1pKbhqxhgdFH9JvmLXcIHYa0PsbV6RtCfLNmYGJMDbKw1WwcElTkLnfQKKDGbDCdxJIR
	/goTGYkYibF2PtY16XNhlgfMcdpcnVrs6LoPEjuvxrHhWjzfQ4oTtgwmv2miDN1fN53o2ay42f3
	RXIQXI5jmcUJQ5n8DTr64O5SHLUraPPX3fnyKNMGM+CkPSDboiN4CAUh3GYvhJ0wnwnflb8OnOl
	ldlNrPwR5BBlF8d1weI
X-Received: by 2002:a05:6871:6c0a:b0:430:3591:26c4 with SMTP id 586e51a60fabf-4413d6a1654mr2640025fac.7.1780688225462;
        Fri, 05 Jun 2026 12:37:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-440d8295aaasm9163210fac.9.2026.06.05.12.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 12:37:04 -0700 (PDT)
Message-ID: <956f675b-1106-4e26-86ec-8592bafd99ad@kernel.dk>
Date: Fri, 5 Jun 2026 13:37:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 7.1-rc7
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-13616-lists,io-uring=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:torvalds@linux-foundation.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B965964AFB8

Hi Linus,

Just a single fix for a missing flag mask when multishot is used with
an incrementally consumped buffer ring, potentially leading to
application confusion because of lack of IORING_CQE_F_BUF_MORE
consistency.

Please pull!

The following changes since commit a88c02915d9c6160cfc7ab1b26ed64b2993e2b94:

  io_uring/tctx: set ->io_uring before publishing the tctx node (2026-05-24 12:01:15 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260605

for you to fetch changes up to ed46f39c47eb5530a9c161481a2080d3a869cfaf:

  io_uring/net: inherit IORING_CQE_F_BUF_MORE across bundle recv retries (2026-06-05 05:20:25 -0600)

----------------------------------------------------------------
io_uring-7.1-20260605

----------------------------------------------------------------
Clément Léger (1):
      io_uring/net: inherit IORING_CQE_F_BUF_MORE across bundle recv retries

 io_uring/net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
Jens Axboe


