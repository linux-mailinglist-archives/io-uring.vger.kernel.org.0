Return-Path: <io-uring+bounces-992-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5978187D6BA
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8ABC81C20B5D
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 22:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A121774E;
	Fri, 15 Mar 2024 22:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bz26fQy0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D1254745
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 22:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710542350; cv=none; b=Vp+ZlJglX7RMgjRPPvxAAfEJAPhW5SjSUrCg+jZZlo8mMoC6dC9ztYHgnqkdKnrvfarnhVlIkiRjnyfQPW25+GBB1Q7qT/Tiux87CtvxGkpkJ5g7LHSMp3BYMUHUke0dyMc8q8Ik6IMuptrV6N/FfdUhNmbQNaHr/Rk7dnecZPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710542350; c=relaxed/simple;
	bh=ryGNXDjVU/dY95tQdlvNL0n1UzWo4GFveCppEyTLTtY=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=px4M7FwlHCEhjBfv4S74hjA6V0Lnpx4U8MZemDBX53BUKpcVpLmYjqbW27giHQlZsPpMpKLCRLnK9uk1DyffUip4QYbG6/75LjLgguCrwA652qs9PRmzhr4JxelbHlrvrV9BiSKyCf0G79+2vWRzdXkNC+6oWuswviZppDkWiL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bz26fQy0; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so733337b3a.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 15:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710542345; x=1711147145; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7BgZ/DCgFe3xlGG3H2vCJBWBFd8+XvUG2CmWEoR/jbs=;
        b=Bz26fQy0LY1e8Iuejuu1uONjnhmot5kcyHGSkIUsUTjsy7qDGKFDigyE/92O/x1E0A
         oAfc6wqgHFbXppfrGR9zxbgLq4EVoNTOgBNAUytxMwDOwqAa7Xw7/qdRs3baBq31Ingv
         zWczohlODwXmiiX7X+X36myssuuERvJNu6uiBxmtvEd2kRmk0lWEjHpYx8jI+MG9woFG
         GLF2OvnP+TOu35T4LnvWe1/hdxcv1vhkHMMBELW0cT2dlQjLHYvYrgW4CJmFJzKz0fNV
         JLKib3jV5FtoySs5MjNe7Kp1v0sCO27j2sWh1cEOL8rgU3XonQuVuxnoMgvbd0PDsTS7
         cQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710542345; x=1711147145;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7BgZ/DCgFe3xlGG3H2vCJBWBFd8+XvUG2CmWEoR/jbs=;
        b=Dw1yP9bSPoRjT6SK0i0TOctVetdHbfZ46sOrJJbZqEfj7wlCtiUlJ7O1HnTeowDUns
         3XVx3C1Vs0EoJOroVNcuYVvtUgDDQwzkoIl07oVmxVcZTUuQ8XQd/WhGM1CTCF0PSNwz
         5imKV5TS59roTzrUQxoLf7EHoDeSPgS2fr/MBuxRBNEbZTKDzcbR9NO63I7aqD09nJRD
         3czcgGUjzxiTKJ8fwtSnPcdoL7oMdI2burgfU2kbCrPaQFckSP9O6V+mMpxJ4PAZzb9M
         vGZCB0Bmm958+au/041pZHjaRcJHG9/jSt3pI97MA4+AZQiZQ/kpkfFvXJCqxW0PzPDW
         s6dA==
X-Gm-Message-State: AOJu0YycLJplWH7/Y5bhQR2RG9EUTUF7EJBJ8gjeC3FXgivTuiwTIE2F
	uTEGY26Vfit7ryPXPCqwI9G71oy090nqZejyBw3cuDlH5yrTMsSGcY9CONhGvVLQofeX+nO33UF
	7
X-Google-Smtp-Source: AGHT+IHCJSYgQAlZXVUrOdaCQeCLugHnIs8dYjgn5rVmUd+MTI74S0rwYHc//qSycPI3ciGrHDPBwA==
X-Received: by 2002:a05:6a00:18a0:b0:6e6:508d:eae9 with SMTP id x32-20020a056a0018a000b006e6508deae9mr6960499pfh.0.1710542345282;
        Fri, 15 Mar 2024 15:39:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id n45-20020a056a000d6d00b006e6ff8ba817sm1208238pfv.16.2024.03.15.15.39.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 15:39:04 -0700 (PDT)
Message-ID: <95eec2d1-e1f2-4514-b4ed-d33a0c81a6ab@kernel.dk>
Date: Fri, 15 Mar 2024 16:39:04 -0600
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
Subject: [PATCH] io_uring/net: ensure async prep handlers always initialize
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

diff --git a/io_uring/net.c b/io_uring/net.c
index 19451f0dbf81..c5352c92fcc5 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -326,6 +326,7 @@ int io_send_prep_async(struct io_kiocb *req)
 	struct io_async_msghdr *io;
 	int ret;
 
+	zc->done_io = 0;
 	if (!zc->addr || req_has_async_data(req))
 		return 0;
 	io = io_msg_alloc_async_prep(req);
@@ -353,8 +354,10 @@ static int io_setup_async_addr(struct io_kiocb *req,
 
 int io_sendmsg_prep_async(struct io_kiocb *req)
 {
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	int ret;
 
+	sr->done_io = 0;
 	if (!io_msg_alloc_async_prep(req))
 		return -ENOMEM;
 	ret = io_sendmsg_copy_hdr(req, req->async_data);
@@ -608,9 +611,11 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 
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


