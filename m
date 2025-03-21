Return-Path: <io-uring+bounces-7174-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 773BBA6C35B
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 20:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE884481439
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EEC422E3E1;
	Fri, 21 Mar 2025 19:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JzirajHm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2A522D781
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 19:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742585505; cv=none; b=B4lfRTruRA00H/w3n8ukYXhMC7JuIE28Kq5hnGEMH6Ez/qfVvvBEMOqBugSylWcFc3ATJXAU1UTFj5STRolSqIc22t1IKVgMR5M5oR9g9z8VaGN5oKBQyNgtEBUMSvkw/ADSwUKzwB+6FXSqbYwp+3/XotIdH2TLvpJMlg+x5Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742585505; c=relaxed/simple;
	bh=f7qDZuQpOZs95ANnuZCGGbS1V4U83lbedYVN4EhWHqY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M0q6/WrPPXhcDuP+w+WOgXABb0kAmg/Uzt/JHC9zFGfyp9R48wSa4BV+kB4e81u880fkpgQCy7dW6WJiXEm8elEc6IutuHQbCHJz/KSiQUZmjhGoZfPp91vXi9zxoso/mHRO+NemzbwMjWsxb9T9fq6bGZd5NqlvfsvFA2tKKfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JzirajHm; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-851c4ee2a37so154261239f.3
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 12:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742585500; x=1743190300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pt1RTWAqdIYdf2VC0s9lDHoBObb7iKaNhIX0AxAFxKQ=;
        b=JzirajHmXy5lKvPGDRMNhalW/fqHHGYosrs/dPI2Jfv9/pWlL/td8nOt2AgIVrGooM
         Gtj/KT48a1/6itTOF0JiAcHMhHh7K+ro0UOXlQ+9761RynVO7p5zQ3dMRL88nP75Vkh4
         nRbuCKGjLbZ92R4uuWWL2Dni8oLxW8f03h49i9nCuO0aUNXcsux5UI41tXCQ6KCkS45U
         cGMq0vCpdX9nWtnM8sYDkj+HRPupSkRZj9zGkLiXEWVATsMpjn24H+hRrzduK0exl2v8
         iL9mHeHbFBbZfxc7HX4HsBQP21DiShnHGpNjpmJZrEmMLYZ81rgSMuXj5eGgHm25T6Gw
         whlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742585500; x=1743190300;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pt1RTWAqdIYdf2VC0s9lDHoBObb7iKaNhIX0AxAFxKQ=;
        b=q8HdO8ILuW9pwbfQb+RQYlOYubOLpVkF/jbkNSQbU5sqWQcbeACWqS0amkyMNJKbJs
         5wGsTRhrzved0ZndR/lv5FjD5orGHFM+a8+Z5xlboMavyXPfEjbD6pNyPjh0Djsb1UYv
         Ux5zI5PPpA3dQiiu3qlEaNq5NWGCaI1uV8G/L/PL2Npxa+K6PdiuFqsoFCYc+lNv5qD1
         RDeRPNlTgjP+2jHHNYMkdX3DjpsCOUVhmiW8gD6ykwMsw3KK2Ars7Fxv9P4sNqKM9pR7
         H4pzmQNwyUsRlI14EpYG/IsFtO4TtY6nyk3hsOARmT9kpOVJQajEiH5YVgcIdcN3hFR2
         8cUg==
X-Gm-Message-State: AOJu0YwVrR8K17vrVguJI5zfOEiOBIoDDhtSJC5e1fvdp3YYrCPaCOtX
	l6L+DPRRfAMcKN0b8dTOguc3yumSRefRKRjmk2NJRe3M/0skPr7SQUMf1IgomDY4+a8/9vk533p
	y
X-Gm-Gg: ASbGnctw3UrQ+kMd4XMHbjrnvgje2dJUgsNmBEdjn04B47jfVv4aotagz+21eefyuXj
	30UxZGXIc1X4Fv7rUtsXEtz4VhlxGttEw3RfDE3z6zBElBQjakzivS7ac/pUPRV4M1xjmCx0CoR
	tVXn3crdeE3/KCFE6tY9m1tSj8EPH1BIbWM3xxWQlgxlhuORgc7XQxJtzhhCSg8KjZ2p1Z/RVhI
	AzjXGGnBID3q0DXNihv/j1vQ5cp7iHwAzpG1B5FlcftusQetq4eme4k9TLrg84h/M2Gv2izElw8
	U2Lx4JUqO/jxrO0zJY/l8Nzkxeh/tFsq9I4dwWjBIk822jh3Cg==
X-Google-Smtp-Source: AGHT+IFUW7Sj5DnDBz0m2mE4m06hCXx/jNmpeaFyC4mZb7VXuNrz7JikmQNTMMQPD0NynUUAG2o9/A==
X-Received: by 2002:a05:6602:489a:b0:85d:a235:e91b with SMTP id ca18e2360f4ac-85e2cc9f759mr480379839f.13.1742585499696;
        Fri, 21 Mar 2025 12:31:39 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbdeac82sm571268173.71.2025.03.21.12.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 12:31:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCHSET RFC v2 0/5] Cancel and wait for all requests on exit
Date: Fri, 21 Mar 2025 13:24:54 -0600
Message-ID: <20250321193134.738973-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Currently, when a ring is being shut down, some cancelations may happen
out-of-line. This means that an application cannot rely on the ring
exit meaning that any IO has fully completed, or someone else waiting
on an application (which has a ring with pending IO) being terminated
will mean that all requests are done. This has also manifested itself
as various testing sometimes finding a mount point busy after a test
has exited, because it may take a brief period of time for things to
quiesce and be fully done.

This patchset makes the task wait on the cancelations, if any, when
the io_uring file fd is being put. That has the effect of ensuring that
pending IO has fully completed, and files closed, before the ring exit
returns.

I did post a previous version of this - fundamentally this one is the
same, with the main difference being that rather than invent our own
type of references for the ring, a basic atomic_long_t is used.
io_uring batches the reference gets and puts on the ring, so this should
not be noticeable. The only potential outlier is setting up a ring
without DEFER_TASKRUN, where running task_work will result in an atomic
dec and inc per ring in running the task_work. We can probably do
something about that, but I don't consider it pressing.

The switch away from percpu reference counts is done mostly because
exiting those references will cost us an RCU grace period. That will
noticeably slow down the ring tear down.

The changes can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-exit-cancel.2

 fs/file_table.c                |  2 +-
 include/linux/io_uring_types.h |  4 +-
 include/linux/sched.h          |  2 +-
 io_uring/io_uring.c            | 79 +++++++++++++++++++++++-----------
 io_uring/io_uring.h            |  3 +-
 io_uring/msg_ring.c            |  4 +-
 io_uring/refs.h                | 43 ++++++++++++++++++
 io_uring/register.c            |  2 +-
 io_uring/rw.c                  |  2 +-
 io_uring/sqpoll.c              |  2 +-
 io_uring/zcrx.c                |  4 +-
 kernel/fork.c                  |  2 +-
 12 files changed, 111 insertions(+), 38 deletions(-)

-- 
Jens Axboe


