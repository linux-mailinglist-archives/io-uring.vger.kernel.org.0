Return-Path: <io-uring+bounces-9548-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0C38B412DE
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 05:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 472901B2418D
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 03:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 970FD2C237F;
	Wed,  3 Sep 2025 03:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="EBuVi55f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003901E833D
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 03:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756870020; cv=none; b=FCphkJJ+qf+ZVwSR02OEtDmOeyBLJwQC8um08dH8+XLPpOTddw0Tedko9VRPtucxqyQu0ufzg1bbZCh8zNgLBXsHeA25q4CVLKDLRai62TswZeWzyLJSSSoDzYkVyPiDHjU5fYQcXUA2Sxp/kYGosG6EghR8UbB++5YAUdNuDr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756870020; c=relaxed/simple;
	bh=r/lzy9yr6DodEDv6FzqGeWpQUvOquGmOFlV+gYPQqqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a9Ouxw/wjv7T+1UyCumtvLXQXdAGQzOBLKduZAkzUZ3xcRDqq+Pm7NQaCCUXqgHhLNAm+GvvV/SVLfRMdpxbCvB6lLbo0gHu5EAjoILSYbctQ/ZX/hgm1bOhiAaMGlsNXsJqqIncD8AlUv/m+0ZHhrzsLvhQElGF+lKRXphfavs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=EBuVi55f; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-24adcc94338so6273225ad.2
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 20:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756870018; x=1757474818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JS8Y1zJmFurXBmjvwW5K+3pblWnk3elwcS+1Ua//b2g=;
        b=EBuVi55fQFNpVCI4ZnYNmCFKSZLoi1VdzoPNgrdXtNqGsY8mOLZ9Qu52GzLG1uSUVt
         y/2zCbAw1EB7C6hlwKWCMW+o+LTp4KVfEEhmp7GPXrKg3IIycaDWKror0h5uOfVBJm8t
         tcZaxQONNqrCfLtMbd38sfAorMxZMfcZypTelAA5jBZL/hZ2n+bSME9H8usJS7F+6vW+
         VF8nG4PbDw4bvgsMiO6Vc73OZLEnLPqyBmMOPMTLAINfqmkaGw2aMoCOb1jQX1xMboJb
         qgvuOIad+5k87tqvE+aw6Z5/UHYgzgxZUM0QhmO36Vy4hZSMn9Akm3BToQWuI+DYpT13
         b28A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756870018; x=1757474818;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JS8Y1zJmFurXBmjvwW5K+3pblWnk3elwcS+1Ua//b2g=;
        b=NabvT8UPTWi6iuUsSAZI4NMJx+u1/mIB7CDNcjIGpQW4cZTCHMcl/1KLSbAXcZKeDX
         SXzjVN4ywhgY5et07jnRidUc0YeQ+rpR9dQMZHapzaVT43KJjRfVjuvu/9ioOgoeePrf
         F68eRhL59zmWMzcDnoC+hw6iSyC9a7Mpf041S14Yx4YX63ELS4A549i6Weyva2cPT7Cg
         3KlX+VL35BX6AiT3A3+axIH6UFyU9WxB1SFXlhe6HsK7kCzVbGtZdAXQp60aYaDYioid
         xxPgfEezuCSajvcAeiHxiKfGjj6v1TAGIj9Z40OWamPUWBaCB1wkcUd20LyKmYAKZQkq
         lgfg==
X-Gm-Message-State: AOJu0Yy3F/QFNjqReyit5vrhc8/nlYClwXBSzcSJOQoEhKomyiH70ca+
	nWehADIVbztYscs6HsvqdyB9S9bNEig7FIkdpaYvfJU0Y3+VV+UhVowfglodfyq20kdBnKdxfOH
	ZF1fFWtOFZJ97WP3UA80mvRlYga3E0J3mTsN5
X-Gm-Gg: ASbGncsOhMY5hKLv/YAv6ikcIRvMVcMYuJp1GYgUMxvy/sLuJQt6Ft75ka9eAWO+1LG
	yPReHhJduJ6HFsJLKP4pE+G2G9v9Lcdni1sZHTZMG/G5Z0THscZn0hfH/JUXWEMRef88GaUDsJq
	vQ1KPc2lDOAi0+71pY7/OU//DcucSus2X49OBxkVcZ1FCmv8uqVQMXettRm+hYWtDnoozqJYd8q
	fNsdjPvxvZGaWOPMqEgl68XW3XoH48qhD8sS3O33sfcDiXvD4mPxMcqgjWC1SaqWvC028LT+ceW
	rkoFxNWG6N4NU4UNh+7k6LatHNI5ixF17IBkmtHWtTuPcRYbgvUt8Z6LQuMpd1dWuArFItBv
X-Google-Smtp-Source: AGHT+IFFwY4/4dAuWXBzcYZXH0gw8XtEqg0rleZgc9kWYELaDLg0OD+MpPC5wkKXscNxGiaQwzE6G0M4btPl
X-Received: by 2002:a17:902:f792:b0:24c:895a:c7 with SMTP id d9443c01a7336-24c895a0a18mr7870295ad.10.1756870018332;
        Tue, 02 Sep 2025 20:26:58 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-24b0e53de6bsm3163605ad.71.2025.09.02.20.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 20:26:58 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 7E1B234029E;
	Tue,  2 Sep 2025 21:26:57 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 7462FE41964; Tue,  2 Sep 2025 21:26:57 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 0/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
Date: Tue,  2 Sep 2025 21:26:52 -0600
Message-ID: <20250903032656.2012337-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As far as I can tell, setting IORING_SETUP_SINGLE_ISSUER when creating
an io_uring doesn't actually enable any additional optimizations (aside
from being a requirement for IORING_SETUP_DEFER_TASKRUN). This series
leverages IORING_SETUP_SINGLE_ISSUER's guarantee that only one task
submits SQEs to skip taking the uring_lock mutex in the submission and
task work paths.

First, we need to close a hole in the IORING_SETUP_SINGLE_ISSUER checks
where IORING_REGISTER_CLONE_BUFFERS only checks whether the thread is
allowed to access one of the two io_urings. It assumes the uring_lock
will prevent concurrent access to the other io_uring, but this will no
longer be the case after the optimization to skip taking uring_lock.

We also need to remove the unused filetable.h #include from io_uring.h
to avoid an #include cycle.

Caleb Sander Mateos (4):
  io_uring: don't include filetable.h in io_uring.h
  io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
  io_uring: factor out uring_lock helpers
  io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER

 io_uring/cancel.c    |  1 +
 io_uring/fdinfo.c    |  2 +-
 io_uring/filetable.c |  3 ++-
 io_uring/io_uring.c  | 58 +++++++++++++++++++++++++++-----------------
 io_uring/io_uring.h  | 43 ++++++++++++++++++++++++++------
 io_uring/kbuf.c      |  6 ++---
 io_uring/net.c       |  1 +
 io_uring/notif.c     |  5 ++--
 io_uring/notif.h     |  3 ++-
 io_uring/openclose.c |  1 +
 io_uring/poll.c      |  2 +-
 io_uring/register.c  |  1 +
 io_uring/rsrc.c      | 10 +++++++-
 io_uring/rsrc.h      |  3 ++-
 io_uring/rw.c        |  3 ++-
 io_uring/splice.c    |  1 +
 io_uring/waitid.c    |  2 +-
 17 files changed, 102 insertions(+), 43 deletions(-)

-- 
2.45.2


