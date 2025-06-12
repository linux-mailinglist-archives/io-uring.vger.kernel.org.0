Return-Path: <io-uring+bounces-8311-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 598E9AD6BB3
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 11:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 284761BC263F
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 09:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E923224B07;
	Thu, 12 Jun 2025 09:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZrjH5LOp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8468223DD6;
	Thu, 12 Jun 2025 09:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749719311; cv=none; b=Vjyr/5EhRfqdWQF46kvmyL7Zhucjl2jOh7FSBzB4UgfnU/Fq2hhWAj0K3scACfJyhkj22T5uXkeiCa/ywQ+Lhu+RliEeZcKwTB3WQVbOLbWpQ+bolt2JxS7xhwWBBnGc1MBpMQ4W5mGkRfeRQnruy8eeohHeRZ8qmP/JVFaHctw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749719311; c=relaxed/simple;
	bh=nUg4x3VhS8mwzIaMjlJ6X9l/oWdRUMx5pW9GOTqsKYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m9crxOoUQlvzDmGHhD6OM62qcjCaTgRC5fZPjizDWfMRkeJd/WGCQxcDJkwZQYL9MNfri+4jTJBJGs9TBAg/9BZWo+9Pwt3gIS5CRhMN0lXM3vl3JYbzeMEqi2MCaPv7b0vUgAA/FcWLAz5+P7SV3uU8hmGk84ZIcaFNBO/iFLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZrjH5LOp; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-acb5ec407b1so129951566b.1;
        Thu, 12 Jun 2025 02:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749719308; x=1750324108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6AOqmqG3jDxDfEKM4QcvzKxDh3972gmQvHJ+8xDglYE=;
        b=ZrjH5LOpCsCEzpffMs8S6wa7aHXsKkK/ZJSsb61MVWpLuV7vqwGt/APmrNozlQfoSi
         OkCUyG7JTzI3gEpsyB4wvWWJOgp886i1tH6hj2apWCI0JDyX2wbv6LnGp8bXHJrfGOLq
         rYUY/MSbzB/4LeYm8iLvkVq9oMWL51Oc7dIG835Vp8OtF3dg6woLcz0Je9Sz2c6cKjTX
         x4p20e6Aetv3jmvBC1s5Y238xghK/GjYjKTrsl4CleqvyIEMreNNYGms3BaGx6fBrTkG
         RXqlCfcPwz7yDEMDy1YZkpO5mD+z/IgBkjyL2I1+it3bFq2Oaq+tDJkKPrkgExvYCKX1
         +Wsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749719308; x=1750324108;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6AOqmqG3jDxDfEKM4QcvzKxDh3972gmQvHJ+8xDglYE=;
        b=d5eRoTbHlSuJ9r2eA0+U1cRioP3IKDweKTLz15OxlG3jrwTmB3bQzR4It0id08Vimt
         1m/pYEfituQfZnOS3grekDmfj3rwkteeai0cf9SW47d58HjxKuCf9YUhPpTwaug6mvH3
         H0ZN6WEcFLFuytI18eaKuplg9vshKgtqLqgxZynjTdfyEEUtO08RfHiKI1IPCu0i3emW
         C8ciy9qy7lFi8pWuiImAjCRE6oNOuE+zhbGYCwbmOiEdLimgh07X8Oe8JmP92JAFm0cm
         xH+rpNF01cA+kn8KVXDm6Ckhg4GKn2Oi049Cy1iVF+s9mF7OMhmxvuVg6QGbvenZ5sQr
         QQdA==
X-Forwarded-Encrypted: i=1; AJvYcCVm7vRTcIrhMfeWpMQpF+BKjKBoxDV4lm3FvbTBGJsON9zDhxbt1b+qu9Hc88dxuxChhbAHcJI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLOqbLml1/AalggbMiP9okKU6mrlOBOwAgEyjVgEVxQ+OjZBTz
	1xBYTSovzTpMZvrHqbY2mPSUHSAZd0zL7Aj5gajfGDPdnCJf3PZfb83t+sG70A==
X-Gm-Gg: ASbGncvKjihQ47qVnvIurB2oNk1OFebttki1UtAMy+YSHJbyGUsqVl9HOy1lS4a1BHK
	3xgMoID8GUjUOCaFSadbrdwkOLrudxSYdkc2OYot0t/TuxYSBRVtZqY/vIjY+zOSepzGt4oVsH3
	N5lg5BDwMNiVL2PlyUpqxMZFVXphSVXMzeXsJwwc8hikXgXymV1LJOYB+5ytS3DftwRwt9p7hkm
	6ZfnzF0tUBMsdh2OzGaWb4FEtmHKmIj/iHKSF8wQuSSRrPMFSAVdcODAclxy3GtTO2mRNm9yHlE
	FxRFKPsp5bdwh1bPJPrMJX1qkcASdtYvqwM4fZxMWKR1
X-Google-Smtp-Source: AGHT+IHIcOw+IwJh+SD46X8YykK7JzAyzNKqhR3g4KounWJIL0QO9rlCE5GMvgXKio8AuWJUZ7UbQw==
X-Received: by 2002:a17:906:c146:b0:ad5:a121:6ebc with SMTP id a640c23a62f3a-adea19e48b4mr286642966b.0.1749719307432;
        Thu, 12 Jun 2025 02:08:27 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:be2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adeaded7592sm96883166b.155.2025.06.12.02.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 02:08:26 -0700 (PDT)
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
Subject: [PATCH v3 0/5] io_uring cmd for tx timestamps
Date: Thu, 12 Jun 2025 10:09:38 +0100
Message-ID: <cover.1749657325.git.asml.silence@gmail.com>
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
 include/uapi/linux/io_uring.h |  9 ++++
 io_uring/cmd_net.c            | 82 +++++++++++++++++++++++++++++++++++
 io_uring/io_uring.c           | 40 +++++++++++++++++
 io_uring/io_uring.h           |  1 +
 io_uring/poll.c               | 44 +++++++++++--------
 io_uring/poll.h               |  1 +
 io_uring/uring_cmd.c          | 34 +++++++++++++++
 io_uring/uring_cmd.h          |  7 +++
 net/socket.c                  | 45 +++++++++++++++++++
 10 files changed, 255 insertions(+), 17 deletions(-)

-- 
2.49.0


