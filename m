Return-Path: <io-uring+bounces-12784-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cG+zOh03wWl3RgQAu9opvQ
	(envelope-from <io-uring+bounces-12784-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:50:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 56D7E2F2383
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:50:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4D823045AB2
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 12:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4793E3A7F58;
	Mon, 23 Mar 2026 12:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jHWdFaLX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53C329A1
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 12:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269846; cv=none; b=Ga/uxeC/GklQC6kjvpi1FTTqDf0P/Vl4wFB9qz1MgpOejauvZbaUvyiKsdOjl8NFVcgp0hJ4uC00cB50Mh+POH6OmGOykrSaV3oAMkrND/qug6eiSQlyXlS6uZZmHhY8t4ILFiR5VgmT3mmRcbBvBiF98pKgIsqMc/YE563G8jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269846; c=relaxed/simple;
	bh=G6mXLFYcUH6oI5I1LJXYCNY/0zYyH/Ijjh3eAm1LxDY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OEEvzeBEb7AV2G2aiOrrlaXRNajrVPz25M7uRlgJcP4olUjkaWknu56VMOo3uCV5wkqMIrlU6zscCJ+TMYFGHxLcxInN0NGZY8cAt8G/pUsaWd9lMAAZZiPB6X7EY0IhpsMcoBaWTxc9fAOeml6i3XMM1xkySqeQ2NxuG+mV7lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jHWdFaLX; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439b7c2788dso1764098f8f.1
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 05:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774269842; x=1774874642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+Mbc9t8qQAUbV+W1yw7w/qNXR/GMAzA8hewMhzmWu3g=;
        b=jHWdFaLXw0mht5DgxwPR54tlxsFjoxuRREcEGdq8m3iKQZHQejsD19JqotqAW2N4pK
         MP9rILWDdJOWhZvGBj4yXIQQQk95VfxjZ76Skh/8ImjOvsLoD+b6TakkSAKhHZY4mUJX
         DtjPhLzNpxj3rV0Vc0oVE4G94WWgpnV2eFcyCjN6pyd4J2zcQJe+CnEPyZVAH2vzV6RQ
         UQCAToyZVF0OHCAEffP+B4R6G+OBw05dIOZCI5URUnCK17xYRrCnQqQamnfL9myF/p6u
         HL4YQvloceQwRm/7Kd13ijMjHD45ZnkUQRJeNQ8sCLzXiDIR8D4HIBiktqmmv1I0Rcyz
         q87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774269842; x=1774874642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Mbc9t8qQAUbV+W1yw7w/qNXR/GMAzA8hewMhzmWu3g=;
        b=a4VmZLhWB6J/N33prtenAD8Ze+GOaJ+U2Qn0JYb9/x5EgSfqcsuwYEQruHBgzcN4/O
         GyKKtL6kM0ycADabCVvCEfDGQSUoTXxLJUTKs3J1T227MfEgmW2P5P3eJLNBYKABVkyw
         4rtFO8d3n2DvsWmGAwTEfBq01widj/tgbgwIUXRlKjTYxs11IPhNIOpKFvjJsZV+ISZE
         ZMbKr1vZcGvlPt8AP+zRlXGxqrD1hOdPQ8Ef9xm5TC8LMwhk1kOXQvnHGFsxKT1K+FP3
         FOO1UkUq5BYVazhPe88SsMnHeX5prHwuyioL8D9IhXQdHwJ/dvKSv7ISewYCB5LkEBNB
         HeZg==
X-Gm-Message-State: AOJu0YzP2rYUer1EJXXahP474UjmdCVMpzNRGycVBPQ+QjshkBLufZ2F
	pwt1sq+169B2SfqCBPMAelwe6hn/spU6v+0/uYtobFjDF5+bTAA9wUlDISaNKQ==
X-Gm-Gg: ATEYQzyqxL16lRjF3P4gFWFtcGloS2rEd8tBuKKwXCjyhhg+P3MS1Lgq1oeLoylBSKU
	+K92CqqW7jjL+o/IM6Y9QTVekGR30Ytl1Q5wVch6eQjjC6rKDwY8lTCrNUlNjK2QbQE15h8CIzi
	OPzXI6505J4HsSXuten95TbImgptZq/sFE70DXlfLDZMXkYlYtydb0YkbdnINnvj4aFUdSxu8G1
	CGLuOEcdBRds0KwfPBq65IuOngUsyHBy+cLGpif79XMCs7P7TXv4/IBMTghQJXL3/JKRFyDh+hT
	E5OmqI2UwjXCH2VFz70Z5IMOiOBPhkWGGBx0ZujUy3r5YndgxKT41MUJETtz6GmPKXfUxy5gdOt
	B+sb8zrYVp0B34tfCt3tBPFyQfZ40WZ1wnqHABjwqQC/klKuLZcmoO21PqKxBr02KJTyd3wGXGY
	dw3sJ93yoefsWfF2+Lk0ZQcvsJXBVWJd0GP6B79stlcxvZIvVxS4VNAVGn1qQizpvWXZ24TDTGo
	dLN79SRStmaBLYKgB1N
X-Received: by 2002:a05:6000:2502:b0:43a:16aa:1448 with SMTP id ffacd0b85a97d-43b6424f499mr18115317f8f.22.1774269842300;
        Mon, 23 Mar 2026 05:44:02 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:6969])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm25520861f8f.0.2026.03.23.05.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:44:01 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 00/16] zcrx update for-7.1
Date: Mon, 23 Mar 2026 12:43:49 +0000
Message-ID: <cover.1774261953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12784-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 56D7E2F2383
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The series mostly consists of cleanups and preparation patches. Patch 1
tries to close the if queue earlier at the start of io_ring_exit_work()
as there are reports io_uring quisce taking too long leading to fails
on attempts to reuse a queue. Patch 5 introduces a device-less mode,
where there is only copy fallback and no dma/devices/page_pool/etc.
Patches 11-12 start moving the memory provider API in the direction
of passing netmem arrays instead of working with pp directly, which
was suggested before.

Pavel Begunkov (16):
  io_uring/zcrx: return back two step unregistration
  io_uring/zcrx: fully clean area on error in io_import_umem()
  io_uring/zcrx: always dma map in advance
  io_uring/zcrx: extract netdev+area init into a helper
  io_uring/zcrx: implement device-less mode for zcrx
  io_uring/zcrx: use better name for RQ region
  io_uring/zcrx: add a struct for refill queue
  io_uring/zcrx: use guards for locking
  io_uring/zcrx: move count check into zcrx_get_free_niov
  io_uring/zcrx: warn on alloc with non-empty pp cache
  io_uring/zcrx: netmem array as refiling format
  io_uring/zcrx: consolidate dma syncing
  io_uring/zcrx: warn on a repeated area append
  io_uring/zcrx: cache fallback availability in zcrx ctx
  io_uring/zcrx: check ctrl op payload struct sizes
  io_uring/zcrx: rename zcrx [un]register functions

 include/uapi/linux/io_uring/zcrx.h |   9 +-
 io_uring/io_uring.c                |   6 +-
 io_uring/register.c                |   2 +-
 io_uring/zcrx.c                    | 364 ++++++++++++++++++-----------
 io_uring/zcrx.h                    |  33 ++-
 5 files changed, 257 insertions(+), 157 deletions(-)

-- 
2.53.0


