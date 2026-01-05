Return-Path: <io-uring+bounces-11374-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 84BC8CF59A7
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 22:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ECE2D300C357
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 21:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 192372DC334;
	Mon,  5 Jan 2026 21:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="buBzbC6o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f98.google.com (mail-ej1-f98.google.com [209.85.218.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D18280A52
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 21:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647153; cv=none; b=sWjBHMYaW03DdGsnSl5k5TdnRoeQeY6UfxDKiu9iWUXMgOj352ceVNJmrF8XRPb3xvFRUUhPBGJ+XUFFatGdDvR1bbKotbfpV6al4xgMqH7upTssU4XFpPvWOFHWDqo6Act3ZAzrOnz9amxGahnI6UI2uARov8+xUvjmKgNzHeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647153; c=relaxed/simple;
	bh=PKe3zut0rc2C2whJ8cqtZoWJ6n2ersPUtJEMB8597Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TkzMl0HxRSw2ENhcShbVcNshnAHLliqAP8iOIIx4KPq80WswnzUfeaRng8Yih1X+AyOhrchoWrlDshTssDt4TLBL20Eo05mQXDDfK7FPfg6L45TFeB/A4DDDXgdwRNw3CyCLPHDX2hfbTIuIpuogqBnpUo+69kc78N6Q3xb1oXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=buBzbC6o; arc=none smtp.client-ip=209.85.218.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ej1-f98.google.com with SMTP id a640c23a62f3a-b7639da2362so6897066b.1
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 13:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767647149; x=1768251949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ThFq9ylN2vLuaOoZ/EmEU7GtHAyA7EZX6diS045hnHc=;
        b=buBzbC6oMPAIS4xMy0m92wzj/rH/OUTuBTef6Jc57lX+Aeqn2WkFXz3bVDA4JftE9e
         V4Jh+keQjk6QvRQRQwSXpVd1c8QmK99A9fZfzBT/xHL9ZjcpC/HBHhiPcMJyzGK3fZBV
         VxeYvOYcrexkZnguCGWyYpoPs0C8PD/By40xB+TpS/JOijGrwrYfKVSHIN0IASkGoon8
         pViBmbBELKcs3UKPDAnp+SHUvi7yQaO2YDm19RzgChjK/9dplkWD61IDft9zI7Qx0zqq
         B6fFyqW/WMXeIXHdUJbnoo/TimFZvh/61EJBjQU03VUED623JtXfQgWmo6qTI7Yso/nA
         TXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767647149; x=1768251949;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ThFq9ylN2vLuaOoZ/EmEU7GtHAyA7EZX6diS045hnHc=;
        b=uY85g36F8JZaiHA3fb5X6y05zo53QO9ryyg6VdnlBOMY779SsBoJqqXEEl9tRwTi9I
         aoi/HWuxnnA2fFaznlz360yCsFWcThf6Q7ltcInibgzstxEOhfAOL7FDvvdMJcm6umdm
         yJqfjICC8qJZNiWORcYz4Dv3RMiBhlG2nw1n9QymgGZC2Jeb7OtDlDN4vAEAOo1xibDI
         gzm8kmbZm20Dexf9UaFKwOpLbR3seg8ztxHmCibHjGZ0Ydi26PKetJNujHa9Ew7+NXGy
         wDRrbFErNAMkms/DCrbVAtJNnxZc7RpwcZQ6yCxP9XFeiAfztMYLHExkm67IjQSgSGwy
         cWSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRpQL2XiCwmeT/5yUxBt4AIEoby9ekueFr7GH1bQq6y3wlcw/6yRLWbycWp/AZr4df9N5bEYo04Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwT9/uv5OwsIITW5329wwKnYRO7/iLX5LUlZ7MjqAIHq0Xm0H/W
	xTTnwmFqtXkNZIk21RQDWWiYrtYCDh8KumNciBiUMjgChxGtdr1alUaaqEdYhlrBdKUI3jN1a0u
	wBv3+n9rfo3KhWF0pifxkIDdnqqB5zNKqvfB4PoxeDu0fZisYsuzk
X-Gm-Gg: AY/fxX72vd8NpLW+G5/JhjyMDuZ/H6IvZRme81jQKuEKpT5TYyjez+ozwspTTnLHaMG
	viMO0Njp2BGV7F22LztMs0oQlzph9x1RMLZyQcXoCC1SeGGmvAgBhCo5yrehCZHR9m3cdH9L/pA
	7wj65G7VDTiRh/D1Tc8sfU7uk65gcBEm93tQfDB4TCaUa6i9bYQGfc601uT5JIvYHhI2PFMnQqI
	t7AVsEYAJLVyH5kKeo9Et/OwsV1A64HJiXTuznPoXCm4Y4MdvReQ8A6ruP36apzFSWJ3P2W5HnE
	RCgsB8kXJwOWZIrjen5OmoZL/p0UfR9d/2r45OP/xp16oq5PGC48X/jt8FLUURbLR6JEda6l71m
	RenLyVn3tb8m1j6Z5GevFVitNkIo=
X-Google-Smtp-Source: AGHT+IFfGhpbIFSepFLprA1aLr+eH5GA8QJxe4JwPbqRXkHq2J0qeTXAvG+MDsJ5Im3r4i8AbtZPkZzYkOck
X-Received: by 2002:a17:907:3e0f:b0:b80:b7f:aa1a with SMTP id a640c23a62f3a-b8427099dc2mr53580666b.8.1767647149351;
        Mon, 05 Jan 2026 13:05:49 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id a640c23a62f3a-b842a275ff2sm1257266b.22.2026.01.05.13.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 13:05:49 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.49.34.222])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 089B534059A;
	Mon,  5 Jan 2026 14:05:48 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E97F1E41BCB; Mon,  5 Jan 2026 14:05:47 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Joanne Koong <joannelkoong@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v7 0/3] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
Date: Mon,  5 Jan 2026 14:05:39 -0700
Message-ID: <20260105210543.3471082-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_enter(), __io_msg_ring_data(), and io_msg_send_fd() read
ctx->flags and ctx->submitter_task without holding the ctx's uring_lock.
This means they may race with the assignment to ctx->submitter_task and
the clearing of IORING_SETUP_R_DISABLED from ctx->flags in
io_register_enable_rings(). Ensure the correct ordering of the
ctx->flags and ctx->submitter_task memory accesses by storing to
ctx->flags using release ordering and loading it using acquire ordering.

Using release-acquire ordering for IORING_SETUP_R_DISABLED ensures the
assignment to ctx->submitter_task in io_register_enable_rings() can't
race with msg_ring's accesses, so drop the unneeded {READ,WRITE}_ONCE()
and the NULL checks.

v7:
- Split from IORING_SETUP_SINGLE_ISSUER optimization series
- Drop unnecessary submitter_task {READ,WRITE}_ONCE() and NULL checks
- Drop redundant submitter_task check in io_register_enable_rings()
- Add comments explaining need for release-acquire ordering

Caleb Sander Mateos (3):
  io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
  io_uring/msg_ring: drop unnecessary submitter_task checks
  io_uring/register: drop io_register_enable_rings() submitter_task
    check

 io_uring/io_uring.c | 13 ++++++-------
 io_uring/msg_ring.c | 28 ++++++++++++++--------------
 io_uring/register.c |  7 ++++---
 3 files changed, 24 insertions(+), 24 deletions(-)

-- 
2.45.2


