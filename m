Return-Path: <io-uring+bounces-13219-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cP4iKE4q+Gl2rAIAu9opvQ
	(envelope-from <io-uring+bounces-13219-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 07:10:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 021F54B8746
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 07:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49B203013492
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 05:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF50C266B46;
	Mon,  4 May 2026 05:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="jDD4ojjw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FF525A2BB
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 05:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777871415; cv=none; b=Vu9kZ+I63CB8YQ/TZWfKQm83Q+PzncpG7a7hk2J8M4uBKJ+L45ZlLDy7iJtssSWslNiGUILohVPJ7i52Yde4l3F3iG+nRdd7IJqLOymTZRSH4iQoH5mDZz8DHQ30guFYLB6WCCPJS8HhB4/s0cwE1x8y/uIFMd2gx5ALcy8VhpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777871415; c=relaxed/simple;
	bh=yEjl9iFNQqa6cMJGG/IVyEPQ/rgDZCCBqjHLRfjlX5E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Cjce8ZaxFu+l2jI24kOimTvo/HuZdEFDVFs08fsKH3yRCwpqPcS/Dc/xPHF2p/r1sIISoUhHsE4gmTAcFbVRgdnZkEUPWQ8HrayICnINa1IJ/YAhjvID8Cw7fDLLJPW5PO7PoLW6Ko0JYjhat8eq2kKFKiauzgCCxPLIpNH63LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=jDD4ojjw; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso38216515e9.3
        for <io-uring@vger.kernel.org>; Sun, 03 May 2026 22:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777871413; x=1778476213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GY6/SYEMpOXuhpz+WoweZwGuxIrPXA+rzEqcCbsvVKM=;
        b=jDD4ojjw9iiZALDUSVdKYD3yx8g4tjPVgWmPwVKQnyylCcFz2j4T+GncoQ2u7ZVXwi
         MkFhUVrPDH/w5ch0GGnt2jBWJwK0EmMIGZUOMfQ/4ptfPG4YLPz10+pCJNlnmq26gsci
         SvfNg/TqzOXkBnAB/xzpj40+xF5aHscnqPn+kBjWFL9i42guHjcsqEPVieGecwTE9WlA
         xmRLOTc914YbNg57MsGxV6889rnzNRdzZT8Kxjyg9I7jcqLO7kirlR5OtjWRowI3oVvl
         rJq71opdXaCqODNZSr3sY7HdElN5b2bNBjnyYoYb9a6sb7lWOJO/fG7qVivQm7Hd7hJw
         Fopw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777871413; x=1778476213;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GY6/SYEMpOXuhpz+WoweZwGuxIrPXA+rzEqcCbsvVKM=;
        b=EaG1D9yd2fR9z04szaxPgtlaIUFgVVNzNb1Nu4knzd9aAYMaKC63WA2y/D4dw1TZAp
         BFihcSQ+rDsuBjZjpt5K6WVSWDcaaMubIRjX2pTjIpfungxgO7ipdut6fPsP3Gsq9NBl
         6YNNCBxLTXYErZPYD/BbmSybkwFz1Eee4+4D3hh8kjTgndlUEUpVRlXAwdr22t0okFjA
         /WTFeMWHgptCq88f1Q6MTHRKa6gy6vBdJr3q2Q4PdV7Tw+NXW2A4LVgzR9QERbwRkYZb
         X60MuTwa/7IHVjiyKIaYc9F3CfkLN/tx/SG/AYbeAwWLbr5N74oDtRWb7WVuG62PHg19
         sDaw==
X-Gm-Message-State: AOJu0Yxzf3WwEL0GX/XNSBT+5gJa6vwuyDGkFwuVfR9vnNAmT4+aKahQ
	HioGc1gOIc7zecO04dODMsvIlJUPRj+GzRvqslbCpLhZ4Ut3BfPVcGEtRnpVQKypO0v8e2mml7g
	+QTUzNIrW7A==
X-Gm-Gg: AeBDievvu72a9IdYRShnDFN2AHDOWygqFRR49J8H8AP5rlv7PF5gaVHh4uwsW6VtuKz
	cA7ZBWRm6owhvgTPj4MBExwyGFYl+U2SDod86oHTrwT/ddCvoYyEqz/0/lShkULcI6aqYQeZXhO
	LWQoxcH8qc8i1Ic99NA6lIfGT0BlyM9e+QQPnwB2yfi2pgNr313KFzbnSGBnqNjAUI7vE9U0VRX
	3rVYhKOae8Wg1nteZus1QPZKOXMrZ9A7/57s0uXLHUBe4K9NmQixzQYIy7ouI/07xCKk1mx+1DR
	y9+2gdvrrp+8v53chwR71PkMXi1Sjd5MMnvHs5q97j78APX6P8W1dUDiXfPtnc5t53Oyr9p04lb
	MxTa1W71+gcFrMwN0/i8zgnh3xEP8gxcjKBsAi/zkzYbK3c7VBuZHbnY0V7ZQhOi1+ccGKuYOoU
	gzfVvGfVt2OjzhTWMN8/zDp9lO5VzRICrhfCdc8izCiea8psaNXcycAiV0bwx/UISLggh5jggW8
	vnJ1DyTsXaYIwut
X-Received: by 2002:a05:600c:8b01:b0:488:ab26:8fe0 with SMTP id 5b1f17b1804b1-48a9865d987mr141096065e9.15.1777871412701;
        Sun, 03 May 2026 22:10:12 -0700 (PDT)
Received: from [127.0.0.1] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a9919fc3asm79515965e9.0.2026.05.03.22.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 22:10:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Yufan Chen <yufan.chen@linux.dev>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Yufan Chen <ericterminal@gmail.com>
In-Reply-To: <20260503175710.37209-1-yufan.chen@linux.dev>
References: <20260503175710.37209-1-yufan.chen@linux.dev>
Subject: Re: [PATCH] io_uring/eventfd: reset deferred signal state
Message-Id: <177787141023.304027.13516745291264064485.b4-ty@b4>
Date: Sun, 03 May 2026 23:10:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 021F54B8746
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13219-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]


On Mon, 04 May 2026 01:57:10 +0800, Yufan Chen wrote:
> Recursive eventfd wakeups must defer io_uring eventfd signaling because
> eventfd_signal_mask() rejects reentry from eventfd wakeup handlers. The
> io_ev_fd ops bit tracks an outstanding deferred signal so that the same
> rcu_head is not queued twice.
> 
> That bit is only set today. Once the first deferred callback runs, later
> recursive notifications still see the bit set and skip queueing another
> deferred signal. This can leave new completions without a matching eventfd
> wake after the first recursive deferral.
> 
> [...]

Applied, thanks!

[1/1] io_uring/eventfd: reset deferred signal state
      commit: 0f32b6daa03ab8c1831f650d617f59447af31172

Best regards,
-- 
Jens Axboe




