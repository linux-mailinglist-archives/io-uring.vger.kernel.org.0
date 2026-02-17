Return-Path: <io-uring+bounces-12273-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id crkQDbDkk2mv9gEAu9opvQ
	(envelope-from <io-uring+bounces-12273-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 04:46:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 71505148A2A
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 04:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 14CF63014123
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 03:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62DCFC8E6;
	Tue, 17 Feb 2026 03:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P1piGKMt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FDC4A21
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 03:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771300012; cv=none; b=BfqUm3dlcopkYQuE7f+EbHVpmIuvhOwzheXfKpbcevLoc81wu5IrT0Jc6zZeaNyFQCGhKMgXCyGiLdw/tk/s/jt7bW19b7uV25WJBo93qdSZFYSV/v/t4xttDIs1YbVHK54ZZL0K9HY21NJZ/1MgL2oRr+Y0BtPueasUHzWyqgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771300012; c=relaxed/simple;
	bh=7ZfmE+qYJ9TJ6uv1BkH5Gs0d/oPDYqGXlp5FKEpqabQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=XvP9YlCi9FNx+mgcI7Ci9wV+0TBjUwCiPn3UB5XxmwmHf/jFV+hEBJ6iL+K905kM7FAG+Kvujv/oVbdv9YZD9Y1Y1PcItPf1FL2VK0StMKT8/gNvjrP3NBV32qjLQyC80w66MybmBxqeo3fjVEMAzG/6NJnWfVNlzipQ9wewpEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P1piGKMt; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-45f053b7b90so2423538b6e.0
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 19:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771300007; x=1771904807; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w3l/wzqVQYmiCJZ2KlSBNPBQrzFo2F4JgAYFedPFgGs=;
        b=P1piGKMtE/S1qE7tqI7TZQKbctTBkr7QWAxmvIMpNkbexZW+Qt2kypapx1N+r8UIGm
         ta3jFcetL5BO3P90OZ010O+KsN3D9hUgavK4Wu6xeqG5vkxIcQMP+mDvQhjm9NeP4Dys
         RLOoUQfHte2sSXgFNMMfcG2kVCCJ7MfqbWwk/toNhpbo8KdoPx7cGVzfD1uhDssIN6tz
         edspHWri//nwPpq81HlmaKOkpNXSyqX0aLWEFWDm0/qBW/zkfzXoUOjqOXXLf/gP7RiN
         mtOu7eu+iZIPB4QGIM10JXwwU4n9Qmme3aKgwAGE+m4OkfDHcGBq38xXcH5Hdx42ZzPI
         NJCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771300007; x=1771904807;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w3l/wzqVQYmiCJZ2KlSBNPBQrzFo2F4JgAYFedPFgGs=;
        b=gb1nQvrCco7MoGT8yhIMPWGYUvgQiBC6NxrpkafKoVzygSX0n2RRc1e3UVvrEPxEOI
         z1mDyAou6rh1x1xCxhulpGvqenbxC8KJFaO/fdGIMEs2wTMvQm8TH24VNpWH4e09OSF3
         1DMvBV1mGrIq89EVhdFoTJ1j5bQg77yZZTEpYzTi6KG0+dTLS3AvU9a/baK9iJ0TP6KN
         OvFoQZ3nLdUUxswjL+0A9oPZVpvo/FIKEJg7mAtC4l987FyZ2/X1qEXcfl1wiFJuUkb9
         /zWVa7V9guV+e1F9MJpLBI9esdp9+qVsA0934L47OgLsu9veCg8CNxBTdUI4Gs/05qoy
         v4CA==
X-Gm-Message-State: AOJu0YzbvWjPo2BVLsULJ0+O0O6MGAR4ZgTTIJZkf38/7gamEid22YX1
	71GiKga6aFYRI2chEFMW77Y4xnCbaxls7kJkcGEkeAiSsBe81CaK0ArYKJi7lc5IZ28j4Djmk4L
	XdUYsoBw=
X-Gm-Gg: AZuq6aIzxdfM/XlXGi68YrMPJ/FKaPmHvYtzFAHNvc/oe3p5sp0OqRHLbS0is1WsOjQ
	U06YVMyeJYsfEdENo0pwB8kVdkGAo8AjVwBFREt/bXYlBjIrLkrTa+CTksgsWFf5VTxYFQUDs4N
	Vfn/LjbXg9CLRiwxi8yfiaoAqTxc7YZSPoMIB0/CHoNIYY0I3Ij4EohKK9SpGS1h7cni9yhx/l8
	SmX3SeGCyRw9nKJmxbgDMwi1IQblgilY9RiI2p9NmLn2ie67+9+Vb4wnCIfeFsjRq2lbPbrgFFJ
	ydEvbfD+JxYFeoJh8sFJa5az+K9skGqwfFgrpPdD6/plz/l9KGDRp95O2nRVY9GDgUSduuv/Y1j
	9YOhdFRB2aiOn/rySwp3OGJiBmBjaToBRrciadcSV8mhw41LAYfj/24AvwCUIaluzlqv4rOvmJU
	zUh0DKthTSeDhl5v4PWOIYUG4rG9J0JZ6WopDjhrH0fjJKE5zMmRNoqRPGi7n9WTEdVxZ3/Y3Ym
	qI7j4aSjA==
X-Received: by 2002:a05:6808:c2de:b0:45e:a7af:e8ec with SMTP id 5614622812f47-4639f22b345mr6728868b6e.49.1771300007435;
        Mon, 16 Feb 2026 19:46:47 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4638e05aa10sm9104798b6e.5.2026.02.16.19.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 19:46:46 -0800 (PST)
Message-ID: <73fba1d9-05bb-4f4c-9de0-514688c10947@kernel.dk>
Date: Mon, 16 Feb 2026 20:46:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Final io_uring fixes and changes for 7.0-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-12273-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 71505148A2A
X-Rspamd-Action: no action

Hi Linus,

Usually I'd send this out closer to the end of the week, but I'm heading
out of town for a bit, so shipping these to you know. This is a mix of
cleanups and fixes. No major fixes in here, just a bunch of little
fixes. Some of them marked for stable as it fixes behavioral issues.
This pull request contains:

- Fix an issue with SOCKET_URING_OP_SETSOCKOPT for netlink sockets, due
  to a too restrictive check on it having an ioctl handler.

- Remove a redundant SQPOLL check in ring creation.

- Kill dead accounting for zero-copy send, which doesn't use ->buf or
  ->len post the initial setup.

- Fix missing clamp of the allocation hint, which could cause
  allocations to fall outside of the range the application asked for.
  Still within the allowed limits.

- Fix for IORING_OP_PIPE's handling of direct descriptors.

- Tweak to the API for the newly added BPF filters, making them more
  future proof in terms of how applications deal with them.

- A few fixes for zcrx, fixing a few error handling conditions.

- Fix for zcrx request flag checking.

- Add support for querying the zcrx page size.

- Improve the NO_SQARRAY static branch inc/dec, avoiding busy conditions
  causing too much traffic.

- Various little cleanups.

Please pull!


The following changes since commit 4adc13ed7c281c16152a700e47b65d17de07321a:

  Merge tag 'for-7.0/block-stable-pages-20260206' of git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux (2026-02-09 18:14:52 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260216

for you to fetch changes up to be3573124e630736d2d39650b12f5ef220b47ac1:

  io_uring/bpf_filter: pass in expected filter payload size (2026-02-16 15:56:31 -0700)

----------------------------------------------------------------
io_uring-7.0-20260216

----------------------------------------------------------------
Asbjørn Sloth Tønnesen (1):
      io_uring/cmd_net: fix too strict requirement on ioctl

Caleb Sander Mateos (1):
      io_uring: simplify IORING_SETUP_DEFER_TASKRUN && !SQPOLL check

Dylan Yudaken (1):
      io_uring: remove unneeded io_send_zc accounting

Jens Axboe (6):
      io_uring/filetable: clamp alloc_hint to the configured alloc range
      io_uring/openclose: fix io_pipe_fixed() slot tracking for specific slots
      io_uring: use the right type for creds iteration
      io_uring/cancel: de-unionize file and user_data in struct io_cancel_data
      io_uring/bpf_filter: move filter size and populate helper into struct
      io_uring/bpf_filter: pass in expected filter payload size

Pavel Begunkov (9):
      io_uring/zcrx: improve types for size calculation
      io_uring/rsrc: replace reg buffer bit field with flags
      io_uring/zcrx: fix sgtable leak on mapping failures
      io_uring/zcrx: fix post open error handling
      io_uring/zcrx: check unsupported flags on import
      io_uring/query: return support for custom rx page size
      io_uring/query: add query.h copyright notice
      io_uring: delay sqarray static branch disablement
      io_uring/rsrc: improve regbuf iov validation

Yang Xiuwei (1):
      io_uring/tctx: avoid modifying loop variable in io_ring_add_registered_file

 include/uapi/linux/io_uring.h            |  8 ++++
 include/uapi/linux/io_uring/bpf_filter.h |  8 +++-
 include/uapi/linux/io_uring/query.h      |  6 ++-
 io_uring/bpf_filter.c                    | 82 +++++++++++++++++++++-----------
 io_uring/cancel.h                        |  6 +--
 io_uring/cmd_net.c                       |  9 ++--
 io_uring/filetable.c                     |  4 ++
 io_uring/io_uring.c                      | 13 +++--
 io_uring/net.c                           |  2 -
 io_uring/opdef.c                         |  6 +++
 io_uring/opdef.h                         |  6 +++
 io_uring/openclose.c                     |  9 ++--
 io_uring/query.c                         |  2 +-
 io_uring/rsrc.c                          | 43 +++++++----------
 io_uring/rsrc.h                          |  6 ++-
 io_uring/rw.c                            |  3 +-
 io_uring/tctx.c                          | 10 ++--
 io_uring/zcrx.c                          | 16 ++++---
 18 files changed, 149 insertions(+), 90 deletions(-)

-- 
Jens Axboe


