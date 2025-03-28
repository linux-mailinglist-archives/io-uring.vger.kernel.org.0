Return-Path: <io-uring+bounces-7287-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F35A752C7
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 00:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9ED0E1890137
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECC71DD9A8;
	Fri, 28 Mar 2025 23:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lqq0AjoN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001D11F180C
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 23:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743203423; cv=none; b=CdV5iC64K2KKbwiwdqLhI+yWd3SuN20QLF7nZ5rP/zRD6B3ODtpPuGqxfCU9GKFdpBwdpPNbENeLzEHYrm27r98QnOTybh8WCRGac6MUy5PKebCbelD4TqNx7Ci2X2j8WQKL+pf4mtLCiyYjMEU4YdL8n5M3kIuEVqJZA79waeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743203423; c=relaxed/simple;
	bh=5ibT3gDwk1YFJTkXb6IxQPEX43vVwD8l2PLVRzwHdhg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W29b7s5ON2/rXRvVCg+uqqbp1IrVz09btOZ2ZPbh5hPxYJgNlmgTgDS+oRramGYn4yXuaVaN5OOSSkBwHsgIFDziQYCVUAvHoHDRfBPP3XMcY7s8ZU3gPt+RlxCxZtdvUGxJwIptHczQe+rAR0EY4Ug6Gqyee5+izbblwYGQynQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lqq0AjoN; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ab771575040so733008766b.1
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743203420; x=1743808220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nghV1LzTRdpQ4Gi02SVk9QdLbZl6tXAF7E/lIiPTiyk=;
        b=lqq0AjoNiaiBVAoQ6oLyXKhmBYYWE3JUlVB6wGOT02Gn20GEMew9hYK8Npp8eJ4yTr
         JS8IcTWu9vUj83MHYf2BYGOwdxPiPH+4qTPUeJqqiblip9WCG5Spo1DRv/TAd2wtmwaC
         wHrfdHQhOUSh8rWquXv0KkFak6XqqHX3wMXW45FqitJnZH9bQChXqR4IoWXStwdcs0in
         GfxQu19B3XtfyAYb6WQzGAOVILMupb8zcbYhGCFBVFcoJRFsFuBfaxLvzgnPoABLHYdc
         //pVLnB1OF8X3NbkI2ptZiZpM/6C436Yd2t5d6OTMD0WFsp7SSDerp3pOUzod8kfwbiq
         tiBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743203420; x=1743808220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nghV1LzTRdpQ4Gi02SVk9QdLbZl6tXAF7E/lIiPTiyk=;
        b=LEUlgrwTqoGmuiEbd9HEzlWiJDIi0avQIRC4489hXDUKXqUB7Q4WHmGbi+1LUK276G
         AQrR8fPl9+Iai2W9zIsgVoILcsaYju6n0o2W9IVwzP1RUohGc6/mWzEixbthOM7cgQYf
         e5xKwAtySLeeb7jG9icVbhGG1gyawJVPq4EzDthiE98+OMXQOECH9cRB+pkVBF7puxJI
         HmJl05xVUEY5bJNSvZ0VaiGLjiw1fg7ooxUY0gspxmniZ6cS92tN8k9NKvF6aIP9FxxQ
         +ZLaeicg1pgQAAh/NYnT8B7Yqhn1gO4dlnV98JNtQlTg7ph2T29T2CFDIfLOMgbGfnnj
         df/A==
X-Gm-Message-State: AOJu0YzaKOApJQdwLlazx1kSnf+MBTDKzfSUBzZ2lijdjctmaosxxo7P
	EI12qa+PaES2pmRR44vSAPsg0n+pq9NEEtxtm/SqIYVAMCbfaIUxQF8mJg==
X-Gm-Gg: ASbGncs8OQBjQhSdRnYRDdR8ugUb14xgy2TgFEvoEzgnb+r2UdoPghD78aj83EMj3tE
	ZdwUTeg5AOc890yWQ9Iq6+ZeJ17d995Z+oVPjHqGmZxAVCbT+DetJ2al545n0Eww2xHb1kX3Blw
	1alz9X0qRFSsxa581CmVamzLGMjxK0PRYgfnl5Rr9qjxJxqalhK9MIeH5N8M52njniffUXV9gq6
	dwMKmrt8l+TmYpzDCqRyfpIy6BYTxKcJE2+oYJmESF/6dKGpXu7t851fahIc/EBKCGeRrOYoslw
	YcCdyt5tpAZop6cBS0SKDJT/j32SfUx494Zue4veWiMMw8ulfLAgWSvppwg=
X-Google-Smtp-Source: AGHT+IEgYdBQH091TYufL7MLXJhcwuB/A/r+8YcdWSX0l0fiDHudAlOrvYeBrFLaGFnND9WXkORYug==
X-Received: by 2002:a17:907:8689:b0:ac2:7ce7:cd2b with SMTP id a640c23a62f3a-ac736707a4emr157101866b.2.1743203419550;
        Fri, 28 Mar 2025 16:10:19 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71961f04dsm228915966b.91.2025.03.28.16.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:10:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/7] send request cleanups
Date: Fri, 28 Mar 2025 23:10:53 +0000
Message-ID: <cover.1743202294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first batch of assorted cleanups for send path, which grew out of
shape over time. It also prepare the code base for supporting registered
buffers with non-zc send requests, which will be useful with
leased/kernel buffers.

Pavel Begunkov (7):
  io_uring/net: open code io_sendmsg_copy_hdr()
  io_uring/net: open code io_net_vec_assign()
  io_uring/net: combine sendzc flags writes
  io_uring/net: unify sendmsg setup with zc
  io_uring/net: clusterise send vs msghdr branches
  io_uring/net: set sg_from_iter in advance
  io_uring/net: import zc ubuf earlier

 io_uring/net.c | 127 ++++++++++++++++---------------------------------
 1 file changed, 40 insertions(+), 87 deletions(-)

-- 
2.48.1


