Return-Path: <io-uring+bounces-10388-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 58AC8C379D5
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 21:03:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 690BF4E4B6C
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 20:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949C53074BD;
	Wed,  5 Nov 2025 20:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z/JJR/3x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F9D126C02
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 20:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762372994; cv=none; b=PokmUrE5JM/ptU4KngsS3NbcBOo8WQqtGWOfSqXyoByQwh7yQXdYfiQAGJdf1xcBbOvUcJOMyFFqQX3bnF8Bad1aBeHoK8ZKaW5ulzsYDOdaYUOZurf2VuZjlLz3dQfqdP+GY+duHHVzbtDai1UcM/pX6rfAD4BQd76gyQBYHMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762372994; c=relaxed/simple;
	bh=KA+ZxJ4hY5ybJqPSvpyAakQoAZ6tIa6sQnggzvFjVLI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=To0pnP4/bxamBit4F9nYx3Hcpsreb5I0mzmvhwqQVSoiu0cDlB/AWjKorNi/3bvrQU8RN3Q/5yg4HG9GofLkJvW1vs0XEWGLKzcp3+QwL9V5iyQ0ryXmLQf/LlXYW9BBJmtAXF+FvQOlHY65u2JAOPNLFT1m6cShHWRh3/5EAyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z/JJR/3x; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-9484c29576bso11267839f.2
        for <io-uring@vger.kernel.org>; Wed, 05 Nov 2025 12:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762372989; x=1762977789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+IVwIeYTYsFNbB1tfwcG8M4KNJq+seDK5hI5Sv2vpF8=;
        b=Z/JJR/3xxXd6Dp/fioywxmQI6iVmsbvndAXUnLBBkCsAlFKPU+lRn3ovJF3m2iWPys
         /I5tWNXSfkqVq27NchAVeNz3LWx/ugVrjhDpAnVo3Aqp6txMWZ2crTy39ExdlsrHmVB/
         5zAu0TQoDpL8bLsTWXutgKEIBxYIdhmJfuMN3dmTZEutA9/i/ZuwsGgsFP723Mrb9/oy
         RdSEpmZ59ql1YOfL00o+sa6MY3Zp6RvwP8RT5LytyT5jNp3NSUpVasVBqwQGcbVoS4Fy
         /1A0OwQX/SIRerJUVoy0lHTbaYvaQnPdG4FzQsHBnxzetErlbXG0N8J3B+5nzAVFn1up
         99pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762372989; x=1762977789;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+IVwIeYTYsFNbB1tfwcG8M4KNJq+seDK5hI5Sv2vpF8=;
        b=YsiZ6ylukBRzNL5EYgzjciDwI9lbJVLUNBp/YVaak4YDJvUZvXJiEJ33miWPJqRBOC
         5WStIsNykInRVekRtp/Ofu2dIoIe4nnQR9a7PPaGrqOULrEpXIfrE2GOKBTc/DV50/e8
         1VQziSOkcVs/lqOu4gBjpQloD5q/1ni0leYi7Gmo7s+ltF0DbGTM3EO7E4T2OJeq5Zov
         x8lVZ3+nAHziOhh6IcmpM99wjIUZl0JMNo/t92FBvGd+uMbs/hKfEyUsFnpy+Z17s0vg
         agWKjZtyHc14jNKs7yFB5FbMfSZXMm6JUu1ENPNX1bD4nTVN9r5Br/hKnwcKVVvbe46n
         +Pog==
X-Gm-Message-State: AOJu0YywvH8RpijHsTVT1iHz7o9gZh8ZPUyaiyynk+yejdBJRxzxFY15
	3izOfhMhei2PcXZLfTjryf7raFGewGcqhZL3eWHI2c3+51kaW6sncHO520mweAxKF9tMeDkEOS6
	uhTpd
X-Gm-Gg: ASbGncvSWEZ2qjjP4D4iSkVIkd7fWnpr70DxW29XmwzsnLUfODKaArChw09ikPN/deq
	ly/85x+mrwTQv555uhTyVqlM+fWAlmq191N5cnpAZQ+QgF3zUE9wBmpsC/kMr8Ai1yixhwplBNl
	vxK3qQHEmPfta3bdAJZus72wyTt4cMfuuxhC2lYqGLUBNXMxTFjTluMP3030xFqXX292TKYNTJS
	HGcMKz/WdLspMcq4piUebj41TkOIuyyhFba7V0pM0NClt7sG/2OgetEh6o0xv5zz3zFnOqR0B8A
	qHPmf73wqIJ/WTUQefB3l6QFb09L6oWd3FmKBpH16XH7/3K6lJ04XzpYLzjIo5eQ9+RPceuGkKT
	X+1rpcK0wy+hqkqfYERjfY4T1SDpyP9DP0a6OPkoIhCm1qYWPFAbpV0cvkMv3fg==
X-Google-Smtp-Source: AGHT+IHW4HYDe8zNOfRfA4uhx0c+o1IAW66TyXBtTUd5VlpQ6qg4XXijpwiqz94h3rbynAvzRwPYKA==
X-Received: by 2002:a92:ca47:0:b0:433:2e0d:42bd with SMTP id e9e14a558f8ab-43340759de3mr61328765ab.1.1762372989345;
        Wed, 05 Nov 2025 12:03:09 -0800 (PST)
Received: from m2max.wifi.delta.com ([99.196.133.153])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7469631cesm49632173.54.2025.11.05.12.03.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 12:03:08 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Minor vectored futex cleanups
Date: Wed,  5 Nov 2025 13:00:56 -0700
Message-ID: <20251105200226.261703-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Wrote these a few months ago, but then apparently forgot about them...
Nothing major in here, mainly just splitting the "normal" and vectored
futex wait support data structures to clean up the code.

 io_uring/futex.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

-- 
Jens Axboe


