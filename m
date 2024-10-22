Return-Path: <io-uring+bounces-3884-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D075C9A9609
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:12:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F8F21F21E63
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE187132124;
	Tue, 22 Oct 2024 02:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hj+C6cK3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A5612D75C
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 02:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729563127; cv=none; b=A+iogIx42Lq/guFLjuZzbLMwMy8lLaw0nD7vmk3VeBhzq/6fPdWpoiC5m4qeL4UkXep7sWVH3RmlbeKq5EjsyhGLD+T1jZ0tsregeLSMfK+A5lthvZVxdw03ayvyaX/eRajPz2msmAtXn3mT9G7v/WOQ1rL5Er9vpZYSFQyB4bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729563127; c=relaxed/simple;
	bh=5KZIL7Hk0EoWhcdtUJWkQBUWcFCTpVZ/ukH+5QMnqlc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PtGlEp90grFkSy+RFZsVfwOcQvZwvnryrymWpTwAlRk4EtzD1Rs/N0kz0JkvSKDlKNgh3cQPv9oIxztbQT5MS8rURKJZl3BkvVf0n5g5a0LJv5m6BE0gc4xDnDFc8hHosYCnHVLJ0VhF+Lqt23NaE+y81Ei8u2fWbnFLNm9xwl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hj+C6cK3; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-71e4244fdc6so3576923b3a.0
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 19:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729563124; x=1730167924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=0irCcWrnbcSv70Aqo0n7MSeStSdhsJdeypA8tFQ4U9A=;
        b=hj+C6cK3GCuVuA1PDs6su8J14tADHrDnY/qsjHOeIW4jKrJSRAc0CKKtAuKTscRkUZ
         hSorVbcNouMF8xASq6jV1Fdghm1mBh9j5tbbQgTvCeexQOB0EOdWD+Odv8vpsPBOTmnP
         MpDx9wU8Wch1AK6gAtYY4arBAVmEKM1Hj/0peKGwAKbzbSWxgx+VqdyljiOGosvLW44X
         V5lal9puLQciittgQBMm/KQxuquADV2x6x2SnLTyUJ4Sx4NMJn5PGtMd6+o8z1GLXRfc
         t7E83xv9PY6Vu0wVRpeNKsre9fy7Ab5SXHO+sA5NRk209CrTh1dMt/4+Zr79G19wKSey
         FRUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729563124; x=1730167924;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0irCcWrnbcSv70Aqo0n7MSeStSdhsJdeypA8tFQ4U9A=;
        b=WM9cxMsvzCV8DFb6vt6PK0BYjb6cTaboBjmzt/bZPaBhYrokdhfvEE3KeiuTIaIkwW
         91au9DKAaNnGkXKAIq4uvC0aDzlswnkbX68q4jTZNgA+kH+YmzI35ZXqFQtSjr32IDPA
         QkwAXaHsSWUtkGgeaTO3aDEzepuFTI1DPYzCQSC77klfZNWVThkVPJTYx7/Z36BrxPqC
         JgxiDjEMYNdXAnNvbOC+XYbsk+w7X3z/iS9/zRaHYkfEUEyfU4cmy+eHcJx2C9AKlSPK
         wHlNxK7cnWyq/5ke5McA61CekCYy7qHFdMOWfj4dD+lbXXX4jkBDFdb/dOeNjPa2MmOu
         WF1A==
X-Gm-Message-State: AOJu0YxDjoWMgxabF28J4XzYBZMATd+FvavKWwxSXABVYVTCViRf66qu
	L4KPRBCk/cPwL5yTIagcj6DjhCc46uYLNzV29m29cUC52jmJ2cgOJfmbfcemK6ADkYksMLahBqB
	v
X-Google-Smtp-Source: AGHT+IFUdlTeujPpD3gS04dSUYIRt+IpBvWWq3hshCGZ2OcJPR4xUuVP7Q6f2ta8R6t1yAQcdEG3Qw==
X-Received: by 2002:aa7:88c2:0:b0:71e:6eb:786e with SMTP id d2e1a72fcca58-71ea3168e05mr17616726b3a.13.1729563124448;
        Mon, 21 Oct 2024 19:12:04 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec131477asm3747060b3a.10.2024.10.21.19.12.02
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 19:12:03 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/3] Add support for ring resizing
Date: Mon, 21 Oct 2024 20:08:27 -0600
Message-ID: <20241022021159.820925-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Something that's come up several times over the years is how to deal
with ring sizing. The SQ ring sizing is usually trivial - it just
controls the batch submit size, and usually it's not that difficult
to just submit if the app fails to get a free SQE.

For the CQ ring, it's a different story. For networked workloads, it
can be hard to appropriately size the CQ ring without knowing exactly
how busy a given ring will be. This leads to applications grossly
over-sizing the ring, just in case, which is wasteful.

Here's a stab at supporting ring resizing. It supports resizing of
both rings, SQ and CQ, as it's really no different than just doing
the CQ ring itself. liburing has a 'resize-rings' branch with a bit
of support code, and a test case:

https://git.kernel.dk/cgit/liburing/log/?h=resize-rings

and these patches can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-ring-resize

 include/uapi/linux/io_uring.h |   3 +
 io_uring/io_uring.c           |  84 ++++++++++--------
 io_uring/io_uring.h           |   6 ++
 io_uring/register.c           | 161 ++++++++++++++++++++++++++++++++++
 4 files changed, 216 insertions(+), 38 deletions(-)

-- 
Jens Axboe


