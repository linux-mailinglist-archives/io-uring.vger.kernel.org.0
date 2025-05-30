Return-Path: <io-uring+bounces-8134-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A57AC8D6B
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:17:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E51AA3B4001
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 12:17:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03BE521D3D3;
	Fri, 30 May 2025 12:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EAzOuNG/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2E838DF9;
	Fri, 30 May 2025 12:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748607439; cv=none; b=p9FVcvSAe6bVh3GIHa1ldSbQbOPyOXyJtjg6jiZXC8cg3262qFg2YM8kzdhATddAubg+7duIgM0ngxJj6Ug37uBxAI9cXn4cs1gj/6XEPbKLHKMee2FN9x37KUnHKvoPPyrYop8iRuqAKEcNqwhuSWna02ENkHCn4UipMSEnoO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748607439; c=relaxed/simple;
	bh=Dl0or4c6Uc3Qr21hPBlAdyjFLBBjiTCbqz/trLFGue0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mu6OGJuipfBL5qe8h6G+ooWLoodzqI1yj8F+mHInrIa7CeifhoeLqkcTZbXh9E0/i/YcqWf3EdrAqyaevr3s5a5RjiXqNYFS8CTrXptWJ6MqObnir0P9PsK7PDbaRkZTaOroTq6q8w09xwUw0oAHIycr7t0lRccoUtnSIK/5ZIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EAzOuNG/; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ad69e4f2100so299671866b.2;
        Fri, 30 May 2025 05:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748607434; x=1749212234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=00AEb2KGuYMJCeS8MDt+GUEv6nAsvPAvD/wXq4V+AfY=;
        b=EAzOuNG//SUANJ03Sm8eE2F8dG7fSUV2WVwQrCoJ+uc/nAhL89G6lB+DSadGBWHsyG
         7iLfrwyIONbIyYVyAk5BasZ+yIAw9/SZ6X29UPVWbQcJJYd9XC00NO/HFNKLawsk2tTj
         4krwMmg6BTW/lFdH17+auQfkqmh64XXNmduRMi6uauI8ORUh2f1k8KwFPE/L5ylF52d4
         wCpi5K5bRc3Nj/kGN60f9ILBZh9BG9xor1xU+xZnqHMGmCDI1Pm/BgWYrvPNhiHuzUC8
         aQ/g2zJhO3PVAk5JK2ZCc0xmMpdbTUsM0BkZhDE5x98tVn1i9mUn5oiIUeuKDnYaRrVx
         rxQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748607434; x=1749212234;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=00AEb2KGuYMJCeS8MDt+GUEv6nAsvPAvD/wXq4V+AfY=;
        b=OEcB8uvKEZNQsDyWoPICyrOOnb9yZX0jvp/3sOfN5hdCr+hS0UXKSLElVDtUC4UL0R
         xF0YSdhpEUFXvME+eu5KcMEg6mOmxuGjNr5R8RK9CD9XgwXNLzZjVcg/iZklF7WhqjH/
         i1bnScZHMK6SDvNwpS1q3PGbaJmKoXYdUhTdSAs3Ma7r2JxGKwchs8ovcgPxU9FLpTVF
         231CKxYJ/Mdzplmg6nOdpeQhlEYo/ers40ZxPQyIJVOSLuoiTKnKSgIPeSz7m5qHVCGX
         cY0uhNzJ7Q2FsOFvT6KbU+So8ndvpRZORyaXodIwgo5rejB21FbFn2nvDQ+zv72mGlbv
         /1Vw==
X-Forwarded-Encrypted: i=1; AJvYcCXJgTMkUCjAPyI+ZJERSaAPob3Tn5TT4wE/xYmEgO00Ux2ucCAayDW4FQV995g5oUY5Hj++27w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFkhE6x3PlbXMvwszTKjkFwZ+lXsdZSZfOecWI0EpxLj2qU5PR
	4Pcttrv9rglBfqHKPhTpAg1gh5S1Bqk9YRR375rcAUm6Iy6G28Iud1PQrst8aQ==
X-Gm-Gg: ASbGncswLvO/5a7RCiHFrHyOLTX3VYH4wpMH2nZDNX5B6gyKiZUSEyxAKCsCzaKJ7xx
	xz/qZ2OQvLrwbdYpL5MoLxY/DigbchTXHwvbjyGBsBT3is4EqKwUq0C08V32PLqo/9QJHKQDjJa
	nslaGw8N+Q/lNhvu/ZcA6iw6V+KbjQLcqWGc+2hJQ2Z0vpcauicnytbmZ9vQn3czhm+XShCZq2d
	nK5mr8deuXxiNSoPUGdRwKGWGG/9bwpmJjqbU/upIKr0hY/BVXtdmICl+beVvE0GBdbOeNrwJx7
	kfaJr4PC9bMfIHFBXmv6RCoC+2F6zwkg9VY=
X-Google-Smtp-Source: AGHT+IGmvUgZU38AqfgxvmUConGqJIqYwbVNECpMz9O2ddRpTlNYS0WVxMM+6GOEUb0d+2sVW/a3bw==
X-Received: by 2002:a17:907:db03:b0:ad2:28be:9a16 with SMTP id a640c23a62f3a-adb36c117ffmr178979666b.51.1748607433613;
        Fri, 30 May 2025 05:17:13 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5d82ccedsm318566966b.48.2025.05.30.05.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:17:12 -0700 (PDT)
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
Subject: [PATCH io_uring-next 0/5] io_uring cmd for tx timestamps
Date: Fri, 30 May 2025 13:18:18 +0100
Message-ID: <cover.1748607147.git.asml.silence@gmail.com>
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
 io_uring/poll.c               | 43 +++++++++++--------
 io_uring/poll.h               |  1 +
 io_uring/uring_cmd.c          | 34 ++++++++++++++++
 io_uring/uring_cmd.h          |  7 ++++
 net/socket.c                  | 49 ++++++++++++++++++++++
 10 files changed, 245 insertions(+), 17 deletions(-)

-- 
2.49.0


