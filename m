Return-Path: <io-uring+bounces-8202-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55BCFACDA13
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 10:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4E9B1885559
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 08:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47FE328A1E3;
	Wed,  4 Jun 2025 08:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGDFANga"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8BE19C54B;
	Wed,  4 Jun 2025 08:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749026487; cv=none; b=upArWSRLoIShdaJHsyfeRh9eoR3uX9OY2eBIrUvXuVB3pMaQb4oaI1tmCLy4B0T7iIctfC5B2W6i6JRKrOXuUxJR04qqrWVIcN5uBjuzUJa1dDIUe9QuGgUyEK7Dpbs/gjXsBgsxRhiVRbJJKo1MTEWm9keKa73462udMrNMAmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749026487; c=relaxed/simple;
	bh=1tjm6/hCWvSGTFRv7A/oztqIEZm+f7szF9IYcFrpfNU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EdDTFZLceVLepRG7iACS2C4tKGm1ZwBg8Le8uKz9RshqxVB5HwaCqZamX7kVtxh6X7uLrMsjoExya3opYpHLxUY+j+4JlUP2NqPYeuxu2kUMxjcFCWogJj2xECkkMCWqCaciijCT7WAR7QnmxaukBXlKxR9JC8Slx8RcxpXIC3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dGDFANga; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-60462e180e2so2232130a12.2;
        Wed, 04 Jun 2025 01:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749026483; x=1749631283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JwkpfPTzkKIhHQoBSoF1MHPsKE9/9GxITXSpV0jc3z4=;
        b=dGDFANgaEAu1Ws8hp6FlbFz5lQ/51gehsvci7UyWCEgvr85ZipA3JW1PFA5MP0Cdhx
         867A06LCWv3ZWLbTgm9JVOVjqKzqUKOlKs5ff42eIHHlPKuwetM2IZzZsvp5l600ruCA
         8N+aJbYhArvwCFCIM1AAlUhJkUhPM5iXUT844ASvKUcxPUCCbsUmCziihIUcH+9v0W+J
         HwKumz55Wodwy9BKT/mE7DcxIus/nX3UvCiZ7KbdWZAQD2dlVhiAe3zNeYtS+GP3aau8
         X/xM5h+7tH3a0WJ5/8HIjFtmK7XEFNpUmpYTqbwP1wPpcTZfUKBdbRWqeOY/Hf2+UYX6
         tEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749026483; x=1749631283;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JwkpfPTzkKIhHQoBSoF1MHPsKE9/9GxITXSpV0jc3z4=;
        b=CkU9Xz9Gc8U4qjg5bWxW2sEJcZPjAmvoFxGyiQNqYQ9sdXtN6QqvaJMV6Mk8N2Wxt2
         owjKISZATczGshRoVCP3IFy9np2yPIUpplRfj9QgsEhPocytctmEEZa/rta6rl9pSum7
         gfiJua3YiZQgBWEqc9ju1MpcQkWp7oONd2N+tBKvlmaBMGaiVopf094L7fDm4vgxlGoI
         m1zDxbIJ5qRWIv1V1GappeVxyLKMo46Fy2ZRVD6Z1Vl+BvAqrtKMh7LlsbSxVz4RpR8Y
         8dQYXzHcOn/QtpDtDvAnyPQskzB6wMi4NVwKZthLP8HCCWtxLHSqa2KKn5/LU80FcfmS
         2ciw==
X-Forwarded-Encrypted: i=1; AJvYcCWGJ4ks19rTuZv++/izn6CF4SJZkNyRYKcelFW8Kdwp4deo9Kzwr5CZHshV6ACC+gSmjxgDsWk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqZMTNYYAg3BkTvYrUIAJoROvMiueIvCIFw2D2ZnTsjwz6NS4C
	itugA22LMj7/wt992lTnYEp3OWIrLYyVQIK+4DqQZIsYHLJZRrxbwlYYSnd2QQ==
X-Gm-Gg: ASbGncs5qmTddC11+pWWn+wyogYgFBdWmzZ5FTMvK5Kcaha2o4poV+73LK+J7dw4Mbs
	ENY7SRx9tZAWgkgShv0TbZFZ74LazDzrdMpxeKb6+w00bECgcRkc2NXFo49a/ZHhR0zaRV9tfVX
	w4xCG9q/XVgtDnkHhhcfR8U96zPy349Sz3LGyrZVL8bY1gjB7CuMOYS+27ba2xuZTpBriJjqrkA
	JafMWWp+9bvimNZg9YO1gAIL7Y9kkFX1VQQ56Tif4YE41L28kAjo+gHcV/tTQqjd7TVUSv7MKgp
	NmOb8t5fh4pQknw6v8Y21kH729T38TD2opg=
X-Google-Smtp-Source: AGHT+IFFabkO+0cK/5zUUd/du/zt8OPiN7ImeTq89nobBXf63UOy9Cgevvi8pna5kqhh5iHCCm+fIQ==
X-Received: by 2002:a05:6402:27d0:b0:604:df97:7c2 with SMTP id 4fb4d7f45d1cf-606e99a63c9mr1962889a12.2.1749026483259;
        Wed, 04 Jun 2025 01:41:23 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b3d1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-606f3ace23bsm544261a12.12.2025.06.04.01.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 01:41:22 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v2 0/5] io_uring cmd for tx timestamps
Date: Wed,  4 Jun 2025 09:42:26 +0100
Message-ID: <cover.1749026421.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Vadim Fedorenko suggested to add an alternative API for receiving
tx timestamps through io_uring. The series introduces io_uring socket
cmd for fetching tx timestamps, which is a polled multishot request,
i.e. internally polling the socket for POLLERR and posts timestamps
when they're arrives. For the API description see Patch 5.

It reuses existing timestamp infra and takes them from the socket's
error queue. For networking people the important parts are Patch 1,
and io_uring_cmd_timestamp() from Patch 5 walking the error queue.

It should be reasonable to take it through the io_uring tree once
we have consensus, but let me know if there are any concerns.

v2: remove (rx) false timestamp handling
    fix skipping already queued events on request submission
    constantize socket in a helper

Pavel Begunkov (5):
  net: timestamp: add helper returning skb's tx tstamp
  io_uring/poll: introduce io_arm_apoll()
  io_uring/cmd: allow multishot polled commands
  io_uring: add mshot helper for posting CQE32
  io_uring/netcmd: add tx timestamping cmd support

 include/net/sock.h            |  4 ++
 include/uapi/linux/io_uring.h |  6 +++
 io_uring/cmd_net.c            | 77 +++++++++++++++++++++++++++++++++++
 io_uring/io_uring.c           | 40 ++++++++++++++++++
 io_uring/io_uring.h           |  1 +
 io_uring/poll.c               | 44 ++++++++++++--------
 io_uring/poll.h               |  1 +
 io_uring/uring_cmd.c          | 34 ++++++++++++++++
 io_uring/uring_cmd.h          |  7 ++++
 net/socket.c                  | 43 +++++++++++++++++++
 10 files changed, 240 insertions(+), 17 deletions(-)

-- 
2.49.0


