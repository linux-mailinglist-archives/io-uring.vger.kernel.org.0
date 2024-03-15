Return-Path: <io-uring+bounces-993-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C888B87D6CC
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:48:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66F061F22602
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 22:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351FA58AC5;
	Fri, 15 Mar 2024 22:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IFjcEtpE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F062D54BF7
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 22:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710542926; cv=none; b=fwCreZC4B4jcq2A9FFQzpD6EhofImrsX01kdtdzwG6bKfEywGHyLL9Vl1XfQSdLsZvO4RNIOlB/PgelDwCXSAfvmP7PPwxLhu0iA9rfASwnVxwKbaEyeZotLf9J+gF2vb1sdlPvSvIUW1mAnOg7iV6jEWSBa2rvpxLvje9WB85s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710542926; c=relaxed/simple;
	bh=qW9isM5TYM5/EVNS+AqNO557a9CjlOhrdAQ2HPF6Au8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=B4+rxMEtFIxtpG3qnTl6842+LL8t4OoWoJMLJhtz1YPqdOh0WycCw7PknIa9xF1R9dE6IedW14PnpekluA/OT1K3VuiwT83j7kfH3gTcQ7xZVmlXTig3olEYGqpXpp2t79rBv8uqgsG2oRWk5BLgmXJBvF4TcyY9bCN6hKiE9U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IFjcEtpE; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so735196b3a.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 15:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710542921; x=1711147721; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z7fIi5BpADLKttv9k+ssnoLxkuXnrXmgaqCmmpwJbtM=;
        b=IFjcEtpE58FD96ZrE0DKiadQGLoKYX/+g7K0G4evo0PjGG+UpyrG6unyNm291y0zn4
         0Zx4s84mz33FQx5SkOT5BZxA85/viw5tILMHUaeRlo+JZltbx3ut4yxNwtZ4PxyRDIVW
         N7d9pi3J2gphypn75TlHAEKsEzSPO1PVd2XYzrEJqI3Ud9d69sssWiX+8YqUWbNTTG9D
         rfd3cv7yqJTTNwFcXq4Yu1E2lXG7kQNv7ON2Ok+YDMGwedBPTMdsWiJTJb41Yh2DW7gE
         5f8rpODBMNU9E3Nx7+PGL+HTOqVOc9OnKe14qLIbDJ4r3sS89LHa9eBbeX79/f6YCxw9
         PKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710542921; x=1711147721;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z7fIi5BpADLKttv9k+ssnoLxkuXnrXmgaqCmmpwJbtM=;
        b=gVjj26YKP9djBbejoc44gyCH0JvHQXICrDLNFth5I0vV9sEtieNysuvHJXfD7ksxaT
         3uJN/Nlh7sHMX3wDSoMGIpQTOFR7QVbUy3JfyvnNBvxcD3ABDcRDRTPwI/ZzXNy8PmHB
         4uYsFw1Ml4t5gKbTx/AnfOfxzTdO9cVwoDm/QPfVEXXrXa9umiPPklsJbJmUNGQHOqRM
         pbYjTwPmu/S5HzriHi5tgPlQOkavu+5/XK9PZHH5oTXQDZBH8NiquzdozzFnzJWe6+1c
         LlgLjrDz24xLO8HbhApbHFeuC0mWOIgNAEnhs6mqGau0jCEi6kSZAa/v+2zPahIn/uHd
         v9UQ==
X-Gm-Message-State: AOJu0YxmJuFJxaVKT0edE0C3aAT8LwCjm8NPkl0b3QGjdrIr1ZvAZoNJ
	9SFrE+DFy7rB+mQsaqVDvYvhI63VADFS+UeuxV9uFladG1RCHmMojDnrpPe+O918cvgb/flO29Q
	1
X-Google-Smtp-Source: AGHT+IFa02EURZ7EbcpMm7norgM91HXtTdhRosxsl1ywcSmvSypby+0eQkipRZWhvL7kl4Z0cVT8Jg==
X-Received: by 2002:a17:902:ea0a:b0:1d9:607d:8a26 with SMTP id s10-20020a170902ea0a00b001d9607d8a26mr6580722plg.6.1710542921388;
        Fri, 15 Mar 2024 15:48:41 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v3-20020a170902d08300b001dcad9cbf8bsm4415969plv.239.2024.03.15.15.48.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 15:48:40 -0700 (PDT)
Message-ID: <472ec1d4-f928-4a52-8a93-7ccc1af4f362@kernel.dk>
Date: Fri, 15 Mar 2024 16:48:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/net: ensure async prep handlers always initialize
 ->done_io
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If we get a request with IOSQE_ASYNC set, then we first run the prep
async handlers. But if we then fail setting it up and want to post
a CQE with -EINVAL, we use ->done_io. This was previously guarded with
REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
potential errors, but we need to cover the async setup too.

Fixes: 9817ad85899f ("io_uring/net: remove dependency on REQ_F_PARTIAL_IO for sr->done_io")
Reported-by: syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

V2: missed a refresh, and hence v1 had io_send_prep_async() overwriting
    sr->done_io if we had already set it up.

diff --git a/io_uring/net.c b/io_uring/net.c
index 19451f0dbf81..1e7665ff6ef7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -326,7 +326,10 @@ int io_send_prep_async(struct io_kiocb *req)
 	struct io_async_msghdr *io;
 	int ret;
 
-	if (!zc->addr || req_has_async_data(req))
+	if (req_has_async_data(req))
+		return 0;
+	zc->done_io = 0;
+	if (!zc->addr)
 		return 0;
 	io = io_msg_alloc_async_prep(req);
 	if (!io)
@@ -353,8 +356,10 @@ static int io_setup_async_addr(struct io_kiocb *req,
 
 int io_sendmsg_prep_async(struct io_kiocb *req)
 {
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	int ret;
 
+	sr->done_io = 0;
 	if (!io_msg_alloc_async_prep(req))
 		return -ENOMEM;
 	ret = io_sendmsg_copy_hdr(req, req->async_data);
@@ -608,9 +613,11 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 
 int io_recvmsg_prep_async(struct io_kiocb *req)
 {
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *iomsg;
 	int ret;
 
+	sr->done_io = 0;
 	if (!io_msg_alloc_async_prep(req))
 		return -ENOMEM;
 	iomsg = req->async_data;
-- 
Jens Axboe


