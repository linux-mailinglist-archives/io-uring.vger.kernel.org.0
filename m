Return-Path: <io-uring+bounces-13050-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OGn9EE/x32kCagAAu9opvQ
	(envelope-from <io-uring+bounces-13050-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 22:13:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 51DE940792B
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 22:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D24FA30AC988
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 20:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99797383C6F;
	Wed, 15 Apr 2026 20:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="JpB/fRFS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9E730596F
	for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 20:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776283979; cv=none; b=D438MjYK/txGS+dZ8nI15wFhAwAiZQgjKv4y0XsHjsWCfLe68SSqLr9oNKr/puy3JIguzNxctvyfQ971dPyTT6RvOzJB/xcHR4rxxYb6abNPsRqcYhkdkFNVVcQzVTsnWlLyVwubzvC8Kl3gSxlfbUBUOcdlZIoX/zY8rP6IA7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776283979; c=relaxed/simple;
	bh=4M2jIThP/wbOPI9YMLMZwTrFEUruG4Swhlj83aBv0W4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZJ8ZEOz4mpLcaivob723/O7Z378Zj7ZO7SboLEJLvAo7EIix2AsbhWaJl+qSJlcyZewfX2H/4BaMPfvAoaKljrSyC7bFmBCmqyB3MKZaxq9+LVtlL0E9f+SQ9cVHcfD6X6IUESIbZSGBBSLX5TdEwVj7nVch8A7UOZmaEPehJfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=JpB/fRFS; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6891abb73daso3446824eaf.2
        for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 13:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776283976; x=1776888776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=veanHgEaC4BddZnINYfZrwIcIC6tAj/6DhGIqPCBjLo=;
        b=JpB/fRFSRxPhfNp1PpAHSvB+hyxGgiS35Eizo4uuXvKjPxRm9/lZQFh2hHSFy7S3t8
         jMl1IeZGS94rYJSVJzK5EDtWdN24kSGINBeBfnLzK30g2jBnGhQUPRLgkACYDzDLnCc9
         6qGvLKY89YKEKovD4esTL7SnUJD56ggi7yM+AhVK/Fk+tUqiTCUb5oDmDkY4+Yo59P1/
         idfv3BCIifi5zuGBJBOOr5h7Jkobm0iGansryuf8c6TAMkfJLkIIwMxdSeXuAmLSr331
         xXmTmOlF7Z3tTqzlwJ4DammaUXnPbePelLT43muiqCEBxuUnSyPGg5O2fQMwB3P950Lw
         ZXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776283976; x=1776888776;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=veanHgEaC4BddZnINYfZrwIcIC6tAj/6DhGIqPCBjLo=;
        b=dmaWFAidc+f6o61maqnk8xzCeI0Lvoq4iiYhNidmSuDW5bZomfaVDTF0W2Zkko7PhT
         w1LQxL7WCEDbwB15xqW1cpJyfK5APKb2kW4SBV7S0JUB8VEu6nRKRyPo/xuQMNVCGeGX
         JLdeus/jVloaXBDi24T7px/kCXQucjQD5PeO4qTH26W1Z/G0xpw9/FPO3DDapFfoaW3i
         WrMy1fUHXjiGAm44V9InMCH+CH2MtYGSVI8+5AON0SnoMMPlG4iVlOuBSl7oOYV52m9V
         UV4LH2MxNKk9r28nqTUEQOZyW3cKXJ4qwtMSheCsBf3rLK/llLrPuB9vPq4Q2GIb+B2E
         ep/g==
X-Gm-Message-State: AOJu0Yzk4YqX25WIUeuP7gR8SiW88Mi6IzQcqNpi7B9cF6Q2R5+PEWHe
	BtE09qh8vdLM8EeUJrnexTXH05gCjBnjlj+S9ZCWNPlvjdvjOG1yIvUd2V6ik4te2qD+j9fSyR8
	VMtyh
X-Gm-Gg: AeBDievItWfUnLGzTA7fPg7/A9V2UgVwcGEDZ6tSnFeImnFpgmA6MbPnHbDEfZxCEz1
	BIad/A0QXPT61mRvToFWvE1tNbv34jdO9A1SdceIu51Z74rxPBZlBRG444TOeE4BSK1x4oFxeI0
	wYIN1B0ca0aWJC8AcCyrehQFYFIlzlcVuY63rRe5Vmix7sItXTRijXIq2rNwDlBzj2mc9CIumot
	5lILCzz36td8g4fzVdgzzsHUju+bxRrYuy5mP0enu6M+T1vrr4a1yakNMZmO9tRsrRhiBVhzwSe
	9FJJ0HErj4ai/tGE3Tkaz/eS0x/cYwjj96w+QXscOrIfa64ruuc2Uj5taCVVcOOjQLJwK7by8LT
	C6ZcIYLExxyedKBJfRz9KtUhne5eEdVvKC4wqR7q103hEZXCB1xIfQAmjrH2+2Xy+KVWGz3NF5R
	EVtmNLVoTBxLVQ1f5ee1GosN80zS/DYgTwfVPhhQGG2r4l+W78hZMJ8BtWFER6GeutOenkgVvD1
	0/R+qI7mmCut//2aMMPnk++C/KdnMOYRMAIKjbl
X-Received: by 2002:a05:6820:4b89:b0:680:1a99:6be2 with SMTP id 006d021491bc7-68be2c4f5e8mr12538532eaf.0.1776283976574;
        Wed, 15 Apr 2026 13:12:56 -0700 (PDT)
Received: from [127.0.0.1] ([72.170.223.83])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6932ba69701sm1577878eaf.8.2026.04.15.13.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 13:12:56 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <35996dec32a78ce0c93dff43197b52cadc2696ea.1776003410.git.asml.silence@gmail.com>
References: <35996dec32a78ce0c93dff43197b52cadc2696ea.1776003410.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests: fix zcrx tests
Message-Id: <177628397318.681988.13087182622146022851.b4-ty@b4>
Date: Wed, 15 Apr 2026 14:12:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-13050-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 51DE940792B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Sun, 12 Apr 2026 15:17:31 +0100, Pavel Begunkov wrote:
> zcrx.c is broken and clearly nobody is running it, do a complete
> rewrite. It covers most of the cases it was supposed to check,
> especially around invalid parameters, but also adds tests for different
> control commands like rq flush and export. It relies on ZCRX_REG_NODEV
> and doesn't require real hardware. It can get !NODEV support later, but
> at least it allows to exercise most of paths on any machine.
> 
> [...]

Applied, thanks!

[1/1] tests: fix zcrx tests
      commit: d8583c5f8d1bb2eaf226c15e2a1a9da74aef5dcb

Best regards,
-- 
Jens Axboe




