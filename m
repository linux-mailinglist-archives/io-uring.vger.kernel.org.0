Return-Path: <io-uring+bounces-7824-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA52CAA77EC
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 19:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 258D53AB668
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 17:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645581A3A80;
	Fri,  2 May 2025 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uzKYv/vu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BBE1A0BFA
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 17:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746205234; cv=none; b=IW0jbVgctD+9HQHICDURq4FJyZ4SVATx1kZupiMvhCrKzx3LiY/m2z8VLMgx9B6xPIPE5IK+TfLp/7Wu/mguvtzoIkZReKeSe2F8DNMhKdxDx4gKx4tn+vf7jTSpx5+VLIKCK13Yy4HEKpDc5ksRET8NRkfGSNhFMHdudyQo36w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746205234; c=relaxed/simple;
	bh=8UfDlGsZHlk4FDrapRM24da0GAJEycZFBZNYMmFNqIw=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=EKQ/nrq/Wg163Yc5GILZLF7jFX/Rn6BS7YxTZiiDVHuNoibB9yKXleiIOBfQUuTlx4CxQ042UpvBSoG+AVGjLk4Z1wYq05YPPL5xo6QFb99FvuwssdxjWVG11csx4nmh7vGrYPS4N4Hu+mP8xDscJb6qaq93ewVnEZAUz7+GZr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uzKYv/vu; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-85de3e8d0adso54081839f.1
        for <io-uring@vger.kernel.org>; Fri, 02 May 2025 10:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746205230; x=1746810030; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXKk7n9uhjCVKeJc/1Py9NKTsgg4IVjQKW9Jel0Mp7o=;
        b=uzKYv/vuLDrsmdGG9s6StbBobS32RjfAbkGxq47toaW02P2cFD8pvvpZNHYt7s957T
         de1Zji22ECNyhavL4eMauHatZefH0wKxAZIkLOYw2oZAIhPXbB9TkTnQPJX8glRT84p3
         O5X5SBd4E87SE3Oo8x0KdC0/rMP921N1Of9cmRrcx3k2Zbj5FUWai/A7BfjVvxg68XQg
         auF7IX4C/9AmWSWPIXnWqEA+Vr3EnUrdxQ7meURPE636/K/shpz5naYX2Asnac2mkepf
         jZxJwjDm5GAqHfSmPP7jpLc+gmAWpnF6vBbHBwqrnWGeqs3K3MBejRFWutA84kDeui7g
         ONqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746205230; x=1746810030;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DXKk7n9uhjCVKeJc/1Py9NKTsgg4IVjQKW9Jel0Mp7o=;
        b=Lzu9Cut9UtKfL4sUW+Zs+sz8TPrz7pNzl/7NysSP6ynzn1TFYhtkrEAzGP1O6yLOzg
         7Na+vjgHYm5o5dU122TQTPAm1uov7TK/+afbzFAqIrm1BTu2sZ5/VkQBPEiXVGL9Gp02
         bp7ROr4h9JQE+MXwZIynmoivSnFrM82Hf4wdEmXODh01deJAMVnCc4MOj61kVByxSGvW
         apLn5I5qvlyKfzmSZEGqGIIpF/+Xzz5mXL/1d2FbwLF3ykqUpQRuks52erEjjtCc6F2+
         MGMqTmAEqN1pVMix9lB7rwUwAM24I/b3aZu03555BUOJHwu2UMNxjLScf50DKTE7yu9J
         mdbw==
X-Gm-Message-State: AOJu0YwF1+BkiuetCl6nK9GBJ8qvFZAEBtII4LQV+uZySc7CqYLQOoHj
	E3K3Ix+VOYbVCvUWpxsuhazAb/bhO9JPfzkTF8n8djY8nq2PsUCunNZqe2ExYRZEjk545Jnej7u
	D
X-Gm-Gg: ASbGncvq/QEi1dlZ2Q1FQgGxvuNEg4525hAzLCW/pf9fdDiWxOxyNLiF5a6g4FQQR5A
	w0MLO/g6NAYj5FyIZpUUC6jQFHOtlpKc5mIdlFawdfYM3OxAmvgEQhJ6fOwsIqg5+X/5b1/l6Cv
	M7PL+mzKeucYSaCXxNQa6q+Zk5uX8kJ2aDYhGYSwwKmBenE45MA+m46rEQvmgJrJ9HN02EIf6+E
	ap+orjG3Lvz+ZaK5nd3rWZpd5ZdG1gNKgZoktwlUN/78iY22+O/SEsTktLPWgDOssu+KDCqmNYa
	0VITWU/xngsPR9aOrqlZ2mOCMAlSgFqrQoZQ
X-Google-Smtp-Source: AGHT+IEh6tlu8G+oJQ+LlgFbfgnEoP9yGFs1p5wiTmvU1JPhxE8fahs9ASONz6KBjPAQIbC1O8ofIA==
X-Received: by 2002:a05:6602:2983:b0:864:ad44:e60b with SMTP id ca18e2360f4ac-8668c24d463mr513607039f.0.1746205229706;
        Fri, 02 May 2025 10:00:29 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-864aa582a74sm63785139f.41.2025.05.02.10.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 10:00:29 -0700 (PDT)
Message-ID: <6526a5f1-f00c-46ab-85d8-2afaeda2198e@kernel.dk>
Date: Fri, 2 May 2025 11:00:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.15-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix, annotating the fdinfo side SQ/CQ head/tail reads with
data_race() as they are known racy. Only serves to silence syzbot
testing, by definition these debug outputs are going to be racy as they
may change as soon as we've read them.

Please pull!


The following changes since commit edd43f4d6f50ec3de55a0c9e9df6348d1da51965:

  io_uring: fix 'sync' handling of io_fallback_tw() (2025-04-24 10:32:43 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.15-20250502

for you to fetch changes up to f024d3a8ded0d8d2129ae123d7a5305c29ca44ce:

  io_uring/fdinfo: annotate racy sq/cq head/tail reads (2025-04-30 07:17:17 -0600)

----------------------------------------------------------------
io_uring-6.15-20250502

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/fdinfo: annotate racy sq/cq head/tail reads

 io_uring/fdinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Jens Axboe


