Return-Path: <io-uring+bounces-9113-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D52B2E4E3
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 051A31CC22A9
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476035B21A;
	Wed, 20 Aug 2025 18:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XAnNv3Op"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F24627A93A
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714367; cv=none; b=LBZGdWO6nZphr9ZWX7nAoTHpwj8ST3PyAQH3RLrb2gwe4ox0BXPdL/ZgGpV6+M/xpH0oo0VruzxyyESSURUGO3sIyN/tjNGg457sJzwwC4QU0K4n3YA57Apd1y/SdJoZ//fH2gQKz9VXhWKIpUPih2FQEbtgd7AgD5RbgVPM0qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714367; c=relaxed/simple;
	bh=EgZYdFM+UthMnqws8SF1P15rO5AcoKXCiv8QbPl73Q0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=AYUKm7OebQ4xyAEPZEQBvnAWc0sCRKpo6ulAt4RXkSaEa6jjRt0JMKB9U4KVIdsDeBsCm/Pu201uHtujjitGsq2lcLXmWiJFFCHBYeW3jrms+UacFmv/kfK1++nIiiRLWp5EfGk7d0OL7kDQBeUUE6Oyg0qSSkYUxjHWxycWFk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XAnNv3Op; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-88432e362bfso2210239f.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714364; x=1756319164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=9KgR7+vVan0pbxzW4G9ktWweqSc6xZ1ytWQALwJ9/eQ=;
        b=XAnNv3OpQphAWMJBOfTOfjz0kZafqvCZYakoJ9wXFjdSOl6NVjwAUWMwK4Ttrnxxjm
         O9Mf9MbttLsxjhl26i6O0P2I3D4WozhMi3vhUxn11FPJWpmglxIMVngS5JaTx7YuwN2h
         Frpc+HU/cEWzSt6CEf2ms83+Cqsy8lNyDLBd0r9vyjU9JHqtlhs54DIRZ77WT9k6R2gu
         KqH9KssXxoB7/rHENEuyhctw6FNk2L3oViqYpZUt4RQhuVGbp1TF858PIemgKu8OJzEg
         hYCmyzccdKyRHJq3zGcFE0NsEgF4SY5hfW+CGqWwrXI5PocfSFkKXAfXUpXzouDVyss7
         yYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714364; x=1756319164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9KgR7+vVan0pbxzW4G9ktWweqSc6xZ1ytWQALwJ9/eQ=;
        b=UiWXO/oY1TsOz2DZ+6+i2Ru7H6YQp7eef6HMh8e7I9M/7jtOSNrWJKpp953i1U7rBZ
         aUGPyX3Apf2sMzc+OTg0h6NdXw2USiPjCgsloJLv2/9ZW96yRsRlpbV/IU89OHmaScdS
         +qHC/zCMnvCwwYLms2YfuN4pBqtJIWY3yQGXH8ia8BA8o/U0qRvL/2wsr940ETDgAN9o
         aBOozsNOkbF5yikHH1CbyfX4PG97p21/00D6RcVqjJWXnm/EJ3ERmhQIf/4SOQEydK9H
         TT+GBKuGnoV6/ATDV8/urkSom/GpehRa3pUu4BqYBBZFnM3F6vIg2V2Yan5NKf4QyvWo
         IaKQ==
X-Gm-Message-State: AOJu0YyBzU+w5Wn+2rBpeaxVB3g3cRP9N2iqLBI3SRY29EVepq8BobMP
	z+BYDZ3oRheRj7O0UC1G/7X+eiBscmrXEYq13P2TrMCFrBvW1HbsgHeTBCTT+qEMVB5nquIIq0T
	RDGKr
X-Gm-Gg: ASbGnct8/xe7rb27JXOUpVfgcdF6U42KtHYm50uPNU53FPjqeIbsaNX7bZFKHXZV8Rx
	/Ifo+RBLnCeCx7lg9DcPSE+Hj64sh+68phtYm6UYoZ5QspicIELGlOuaFQyzp2yxHR/T5ixDC/Q
	NVTFaQTerb7iG+NFbLsd4CbfJ0XDMM29cGnpA/ZUkUPfVVfqSYHXxJc/NMRupa2aYX5yMUE29KS
	wdhXO0A+Wm9+KiLIW3Gq0Gj1G+0Gc6ddfZ2r3z9LQqtWdaKTDREVQZtTvq5L+rQCa1o81Lp9H7r
	RkSD+/sCCRMkkYF9MEY2gYkW4vbChSGGXppfLLzKAplQiSMHtQZgdSlk5zIR60VmyMkVINSLJJW
	EUrie0/IjGRkg0fc4
X-Google-Smtp-Source: AGHT+IGStsYA/lV5jgFdfhWojND1+cruieo1zAY5LqE69DcYBF1ox0QyO5StxlFIOhNmokAj3GxZDQ==
X-Received: by 2002:a05:6602:6b0a:b0:875:95b7:c0d6 with SMTP id ca18e2360f4ac-884718431a2mr847467839f.2.1755714363627;
        Wed, 20 Aug 2025 11:26:03 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947b3666sm4217951173.24.2025.08.20.11.26.02
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:26:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/9] Move io_buffer_list out of struct io_kiocb
Date: Wed, 20 Aug 2025 12:22:46 -0600
Message-ID: <20250820182601.442933-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

One thing that has annoyed me is that struct io_buffer_list is inside
struct io_kiocb, as they have potentially drastically different
lifetimes. This makes it easy to screw up, even if you think you know
what you are doing, as you need to understand the intricacies of
provided buffer ring lifetimes.

This patchset adds a struct io_br_sel, which is used for buffer
selection, and which also then stores the io_buffer_list whenever it
is safe to do so. io_br_sel resides on the stack of the user, and
hence cannot leak outside of that scope.

With this, we can also cleanup some of the random recycle points we
have in the code base in general.

Should not have any functional changes, unless I screwed up of course.
Passes full liburing tests as well.

 include/linux/io_uring_types.h |   6 --
 io_uring/io_uring.c            |   4 +-
 io_uring/kbuf.c                |  67 ++++++++--------
 io_uring/kbuf.h                |  55 ++++++++-----
 io_uring/net.c                 | 139 +++++++++++++++------------------
 io_uring/poll.c                |   4 -
 io_uring/rw.c                  |  56 +++++++------
 7 files changed, 170 insertions(+), 161 deletions(-)

-- 
Jens Axboe


