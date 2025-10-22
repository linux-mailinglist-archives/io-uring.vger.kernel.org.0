Return-Path: <io-uring+bounces-10134-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id EDBFDBFDA46
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 70EB6357FBF
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF09C2C21EA;
	Wed, 22 Oct 2025 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="M9jgNYrL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB99B26FDB2
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761154861; cv=none; b=Mjm4DBSs5T1O1yOiDVHAoSE5kgpGWUCRCrTAV62FIyU4m7T6qk5GY4dJb6hevtXc/ejwia7RXHhpn+KmXQYw7Wov75wSDIoEbF77nnfMKviVHUcD3I15m8n8XhWSEd+uKKtkVV+q1gXet3jkfGn6aRLD6OzzpTX1zc80bV61W9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761154861; c=relaxed/simple;
	bh=j7rrcqsBcqQZXQjyYxn+ElR6LMJuF8lwHPe0OyCAA/g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pVh2G2nf+6gfC2u4JkwfnrXhwqkKNdaN2xPHQPLlz7JYzaYoy2q7SmxqZkfV8BeZC+l2tDCSxJaJ0G8bm88T0S46HvNUHT/BM/U6nrewX448GTqKUKGOmbN3PqDXdzIJUilE/UTvMFNpUyBhLx3RJfZJoFFpzbkpPglf0RQaozc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=M9jgNYrL; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-430d7638d27so37805565ab.3
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761154859; x=1761759659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t7pO0EyQ6MZ1563OJz3DoyJZ7izcwHhSEFyAYJP3BlE=;
        b=M9jgNYrLESsFdtrzoFSjG7PSsiYqXZKOX0UTGhm2Zt8/0TIDTOFk/xi4V6OU7ETZcJ
         F288RonzPSO63opLymk9kW/Q1sghGvp1vnT5OqSrXfP4DoscFmzXUwYchfJ7FroQItMo
         ZzoD6K0e3PjzZvTFQkclLjfgPJYKD39sVcWH/LWJuYa8Qu+xASDSJaVzn+E09oJPRZ80
         NhQs2v3PHTEhJswhG0kS/UJYHX5ZnWHkb0LS46VMJs9S+31WR4s16m+tFzFY8OR+ARbo
         XHvcETaNb83qDCvx1xKUzN50WCTJF5arBfCC4KAtnc3/nFjUlLJSOhhk67RWSriMXOgl
         84tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761154859; x=1761759659;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t7pO0EyQ6MZ1563OJz3DoyJZ7izcwHhSEFyAYJP3BlE=;
        b=aHROMkSAOubZEqMwGVUigLwMoT1OG77Dlol0dAO7FMchW2eOhxOj9Gg5EV7EBjxSHu
         Zhm6IpuC25q98RF72/nqH+uQFVxa60DCk9YwCAgH1Qv/b0V0+aDNqwJ7aWI+ZmgCagK4
         kPA61IMI2a3N4exVTR/PvUVCGnSFqcZ7hW9r+tjWYu0UrIrENAHlPa3vdb11q1tmeWUA
         ESOsu9No/xlEyXaA1QHQOipWSUXM88VhFiyQxwhvFnwrnb9RZVf7s72Tl2U+V8x9Z+Ye
         Hf7DABMhyKYAKQUMt+cGNezA9UIEMmWFRRW6UrepEji0J1K9dDmPfxykMHmD33Q2tAXE
         r/NA==
X-Gm-Message-State: AOJu0YxPBwGfWmG6azjGtm82yRQXLT4gxSwnWP1/iNzDD28/ujKbRFKB
	75q1Kkx15d3Kq5WzBdGs9o7kyp4z01EDjcFxpKzbWivjlIx/rh3l+O1uDSw/pKW6h7s=
X-Gm-Gg: ASbGncuttFzA7VMRvu6HDekCel6ug0G979HA9zT/NvT1PrlRG9cjF22L/G72cZBRdzC
	ie20j4g/Ik7PGQ0oI9+zBp/rFqPxvjlq06+kBtPi6W5X7jXLWkmt5nU+lhOQcsb2MzAiR3LeRNS
	V15Kpd1XJ7cbEqrYSiMnF1bHCNjcsF254+Wnfn9HyKu2zcvCe92HqYCICDPbe9qGLphYTOO7jr4
	mPto/50x+R9cb/QN3RWu3r3Da2+aK/U53E2V0D7kMm4lRx+T/DFn3iguqRZ2hxc+fYMiFbfn3Vq
	RSDqcvcoRFiGGOo1xX9XxnNJxtpbxehcrQPAp0Q9VUjUl3Ibvj/uPYl0H92DF9P5T7YC8T9pOFC
	vuYgIVp6Vtpaxgc728S4RYcECh5ZfG0FGW1OY691fmR2f7A00ApShSyR4KDqlvLXP+6wjSnpbyC
	wouQ==
X-Google-Smtp-Source: AGHT+IFDVn+/9jIWnG8R0OXhe1LxNo/yICJ3TQKJEIfYUfjZGavqD7Hx5hNMH9Z8hmShEZ6HEwJZzw==
X-Received: by 2002:a05:6e02:156c:b0:42f:8b0f:bad2 with SMTP id e9e14a558f8ab-430c524715bmr330365325ab.10.1761154858755;
        Wed, 22 Oct 2025 10:40:58 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a97407d6sm5391534173.37.2025.10.22.10.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 10:40:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, csander@purestorage.com, 
 Keith Busch <kbusch@meta.com>
Cc: Keith Busch <kbusch@kernel.org>
In-Reply-To: <20251022171924.2326863-1-kbusch@meta.com>
References: <20251022171924.2326863-1-kbusch@meta.com>
Subject: Re: [PATCHv6 0/6] liburing: support for mixed sqes
Message-Id: <176115485745.149047.18203891023971914011.b4-ty@kernel.dk>
Date: Wed, 22 Oct 2025 11:40:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 22 Oct 2025 10:19:18 -0700, Keith Busch wrote:
> Changes from v5:
> 
>  - Fixed up braces and line code style
> 
>  - Added fdinfo mixed sqe tests
> 
>  - Fixed up errors when CONFIG_USE_SANITIZER is enabled
> 
> [...]

Applied, thanks!

[1/6] liburing: provide uring_cmd prep function
      commit: 45c13470e7fd050fcd94b99d00ed58576b7fc4bf
[2/6] Add support IORING_SETUP_SQE_MIXED
      commit: e1453a03f3e5f568f94e9cf9008fa1862154f7c1
[3/6] test: add nop testing for IORING_SETUP_SQE_MIXED
      commit: 293e571185b78098ba4e95cf1723b0bad0cbfad9
[4/6] test: add mixed sqe test for uring commands
      commit: 43f0b21ade9d0b69197dad4f1517a113150e7b47
[5/6] test/fdinfo: flush sq prior to reading
      commit: d118e9e77c2e4a4017f3d000af349e59d6adf686
[6/6] test/fdinfo: add mixed sqe option to fdinfo test
      commit: a41ea23839da482d9585b83e46398147e4c4d1aa

Best regards,
-- 
Jens Axboe




