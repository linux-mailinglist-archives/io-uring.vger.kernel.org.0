Return-Path: <io-uring+bounces-13104-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aI8CAXLQ52k4BAIAu9opvQ
	(envelope-from <io-uring+bounces-13104-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 21:30:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B7043EF23
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 21:30:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 697BB3040C51
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5CF8372EE0;
	Tue, 21 Apr 2026 19:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="gOP28s6d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419F11A2C04
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 19:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776799854; cv=none; b=Ag6TNoSTHnQQF7h8JA4axhb6V9ITW6tKjk+wWWOdA6WQsmjG2V7ecWcX/IPBrR3wuQCz1Z9npYOB7UWFNtZiAvDBGWw2VL9CdpYJ3ddUlHZKxRYMwGboXa6COoQRcu1NDRlQomQwbfhkYxfEtm0K0Xn3MoY1muQVvCfIvY7DUp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776799854; c=relaxed/simple;
	bh=izktAEpR0zjbCNvGlVSiBZQsxVo/NserP3PIwIup+6w=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=kCQ/6BIumUPP5Fg1pKqq+WXp/YSZnW6WECmKu9fgZylCwkHn0Uqe+Dy78hTvs2Sfp/ceZSz6iyWXa46BphsEDKaunSzfflQjArYut4YFiVZY5EC/ATsOuc6gq7GRBjDPDTX5ydDDCj1jfM7iBmCxfv1NVqBAW9VNSFpq84yph7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=gOP28s6d; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-479fc1fc048so251998b6e.1
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 12:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776799850; x=1777404650; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VknmcEvTp3P+iF96D9ozSRevJJ2Kb4TjccTHpOljuBo=;
        b=gOP28s6dsXzQb278jbhKsgPzFVt+ZDkMcKUQczPIw5DJ+PTHOSqp0DSraGzYdW8cdC
         7lgm2gEw/Lul7H1s3qQ0PnfmRlIy9Trp2UKmhl17jMJpqSMssszzm77GIeZqcpmilEMb
         M/9LQnQq3DccU7KMfCzt2glv7qGoLM8s39SgAG6xxT/AJZGrAT3F5GC3VrCNvBgdwiXF
         ByhQ+bivWE5YC/g/A6lz+sMopbzfG2zkyxKBzeRsYXR4zmPfYfFKYL5IG/Jp0FR2y7Dv
         g1YnFfrKuKTEl0ZXVseqCJnPFyzsGSfTFnbaUMD4yu5JUQsqpNyOpARs66fAUrTg8+Mp
         9CZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776799850; x=1777404650;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VknmcEvTp3P+iF96D9ozSRevJJ2Kb4TjccTHpOljuBo=;
        b=axNkXcuoABfGedQZaHD1WKCZrE3pALf4ZG8ddRlNQ5oaANM6ANdxp0iWM3m5y6AWrI
         R9egBIk6ulJzcm9TAKu55yFZ4e9HASnaXmjOqrLXofpCR22kwWeJUHBD1z/qGfoTzFI5
         xnK+/qZjTtqS9c04s71ij2OCn1ktnzqC+4LemB8irJ+N+OwRZyRehXj1MfWl1CvV3M3D
         u0pejRDOOA9fvIE151WVGAR4s9rFja2DNVqxcMnze0ZQcAhFJS1RTp3/mc9xjfEhLWZb
         pCpAt2P/HSJUnwu6RgN8g3fzXi1rMcdvoPGLKakQn0dNP2ItbI+FnyA0C1Vrvzc6XAXY
         AoUQ==
X-Gm-Message-State: AOJu0YzlmZkBrJgPWbIjliL+fboWBdPP6w1JashIt4sjHBIfXk5Kx1Q/
	hEvBaVF+dj/pzNQIge5MVgbhckupBeIKEEjTQfQ+hsN6gm81gr96XIIX5aFt/u2I0l3mJms2l4d
	IY7wvSRU=
X-Gm-Gg: AeBDieuqJf0vQhcBq8Tb6e2IR/EfvWUaJo9YQz8udG7BlUv3Tgcq5bnCxTfnQPwtApN
	jO/TJnuBkn2Hcx5VnInyJ5+KrVGypmiXJB8zX+YqYbq7cxiB7O7hojRuqVsbv2e9Wq+OoyAnEGk
	DIqX8XUyyqDIzma3o1lcxnXBU966FrnlGPnL6bre1UtM7LpCS8CPxoTfXCGGxTrS9BPnMlTU3he
	uwG58yS+bHFh8yeUh23yL0ddq538d/cD3OFvKXJl0E/7lqCHX8oGsqUJ3Ii579/n7iJRDe03Kak
	GjBTnA4ULsYY56wWMBWnuNp4Ccqc6wy16ro37CYrzCWJqqJLIophsUF7SvVGz1Wvb8WueRviYAS
	fqNy9NxGsia+/fAIUGiQLSAAn7pRN4/b6ikaqeCc/51Cy22pyEZhfIN8uu87R13OeWaG6vuX684
	Jw3Ofznbe3nqYv6il43qQstTxHSvglqynwSH7qb0v+ArjWTaoLL5go3txr/LzdEvY0A3s5jmCZp
	XXeEB3ZZP+pZ1MSOhc=
X-Received: by 2002:a05:6808:148a:b0:45e:f0ae:bc0f with SMTP id 5614622812f47-4799ca8c0femr11014839b6e.23.1776799849742;
        Tue, 21 Apr 2026 12:30:49 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4799ff36814sm9800418b6e.7.2026.04.21.12.30.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 12:30:48 -0700 (PDT)
Message-ID: <bc35ebeb-69f8-491c-98bd-b563b8ff6778@kernel.dk>
Date: Tue, 21 Apr 2026 13:30:47 -0600
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
Subject: [PATCH] io_uring/poll: ensure EPOLL_ONESHOT is propagated for
 EPOLL_URING_WAKE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13104-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: F0B7043EF23
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Commit:

aacf2f9f382c ("io_uring: fix req->apoll_events")

fixed an issue where poll->events and req->apoll_events weren't
synchronized, but then when the commit referenced in Fixes got added,
it didn't ensure the same thing.

If we mask in EPOLLONESHOT in the regular EPOLL_URING_WAKE path, then
ensure it's done for both. Including a link to the original report
below, even though it's mostly nonsense. But it includes a reproducer
that does show that IORING_CQE_F_MORE is set in the previous CQE,
while no more CQEs will be generated for this request. Just ignore
anything that pretends this is security related in any way, it's just
the typical AI nonsense.

Link: https://lore.kernel.org/io-uring/CAM0zi7yQzF3eKncgHo4iVM5yFLAjsiob_ucqyWKs=hyd_GqiMg@mail.gmail.com/
Reported-by: Azizcan Da?tan <azizcan.d@mileniumsec.com>
Fixes: 4464853277d0 ("io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 6834e2db937e..0204affdc308 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -417,8 +417,10 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		 * disable multishot as there is a circular dependency between
 		 * CQ posting and triggering the event.
 		 */
-		if (mask & EPOLL_URING_WAKE)
+		if (mask & EPOLL_URING_WAKE) {
 			poll->events |= EPOLLONESHOT;
+			req->apoll_events |= EPOLLONESHOT;
+		}
 
 		/* optional, saves extra locking for removal in tw handler */
 		if (mask && poll->events & EPOLLONESHOT) {

-- 
Jens Axboe


