Return-Path: <io-uring+bounces-832-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D047087325D
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 10:19:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BE762914B7
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 09:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87CBB5C05F;
	Wed,  6 Mar 2024 09:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxoV+Afz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BF31426B;
	Wed,  6 Mar 2024 09:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709716778; cv=none; b=DBV9eKaizPYMbLO096jc867kqAT5VDnZOhbGCmAemJiuOP/PbgG4I/PmIyjpeljOrkIXsZT+t2WWK5ITHAKHm6q5CBd7Iyk48Wo0FjqaaT+pJtq5DlH8hn2ADpA+Omhpi1WE7o4nNiVhAQAarjqQO+yUXi31OdC5CECtxuOL8SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709716778; c=relaxed/simple;
	bh=SdhN+E/eIF2/Lkza9tWV8jRNzD4ZRlSs/BSK/JBa3bw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jeGJZ9E95qtjXA4vhV0FbJWKsc7kB+n5d8co38bfEcndAN7yzAY9ca4q753CZZfg0y8xKuCmeCJ5m0fc8JELa3oHG8NZ888hFjoACxdiBawbo5IvCc3D0CH/6WlHVTROktp/W86sfEkhMtn8FFrG6HrPMZ7iRrKx4mTrOkwZZS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxoV+Afz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75619C433C7;
	Wed,  6 Mar 2024 09:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709716778;
	bh=SdhN+E/eIF2/Lkza9tWV8jRNzD4ZRlSs/BSK/JBa3bw=;
	h=From:To:Cc:Subject:Date:From;
	b=lxoV+Afz7vRNq8gDajaFO0gA3LaIfcnWVlTvxFNixwyl7lFsDxIJE8bGpM8Ck708o
	 gbxge3ZsDIsydC1JXa/gkB6Db9m6macOwic3yKQKLSNCnGgk1D9Y8ka4LXcWrcOYq1
	 5d84ECwvUs5MP9soZS9CwQ3lPBPgG4tmrTVweLUxMmOwYIkGsHV83l05oC/SvQlaLy
	 qcAdfC6hRhy0jjn3wLVIxx7hgiD8BlOTWADtUqN7/WAfWTtQU7Pn8n6V3ZYIbUjc7+
	 zje2LvcYuXVtS90gxO7tRtt62Fa34I7b71+iB0aQXAMvmH5nmBrNMgrUghRAbevmLu
	 mtOLu7z0Q9L3A==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: io-uring@vger.kernel.org
Subject: [PATCH 0/3] fstests: fix io_uring testing
Date: Wed,  6 Mar 2024 17:19:32 +0800
Message-ID: <20240306091935.4090399-1-zlang@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to the manual of io_uring_queue_init, it doesn't set errno
but return the -errno on failure. So we should check the return value
of io_uring_queue_init, to make sure if the io_uring is supported by
kernel. We've left this problem in xfstests/ltp/fsstress.c long time.
(Refer to PATCH 1/3)

And besides kernel build without CONFIG_IO_URING, a system can disable
the io_uring supporting manually, by set sysctl kernel.io_uring_disabled=2.
The former cause io_uring_queue_init return ENOSYS, but the latter will
return EPERM. So I let fsstress to deal with both situations.
(Refer to PATCH 2/3)

A question is if we should do "sysctl -w kernel.io_uring_disabled=0 &> /dev/null"
at the beginning of each test case (e.g. do that in common/config ?), or leave
this decision to the testers (in their test wrapper). Now I only do that
in _require_io_uring(). If anyone has any opinions, feel free to reply.
(Refer to PATCH 3/3)

Thanks,
Zorro


