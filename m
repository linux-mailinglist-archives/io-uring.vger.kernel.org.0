Return-Path: <io-uring+bounces-13062-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0HfZM1RB4WmaqgAAu9opvQ
	(envelope-from <io-uring+bounces-13062-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 22:06:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6134641475A
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 22:06:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8FD1D30312DB
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 20:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5BB73ED5C2;
	Thu, 16 Apr 2026 20:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="gShKyFJ8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFF512CDBE
	for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 20:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776369994; cv=none; b=YQk0kkhf0HbQKYzNVETWkll54aUHQ9cFLYIuGSwo1whPcyEQ6BL9jC6QtL/nXNpg22TNjbGTotDedPH953patGrhCP3WFaAgn4lqjIpHfsSiPaZFjsa3gBVEZEoHM3W/wwK/FA6xFypaHQJXC65By7oeGV7qgfcKmetbz6lxJL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776369994; c=relaxed/simple;
	bh=WTpGxukZR78h09fbd8OwaBAVe51+XD0OJHsL+XAJQd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiPeB7PnS9B3xVIfzkBxuFXRLm9TwBcVrwuTvJ4j42YTfXooQy6Q0QXGx/NEGeOsl2c4z1wX5+ouJnN+0PUm44kLCtpHSoavLKPMx3vXVvdG10OxcvxP0BwqqMOa6hje0DdeeEMjXP1Y6W0b/dfqVArN1nhAywpFL7OBVSrH9Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=gShKyFJ8; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-470145d7e6fso3141266b6e.2
        for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 13:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776369987; x=1776974787; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s2afb8QhLulvx0IdstQmPnC3FtqtCJws52lO9av6OV8=;
        b=gShKyFJ8VfnjoFXWfIj3w8WHQvn/zooWND1mHFUJpTDATTDnTnPD1UyL8mjN4BotCf
         f3KGhp9TZHuR/Kh23KdVx12/+sQDq9/YcTNgLtUoJhimjtlauxTW9coQO4WRjW13YBit
         LHGYSZnRUSzLqEQn0kgWaN7RcnRVNxzGKHRfA8NJGNntHos2OVM6UeaoS+sI0yURdh9g
         DQr2J3DcwMM47gkhA/aC7+ch++XgGuQVum4czFQTrCwKY9EaBMz2dVj4jEW68N1FIu+m
         jypEhcp8xBVc+b26llO5sW/XoDdkb4T90haklLnIm+xxPYhsr4/KqV8SicFs86m+IaIz
         7Tjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776369987; x=1776974787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s2afb8QhLulvx0IdstQmPnC3FtqtCJws52lO9av6OV8=;
        b=srgXWIik8vOD0+w0nvy6dOa+HSYe9GONC0SjuH5SdHUz81BvHCx0NSzlcVxaYlwpFM
         Qb0i6PgbGz2Aw0SBiWX1/1XpdsY5IQ7RcLSgpSYE+LAL+QCSl4gtyV/R0aG3VAi0GPID
         SrUF4LmHSDvBV+HPl6uGxyvFKSm+VLqdWWHvcPJesVuxd3rNfCjKQv0Lk/Y+f5DY7fxJ
         8O/avdDjPFssSaqBqrH1fCm1tmWz8gY96e8rnwawNEWCLPWTCVb8IpY6yqhWIANSFwHS
         wvfp/C1ZVhTRTgSAmGq7nAXCF7J9xZZjoiIgvcuZ9LLk12kaS3CQT0BlmkGxVcUKatnv
         f6sg==
X-Gm-Message-State: AOJu0YxV3QDEKPzKvigeCsZePlW7T1knLrQC8ZWl1KXSRKOtwVzTXAY5
	TjEZFWSQ3cLFM8MEsgMHjLzsMZjvkcD7g++MxR/6E3Dud28flJInvfSg6IusqC2z+BNNKhhoQXM
	MKPf/
X-Gm-Gg: AeBDievfQOJ+YIIxadzYLQ2AR7B5ak7fEmNKiRY6lHs6WImUFMiOn+LQri2Z2R1oh+5
	R+v3OmrSyPk3LGG4/p6ghnXdvr2Y1nJZD+nxGoAfqZVu59QA0JXy83Sa0/PP455PdRxcP8v8d2P
	ztYbKImkFomstedvyIE16XJgu6BCYQzAFz1d1U/3E8FmfoElUWcIocuqb8AMDAmodoclsBXEWNU
	Q0J8UcOf3cJV84HvI13Yis4fufSoJI90iPuYpowquYIm5HQu8ZBoPL2OqPjD6vjyL+3moD4fvf0
	G0GzhJ5zmvHnaZyryCEkPpJi2w9LXq3qPJMEYWcJKNYGMBhNnBDxLc1um1DZ1MmPSNMlyY5FlrC
	UrONiI1bwXBrST6nGUCvifRGPTHtZxMMB938CYmzlMro7FOEQlCcTQP4169uBJYvUE+y5FQbMtj
	oGMnpzo0n0pOh3SHeA6+gUUg+2I52WsLr8b32lh6/+cugDtuPPVTA+Posezj4DKDk7gBpx/lTpo
	t3RyA==
X-Received: by 2002:a05:6808:448a:b0:46a:6d33:65a8 with SMTP id 5614622812f47-4799a2f2f71mr222318b6e.32.1776369987172;
        Thu, 16 Apr 2026 13:06:27 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47997f9abd8sm576352b6e.15.2026.04.16.13.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 13:06:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+79a4cc863a8db58cd92b@syzkaller.appspotmail.com
Subject: [PATCH 2/2] io_uring/tctx: mark io_wq as exiting before error path teardown
Date: Thu, 16 Apr 2026 14:05:53 -0600
Message-ID: <20260416200622.831635-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260416200622.831635-1-axboe@kernel.dk>
References: <20260416200622.831635-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13062-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring,79a4cc863a8db58cd92b];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,appspotmail.com:email]
X-Rspamd-Queue-Id: 6134641475A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

syzbot reports that it's hitting the below condition for exiting an
io_wq context:

WARN_ON_ONCE(!test_bit(IO_WQ_BIT_EXIT, &wq->state))

in io_wq_put_and_exit(), which can be triggered with memory allocation
fault injection. Ensure that the io_wq is marked as exiting to silence
this warning trigger.

Reported-by: syzbot+79a4cc863a8db58cd92b@syzkaller.appspotmail.com
Fixes: 7880174e1e5e ("io_uring/tctx: clean up __io_uring_add_tctx_node() error handling")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/tctx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index c011a593c0ad..80366320276d 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -171,8 +171,10 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 	}
 	if (!current->io_uring) {
 err_free:
-		if (tctx->io_wq)
+		if (tctx->io_wq) {
+			io_wq_exit_start(tctx->io_wq);
 			io_wq_put_and_exit(tctx->io_wq);
+		}
 		percpu_counter_destroy(&tctx->inflight);
 		kfree(tctx);
 	}
-- 
2.53.0


