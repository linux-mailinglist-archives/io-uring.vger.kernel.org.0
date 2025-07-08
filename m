Return-Path: <io-uring+bounces-8615-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBFBBAFCDF6
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 16:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D5221886693
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 14:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E9B2DFF3F;
	Tue,  8 Jul 2025 14:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HmQEOeF0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E850F226D0A
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 14:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985555; cv=none; b=hctECrL/kdCkH90yV3WulzeVN92lc7gA035VnhXzLSZgDLtakN+wC+HCzYJeJ3VlBFe9U2toG+vHRLKwhlXNrKKQ7qazsqbUk5g64xSEYVU1jdTOetIkYJuXGgNOm5MazDkRcrRewKqpc+AV6HCeKqWfZQpuQuc041HpiDWzFx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985555; c=relaxed/simple;
	bh=UKvGIB8r/OcssRMw8GSD0wq+V/+BgWhsLd1p1D4GtnU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=RekdUakHl4oYjulx7wQPOVFP3+TiF5r82fka+6Ko6TwCyUI+K+q7dRP0ZRIbWNXocN7Os0K0vU8UNkagu+PxK/fPArIl190DpFF34AVcYGOQVTai6C+S+kg27mnjXMmXwXDumq9SSBdKpSKmZuppk1TAi6w2Jxnhv2X6pafRDJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HmQEOeF0; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-87640a9e237so395604039f.2
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 07:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751985548; x=1752590348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dDbIXrfUOee2rj7PvhdPy72O58uVbjGCgdPxAsILAXw=;
        b=HmQEOeF02JS7tmEgsYreTLwGQYde5T6Udb0CCB1xGU6R0KZneYuNI8Pc7QWL2ynoEA
         D2j2g0RjWLy4/8zx3jwUyu/L6U4z/S3Qsohv51rFbD10tGruXGwGVUgyPN9/Lsanpjp2
         3uWCKfpNmkWraEYsw7GP8mjUO1T9bc7CnRqfM22Ynskn9j6faQ/VN8hVumTZsF0thDUM
         RR5t2+ov/qvWqgQnoIGRYObbmS+Y469FUMrfEwAU0Czktf6jQ+cQQTeH0VTQB8isUc6Y
         /o5n+N9hHbsQVM0TDFaxi65hmV9DOW2+JEgpOs0OGbf/+ytmUP+PaPOg9Lmo4i1BR2Bi
         BvRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751985548; x=1752590348;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dDbIXrfUOee2rj7PvhdPy72O58uVbjGCgdPxAsILAXw=;
        b=Qg96z2hIkwhjlxrOMCnk8OrFhe8XLPfDufFb1vjFfEalk0drA3q3gkASH7xmeWNRDJ
         jrlth0mhzHLh6gUBh/IkHik5pxefxNbZUdEoG3FusXjgW1uzNOWmQnvqkyJBAY3FTkCD
         qsml9adzx8Djh+D2qAr2YUMLLpLzBycUDTX88K4ErXwlKC00jU8XmZEdj8vB10jETsxV
         L7DxEuExFnCSer2p2nDCeJ9F9LyWzciYo5PWtOdiGE8cB3GVOUyYxzYW8GezkXnAFqj/
         JaObiD/Vv/ea/7S2XKiV8aJXBg2X5nM5ZS9muPlUzphxggy1PZJ5Uvxz7Ggp6+PscAZ/
         9p1Q==
X-Gm-Message-State: AOJu0Yy6R3G8VTQAY+nf9ETjT2kjXyaZxIQQrkadr7dnUADgPY1+YU0o
	Khh9vo/AzgwDZt70dwDJ6snFZc9ONmqV4s7VrWf5M+eqFeflCKWr1tcKkKIbGZVDSKWv9VsteXO
	dRpEM
X-Gm-Gg: ASbGnctaU4hYIaWhjeApiFTg96/czEX2nrN32/aVoYGezRsLsL+5CCe6cJ2yWGl9YoJ
	65allWEk14+KtNjGoP4H6x5iAFAm6RAU4fBCEdIWccadooak8hfvrPikf8gHiGKRcypPCCrcTRd
	DZ4hdq+IS03kvK4d3ciTrQvMBUmK4JOsjFZYESiLo+8sKk6n/CQcIulJazdo0I9rPhNSBP0SLXx
	po5nfKlyJIZimK9hBWO8oW/+Fy86PTRMmYYXhuOKzAtvj/365nOonuOkimHtnPLrD/Y3ijucG1W
	nzbPy8KFNmAAlHw3P/f9E2Kbw7kIUKWzZ89/rFU06waZ0/qE5KyJGAEK
X-Google-Smtp-Source: AGHT+IF6T7V+CzLjrwejMgPWTvzjFtj8YZBh81bBVjMr8pVKak2v/m0X/kePihbHxqN/L/iGsi0gcQ==
X-Received: by 2002:a05:6602:2983:b0:873:1c2d:18e7 with SMTP id ca18e2360f4ac-876e16351a2mr1524291339f.10.1751985547898;
        Tue, 08 Jul 2025 07:39:07 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5053aa4e546sm166739173.134.2025.07.08.07.39.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 07:39:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] Add cap for multishot recv receive size
Date: Tue,  8 Jul 2025 08:26:52 -0600
Message-ID: <20250708143905.1114743-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

When using multishot receive and handling many simultaneous streams,
there's a potential fairness issue that can occur. For each receive
operation, io_uring will keep retrying a request for up to 32 times
as long as there's data pending in the socket. Depending on data
delivery times, the amount of data received can vary quite a bit.
If the multishot receives is using bundles as well, then each bundle
can use up to 256 vectors of data. This is good for effiency, but
can skew the fairness between sockets.

Multishot recv does not support setting sqe->len currently, it'll
return -EINVAL if that is done. Add support for specifying the length
in the SQE, and have it apply as a per-iteration limit for each
receive. For example, if sr->len is set to 512k, then each multishot
invocation of this request will transfer 512k bytes, at most.

As an example, this test case sets up 4 streams, and uses 32b buffers
for each stream. Each client will read 8k of data, or 256 buffers in
total per stream. If the per-invocation limit isn't set, it looks as
follows:

axboe@m2max-kvm ~> ./recv-streams
bundle=1, mshot=1
Will receive 32768 bytes total
cqe res 8192 (bid=0, id=1)
cqe res 0 (bid=0, id=1)
id=1, done, 8192 bytes
rd switch, prev id=1, bytes=8192, total_bytes=8192
cqe res 8192 (bid=256, id=2)
cqe res 0 (bid=0, id=2)
id=2, done, 8192 bytes
rd switch, prev id=2, bytes=8192, total_bytes=8192
cqe res 8192 (bid=512, id=3)
cqe res 0 (bid=0, id=3)
id=3, done, 8192 bytes
rd switch, prev id=3, bytes=8192, total_bytes=8192
cqe res 8192 (bid=768, id=4)
id=4, done, 8192 bytes

where each stream will end up reading the full 8k before the next stream
is able to make any progress. With this patchset and setting sr->len to
2048, it looks like this instead:

axboe@m2max-kvm ~> ./recv-streams
bundle=1, mshot=1
Will receive 32768 bytes total
cqe res 2048 (bid=0, id=1)
rd switch, prev id=1, bytes=2048, total_bytes=2048
cqe res 2048 (bid=64, id=2)
rd switch, prev id=2, bytes=2048, total_bytes=2048
cqe res 2048 (bid=128, id=3)
rd switch, prev id=3, bytes=2048, total_bytes=2048
cqe res 2048 (bid=192, id=4)
rd switch, prev id=4, bytes=2048, total_bytes=2048
cqe res 2048 (bid=256, id=1)
rd switch, prev id=1, bytes=2048, total_bytes=4096
cqe res 2048 (bid=320, id=2)
rd switch, prev id=2, bytes=2048, total_bytes=4096
cqe res 2048 (bid=384, id=3)
rd switch, prev id=3, bytes=2048, total_bytes=4096
cqe res 2048 (bid=448, id=4)
rd switch, prev id=4, bytes=2048, total_bytes=4096
cqe res 2048 (bid=512, id=1)
rd switch, prev id=1, bytes=2048, total_bytes=6144
cqe res 2048 (bid=576, id=2)
rd switch, prev id=2, bytes=2048, total_bytes=6144
cqe res 2048 (bid=640, id=3)
rd switch, prev id=3, bytes=2048, total_bytes=6144
cqe res 2048 (bid=704, id=4)
rd switch, prev id=4, bytes=2048, total_bytes=6144
cqe res 2048 (bid=768, id=1)
rd switch, prev id=1, bytes=2048, total_bytes=8192
cqe res 2048 (bid=832, id=2)
rd switch, prev id=2, bytes=2048, total_bytes=8192
cqe res 2048 (bid=896, id=3)
rd switch, prev id=3, bytes=2048, total_bytes=8192
cqe res 2048 (bid=960, id=4)
id=4, done, 8192 bytes

where each stream gets to read 2k before switching to the next stream,
and then this repeats until they've all read 8k of data.

Patches 1+2 are just prep patches, patch 3 implements the capping logic.

Can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-recv-mshot-len

 include/uapi/linux/io_uring.h |  9 ++++++
 io_uring/net.c                | 52 +++++++++++++++++++++++------------
 2 files changed, 44 insertions(+), 17 deletions(-)

-- 
Jens Axboe


