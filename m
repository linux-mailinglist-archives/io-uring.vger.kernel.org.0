Return-Path: <io-uring+bounces-755-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B068680EB
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:25:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E40A1F2BC56
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB2012F5A1;
	Mon, 26 Feb 2024 19:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0r6TklFD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007431292FF
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975508; cv=none; b=Xa/HPYoStXPWzPQKKHTo8DePC8UqraYhaeqkzSlLmZyZCc2lWnwsOAK1HAHSAI1w1m4g4izLF+5eRvEc8OcQvJ+T8P+HZGtpIch5aAkgLIYhpyjJHKcX+4PfYmV1vA1FERUHtplMZY79TjKvVXTkbDlOghlxOuHcCffGGuem2js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975508; c=relaxed/simple;
	bh=owbQ0kKpsjE5FoO8F8vo9L2+Ru8sez6qulsIO9Poi4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FBjtA43LH6wbNx3fcpnp1R2ZNwLXB1cGDGqpZHUbXKgGKNGFus9tePtn8Cw8iZcFRry4GOzoPdlbt5PjSjdnjH6nxRao4G7zV3aWurWz78hmuKR+QohAhNcgDR4E1+ctonXNn1f4BXAXLc9VvK79KplAJhdqGKrvOsO24Mgyxn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0r6TklFD; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7c45829f3b6so27404139f.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708975504; x=1709580304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YIFMICFlcLzsaq4wX8zSMApjisYbrGYlA1x/if/yun0=;
        b=0r6TklFD+T+aDPgRQ7I+DGT7i19Yk5xGaUa+X8g+nhB5uVwyMxjQ6jMwIddjp8p4QQ
         VIY1faPGhP8Ah/DiqKuCbGBwxhBtpSGBq0m72bpf87UKSbbMcSISgXlEK+PzJF/PLTV2
         YUg1PVhtPS2HqyceQH7kJdzFZjkd/lIom6xRs9D5vTMwbFAT1O6MP5DunWvZcll5CVY9
         RQBrCR/twjHNE62r1EXiNDBJ8L3FYfNBzHP67xQNxIcc19ke5iAfvtG0wpfCL7HD2Ncu
         eWM77i0jRPRENwqbkl0g2AZBWurh2/UeqUcpJWZFXai/v85rkEHIVZQmCvOeK0Rlx2Li
         g6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708975504; x=1709580304;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YIFMICFlcLzsaq4wX8zSMApjisYbrGYlA1x/if/yun0=;
        b=fXIPy4vsf1GQ+PKxz5UqdgOyb6o9gBDT/Zx6hR3Mn0nfjs+o7Ka1cSc/R61gn2VoDy
         pBfTQ8AcsbdNBjdxQ/dgcuOblD1rS4ZC9+PHM94MVfCPHEds4p1wzwXhM7Oq4cjlGahY
         PUW0suy1l1GPOzHlygdAxg8u/in+YC+CxEljQWJZlum6QtShq0R3HVSQPKZsoK99L9F3
         TlVgMi9bLBe/14iaYUIvAxMwVBO60yQRn+MpFkOBf7Wnoj1kYz5cntvObyA4UpFkhOwF
         7aKbsTN5NWpquoWk/pFvEtpaQGikaFvS+mp9pe//R4y/mRMg1Q4V8HP8lQej87jeNEfx
         tQKQ==
X-Gm-Message-State: AOJu0YxnmdNO6H7gPNIf6TmVbnSZLNi/zZwdaMqL/hBkT0qfcNPmsSrS
	WvqOYmlY3w0nSJLruB7a0NCeOszEyetTAzkOdB0uczvwgaHoMYzZBuprF2iaEoRWV3Xfrl1mxLR
	a
X-Google-Smtp-Source: AGHT+IGjPSdq1mRTssUdCpZrLqESbk6vUFp4tvGI8J+zmIIVM93Wl5h/vfDJzGEcEcH0Co7rdGZ9kA==
X-Received: by 2002:a6b:7a4a:0:b0:7c7:9c4b:90e6 with SMTP id k10-20020a6b7a4a000000b007c79c4b90e6mr6995365iop.1.1708975504680;
        Mon, 26 Feb 2024 11:25:04 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0047466fd3b1dsm1370484jab.22.2024.02.26.11.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 11:25:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com
Subject: [PATCHSET v4 0/9] Support for provided buffers for send
Date: Mon, 26 Feb 2024 12:21:12 -0700
Message-ID: <20240226192458.396832-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

We never supported provided buffers for sends, because it didn't seem
to make a lot of sense. But it actually does make a lot of sense! If
an app is receiving data, doing something with it, and then sending
either the same or another buffer out based on that, then if we use
provided buffers for sends we can guarantee that the sends are
serialized. This is because provided buffer rings are FIFO ordered,
as it's a ring buffer, and hence it doesn't really matter if you
have more than one send inflight.

This provides a nice efficiency win, but more importantly, it reduces
the complexity in the application as it no longer needs to track a
potential backlog of sends. The app just sets up a send based buffer
ring, exactly like it does for incoming data. And that's it, no more
dealing with serialized sends.

In some testing with proxy [1], in basic shuffling of packets I see a
68% improvement with this over manually dealing with serializing sends.
That's a pretty big win on top of making the app simpler. Using
multishot further brings a nice improvement on top, about 10% extra on
top.

You can also find the patches here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-send-queue

[1] https://git.kernel.dk/cgit/liburing/tree/examples/proxy.c

Changes since v3:

- Drop MSG_MORE patch, separate thing anyway. Moved the flags hunk into
  the respective send/sendmsg patches, where they actually belonged.
- Rename IORING_FEAT_SEND_BUFS to IORING_FEAT_SEND_BUF_SELECT
- Enable MSG_WAITALL for send multishot. If set, then we retry via
  poll, if not set, we terminate the multishot sequence. This also
  fixes send multishot with short send in general.
- Add other networking related patch for recv/recvmsg multishot,
  managing IORING_CQE_F_MORE better rather than always needing to hit
  -ENOBUFS to terminate.

-- 
Jens Axboe


