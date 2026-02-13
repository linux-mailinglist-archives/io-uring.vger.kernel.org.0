Return-Path: <io-uring+bounces-12202-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aJM7KIOSj2l/RgEAu9opvQ
	(envelope-from <io-uring+bounces-12202-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 22:07:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 050D41398E5
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 22:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F19833025A43
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 21:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8861FCF41;
	Fri, 13 Feb 2026 21:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2FmE3DH1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DADB8C1F
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 21:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771016829; cv=none; b=TzdWvYkcBia+LiWThcDr448EYPcxxOLvHsK7ETIdLu+Pw47EPkWU5mUTyl8aDwektr5O6LY7TUaOLbIUOkXD5I5RJGZX0/W0xLFHJD45gL3YM6JOvCVQ6C2QLGDaf/UI/nyG+rOfsGeTM4gETziVdgluoJ/GsSRvoogeL6WS1UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771016829; c=relaxed/simple;
	bh=ABUx8eItb5lI1A0a14oq3MrpAztNFTa0yMIfcd7MAV4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VYvVW8RYHz6jd6whDBhBGFhZ3AQ9hauI0aPdRcv4zKdHWXmkzO/ox92f5xWQyzPXF7qpKiPTxSCtvSQVF7LSOtYTymWBPBGeYliw+0uJZHOkdYFK9KQT/vH0nq65r9UXzidwzy3U//LLduaDh/gUIXLqR9BXVZkYW94zYm3fCjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2FmE3DH1; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-463a94f8475so428609b6e.0
        for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 13:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771016825; x=1771621625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ctdS21LqikeUVr0PmIq31b2awYDvbOQVQUnRFmB+hk=;
        b=2FmE3DH1+EzQ0/qq+Y+CMoAnBcznjyQbvrlZ6fh4+VsTsnHol2cyr8pMjiOK82VR3C
         M3prilMJfMeaD0OQJ6mJC9NH8pLgPS4X84dWHsFFcfT+v4QANo6WCesF/14YQa3QRWxx
         Uqj9aeJNXPHJqaSAGMwbFU9bJOQ+YWIT6N7Lv4SamSGylgBcoa5MtLr6ZkCcz/JqWhii
         MCZyyeuBH3Rf6ZU0QXL+K0hnuJgGiiilziHeyvixCqLRfQJYIDMQFg7FU39RJWqdbQQc
         aEkj9exNDxsg6OgD6wIj7dIAubSLIPNvltylgl7alNdHiUlfc8nqMEBcU9BTG6I6QygY
         TqwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771016825; x=1771621625;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2ctdS21LqikeUVr0PmIq31b2awYDvbOQVQUnRFmB+hk=;
        b=NRn2zbGsTxFgsjZ93kwBWcn/3zAqVpfAGfjmMd/QCicA2I5wEHv6BM2f1EcPuk4JvD
         tSUAUmfanaYEpRFUKaa0dJjQ6hfnh5A57MhO7mTZd5gjvckWDVY6gWfV+Skk/zcWFWAC
         MDewyc/JAxR1449uLE6/4dnH53E8OT0Wfa9IUmO4jZPtK7nJZtOTa/BZlGCsc1f7tBwj
         cRXRI8p1xH1OuR1UJ8S3taf3RUHxdzT07SKiiHdpU1XKa6Q86pr626fXFDb90wLKBlVG
         5Xvhm2YXTb4wNo5F1uiMuRWP0Db+ET9XvH+AOePmufc1MtdXW3vivTKKhlxjU9rHkiTg
         fgRA==
X-Gm-Message-State: AOJu0YzOwLommTg+KsQkgMcMnB3Ztw1UKztpQ+5g2Qp5DZEO6so7SDCM
	Kv2ww/kdCe9acznEXebr2sXPXSYzCZd+j41nBFRNngDfoMLuvVO/DSWKMwHxXRfnA9SbZpVauI7
	6mLo+xwE=
X-Gm-Gg: AZuq6aJCQKImYHxpam+7RgmfrwZrZIQvEC86/SXAYU4JbDNJgq4XoO7ywVXsK8zSYp4
	9o5SUf4d4yCFzXSNJ0x1Wl5zU2OMaYBe2G1VgKnctTAmeYFbVSJ6beOGnynL40teUvoRETdBqtA
	0dRlwdOgsrt1PeEe+bPVCgP8M4PTvEOu0HNNSXgbpdE7KT3NaMQ9pCgsVywfWeE1gr4/YHhlXR1
	vBGQb9VQQTlTcsbZ2tvHr3hxrw6/lsAJtWKQMbGxSnT57CoxJkAiVqq3MNytYKYoVWyDi32B5z2
	9j++kIae48a/PziYPP1/uKJAjOK45IlCs7U9gtIjvMiB3UVqhtLMkmLRgPJvPuvg+zPndA5+08o
	+yOxg1hwaD3L/hjul+KihoTlPzzTyaspksAyHVZeF0CYOtvRR15fz2Vl431me6auYN8M6vN4zCt
	tj5UhcFz2L0hye7g7GibuZfHBBxaG3Vf1aZGUjFHjWjJDxdhNyytTJHpkg+4WkcRR2eg6t7nGo2
	BXDPxeimGg7dA==
X-Received: by 2002:a05:6808:2211:b0:45e:fff5:89b4 with SMTP id 5614622812f47-463b01973e7mr853267b6e.10.1771016825082;
        Fri, 13 Feb 2026 13:07:05 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf16c383sm7440174fac.14.2026.02.13.13.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 13:07:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: io-uring Mailing List <io-uring@vger.kernel.org>, 
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
In-Reply-To: <20260213210548.851503-1-ammarfaizi2@gnuweeb.org>
References: <20260213210548.851503-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing] src/Makefile: Fix missing bpf_filter.h
 installation
Message-Id: <177101682427.298850.12069195780298295812.b4-ty@kernel.dk>
Date: Fri, 13 Feb 2026 14:07:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12202-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 050D41398E5
X-Rspamd-Action: no action


On Sat, 14 Feb 2026 04:05:48 +0700, Ammar Faizi wrote:
> After a "make install" command, liburing.h fails to compile because
> bpf_filter.h is not copied to the destination include directory:
> 
>     In file included from .github/workflows/test_build.c:1:
>     /usr/include/liburing.h:21:10: fatal error: liburing/io_uring/bpf_filter.h: No such file or directory
>     21 | #include "liburing/io_uring/bpf_filter.h"
>         |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     compilation terminated.
> 
> [...]

Applied, thanks!

[1/1] src/Makefile: Fix missing bpf_filter.h installation
      commit: 364a7b561fa13cffdd7771978dc5509ec4d9d7f9

Best regards,
-- 
Jens Axboe




