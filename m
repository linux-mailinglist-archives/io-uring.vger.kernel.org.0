Return-Path: <io-uring+bounces-8909-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9231CB1ED99
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 19:04:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B9D41AA06A7
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 17:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F3A49641;
	Fri,  8 Aug 2025 17:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ISldw6D2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C00182D3
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 17:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754672628; cv=none; b=Js3qgGNHZIGCr7lURukpQeI8U+NPVQz3JXPqRT2nrdhHbpORU6SZh2uy2jArerVMY8yrDFi2PN+ErX1rYFwOHVlyeNQi4OJqVYgD3FyX5Ujt6pbi3G7vGZYsUtAlbhhRel+1MagXvmgLejeFURWeZ+w6S/x3YwEimFzTn0q6KPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754672628; c=relaxed/simple;
	bh=1OCgp6xYCJaZgeTvslJ8u71OySTSunwKrKDq5o0WTtQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=axzcHrsqzDoNhJ7hdCU5m5zAS7cG5o8N5Pmzrs5S968b6KolNMyLgGUQlsaUjz5uvGSCpBNRjKYQozpqdN9sTz3s0EGgVb9YNwon95vHVjTOmZB19KRSrWSyHYgL3UXUm4jYRIN6x3yGxGi9X+EHjX5Q21J5ju16ZoKa7q+EPWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ISldw6D2; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-87653e3adc6so65334639f.3
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 10:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754672623; x=1755277423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=lxjxkqajtmx80ovV58Hj87j8rcqM8O6IQ2ctAMiqP6g=;
        b=ISldw6D20k1vbVjttHaOtihJWjyY28CKq4DaMcveafIZIIFCi9h2w9PMVWgvIEM2rD
         ImRCnpYRBJ5ANmBi8ToE16t1smOwA/E4gNBhVLm3aizpk8zZTVvbmwgRQicAWyyDikUU
         A8TjJRIS5OsC2lmEZy+mmQh8MTjQrMnoHMtSMyzQvSd/vipN4vgBwIZD0xGO5CBb2Nbb
         +LSgQq76iqlOY7XlpryWF4OoaDN8nADgBR1z2U+FGruHYrmcxmx3MO7azk+Sy8qalent
         Yc1Md0iVCEsnc4tuSlFH+Afywkgim/e+9dUrk1a4rJSyh/btLb2Peh27I4XOpbBMLbfh
         hHeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754672623; x=1755277423;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lxjxkqajtmx80ovV58Hj87j8rcqM8O6IQ2ctAMiqP6g=;
        b=EjzfT+sPnIE3tx9/QaTEok2FneOSD8rE2eT20MTEmFFO2PjX5HsNct+6fSJKfIuxao
         1kZVAug1/j0xIT4UEo7wyCiLSOUBvxBHLEE6wnVWMJAdMKllxLQXxI+NiGnuV+XzAR9t
         EGaXwYs0Vd/J20xL6vS8S0AYKAT3jVWsgtFGCHK43KKlzT6y4Q+Vl4LdpFoXs03CO9Xm
         mZbEffQiLSG79jUpvvm5nOUn6xkdgnL4ZGJ19o8KHetPssXJtZTgL856GfCTb4GYEVAD
         quntOH416plVwzOgZfMo8nNgIQ2K3o7rkwzglWVlm2KXCM0miCXE52Lzc8Hak9f+02mq
         T8xQ==
X-Gm-Message-State: AOJu0YxgL8TrsSWCqlXV6R3biZC0YsIVL4Im0iFJHPjLJGUs0StUppU3
	Qt1OpqYZS5h93Hxr0TRZHcgbtSicKMNkrWKXzo3f1jEkufROlwdC1HD96MNV623/a3AppiOl83i
	/ETb0
X-Gm-Gg: ASbGncufdecQJb4HR4AHHIjtij/TQLarhmARhrEa2VUcpsdcdREQ+Rk/AC+qZXglONj
	sCW40N7vc+3SXhtW5ZWmkKSGbt5Ajd7moqMAVhsOxcNgMNTxuBPRWWd2sZkQZO3VcvxDJi/90dS
	qHm8pDIkOTUsPZXNzUT+7rBN+fhXTkraLMc9YUc/sEemZ0iEuAZMCcdo/q/XEqlOh/SiG55Q5NC
	o/DzoTUonRXLiFnqsSExgt/zc6wpA9B8p/4zDHvyBM+R9LJLGlKisnoaCRj8ZpkhA0+Z+Om3FN+
	VSlGnWk5pZepANskJLgF2oCK7AkiaqEDi0ulhfae0BtjAJyr8wIO6sSA8ODBTHNrQkwS6LU5EFt
	JCqji1Q==
X-Google-Smtp-Source: AGHT+IHbZc1HA8hLXGdoTdBm2aDmn0nRZBc8iKtscYVY2T47izMq+AgxcO1j5fpXWsmB6gre4w4kmA==
X-Received: by 2002:a05:6602:4808:b0:867:6680:cfd with SMTP id ca18e2360f4ac-883f11b1969mr672670339f.1.1754672623122;
        Fri, 08 Aug 2025 10:03:43 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-883f198d65esm68203439f.20.2025.08.08.10.03.41
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 10:03:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/8] Add support for mixed sized CQEs
Date: Fri,  8 Aug 2025 11:03:00 -0600
Message-ID: <20250808170339.610340-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Currently io_uring supports two modes for CQEs:

1) The standard mode, where 16b CQEs are used
2) Setting IORING_SETUP_CQE32, which makes all CQEs posted 32b

Certain features need to pass more information back than just a single
32-bit res field, and hence mandate the use of CQE32 to be able to work.
Examples of that include passthrough or other uses of ->uring_cmd() like
socket option getting and setting, including timestamps.

This patchset adds support for IORING_SETUP_CQE_MIXED, which allows
posting both 16b and 32b CQEs on the same CQ ring. The idea here is that
we need not waste twice the space for CQ rings, or use twice the space
per CQE posted, if only some of the CQEs posted require the use of 32b
CQEs. On a ring setup in CQE mixed mode, 32b posted CQEs will have
IORING_CQE_F_32 set in cqe->flags to tell the application (or liburing)
about this fact.

This is mostly trivial to support, with the corner case being attempting
to post a 32b CQE when the ring is a single 16b CQE away from wrapping.
As CQEs must be contigious in memory, that's simply not possible. The
solution taken by this patchset is to add a special CQE type, which has
IORING_CQE_F_SKIP set. This is a pad/nop CQE, which should simply be
ignored, as it carries no information and serves no other purpose than
to re-align the posted CQEs for ring wrap.

If used with liburing, then both the 32b vs 16b postings and the skip
are transparent.

liburing support and a few basic test cases can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git/log/?h=cqe-mixed

and these patches can also be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/log/?h=io_uring-cqe-mix

Patch 1 is just a prep patch, and patch 2 adds the cqe flags so that the
core can be adapted before support is actually there. Patches 3 and 4
are exactly that, and patch 5 finally adds support for the mixed mode.
Patch 6 adds support for NOP testing of this, and patches 7/8 allow
IORING_SETUP_CQE_MIXED for uring_cmd/zcrx which previously required
IORING_SETUP_CQE32 to work.

 Documentation/networking/iou-zcrx.rst |  2 +-
 include/linux/io_uring_types.h        |  6 ---
 include/trace/events/io_uring.h       |  4 +-
 include/uapi/linux/io_uring.h         | 17 +++++++
 io_uring/cmd_net.c                    |  3 +-
 io_uring/fdinfo.c                     | 22 +++++----
 io_uring/io_uring.c                   | 71 +++++++++++++++++++++------
 io_uring/io_uring.h                   | 49 ++++++++++++------
 io_uring/nop.c                        | 17 ++++++-
 io_uring/register.c                   |  3 +-
 io_uring/uring_cmd.c                  |  2 +-
 io_uring/zcrx.c                       |  5 +-
 12 files changed, 146 insertions(+), 55 deletions(-)

-- 
Jens Axboe


