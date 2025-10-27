Return-Path: <io-uring+bounces-10242-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E7006C11B30
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 23:30:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 993814E7516
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 22:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4CCE32861D;
	Mon, 27 Oct 2025 22:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="apXhFa4d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A9030C37C
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 22:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761604182; cv=none; b=n05epPPH6Lsf3eUbsWnb1WehbC5jvc/NAiOZ0JK6+fzJesOy8kaPvvJVpuiX+FM9sCgaAU2v5rYwWEAH3O9RLoZc6ac2AiOZ+kEFrKYcTUvBMJ1uNcNtbrJMJksDIRZpD5SxLQzAuPXXK5ylN4ge7bnibsKAelHGJjaeJDzA6OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761604182; c=relaxed/simple;
	bh=d8NMdMIAsKL9dT6NiZf9+euKVtilxlxSJ5AK9kuS4JM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lO6eBlpBNxJ3CjSr/FwpfsVzqvU0zu81U/e/TqXOTBCguh7gOjewLlpksNCg4U5WR2BBcbVazlSiBploVvz1znNmBzd00NLbnzLd0R3hOdORk1Drz8/L558NWO6QI+Tjxbe6OXTRxmxx5kZYANgjOolWnHyMWilQcCjSdY6Nn/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=apXhFa4d; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-339e71ccf48so6764424a91.3
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 15:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761604181; x=1762208981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8mhu62PqUUoiRlh9DDmVeEAVqYSH9RKV2q5DyJsz5J4=;
        b=apXhFa4d+yKE6olfb0DvBNUQe0hJorglbPH7h73euoN7G5sW+tO2jrrHQDpT3eEFuh
         F4uwit47RfxDgiWrQKTcNnJ1sGeTbtQtzJQ9f8WD80C1AJBeVhIFhYWxhY1GrDkezu3Q
         Vl2G7LJIbolFNKrNxaxa0JzWGTZJEQU1tXpeJOWOD3CLbyCALGeBAQ6n/ssC8+dqltsC
         Yjlw+u8txM54PowIVLO7WXcf9G44bewEWwq66yiPvig2Ig0RTYZC7Uz9lR7uWWxgH4fD
         8Y5JiU5uFraJM/jRCu/ovYLDU+5boboTjWhXFk9yv8XWlnmPud9pN7rP45hNFQFM1KjC
         4ksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761604181; x=1762208981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8mhu62PqUUoiRlh9DDmVeEAVqYSH9RKV2q5DyJsz5J4=;
        b=YEMDGnb4WNHFqwM/YdPZ8TtDtDAtXljuE0HqiHrgZYZTDxgO4imRNc47t2XP82Kjjt
         bjAVRWVJh8BcAbgn3nQLMg6BSVQ6IIoGFDhuLYYo/yWCBe/cpEhmRRnUAKD2sBEKrTr1
         zoL/xytpCidZ25glxREY8k2EpQ5K8leiTtlvkPe0wO1r0xD5soYoGCTs4vlWFxTbnhEH
         Zl9HcBWbcgb0hMg9l4Q00pANBZWjxem9Wa7Tz6gwk6i8SV+uHMm7CXMFInx7GXMRgi6M
         hvOs3rEdGZ6GsDM8Oh/5Tv6ZkLw4+EO6J6dl+XoaCEGQ66gWrbb3iEjhsNWCrcnZvXq5
         5c5w==
X-Forwarded-Encrypted: i=1; AJvYcCXgqAiKZXKIsK2EMw0TIuJJXcddmL+nuNMFthfpTb1bZ+vAk2/vEIPJu/BhMcg3qSDpTJ4st2StPA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9jgiYSYCDozS+ca4VNYGo+fZMctb3H3OonJLtcoQzYoC5S0LY
	QmINzvPODHdMQUbcYxOd4kObLXQ76sqvTP6f7VX4IuEGY8zLoeOlB8520HxsFg==
X-Gm-Gg: ASbGnctmPiK//wqkqngS5vBWrGqjH+L78c9oTvUhmV8I3JdwPDpFqecM40Zpku7S5oa
	PxjwT3Agbh/IPNJ4T94d7VF8viRC4OZS4UQJc2ME0/OROf08mIJ3PlCS6D1m+OIsxfXQf2Evr/V
	Bh80QsWaofaeS9ltRDfSfBEVfOK/mWOzAfRtl32E9ubSJkpmGgw7ViHUtnalCR842lMCerBzgaH
	9e77/AEjKMIhO/EAPDNjZjDjjOLbanFPIrM522c9JvH1yJBDY7D1CCSW9i5IfXWmWNIFBg1/p1M
	NWBCmxdV2eOa9RKLsIBJi+1tgrjR2oS9TVq7kIyxwdNgMtTCDxTDa/H3EMRbPXPGZhm42RCKv+G
	vEGj0sg0VTUgNtY1HSxq6OfWQ1XHzkq7Xa733jy1aPSyS/MFwrTg/It00MleX4p76TN4l6EcMnM
	aRa2UI9DwFPC3IToFNLK8aX3wa0o8=
X-Google-Smtp-Source: AGHT+IGPU1TePCGRCsZt+liUeRMz+ZQoyOc9MsK8xsHUDywlroEXsW+H9dLQ5M35xZaqbOPL+oauqQ==
X-Received: by 2002:a17:90b:5241:b0:32e:d649:f98c with SMTP id 98e67ed59e1d1-340279e4afemr1601136a91.1.1761604180545;
        Mon, 27 Oct 2025 15:29:40 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:43::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed73b5bbsm9752763a91.7.2025.10.27.15.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 15:29:40 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org,
	bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	xiaobing.li@samsung.com,
	csander@purestorage.com,
	kernel-team@meta.com
Subject: [PATCH v2 0/8] fuse: support io-uring registered buffers
Date: Mon, 27 Oct 2025 15:27:59 -0700
Message-ID: <20251027222808.2332692-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset adds fuse support for io-uring registered buffers.
Daemons may register buffers ahead of time, which will eliminate the overhead
of pinning/unpinning user pages and translating virtual addresses for every
server-kernel interaction.

The main logic for fuse registered buffers is in the last patch (patch 8/8).
Patch 1/8 adds an io_uring api for fetching the registered buffer and patches
(2-7)/8 refactors the fuse io_uring code, which additionally will make adding
in the logic for registered buffers neater.

The libfuse changes can be found in this branch:
https://github.com/joannekoong/libfuse/tree/registered_buffers. The libfuse
implementation first tries registered buffers during registration and if this
fails, will retry with non-registered buffers. This prevents having to add a
new init flag (but does have the downside of printing dmesg errors for the
failed registrations when trying the registered buffers). If using registered
buffers and the daemon for whatever reason unregisters the buffers midway
through, then this will sever server-kernel communication. Libfuse will never
do this. Libfuse will only unregister the buffers when the entire session is
being destroyed.

Benchmarks will be run and posted.

Thanks,
Joanne

v1: https://lore.kernel.org/linux-fsdevel/20251022202021.3649586-1-joannelkoong@gmail.com/
v1 -> v2:
* Add io_uring_cmd_import_fixed_full() patch
* Construct iter using io_uring_cmd_import_fixed_full() per cmd instead of recyling
  iters.
* Kmap the header instead of using bvec iter for iterating/copying. This makes
  the code easier to read.

Joanne Koong (8):
  io_uring/uring_cmd: add io_uring_cmd_import_fixed_full()
  fuse: refactor io-uring logic for getting next fuse request
  fuse: refactor io-uring header copying to ring
  fuse: refactor io-uring header copying from ring
  fuse: use enum types for header copying
  fuse: add user_ prefix to userspace headers and payload fields
  fuse: refactor setting up copy state for payload copying
  fuse: support io-uring registered buffers

 fs/fuse/dev_uring.c          | 366 +++++++++++++++++++++++++----------
 fs/fuse/dev_uring_i.h        |  27 ++-
 include/linux/io_uring/cmd.h |   3 +
 io_uring/rsrc.c              |  14 ++
 io_uring/rsrc.h              |   2 +
 io_uring/uring_cmd.c         |  13 ++
 6 files changed, 316 insertions(+), 109 deletions(-)

-- 
2.47.3


