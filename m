Return-Path: <io-uring+bounces-8355-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB73CADAC36
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 11:45:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBA651888E93
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 09:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9161F26D4ED;
	Mon, 16 Jun 2025 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qnr+ZeJ+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8CF8F4A;
	Mon, 16 Jun 2025 09:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750067127; cv=none; b=NDABcDXiNtESHoekxdGWE3Y4Tjws5Uo2VwB+s21wit8vA1M940IkdIlQ5ZPqGT//Wyyc16H7NHnDEmRGmkMsl6yqFr0gagzbO6sFKIjZ9uaUkbuibqTYl2tjqgwphrZ90R9MjPMEcB3XenWoIz1JVdREn4D//PHBq15pVbAMZhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750067127; c=relaxed/simple;
	bh=H36VfsH0DBSrLeuy2+/KVHX2GFG1FlPWsxjQLZF5ITg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CrvE60H9TloBJSOmJkEj5YG0cAFNPxH9mFh5sBUq1KAvmnVd/j7hw6QtyArW7oy4Km42LqJZ+2JFsGsHXVOsaf/+3/ftjVhWh36jOPy/gHEb2HvqWwPXQ45hzV42ml9syW3XB+Ebenn5wCetOYrKgWdfLcnQYdcxtC6EAE53Jz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qnr+ZeJ+; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-607b59b447bso7539738a12.1;
        Mon, 16 Jun 2025 02:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750067124; x=1750671924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PMH2ir2ZAgokVwPba10HlmVOqMqVEJdrpsV1uXEzQTA=;
        b=Qnr+ZeJ+++fRgJ/kH/fN795XXm1A0y8tflXywZNUw2Rttv2tjgTJrbPet/mZK1XKbY
         /G3PMIQvZYIObPohI7MExj/YfsEOMubhl5EPIO7UkhQuMGkC8stWAB7ABZYH0J9kttKK
         Kl5avfnCDI4jUfoZZ5sp9KTJYFz+/gCtVzByAX88OtntnAGE2Pd6GNwHdNIfPp51CZYB
         LDeyOSzbj2DEZSp1XbpE6WGY3H1+RfX4gX8v6ukqdBEJeZn0vhZnzRinwcTvY59IW75Q
         uETIhWSkEfjp28hJfBgiM3SZqx7DRbBIZWUademJds3Zi9M46t2urQKVSBjWvf1DLBnc
         oU9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750067124; x=1750671924;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PMH2ir2ZAgokVwPba10HlmVOqMqVEJdrpsV1uXEzQTA=;
        b=Sw5JMs66RlngFwAmx36NUpZyHIiDi8aYqQixxxmVDpRJrv7M5dVVgls7goQLOiq44v
         fTSEz6TVr2sVGboZs36OQ2EHODbuy0JNeOUsdvteDrHAQ9yseqtop+sdePB5id1tivif
         IxDuFYlOhEUKwNbFvprYUk3VXt5bhBjEg+jexmnQ0XarK+KgYjDsDoTQ+43YH5MOHCiA
         ZNJ5YL++Ebr8CXZYQ85PcdxHbJoQJThdanGx2dGzvDNQX5ej3xvHsN/svb0SAYOd6ctu
         OogVIe458fAfXTMUgg8z0KBgPq+SlKUF9gudYF7LJRwFMjXirzM+RBvXQEEYPyI4PzNx
         X2Ww==
X-Forwarded-Encrypted: i=1; AJvYcCWZO16icwJgcrIOJcBjEp5A/DcnPfNE+8imjnGEdntmiTlraZcQdI72wsNIdiPoCU31JyYs658=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsMwT3GnuLdaZMaLOXNHWjUgl26P5y3gSyuJdH3LScGvYlqpDc
	iZoN4i99XVLUsGSGupGq4JmpBBuYWyVo2EgLvKq9GwcPNXLSKVxBdPfC/kG7dQ==
X-Gm-Gg: ASbGnctZU8YBwezEeeySl4nkIYCKpIrAU4pZbpSKAt762QL0j8T245jzQZrgdMbY4Lr
	lw9fEp24HBCPFkz2EMTwwQwM81Ndj3l3FT7wYT5445vRUPh7TTpcDGNdJgDBqQZW+AImqjGDxJP
	XaSoexp1eMgHwbbdrxkh7fpdgtFfkyD5T81EtoukS6kcjhKwwl0kF/4VsRrM6lY+i9/3kfmY9Ua
	JFz5fTQ2b20U9ICD+jMdOoGojOr4FD2uTds5JiYNaq2CNX7soa0wuIQZgRO5GgFMOUPo5TIBn8J
	nVMF7pNwge/jlroPSrk9Af0deKRVtHzghvxqQ0d4x5AL1A==
X-Google-Smtp-Source: AGHT+IE9FhNwpcs7msRy9AJJJj06TALyd39vOEmQrT3p+qiYzf+v/OiP6MEzf67voYof0A4lFozZVw==
X-Received: by 2002:a17:906:c154:b0:ade:2e4b:50d1 with SMTP id a640c23a62f3a-adfad415a59mr840518166b.29.1750067123413;
        Mon, 16 Jun 2025 02:45:23 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a3c1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8159393sm629363266b.15.2025.06.16.02.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 02:45:22 -0700 (PDT)
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
Subject: [PATCH v5 0/5] io_uring cmd for tx timestamps
Date: Mon, 16 Jun 2025 10:46:24 +0100
Message-ID: <cover.1750065793.git.asml.silence@gmail.com>
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


v5: return SOF_TIMESTAMPING_TX_* from net helpers

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

 include/net/sock.h            |  4 ++
 include/uapi/linux/io_uring.h | 16 +++++++
 io_uring/cmd_net.c            | 82 +++++++++++++++++++++++++++++++++++
 io_uring/io_uring.c           | 40 +++++++++++++++++
 io_uring/io_uring.h           |  1 +
 io_uring/poll.c               | 44 +++++++++++--------
 io_uring/poll.h               |  1 +
 io_uring/uring_cmd.c          | 34 +++++++++++++++
 io_uring/uring_cmd.h          |  7 +++
 net/socket.c                  | 46 ++++++++++++++++++++
 10 files changed, 258 insertions(+), 17 deletions(-)

-- 
2.49.0


