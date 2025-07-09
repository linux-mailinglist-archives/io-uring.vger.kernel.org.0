Return-Path: <io-uring+bounces-8635-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30150AFF313
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 22:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 151983A16A2
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 20:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16B21239E98;
	Wed,  9 Jul 2025 20:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DqMA2EL5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA61F202F8F
	for <io-uring@vger.kernel.org>; Wed,  9 Jul 2025 20:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752093269; cv=none; b=Drp+J3P2qxIPI0KG0MbCFe90MZ0zlLLIRMbnFwq5sw4VMbUnr28eFomLac+uFSaBhHQCaFB4rwEkci6WOCMvBtuj+zs8ujQ6efpW+6klAHaW8s1qp0PM3FeG8Fd3jZ0BWD4cbx5/DapHAL739hh87tCvzWazjnrTuHliff0DMDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752093269; c=relaxed/simple;
	bh=Jgvz/ZYqG6okfNTPX+otahK3jXYitakgfbkSoRSrBvc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pt2KqPmc4/k5H23xPwDr9Wb3XL2jbywFm9GMIFTKuy9VXYTuT9egU0OG/u46viYUX/UWZA8JhWtUoNUJ+WzgtEG4HhkcIrJTEKa5DZQ/SLFffTBsO+lwWLGeJGKh6APz3jySrq/FLwo/az+0PysoqJo2FgXwEbPPu2w+DbmM0+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DqMA2EL5; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3dda399db09so2456215ab.3
        for <io-uring@vger.kernel.org>; Wed, 09 Jul 2025 13:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752093263; x=1752698063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=eAnjqooeGSKrai5ZCwnymG9h4cwawOLBs4Opl7OAwhI=;
        b=DqMA2EL52a0kecU7HoA1zEsGqqge/dEIssFcFyIMFSzvFAYHPy7ejFyKBnN0/4QX1p
         C+CVdQ9KLFxxTVqooVNEiXSYAKBXU1KiabFbM1prV6BXQpKOm8VbsNJdkJZlzhCad3YT
         PLdkayKUSBf+lggxjyLNrZuAQKwUtngMh7LZzYYMiFc0YSJAMzDY8erMxjr5aR1Ytqj9
         hnpG5WIDPgmnsObgVna9ICA/cNcba1pMWcf7DikU5REwtqB2qsUgclEx+3OTJdAdb2VX
         Nv5m1/UiGv1PL2wnpT+o6qkvOXLCG+vEWN05du1qNzPbLC6mJoDsFpqgvPggA8twG3RE
         mjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752093263; x=1752698063;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eAnjqooeGSKrai5ZCwnymG9h4cwawOLBs4Opl7OAwhI=;
        b=stwJh6cNqMZ92qKFMKMjD0H6ojPQ53GujzlrrgxwOEExz2+nxvjRBTyXfy9lz4IZOe
         TAZJndVC+ZoJulgqalF2X8NU+Oel28YxssGTCewaMCIWfq/lhIwToB2gnim1ZVeqYK/5
         74lwvncagQ7tmmBVEy/1UGFe6QJL6SIIeBaPpNzqiGvdlaU/0Zt5232/lffe42hw1Fg6
         pm3/2ZA7pRcaNQAey65vVw90kkhJ0HN3kn3ydauBhoHyowFDenAme1MgzFUUbGsgAbe1
         fD8qZ+/karoLS2Qke5hp83hvwddCbYrMwc0/4Brt/7sTfMCD7Ke7Z+9pKFpq+pwa7ZH6
         p3MA==
X-Gm-Message-State: AOJu0Yw7JHZmYfpJBkyGtuBfk+f6/Q16xDYgOTzd77k5wpwE3MN/7sjx
	LjW/Zj4DNjjC2MtY08XmOUDc6qUQLIGQIgywpdoY6tETk4p6KGBgjTs0+YBaDcFPJPYTOdiOrtW
	NVW9l
X-Gm-Gg: ASbGncvBLPApJ7m+qDW1a5x6I0tbJZta4blZV5AagITJBf4mMZLnBRMroC8UgXa3atE
	Fucqmh5NR+B57FaorqsjTQyX2Ejq5Uus6Mtk0WekNMTaniv3OVqFGqytoBrNlpE2JB+peOZ8Mre
	gwjoeZ65zbh+qprEUo5uarv+jXY/Q7MqNDYfyte/iDPkPnnjP00xwOqLWPOsaxP138IDS8P4Vkg
	vcH94HeiczaHolxW0swDrvfi0oekZyp7sZt2IKfylU2TAUuo5xSc+5ixpNgvgEwkCg+kFcLI/He
	MWnj69fY5stHEgKbKJ+H57FqkJhjUDCUqo4zEyY/ZMeS
X-Google-Smtp-Source: AGHT+IHJWFtijNIYmt2tqjNU1lt+lZtoVnniq0+UnRD6tlcF5mPMLm8/14Wkhn69jb1VbEzf3vBwzw==
X-Received: by 2002:a05:6e02:2167:b0:3df:3eeb:9dd7 with SMTP id e9e14a558f8ab-3e1670fb2bamr41658445ab.19.1752093263177;
        Wed, 09 Jul 2025 13:34:23 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e246229f5fsm125965ab.50.2025.07.09.13.34.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jul 2025 13:34:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2] Add retry cap for multishot recv receive size
Date: Wed,  9 Jul 2025 14:32:39 -0600
Message-ID: <20250709203420.1321689-1-axboe@kernel.dk>
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

 io_uring/net.c | 71 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 54 insertions(+), 17 deletions(-)

Since v1:
- Get rid of the need to check for flags overlaps and io_uring.h
  addition, as we can just document that the upper 8 bits are for
  internal uses. UAPI is only lower 8 bits anyway, as the ioprio
  field is that size.

-- 
Jens Axboe


