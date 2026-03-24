Return-Path: <io-uring+bounces-12834-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0AVLOVHXwmllmgQAu9opvQ
	(envelope-from <io-uring+bounces-12834-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 19:26:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B95331AC9D
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 19:26:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8872430048FB
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 18:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D0D63B9;
	Tue, 24 Mar 2026 18:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DKOja9dq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3D838AC9F
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 18:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774376539; cv=none; b=swdTJoUXUrwX5xPbags3x/tuo5/cnEmFers/EdZ8HYx6+W2me+bUvDdMeQQMuZy6l8lt5lDJQxAYWhfsP9NEtngYuSpjvrCg85EHtlv3IU5ifzXMd4dsLY0Nq7vg1N/jEdi+l3B/mPlQYbTYgV1vT+b1JDHcl4A0ke9Hx9fuIvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774376539; c=relaxed/simple;
	bh=+maH8XCkt0Ttm9Z4O5uVQMaGLeGnHoH5nn5CbylYB0E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lBARNV6TmAmKunbKGSapbhJ/BBpRotBDSYzAjplsHdHH/x0ofyFZhlOKtkS9Y9DZZ4bFzLxkyQoUzR3MgBT97eQT7JQBrB5TuUYdqF/dJPxySNNM/MRGG1ujXJ3t6LNXVT1crnKcEEEAekwbWzLkG4htzCFPqAHhGcpjMLpNHRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DKOja9dq; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c70fb6aa323so626379a12.3
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 11:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774376537; x=1774981337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5LSozF1aIEcrX2r+eKALPj2G41igTmICnZB8Tfbrtwo=;
        b=DKOja9dqoz5zU+wwoyF07Z5EctLoYaYZiL7Kkl8NjMpZ5NA6770UYV2pwAejm2q12o
         4TaYc7qqlXQLGN6U8rvuhidpq4F7463UOOd0PaDzD0zL/FnMIFFK3k8K2NrPTPUJq4h7
         tJ2F0CR47dUwIBH3CSzUZcWXdDpJKEw545CVpTxv+5d92owDBZvzNMnhATiFl5kQ/VSI
         73Q9fSCrMunf9wwATtoHvbbdQNaiydKzH/juKhg6xsKOy4s4UCHvgIKyaeosg6w7FA7Z
         1RcmlSOGXLcRNmNPpLUo+xzkqseY6ZYgGkUzL96kGlMaWFW854BTwQLS2yx1eq5hzA7E
         aqbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774376537; x=1774981337;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LSozF1aIEcrX2r+eKALPj2G41igTmICnZB8Tfbrtwo=;
        b=ii8tzpFeUP+gS82GRGO2ijcR0WKUC5kuIOLdNsxJubth9I4VH/j1qG1xFV5eqyTcKd
         V5jgHbAEpZJMQbVtNIe9rM0bR0/aBoKC+bYB5RP4Xdv6JjSoWIJA8cTHALDsiklEZqtv
         i0zWvuHg7gnQNj4gf1gPIOPEYNEObZIBUf2a68GMLHKVOYhgugjea8GLktvUZz9HbiB0
         ldttR6qHE1/KOO4VQQ7BVM/GXxkJ85lj2D0Y2ixBAG90kX9XOxgCal95cUn4+JLs7qRb
         JWvM+pCG8lTpPSnxjfXGWpX/WhmEzj3tsS1OsMAhiBSkN8k9CU1zq6mZtoDppqI+NP0T
         umpQ==
X-Forwarded-Encrypted: i=1; AJvYcCU01m7hC78UzY0dX8TM5ehtF6h0YmI0RraGZhZWj2qv65UE6ZaH8jMWyxImDfg9rOkBHf9/+/mLug==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0rDW4/dPlLDCxTDZgg9YwKSxhFRwL2pCGIfioTgf6UBbeR77r
	yNFf3H+9ETzlQH62KnkTDzpor4WCks+F7xVaMDLDPHGUYJMK4d0rFmt2
X-Gm-Gg: ATEYQzxori2ZE4dH516RNkJf3iQTJWeI88nlq/4lHPEgEDdLw9Q+pnFAU+MevwcuK5v
	XIKXEjk1nMh6oS+UMCr6/sd4MryH1CGEriO36GXTpEKRqcsHeUWBlyLxohJMa56l1d+1VQ5DtjW
	AhlyhrxpnT//XTMM2u9PSRfL43tK7XXa6tLNw9fB0Iilbb1czqBUTL4lLq8YSMlZAgc8yNotfZU
	p1lX4cLiawBg4vIhReyh0EFmZicIUUGUb6CnW+Af9M7DoQ/K1FGcej5NIOTRIJcoaZ551fUpboo
	VS5dicPQ1LLJ9NxCqLuKIXBk+S75fOkIE7R+MOhnPdHbNp0MzHKuXDvUdGMFxXpZzzKjY2RxrbS
	yO2RPNmBlxa+6AiZp86rGaa0jNQ3YEKA5fIrziLs+MYGZGNMtN7euevyh6bmANYPLVAzgUtGs5d
	3Q8lZcWrx2Xb2hlSd3Og==
X-Received: by 2002:a17:902:c942:b0:2b0:66bc:22a3 with SMTP id d9443c01a7336-2b0b09a0998mr6684805ad.10.1774376536853;
        Tue, 24 Mar 2026 11:22:16 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:74::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836554acsm200321165ad.51.2026.03.24.11.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 11:22:16 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v2 0/5]  io_uring: extend bvec registration and add mem region lookup
Date: Tue, 24 Mar 2026 11:21:52 -0700
Message-ID: <20260324182157.990864-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12834-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6B95331AC9D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This series refactors and extends the io_uring registered buffers
infrastructure to allow external subsystems to register pre-existing bvec
arrays directly and obtain a pointer to the registered memory region.

The motivation for the patches in this series is to make fuse zero-copy
possible.

These patches are split out from a previous larger fuse-over-io_uring series
[1]. The remaining fuse patches will be submitted separately and linked to.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joannelkoong@gmail.com/

Changelog:
v1: https://lore.kernel.org/io-uring/20260324001007.1144471-1-joannelkoong@gmail.com/
v1 -> v2:
* update io_kernel_buffer_init() to take bitmasked dir directly so callers can
  set both dest and source

Joanne Koong (5):
  io_uring/rsrc: rename
    io_buffer_register_bvec()/io_buffer_unregister_bvec()
  io_uring/rsrc: split io_buffer_register_request() logic
  io_uring/rsrc: allow buffer release callback to be optional
  io_uring/rsrc: add io_buffer_register_bvec()
  io_uring/rsrc: add io_uring_registered_mem_region_get()

 Documentation/block/ublk.rst |  14 ++--
 drivers/block/ublk_drv.c     |  22 +++---
 include/linux/io_uring/cmd.h |  47 ++++++++++--
 io_uring/rsrc.c              | 143 ++++++++++++++++++++++++++---------
 4 files changed, 165 insertions(+), 61 deletions(-)

-- 
2.52.0


