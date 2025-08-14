Return-Path: <io-uring+bounces-8960-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2DB3B27323
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 01:50:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED9C75C8073
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 23:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCFAE23BCEE;
	Thu, 14 Aug 2025 23:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mIMEFLRP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3153F1F582E;
	Thu, 14 Aug 2025 23:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755215454; cv=none; b=np/bQcUyZT1xm/JCnDIG1/E+lO9STEUP6D5/ptM7LFbYIUu75C6jhEb3izB42mZiLpzUJwwwLZSGxsTyD9uIUmojo8MKuuUBleBwpRBfZavSE6wURO2xFUbBVuTd8nmafnyH7NPcgL1lG97J4BSyQ5GhTHjaZJBWqlQGaiQ3lwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755215454; c=relaxed/simple;
	bh=YYANnOZCEYINVi4HHVKDm5jRQWOEvglhqYxWI/MdArQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KccgsTrmTE0iZzrV24IZ4HZE+WiMBJbWGFW9nr2yjMojAQVIOb00+1C13z56NPLOmgg0UAYZF1HeGLHOXv52VKQ6d7hZxjyaOFVTg9r0H7h9pOEg8j3p7b9PpL6Ra4xC7U0ofAm+d08jeJQQBlPS9+LL3PasL5mL5aT4PbRWKVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mIMEFLRP; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-323266b6ff5so1005202a91.0;
        Thu, 14 Aug 2025 16:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755215452; x=1755820252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T/ZG0aIyynfo0Si3XkaCdVTUBMQGqSNBn03vuGRaVM4=;
        b=mIMEFLRPMGYCS42HdeH0FkEA24TtkbOn7bOOs1WEENI8zKuNfRdsRhnJUwRRgdQiNq
         jb50OXCZ2o3nzbmwsaEUFVUZipOpiTh2ukQnt0yHy++u++G+rijQGC6Rgic39Gy5jQcH
         WR19owjL2h16mo2W5fpnqT/+F8oynw3kvYKhF6F7o6G7yfvuMh49O9XMSGbur8XrAMUW
         1F8UeTrTdeXMxEzhmHQjIBeYJ0MCKgTbSDkHmc+ZicdYTOJPJNg6ZATHV6BmANBCgx9U
         ATbbDqmj8d4Ua02ePdyYcbchf6HoZkuCZm2U0SC/BxfAGBT0k7+KGZkMfekx6T6K/aql
         /65g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755215452; x=1755820252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T/ZG0aIyynfo0Si3XkaCdVTUBMQGqSNBn03vuGRaVM4=;
        b=bmYRtLRUMf8CRPXuHQimXS1lejUrSuHL0j0tqSCD478TVzxjqSJL3D/d6NEdmgMYh0
         9y4SVdkpM+6HqYtkfzXhVpgQAC3dM+sZi6npag/F61BzGOSFJz8xRjJO94/AG+31pMEa
         pGExqAKtV3PxhHVsOOXS0O4lwauFgQzyWWfTBnvH5pO0Rw1P8Tw78WzLfj3u3hBgGs5a
         s5EzXxtZP/1G00j6FCfFToBTkjsMDc4vUimnaSAa2/w19S1M2pVinXUOBzCi3ANoQn4L
         eX0cY7YntL7vhhmlszeDuG9njz4s7ZgpP1gV1/JbgTX70TB8FOdAgjiqD884wLnXseBe
         xSWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVF9gdtp2B9lwMxSoxH8KX8MOtlJPDKvrzi/RgJulJOl/MYMFC1df2R8KpEzV4PUBP3KWW8dEwwqdGAnBna@vger.kernel.org, AJvYcCW64O4n1ttLBoZJCzZJV/EUy08LSr6hJMVgA4XCn7Vtz1Rdir8HuCyBJYJWRgt1FzKXain3/ua06HBl@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu+FSyHOAgri8owZw618puSV7IMUmT6kWfI3DCydVm4TQot3aE
	LgcG4UBICd0+98IAt6CDL4MjZKYqofbE7Npue9G7APj03SLBxgg9jeXixGW0rn+dSEY=
X-Gm-Gg: ASbGncv4s5nFjqxdPLfJcJJZfNPEZMsujJ+h5RRJTQKV03tKefW50tnbwcRi0pyPd8H
	K2GwE346nuISB7zEwZBkt+J2EoQ910StZrdmr1u/1iqiu/aconG05jVdWHQIX92W840+DRO7dcB
	vUY8ieeVMasnkcmuamRK9EvHuYMDpzle3u+YOlnZjULuS8++TOVjMrZF/F8SF185USDtlU2KOEM
	BvSnJ2UUgooOWaVzSIGwDLAF0tqd61ebCGIsJ3HwWKGky2OfUsMPb+UeNpm4faD7KMlo/NgxJxf
	rS42fbL/Ix4U0dGo7ClgGmMZy4iRPq4/OG4gllqlIY418IdFsoUyqR9wMxEvy92yJnuabjyGixT
	GUxwGpYdUGbOvBGuf5u3rQ8Ya
X-Google-Smtp-Source: AGHT+IEFemqmqMOAamTJP1Q5qkjksg9nJXiZU9YcGVui668eQSegvj5roEo0tRHpv8eEOQ9QLWQ+Dw==
X-Received: by 2002:a17:90b:4b92:b0:321:c8b1:5bb4 with SMTP id 98e67ed59e1d1-323297ac215mr6553115a91.15.1755215451995;
        Thu, 14 Aug 2025 16:50:51 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3233100c1d0sm2974721a91.17.2025.08.14.16.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 16:50:51 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCHSET RFC 0/6] add support for name_to, open_by_handle_at(2) to io_uring
Date: Thu, 14 Aug 2025 17:54:25 -0600
Message-ID: <20250814235431.995876-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.50.1
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

name_to_handle_at()
===================

Support for name_to_handle_at() is added in patches 1 and 2.

In order to do a non-blocking name_to_handle_at(), a new helper
do_name_to_handle_at() is created that takes a lookup_flags argument.

This is to support non-blocking lookup when called with
IO_URING_F_NONBLOCK--user_path_at() will be called with LOOKUP_CACHED
in that case.

Aside from the lookup, I don't think there is anything else that
do_name_to_handle_at() does that would be a problem in the non-blocking
case. There is a GFP_KERNEL allocation:

do_name_to_handle_at()
  -> do_path_to_handle()
    -> kzalloc(..., GFP_KERNEL)

But I think that's OK? Let me know if there's anything else I'm
missing...

open_by_handle_at()
===================

Patch 3 is a fixup to fhandle.c:do_handle_open() that (I believe) fixes
a bug and can exist independently of this series, but it fits in with
these changes so I'm including it here.

Support for open_by_handle_at() is added in patches 4 - 6.

A helper __do_handle_open() is created that does the file open without
installing a file descriptor for it. This is needed because io_uring
needs to decide between using a file descriptor or a fixed file.

No attempt is made to support a non-blocking open_by_handle_at()--the
attempt is always immediately returned with -EAGAIN if
IO_URING_F_NONBLOCK is set.

This isn't ideal and it would be nice to add support for non-blocking
open by handle in the future. This would presumably require updates to
the ->encode_fh() implementation for filesystems that want to
support this.

I see that lack of support for non-blocking operation was a dealbreaker
for adding getdents to io_uring previously:

https://lore.kernel.org/io-uring/20230428050640.GA1969623@dread.disaster.area/

On the other hand, AFAICT, support for openat() was originally added in
15b71abe7b52 (io_uring: add support for IORING_OP_OPENAT) without a non-
blocking lookup, and the possibility of non-blocking lookup later added
in 3a81fd02045c (io_uring: enable LOOKUP_CACHED path resolution for
filename lookups).

(To be honest I'm a little confused by the history here. The commit
message of 15b71abe7b52 says

> For the normal case of a non-blocking path lookup this will complete
> inline. If we have to do IO to perform the open, it'll be done from
> async context.

but from the commit contents this would NOT appear to be the case: 

> +       if (force_nonblock) {
> +               req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
> +               return -EAGAIN;
> +       }

until the support is really added in the later commit. Am I confused or
is the commit message wrong?)

In any event, based on my reading of the history, it would appear to be
OK to add open_by_handle_at() initially without support for inline
completion, and then later add that when the filesystem implementations
can be updated to support this.

Please let me know if I am wrong on my interpretation of the history or
if anyone disagrees with the conclusion.

Testing
=======

A liburing branch that includes support for the new opcodes, as well as
a test, is available at:

https://github.com/bertschingert/liburing/tree/open_by_handle_at

To run the test:

$ ./test/open_by_handle_at.t

Thomas Bertschinger (6):
  fhandle: create helper for name_to_handle_at(2)
  io_uring: add support for IORING_OP_NAME_TO_HANDLE_AT
  fhandle: do_handle_open() should get FD with user flags
  fhandle: create __do_handle_open() helper
  io_uring: add __io_open_prep() helper
  io_uring: add support for IORING_OP_OPEN_BY_HANDLE_AT

 fs/fhandle.c                  |  85 ++++++++++++---------
 fs/internal.h                 |   9 +++
 include/uapi/linux/io_uring.h |   2 +
 io_uring/opdef.c              |  14 ++++
 io_uring/openclose.c          | 137 +++++++++++++++++++++++++++++++---
 io_uring/openclose.h          |   5 ++
 6 files changed, 209 insertions(+), 43 deletions(-)

-- 
2.50.1


