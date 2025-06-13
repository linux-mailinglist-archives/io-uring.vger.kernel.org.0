Return-Path: <io-uring+bounces-8334-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7D79AD9471
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 20:31:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B8BE1777B4
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 18:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B23D20F09B;
	Fri, 13 Jun 2025 18:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O2usELBq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0FA2E11B0;
	Fri, 13 Jun 2025 18:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749839483; cv=none; b=LVUVsLBNU/X7wlmJGFgIfC2hpTbCEojnOnq5pRYtrz0zDdGDPbwi2jlJljWwvlPnCMjvab7jLuxe00NB+yj6M6B5DebFUK3x/+g3fBD1LV5ko4UFRG9geVtjexQ+M6Nl9tGIKKfbwQkfctQqJROGPbzrEVpprwwKMMGuw6J7BD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749839483; c=relaxed/simple;
	bh=sLS/07tjVr8LSWaRR+p/V5hXn6Bn7BL8rX1uC5VzVf8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JZW7hPwmoJjIzYr0zpxZOUeRvWXVJAnDP2vOyKw3xSM7CECUnqLNkTUGCLu2hy8eTaSbnSBdaDAvR2AMGApyJo7RcQ283HECD21cJrsw1AfStqKy93cVWZxElUi9v/ydbRRi7VorZTK3kJH+rKomyy/sScXc+ppoq+j6jxuCcCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O2usELBq; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-adb2e9fd208so471496866b.3;
        Fri, 13 Jun 2025 11:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749839479; x=1750444279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4MTH8N7oWCaysYAZFEeLV6dsdnv2JrgRBNJz7MrYnh8=;
        b=O2usELBq31U18bJXJkQZ8s+uoqWCcHcqSGEvLq54CGX2AgjqMA9g/rR9QLD6mLzkcf
         2Z1isOqGwEK1ZqWJ398uOA9bGBpimc1xhxR3a0GetRl/evYTH6Wxa8qhs45nsIwwW6lH
         tAn59PEJBAuHTmPloApB8SeAWbx61CUXZZJtONPQrEkc/2dulKMa0SeDzJLj8JitN37A
         D0S3mQ/hw5atlCfcv0q6YpjIhxdnyt2TC3Wa89iIGB2g1LL/qA3xs4rIsjDbgNMGpLil
         QZFuhFakPLRogKOCUvf7m7PYLfGbd6QJJ3HTUywoccAyVwgzqnNuLkVegaI8eVlmJaV7
         C8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749839479; x=1750444279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4MTH8N7oWCaysYAZFEeLV6dsdnv2JrgRBNJz7MrYnh8=;
        b=QHhvzrH+EoOVStXZy+kgFSXRlhk1hI5HaRUvfAPrvQVPla9rnR2QvGzT0jsKyYRDAr
         d0RGvUOH+6QGY+KDtL2Udlmussvvg8p0UrYsH8q6ZrFXYp/9pbuDbNK5BhKg+g6VG3MT
         4Sx7duA9VbERHKc22PBwQuNm8spqtnkSQTtcynq1+cKEm3S+wjifJzP1hEvqh5o7noKv
         ZeYxep06NZ/zbPguE6rKz5DzPXGahVct94yXa6w8aKzv8iI2yDccWUMft0+Mxo6tJ/C3
         EGFZ5UbU8yUk1TI2s0Fh8/TrN2wgzsDg6T8VLLdvjVgytwRoECw/hkplzw4J6MD1DQf2
         6PJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWY86E4syTUOar/6VoQXYgorXa3EXaWusImznlv/K+Gm/D7x91t4jDn9AMSZBrBH2vBselmiJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCcpPU440KCPXJ6pbOk+PQyOfIY0aiKWksYyMW7mYOrMWlCzBL
	rtqTDRNW2OiLPRlfzQigmkQZn4k2+ZyvXU1VhY9bZdu2i7XhaU7s5QQWcZhOaA==
X-Gm-Gg: ASbGncuq1zabkSZ5x4VIWx+typ8+/8K+caiA/wk/z/Z9xN7tFKgDYQOsMcvg1aZS8tE
	r60e1txfHS2O45+GIDOuaNKnqkLtI7T2Q4EZlgYJDoluMIN8YQVnu437SA1xYJxs5pUqZOTeBXw
	jl/Lje9Wk+bhhRard4jARQTOip9sRVnpVQ7hqd5SgKzji+lentJsS1qHgt8pzJAtx/6larLWs3G
	nUXCfy94kzAvpl1F9mOS5PCmpXct7JIRh2di0AzG25kgcmmLojuUqLMxiV/saooD216Ku/19QUK
	wyjNoIwZwSMFgu56oXa3aj5L9FyL0mXrwr2WNDojvqDRNt5jYpK/bH8mttVVP7rcZ7Pn5fJFMQ=
	=
X-Google-Smtp-Source: AGHT+IHuIW9Vxhudml+mJdzxiSKPrRBL2MsmUXmV26CbqNfpPz0F3OjMIYN/WscEEam+LBVzoO9KmQ==
X-Received: by 2002:a17:907:6d0a:b0:ad8:8945:8378 with SMTP id a640c23a62f3a-adfad3c5204mr25291466b.19.1749839479169;
        Fri, 13 Jun 2025 11:31:19 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adf688970a1sm54772466b.175.2025.06.13.11.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 11:31:18 -0700 (PDT)
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
	Richard Cochran <richardcochran@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jason Xing <kerneljasonxing@gmail.com>
Subject: [PATCH v4 0/5] io_uring cmd for tx timestamps
Date: Fri, 13 Jun 2025 19:32:22 +0100
Message-ID: <cover.1749839083.git.asml.silence@gmail.com>
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

v4: rename uapi flags, etc.

v3: Add a flag to distinguish sw vs hw timestamp. skb_get_tx_timestamp()
    from Patch 1 now returns the indication of that, and in Patch 5
    it's converted into a io_uring CQE bit flag.

v2: remove (rx) false timestamp handling
    fix skipping already queued events on request submission
    constantize socket in a helper

Pavel Begunkov (5):
  net: timestamp: add helper returning skb's tx tstamp
  io_uring/poll: introduce io_arm_apoll()
  io_uring/cmd: allow multishot polled commands
  io_uring: add mshot helper for posting CQE32
  io_uring/netcmd: add tx timestamping cmd support

 include/net/sock.h            |  9 ++++
 include/uapi/linux/io_uring.h | 16 +++++++
 io_uring/cmd_net.c            | 82 +++++++++++++++++++++++++++++++++++
 io_uring/io_uring.c           | 40 +++++++++++++++++
 io_uring/io_uring.h           |  1 +
 io_uring/poll.c               | 44 +++++++++++--------
 io_uring/poll.h               |  1 +
 io_uring/uring_cmd.c          | 34 +++++++++++++++
 io_uring/uring_cmd.h          |  7 +++
 net/socket.c                  | 46 ++++++++++++++++++++
 10 files changed, 263 insertions(+), 17 deletions(-)

-- 
2.49.0


