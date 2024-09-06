Return-Path: <io-uring+bounces-3058-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D9C096F065
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 11:55:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6909F1C23705
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 09:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3DAB1C8FD4;
	Fri,  6 Sep 2024 09:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="LWqDfATK"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-65-225.siemens.flowmailer.net (mta-65-225.siemens.flowmailer.net [185.136.65.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FBD1C9DF8
	for <io-uring@vger.kernel.org>; Fri,  6 Sep 2024 09:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725616428; cv=none; b=XZ7PCr9+KnmOEH9WunCjQNafh/Pvn2WYXMPPRcPOXUkESOYRTH3KUdvNJE6CawPpnbmp/F6wEcUKxJeID9CXXBJh7BxLzs3ZHfh5/nBY4h24VszGn7df2RgxV+2nz2y4cT/X2ZUFCW2DQak40nRUl9+DIUo4rsQoLTjI05EC1NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725616428; c=relaxed/simple;
	bh=1pi+ZE9H6rSyN5PpZ9k74hjrSRiBdqp4Fn5YbapZfXk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s1uAnDlqNIb5PDFsdXUOv/Ukcw+odKHy3z+KqHc9qU4uNqFcFpKNPT2+IWtWe2zuxHyQ/VJzjzS09X02UEbe0NWkT2+r/VzBnaw8dBwJcgu/56Kog+8iljHKV4Dlimgx59ZwltUUqB9WGtaxIOXLp0hD15h0ipfbvWmwW2tBSLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=LWqDfATK; arc=none smtp.client-ip=185.136.65.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-65-225.siemens.flowmailer.net with ESMTPSA id 2024090609534387b7bfdee544bbd6f5
        for <io-uring@vger.kernel.org>;
        Fri, 06 Sep 2024 11:53:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc:References:In-Reply-To;
 bh=VQynP3ITLuCADWZje+F9AQoYOLz42+/shggf0ishfvM=;
 b=LWqDfATKPVenyJXuklby7nYPlGjUB/UWj1QvdlGlW39ZBRywTsvdFWcCuKyaEZ2EuJu7CG
 fQKysHpAUXijG0gQG14Qh716dV+wDxGghDiKUMOjHPBfn+GJN6ZbFOk1Mjn25V4/Pr1D/uR5
 MHdOp4xxPzZJ0y3sR1+qLPhZ7cFESa/P9p9FnjrrIp4ah0Xvyl59xWZsqKiMTUhDlAN/PZKT
 QOzM558GUKSMaAU/qU38ajG8owFcgpwRg8Of4OphWhkNkbWTmW35XQOuTfsYGgG6RC9cqjFP
 7PG5O7iaRhs610JNiUwuc9MhE7B2Ws8OUXjCZDI07u2IpiVzhsk+lvBA==;
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: stable@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	cgroups@vger.kernel.org,
	axboe@kernel.dk,
	asml.silence@gmail.com,
	dqminh@cloudflare.com,
	longman@redhat.com,
	adriaan.schmidt@siemens.com,
	florian.bezdeka@siemens.com,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH][6.1][2/2] io_uring/sqpoll: Do not set PF_NO_SETAFFINITY on sqpoll threads
Date: Fri,  6 Sep 2024 11:53:21 +0200
Message-Id: <20240906095321.388613-3-felix.moessbauer@siemens.com>
In-Reply-To: <20240906095321.388613-1-felix.moessbauer@siemens.com>
References: <20240906095321.388613-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-1321639:519-21489:flowmailer

From: Michal Koutný <mkoutny@suse.com>

commit a5fc1441af7719e93dc7a638a960befb694ade89 upstream.

Users may specify a CPU where the sqpoll thread would run. This may
conflict with cpuset operations because of strict PF_NO_SETAFFINITY
requirement. That flag is unnecessary for polling "kernel" threads, see
the reasoning in commit 01e68ce08a30 ("io_uring/io-wq: stop setting
PF_NO_SETAFFINITY on io-wq workers"). Drop the flag on poll threads too.

Fixes: 01e68ce08a30 ("io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq workers")
Link: https://lore.kernel.org/all/20230314162559.pnyxdllzgw7jozgx@blackpad/
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Link: https://lore.kernel.org/r/20230314183332.25834-1-mkoutny@suse.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
---
 io_uring/sqpoll.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 11610a70573a..6ea21b503113 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -233,7 +233,6 @@ static int io_sq_thread(void *data)
 		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
 	else
 		set_cpus_allowed_ptr(current, cpu_online_mask);
-	current->flags |= PF_NO_SETAFFINITY;
 
 	/*
 	 * Force audit context to get setup, in case we do prep side async
-- 
2.39.2


