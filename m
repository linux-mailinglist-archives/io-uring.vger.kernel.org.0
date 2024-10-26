Return-Path: <io-uring+bounces-4048-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6414C9B1B46
	for <lists+io-uring@lfdr.de>; Sun, 27 Oct 2024 00:24:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 921ADB212BA
	for <lists+io-uring@lfdr.de>; Sat, 26 Oct 2024 22:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009ED146013;
	Sat, 26 Oct 2024 22:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HWhPn512"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EC910E5
	for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 22:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729981438; cv=none; b=u+ADffidDbYzWM8z6rHpvOuuXMR0wLFeb9kntNuviux2+aTPHerJBYQzNWGCSzqXEN3ZxQG8Y13XZrTM0g3VSFC8qoO5V8OgfXhIsvZy4cCr4vmobvIVQ44ARnG/Khkmmy02yWu8DorqFWwXjN+nBlMWcqnPPAeWTz8cz2QAdQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729981438; c=relaxed/simple;
	bh=cGKMaxbG0kvlIb65Dyk03L9g3qGS3hgOjG+pPqe7m7s=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rzInVgZ/Sua6W6giiOxn+iZl/JGWb4ecSn1djywrG32iAs2xJ8O9xgmE6e/aWzsUEw5i04QrQXEYCJn40VGpl/Tx58Ae6OIVXYA5T+frCx+Rl1Q+z2aHyyJcbK0JZv53jDBtR6iU82n48iM/jbrbSb/h66xRkv3Vpvd9nGsFeQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HWhPn512; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20b5affde14so22183405ad.3
        for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 15:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729981433; x=1730586233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=NpB1uuJkquyBvZ3iwrB2XzHbzMN+TTux+pFFCieAszo=;
        b=HWhPn512MSlmx5O8P+P+5TRK/8EzXGZQVw4Zk9R23PqMWa2YGR66GixnnGmGHPtlPT
         GTPddVhZSgHP8KCcjPzPR3CxgAavW2KobIlHE7zF4FYLXeqvqzrtY1HT0uaaNTJuwygX
         uVwi8BaOwJopJIHajflrqlTmzn6SmYyEstTc/UxQxRAzsy15/MuK+fSTAAqLAphkOdJS
         dsFOwiJKYfpSycqnAYa8765S1XR54SPHxxE3MBhylJ8sGu7PcvZl1nj/LK/LsP+8V5+6
         A/JO3Q1gRPnIwd8RNp/biYjZxNrXJIcTItGnpJu4qxBD4B/BPsoY7RUFbxOgUKTOOerH
         fdUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729981433; x=1730586233;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NpB1uuJkquyBvZ3iwrB2XzHbzMN+TTux+pFFCieAszo=;
        b=UrFLgHSF6ZJCifSNMPEA0y0xvAYLmyFQN6s+Bob0ttSTCy+59jOiW/vDqZateLxF+o
         Si+YLu90e3sVc/rqSWXFcDbHJ8Z4POlHTfTRDGG27TWBxWx997tYKeNyDjxPzzPq628E
         SNa2IcrzoAo6VVcqDGS1TwxspANhwmxf3vvQdHibVS50sZMzaafwogilEVp5KCEPnoMD
         YNRlN108ysib+BNSvERLqoe7xB6zlgjDS8YBGunmngcxBE6XCnbfxkVOKoAhXExtBGpF
         FKncnCnpZwiPjaOJGrEq+lBpFnBf+wRK3NiFrRjbjOxjB2zP52vInzpt28j9dtNkb+NR
         WrTQ==
X-Gm-Message-State: AOJu0YymiHrmzpoArNUtK159hPN4ylonOmOjc4CeOv+588bBh5xaB3tV
	NfVaRbZ5dukIzRHHFqtL5bVhEpexwf8lNv3+dsFbba3pQu/L5+Hkg3bviFOLZ9BDlYe+M8vSpZq
	1
X-Google-Smtp-Source: AGHT+IF1mLVdbdE7NKofY9HLHm5psML2CmTSvPTVH3qXae9bYt7gMoeLpDFnGj4rw8cLcMP3SovS5Q==
X-Received: by 2002:a17:902:e80b:b0:20b:5b16:b16b with SMTP id d9443c01a7336-210c6b08be4mr48831515ad.36.1729981433284;
        Sat, 26 Oct 2024 15:23:53 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf44321sm28134705ad.30.2024.10.26.15.23.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 15:23:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/7] Rewrite rsrc node handling
Date: Sat, 26 Oct 2024 16:08:25 -0600
Message-ID: <20241026222348.90331-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Caveat - this series is very much an RFC. Not because I don't think the
idea is sound (and the way it should be done), but because the series
itself is not very clean. It should be split a bit more. So just look
at the final result, not as much the individual patches just yet.

For a full explanation of the goal of the series, see patch #3. tldr
is that our currently rsrc node handling can block freeing of resources
for an indeterminite amount of time, which is very unfortunate for
potentially long lived request. For example, networked workloads and
using fixed files, where a previously long lived socket has the full
resource tables of the entire ring pinned. That can lead to files being
held open for a very long time.

This series handles the resource nodes separately, so a request pins
just the resources it needs, and only for the duration of that request.
In doing so, it also unifies how these resources are tracked. As it
stands, the current kernel duplicates state across user_bufs and
buf_data, and ditto for the file_table and file_data. Not only is some
of it duplicated (like the node arrays), it also needs to alloc and
copy the tags that are potentially associated with the resource. With
the unification, state is only in one spot for each type of resource,
and tags are handled at registration time rather than needing to be
retained for the duration of the resource. As with cleaning up of
structures, it also shrinks io_ring_ctx by 64b (should be more, it
adds holes too in spots), and the actual resource node goes from
needing 48b and 16b of put info, to 40b.

Lightly tested - it passes the liburing test suite, and doesn't leak
any memory. And it removes a net of about 250 lines of code, as can
be seen from the diffstat below. In my opinion it's also easier to
follow.

Can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-rsrc

 include/linux/io_uring_types.h |  25 +-
 io_uring/cancel.c              |   4 +-
 io_uring/fdinfo.c              |  10 +-
 io_uring/filetable.c           |  71 ++--
 io_uring/filetable.h           |  26 +-
 io_uring/io_uring.c            |  51 +--
 io_uring/msg_ring.c            |   4 +-
 io_uring/net.c                 |  15 +-
 io_uring/notif.c               |   3 +-
 io_uring/opdef.c               |   2 +
 io_uring/register.c            |   3 +-
 io_uring/rsrc.c                | 586 +++++++++++----------------------
 io_uring/rsrc.h                |  97 +++---
 io_uring/rw.c                  |  12 +-
 io_uring/splice.c              |  42 ++-
 io_uring/splice.h              |   1 +
 io_uring/uring_cmd.c           |  16 +-
 17 files changed, 366 insertions(+), 602 deletions(-)

-- 
Jens Axboe


