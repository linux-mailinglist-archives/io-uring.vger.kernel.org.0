Return-Path: <io-uring+bounces-3673-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9884799D891
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 22:54:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D60AB21A5D
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 20:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F85526296;
	Mon, 14 Oct 2024 20:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="o+59BbRL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D1D1CDFD2
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 20:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728939265; cv=none; b=E2n5HkDXXTaLVcjUGCuPmHjb7AMc8B+MsUe84Bcu4MJ7e/5Q2rODL/dAtgNTc4G7pbhPHaU63PkgKLcGgYwqTOXVa2t6g9Y/fchcFs/pbS/Tv1nvd7a2ttdVXFjWCTOPXYD1MQo4flBkQR8ck9DjEhO/3v1zrof0N64Y0cPZBos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728939265; c=relaxed/simple;
	bh=YsC3obUOxg+1W454xWY39EfwjgREvS3qabhzmGO8fec=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=lt85JUsbTWxeN+W3bmRHTcx/GyB0eUqvTMFPOywfI74WQsALAcYwEIiuwrT+f/3p39/FKCqQvBEhTxDucLgvWTs0qC4JYF82TwUX0PYM5Je3rI/C591YRaBp1zT+9X3gpVun/zOX+FEOKGF6HZ/Bh+VKeqzWhCLyt5b2zN5KMO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=o+59BbRL; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-8377fd760b0so142675739f.2
        for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 13:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728939261; x=1729544061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=GS1JL/r+apF2SHVWJVZSnvu5zZ5DO1P5cuMmTmqX25g=;
        b=o+59BbRLUSfPRjNajdrrlZ/y1obdjjow7Bme/I97lRfELuqnVPOMD6fRJNo7hZ3JCu
         qTF3AWVPzBp/AkQT/M0xMA5xymOhck2Pf7oWZ1mcbfmbyde8WJ6tKo4arO7weIGUM3zk
         l0jyYlpm27+CRE4KGj4+3Bo+akRf8yfemW3sA4Xa7PpmYj5tyY40fSG2QyYgggyGGQ7F
         rz0gEylMwQQ/9TxZPuBij0hx2/c8ORGcKsl4hjle43sDkhiDT126pWoqMsSsVQy4Ly+P
         Quh2n44Es/I2rVN1QKDd61ajXybG/XNsqF8lHN29Zzn05luAw0FnhbyGC4d1GCom5azG
         PcyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728939261; x=1729544061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GS1JL/r+apF2SHVWJVZSnvu5zZ5DO1P5cuMmTmqX25g=;
        b=w4o2IAPT2VUgyQ6UBdHkIwaPEXdV417qg0nKLEYy9646asfajWF7lb4g45xnijCoPC
         5nWyG4wbO4n0VKhaFYcS2OU4nETeWOHySb4CbI13hVTFrbN7sSirgecdPI0vRiZmUNe/
         pXU8wPHOt5ALo9y5ce1FqYqfYI3kb5PhcBX1vnnzW2w2GYeJ5kFK8VKUHTwUhS2yoM8k
         9aM72l4Inadd0vST257bgXLIi3POhiCXtYcQjuW7/JJ2/9QRfh4YHT6g6ak/6DP+SRim
         Gx+GR7yP5hRb90xDVfKretLxcr4CHWgYDrJtVNcP+dC+AvLRDP3vgeUf0AiC5sD7ftJa
         4HXA==
X-Gm-Message-State: AOJu0YzyM2MjLJAzp17it6bOM36g7lOVmc2rsKh3vlAfNdLHr1fUwVTi
	kWq3gp4gcYmcKtIJvSwUZOuo2esRpOvVa55Utnt9XsZ7Cv8ZZ8xq3zd66MMKs3YayqA5a5QU8zL
	v
X-Google-Smtp-Source: AGHT+IG7BXL15H3t/jchieUEhV/7LTQRCflt4+GCpoIVi29LygnPrmS8OUtfjFhOPLEP4Q43Cet5Tg==
X-Received: by 2002:a92:c547:0:b0:3a3:4b10:65a4 with SMTP id e9e14a558f8ab-3a3b5f6ea15mr100713695ab.9.1728939261048;
        Mon, 14 Oct 2024 13:54:21 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3afdb3629sm62644895ab.21.2024.10.14.13.54.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 13:54:20 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/3] Add ability to ignore inline completions
Date: Mon, 14 Oct 2024 14:49:45 -0600
Message-ID: <20241014205416.456078-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

For request/response type scenarios, it's not uncommon to have the
send/write be of less interesting than new incoming recv/reads. Yet
it's not quite possible to wait for only recv/reads when an application
does:

io_uring_submit_and_wait(ring, nr_to_wait_for);

or any of the other variants of submit_and_wait() helpers. The
application may attempt to count up the sends manually and include them
in the 'nr_to_wait_for', however even that isn't infallible as that
would also ignore failed/short sends/writes.

This adds support for ignoring inline completions. Note that while this
doesn't catch all scenarios where a send/write can complete, it does
catch the interesting ones - the ones that complete fully as part of
normal submission. With that, it's possible to simply ignore the
expected inline completions that naturally happen as part of a submit
and wait scenario.

Patch 1 adds the general simple infrastructure for this, and patch 2+3
adds support for send/sendmsg/sendzc. For those, they have to set a
send specific flag, IORING_SEND_IGNORE_INLINE, to have it be enabled
for those requests.

Comments welcome!

 include/linux/io_uring_types.h |  4 ++++
 include/uapi/linux/io_uring.h  |  8 ++++++++
 io_uring/io_uring.c            | 12 +++++++++---
 io_uring/io_uring.h            |  2 ++
 io_uring/net.c                 | 16 ++++++++++++++--
 5 files changed, 37 insertions(+), 5 deletions(-)

-- 
Jens Axboe


