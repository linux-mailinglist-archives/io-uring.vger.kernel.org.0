Return-Path: <io-uring+bounces-8548-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF4FAAEE966
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 23:18:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B94077AC824
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 21:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E039D1EBA0D;
	Mon, 30 Jun 2025 21:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MR7mYUq6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D8F4C6C
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 21:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751318280; cv=none; b=fC+rzdltBmprO6XWuuityVqc6W1PqMnOLlLi4mpFr+QqNs1VyYE8K536yjbnz4GLa/ahrxDW1YiDDGfx3Fy3rkkECv+s9IChyG5dAQFKdooMrKWs5v2FzCHQISdrf3p7WbQYR1tCenozATlMcH1t/2hyTZghAhzH3pKXcpWj4ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751318280; c=relaxed/simple;
	bh=PljMagKfmVUxSYtfcxJqQOFMOXGeE8BfTFQreJ6fe8k=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=DXJiLLE1mr1X3Aiaz2ozdq4rWPhvSCGpzV88sTRuxSPmiZ+qRTtKKFlXXeeazjbVdh6JxY9//6WixSowL++uZJeP0JXDrcwdc/mRKwdULXpy0R6edoPSErLa88Z923/RB40CWKGN1F6wW6QqpDPHt/CDJXrJiLOQSNlhd7D0eGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MR7mYUq6; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-86d013c5e79so219617639f.0
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 14:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751318276; x=1751923076; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WK5rF4c2HI2707209NHlKkcmIv9uHBYuGBwf/eLCZOs=;
        b=MR7mYUq6SpfzO/C2BAOx247lIDzWghlWeANjHVuNmYge1VuN0AQ56glKiKNsZ4k+gO
         W2KhG1aVxmPPk4TgLydBXUWwGUTce8rbYP4dy/nQ2wZOwaQ/u0os6DY/iy1BmAWdY2gp
         emL9AjFn9VifeFDmQ5aLqVIX1JUTA6+Ibza908F7ftvCnDGymHUjzH3t4vT/E3ZIdbN5
         HOLiUsLQ4xQpH811Vwjfu1klsGCiyPDlkpUda2fbIMlsvgs8tBDyhm/0xQB8DMLpfumA
         D5SBnh4ckaV4neEWhUFpZ3VKK5cMY02hphXSzj3+rQxv5ti0w+zR5c6kdVMlpXcZOzKX
         AEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751318276; x=1751923076;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WK5rF4c2HI2707209NHlKkcmIv9uHBYuGBwf/eLCZOs=;
        b=CFPGvkLeD8RzERTa84tStIt9SiH3Fn4/RH9/ss/ybMnUybBgYD3hIohds3zpOoK3g0
         zGfOHRjGXigATpTqErgTYwP5izJKnmi2jr2WSSze6Xg9BWdIq6xwSR4l38w1blA0d4Vk
         +p9ixRbaS23QOs7/TdKuNMlzEv2qnDZ8TossOMhUBMoJPAixTuoAdPs/XQOB9/aTH5a+
         mikUgEpdGRLsdOeZu2+4Aan1JcpecUucJka3E7VyIG06eqH7szcn0zuev/sfWBaCqzcE
         E4HuK/Qf+idCvAO4MGnu0pvudFpLlM+vRmzx2dEyeWS01Aav05u+sJlL16oWZpB8EyNs
         IFcQ==
X-Gm-Message-State: AOJu0YzRzFX2TRlOnkadnEFSn+KSTyo78Ae72zGskSI+XwAIh9aidZfR
	NLpmnzYN4EKCXpSH7sa1JFF87jK0dIZAcAd+Y9BaQpn7AqEcVIn9B5/LJL58810abhSf+AUgLML
	hdr2E
X-Gm-Gg: ASbGnctjWYyvpKdCth4nx+GRIb2PMCOxy9J8nQE5Fd3wXNfmbqsbcbbVJ4YmmYgBFkH
	KXtVfTQfzwLGZmp9mapemIuwUIMs/qb4ErWO1Y6CkaOHx9YlVDxECD3poGft2BI5JZu355vE+pf
	LRWW6+qkRqC6hO/Fca6wn/ae7mf/MJsXZUvH7VSBGqCTf5pSBbAfTcafEayqpm64SQ72TLGaj+y
	EZynhHI2FGrKVT3kIbOJUuRkbZz22BVDTeH/FJ1zI6gaY+3hVZH/BvVbkjDRVtzdrzd2mmkpTJF
	l16a9YkIkqxXt4zTPFVP9M9gUVslZEtRjRNK4KzxpbI2gsDTSeyjAjuG4uk=
X-Google-Smtp-Source: AGHT+IHilX/6x33sSM0wQaEUiGrl+brEs7aEVQ6fkjKSbo1BwhM3sbesKBfvdh7OQF75Kt4bagukDg==
X-Received: by 2002:a05:6602:7209:b0:875:bc83:45e0 with SMTP id ca18e2360f4ac-876880d9222mr1625390239f.0.1751318276623;
        Mon, 30 Jun 2025 14:17:56 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-502048959a7sm2170806173.35.2025.06.30.14.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 14:17:55 -0700 (PDT)
Message-ID: <c80c82d7-5727-4b8a-b995-2de1d5733103@kernel.dk>
Date: Mon, 30 Jun 2025 15:17:54 -0600
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
Subject: [GIT PULL] io_uring work-around for S_IFREG anon inodes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Sending this one out early as the patch that broke io_uring is already in
6.15.4 stable, and I'd like to get the fix included for 6.15.5.

tldr is that now that anonymous inodes set S_IFREG, this breaks the
io_uring read/write retries for short reads/writes. As things like
timerfd and eventfd are anon inodes, applications that previously did:

unsigned long event_data[2];

io_uring_prep_read(sqe, evfd, event_data, sizeof(event_data), 0);

and just got a short read when 1 event was posted, will now wait for the
full amount before posting a completion. This caused issues for the
ghostty application, making it basically unusable due to excessive
buffering.

Please pull!


The following changes since commit 178b8ff66ff827c41b4fa105e9aabb99a0b5c537:

  io_uring/kbuf: flag partial buffer mappings (2025-06-26 12:17:48 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.16-20250630

for you to fetch changes up to 6f11adcc6f36ffd8f33dbdf5f5ce073368975bc3:

  io_uring: gate REQ_F_ISREG on !S_ANON_INODE as well (2025-06-29 16:52:34 -0600)

----------------------------------------------------------------
io_uring-6.16-20250630

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: gate REQ_F_ISREG on !S_ANON_INODE as well

 io_uring/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
Jens Axboe


