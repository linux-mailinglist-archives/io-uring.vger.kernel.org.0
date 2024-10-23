Return-Path: <io-uring+bounces-3931-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 320989ABB9D
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 04:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 613271C218A5
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 02:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC7D45038;
	Wed, 23 Oct 2024 02:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C5fgmekM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4E48825
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 02:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729651065; cv=none; b=KNlptkk+gQ2wp7H+ub6nOpDdLhx0F8BEtjr54UMlm4wbdHyStqCMeJOT/4KTHYw8PmqH4N/aIy71egdn3lqzuO9Wexrw2h8bYF5hchQtJsQT4WbUALBkjKdonVgdzKIzvXhocumgbxws7x9Op+0iRu46xtywykXV74b2mBWz05c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729651065; c=relaxed/simple;
	bh=eEZwh0UmEmz7xPBLM1FkrNKp10hmTKaJFJ+oPBjRxfk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=clGDXzyDFEeAs5oxM6kWbXIvfMvdv3o5RYhH013c9vKGQIAH/KSFaFnHHwtzPWb4GxXzeEeZBq0H+TZFJgU3BUG0PI9RL5C4dHcj84IhVBU8eyABdvSuLElT+lzxu4EYH7LXZ9mZe1zipPPFRWjaHINrK+5WIq1oKuT3akm5n3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C5fgmekM; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5cb72918bddso3143060a12.3
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 19:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729651062; x=1730255862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H3ZyGAgy5DqURxudZ9Kk/N7YfHc0c5+nakT1BGCUqQ0=;
        b=C5fgmekMg6D8axBzGfqYREGwZrZJwI5dxuZFbCTrENUpKTOkMzfCxVc2DS+F5M4crb
         MUFO5q8LFWwynZWQMjBCfPBk9wFcpD080utZZ4NcfXsij2pckJNlfVL28CgrtPEieeab
         /LfnydR0cB7jONiihj4Od/jOfBoyRIk1lgW/zV36CpCRYiglRrS7RksbSCdCLCsUVmNR
         3WyLiG39trWlgPvB6P7vStP9a8kVbcjbn2BA0E5bhLwJ4Zig1GLate/EOFeKKtjuC1jl
         naZ3bLCUZHKDgvxBqtCbT0nouPtPyqG5AxOdKMluOAxuK5xKLzHUaI3Q34TbCvt+c5ad
         mBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729651062; x=1730255862;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H3ZyGAgy5DqURxudZ9Kk/N7YfHc0c5+nakT1BGCUqQ0=;
        b=MO4gacr7hR9TOwv1W1o1Rmn/Wplhk6jHvW/L0Kl/DUdRE0ilMrkcwXdXkMl7dSZQvQ
         fFzmFtAQO3055BEf+Aj19/VyEszPMs7IV20FESYoBi8bMtUWPkm6M+npr0UAv5V1GbyP
         K6+Pb0iRcaC5D7sjMyGK1+J84Y3dw+HZhb2GWaoPlNaVOm22Q7w79aEM6BE3rYuvBRX+
         rEQ1Ei+VHqnDAQkuSKCmeLBfVtayeevMoxUD1nJJpj+gOTLlBQjJwNN76dUUkfBdBZg7
         geba3W44Byuh+/wExgTxrANLZC7uj1VKN4AWMJDe2j3A5RYDZmXvdwv2K9o+mreCwKow
         Vq3A==
X-Gm-Message-State: AOJu0YxiErAJdsfAqyBduI1onE3mEBlwYwG5Z+xH2+Je8fmilCUB5ZT0
	6lAUj0O74e2WpFnOvt/q+KP2cOKy6GCnDew8z4RTOI9WZ9h29ldFVid6RA==
X-Google-Smtp-Source: AGHT+IHbM5z8l+e8gSinFehYy/RclUytA8Vk8c09iVpNAXml+XOg3zGFwC2NtjDcTVLGmFSem75tlg==
X-Received: by 2002:a17:906:f5a2:b0:a9a:10c9:f4b8 with SMTP id a640c23a62f3a-a9abf9b59edmr95747766b.61.1729651061799;
        Tue, 22 Oct 2024 19:37:41 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91371046sm410418766b.139.2024.10.22.19.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 19:37:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 0/4] implement vectored registered buffers for sendzc
Date: Wed, 23 Oct 2024 03:38:17 +0100
Message-ID: <cover.1729650350.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow registered buffers to be used with zerocopy sendmsg, where the
passed iovec becomes a scatter list into the registered buffer
specified by sqe->buf_index. See patches 3 and 4 for more details.

To get performance out of it, it'll need a bit more work on top for
optimising allocations and cleaning up send setups. We can also
implement it for non zerocopy variants and reads/writes in the future.

Tested by enabling it in test/send-zerocopy.c, which checks payloads,
and exercises lots of corner cases, especially around send sizes,
offsets and non aligned registered buffers.

Pavel Begunkov (4):
  io_uring/net: introduce io_kmsg_set_iovec
  io_uring/net: allow mixed bvec/iovec caching
  io_uring: vectored registered buffer import
  io_uring/net: sendzc with vectored fixed buffers

 io_uring/net.c  | 132 +++++++++++++++++++++++++++++++++---------------
 io_uring/net.h  |   4 +-
 io_uring/rsrc.c |  60 ++++++++++++++++++++++
 io_uring/rsrc.h |   3 ++
 4 files changed, 156 insertions(+), 43 deletions(-)

-- 
2.46.0


