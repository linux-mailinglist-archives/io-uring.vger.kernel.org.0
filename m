Return-Path: <io-uring+bounces-5806-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE5A6A0939E
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 15:34:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 475673AADB6
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 14:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 968F3211283;
	Fri, 10 Jan 2025 14:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SNqUZg1U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A81A210F53
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 14:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736519665; cv=none; b=tDRSt4g/YY3PbLoyQEIc2xiO7m4e3BDEvdYn0FUqu/xjMFkWcSVNIT+kGmyR4O5byABRiu5+JASQJQo46cA6+dipiCCFtjP7lGo/k5gxknZRP5GoERBdQOauOUqckb0muxxLeVtlVM1L0K0Qm6wFNOxVvTmv/B1wF/5Bw7ezJho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736519665; c=relaxed/simple;
	bh=VlqCuzIwHBzoVyiGwM1a12/hu7iG+nGby6L2kwJVimw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dFZpb9bfEYJcH5kgF9fGBAnde2PLQD0IdJucImV39zJj+zdDHPlFoCrNe34PPAX+c7eKIvuhyqaTa02yyX8CQjDlIF51sCwQgjtpW8qR27FFDzLPAb2tgpNE59/nnX4L4BW2Le2S+Xd9VmlGXPXo80VDWP5O66aysSOtSIJTmO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SNqUZg1U; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3ce464e52bdso6487945ab.1
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 06:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736519662; x=1737124462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pixp+zCOBaeGmVokmswNGSx4S9W45oywKiZZ/7VEiaQ=;
        b=SNqUZg1UUqkT5GeP++MsF0/IXB1ornMRGDW4b55ZLc1Mbz0csK4X/syuAZZexqDOzw
         XnOyV9NtR9fxcXHWziqmg7IDNOV01zG3Hvh35/1X2elQh5u9rk/gaP+iDXRRmf1o+Ljx
         7G2zKokoylZCdmEk1ylRtJOVFygV2F33MpQNRRIp0gP8R+Xoyma2SUNUmvqGUYhVv9fA
         4yIfpSwLm1pocDTRsYfHjyh84TMCrpHQfoXHEe77egf9qDr52sUSlK28MNQp7cWVjQsI
         9VB4LpACHMfiXoZAGt/9RoBy6EjtHsWzRzXJEDpZjmu/zEjaeiZAh/6eTyXU/GV3L1h6
         6PEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736519662; x=1737124462;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pixp+zCOBaeGmVokmswNGSx4S9W45oywKiZZ/7VEiaQ=;
        b=WX/+FRt9wnRkqEyxqErjCJ2ldrnQ3qhR8KjxgRYUE6mXkV8mJq3vwEQf5kHOCtyoG/
         KoeD0SCn+Bv7dWzVbw4WzMM8zMQ41NMGM3SVeczxKskAn13X6lI0RDJMssfIRz6J3q4V
         wpPZrf1lD+fAt8JFJbLfIa9PhH0bontHHyryq5zIVAvOgzffxCo2bwPQGm7YW13VXpYb
         n6b+8aHIdk5GF7KDos0xK048ZJ7DK7PBVevJINiep9F0hrHCTBXFjYHxotSb3OzEMw1p
         izixhM/c7f3YT/yVAU5R6ERL0YGIRuPhhhbO25Bq28+Lkny3QdywTZxozL9Iextl4bda
         aepQ==
X-Gm-Message-State: AOJu0Yw77zgeMLXtHzNnRBz9OqEO8KfmsAXM2DoCBFF6uRCgjwTSN67s
	61GA+hYz1BpJJhnGojrb5v5kSjPDYvo+ZgKN9KFMbwcVjiDu7QKyZ3PUp6MgftMybQ2w2d8EBMD
	k
X-Gm-Gg: ASbGncsvc5/tBDsWK09nEPyi++DsFDDTvcaJkMjGPjAK1R1akHexkgLVHPFzhF0hA+3
	0jMJF75yiQR4FFfMtTQT63pDMJE2jRoXTVne+FLrTDp6A0mkFW6saSoT0x8u37I5RlmgjA8KfMu
	rG9r5p2fd6XAlUXiEu4IVc0PFXjo8Gt+bgKzpNsL3IBZaPNM2YX+OYREipJ38TzZezAQp6dfRiu
	b8KgcERSdQuoDDfjc0DU07zJUV00quWM99PeKC/U06uRLQ=
X-Google-Smtp-Source: AGHT+IG9FnuaDXYiwuHUnKPjyt8FULpKF3z6Qvv5jBIz415EctfBDFLT3dTT/4dJYhDPnUwwHeMyUQ==
X-Received: by 2002:a05:6e02:1d0d:b0:3a7:d5a6:1f9d with SMTP id e9e14a558f8ab-3ce3a9b5a86mr79536895ab.9.1736519662538;
        Fri, 10 Jan 2025 06:34:22 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b5f8e9esm910546173.4.2025.01.10.06.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 06:34:21 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com
In-Reply-To: <efc7ec7010784463b2e7466d7b5c02c2cb381635.1736519461.git.asml.silence@gmail.com>
References: <efc7ec7010784463b2e7466d7b5c02c2cb381635.1736519461.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: sqpoll: zero sqd->thread on tctx errors
Message-Id: <173651966180.759272.470785840955056894.b4-ty@kernel.dk>
Date: Fri, 10 Jan 2025 07:34:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Fri, 10 Jan 2025 14:31:23 +0000, Pavel Begunkov wrote:
> Syzkeller reports:
> 
> BUG: KASAN: slab-use-after-free in thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
> Read of size 8 at addr ffff88803578c510 by task syz.2.3223/27552
>  Call Trace:
>   <TASK>
>   ...
>   kasan_report+0x143/0x180 mm/kasan/report.c:602
>   thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
>   thread_group_cputime_adjusted+0xa6/0x340 kernel/sched/cputime.c:639
>   getrusage+0x1000/0x1340 kernel/sys.c:1863
>   io_uring_show_fdinfo+0xdfe/0x1770 io_uring/fdinfo.c:197
>   seq_show+0x608/0x770 fs/proc/fd.c:68
>   ...
> 
> [...]

Applied, thanks!

[1/1] io_uring: sqpoll: zero sqd->thread on tctx errors
      commit: 1593ed0d510769514b648e09f8b7b71cc7fc18ec

Best regards,
-- 
Jens Axboe




