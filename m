Return-Path: <io-uring+bounces-12085-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sCgCB/A5hmmcLAQAu9opvQ
	(envelope-from <io-uring+bounces-12085-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 19:58:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 800A710255B
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 19:58:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BC91D303A84A
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 18:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666664279FD;
	Fri,  6 Feb 2026 18:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HTuvgBSb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1984F42848E
	for <io-uring@vger.kernel.org>; Fri,  6 Feb 2026 18:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404291; cv=none; b=IdL2w9cNhgmAnxFcFAIDtHcPDsZmF1D7bCk4qebM6KnkW5lggalrzTVJIvc2zVHzLS4T6DLFERHuqXfcGvcsBjhu4zxtzOjom1Y13dYeU34oWL2/A3Nsed0Er9wUjftqJGRY2s3oIfjh5//9BABqG08LF0YpDgSvC89QCtwXRU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404291; c=relaxed/simple;
	bh=Ov5+ShbkfbVH1cj72wn0K96kZfFVsGXrUgq7a4ISWlI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=MC2/9MrAI2nZfVDX70lmB49CVWPMvUcT6qJ7VZROv2MBXYW0ldw03p9wYPA1+119wNaTsmxC7g40zDsVMdIgN/1Ifrkd4n0za/UF1H/dnpJogb7rSH9EqoKRfwDNz3699zlZCv/1kJGWp67ZIGbEfszWdnSu9euK4+T4TwJ573Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HTuvgBSb; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-40423dbe98bso483828fac.2
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 10:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770404290; x=1771009090; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NFayfXFCr8uTtagrI+irxnDsr7Q6K8DeRpjr+PMPA0A=;
        b=HTuvgBSbr82UG3wGIbG7czDW2LIii11nrWrrvshU3YPaGv+dxrMrpQ5FYO25XHc/e6
         nBcQYYIstZVaAq8FhG3gMOsyUWWZDxl7b2mwp+XmaFDQ970JYXMhBKOcJy1Pw7oIBzoL
         Evquc/FT4FPbh6IbSN2uwqgfs7/hFxFHazbz5sfQ/DtxcNQj2pUfPAAUkazojt9glafn
         iQ2s5q4C54+6AlCE+unI/O5YZoUXVkf3K635cAbWQR6nl2XyE4qIw1TfgWbiDfwuwSM+
         Aew5+t58v1+IUh0ToQbWzArbRuv0Ng1FZD8DwnqWBk84ErU8TwMCgYY3tZWyuI9AADcG
         lQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770404290; x=1771009090;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NFayfXFCr8uTtagrI+irxnDsr7Q6K8DeRpjr+PMPA0A=;
        b=Gvn7nK/BUwHptFMrFLEGWsqlCVTa9ndbbPMOaqkwLu2NbsFYgtbPovxWsOdxqPMq9l
         WjvM9Ym2Abyy2Udy5Q7Zb8uxPoukDsOp8mOrq+Q5KYT4gadlKfXh6SN3dp4BKfVQAvna
         eJOv6DNRsRUMGeTmu0jHfj6ZF6Popm5FOgoVQv3GI/UnXLG43I+JycktPZ7Bfu7CrFQ0
         1emDjGghPaKFiCSwoLNA6JFgNBJlcsGenNAFkUiFoKVcs870AuClNcK7KKVbw4nYpmye
         L+jtbbpM9nDgl03dn/au5wNKAxz8Co6dd+3rWNHY8gcFfljW1x0GZus9hSSHTf93YJb0
         bfzg==
X-Gm-Message-State: AOJu0YwOHgKh6UZ+qrBwrZPmYqnfJesOzoBy8CtU3LR+hl8bqXmHAMpF
	lKLw2mhFWdMC1/CC55C7Fsl+0EMorJXy9g+CHq5KiMPJaijDZ6QtXuDrq+LEDwMDhHw3WRf2y7T
	uClfnU7g=
X-Gm-Gg: AZuq6aJG06bs7r3ulKP/HVrYKXFFCU+A65nfp6R2cxTdmptmM6M/MyNfa2g2GAKqIv1
	e8rluOnrq5hXvBxGtmpxn3SAxo8HQogQkGIqI1NzmSJrYQIXUo65eebDsT4qpHq8R3gIsGTZxnN
	w+i8erycfRwg8pqCruTc+egDGVPF5YcRctkqkiqEhW9cbcjEOhr8OChN6uTOab9I1QaYa6UMKsb
	J3OZ1heNhcQl0a4k0mNdsnsDAu4wOhKl1qmvwA9cx23w4GToYphff38pp5eFDqSr6w48/zJd9Wx
	WPo8ZdxijCh1AklBnQN7mvSjv8AfMguJx8UicTo+PbXCRq3EtoEI3cHqMJ9wivp2r4C0k634ayz
	nDxQdE6hQSUoZpWTbXXEfaEP05BmGm6sXCfSmf5M1X0ecgXUucczDhKIl7AVrUwvBXI43xkG1jS
	9y7rUTKmbOgxcjfpKY7+eDZVcBOLkcLJv5moiLQWe3JthW6BDujVVsPLRd7j3bMwGT23q2
X-Received: by 2002:a05:6870:8dcd:b0:3ec:4f18:9c79 with SMTP id 586e51a60fabf-40a96ca7334mr2072534fac.13.1770404289918;
        Fri, 06 Feb 2026 10:58:09 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40a99787786sm2432762fac.19.2026.02.06.10.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Feb 2026 10:58:09 -0800 (PST)
Message-ID: <c168f48a-0cdc-4bb0-be00-a778aab27e04@kernel.dk>
Date: Fri, 6 Feb 2026 11:58:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring cBPF filter support
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Christian Brauner <brauner@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12085-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 800A710255B
X-Rspamd-Action: no action

Hi Linus,

On top of the core io_uring changes, this adds support for both cBPF
filters for io_uring, as well as task inherited restrictions and
filters.

seccomp and io_uring don't play along nicely, as most of the interesting
data to filter on resides somewhat out-of-band, in the submission queue
ring. As a result, things like containers and systemd that apply seccomp
filters, can't filter io_uring operations. That leaves them with just
one choice if filtering is critical - filter the actual
io_uring_setup(2) system call to simply disallow io_uring. That's rather
unfortunate, and has limited us because of it.

io_uring already has some filtering support. It requires the ring to be
setup in a disabled state, and then a filter set can be applied. This
filter set is completely bi-modal - an opcode is either enabled or it's
not. Once a filter set is registered, the ring can be enabled. This is
very restrictive, and it's not useful at all to systemd or containers
which really want both broader and more specific control.

This patchset first adds support for cBPF filters for opcodes, which
enables tighter control over what exactly a specific opcode may do. As
examples, specific support is added for IORING_OP_OPENAT/OPENAT2,
allowing filtering on resolve flags. And another example is added for
IORING_OP_SOCKET, allowing filtering on domain/type/protocol. These are
both common use cases. cBPF was chosen rather than eBPF, because the
latter is often restricted in containers as well.

These filters are run post the init phase of the request, which allows
filters to even dip into data that is being passed in struct in user
memory, as the init side of requests make that data stable by bringing
it into the kernel. This allows filtering without needing to copy this
data twice, or have filters etc know about the exact layout of the user
data. The filters get the already copied and sanitized data passed.

On top of that support is added for per-task filters, meaning that any
ring created with a task that has a per-task filter will get those
filters applied when it's created. These filters are inherited across
fork as well. Once a filter has been registered, any further added
filters may only further restrict what operations are permitted. Filters
cannot change the return value of an operation, they can only permit or
deny it based on the contents.

Please pull!


The following changes since commit 0105b0562a5ed6374f06e5cd4246a3f1311a65a0:

  io_uring: split out CQ waiting code into wait.c (2026-01-22 09:21:16 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-bpf-restrictions.4-20260206

for you to fetch changes up to ed82f35b926b2e505c14b7006473614b8f58b4f4:

  io_uring: allow registration of per-task restrictions (2026-02-06 07:29:19 -0700)

----------------------------------------------------------------
io_uring-bpf-restrictions.4-20260206

----------------------------------------------------------------
Jens Axboe (7):
      io_uring: add support for BPF filtering for opcode restrictions
      io_uring/net: allow filtering on IORING_OP_SOCKET data
      io_uring/bpf_filter: allow filtering on contents of struct open_how
      io_uring/bpf_filter: cache lookup table in ctx->bpf_filters
      io_uring/bpf_filter: add ref counts to struct io_bpf_filter
      io_uring: add task fork hook
      io_uring: allow registration of per-task restrictions

 include/linux/io_uring.h                 |  14 +-
 include/linux/io_uring_types.h           |  13 +
 include/linux/sched.h                    |   1 +
 include/uapi/linux/io_uring.h            |  10 +
 include/uapi/linux/io_uring/bpf_filter.h |  62 +++++
 io_uring/Kconfig                         |   5 +
 io_uring/Makefile                        |   1 +
 io_uring/bpf_filter.c                    | 430 +++++++++++++++++++++++++++++++
 io_uring/bpf_filter.h                    |  48 ++++
 io_uring/io_uring.c                      |  48 ++++
 io_uring/io_uring.h                      |   1 +
 io_uring/net.c                           |   9 +
 io_uring/net.h                           |   6 +
 io_uring/openclose.c                     |   9 +
 io_uring/openclose.h                     |   3 +
 io_uring/register.c                      |  91 +++++++
 io_uring/tctx.c                          |  42 ++-
 kernel/fork.c                            |   6 +
 18 files changed, 789 insertions(+), 10 deletions(-)
 create mode 100644 include/uapi/linux/io_uring/bpf_filter.h
 create mode 100644 io_uring/bpf_filter.c
 create mode 100644 io_uring/bpf_filter.h

-- 
Jens Axboe


