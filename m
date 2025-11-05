Return-Path: <io-uring+bounces-10386-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E543C37819
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 20:37:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 371CC18C7F34
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 19:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E09263F30;
	Wed,  5 Nov 2025 19:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="omCV9i5v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C41D33F8C1
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 19:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762371420; cv=none; b=c6W3+I4ANll+/h2z+UodMMh0KHa8IzU0ILPZlpZZmPdVCaQabiJxlFyg0VwULCIAYFpYbtzd4t6HHELg0CWjDzxdGQxzO8B/v5Yj8mDOp1EZgEX1YRv6bEUnPaihjbHNWbw+7Fzr22z5UY0IJ5LQjyc9TYQ404XxhSzuVDSgNUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762371420; c=relaxed/simple;
	bh=gbvx5wE3fd3J3RR1D83FPZkPKZ117GCieCxLhI/ItgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okpSooWs+v2L7iRlD2xM0zfhR7XsIOLSVHF/6cv9bru1UdN7N1SLmiN4W0G3i3liGx1iDDihemJRHNR5sDEQA+ymKrWGgpXBi7+biSnex1t6ezRDUrM1eB4zQQjj0NrwgBFfV57DVKHtL7Fc7zPzLqOnIZI326e25oRmiqT8UBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=omCV9i5v; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-948733e7810so7215939f.0
        for <io-uring@vger.kernel.org>; Wed, 05 Nov 2025 11:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762371417; x=1762976217; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZV0TlBKqi1D/LW+ranC8T4AiAm92JIMdB1Gls+4XWEc=;
        b=omCV9i5vjmDY+KX0mvroEUPrjeRqlE1nyfZgc6Jmnof8mgd7FK9nP0unLtt7QSAPRf
         28EwVBJWNuko/lvz6uJX8aToCG9Zt3fiT2hFFQJDdzX1cydaUGsMXKecDwbU+tdadIWi
         0m9oxv7KHZ6Th1XOBRnQ9oVsePP1MPTITy0GqoN05bP+UBeHr2YRnKFtcNvKgNo2SKLi
         YAtqZkvJYATQp02s2iTjxpTAl+gIXf7PwNvT7EOBWLm8sPRj/7dshtDieYBs5GbEPIvc
         8RZC3UpHISNVz0LP05oMiWgP/IplzFGawu/X/WyjXOis/+y9rMids3zisP3NOGfw715c
         W25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762371417; x=1762976217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZV0TlBKqi1D/LW+ranC8T4AiAm92JIMdB1Gls+4XWEc=;
        b=ormZYGadKxTGb1177zVEcrUN09B1f6JI1cIn1OGcqRl/CpDbNM0QQoM+P2nq5Pk/YX
         vsT9oEaEJDdGaR4BRr6gCPfhI/5qoC6ucC3mQFgTxJcmY83kB3VFceBg+Ja3nCQaxkHc
         wV4PSTMk++Mt9S74SMFzzl7i4pvrgFZrezwk/aySaWX0dbKPEgmYq6zoGakgw18+q578
         e/ciOrjuGp50l2ixfGxPZtriFVeKrga5WIyM5pQEgrWKX+Sk2xXnyDig6/aNsmi8lQBp
         RnWnOlXOq18RfuAJ7YIRcLtkvjZZuXDM5au1EWm5KIywg1PFCFg5plRIedUZxDINkW4y
         5Rqw==
X-Gm-Message-State: AOJu0YyLVBsDYKM9Zswk5c5vBGCYsNkrT5CJX7f5bDWcaKwva4WHBTnv
	J+YAgA34TKUS1jylrUQxoQS0+Pwx1XoOUP7tWrMSz+xOMc0henGjVmrNB9ifWrxPAVNOQwwNHKl
	ej+LG
X-Gm-Gg: ASbGncu7oRJuqRiD8N9d5XePLMUa0lzb7HixhqARpD6Igl5mAkBYzjdB6WtUO4Lu1r2
	fkIQ4b2vblDiehhgfMW6lzWGjn5OrYDUu4JEU/mY0s1xoD8YD5nZCgoqSMePzQdD/LLUME7QvjP
	2XGEUznwuHKjwgGyr9frFsBCVEf+hk6rLdvxmep/MdpTLa9L+dMGBVJAk6wAaXLyvKb3zAh5Svp
	Kkcr4lS7Fa3h7oq+ke3bNrwolvKvMCs1g+hs1jiHfeAV5I98h0DTfo+R/AHx+1bKC33AEUIpt+o
	58vyrjQLmY7IbfwemePvrK8bWNhEb3l+1etNB+Xjg8pPdpCLgw+9s4yhrYSHWH5lDN23NyJafhS
	RqLX0LsB+onqJZKPjkD/NaGZ6b83xagCRSykZ6EGxMcf1s/j5Zgc=
X-Google-Smtp-Source: AGHT+IGgBGOHfMfXmMRhy8Q2n8id7s+IxU/DStD8Vwax6ruyj5/Rda/odhd0JIXPLENQ6Z98FKL1Yg==
X-Received: by 2002:a05:6e02:12cc:b0:433:306e:2c83 with SMTP id e9e14a558f8ab-433407f590emr54973465ab.28.1762371417184;
        Wed, 05 Nov 2025 11:36:57 -0800 (PST)
Received: from m2max.wifi.delta.com ([99.196.133.153])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7467d43cdsm39467173.13.2025.11.05.11.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 11:36:56 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/poll: flag request with REQ_F_POLL_TRIGGERED if it went through poll
Date: Wed,  5 Nov 2025 12:30:58 -0700
Message-ID: <20251105193639.235441-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105193639.235441-1-axboe@kernel.dk>
References: <20251105193639.235441-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a request targeting a pollable file cannot get executed without
needing to wait for a POLLIN/POLLOUT trigger, then flag it with
REQ_F_POLL_TRIGGERED. Only supported for non-multishot requests, as it's
fully expected that multishot will always end up going through poll.

No functional changes in this patch, just in preparation for using this
information elsewhere.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 3 +++
 io_uring/poll.c                | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 92780764d5fa..ef1af730193a 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -521,6 +521,7 @@ enum {
 	REQ_F_HAS_METADATA_BIT,
 	REQ_F_IMPORT_BUFFER_BIT,
 	REQ_F_SQE_COPIED_BIT,
+	REQ_F_POLL_TRIGGERED_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -612,6 +613,8 @@ enum {
 	REQ_F_IMPORT_BUFFER	= IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
 	/* ->sqe_copy() has been called, if necessary */
 	REQ_F_SQE_COPIED	= IO_REQ_FLAG(REQ_F_SQE_COPIED_BIT),
+	/* poll was triggered at least once for this request */
+	REQ_F_POLL_TRIGGERED	= IO_REQ_FLAG(REQ_F_POLL_TRIGGERED_BIT),
 };
 
 struct io_tw_req {
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8aa4e3a31e73..d6f7cddf36d0 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -419,6 +419,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 				req->flags &= ~REQ_F_DOUBLE_POLL;
 			else
 				req->flags &= ~REQ_F_SINGLE_POLL;
+			req->flags |= REQ_F_POLL_TRIGGERED;
 		}
 		__io_poll_execute(req, mask);
 	}
-- 
2.51.0


