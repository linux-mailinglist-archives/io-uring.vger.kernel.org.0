Return-Path: <io-uring+bounces-9711-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6378B523AD
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 23:46:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 803FF3B3DE5
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 21:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B72285050;
	Wed, 10 Sep 2025 21:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bxVRNbUj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E438425A350;
	Wed, 10 Sep 2025 21:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540781; cv=none; b=AzEcQD0oqceMvxdyZsWH6j4d6uKAabVjLRb2otgdjgV7ThP3vJD8liyjtwc3YxKAXtc1cmCgRUWFMNMVJXBDjw7QPU+Anc7UR5RKxWELOBUsUFp7fnTUR67cRutZqAxiXiDfqo+5KDLbIgXqO8MdZPdDUGE6fMKn4UTAxIY+9MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540781; c=relaxed/simple;
	bh=qEPx7HAoIVqxUArLb7byNF6xzaLgP3XmTw+GmgWpgac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sUfOE/ggOFM/u2zlM0DpUD2xxqlmdI4q6hHwtRvE59MFBdUmDeUB3E/rQM2oQQ0vGMmO03G5wwO7BrForP22ltpW44k0AP03BCXoBXFPmOrvKsJPACu4uxavODEadnHW/evSvjUZ7zzhBCiScVkag0kqd6lC6ypv4GXGfteM27k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bxVRNbUj; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so74526b3a.0;
        Wed, 10 Sep 2025 14:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757540778; x=1758145578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DEg1ki19kRldKZrSMUtRB9eXrCIGMi4KX9/Z6BU973Q=;
        b=bxVRNbUj8u3rALQa1hFLsqkduNA1yWWChQBcNlzga08HR1PcHpHvxg9N7Yng26rd+K
         q8os+rL+FRs8WarGsPYg2lwSq3PWN1jqm/2efFkoZGjzvsR5JdEqwybl/A6xKWVdXtFs
         yLkzhR3U2BZC/3L4CEJ2C3bq7bHzm5/2rLilb3dtIhNN5efAkW0CMnzSfJ+xYjLy+TH5
         VGXPmUehoCPrzXu05nWRx/GKA9XNjThFKJD/zwGZlgjQKoQw5zdSyvipnT88NtUJ3rbl
         FJW1leOg5xV75YupzQAeyaBeSXgeuWpaneh5ndi3po/TXr9nVXXHWr20cVniTv1iHQ8Q
         Ka/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757540778; x=1758145578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DEg1ki19kRldKZrSMUtRB9eXrCIGMi4KX9/Z6BU973Q=;
        b=f0M+U+0YKjWgfQRvMzjKoUWIbjAL3+ByjgG9EwMz1M9GcwWlXSxTzlyNoQu+joAGDe
         akZ+ZCN7QF7R7dxxqatIDIY/pWANvwhZskbyFsjGL9BNS8t9ASgoyvbcgBAI+6MtegvA
         E6kFvwJ3HROQu9Jt5ryfZDGcBaYdqzRnKY5TwJEIofpvHvlnwKEbQI4m1oiPqAQjELFl
         0XuAl/ipVTR8MINFa4BFi7S+Z87c+iDn2qlNTbdordfyHzZrEXUe375qhOVtSeb/KI4/
         zuYOGeyq600EcvEh/HC+UnxfR2B4utknuqW3Iw67ugeW1m1ZnFj1bAFR37Mc8XhcZnIc
         3YIw==
X-Forwarded-Encrypted: i=1; AJvYcCUd+q6g2pe1/N8L0CzK7meyq6PusZy7vD7Ug8ZhNHTBXEO68c0nELWA8MjXTA3J9pdL7GpOpsNVpYWU@vger.kernel.org, AJvYcCVbzMVBhxhZu2fAPPxQe48sC3mTU3fzGfAtvUVNoL61GJ98tGLisPht+Z8voYYwjxZFwMwZsKQ2hAfr@vger.kernel.org, AJvYcCWc+iMd/ZqBA8ZXewaIGQqrSyAydAAtx7heqATLSF8kwrLQS2sdlFdcCGG5kht66jjSybyp0tPmdnIvXv84@vger.kernel.org
X-Gm-Message-State: AOJu0YxYj7vRrSKUGwAf2DVSLoVTx2a+mjj7uUyCt6o9w59AeefrIKr5
	ZfsCE7ZN8IJWCJa2U6mLsnd6gK81c/AVipz5kEv7cSvjRmhjQF1TVQE6pXoqtkfH
X-Gm-Gg: ASbGncsyyDsW53ZCsZKrStTTc2jRfTLxQJrPStXCqtdCLhfQ8Qmcw5UMtVJUaVIa+A7
	2e8OqiawmOb9ze1QoaeNv1kr3UETaupGIzkSV0cm92UPvC6LaHJvjzM3WF8awZlHMSM60ThdDp7
	I4HPYLFQwDtuCmD30vEtM+KYwziNXm3oGEDgqSpl/PZZZDdZGStQeP24UAcHJrjzpTnmF2X7bnm
	ew6uLpOJrOcXNrv1xpb1I/wWwQ/eCr6iwJpp0MjJhzJEGrTF4QLBRqmOytZqaxMMhI03loKttZ1
	+DgGt/zpz80FKBdy9cFm1ykXhWbZW+5wKFs1z1DT1QYe44FzUSDjIZlC1fcsql582X45QLGvVal
	iwp4M8DWHD8VzjuCPuURw1Hi77UQKBgGVXChy
X-Google-Smtp-Source: AGHT+IEWMAt2EvrHuYaNHgZ9JLPgQrDkZIZNfmGfyJ8/NwZtAmfWU7QJSWyZrMZs6yzxQ7mh3Pmsgg==
X-Received: by 2002:a05:6a20:12c7:b0:251:9f29:4556 with SMTP id adf61e73a8af0-2533e950082mr25079587637.4.1757540778287;
        Wed, 10 Sep 2025 14:46:18 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-775fbbc3251sm2422516b3a.103.2025.09.10.14.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 14:46:17 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>,
	linux-xfs@vger.kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	jlayton@kernel.org
Subject: [PATCHSET RFC v2 00/10] add support for name_to, open_by_handle_at() to io_uring
Date: Wed, 10 Sep 2025 15:49:17 -0600
Message-ID: <20250910214927.480316-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for name_to_handle_at() and open_by_handle_at()
to io_uring. The idea is for these opcodes to be useful for userspace
NFS servers that want to use io_uring.

The biggest change since [v1] is that this adds support for attempting
non-blocking open_by_handle_at(). When io_uring calls handle_to_path(),
it will set a flag to request that the call return -EAGAIN if it cannot
complete using cached data.

The same holds for the call to do_filp_path_open().

Supporting this for handle_to_path() requires a way to communicate to
the filesystem that it should not block in its fh_to_dentry()
implementation. This is done with a new flag FILEID_CACHED which is set
in the file handle by the VFS. If a filesystem supports this new flag,
it will indicate that with a new flag EXPORT_OP_NONBLOCK so that the VFS
knows not to call into a filesystem with the FILEID_CACHED flag, when
the FS does not know about that flag.

Support for the new FILEID_CACHED flag is added for xfs.

Thanks to Amir Goldstein for the review comments and suggesting this
approach on v1.

Testing
=======

As in v1, a liburing branch with a test is available at
https://github.com/bertschingert/liburing/tree/open_by_handle_at

and is run with

$ ./test/open_by_handle_at.t

v1 -> v2:
- rename some new helper functions:
	- do_name_to_handle_at() -> do_sys_name_to_handle_at()
	- __do_handle_open() -> do_filp_path_open()
- create a union member name_to_handle_flags in struct io_uring_sqe
- add new FILEID_CACHED and EXPORT_OP_NONBLOCK flags
- attempt non-blocking open_by_handle_at() in io_uring first, rather
  than always giving up and running in async context
- add support for FILEID_CACHED in xfs

[v1] https://lore.kernel.org/linux-fsdevel/20250814235431.995876-1-tahbertschinger@gmail.com/

Thomas Bertschinger (10):
  fhandle: create helper for name_to_handle_at(2)
  io_uring: add support for IORING_OP_NAME_TO_HANDLE_AT
  fhandle: helper for allocating, reading struct file_handle
  fhandle: create do_filp_path_open() helper
  fhandle: make do_filp_path_open() take struct open_flags
  exportfs: allow VFS flags in struct file_handle
  exportfs: new FILEID_CACHED flag for non-blocking fh lookup
  io_uring: add __io_open_prep() helper
  io_uring: add support for IORING_OP_OPEN_BY_HANDLE_AT
  xfs: add support for non-blocking fh_to_dentry()

 fs/exportfs/expfs.c           |  15 ++-
 fs/fhandle.c                  | 156 ++++++++++++++++-----------
 fs/internal.h                 |  13 +++
 fs/xfs/xfs_export.c           |  32 ++++--
 fs/xfs/xfs_export.h           |   3 +-
 fs/xfs/xfs_handle.c           |   2 +-
 include/linux/exportfs.h      |  34 +++++-
 include/uapi/linux/io_uring.h |   3 +
 io_uring/opdef.c              |  26 +++++
 io_uring/openclose.c          | 191 ++++++++++++++++++++++++++++++++--
 io_uring/openclose.h          |  13 +++
 11 files changed, 405 insertions(+), 83 deletions(-)


base-commit: 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c
-- 
2.51.0


