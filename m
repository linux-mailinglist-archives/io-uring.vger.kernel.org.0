Return-Path: <io-uring+bounces-1959-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA018CEC94
	for <lists+io-uring@lfdr.de>; Sat, 25 May 2024 01:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4EC9B21861
	for <lists+io-uring@lfdr.de>; Fri, 24 May 2024 23:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55D685631;
	Fri, 24 May 2024 23:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AX39pQwL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0820D2CA5
	for <io-uring@vger.kernel.org>; Fri, 24 May 2024 23:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716591912; cv=none; b=NMSafd87DOEp49uk87gsxge8P2j/djln5Gr6CJ99rSVGKV+wZyl1amRzaSvKjudFEVwuXxrml3+GqhmluXeOQ2xpPx1xFD3uXCFgOWmdcIpgn9kBm3Sdpbm0ZIrCW0/B6x7UljJNfCY2KlRIdryr90tr0rUarq83GdkH7FAYW6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716591912; c=relaxed/simple;
	bh=KYou+MDl+vtZBzYdPpr0T9NYYjvpe8Q6+tXKu8cKe1s=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ktC9YXsfVmKzRqGRWrHdFvwmct5tt46RthSK2zcGvH21qcvFw5O4zHdNY/jI8WUi9AP3/mJ1idbZMJemuhAYugFrqK6v+Aw9CdFvNWdv4Kgk0lANqiyYOrlX6pYIoR0IkZwJANJ3y5w4weEq7jxq5LcPLcjWv/WH73cgHqzsENw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AX39pQwL; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2bdf1f8949dso352773a91.2
        for <io-uring@vger.kernel.org>; Fri, 24 May 2024 16:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716591908; x=1717196708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ljYDHheqET3DvojW5TqZ5LFFwY7+4BST3j5PUZZOXHE=;
        b=AX39pQwLv0C//WuFbmHxVFKJKcYI7ufmlYUhKA682G0N2mb9tmWr+XwWHKTyj8d54o
         QXLvb1cHd/qPGxLkST1kLD6gEzW9RqdAtjRy+i7IFXpun8Vwge+OqJh1/fxza9gldnpT
         Q+ZIHuY1g6FMqGgnMqlbKB3y58FWfVaM06ZiSjMA+Yxt+cBK6uyuDa0hUCT7FGj5rI4z
         TYGwyTXQHPhzYU8OTrFmU+E9EMTkZ4ZkEsp0PmPUQMAahBOd5WW+dFQh95UFfguZOK9m
         oKX2M0rAf0n9z/8kLLRypNnF3fBBXIBEvfIdg+zadbOkcspLNhz2YtwphzcD/Sbuzi2b
         GN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716591908; x=1717196708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ljYDHheqET3DvojW5TqZ5LFFwY7+4BST3j5PUZZOXHE=;
        b=Nj4fjlkhpb5wyuJ4S6p/2kO3f0ADLYZ08/tTAWXOQuvmMub3/uRqOfATbMT4tClui8
         /r+LoeKTgcWEo4utW8aTg3JfHGRoU7fxpL4gy9ILc5q/h/lgenh9km+vFZ9kTySXSzVe
         UlqFzmQfssIbOAwgZea0lVwV/r44fmMlh8/F30cc6MlSP7G84jUjzrGnYooDOcNkCCi6
         bjWfbJlgVzF0RI+7AZXQORYxf48T0ySWircya1W5WmIoMlEenCt8ZQ84srYPUHtMrFzl
         y6AVM3PVkQKb7uJQ28hvIYR+3cu9ZeSljZryM0fntl0vzmJ4YoWARPOz4FhncrtLLwng
         T5/w==
X-Gm-Message-State: AOJu0Yy0Z3JFNflLiIcu7FL9WjPFoWUFY7FL9jTR4J2RwP1Bo6zyd58x
	CrZhcFXFHDgIr95XawggdsvB1gFtZtGu6EZMxa6aLtO7X1nmD6yxT8bGuJBOTgcAdE5rLaO77bM
	K
X-Google-Smtp-Source: AGHT+IG9WMxX/PzeH8cJlj1NZ2E2zO2eSa0bXOrh+RQNyuIYvFCWmHUwZvi7D7iyYgCVbYMYRj7pFw==
X-Received: by 2002:a17:902:6545:b0:1f3:4d8f:e5f6 with SMTP id d9443c01a7336-1f44993169bmr40283755ad.6.1716591907544;
        Fri, 24 May 2024 16:05:07 -0700 (PDT)
Received: from localhost.localdomain ([2620:10d:c090:400::5:7713])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c7c59besm19147625ad.106.2024.05.24.16.05.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 16:05:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] Improve MSG_RING SINGLE_ISSUER performance
Date: Fri, 24 May 2024 16:58:45 -0600
Message-ID: <20240524230501.20178-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

A ring setup with with IORING_SETUP_SINGLE_ISSUER, which is required to
use IORING_SETUP_DEFER_TASKRUN, will need two round trips through
generic task_work. This isn't ideal. This patchset attempts to rectify
that, taking a new approach rather than trying to use the io_uring
task_work infrastructure to handle it as in previous postings.

In a sample test app that has one thread send messages to another and
logging both the time between sender sending and receiver receving and
just the time for the sender to post a message and get the CQE back,
I see the following sender latencies with the stock kernel:

Latencies for: Sender
    percentiles (nsec):
     |  1.0000th=[ 4384],  5.0000th=[ 4512], 10.0000th=[ 4576],
     | 20.0000th=[ 4768], 30.0000th=[ 4896], 40.0000th=[ 5024],
     | 50.0000th=[ 5088], 60.0000th=[ 5152], 70.0000th=[ 5280],
     | 80.0000th=[ 5344], 90.0000th=[ 5536], 95.0000th=[ 5728],
     | 99.0000th=[ 8032], 99.5000th=[18048], 99.9000th=[21376],
     | 99.9500th=[26496], 99.9900th=[59136]

and with the patches:

Latencies for: Sender
    percentiles (nsec):
     |  1.0000th=[  756],  5.0000th=[  820], 10.0000th=[  828],
     | 20.0000th=[  844], 30.0000th=[  852], 40.0000th=[  852],
     | 50.0000th=[  860], 60.0000th=[  860], 70.0000th=[  868],
     | 80.0000th=[  884], 90.0000th=[  964], 95.0000th=[  988],
     | 99.0000th=[ 1128], 99.5000th=[ 1208], 99.9000th=[ 1544],
     | 99.9500th=[ 1944], 99.9900th=[ 2896]

For the receiving side the win is smaller as it only "suffers" from
a single generic task_work, about a 10% win in latencies there.

The idea here is to utilize the CQE overflow infrastructure for this,
as that allows the right task to post the CQE to the ring.

1 is a basic refactoring prep patch, patch 2 adds support for normal
messages, and patch 3 adopts the same approach for fd passing.

 io_uring/msg_ring.c | 151 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 138 insertions(+), 13 deletions(-)

-- 
Jens Axboe


