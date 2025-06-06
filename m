Return-Path: <io-uring+bounces-8269-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B4FAD09C7
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 23:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56D24172467
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 21:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27CF4238C0A;
	Fri,  6 Jun 2025 21:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uDj/G3u1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23FA1F8747
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 21:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749247001; cv=none; b=eL5jcfvq4E/PjXJYjuRRc6gs5fljaELOLzXbkETUQib7f2OvP+UfegvO6lUSGky3ASgKCRGIrIkGZdghQRH6lBiHBx65BWwqSLHjcydHW7s9VlZWiwB3rom6Jx1qSp1ApogDuLlopkgDTwfXgAlEolr7dyrFtC8OR/68o1t2Vv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749247001; c=relaxed/simple;
	bh=SwxpD4QcwyAw66ANdsO7/78QqvuUjxyxqug3n+Nn/BY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H8nn6Wye3fAHyAdyX5LZ/ZCVLtD4RdDy50e9aPZZdXIVGDq5H66l54XUm/25ipuZPiI4zHIMtXpNQx4djKYlttr2smeASV/fpG6h6APugIqqYLQ3Ik5iJozi9KTrsHljZiwZlxk4s7r6RGIk/7xrN+mGFMTG6yVIdy5lPlgsgdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uDj/G3u1; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3da831c17faso8974675ab.3
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 14:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749246996; x=1749851796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=scOSJhbDbnCyFrI0smqYl+OfLeJuhkf354J7UJAzP1Y=;
        b=uDj/G3u1rmWXGAXcrI2o7LycDINEP1XvDHvKSDV2KNd0wmmFzVeExWU1Cu7Fgy4ZOV
         ApwL/BtIRMuEfS6j+azdxo8LpjrwxU3t6y4PuHNxPcU6Nn/bbNXHwNdvu2EFhdz2M5qE
         twhd6ZztwugohK3s7YKtqUkE2J/g71Mr0g63aCJHBLAvYt9Gsr81IN/3sETQRVblx3bg
         a1FJ90Ac/x5rF1mfMava3ixrXboNSDHA65G8J887bJX3kY1YRCuuzwLDWwgHzknHptE8
         EpSH2t1VH+77c2ivOEzfyKY6YEAF7E27xL2hgcRATvQuRtmYNEy8AlTrJ58EqamGzESv
         mslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749246996; x=1749851796;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=scOSJhbDbnCyFrI0smqYl+OfLeJuhkf354J7UJAzP1Y=;
        b=SH5aZgSo61jNhflHPI9VApwZGJNME9SMU50rZgkHFZz5F8mp2PU3sbdtCeh66rZc+M
         VFWcxWretQoiMm9UcBRIfMdVkL7VdgO33FNf44MoftTH0JhrspEvaVdJjpoL8pvc+eFG
         iVcKWGcAiYyAsn4myOcvuyZetxl5Lue3P6QzJlqYaQ3M/edsn3XRDbHK7wkkSZrcxPUo
         037aUxyfIS8eK92CvMBAgk6SHNCgLxbjhI9Kzlib5hmIVXQNCfAh2j06hXemUXHOu+KT
         gvrvYSRLY3FJlqx7dvWsAMMOUePziAB/xAgt5ES3e+TJRfU8Aau0oGfHzo1CSdfzhc1s
         H3Pw==
X-Gm-Message-State: AOJu0YzD0GWQPnV6hThPk0THvR5Q/Gqd8VWjhAyfgfz96iVnihN5OmR6
	Z5a8B1CnF0U/8PjVWybnFoJwfzeA/YQ3ewVVqgUwbz4NsNj+BMiqRIrxWI8PEwTV5woRwvWKI5p
	KyPWB
X-Gm-Gg: ASbGnctZlGozYCL3vLEZKmkj8DD5j5Bv8c94tFfbNcINu3svcwdl/LwqyuAgVXpkLn5
	4JV1BMdaUkQCdhri2i1O1T4OPnDGJ4V3Z57bwUPt7Tr1jrbEs+pEJHWtybpu62XLJo5taFsh8MV
	7yz4hi/dlO4U3g2oLlrli60giBwYp84QJKCz8ynj/Sv3xlCXXARvpCJdW0HhffPLKi8JUd+Xq73
	qWF23MXe9llF2ZdD4J9CktIaRlLkZsLYPsMx52ZUalNFqZQPhjoxHIyJ6I4Qrh22M1ZD0uAdu53
	RgsltGpw4ejhoNr/NAxacaavnJEYl5yyMfws2MZBKWdQng50LohAfn4U
X-Google-Smtp-Source: AGHT+IHRUR86DWESd9kpESQILfk1FkKwm4Ydhi4KwT4z1wFzdPOpj//3KThJAXtOSBxYo3QINxCAOg==
X-Received: by 2002:a92:c246:0:b0:3dc:8bb8:28b3 with SMTP id e9e14a558f8ab-3ddce3eb206mr64755125ab.5.1749246996386;
        Fri, 06 Jun 2025 14:56:36 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf1585bfsm5735105ab.30.2025.06.06.14.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 14:56:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com
Subject: [PATCHSET v3 0/4] uring_cmd copy avoidance
Date: Fri,  6 Jun 2025 15:54:25 -0600
Message-ID: <20250606215633.322075-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Currently uring_cmd unconditionally copies the SQE at prep time, as it
has no other choice - the SQE data must remain stable after submit.
This can lead to excessive memory bandwidth being used for that copy,
as passthrough will often use 128b SQEs, and efficiency concerns as
those copies will potentially use quite a lot of CPU cycles as well.

As a quick test, running the current -git kernel on a box with 23
NVMe drives doing passthrough IO, memcpy() is the highest cycle user
at 9.05%, which is all off the uring_cmd prep path. The test case is
a 512b random read, which runs at 91-92M IOPS.

With these patches, memcpy() is gone from the profiles, and it runs
at 98-99M IOPS, or about 7-8% faster.

Before:

IOPS=91.12M, BW=44.49GiB/s, IOS/call=32/32
IOPS=91.16M, BW=44.51GiB/s, IOS/call=32/32
IOPS=91.18M, BW=44.52GiB/s, IOS/call=31/32
IOPS=91.92M, BW=44.88GiB/s, IOS/call=32/32
IOPS=91.88M, BW=44.86GiB/s, IOS/call=32/32
IOPS=91.82M, BW=44.83GiB/s, IOS/call=32/31
IOPS=91.52M, BW=44.69GiB/s, IOS/call=32/32

with the top perf report -g --no-children being:

+    9.07%  io_uring  [kernel.kallsyms]  [k] memcpy

and after:

# bash run-peak-pass.sh
[...]
IOPS=99.30M, BW=48.49GiB/s, IOS/call=32/32
IOPS=99.27M, BW=48.47GiB/s, IOS/call=31/32
IOPS=99.60M, BW=48.63GiB/s, IOS/call=32/32
IOPS=99.68M, BW=48.67GiB/s, IOS/call=32/31
IOPS=99.80M, BW=48.73GiB/s, IOS/call=31/32
IOPS=99.84M, BW=48.75GiB/s, IOS/call=32/32

with memcpy not even in profiles. If you do the actual math of 100M
requests per second, and 128b of copying per IOP, then it's almost
12GB/sec of reduced memory bandwidth.

Even for lower IOPS production testing, Caleb reports that memcpy()
overhead is in the realm of 1.1% of CPU time.

v3 cleans up the ->sqe_copy() handling, relying solely on the
IO_URING_F_INLINE flag. And the core will handle it now, rejecting
commands if they should not be copied. This will returns in an
-EFAULT failure.

I think this approach is saner, and in fact it can be extended to
reduce over-eager copies in other spots. For now I just did uring_cmd,
and verified that the memcpy's are still gone from my test.

Can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=uring_cmd.2

 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 37 ++++++++++++++++++++++-------
 io_uring/opdef.c               |  1 +
 io_uring/opdef.h               |  1 +
 io_uring/uring_cmd.c           | 43 +++++++++++++++-------------------
 io_uring/uring_cmd.h           |  1 +
 6 files changed, 53 insertions(+), 32 deletions(-)

-- 
Jens Axboe


