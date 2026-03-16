Return-Path: <io-uring+bounces-12700-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2NqMLvVauGk7cgEAu9opvQ
	(envelope-from <io-uring+bounces-12700-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 20:33:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C88729FD0F
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 20:33:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 70D493018F34
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 19:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3688234C124;
	Mon, 16 Mar 2026 19:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IhsiTs/b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC35C33A9D3
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 19:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773689586; cv=none; b=Qlr97yc5YceJ+dTDySmjDEx1DO6EEJsm83xFklrF3ypb6hSXA+/WaTFn8hSuDagd47B+lrIdKl6Z5ASBYNSFUeFQ/UrPZn9k2gx96BYK/06SIUObKMBtFwGcAoNlaAqmkiiVwL8WOPRo8OP9Vjy9b71XVFnx8Ybl8G0caY+VdzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773689586; c=relaxed/simple;
	bh=oTEoGlmvparb3VSFCxYYdyGA8mnHgx0FTtdD/r0KQak=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=GRe1bPuUX5yZLIHGTJYYLFXtKMydSFfFTkrqhm/mAV4y8rK90tXQ8GfcyV1qxvDdQM/LdCpAfh94+5BTnDGG16x7cllM0ACgz5bX+vjb2bT7GiTHYUcZWd5lwQ8YSfSD1+q/68C+HNhOglTTfGfjr1Fj7TL7QVgl8m6aKyvksG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IhsiTs/b; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-40427db1300so2971193fac.0
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 12:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773689582; x=1774294382; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/ZLw2GEL74wXFi4mnBCdIGmeDLoogf2VctRT7EQunc=;
        b=IhsiTs/bqJV/kIYRaCqk73Vu5/Bl/zT6qRjbGRj7eZw1eUwrRIPu5gp2JK95XekO9a
         th9qW4q7HcDiUdzpLbMRG7MPmza4LkO44rNeUiCrrokhoF9ejic/UyKTER0uHxz79s+m
         wLsSyCGaidhzsf8nx1YjTxxl3SswnYdnU97HQNQJNBnXeNidsJT4wrWv4RP4N2B9Uhly
         b3lB6ZBz6cN1nvVHRmm1UV5QewGZ2eGg56kQv3iafr9kKYaEFcCJoFoj2A6ReRCINGAG
         RWPXxlZ/LSm2JH8JovfRFsasfj6OT0lSpV24cHQPnzJg3/DeY2wcJ3f2ejRTMlYvr3rq
         vhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773689582; x=1774294382;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H/ZLw2GEL74wXFi4mnBCdIGmeDLoogf2VctRT7EQunc=;
        b=pIrqJKmTO88HQqlGgju7oK8Wgcrkt/cevhYgZeAlRV0PlyI905ZXNO0N0s+tzR13k1
         6cnkt+n05WNs53Y6rfDUNZ0i8XErYIu/Q/3x2iurfYM94m841DDNws+Ex3Bb9lV1v8x9
         32he/1KUmF89Egtibc/mWJhrRIJ0fvhInhc7gcfajWf/yXcHBTgIVNZdlQTZsOyGodRB
         Y6k9jIDMx+Q7rP1C26sT4f7bmlRH2KQCZBCAyRxVn8dkp5J5PiVkbaRoMuwnBpB4Fr6i
         r3tafhk38AeTXsACCbaaRD5Jway7v8QldjZ0dC0VUvObT58KwciyoBxo7hDQ3XSlHdvY
         u/gQ==
X-Gm-Message-State: AOJu0YzFvEY3+5bgW6jTt/L+TGM9bb5x61J/eVyo9TcvpVyjvPk1JDGe
	h5npWKFSgVnRwY72oTBlUdDw+LBI3zBoy4JyaRNcSZBVT+JwPGFkxd5AVBXN0XoNLVYziOdpt6B
	Z8lmy7yg=
X-Gm-Gg: ATEYQzzv+2sp83udcg0hPIAORvJ8WcNUhdaWOWctDilQZ8j+a4pcUlyZ2zeFrySi62P
	5Q0nOpNnY/rpQ/sX+1uL2xb4iTasTjyoh3iIFrzx6m6R8/4N6ki4hYmxnoSwMcefOgS7M9IItTq
	UQrZ6CrEw8Ohr8hzyZpzChJlLFv502Zl3fmo4CmVyUNWS/vlHKKhS8nKaqSUawqfwpdW/UpAu8S
	m+Wj/UU8VP0lhEfVvb0uvWD0uUAnCwhOSIQKndn6FWj6i82fScmVcqYuWJNGNb+vfhwMOzSuqll
	4X8qM59yLlojIK34cQjW+eL02oBeBszPZCfmAZg0kkw4pJVg005CEOuVdXwx3ODiGsFZnm3FGA9
	tt3rUjYEmqnQIuYXCcTY81CF7axwLlgbgWZB6mGFOV9xjmVrRkWa9QWcbP7a7j/QP+XFWJZZnsT
	SCTgWSiQNEH91BacCqR+e329EB5X7jxkmHOFemjFWnMlK5XAYEqf7aEKKmtSwQbP20tkM49TKkc
	sv3Cih+Qg==
X-Received: by 2002:a05:6820:f004:b0:672:7c0d:5607 with SMTP id 006d021491bc7-67bda9bd105mr9977721eaf.26.1773689582373;
        Mon, 16 Mar 2026 12:33:02 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bdd612b6esm6026026eaf.10.2026.03.16.12.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 12:33:01 -0700 (PDT)
Message-ID: <e5a5e36b-d091-48d5-b961-f89f2d352fb6@kernel.dk>
Date: Mon, 16 Mar 2026 13:33:01 -0600
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
Subject: [PATCH v2] io_uring/poll: fix multishot recv missing EOF on wakeup
 race
Cc: Francis Brosseau <francis@malagauche.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[malagauche.com,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12700-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:email,kernel.dk:mid,malagauche.com:email]
X-Rspamd-Queue-Id: 5C88729FD0F
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

Check specifically for HUP in the poll loop, and ensure that another
loop is done to check for status if more than a single poll activation
is pending. This ensures we don't lose the shutdown event.

Cc: stable@vger.kernel.org
Fixes: dbc2564cfe0f ("io_uring: let fast poll support multishot")
Reported-by: Francis Brosseau <francis@malagauche.com>
Link: https://github.com/axboe/liburing/issues/1549
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index aac4b3b881fb..d14f21a409a4 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -228,6 +228,16 @@ static inline void io_poll_execute(struct io_kiocb *req, int res)
 		__io_poll_execute(req, res);
 }
 
+static inline bool io_poll_loop_retry(struct io_kiocb *req, int v)
+{
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return false;
+	/* multiple refs and HUP, ensure we loop once more */
+	if (v != 1 && req->cqe.res & (POLLHUP | POLLRDHUP))
+		return true;
+	return false;
+}
+
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
@@ -246,8 +256,9 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 		return -ECANCELED;
 
 	do {
-		v = atomic_read(&req->poll_refs);
+		bool retry = false;
 
+		v = atomic_read(&req->poll_refs);
 		if (unlikely(v != 1)) {
 			/* tw should be the owner and so have some refs */
 			if (WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))
@@ -287,13 +298,15 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 			if (unlikely(!req->cqe.res)) {
 				/* Multishot armed need not reissue */
 				if (!(req->apoll_events & EPOLLONESHOT))
-					continue;
+					goto finish;
 				return IOU_POLL_REISSUE;
 			}
 		}
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 
+		retry = io_poll_loop_retry(req, v);
+
 		/* multishot, just fill a CQE and proceed */
 		if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
 			__poll_t mask = mangle_poll(req->cqe.res &
@@ -317,12 +330,17 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 		/* force the next iteration to vfs_poll() */
 		req->cqe.res = 0;
 
+		if (retry)
+			continue;
 		/*
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
+finish:
 		v &= IO_POLL_REF_MASK;
-	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
+		if (!(atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK))
+			break;
+	} while (1);
 
 	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;

-- 
Jens Axboe


