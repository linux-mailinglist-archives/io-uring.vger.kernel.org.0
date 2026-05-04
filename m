Return-Path: <io-uring+bounces-13218-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id V/SYMTgq+Gl2rAIAu9opvQ
	(envelope-from <io-uring+bounces-13218-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 07:10:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FC2D4B8738
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 07:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 14AF73005AED
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 05:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F840261388;
	Mon,  4 May 2026 05:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="hGn6Rd71"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0137421257E
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 05:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777871414; cv=none; b=J0c/8vSytJVpAU6tOoCSaYlpMtcXIp84FSLDmzOiH2ZFtc9txhg+p5bM1qaTg9vYkijzMCAZk+SluCnYinpoH95ui9Tl5+aNhqTe7elubAPgq4NDeIHuPmDgAp/gCiUUjOumDJRkLNCEm8gXUn7b2x0lDv7yl2awTdiReDvJmLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777871414; c=relaxed/simple;
	bh=Wi4akL4trAU4b/Gemynjh0OqTGZ9OlVQhG0FkucpxRE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HRrTo8l124JN64o6ByZirFVhvtZp4/aOUrOMA3zK0P8va0mKh/ei3ojFqVerISGvW8IwIjVG2ForECa+vnj88QUylE4zrhnI4mucO79mIGc297DyCsYs+mmL3ucBs1D+ls3S5UE6+ftZULsMvd93QLSt1gUlTe77puuaa46byAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=hGn6Rd71; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso24810235e9.1
        for <io-uring@vger.kernel.org>; Sun, 03 May 2026 22:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777871410; x=1778476210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pp+tesmKLOH/0Wzuf0WzvlSm7H7mw+EteHM5VM/H7ik=;
        b=hGn6Rd713i2LGSGUZB+/k5WOQuyGROhFgbEPmFfpuQByJkRKUKRd10ABTDHaE+jO+B
         GX7l7Q75MHRGpnnQsMUT+qSbuie6lRZr3RZZBzDKcadyf2fj33Ulpj+n0na5XZvjJ4Hm
         74Y8c7aRCaEGkEgRaQXFRwYgm3+UhYLlqN4yJMofxs18uT8pQoeYkVthyzkFq4+oA+G8
         ytlZ0KnxBtDGyTfNG4MWF5raRjogzI3xWuXuPpTLt4YhqHTIrNPi9gnzC1C0+InxpL3X
         S9z4katqMn7cCwPCdcG+KuWzE/nHtBwm4BMrQx1//QYZ/O9eaVbiHzsAZMFbSY/0Kl4x
         kTsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777871410; x=1778476210;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Pp+tesmKLOH/0Wzuf0WzvlSm7H7mw+EteHM5VM/H7ik=;
        b=l5MlGvHJtdZ9J6EMgKuHy75A+Kvh0aprUHRmPihQMNArsNMYC1hN2aHSzXxBN8vZIY
         oaX4vRs20jX8+bHPsOYEBiXE40F41w1pxLi3chQYrVkkmkVGt2dc4cPh2ihEfSCE8mVV
         7vS5F7LM3jpuWIZQx9zYJv9AOc7JuTSPldogMlGC2oq/Ki6gfd9Ovv/OD+5QjZjtq0l8
         o5iEadPGqbhW88ETcrlUY/TeNvrPmCzNac6xTzwO5cG6xTU+esDoYvjSqOtEmSfLdOQY
         yi1QZ1sLr110nxhkxJoJloUUQcIACLR4+/ufmaCJFIAdP3KpIBUpACOWAEQ8+42A28vI
         xpQw==
X-Gm-Message-State: AOJu0YwngMEh5Hwj3LyZIe/xNPo85WTGpWDn1bZ0nVAhF326f9JqH2IS
	O/hNc0K6nWYaCCArFkAGsL9vxlv5In+U2KZcbO7iUJhx52Vsq5QjG6tc9BfbyUs0gOg=
X-Gm-Gg: AeBDiety7QDzGXXkmUuohdYx0EoKs87wJb9q99HGJgFUJ0dQGBl8v7BaV1QY/FIMK0T
	3yJoJCJ6evrEEQ1DoBhA1+x97NeEZhmyfxIRBfq19NIMkBafSzbX4ekp6vpmvnTFQ+3Kp2tKWzB
	nl84KP+1HCnEbFmzh0XPKcDwR0a0lwxSu/oBC9VcNDOp9O3tztle2wcq+3jsyMeKsv5W/r9J7mz
	CZSGIpg3qSEGJuC/QIwV3k8HX6d7IAKDNrHPXOehIkPn/M3zd48hZPMeRADi3hUqDmXt0tXR9D3
	A7pPh+lO93G/CPB3wtjphu8a+iAjlRSrWh6YgMNgpVCODgJ7+TjGj/shnU+TniygJGQ+e8nJWi8
	Um8N6feheod/ULVICaSQM/XdANLOVZT/fdxv0R4EJhFAIP7Xs17lAm9w2fgXBliK6H1aNrZbN8k
	+E/ur77j5EgfICEkka+WRuZQkDZ+lrXQJUHT8PdRUeMZpbvNrYbVXaSKgIQnYeZDi2Za/MMLqS7
	msWMiI+PF65JRZi
X-Received: by 2002:a05:600c:45c5:b0:488:a916:14a8 with SMTP id 5b1f17b1804b1-48a98871959mr128927675e9.10.1777871410110;
        Sun, 03 May 2026 22:10:10 -0700 (PDT)
Received: from [127.0.0.1] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a9919fc3asm79515965e9.0.2026.05.03.22.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 22:10:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Yufan Chen <yufan.chen@linux.dev>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Yufan Chen <ericterminal@gmail.com>
In-Reply-To: <20260503175610.35521-1-yufan.chen@linux.dev>
References: <20260503175610.35521-1-yufan.chen@linux.dev>
Subject: Re: [PATCH] io_uring/napi: clear tracked NAPI entries on
 unregister
Message-Id: <177787140910.304027.4176017900105568529.b4-ty@b4>
Date: Sun, 03 May 2026 23:10:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 2FC2D4B8738
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13218-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]


On Mon, 04 May 2026 01:56:10 +0800, Yufan Chen wrote:
> IORING_UNREGISTER_NAPI disables NAPI busy polling, but it currently
> leaves any previously tracked NAPI IDs on the ring context. The normal
> wait path only checks whether the list is empty before entering the busy
> poll helper, so an unregistered ring can still observe stale entries and
> run an unexpected busy poll pass.
> 
> Make unregister switch the context to inactive and free the tracked
> entries. Do the same inactive transition while changing the tracking
> strategy, and recheck the expected tracking mode under napi_lock before
> inserting a newly learned NAPI ID. This prevents a racing poll path from
> repopulating the list after unregister or reconfiguration.
> 
> [...]

Applied, thanks!

[1/1] io_uring/napi: clear tracked NAPI entries on unregister
      commit: 2c9cbd7dbde2462dd3d91f7a24eac2d142aa4cf0

Best regards,
-- 
Jens Axboe




