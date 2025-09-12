Return-Path: <io-uring+bounces-9768-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93CBCB5535E
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 17:27:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFA203B6E4B
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 15:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D2781ACA;
	Fri, 12 Sep 2025 15:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7L+iUge"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEB8221DB0
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757690824; cv=none; b=iSUB8b2Fwn0YUP2v5AUuqIAmzu0ChdSZsH3bOR47X/Ltze8vslsqNmTfbIpyBTn3GFBhRgmHg9Psd17mlc8ETqFUAzVa3kQIA49hCZ6GZdbx19npU7BoBXBXUGWqYP3fxq5Toxk2t+TndNv6TviO+3WNqqU3pGhDNzRtyct4oXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757690824; c=relaxed/simple;
	bh=UXb6oiZ1a08xukqMWGzQmWMh6jz5S2O37oTIMSab7EM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XGrqswUD4VWO5YBKBlJKUwitY5mwwUxNlX36lArNi0YwwqJPO4u5ftL1Pw1INKMV2L8ChpWvUnUxeTsi5q/pTtei8KBVo6n7I93BwUcEif0CBfY+8xFzehqwNqxZ/dcnhB5kE84p9wTpsMAFXPB2TBdZRtrXQfznARc9dBVF158=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b7L+iUge; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-77264a94031so1617484b3a.2
        for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 08:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757690820; x=1758295620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xrD09NwNNaCCc36kTZDK/vKByj38vuDQyaEDdfXfDJU=;
        b=b7L+iUge4aytQjBq4HgJkLPgCqGydals+8HXZasSFisCsDY3Co81nrXf1I5AA7Pn5q
         6Syc1etDQw+j5O7mAwTR/T+zjpgnRou+nizOfm/u4q0m8Rfgkpcl30eQXnaWO+EXUECZ
         qOuUsJT6Z66MXugQn139UwNPYmBDn0KhCVVXJufy15aSG++QAiUhovWJB3y6gY7lveoC
         1X+JNRVI2KakKoHMevrdZcF/T57+QCk39CS1atfzy3tWJAQrAcFXyEbUGPf9l1qjVlGe
         zRAr0/kUBN/tT/R9lXzJSWq90HzW9drgKZuAlQTEP46T+FZVzOzecbYseyD3QnBRcMEE
         BYxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757690820; x=1758295620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xrD09NwNNaCCc36kTZDK/vKByj38vuDQyaEDdfXfDJU=;
        b=tyeshOIY3iqi4nNz37m2GXqOBjq3b63osFkIqSkDMhirRhIdDNHVpohf/xU+52bRMF
         y6xlVOVHVxqJF59AWpUHIV3XxfL7a0pBu9VN79cFTDIWbuJ2utFsPFjw3VlKYs3o+fi1
         U/pCTDK7hXPCci0WJV92gXzkuYktEbv5CMGRvdvmsDRH6QP8Yvs3PFGPSJgiIZ2yhqbe
         P644KTWEdjafVyNxlCjVJOZoZQ2oqkn1loR7S1hBtxHWcxd2OoRWbbX7CkT3iZOM8G5Z
         xHDfBFD5y63QM2ULAh8JLmCEJt5rceg5ML40dGbeTjGTm0g5/QaqQr+hXb54emc4fbgG
         hOoQ==
X-Gm-Message-State: AOJu0YwyOibEvwtxwCaZyvnKeMCSo93fWH13tviTWG9sNGNC08KpM8lw
	D9Oht9YEB+DKbmd0DLt5/WG/NIleAk3wfGHWcTYbGZocPbFEWD50p7aB6k08bMOZ
X-Gm-Gg: ASbGncsveMY7YsWXJZvwUJ8mcJCeSGOPuvMmWJVF1TAJP3BQLVB52Tp68slsqECkmkf
	1Jrvz9LK9pG4krJkiTKnCQCSlldk093FJM+mogEXIzveSJN/x4gVvdyjBI2e5G091nD6bxLF9QC
	D4oE56EyNzu9s7Tupbu1Lt934QZ8ehzTYt5bE/aZd5TZM+ZvjoG9QNriMq03HKifonAEXEvpXPk
	sE1NCJwWHp/+ud+W7CvX8xNWPjlv2kCqXOpN7tHlGY1QpUdLDREA6a296OBSU9n0IBGjsiHTODQ
	FwpKAZAEySrSbd2X/xsj8ugEy7KXD0FhVa0+Xx6Z+aTPPtba7/vvHr/o4W3kFbJUMvPwxUjJ50v
	EwdS32Ks4Tvz3G+ekbwxZWyHD/jAwY2cZgZtI
X-Google-Smtp-Source: AGHT+IGUo0K4zIFMUfzF4WpP86EMKMNSUkcTVtq3VjmtoSg0kTDxGd/EyfD7RbMVVOytbEOUNyiPxQ==
X-Received: by 2002:a05:6a20:2583:b0:24d:56d5:369e with SMTP id adf61e73a8af0-2602a593376mr4421336637.3.1757690820222;
        Fri, 12 Sep 2025 08:27:00 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7760944a9a9sm5436846b3a.78.2025.09.12.08.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:26:59 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	jlayton@kernel.org,
	amir73il@gmail.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH v3 00/10] add support for name_to, open_by_handle_at() to io_uring
Date: Fri, 12 Sep 2025 09:28:45 -0600
Message-ID: <20250912152855.689917-1-tahbertschinger@gmail.com>
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

For both syscalls, io_uring will initially attempt to complete the
operation only using cached data, and will fall back to running in async
context when that is not possible.

Supporting this for open_by_handle_at() requires a way to communicate to
the filesystem that it should not block in its fh_to_dentry()
implementation. This is done with a new flag FILEID_CACHED which is set
in the file handle by the VFS. If a filesystem supports this new flag,
it will indicate that with a new flag EXPORT_OP_NONBLOCK so that the VFS
knows not to call into a filesystem with the FILEID_CACHED flag, when
the FS does not know about that flag.

Support for the new FILEID_CACHED flag is added for xfs.

v3 is mostly the same as [v2], with minor changes.

v2 -> v3:
- rename do_filp_path_open -> do_file_handle_open()
- rename the parameter fileid_type in xfs_fs_fh_to_{dentry,parent}() to
  fileid_type_flags
- a few minor style fixups reported by checkpatch.pl
- fix incorrect use of '&' instead of '&&' in exportfs_decode_fh_raw()
- add docs for EXPORT_OP_NONBLOCK in Documentation/filesystems/nfs/exporting.rst

[v2] https://lore.kernel.org/linux-fsdevel/20250910214927.480316-1-tahbertschinger@gmail.com/
[v1] https://lore.kernel.org/linux-fsdevel/20250814235431.995876-1-tahbertschinger@gmail.com/


Thomas Bertschinger (10):
  fhandle: create helper for name_to_handle_at(2)
  io_uring: add support for IORING_OP_NAME_TO_HANDLE_AT
  fhandle: helper for allocating, reading struct file_handle
  fhandle: create do_file_handle_open() helper
  fhandle: make do_file_handle_open() take struct open_flags
  exportfs: allow VFS flags in struct file_handle
  exportfs: new FILEID_CACHED flag for non-blocking fh lookup
  io_uring: add __io_open_prep() helper
  io_uring: add support for IORING_OP_OPEN_BY_HANDLE_AT
  xfs: add support for non-blocking fh_to_dentry()

 Documentation/filesystems/nfs/exporting.rst |   6 +
 fs/exportfs/expfs.c                         |  14 +-
 fs/fhandle.c                                | 155 +++++++++-------
 fs/internal.h                               |  13 ++
 fs/xfs/xfs_export.c                         |  34 +++-
 fs/xfs/xfs_export.h                         |   3 +-
 fs/xfs/xfs_handle.c                         |   2 +-
 include/linux/exportfs.h                    |  34 +++-
 include/uapi/linux/io_uring.h               |   3 +
 io_uring/opdef.c                            |  26 +++
 io_uring/openclose.c                        | 191 +++++++++++++++++++-
 io_uring/openclose.h                        |  13 ++
 12 files changed, 409 insertions(+), 85 deletions(-)


base-commit: 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c
-- 
2.51.0


