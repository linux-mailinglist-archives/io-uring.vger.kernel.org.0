Return-Path: <io-uring+bounces-13456-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNE6MOHoDWrr4gUAu9opvQ
	(envelope-from <io-uring+bounces-13456-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 19:01:21 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14FA0592D0E
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 19:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F3051303D4C7
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 16:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2182F5A06;
	Wed, 20 May 2026 16:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="xxJ+oFaP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75923225A38
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779293080; cv=none; b=Mbi6cRCP5N2xA+RUu88sjSaVOtFbT3zveQAyr8/UpiC3udlK7J4AnNPL2WuRxcYsWf0+U4IvyhwFtEa3QHS7cH6Z/l5XsYMlIOpkERDaavNEeT3prGINUpm6xVRXjee2OuwqT4sGaOiyaEE4Ci7hM8XHy/lqLCmzW+HYCyQf+uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779293080; c=relaxed/simple;
	bh=Jeh2zKlmTevQnJWu/eDk3cwfKcQax505QlCrRt8SjPM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=CWUrgvukxRAU2ehxBi9/Fs8pezSQxJ/tJX/lERP5FcCuYZyjtJGt5ZEH1MPCT964PXJ/hmXQwftxCab3JKZBqm05IOwdee8APTZ+ZS5WU+xfkaoN2b0ORex5gxRab5gvAk7y8Q0H48T6TUcuDKSvOcDi0d044mtxWh/6byQthxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=xxJ+oFaP; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-43587e63a8eso3302263fac.0
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 09:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779293076; x=1779897876; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nBib94uW8hYiBJJ6KgF58vAvMDKBEMP/MQwMvS6BRWA=;
        b=xxJ+oFaPxAxUzz6SWnwjRRp3g23RAkbiluE/48g4P5SWOT42tPG27O4S3S2T207mKc
         CBlMiIqWLR9T8n1FCHe7MtwMtSyyKlts+VT8Y0x95VcMqnO7/Vjsf1gl7JrEyyqkyWjJ
         64a9QXiR/PFd77BW8kmnbN28rzh4XxfGpmJxc7lnZqkFe3UrBblogXkTkzt1+itycFey
         aewq0yfilpFbCMyKha5wfKgHxDh7g6DPPh3gZY5L/KRJ6niebwN320X7U2lRgS/8Qe+x
         w8MB6xi1XW/BuKllPKYJZxqaIStO+gkrHDT6oakbypSXkIm9id0D4E94UQtGCXayxScL
         0yKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779293076; x=1779897876;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nBib94uW8hYiBJJ6KgF58vAvMDKBEMP/MQwMvS6BRWA=;
        b=X1CeiXCqVrz55hvlnoL7M2QrjtklpbcysGEysn6Vhl4YwTCYjz0tCHllNU1f77Jlg1
         eBD0mJYM75ucdd7oxVsjoKBmy5mBb9DB16YSAieHrQUCTX2DrmV1J6qaSyNSdXife/H/
         pJWhIB80JVoR9BmNwkVa1Dj7ORVgN6QtU8ylQDHfkaI3D6nuP6C3plfaIc2dekwWbUW1
         sTJ+UUzodeF86jAAPLOqG4uYm49itqHsnX3lUXoRvasDVgqnO72n92z4w/Ue54MY5mMN
         iJiiWpASnJxRqLSm8VzZMPEXBN7nwF7gXBVKDAIpAyH47xJmVwsIlKV/4kq093X1oOv9
         IEIw==
X-Gm-Message-State: AOJu0YzKQV5fvLjWGQNyH3qUb01Q2ohHruLw1C1rN4g1vtdA1rFTHmO3
	cWFZBgAa5BRB1Ue/qgN1wllUITRjUKOURH79MBqI5LAqVbBS3qnYzNsihQZLd1xVX2XL7jIBjLT
	15XHX
X-Gm-Gg: Acq92OFWrQO5Udr0M2OlsEY9aK/8qVjzUtrmX1E3J960/hLd2JhtIxOL5uT5sSInw96
	R59XpkAeo08dzuLdXGWrfSC/iTCk3knMmtcHpU+XYyyBkI+BDOoe7R3/iCxSnFhfsz/XzMJxSOu
	MR9HqTkY2bY0XCjf6jY71Ml5e+yY3PQugM8bRQ/E5jQVuEXDMsUxpxSGnwozfCizrNn+VpceOLo
	vGEV5ZYKIstjs7bh72cM0oYu8dc1AlXB/eqKNYy4f4V1aKeqDXWTSt7Tku+3wjgH2MIhU7IJ8HQ
	oTBsZcFpo7xqtD7tke+9hyr8mY8cZln8dXrZIwUtyNiPvm1lSOalrwhmwr47DNkWUzWq0VhJG4e
	oqFCTkzgdO/ygyGhGWzK9G77h989i0k0IGvMpgqFoqetghYKyypMxHrRd/S7kUIzhDImxLqduJu
	KZicfJVwQT353txs8v6IcoSFM/97TVDWRJ74CjywGXug8+hvb9mEWQ5sVuXvJdAeL+gqvAP7dJ3
	rwAPUoY2KZHvOAtml0=
X-Received: by 2002:a05:6870:c245:b0:42f:d33a:41e0 with SMTP id 586e51a60fabf-43a2defc267mr15860224fac.22.1779293075641;
        Wed, 20 May 2026 09:04:35 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43a956fa142sm10395377fac.9.2026.05.20.09.04.34
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 09:04:34 -0700 (PDT)
Message-ID: <6171c1b4-fa7c-478f-ae61-ea0c0e939e1d@kernel.dk>
Date: Wed, 20 May 2026 10:04:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/timeout: splice timed out link in timeout handler
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13456-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 14FA0592D0E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

A previous commit deferred this to the task_work part of it, so it could
be protected by ->uring_lock. But that's actually not necessary here,
and in fact the head clearing is not enough to make that safe. For those
two reasons, just re-instate the local splicing.

Fixes: 49ae66eb8c27 ("io_uring: defer linked-timeout chain splice out of hrtimer context")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Fix for a fix that went into the current 7.1 kernel release.

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 6353a4d979dc..c4dd26cf342d 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -417,8 +417,10 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	 * done in io_req_task_link_timeout(), if needed.
 	 */
 	if (prev) {
-		if (!req_ref_inc_not_zero(prev))
+		if (!req_ref_inc_not_zero(prev)) {
+			io_remove_next_linked(prev);
 			prev = NULL;
+		}
 	}
 	list_del(&timeout->list);
 	timeout->prev = prev;

-- 
Jens Axboe


