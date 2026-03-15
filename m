Return-Path: <io-uring+bounces-12684-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yHa4F0DctmkQJwEAu9opvQ
	(envelope-from <io-uring+bounces-12684-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 17:20:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D022915FE
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 17:20:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C28D300EA9B
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 16:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731614207A;
	Sun, 15 Mar 2026 16:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XUPwiIx6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD6F1448E0
	for <io-uring@vger.kernel.org>; Sun, 15 Mar 2026 16:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773591605; cv=none; b=AFlWcIZslDOAQNEGON9Y+GKC3PKDWvG9WDbL0jpUIok5+1ON9bIp7c2nYUxbRiRicPEkVljMjeEzxeOJ9Fak/eeWHmf4crJa0Sh19gFYl2wqcMdvg1j/+Xn8kbVxWn1xF7xevLrQblJwp5MOZTX49BJ5hdjnDEUYin4/RrS7l0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773591605; c=relaxed/simple;
	bh=q3czYs28AsyU09bbiuFRlYcJifhTy5kLbrFwpXUm4vk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=H0fwwRH14rm5yQF+iafTkEomM4JDvE6wf7a+wgX/6/fK2Q0rzwShrccDkIbTdyMK/0qaMSsF0sAudLtblWf1wUhdsBQ9GETk83t9OcaQZreEV6IZ3OqWATlgkPLHA7Of13fJPm3+fvzcBpqL2F33mK2/GlO0JYC5NroxQLI45zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XUPwiIx6; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d74dbfe84cso2663059a34.1
        for <io-uring@vger.kernel.org>; Sun, 15 Mar 2026 09:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773591602; x=1774196402; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QCWBTC2SOz4ZQ2CsYoHe6YyS5V/ZdauXaPK0G3eeOuk=;
        b=XUPwiIx63bnlYumOrvQFqok8JneWGbpHzu8ZH5VrhYI5sW1oBdfI90yCD0K3wGhuSZ
         0gDGN2XLjr81JNhYhvZ+h1JPHqeLM78WYe3k9U7yIM5EWZuE0/rteYTFm7J1qrC+p6+Y
         XGjIhtPeyVy/hwPDSg0bKHu32JBXWxnkkNOX5VpoL4eVy9v1NkZ5c1V0xcRO/7Qez7+N
         GMSIrRmB7hZCXeavd+HlZ0kXSXn1V8c984Qjp2gO71rhd4M1coqdJJJwtGH5NG5woPaJ
         aecKwmbIzAoGWIO5ALTW5FyD4u3CgCBqS4kjVwFBWVZ7L+HLePeXXLC3uyJp+vbmZFJL
         7kOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773591602; x=1774196402;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QCWBTC2SOz4ZQ2CsYoHe6YyS5V/ZdauXaPK0G3eeOuk=;
        b=O11ylrOTPP6txeQ1xExS3kVGRNWzziybbMYs76i0SNbPhPX2C4eKj+ta5p0vJBR2Lb
         mOeYKBZhqbt8B4gVDs4Dzlula56EqK0eXQIb3cmwPTG6fr9cX8isA3RtKhVKx8VItRZS
         iYHSoCykAPVGQsOqGl5VtNz050+a9TQ8lmmFUbpsq5Yg1AFI1ZmmYlouEEPjaKn+08hh
         mY8PTzdSLbY1F/iQByPj+fS3MNGLfaw48EqMK62lCtNsJxSQAaGcFXGb/nQ72rbANXn8
         Ur1OnwTfehnHF/y1lce/Q3KM5OVjzDvT87WCzJOy0nMtGH8oayMI9X8+scccSZ30VQGY
         M7ug==
X-Gm-Message-State: AOJu0YyS/r+x7gzaH9FHUYLbWawv8FvE+ruyaZJ+b0XIDro3Cq6XbmZw
	Oq5H2+Bb1uqRYQTgzUnmaM9lSOvA9u/H5DCfZDcVpHeJjwbGQfnxIOlSWrVKgjPJeGMTEuoOGEm
	68J5x4KM=
X-Gm-Gg: ATEYQzxPtYqsoBY0rRWXCH1awCDbU2eMZPwA52D7sgWepboDSFk9R2YuShmZqXZASjQ
	YSrVBEHQt5pHEFL2M44UK5/cYNftTdKkrxU4zY80K5buQOu+ONAgtV8V7rdJP/qKgVIvQRhmsn7
	nBDJFNCfgwmF+zRVoNSIQ9YvQDUgiLZWnqDZBD4e07pJ7ralEWAzN+sRghHYfwX7Wwq5o+9FZ7v
	veu9h7dsgBckvr1f0sPzZWp2qW4FulsMVknetM2zKxpgZmJrt4cEDNBvkcwJN6eBAs0Ew2Ig+sz
	bfKiU6PB8h4flhW7u5o9NUbLaHEfyKhlc65TjZRALwPbhz+KRLhHxEXEU+L5fMOWJvZGNmU+TMg
	+TrV4Fx1g9gRTG2E84ozNJ5W3XXEUYeYeRpS6Vr42/o++7dYmsFpNbPOS9KGmWKefHXsj2GH6cr
	4tep85UaqRi4lgegka4KwYwn2/mxEkjzYSV32X+Skn2SwGHRHchn/N5pmFl2wDfo9ySwUmTJ209
	bqQ2dQWVg==
X-Received: by 2002:a05:6830:6516:b0:7d4:f2bd:dd0f with SMTP id 46e09a7af769-7d7825e838cmr6717447a34.30.1773591601353;
        Sun, 15 Mar 2026 09:20:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ae6a361sm10565455a34.20.2026.03.15.09.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Mar 2026 09:20:00 -0700 (PDT)
Message-ID: <8688cc4e-8619-4392-8d5c-93c554d70c34@kernel.dk>
Date: Sun, 15 Mar 2026 10:19:59 -0600
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
Subject: [PATCH] io_uring/poll: fix multishot recv missing EOF on wakeup race
Cc: francis <francis@brosseau.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12684-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,brosseau.dev:email]
X-Rspamd-Queue-Id: B4D022915FE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

When a socket send and shutdown() happen back-to-back, both fire
wake-ups before the receiver's task_work has a chance to run. The first
wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
When io_poll_check_events() runs, it calls io_poll_issue() which does a
recv that reads the data and returns IOU_RETRY. The loop then drains all
accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
the first event was consumed. Since the shutdown is a persistent state
change, no further wakeups will happen, and the multishot recv can hang
forever.

Fix this by only draining a single poll ref after io_poll_issue()
returns IOU_RETRY for the APOLL_MULTISHOT path. If additional wakes
raced in (poll_refs was > 1), the loop iterates again, vfs_poll()
discovers the remaining state.

Move the v &= IO_POLL_REF_MASK (drain all refs) into the non-APOLL
multishot poll path, since poll CQEs report the current mask state
rather than consuming individual events.

Cc: stable@vger.kernel.org
Fixes: dbc2564cfe0f ("io_uring: let fast poll support multishot")
Reported-by: francis <francis@brosseau.dev>
Link: https://github.com/axboe/liburing/issues/1549
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index b671b84657d9..0f0949d919e9 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -303,6 +303,7 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 				io_req_set_res(req, mask, 0);
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
+			v &= IO_POLL_REF_MASK;
 		} else {
 			int ret = io_poll_issue(req, tw);
 
@@ -312,6 +313,11 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 				return IOU_POLL_REQUEUE;
 			if (ret != IOU_RETRY && ret < 0)
 				return ret;
+			/*
+			 * One event consumed, but additional wakes may have
+			 * raced. Only drain a single ref.
+			 */
+			v = 1;
 		}
 
 		/* force the next iteration to vfs_poll() */
@@ -321,7 +327,6 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-		v &= IO_POLL_REF_MASK;
 	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
 
 	io_napi_add(req);

-- 
Jens Axboe


