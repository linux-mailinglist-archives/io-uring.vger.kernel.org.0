Return-Path: <io-uring+bounces-2092-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 39D368FB3E4
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 15:36:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82923B21275
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 13:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC93146A8C;
	Tue,  4 Jun 2024 13:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="M+odHtK8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388E41E49B
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 13:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717508164; cv=none; b=WzhNFKldF/dSSbFqP8G5Zq5+fL94Uke8pGPgkPc53C3/hzJxc5GSS+8X1BJMRFFyQULuJRdZqsJGiUzgZLrFcIzulHljbSwYTZr7hmg9eh3srzxTaNRSEpcVTE//TZz0FJKymKK3X/2SN7wBd5TmMQz1RBh777yEwNtMwtKAtjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717508164; c=relaxed/simple;
	bh=PHqdzPe+YVlVlc2fd9sWnYMMRuPmbX7M0MfTXs/Vgpc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=MnnMnB+C+TAQnqHUhVdFiwoFyv9boDeswmc044wjQACyiB3s5vHzFzZDhPo5AnrFrAfE6GLZVbEoNpKDGvVS5K3oTAd5QmN/y1OazNIAozQsv4WSUUFGC2qxGgSZCOC/V9YzMgAX+zq7o6cM1znenffmOf1PiVbpjwd0rxZhsCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=M+odHtK8; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-6c87835b8c5so227351a12.1
        for <io-uring@vger.kernel.org>; Tue, 04 Jun 2024 06:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717508158; x=1718112958; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uZOYE8CGFBHTDkkR6ogbVemC9XgbOZqWrTG+qqsRwB8=;
        b=M+odHtK8NK8So2W//u+Cg+hQaPO61tIGCROPyL2xHN1sYCabiZ/QcFtxn+sziunVMu
         jiUlDswZZocUrOKtWuptljW6j6R7cbOBGd8aTcsYlTwB6oWBvt3G0KcwZt10efHDDM9P
         wZGV+eRI8VJ6Db4H3cJEu76lKQwrkLT94X65J1EYrCZKPim3tLU+xbxtpC/Fi4bZJDsH
         0uQePEFQSpjJmZnY5XUChnKqr0zOwya3Cn4CaeuwftW5sQm5Wtqy/pbN0BiuJRAKufeu
         NkRa04B8OdP0fzfqFJ2TN6NjZi8+fMFgR8qmBadglPc1rrVEV03PXVdVcSG5W+/me1RK
         xAlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717508158; x=1718112958;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uZOYE8CGFBHTDkkR6ogbVemC9XgbOZqWrTG+qqsRwB8=;
        b=iAePHRMtZjVtweRUqdvtFyLmqmz0OI6UUeF3gIgpKl4K+oDOVaVDXPdqU+pHH2JoWp
         x6++SQhJxsNaIEr5t5hs/OBC+xkKAOyZjW8sHRBf02rQtrVyPS/1MioWDu+V+n/Od1sg
         D8A7cLZ1nS5DUDWj/54m+pa+pk02reSjlq6ZEEDPh1xcIFUbiwdE3e7oN1xDK1THuCCt
         OGVR5AQCkeKQASr+iBwXdGDPn0YX8//rrkPpHAtEPhgr1Lij1CuNnjsjtydB+1AiQIEV
         B+PHB6VfwMF8EGtBMNuL/DneFSOjBDvPTk5pduyb3Ff2inxWKDUHN5D9hzhwzSy8R8gL
         7ZnA==
X-Gm-Message-State: AOJu0YzBn1BDtmeii+DzxmlZHuX0fo4p66RZ6lm9XqEsMdgzt0AdV7Vm
	HtgKtgjyNrvahm/EjEefarqsAH7eamHOI6DqR1JfN1MUwAudPi6AI8ciSFwBL6r6Fwm1QGhCleT
	8
X-Google-Smtp-Source: AGHT+IEk/C7Fmmx6MTPItjNWGuim9QbBFSE8JIOQNxjMtGCX3G1pbtCNttlzLRBDL2XPsHDYoIS4rw==
X-Received: by 2002:a05:6a20:3d85:b0:1af:cc80:57b6 with SMTP id adf61e73a8af0-1b26f2871a1mr13751808637.3.1717508157790;
        Tue, 04 Jun 2024 06:35:57 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702423cce7asm7029317b3a.40.2024.06.04.06.35.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 06:35:57 -0700 (PDT)
Message-ID: <b606e824-7bb0-4aae-989c-3e7f11ec5953@kernel.dk>
Date: Tue, 4 Jun 2024 07:35:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Lewis Baker <lewissbaker@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/napi: fix timeout calculation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Not quite sure what __io_napi_adjust_timeout() was attemping to do, it's
adjusting both the NAPI timeout and the general overall timeout, and
calculating a value that is never used. The overall timeout is a super
set of the NAPI timeout, and doesn't need adjusting. The only thing we
really need to care about is that the NAPI timeout doesn't exceed the
overall timeout. If a user asked for a timeout of eg 5 usec and NAPI
timeout is 10 usec, then we should not spin for 10 usec.

While in there, sanitize the time checking a bit. If we have a negative
value in the passed in timeout, discard it. Round up the value as well,
so we don't end up with a NAPI timeout for the majority of the wait,
with only a tiny sleep value at the end.

Hence the only case we need to care about is if the NAPI timeout is
larger than the overall timeout. If it is, cap the NAPI timeout at what
the overall timeout is.

Cc: stable@vger.kernel.org
Fixes: 8d0c12a80cde ("io-uring: add napi busy poll support")
Reported-by: Lewis Baker <lewissbaker@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2:
	- Handle negative timeout while in there
	- Round up to avoid potentially tiny worthless sleep at the end
	- Fix asm-generic division complaint

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 883a1a665907..8c18ede595c4 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -261,12 +261,14 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 }
 
 /*
- * __io_napi_adjust_timeout() - Add napi id to the busy poll list
+ * __io_napi_adjust_timeout() - adjust busy loop timeout
  * @ctx: pointer to io-uring context structure
  * @iowq: pointer to io wait queue
  * @ts: pointer to timespec or NULL
  *
  * Adjust the busy loop timeout according to timespec and busy poll timeout.
+ * If the specified NAPI timeout is bigger than the wait timeout, then adjust
+ * the NAPI timeout accordingly.
  */
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
 			      struct timespec64 *ts)
@@ -274,16 +276,16 @@ void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iow
 	unsigned int poll_to = READ_ONCE(ctx->napi_busy_poll_to);
 
 	if (ts) {
-		struct timespec64 poll_to_ts = ns_to_timespec64(1000 * (s64)poll_to);
-
-		if (timespec64_compare(ts, &poll_to_ts) > 0) {
-			*ts = timespec64_sub(*ts, poll_to_ts);
-		} else {
-			u64 to = timespec64_to_ns(ts);
-
-			do_div(to, 1000);
-			ts->tv_sec = 0;
-			ts->tv_nsec = 0;
+		struct timespec64 poll_to_ts;
+
+		poll_to_ts = ns_to_timespec64(1000 * (s64)poll_to);
+		if (timespec64_compare(ts, &poll_to_ts) < 0) {
+			s64 poll_to_ns = timespec64_to_ns(ts);
+			if (poll_to_ns > 0) {
+				u64 val = poll_to_ns + 999;
+				do_div(val, (s64) 1000);
+				poll_to = val;
+			}
 		}
 	}
 
-- 
Jens Axboe


