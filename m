Return-Path: <io-uring+bounces-835-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD4187325F
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 10:19:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E959E1F21241
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 09:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6075C05F;
	Wed,  6 Mar 2024 09:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JYVR4908"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675521426B;
	Wed,  6 Mar 2024 09:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709716782; cv=none; b=LBfIhzy8ih2XuEtsBuptDQEpl82bNblJzBmQt4z6OFiLQpwxUm6ij9wHqGLnw4XoaEjvGvrK/OxaYSsguuYq+dAmpSQ5TFVxaPwtZEKgyoKt5Sqfg+b9T+aypNYglaEPQtZSIFr1YNsqkDxRo9hBm6RHIR5NEs6FfAh3nvNsGWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709716782; c=relaxed/simple;
	bh=576BNnDqwXwQ6YZRQiSOlSYy6Uiobq8Bw6/3h46gfGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGOZaJA+QojY/6r2MWC5Led782jf4Yx98Vx74NpWQR84onotRMpeqA8dPpgeDLnmsugWMJzb+ahe23zFO9XTDbAoBwvWyEEpcz75W1Vfu3Af/XB1Zn0CiFSUeIXO7jLZn14Gh9QWVWsI/1psX3tuuXIhQVuh6EMobiAuAj00uBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JYVR4908; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5CBC43394;
	Wed,  6 Mar 2024 09:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709716781;
	bh=576BNnDqwXwQ6YZRQiSOlSYy6Uiobq8Bw6/3h46gfGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYVR4908vGgev2/06Px7KxZCx6ywj1b8SjQLe5INNYbQZTKD7LxLkr+h7DKQracks
	 fae4BSuJ5EJh1ORZa+tNxWRjSXN/DMF7LEO2iOOnZHU264LJ6eGSGFPeni+H3iXeaq
	 qTHaRRwbT2nA4mr2QlAV+qbkMzRSHig0NojWhPHwifdbURcZmwgTbEQ9ZT+Q5e7uyM
	 M9e4kHtXJC60AlJGWNfGXoGQ+zhWlJkZ6jrg16T6tUXC+opxc9xPU1R+hk7TCblG5G
	 E5r0UB4YdXv+ji5XLtfjcGcr3Epxc9E8zFcjrHcuIdBHdeq0NF3djczRk2az/ERPft
	 J3moPMZrlC8bw==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: io-uring@vger.kernel.org
Subject: [PATCH 3/3] common/rc: force enable io_uring in _require_io_uring
Date: Wed,  6 Mar 2024 17:19:35 +0800
Message-ID: <20240306091935.4090399-4-zlang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240306091935.4090399-1-zlang@kernel.org>
References: <20240306091935.4090399-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If kernel supports io_uring, userspace still can/might disable that
supporting by set /proc/sys/kernel/io_uring_disabled=2. Let's set
it to 0, to always enable io_uring (ignore error if there's not
that file).

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/rc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/rc b/common/rc
index 50dde313..966c92e3 100644
--- a/common/rc
+++ b/common/rc
@@ -2317,6 +2317,9 @@ _require_aiodio()
 # this test requires that the kernel supports IO_URING
 _require_io_uring()
 {
+	# Force enable io_uring if kernel supports it
+	sysctl -w kernel.io_uring_disabled=0 &> /dev/null
+
 	$here/src/feature -R
 	case $? in
 	0)
-- 
2.43.0


