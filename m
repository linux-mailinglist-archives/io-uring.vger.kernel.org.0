Return-Path: <io-uring+bounces-11925-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uF0aKhmud2ngkAEAu9opvQ
	(envelope-from <io-uring+bounces-11925-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 19:10:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22E028BEA9
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 19:10:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F28EA301BA5D
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 18:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FEDC33556B;
	Mon, 26 Jan 2026 18:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rwLbKVQt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5A62E54D3
	for <io-uring@vger.kernel.org>; Mon, 26 Jan 2026 18:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769451031; cv=none; b=syQ0RCiNc7jRtwuzQZn38wx96pshLrS2yRPZe/xYwos0RGk+8bTfmpkWylD+KaHQaME81eXSFZ1X0u6SkeFQY1YwrC4yGRAsM0WDOC4+SJIDoX79GvRApbOh6ihZtMYd8Vqiu2M3cyuNdw+0YNgeHcQ6EbesmQvJ9tUJsAkv+2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769451031; c=relaxed/simple;
	bh=0SxFXtbc2cJMBREY56rNlXfkldCobsSUvwkSMvylKzI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=e+7BZMLxOb6ZghRaUmN3k1NOxlfGDSrjQn6nw+H7gSUf0mJtxF0+bmxA7zcPJbVI8p8Lox/NqRhGHlhjmBMZC5VlXmuKEONazhOStQQ4ebnv4yhhbyvNIYHiftwiRulzAsxHi+y+obnT8NShdgDNpNQQBVBvmEuMj292ynZsMeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rwLbKVQt; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-40418578e28so1319223fac.1
        for <io-uring@vger.kernel.org>; Mon, 26 Jan 2026 10:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769451028; x=1770055828; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xHQ6qWUUe1Bt4EfLHpRA430LPS3qukaE1FFL7juxFb4=;
        b=rwLbKVQteior/xgzQjl3q+ukFCO7yytWeILDZlM3dOSh6CXOQsvz4bp/QcyMA2NBth
         8Pk2dvZCjI5jKkr2HlW3nB3cFUuFrVoPbdeXiDo5Ho+uC5HqqVvWM8kAHMUN3i/b/NOo
         nQH5r4NOptDUn5FFTKhCQ62kP3xpRy5gDBzlUo9Pft4c0r0YbTR6y1/A4CqZ2FM3OLO1
         Z7GC2Wigiydf2djvoS9+IviM44flhGpcUDFh0fFwColyxFzXgGkcU5AkjI1Od6aOtXoD
         h9syJZMrSHppfGMeRJpwNfT44ChmOo4fZhy6+zXDb1/AnUWvNvqgSeXxy4PJCqIUmIvq
         U2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769451028; x=1770055828;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xHQ6qWUUe1Bt4EfLHpRA430LPS3qukaE1FFL7juxFb4=;
        b=rXFOg8tcLrP65/FxtVs0nhPPySONz5SxGIWiB6L1OqIJxtTY5VLIoHWey0tg426yiM
         OLE6dq3Wqox/u3gjbcQETjRjo3rzZSrbifvO3R81hqj2W2yV84P2iLyIJsH5D3A8lgyh
         XemQSUyS72Y1BqXJ9+yMlvcQG005OqzJi5iUO8VesViNaNW/6RwKzhfzJe1EZ+pYoEj9
         peT6aYE9vh76dZbOoheKnxu5LEQSKPTrpd1HkP+Enq8wLaf5w8cfwQ797DVm6ZBUVy5e
         pvDS6Z64Iy+eEAMuKtqdY2LfNePqGWgOfVXtVBlu84Fixgc80vHtxnHOAa3pCqmTh2L0
         29yg==
X-Gm-Message-State: AOJu0YzpBlnHgoGK///vf9H72yx1d99idz5kGRQnQHByH1hYtc/jQODf
	x1jUSINxDLfTUUd5IwPitm9gz7hQm92LB9oBCbkDBo2usAkL8GxEF3/zDJaQOW5zFsHGOMRilXA
	67gk98aw=
X-Gm-Gg: AZuq6aLOYGue/NuW/HQ8K5ShH8YV1S0hAylOVAchYZvl6rOxi6FXgjrVltAJH+YcEdF
	dL38NgrGGH23WfqiZdvzESJr5q5OVs2rdPtFdfaY61ZonolNIbEV7wxH/ERNwoX4bm7fRzpXedh
	mt+azx+RcNU8DyVt5JrNJr6hFDwXZ1z9bgqwVDtK/mHATrQfW3LCKllRIsRpy3HvSAoxGQFw3ho
	fO6cn0y77HzybqTyynkFUX8PFGSjEgi4hkGNLpywtJm2P/RaD5tPRzO/rUB/XohPgigRN1D4RYP
	UITQYjcluxquEruMnCc2DqZxMyNth9Bi59bYD5Mhy17dmOcxjfxDZ7jYN0ITKqjFbyDPd/jODnh
	PjznHuIOiLatjQsxGbm3CTclhSNU6lcpsVd42+xTSqMFw1jNrn4Pi2hQvxrsRVyQKFlZ35u3n44
	Gd/lbdAWW+I6lK14M1STzC6mlwoHnIbDpPooaa4wpM4Gm+emaNW+SEjFU7n8wcKS+1RNXTc9lRk
	TQuM+rz
X-Received: by 2002:a05:6871:510:b0:404:2fe7:e184 with SMTP id 586e51a60fabf-408f81e34d6mr2127074fac.43.1769451027552;
        Mon, 26 Jan 2026 10:10:27 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-408afc5686asm7577691fac.22.2026.01.26.10.10.26
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jan 2026 10:10:27 -0800 (PST)
Message-ID: <02873e59-b01f-4dd2-9e37-d65989c7c49c@kernel.dk>
Date: Mon, 26 Jan 2026 11:10:26 -0700
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
Subject: [PATCH] io_uring/net: ensure io_send() recycles buffers for -EAGAIN
 retry
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11925-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 22E028BEA9
X-Rspamd-Action: no action

If io_send() is using bundles or ring provided buffers in general, then
it must call io_kbuf_recycle() for the -EAGAIN case that ends up punting
to polling. If not, a later send could potentially pick a later buffer
and complete before the previous buffer, if space has freed up in the
socket and it races with poll retry of the previous send.

Link: https://github.com/axboe/liburing/discussions/1528
Cc: stable@vger.kernel.org
Fixes: a05d1f625c7a ("io_uring/net: support bundles for send")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 519ea055b761..b1c3b86539ee 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -673,8 +673,10 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	kmsg->msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &kmsg->msg);
 	if (ret < min_ret) {
-		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK)) {
+			io_kbuf_recycle(req, sel.buf_list, issue_flags);
 			return -EAGAIN;
+		}
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->len -= ret;

-- 
Jens Axboe


