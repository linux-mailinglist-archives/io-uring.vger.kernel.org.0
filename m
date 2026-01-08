Return-Path: <io-uring+bounces-11532-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2AAD06163
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 21:31:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E69C53034361
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 20:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5539C32ED29;
	Thu,  8 Jan 2026 20:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cFYhx78x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8633522A4F6
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 20:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904192; cv=none; b=iQyDJF95uRY/m+jo34xXzQVkSWjfzqYfT1QN9L8hUEuxHRO/gCsxqS2+00seRYATwIHXKO0qi/CzzWNN5+xv1FbXndmJbpy5+X9XpMdjemcoTBtbhCWj1W3jtpGd4Yl5d+pv4wqocZ26ezvrkVABZ7PnGwCYC/AxCk5nnGVL4+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904192; c=relaxed/simple;
	bh=UdY5kZdR7sWgLwWisYd7woGFnQnj3KEwGQQJBGYkBWs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qCaAAZH4qi3lZ5qRy9rTiaDs/3O5CFvDBihPzXhO/vHsgCeIHY+PFtPm8Ct6GtR6dcrt4w4yXRtfDJtHdzp0R9jFBSscb090kzobX09/Y++tuuAPx4SyMc2cQMkKtimwfAL9wZDXMk+bjMzdy/7JJDxMdcR/FIrwj0cjwk4JSaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cFYhx78x; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7c95936e43cso1414794a34.0
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 12:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767904188; x=1768508988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=4j6WPbOIXMCwjPP8FjdOSYXy1fndWzkaYL762wEtoJo=;
        b=cFYhx78xZFG2YDQAln6SkhIjitNlqVB7g0nbn4PDuX0HbX0+kgNuhJxBnGQGT8fxrL
         8oQa9I3sEF252ljh11X4JJRzqAuQaPz3AL565lG6kXPFy+gptSJQ4K+9lQvHtsaEFLd3
         oTH+4/w4r+AiX3PilSBx8UlLy30CfVqWqOAgRaHRzIDkaZnZmMBgZXiJkn1MzaBI27kY
         Jhb0TXtiFw8lcrmJBpeq5sx5zTCfx2GhHPXJNwtEzduGQSM1RhSpyM6yKuTEZ92sIULY
         OIFovzygG9d6tA9orUIA7VcCJsEtslU/9cA31/kwRb2D9AHJ31N0woikq7OVHWY+XPbY
         t0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904188; x=1768508988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4j6WPbOIXMCwjPP8FjdOSYXy1fndWzkaYL762wEtoJo=;
        b=qt278CAqlSJV8Sci1xfqeTAerJGJMxcZR+WTQ4D6DUtYkHyTydOtaPDnGcnxH6r//x
         GLNsW9vnqP7pAb60EaIEj6oAcrtgpRNTTewVNSU1icxg0lJxXgtJpmHK659z2hZC6kpL
         nhC/zbWKsxh/OhLdg5szR2yLgOfot8u0vMO5Ltl8GudXAWk304pfybxoPPthI/PBQGj7
         Zh2yOXXLUfdYeMB2r0dOLw4Pvl3SBMeXkO/xx+Rkqfw8wwqBTIxW/nM4TEbieqApYBGb
         MHHLUp1sab4NPQlkWp6IrR16liYs+I849NWmkDwuqgAY0vEgw6+p65kqHB+piNZpTGCT
         eIkw==
X-Gm-Message-State: AOJu0Yx49fKBdQedMlEQkhZCxb4aMA/b70988TfhH6SGn7u8vHBMJTO/
	8jgtqWK5K+CjRFcjhzqp4rPkB1hLJpc4wD+q7tuu2Vp56Y+hvl3MwipmH1WfhXYApa6103dDryp
	ffrzv
X-Gm-Gg: AY/fxX5ZARrxqiYdKm9oEyTKrGPPo9FKF+KasJouu2iBioPEjuBxPgbPDQOZqAM9OCS
	o0mmig76LDZjsBq4ngFupkc5uR5K5DkbCfjaXWF5R5wX6cycyK6xziLJ1yPrLA6wyMdROOfSb0P
	w0on67dVWlGt0dfCTzz7YaoJBPMNejGEJT+H6+wsC8Eek/z/fTdwDaCOCDMNWXdNL9tjn2tqtVY
	W2VI3muO/qw+CHp+hj3ZDH82OGF6raMv9IRLBUYsx2pIKql/cKuE+lF6EMVOw2b386VI4f8iPWP
	DzY5MIKHBYeag0OD0DHa+nWDBWMiVyCtfsNcBYgHT+iL+XnDCGVzKNW3G2Mrx6paXNUULPbWeeq
	cIIKvdKNr2p29tBsYXExHLXrfIbD3nros7ZhevSQdfufwgkZVEBEVVrSWMTthbyC6mzY5uU4=
X-Google-Smtp-Source: AGHT+IEUjz5GhF4OSxzaVlaTpY7JozzDC0ONfsaV1wKG8nPSUMVfKXfO3lp/BT551xsV849ykk5ydw==
X-Received: by 2002:a05:6830:304e:b0:7ca:c7bb:e0a5 with SMTP id 46e09a7af769-7ce50acf495mr2709706a34.35.1767904187710;
        Thu, 08 Jan 2026 12:29:47 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478ee883sm6225020a34.28.2026.01.08.12.29.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 12:29:46 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/2] Per-task io_uring opcode restrictions
Date: Thu,  8 Jan 2026 13:17:23 -0700
Message-ID: <20260108202944.288490-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

One common complaint is that io_uring doesn't work with seccomp. Which
is true, as seccomp is entirely designed around a classic sync syscall -
if you can filter what you need based on a syscall number and the
arguments, then it's fine. But for anything else, it doesn't really
work. This means that solutions that rely on syscall filtering, eg
docker, there's really not much you can do with seccomp outside of
entirely disabling io_uring. That's not ideal.

As I do think that's a gap we have that needs closing, here's an RFC
attempt at that. Suggestions more than welcome! I want to arrive at
something that works for the various use cases.

io_uring already has a filtering mechanism for opcodes, however it needs
to be done after a ring has been created. The ring is created in a
disabled state, and then restrictions are applied, and finally the ring
is enabled so it can get used. This is cumbersome and doesn't
necessarily fit everybody's needs.

This patch adds support for extending that same list of disallowed
opcodes and register to something that can be applied to the task as a
whole. Once applied, any ring created under that task will have these
restrictions applied. Patch 1 adds the basic support for this, and patch
2 adds support for having the restrictions applied at fork or thread
create time too, so any task or thread created under the current task
will get the same restrictions.

A few test cases can be found in liburing, in the task-restrictions
branch:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git/log/?h=task-restrictions

 include/linux/io_uring.h       |  2 +-
 include/linux/io_uring_types.h |  2 ++
 include/linux/sched.h          |  1 +
 include/uapi/linux/io_uring.h  | 16 ++++++++++++++
 io_uring/io_uring.c            | 10 +++++++++
 io_uring/register.c            | 39 ++++++++++++++++++++++++++++++++++
 io_uring/tctx.c                | 23 ++++++++++++--------
 kernel/fork.c                  |  6 ++++++
 8 files changed, 89 insertions(+), 10 deletions(-)

-- 
Jens Axboe


