Return-Path: <io-uring+bounces-13131-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GIRyBVnb6WmNlwIAu9opvQ
	(envelope-from <io-uring+bounces-13131-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 10:42:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AF12244EA95
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 10:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4A46D3002337
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2026 08:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A403C6A27;
	Thu, 23 Apr 2026 08:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NnB6+TYo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07013DDDBD
	for <io-uring@vger.kernel.org>; Thu, 23 Apr 2026 08:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776933665; cv=none; b=QLTIQoG0kXHx3oNxk5q8zt6kW5EegWsblJpGY1/yhi6jikaiHmlntVbRwRyIsKFS7RpqYPjx6c6FKoKxYHIaTuWuefDvmEvO2rKhdtDEXYMj60cEKvfTZRfhEnjczhnbePsTC2/A+YSFE/ivAPM34ryLnGM+zQb03fVHWBU0N6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776933665; c=relaxed/simple;
	bh=7Alr+b84YmA8dwYrW+JWo6hpo1G/eRkPw5O8+Py+Dow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7ZbBNkmqdBhxt0C+SW5y9Y9ON3+o2UcErljGKFrvcITWgt/5N7Lytl11GkAc6iY+r5iEIacfNaL96Q6ZNMY97zwyQL/7v8Jwuq5/oWX2J7jsmVQBemmPq4ZwDc4EjiPGsYdwkZYVvd5erymlSPBhjPSrXGQ8poD/ItmvlghPU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NnB6+TYo; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82f0647ce27so451854b3a.1
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2026 01:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776933664; x=1777538464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JqLSOmOPVGWKUoYc265cigMlJk7MPx52K3EKiqiJqxM=;
        b=NnB6+TYoU+6XsM/zcx65Nilly7e4MxMWm9tZ6fuobT9PJoMJF7G2y4W9Q3TGF8xDoy
         uEeGM4GvlANMr7hjSMJky/ASp1wmJjSgQU0IZXAvFfNLAmkMENcXq/ro9mWKn35AxBQz
         PvRwHK3dA6uaq5tWqWC6fYQ/+TLe9ZbOLNSCwpAmBzSbyXvbHAmT7HCAnddXAkD3YXJj
         oiynw7ye/L23ofBsD8vg87o1ub0DnbEX1WUzaIB9CtezgXedF/XAwoKYrgmuE8jXZO89
         eK43yhA4oLDsn88r3Fcl5xP4qAPZBDBFN79MrBTVTFxlDl8KOlD7+ZzHZGYXLExp8g2R
         3ZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776933664; x=1777538464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JqLSOmOPVGWKUoYc265cigMlJk7MPx52K3EKiqiJqxM=;
        b=kST+RCfBikerWKqoHP7VVgN/bssLPKWvm7hn/4vAk2pykNrJwWrFBW8GTDNKKefN4l
         3THaVZRkLz4PO/OrdEW1cpLZFIStwayy0nrlo3/yORssUUozF5oXWrElYeAEwRBNkr+C
         vySIASkkRO4tGSnKAXhj7M7L4tLD6qOc4MGD/6Td3SQvqdT7rLgvzfXSrIZ36S9/yPvT
         h7Xtl48yg3FCy/zMY8zCKZ7IYtyWErhpa8pbk/htbhB9NGzxYeNi2eQInAN6xu/bnnVy
         ao4vqS+K1XX1frlAtk/y69kIg3Eyr04cSyGmPK59HnLJG4nD9zsh/XIsXeIFy34YL8pS
         KZKA==
X-Forwarded-Encrypted: i=1; AFNElJ8H1vpwrLwmwf90HPFR13D6RH24KjyagGrptxO015pJ88F+UKRLWhKd6lUXRa/Eer1CXcnLDoSDeQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZz89eOLastakdsPvplWqe7oGk/UqnxAnD72G565Lt2B1HLJ+e
	nBF7ZBQwG1fVRwggMGz82jDgtld/R6kKweV61ukJArYJdutlzGxBwI2D
X-Gm-Gg: AeBDievyqLTMb5Is87P7qDta9INJfH72s/aXGxOurXFZAAWnUYxTw0C7uoCOj72/WY7
	pGju9u0tJ8px8KvUjvzRKef/L/RTcWIb3RS8ZUYKL1G22X3/SzpXpD4QS2YG/6R91Jw2CpFZZf9
	BhE+r3NhnqJLlYR2zUvPK2sBv73Ar3R5PBYJs0/uzWh2JhZRV8Q14JblhreRCugeMgLZ/alw9a3
	/kSQjWINUGMA46H2d/zCDbj39czF3b6JVT+pm3enxswVOcKEhns8iev0pq3RyZWL9by94ZAdAnX
	A6YmC1+z87oqcP+D9sPMSTe0L+jw4T6yvNhWQ9UByrM5cAAPKqQ0PhRBb4rgaZXxLIFxX/6PkFX
	Ip+HXZqrdjMR3XlUVLpiHqanszaWImgZYP02pCbjN2kvDxNHAnAMDCNFPjFYybSs4UEpevmyjAL
	93rNc297q4Y+w7ltjn0KUUnLSCvG78E2IhGHLYwg==
X-Received: by 2002:a05:6a20:72a3:b0:39f:6343:c6e6 with SMTP id adf61e73a8af0-3a08d8fb92fmr16074773637.7.1776933663905;
        Thu, 23 Apr 2026 01:41:03 -0700 (PDT)
Received: from LAP-0337.. ([182.176.170.188])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c797701b1a3sm14714948a12.19.2026.04.23.01.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 01:41:03 -0700 (PDT)
From: Ali Raza <elirazamumtaz@gmail.com>
To: asml.silence@gmail.com
Cc: axboe@kernel.dk,
	bpf@vger.kernel.org,
	elirazamumtaz@gmail.com,
	io-uring@vger.kernel.org,
	krisman@suse.de,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring: fix missing submitter_task ownership check in bpf_io_reg()
Date: Thu, 23 Apr 2026 13:40:24 +0500
Message-ID: <20260423084024.31721-1-elirazamumtaz@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <e49d1391-b06f-4d60-98ff-0f034f2ed9e9@gmail.com>
References: <e49d1391-b06f-4d60-98ff-0f034f2ed9e9@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13131-lists,io-uring=lfdr.de];
	TO_DN_NONE(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com,suse.de];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[elirazamumtaz@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AF12244EA95
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/22/26 10:20 PM, Gabriel Krisman Bertazi wrote:
> How is this a protection?  I thought ctx->submitter_task is about
> IORING_SETUP_SINGLE_ISSUER. there is no permission or capability over
> it against other processes.

You are correct.  submitter_task is a SINGLE_ISSUER mechanism, not a
cross-process security boundary.  The "parallel path" framing in the
commit message was inaccurate.

The code confirms it - submitter_task is only assigned under
IORING_SETUP_SINGLE_ISSUER, either at ring creation [1]:

    if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
        && !(ctx->flags & IORING_SETUP_R_DISABLED))
        ctx->submitter_task = get_task_struct(current);

or deferred to IORING_REGISTER_ENABLE_RINGS [2]:

    if (ctx->flags & IORING_SETUP_SINGLE_ISSUER) {
        ctx->submitter_task = get_task_struct(current);

The check at [3] I cited returns -EEXIST to prevent a second process from
registering on a SINGLE_ISSUER ring - it has the effect of blocking
cross-process access but that is not its purpose.

The commit message's Requires: line was also incomplete:
IORING_SETUP_R_DISABLED is a prerequisite but was omitted.  Without
R_DISABLED, submitter_task is assigned to the ring creator immediately
at [1], so the attacker who creates the ring already satisfies
submitter_task == current - no timing window exists and the attack is
impossible regardless of whether the check is present.

> I'd argue this is a non-issue.  If you have CAP_PERFMON, you are able to
> mess with the process in many ways beyond this.  Otherwise, how a
> process would be able to get the fd in the first place?

On CAP_PERFMON I'd push back slightly: it is narrow (BPF program loading,
perf monitoring) and does not grant ptrace, arbitrary file write, or
process control.  The BPF struct_ops path is specifically what
CAP_PERFMON enables here, not a general process manipulation capability.

But the fd acquisition question is the real barrier, and on that point
you, Jens, and Pavel are all correct.  As Pavel noted, any application
that accepts a ring fd from an untrusted source and calls ENABLE_RINGS on
it is already catastrophically broken - the BPF vector is just one of
many things an attacker could do in that scenario.  There is no realistic
path to get a privileged process into that state without it already being
compromised by other means.

The fix itself closes a genuine asymmetry - bpf_io_reg() is the only
registration path without this guard. I can resubmit with an elaborated 
commit message, if Pavel thinks it's worth applying.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/io_uring/io_uring.c?id=bea8d77e45a8b77f2beca1affc9aa7ed28f39b17#n3053
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/io_uring/register.c?id=bea8d77e45a8b77f2beca1affc9aa7ed28f39b17#n282
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/io_uring/register.c?id=bea8d77e45a8b77f2beca1affc9aa7ed28f39b17#n733

Ali Raza

