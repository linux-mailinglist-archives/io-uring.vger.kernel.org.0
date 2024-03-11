Return-Path: <io-uring+bounces-885-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD988878550
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 17:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AFB31C211B1
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 16:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013A64C61F;
	Mon, 11 Mar 2024 16:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ei5Hof0U"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8D655E4F;
	Mon, 11 Mar 2024 16:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710174034; cv=none; b=DYBYYUyrGb2e1qN7FD3SKB66gsj37Pm7+pL5Pt1zD1QnvMFhrPq0qSHJ6lAoFv2RjKyLMDfeSUT7jm28xt5Fu4m3ycH7pfsABYI3GcPEH1YJ2sh4W6405WzKK+I4Wf9OK+mMpJydw0Gs+fLXvKI2xEwP/bDbWF2r0vOi2njEvKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710174034; c=relaxed/simple;
	bh=gVuvW1/Bc6+EpNX+AXK+mHcBp1gRp3p/EOcda8+OhHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aVVdBSIoiJvzbM3SWDlruDygHKsuw2zfciid+RFCaAuFt5nA516lDQHErBtHvk3IJAlsgqjGhgy0FyDUkfijIauhlwf+mUO/IJYMYMAUeCx+x7a6ty8V1Qb0MgU1i535e5I9cSUEzI4PxjMQot6Ut8bsSaUgW7AE29oKD644dXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ei5Hof0U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD5BC433F1;
	Mon, 11 Mar 2024 16:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710174034;
	bh=gVuvW1/Bc6+EpNX+AXK+mHcBp1gRp3p/EOcda8+OhHg=;
	h=From:To:Cc:Subject:Date:From;
	b=Ei5Hof0UIp3Nnjhp/pa/9Iou/w4tJWVAYG4z8iIl+pYz9vdEiBGUBPyKssb4eMK5b
	 tY17mhz0oxPXejUV4gY44ZYMm6mutUd7wDtKsaQXzXdMROCj6mNhE3fytU5oMRcPj/
	 qZvE2ACEDuqOf22egtDy6nAkk/xe0LV1z/liBN2M/u4Qi2/Mt94TKxksY4ELaXmVwC
	 kAkvsxOSEsr4ODKxDW+bBIlg2d8RwqG47D+wB8Q/HUyjcPugfLns2F2LUZnvPjbwpv
	 Yqb7JLhBcnLvcyvz+a27GVFBxyanUsm6ApzAc560WCl4EkjJ44HrxVI5qDlvVYhxKk
	 /4wKJuZ+7UQ1w==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: io-uring@vger.kernel.org
Subject: [PATCH v2 0/3] fstests: fix io_uring testing
Date: Tue, 12 Mar 2024 00:20:26 +0800
Message-ID: <20240311162029.1102849-1-zlang@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[PATCH 1/3]
According to the manual of io_uring_queue_init, it doesn't set errno
but return the -errno on failure. So we should check the return value
of io_uring_queue_init, to make sure if the io_uring is supported by
kernel. We've left this problem in xfstests/ltp/fsstress.c long time.

V2 replace "if()...else..." with "switch()..."

[PATCH 2/3]
And besides kernel build without CONFIG_IO_URING, a system can disable
the io_uring supporting manually, by set sysctl kernel.io_uring_disabled=2.
The former cause io_uring_queue_init return ENOSYS, but the latter will
return EPERM. So I let fsstress to deal with both situations.

V2 follows the "switch()..." format of patch 1/3

[PATCH 3/3]
This patch is re-written totally, and no any RVB.
This v2 decides to notrun if sysctl kernel.io_uring_disabled is 2. Then
change README to clarify how to make sure io_uring testing to be run.

Thanks,
Zorro


