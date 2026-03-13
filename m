Return-Path: <io-uring+bounces-12662-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WNWAJE35s2nWeQAAu9opvQ
	(envelope-from <io-uring+bounces-12662-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2026 12:47:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EB8C32826EE
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2026 12:47:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3473A30D2D6A
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2026 11:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B87E37D130;
	Fri, 13 Mar 2026 11:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wwi2ecG/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5796A2E06E4
	for <io-uring@vger.kernel.org>; Fri, 13 Mar 2026 11:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773402437; cv=none; b=RvXZ+Mtg+yN7xAYevZt1F1FWC39uK1zHs+YDWE00coAKkxhiHthC/MKpYnkwooOSBap7qKpnK9EkslbmEW5xmFZMQuRaRxHXfQtDxkUA/CGGq4s2E6M7IIBEryc8+23XFsGwdtBHQpxmANcrGlmiqcyAfBHYQTN50C5+y0382AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773402437; c=relaxed/simple;
	bh=dC/uLwqqQ5tGsyI01VwIJly3I3etT8qhy8wM/ZsUsjs=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=u5vv9SDwcvaKWI+cwUii8il4vVN573NAcVNb6vfj+gBQ5Y3FnN5xgBNTAv/JFhbMGxDH4ab5Af00r95moENerBaHToUGhswPSfrehiz3xdZe8LWXtpIg4VosXPycn2elgHyWd4RS2YYeIWfRGWWkt6JAaaQVeGhqkWWXBn4skBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wwi2ecG/; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-46704fbf62dso1374823b6e.1
        for <io-uring@vger.kernel.org>; Fri, 13 Mar 2026 04:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773402434; x=1774007234; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cOGuFOl2uPxgV3D3PuvOfgu6T6mAqkjLmtI2ktXoBsk=;
        b=wwi2ecG/whuI78ufXJVSZ6PF/qQ0qWdEEqxrwpNXT/EWVjegcM3qph60PJbEvVIlGo
         R3rkUN+POiwhUv0Isa8IT0eMSWlbue+MptN7KGsHhfFQjlX1LJiA5wozg/14vRvNdZfH
         1cNchIaP34erxgonAYOfptBBMIWPsfPcW9e6S/G0BF7wNCG0oLkyD8FMAGlzlnLC1KKZ
         A0trzAGpfwhg8F98lP5kLvhvePKfPfQyHB7N8ZC6QTrj8OHMGySXLzwnPF/3dnetHdv3
         lcHr3gCfG1eIoqAQF1eQHokRo72vI91z2d/jM1JCID3iwjPE/KVKNew5r9P3XcbR/dJF
         2WaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773402434; x=1774007234;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cOGuFOl2uPxgV3D3PuvOfgu6T6mAqkjLmtI2ktXoBsk=;
        b=iyQOr9F7cdgzfXiYttlKncwPQB4Adb49ayxHYUQ7LjT8kB1YjufSL5TsqJiRfg/4Ag
         oycY+JBdIZV5mIofh1pj737vSWH/L5nt9QFWbmDbupC3XfiQDMZrf4gGOGwJm8S/4kp6
         IrktuTq/feDtSDvR9Q8piRBjD6VJ7ooBt9f+u8+fYroWv3v3ZqVLhwrUBKJ8c0fzhK4Z
         5lY+UVkAQ788A3v91pTfeWXWED1czg4DRuWMj9nirUYkMvOL1TJLzZAElCjTiwLaaakV
         Z3x3oEd90zU61OVgqCbK1SZ523oT0o6ALwe/T76NwAfl3LaK7bKh3mipErfnMwAtv7bI
         sP1g==
X-Gm-Message-State: AOJu0YxXlEsrSvTuG8o+Rbg8zbzoFeT+8lp2fghbQo1gMUHoV3EHFiqn
	83mlz5Bg6y9iz4PPT2yjhOu+5cVAT57ObgvSt3sKeRNgpN22WOykEzBKzsiMOXHVQmE67FpXOty
	ZDTukhp8=
X-Gm-Gg: ATEYQzw7I1dnMOrT7D7hz8EjCzjfOwq/XHEHFTFxCIRiTIVv8jVPdqMB/P8q1s2utVn
	inwbxao4Rlu99ywUbPvGhBAjWQXYu/D/gNnwgyBanUlKe6D2LIaUhy2BPWjV8X50GKkhQCFd07B
	G4eSlxyxtiK6u8OacKzp1T6DiH9SKWE4dKaAU8saF70afWlJ85AwGjp7mxh+bzRXPACH52wGAuo
	DbQ2hqQyOo84yP3V5WhF+jX71m5QAiF25RLHiKDlx7RE8hslKTjbm/G4AyOQz+KNrEgqBhXm8sj
	AMqXamGPt9fmhoDT5pJ6N3M7FjEIGouYlX1NYeuNJBN83sImF0JtYNxyBQnyaR80qCFZy72irrO
	zuqvfarzjFEdUuS9MrM41LQN7WygDpLJp5GbT0c85GHgGIqGLZGYsw6Nc6pNRPr+odmHWlWw+oG
	9w1ESgvSw0j/PzjRDEbrCFQ/GBcybNugizO48AcftJqSpGeahUcDi9IaCkXxaOLxX0sbCv+i80m
	8eWheTCGg==
X-Received: by 2002:a05:6808:3095:b0:463:ab56:9ed2 with SMTP id 5614622812f47-467570ef6bfmr1397964b6e.17.1773402433953;
        Fri, 13 Mar 2026 04:47:13 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4674de9eee9sm2244345b6e.13.2026.03.13.04.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 04:47:12 -0700 (PDT)
Message-ID: <0ee80082-40b4-462d-9661-142cfb67a56c@kernel.dk>
Date: Fri, 13 Mar 2026 05:47:11 -0600
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
Subject: [GIT PULL] io_uring fixes for 7.0-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12662-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: EB8C32826EE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Linus,

Set of fixes for io_uring that should go into the 7.0 kernel release.
This pull request contains:

- Fix an inverted true/false comment on task_no_new_privs, from the BPF
  filtering changes merged in this release.

- Use the migration disabling way of running the BPF filters, as the
  io_uring side doesn't do that already.

- Fix an issue with ->rings stability under resize, both for local
  task_work additions and for eventfd signaling.

- Fix an issue with SQE mixed mode, where a bounds check wasn't correct
  for having a 128b SQE.

- Fix an issue where a legacy provided buffer group is changed to to
  ring mapped one while legacy buffers from that group are in flight.

Please pull!


The following changes since commit 531bb98a030cc1073bd7ed9a502c0a3a781e92ee:

  io_uring/zcrx: use READ_ONCE with user shared RQEs (2026-03-04 06:30:39 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.0-20260312

for you to fetch changes up to c2c185be5c85d37215397c8e8781abf0a69bec1f:

  io_uring/kbuf: check if target buffer list is still legacy on recycle (2026-03-12 08:59:25 -0600)

----------------------------------------------------------------
io_uring-7.0-20260312

----------------------------------------------------------------
Jann Horn (1):
      io_uring/register: fix comment about task_no_new_privs

Jens Axboe (4):
      io_uring/bpf_filter: use bpf_prog_run_pin_on_cpu() to prevent migration
      io_uring: ensure ctx->rings is stable for task work flags manipulation
      io_uring/eventfd: use ctx->rings_rcu for flags checking
      io_uring/kbuf: check if target buffer list is still legacy on recycle

Tom Ryan (1):
      io_uring: fix physical SQE bounds check for SQE_MIXED 128-byte ops

 include/linux/io_uring_types.h |  1 +
 io_uring/bpf_filter.c          |  2 +-
 io_uring/eventfd.c             | 10 +++++++---
 io_uring/io_uring.c            |  4 +++-
 io_uring/kbuf.c                | 13 +++++++++++--
 io_uring/register.c            | 15 +++++++++++++--
 io_uring/tw.c                  | 22 ++++++++++++++++++++--
 7 files changed, 56 insertions(+), 11 deletions(-)

-- 
Jens Axboe


