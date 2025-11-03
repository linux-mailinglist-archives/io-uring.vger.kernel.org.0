Return-Path: <io-uring+bounces-10331-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A0000C2DBD3
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 19:52:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0DB9A4F0D7F
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 18:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC783254B6;
	Mon,  3 Nov 2025 18:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JUrOIIdU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C3A325497
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 18:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762195786; cv=none; b=DdcAhjnhVmPOiqYJG5TJQ/fRiPfpuZXvte2rUpePOFkOGVHzLqbz0MPvevgf/7CpF3BC9hnHtlUdarM/sm+LhjOnRNwBTkf7nrC6jTiwKXamIC65SoPls2093GNp089gd1TteIDPs0KiyWTbjE1AW3u+Vf3CsB/E/aCvvIDkC8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762195786; c=relaxed/simple;
	bh=lYhE3DwBK7BiAwaOWMOnfSVuzuF3/kzNqFvVKPjuWrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibXRNFCbjXsi5YNbY6HzH5fVB4IG71mf0S2BElZmDrJ6XpEYMMc96rvZzusAbHA2LvzJpw19let8JSCnzoeVCyrjCsDwDeIZ0/k+Nz3tp43SNkX6HQawDldtPX0225+W96c1jtQdRQb3PIpnmrAC0yC1QA2yxyog0HA9PGKmK1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JUrOIIdU; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-4332381ba9bso26357415ab.1
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 10:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762195783; x=1762800583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QzM9ihltmPaewSfHUKeA+wV2tknYcYzl+72JUfBSunk=;
        b=JUrOIIdU1T5Q8og5h8eTQyJfpZwAMIrhEo1ohhOI9MuVskzOSnEoxzQhwwy+V/54W/
         bIgEqjIGOubHs5ktSIdmmFJRbsXNwv3hnGVlKLUIU68NW/EysLrkk4Vo4DbePcFJe3Y3
         Y633yp/UEX1Mc+RLjH5qsNfM707IN81U5cyFi2aaRLNuvSi/8C65BaqBc1PLt1JAW9gD
         fJP8Uy1UL+wutBJFOrZ/n1F0ePfdmHqmjflqWsNgdd0EJaJabmvN6dJAQn1D1jri4NGc
         MKwUu8qvPmnVGfEL7PfdFF63SmLM+hMZyfvemArrqGZMYnpiw7+JPRhEZw8a5+w00FLz
         x8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762195783; x=1762800583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QzM9ihltmPaewSfHUKeA+wV2tknYcYzl+72JUfBSunk=;
        b=BIJj/VmNO5QsQKXWKktVnXo0J3aaRDptMj047FosmWJG3odQym08OMxWomLVo565NB
         g628pI7AVC+q6u56ciDA9q/w+ZT1T1la+xE/PHD5j2GJiTB3lkwFlbpMLZtr8E5HGx/3
         QohSnp0lNmkS5MR2F4hVk3hmOVIcDcK6cPzhtSiz8TtF1T5J1LmKHtRi3G5GGzsqqwZf
         5GRpROW4Ti5HEVuJUtGflZSjt+A/+UQN7/w9Dh82aJSIHBMavAtCkw1EWbyeiSyVDiGK
         ahL1vNQXoZx6ga9pSrLGF7moiSgfRioGPLHObfFGhRkk43OeLiOo1ZWhg7bAQGZAhX/E
         0FxQ==
X-Gm-Message-State: AOJu0YznJC1EVfZvSfXh9osGWLKqRciMs89eu1Dx/1QBVwx3ERlEg1Je
	6DS1VMVlH4Ap7qP/v9gxB0/eWhtd/Vz+CYIMO5f0sZ7pdDPFMpaOVKPz+qWvajK7UwmOjbiXL+n
	blPuG
X-Gm-Gg: ASbGncusmM5l8SALrsRAbxXaRYeB7kpV3KHVxXiXAUMVARt7y6dhOrXII1xyoKTsZtt
	3GSS8a9xMVVrjk6hkXfSggxiC40WEx0SLifNOg5o/e7qxlRIawUuUdR52fdQ2vmtGXZw0oN9xeF
	eaIChtKshyoxMGHtcWzipRTSQCfOkInzrSPXDvItNUXHKZH7auMP1QNmof9jnMyfHBwAHPywjjO
	9fzyBAVk5LdVcaGwLP5RtpVrkaGptqlhDcscGkJpPvRrOUmw8IBiT+Gpb0rZVxnfvp9D/9zk1YL
	PUwxTmuJbqKURpkHh0VWTorvHZG30fCmcVk/fxnRgtNdgBOBMBSskbGp//LEpNpxrpS8oVTdf9q
	ze80LsG98rck4cdK6zpOatLqqxXUch8jEwXFU2IellWvM1Fh5eSg1gxlmkinyifmWCPNX8w==
X-Google-Smtp-Source: AGHT+IHD/x3u/SLzcT0wEpiv4LYPmLgoCvgNoZuqHpvXmgUd32e0uXlOfT4zBfu0m7o7SGMl/IA9yg==
X-Received: by 2002:a05:6e02:160c:b0:433:30d4:389e with SMTP id e9e14a558f8ab-43330d43958mr52992395ab.3.1762195783336;
        Mon, 03 Nov 2025 10:49:43 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335a2224bsm4572985ab.0.2025.11.03.10.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 10:49:42 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring/rsrc: use get/put_user() for integer copy
Date: Mon,  3 Nov 2025 11:47:59 -0700
Message-ID: <20251103184937.61634-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103184937.61634-1-axboe@kernel.dk>
References: <20251103184937.61634-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's just getting an integer from userspace, installing a file, then
copying the output direct descriptor back. No need to use the full
copy_to/from_user() for that.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rsrc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d787c16dc1c3..4cc38eb56758 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -454,7 +454,7 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 		return -ENXIO;
 
 	for (done = 0; done < up->nr_args; done++) {
-		if (copy_from_user(&fd, &fds[done], sizeof(fd))) {
+		if (get_user(fd, &fds[done])) {
 			ret = -EFAULT;
 			break;
 		}
@@ -468,7 +468,7 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 					  IORING_FILE_INDEX_ALLOC);
 		if (ret < 0)
 			break;
-		if (copy_to_user(&fds[done], &ret, sizeof(ret))) {
+		if (put_user(ret, &fds[done])) {
 			__io_close_fixed(req->ctx, issue_flags, ret);
 			ret = -EFAULT;
 			break;
-- 
2.51.0


