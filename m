Return-Path: <io-uring+bounces-7119-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BC4F4A684D5
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 07:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12B2F19C3C38
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 06:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A6624DFFD;
	Wed, 19 Mar 2025 06:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="H8BYkdqV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF23A212B18
	for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 06:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742364805; cv=none; b=SaYdJAtUN6zatHUj9NEbjm2pjA1KwfIdcQO03DkzXxZ1a3LoZ784Apg0wRzB2qd5zZcBxF8Jwy5KPYIFQsEvc45R5dKk8yahwF0JU8C6aU4BUoa3DDPqdXByEwYLB3M6mp7FOOrRoCTgKvO5LM9jqN81WZXb/FVswpX/WGUlhQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742364805; c=relaxed/simple;
	bh=fgnAZx38kJQsnATPCXUWNm/xxMyws7K44nXgSeGVxpc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aQiGxjscZrzvpktYv2yOnN8g744otX67M/4bnUpm8WJUgnYMw7vFmEpE/zYwqkrV8h2Wi/MFV0OOlZkiCH072pA87lNxZQjBCzc19kVPAjzW7vee+bwgGuZjjjbSA7VWs3a5HM0v4jGJ4efWfE2sitouDkFOiAoLNOaal7PQm/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=H8BYkdqV; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-300f92661fcso6741409a91.3
        for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 23:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742364803; x=1742969603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CO+tODm7EgareZRu9AnwaIx9J+0t9yuli/V05KPQy4U=;
        b=H8BYkdqVwfZRt1QE5UnlWhpFTE6ENeMyD22hy7dJoA/bXjB8aGdOaUqhIpSMfkaf6o
         XwaUFuUdJ4aK/V8VDWItEn3Dyk7YwS41dEEdMYqZ9SNymxwkk5OU1n1YoGK5QnukTrsn
         h4RE7MfDk9IrH5H2FjAvyQS+lleL3I6UFdZv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742364803; x=1742969603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CO+tODm7EgareZRu9AnwaIx9J+0t9yuli/V05KPQy4U=;
        b=QGDioFfKop6k328A4FNK+t/JK4gRy+fqgdk5ojGRKpDUZtH6H20ELTmvujznQTa78D
         nO9J39VYxIu+Z6ZMpYTSYBv5UbIk1boyKXrWsoyp0ne/XcPEkSxWz+UOjDUYlXyGGUwn
         eXPWHwSg9D6f7cym8T2u1ehnFuBvHqd1dJ2WvcREfLbAHrSCCw8Y5Spx9N5GbbfvfgUY
         p540Xg4ASMcF9mLbvbHxtBzk4SoI5ZZKZ/cNKN9QSBHTfQeiTCu+KMvvnPn1aUfSu8u8
         RkckazpUSmnkXRIMk5pHJ6hFaq7f6qWX/i7AHB4eIG6+3G9ORhNptZLGYrSJtRr8xRwQ
         Simw==
X-Forwarded-Encrypted: i=1; AJvYcCWo8eGdFBqWjOxBIePs2pjtnOfS0ePOY/oBCxTCUh4C+yKm+5tafwAGmGzQxzru+qMv/587HfQEPQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YygR+cNl11KE8PNg0sY1trYokRD8m02HlTcbg7eAHamyJyOX+TQ
	baMzbleSZtExsr9CWl585OhVAICBQ+yWZpMdhie7iYvJ8+FkT/ZR9Yx9RS5Izuo=
X-Gm-Gg: ASbGncvg3HXp1pe5+/Jj4IW5VOdlhBZP7m4rIXGepOcxbrUDa3DO9Op5QI4XD55WLwx
	lyzbGjoWuCvYXLsH51f9PnIm4djr1qoSBzrl2w7XAEV3mpDASBxAUy+5ULBY4R4V/10zC3xXf2u
	P4G/Hn7klvRBVA7c+at3aFmlJ7M8/xmGqF4g/ph4ROQ62GMpZDr7xc/NjLJpJNPabGB4kG65bPo
	WyDAW2x6yZb3mMinPJhN3MHeQyVRS6DiHVZ1YHoiDcJdLpcVXAazALiQU+Lbdiidgk6ENYOnyDR
	hkAK4g1VvR3qxbC04mbW3HgbluNpJ+1qLpUv4sc4/29PXWYAeVmjcjC4ngIM/fpJBtA0YHqLeeu
	Y168G
X-Google-Smtp-Source: AGHT+IEzTDs9bfHyzrbfJB3F7AOGqX76yXqDNjzD+C2zBRo0LVMeiT924eMNXAxSK2Hv3u5HUl7iZw==
X-Received: by 2002:a17:90b:4c81:b0:2ff:71ad:e84e with SMTP id 98e67ed59e1d1-301bde769camr2191504a91.10.1742364802913;
        Tue, 18 Mar 2025 23:13:22 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf589b07sm645103a91.11.2025.03.18.23.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 23:13:22 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH v5 0/5] introduce io_uring_cmd_import_fixed_vec
Date: Wed, 19 Mar 2025 06:12:46 +0000
Message-ID: <20250319061251.21452-1-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patche series introduce io_uring_cmd_import_vec. With this function,
Multiple fixed buffer could be used in uring cmd. It's vectored version
for io_uring_cmd_import_fixed(). Also this patch series includes a usage
for new api for encoded read/write in btrfs by using uring cmd.

There was approximately 10 percent of performance improvements through benchmark.
The benchmark code is in
https://github.com/SidongYang/btrfs-encoded-io-test/blob/main/main.c

./main -l
Elapsed time: 0.598997 seconds
./main -l -f
Elapsed time: 0.540332 seconds

Additionally, There is a commit that fixed a memory bug in btrfs uring encoded
read.

v2:
 - don't export iou_vc, use bvec for btrfs
 - use io_is_compat for checking compat
 - reduce allocation/free for import fixed vec

v3:
 - add iou_vec cache in io_uring_cmd and use it
 - also encoded write fixed supported

v4:
 - add a patch that introduce io_async_cmd
 - add a patch that fixes a bug in btrfs encoded read

v5:
 - use Pavel's original patches rebased for axboe/for-6.15/io_uring-reg-vec
 - pop a patch that fixes btrfs encoded read
 
Pavel Begunkov (4):
  io_uring: rename the data cmd cache
  io_uring/cmd: don't expose entire cmd async data
  io_uring/cmd: add iovec cache for commands
  io_uring/cmd: introduce io_uring_cmd_import_fixed_vec

Sidong Yang (1):
  btrfs: ioctl: introduce btrfs_uring_import_iovec()

 fs/btrfs/ioctl.c               | 34 ++++++++++++++------
 include/linux/io_uring/cmd.h   | 13 ++++++++
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            |  6 ++--
 io_uring/opdef.c               |  3 +-
 io_uring/uring_cmd.c           | 59 +++++++++++++++++++++++++++++-----
 io_uring/uring_cmd.h           | 17 ++++++++++
 7 files changed, 112 insertions(+), 22 deletions(-)

-- 
2.43.0


