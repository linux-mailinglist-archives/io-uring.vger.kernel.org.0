Return-Path: <io-uring+bounces-12084-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OIrnMts5hmmcLAQAu9opvQ
	(envelope-from <io-uring+bounces-12084-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 19:58:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB2A102534
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 19:58:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 59CEF3019937
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 18:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5BE74279FD;
	Fri,  6 Feb 2026 18:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mu/120Ma"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9D6426D33
	for <io-uring@vger.kernel.org>; Fri,  6 Feb 2026 18:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404283; cv=none; b=hzmLBDDxTSgwjgpQWHYbQfW51rbb70DzR1n1eovi7kWJ3aF20EjuiEa6yfsL7l+oN+qX9waAX69mDq+ge2FPvHWBOBLbEeC+jGY9W3gVDwGoocijA4ZM6EVYqFZJViSHqutDIuSlmxnlIPjCPz3XpwrxCAWCYMOQlaf5nxKqEVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404283; c=relaxed/simple;
	bh=vzZNh5U2yVPMpeaiu/a9NOpdOC3DSgGwk+zgnXudzUY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=YjYyYG0CfcjoBANjzd4Dddk2MwonUdJ24ZlKsstC7R51ldsmQQRINdV9iz0c1QAaLstbyOwwwkWLSR24H1cY0OdWLj2cx+SoyDhrvPgUHcN6CjgpYbOOnIdF7N4MgUuqm9orPCcixPzhsA07KlgVFO4MI6k+TF6IAKCQ4ceUEUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mu/120Ma; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-45c9fdf2a06so1586465b6e.2
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 10:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770404281; x=1771009081; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71ezICaRc4m/qHo8jJKCOEt7GyfkqYx02DLx3kVAkQ4=;
        b=mu/120Ma5BJt6Gh1hf2H/VyVJISPEqTdhC9oOI85+TLunMjelY5k42DVmHwLfcvy31
         MiaAL6E6plQ9L286/45uitaTKpByfBbUkVcRYaodVbU22jzKjwmafoPP3IfFk0wvm+p4
         UGbts9k+TWRpDcOSxIyPQjJv4q4j+9TLR0OIr6ZM00GbF4USK/zSfxFHp+rmWbFsA2Q+
         jtDo5BBCSs4Q4nt82ZlKdZxKzCNTqgHnQG3+XK9rEwK+3qGrwjMSGUwNn1/lDcXAYkt6
         sUNQGEk/G6epdyW2UdAHkI0hJFO/XlrFI7+NQOTtKK6r/B2rIqeFQs39vTZLsfux0BIN
         fHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770404281; x=1771009081;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=71ezICaRc4m/qHo8jJKCOEt7GyfkqYx02DLx3kVAkQ4=;
        b=GlsIcWPSKYezxzYaZ3q0TiNf0Ooq85J/OGwTh6xVUWytwJaQdUj5OYWungUswhykji
         ctcct41YHGX6c9zSV03mlaAyqR1hgywP3CvFgpvIlDWgSlz+Y+i5Iwi0jxjU5Uxc4bV2
         a3aOo7jPq+vyhmqbWKfOfckFB2wfTynq3+nn6N2r6F4QIPtZc/HWqkE/Cy27kk+wopMu
         Z07GwC5TcC754O/J8zcC4C7n16RZOEBLiS5X9S4xqYQqRm+8tHw+rTDjgqY/4eJswJJV
         kNqVvxSWlb1Gm4HFB30eIiL/5V6w+lO40Pvg8/mv5rYhfXh/3xXW9T2Ok74t4VHMMDf9
         biYA==
X-Gm-Message-State: AOJu0YzS3F8Q3FhzRDRMTK1X/qaMLC12gidNONMryIncTLw56TT+/nxq
	0ZeB/vMkuXST0heUwGMEdSSI6dd7H9zfJ9SY0Zg1g5DdpRuudVT3eLP2Ijnymx1peZQeiDGnGRH
	roW9ow6Q=
X-Gm-Gg: AZuq6aL70yX4Pr1kx+cFEzPUjs9lf8IFefebRpHMOhxxIFh+nhiiqKJ7c2CUCOg2iry
	cTPfwJT5S/UILWrVWXmUXp4Ch+BoL7m52V9lTnhbB9mRrRQlBK+yqgLxunl/AdBi37wGSeJEb60
	EMzbI2GWH/kivW8PgKN+zwLvlsCXcDcC/awZL/Hlgbs2OR7qGxL2VQRDeBAm88axIb68PxAHQpU
	8cn10LIISx3TFQqIxu0AYT02CALXb3smqT9BBf3wpIuLquh4CvKG0ntq4Op4WFLy7/SWiEuiRGl
	nUW3aCVQBGxjipksL38JIYy7r0OiRBpAiJXe/ND8g+78tjlrjeFgoJVAC6XKxxJp6o0ehNzVgWm
	kSqp/tl+jlwB1iAPBQugw3C/I5izywN0v+rvb+79WUUDFMyiCi7Yl+Mi/DtDVV1fCOMLGxqs67i
	14bjbnVS/QpL+wqcW/fg8SiNGg+Ourranmp/2SzSLmAYbIWMs/5kr95Hm2oBcEAhFiXTSEO/vjj
	qhLuxc=
X-Received: by 2002:a05:6808:1a0d:b0:45e:e050:109e with SMTP id 5614622812f47-462fcf0466fmr1897726b6e.4.1770404281357;
        Fri, 06 Feb 2026 10:58:01 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-462fe9ddd81sm1780980b6e.6.2026.02.06.10.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Feb 2026 10:58:00 -0800 (PST)
Message-ID: <8b44ed7f-267f-433d-a3d3-262feb13d657@kernel.dk>
Date: Fri, 6 Feb 2026 11:57:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Core io_uring changes for 7.0-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12084-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2FB2A102534
X-Rspamd-Action: no action

Hi Linus,

Doing a few separate branches for this release, and one depends on the
networking tree so coming later, but here are the core io_uring changes
queued up for the 7.0 kernel release. Nothing major in this series. This
pull request contains:

- Series cleaning up the IORING_SETUP_R_DISABLED and submitter task
  checking, mostly just in preparation for relaxing the locking for
  SINGLE_ISSUER in the future.

- Improve IOPOLL by using a doubly linked list to manage completions.
  Previously it was singly listed, which meant that to complete request
  N in the chain 0..N-1 had to have completed first. With a doubly
  linked list we can complete whatever request completes in that order,
  rather than need to wait for a consecutive range to be available. This
  reduces latencies.

- Small series improving the restriction setup and checking. Mostly in
  preparation for adding further features on top of that. Coming in a
  separate pull request.

- Split out task_work and wait handling into separate files. These are
  mostly nicely abstracted already, but still remained in the io_uring.c
  file which is on the larger side.

- Use GFP_KERNEL_ACCOUNT in a few more spots, where appropriate.

- Ensure even the idle io-wq worker exits if a task no longer has any
  rings open.

- Add support for a non-circular submission queue. By default, the SQ
  ring keeps moving around, even if only a few entries are used for each
  submission. This can be wasteful in terms of cachelines. If
  IORING_SETUP_SQ_REWIND is set for the ring when created, each
  submission will start at offset 0 instead of where we last left off
  doing submissions.

- Various little cleanups

Please pull!


The following changes since commit f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da:

  Linux 6.19-rc3 (2025-12-28 13:24:26 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-7.0/io_uring-20260206

for you to fetch changes up to 442ae406603a94f1a263654494f425302ceb0445:

  io_uring/kbuf: fix memory leak if io_buffer_add_list fails (2026-02-05 11:13:16 -0700)

----------------------------------------------------------------
for-7.0/io_uring-20260206

----------------------------------------------------------------
Caleb Sander Mateos (4):
      io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
      io_uring/msg_ring: drop unnecessary submitter_task checks
      io_uring/register: drop io_register_enable_rings() submitter_task check
      io_uring/rsrc: take unsigned index in io_rsrc_node_lookup()

Gabriel Krisman Bertazi (1):
      io_uring: Trim out unused includes

Jens Axboe (21):
      io_uring: IOPOLL polling improvements
      io_uring/register: have io_parse_restrictions() return number of ops
      io_uring/register: have io_parse_restrictions() set restrictions enabled
      io_uring/register: set ctx->restricted when restrictions are parsed
      io_uring: move ctx->restricted check into io_check_restriction()
      io_uring: track restrictions separately for IORING_OP and IORING_REGISTER
      io_uring: fix IOPOLL with passthrough I/O
      io_uring/uring_cmd: explicitly disallow cancelations for IOPOLL
      io_uring/timeout: annotate data race in io_flush_timeouts()
      io_uring/eventfd: remove unused ctx->evfd_last_cq_tail member
      io_uring/sync: validate passed in offset
      io_uring: add IO_URING_EXIT_WAIT_MAX definition
      io_uring/io-wq: don't trigger hung task for syzbot craziness
      io_uring: split out task work code into tw.c
      io_uring: split out CQ waiting code into wait.c
      io_uring: fix bad indentation for setup flags if statement
      io_uring/io-wq: handle !sysctl_hung_task_timeout_secs
      io_uring/futex: use GFP_KERNEL_ACCOUNT for futex data allocation
      io_uring/rsrc: use GFP_KERNEL_ACCOUNT consistently
      io_uring/net: don't continue send bundle if poll was required for retry
      io_uring/kbuf: fix memory leak if io_buffer_add_list fails

Li Chen (2):
      io_uring/io-wq: add exit-on-idle state
      io_uring: allow io-wq workers to exit when unused

Pavel Begunkov (1):
      io_uring: introduce non-circular SQ

Tim Bird (1):
      io_uring: Add SPDX id lines to remaining source files

 include/linux/io_uring_types.h |  29 +-
 include/uapi/linux/io_uring.h  |  12 +
 io_uring/Makefile              |  14 +-
 io_uring/alloc_cache.h         |   2 +
 io_uring/cancel.c              |   5 +-
 io_uring/cmd_net.c             |   1 +
 io_uring/eventfd.h             |   1 +
 io_uring/filetable.h           |   1 -
 io_uring/futex.c               |   2 +-
 io_uring/io-wq.c               |  51 ++-
 io_uring/io-wq.h               |   2 +
 io_uring/io_uring.c            | 782 +++--------------------------------------
 io_uring/io_uring.h            |  90 +----
 io_uring/kbuf.c                |   5 +-
 io_uring/memmap.c              |   2 +-
 io_uring/memmap.h              |   1 +
 io_uring/mock_file.c           |   1 +
 io_uring/msg_ring.c            |  28 +-
 io_uring/net.c                 |   6 +-
 io_uring/notif.c               |   1 +
 io_uring/refs.h                |   1 +
 io_uring/register.c            |  42 ++-
 io_uring/rsrc.c                |   2 +-
 io_uring/rsrc.h                |   2 +-
 io_uring/rw.c                  |  33 +-
 io_uring/slist.h               |  13 +-
 io_uring/sqpoll.c              |   8 +-
 io_uring/sync.c                |   2 +
 io_uring/tctx.c                |  11 +
 io_uring/timeout.c             |   2 +-
 io_uring/tw.c                  | 355 +++++++++++++++++++
 io_uring/tw.h                  | 116 ++++++
 io_uring/uring_cmd.c           |   9 +
 io_uring/wait.c                | 308 ++++++++++++++++
 io_uring/wait.h                |  49 +++
 35 files changed, 1074 insertions(+), 915 deletions(-)
 create mode 100644 io_uring/tw.c
 create mode 100644 io_uring/tw.h
 create mode 100644 io_uring/wait.c
 create mode 100644 io_uring/wait.h

-- 
Jens Axboe


