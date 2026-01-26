Return-Path: <io-uring+bounces-11924-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id /SGUMv2td2ngkAEAu9opvQ
	(envelope-from <io-uring+bounces-11924-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 19:10:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2438B8BEA1
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 19:10:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 50B7C3010D95
	for <lists+io-uring@lfdr.de>; Mon, 26 Jan 2026 18:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7EE233556B;
	Mon, 26 Jan 2026 18:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="y+vZogMn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3451E2E54D3
	for <io-uring@vger.kernel.org>; Mon, 26 Jan 2026 18:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769451002; cv=none; b=hiYhGb/hfdvsV4sVoSuY8ZASFgW3Zrl5+zwLD6qXfYMNqMtVt4+EMbJ+V5wyfkelNM9djHsNvAfTZDYatPHhQwkUyAHC1uQA4t58Us4weJNsru5KRjNatQ5V/mBnmt2GusrXWx2HpETk2fz1E6G+qpWYSfiG2+p79e8DAi59I9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769451002; c=relaxed/simple;
	bh=sGRSuAqKBmdnYclG3xrkSXd1UCwMF5o7XT0SWQgqUUw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=prYH3hs7aJ3sXwmGaolBBDfkuBDb4CpbQz5/96K+FySLKu/iOajbk0aQsoRCJPOf1iYWfEwiibdAjcoistF2QV8Vz3AFaUFjQlVrIr+LpJPb0AhbQGoYgv0JqmQ70KaWrsh5u5E4m/aVEaehTeyCQA7dNyC/dLE23vwfRiKuODk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=y+vZogMn; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-45c96b175baso1608623b6e.1
        for <io-uring@vger.kernel.org>; Mon, 26 Jan 2026 10:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769450998; x=1770055798; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zR1QXEi0a+zUT2A73P7N8iJuc1DJ/icqrZncv0J51AE=;
        b=y+vZogMnA5kbOM1Tdant2MIDR4iZPOBCjO8FnLIqzEqeMqdi5Y+9VKYkAy/2Ui/DLB
         cZGJ7B9tofdHBPs6mFfd9DdpulVDFN2cFr9IxoxEr41+vJMwGcmJPAIEG2igeof2vkMG
         l6Bc8wUjdrAzxKCHE6B7GQYV9YGJdj7gDPjzUoQfvYikp7AfYKjKXXxFELWuOZ6YFiqR
         wROK7LbelfiyQl1oYMMtJyTSBDf/JVzgpjDFOAwLfJERlPCwopHe4JWtWkhR1DWtMIPe
         sDy/UFKuNYcYEWxXsY9YytdZVbwkLeHWSw8fj96s6Zu9FhSvUCN4ox7FbNgYPX5dq5ET
         MeXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769450998; x=1770055798;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zR1QXEi0a+zUT2A73P7N8iJuc1DJ/icqrZncv0J51AE=;
        b=BM2tyzSZHQj9pj2RsaN4El8o0ZHRQOJoW6SMEMWjKMAiCLcOWH1hA9OIpH3V2m+qUl
         5AdbAHlpDtJI+DDRGOcaJ6cAmRKF29apPfVpZwNv/eN1s3Q49XIqXGJcBmkdTjSKapwR
         heHZeffFxBq2OCT+7mz3mFd5/RUqvR21rMyznNUPoCMO98rXt68mkeBLnVs9Lifk9d4h
         15UneCvOgkiNkOw2MDSrzB7CYy5H+myIVd1DwXBg91HbHw68JO+usd0PTQKJ3lyWktHl
         4y8mfgao68suLNp5vg7PvhLqNswypIzGj5VOVPBoPKF1JAyYk9l9grV2cpc+dF8sEtZk
         +jjg==
X-Gm-Message-State: AOJu0YwyCNfi8PKqYEBmuYlwDMBuABNQof/manm5dw3d4INcz+VUWr8W
	7moj6DIdUqKVjyKhWYYNdF2uQOdbdFmbcYd6Wx7PJ/zxDXRDtvR/fEADcx8CCISDY4EAOGfJ4fk
	Eq3H0vrM=
X-Gm-Gg: AZuq6aJYxvgktisAmwfPC5QvMcA4JT59BvnrYIgV8xOs1epVzvTXL/9BVV1ns0mhzqr
	eR4aKpj2G55fqiKpEj5Lt+Lt+2pwo8ir+XakTWe9IDzxqkZNd3J2YLBfdIJYVPizGvXVxjQPM3m
	4LPneaXz7DzTu/eXUcqFcz6oLyZnumzmuKYcMgsCzMV57S08AnpvHlZotZDLVjxey6qcgnQxQxq
	MmXM8xk6T12E1wfQXlLxOe3xMaeGuP/yrYmL4w4O7T5Rr8dAjDUjuWVjF2haROr8oKz8hY7vRYh
	cX1hf2f+gF2EXV1/fYwZusYhHcRqTquN6KrT8tYv7hyLXPS03XKFBCDclMJhZ1XrWgEG8ZlEE/N
	IihuVJM/t+1xNnsjU5DjNHLxlHJ2YcpucjZh+8fu3XhME4Qqy316RPJsNkzZ2PIevcD1Jy5zk4b
	iLlZmG7cCxQ+ZRNJA8l/R4UxrCKoraEm3UbTLPrahgA8POTnNULo65taWyDXFxNfSlyAu+ow==
X-Received: by 2002:a05:6808:1186:b0:45c:9a62:91fc with SMTP id 5614622812f47-45ed9aed29fmr2530112b6e.67.1769450998551;
        Mon, 26 Jan 2026 10:09:58 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45eb42530e9sm6425035b6e.16.2026.01.26.10.09.57
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jan 2026 10:09:57 -0800 (PST)
Message-ID: <8d8921ff-4fdb-4927-ac72-e48a96c274e9@kernel.dk>
Date: Mon, 26 Jan 2026 11:09:57 -0700
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
Subject: [PATCH] io_uring/kbuf: don't early commit provided ring buffers if
 locked
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11924-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2438B8BEA1
X-Rspamd-Action: no action

If multiple buffers are peeked, they need not get committed upfront if
the caller has the uring_lock held - for that case, rely on the caller
recycling or committing before dropping the lock. This can happen if the
operation fails and needs to punt to polling, for example.

Link: https://github.com/axboe/liburing/discussions/1528
Cc: stable@vger.kernel.org
Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 796d131107dd..427e80748580 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -328,14 +328,15 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 	if (sel->buf_list->flags & IOBL_BUF_RING) {
 		ret = io_ring_buffers_peek(req, arg, sel->buf_list);
 		/*
-		 * Don't recycle these buffers if we need to go through poll.
-		 * Nobody else can use them anyway, and holding on to provided
-		 * buffers for a send/write operation would happen on the app
-		 * side anyway with normal buffers. Besides, we already
-		 * committed them, they cannot be put back in the queue.
+		 * Allow recyling of these buffers only if we arrived here
+		 * in a locked state. That relies on the caller doing the
+		 * proper recycling under the lock, if it doesn't commit under
+		 * the lock.
 		 */
 		if (ret > 0) {
-			req->flags |= REQ_F_BUFFERS_COMMIT | REQ_F_BL_NO_RECYCLE;
+			req->flags |= REQ_F_BUFFERS_COMMIT;
+			if (issue_flags & IO_URING_F_UNLOCKED)
+				req->flags |= REQ_F_BL_NO_RECYCLE;
 			io_kbuf_commit(req, sel->buf_list, arg->out_len, ret);
 		}
 	} else {

-- 
Jens Axboe


