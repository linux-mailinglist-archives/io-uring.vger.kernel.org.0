Return-Path: <io-uring+bounces-1194-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 398A488719F
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 18:07:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CD881C235FD
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 17:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A4457875;
	Fri, 22 Mar 2024 17:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="M2MdfLpn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02038605A1
	for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 17:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711127233; cv=none; b=QN2pV7IYdvMniIQk9scv8cXOied86QWJ5NSGiDzntAbt6ramekbTK/Iezcrk/KZkmw+Z6RJKUPYayuSp2gKx32+qYkMxghOVbJy9m3fRPIWwGSOFtA7+n364M1+CAS+oE0OcK6ixVWo2Fnx0kNvGiTlPnYxUf8aC82j0irzXOxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711127233; c=relaxed/simple;
	bh=snPo/MeoFMDoQI1rQS3XRnbzliJHwhQB1C/uVcGZTTk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=MfaTTuQPSnofQVRBJt79rq9UqApIr/83c/ElrDo5w2ZebZ6mhrmoKcvx1jY050ga0XelhRhJZB0uycXtbX+O4vT7F7GO9XFktjjqy+MIRD6uGvq7pbhJeKWhDkx15RmBuC7tTwGe7W8+LgQ6MnPSnFvrE7XlI7yPIHZuTOHunos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=M2MdfLpn; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-36699ee4007so2734225ab.0
        for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 10:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711127228; x=1711732028; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PIS9e8I6QmsjxYXFh7+eCVioRso74FiRgQZ/GaeWTFU=;
        b=M2MdfLpn530q/aXVM6pn1/t9OtQ8cznocA9TdoNW8r9ES8wuFxWbhmOwTHTH9N8fRJ
         Jqy7rmWIknFQd5BOdidrCQK4O/PQgpdSnIoyMqdXSTIx+VcUsQ8l4uMlgf13ky4gs6/b
         5QKGMtCYN5CbyDXU4XyrZW3ufj4CLKGTLXXGhAYG938F0IwJsn6cOcb7ctb7s5FOZZSy
         MzyKgi0Vrh0KbTuJ6Z9LhZrPbigh+TJVA/iUOxakWDtZPMI1l9Tn/BMvdnkeXwol8qNx
         9aAI7nW+ZnMmjEFH6aWlpZwxFVXYS11Jknd1TCTQS5K9edoN6qorE7a27SeZTeHtptuk
         O1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711127228; x=1711732028;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PIS9e8I6QmsjxYXFh7+eCVioRso74FiRgQZ/GaeWTFU=;
        b=LtaSj6vN7S+3uaVLrYcsiYMAHIuAXjXaOxGA9h8Q5kUd+KKm1TFg+uxy8t7grz5uKx
         fG+H93AvDpks1p0jDkiKiD8CxEzpaXrcmPYZp12MnAOhwoHBYyqVnEwcXbFIV0xqUv14
         JAEdwZuByhC2JNW1Om4j9U1FXq64+OF5i6e4HFlruqDQF0bRubvHWy8jvGZWFPMGbcHa
         Lq5uCUufyAPP6CbbSUfEQkcR6NYVAovCFqzU/RS2g88+s/0W/T7tW/D7vcsEDMw7fXJG
         YtKX3B/AbI1hnTfBGx9p0Erphjccoz+eRvNtJx98xtGBHUDXA0V+KGDjWQhIpH8YKey8
         HeZQ==
X-Gm-Message-State: AOJu0YxYC0pKXwhcJGt/z9jtswMt6gSuyQN9i6ukQVIbULtgO+XCppHj
	/+LSMPFyee4jPIVbn6DgMMwYrmhW3r9zsZaMbabQtrru9hidQ6KCGY46U7/PWgwmw1vs6qawJFb
	K
X-Google-Smtp-Source: AGHT+IF/PRif+eG4FUnd/Xh+XAkFRAclXrN1bKDC1TozFXY+DytkywBNCTMUODyqXs72KM1tPrht7g==
X-Received: by 2002:a5e:9905:0:b0:7cc:6b9:a59c with SMTP id t5-20020a5e9905000000b007cc06b9a59cmr37939ioj.1.1711127227898;
        Fri, 22 Mar 2024 10:07:07 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eq21-20020a0566384e3500b0047c051115e9sm56479jab.4.2024.03.22.10.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Mar 2024 10:07:07 -0700 (PDT)
Message-ID: <35b87421-96fe-468c-9136-dcfb24a70a95@kernel.dk>
Date: Fri, 22 Mar 2024 11:07:06 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.9-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus.

Later fixes for the 6.9 merge window. One patch just missed the initial
git pull, the rest are either fixes or small cleanups that make our life
easier for the next kernel. In detail:

- Fix a potential leak in error handling of pinned pages, and clean it
  up (Gabriel, Pavel)
- Fix an issue with how read multishot returns retry (me)
- Fix a problem with waitid/futex removals, if we hit the case of
  needing to remove all of them at exit time (me)
- Fix for a regression introduced in this merge window, where we don't
  always have sr->done_io initialized if the ->prep_async() path is used
  (me)
- Fix for SQPOLL setup error handling (me)
- Fix for a poll removal request being delayed (Pavel)
- Rename of a struct member which had a confusing name (Pavel)

Please pull!


The following changes since commit 045395d86acd02062b067bd325d4880391f2ce02:

  Merge tag 'cgroup-for-6.9' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup (2024-03-11 13:13:22 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.9-20240322

for you to fetch changes up to 1251d2025c3e1bcf1f17ec0f3c0dfae5e5bbb146:

  io_uring/sqpoll: early exit thread if task_context wasn't allocated (2024-03-18 20:22:42 -0600)

----------------------------------------------------------------
io_uring-6.9-20240322

----------------------------------------------------------------
Gabriel Krisman Bertazi (1):
      io_uring: Fix release of pinned pages when __io_uaddr_map fails

Jens Axboe (7):
      io_uring: don't save/restore iowait state
      io_uring/rw: return IOU_ISSUE_SKIP_COMPLETE for multishot retry
      io_uring/futex: always remove futex entry for cancel all
      io_uring/waitid: always remove waitid entry for cancel all
      io_uring/net: ensure async prep handlers always initialize ->done_io
      io_uring: clear opcode specific data for an early failure
      io_uring/sqpoll: early exit thread if task_context wasn't allocated

Pavel Begunkov (4):
      io_uring: clean rings on NO_MMAP alloc fail
      io_uring: simplify io_pages_free
      io_uring/kbuf: rename is_mapped
      io_uring: fix poll_remove stalled req completion

 io_uring/futex.c    |  1 +
 io_uring/io_uring.c | 63 +++++++++++++++++++++++++++++------------------------
 io_uring/kbuf.c     | 20 ++++++++---------
 io_uring/kbuf.h     |  2 +-
 io_uring/net.c      |  9 +++++++-
 io_uring/poll.c     |  4 ++--
 io_uring/rw.c       |  2 ++
 io_uring/sqpoll.c   |  6 ++++-
 io_uring/waitid.c   |  7 +-----
 9 files changed, 65 insertions(+), 49 deletions(-)

-- 
Jens Axboe


