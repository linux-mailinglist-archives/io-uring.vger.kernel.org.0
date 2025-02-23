Return-Path: <io-uring+bounces-6640-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 940A2A41061
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 18:21:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D19677AA2D6
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 17:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9671BC3C;
	Sun, 23 Feb 2025 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FcgBtKFB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D4DCA4B
	for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740331306; cv=none; b=tgFJ9MzExZh6Zs52p0FcIMTNbjYUeyJmGZ1RnP8xFQOPTpxPRQcLhWQDT6cpjsvJmyz2k1KVkM0peI/Onazoleig6guESgm0GGUT4tCE4KZT/EdDhSZVbb17j13ONihcr1KE3R2/aHS6MfEfbbJTVn9bB3SKd3YHP2smsfTVvtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740331306; c=relaxed/simple;
	bh=u1yJmagKuLF+W/LoaMjC7QVfoYnzvE2pQ3hix6FUaac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VuHDRbz3RO5r9nnQ4iE64PCQOaUBiRT+ovOVB85YG5dErf/7qX88JiCGSzHtWuOUQGcb6O6ENWeYMmvHeojz7z/70cIRelnm5BRDmpvQp8MPLSFpfQJNc8EYMZafFNVympRwk36ODnr5rI3rRPbFORseuGr7Dc7RBLViAIpDTuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FcgBtKFB; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43998deed24so35051505e9.2
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 09:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740331302; x=1740936102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ettJdPDsoZaU1L46Yi3fXD4goZ4tIjFxveenmY740LY=;
        b=FcgBtKFBUIpWuTIF5FaLXF77HlBBBuRP+c+AD0YMm4dqdsUGzQF4GVNEN/x7gAb/wO
         sVihHAWwY94sNmMW4SdooQxNnMrZvFtzaV+YPu4Jm9lrkhaFixbgn/tjR5ABbjPvkybx
         wo0XR7UnxX+3i/3faf+11KrTDL0M47j3LuAUiH7BDtZES6uJ9lOqqDzr4+2ou84JGYoW
         ykHMmcMJd2NiHfTWPEw4ZEG67fqZ6kOvAsd1ditZNvpmdVFGK0AMson1mwQF3eITk4Wn
         dteotg1s6zkpMNz6P0EhgkjNAkcnseh8xqHwjUupcuriPKMYxvFqDeUTjVPEzeZbqyzz
         hjDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740331302; x=1740936102;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ettJdPDsoZaU1L46Yi3fXD4goZ4tIjFxveenmY740LY=;
        b=F6GUC65onH3HrSzVDfUwNkE/Yup0rPHNYJZQV6GSkMVuw2dtTeheE4qs+Mb4jHGN53
         v8Ddz2EzsMzWYXvFKC/6m5wJ+T1YEffLKcr4WI/qjFX77mk2IZlUCtlp8Fs7XSL9Y3CN
         JPSwApuPytZEpP3AoqZjjOHJAV0e/DZK61NYHzPFnKBzZqpYYqZyFLIcGTW7LSuNvKpb
         4EYv7x62oB5H7eDRXaxTIzM5eApFVoPhyxWFmZY9FzpRCJNzNE/xyXvbCqMVdlU68tCW
         X175dlHGSq7GiguJ32ReYT6dv5AQtNHSA35ZXX68PFtOHZcd9+tnNABZpG8P1quAOefa
         G9+A==
X-Gm-Message-State: AOJu0Yw5SNbkyKQBkxIZgioB+Xhv4oiaSy4HVlwwZAev8uhxOi+cBE4T
	eJnrTRhJRFcUU8xm0TDimxgq4lM/WFnE3S3Yc5vyRbVtfgxXAzjV2+ZY/w==
X-Gm-Gg: ASbGncsvNTsCkFfCD61vOTdVIs+pFTtMmM6+h9Sb9AccMhaJCUayflhOjPz0L7H8ZiE
	D02EeHWyuBGVtDMsXf2JRFZRiFxEFLaMUs4aGM4lIhpxm44/y2vYzm8L5Pydf3FOZCWP4mKlybS
	BK7r507rfHv0fCozMXXbd9M2NU05tFNym7eqkwWYWjbYE+j876YaxTNj+DbcPQHP58kdg+AOgbg
	Qe8Xzo8a06pwLGqtxlstEp5cSSLqvs8Gu8/CcvL7Zc4cf1RTxgJbLf/5CoVXTHbGUq0p3jLY3Xs
	tBPnlq67lSVNTkgI+T/7nqSjIphivAoZnC9w+S4=
X-Google-Smtp-Source: AGHT+IE+pNqwillS/52SPp/V66wfT1TK5wnBjFeSwUtbBU1YhtYQgQ8Cb2L+tptXBxrEEIX3UQ0Srw==
X-Received: by 2002:a05:600c:350a:b0:439:9b82:d6b2 with SMTP id 5b1f17b1804b1-439aeb34f86mr98875385e9.16.1740331302090;
        Sun, 23 Feb 2025 09:21:42 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b02d684dsm82117765e9.16.2025.02.23.09.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2025 09:21:41 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/3] multishot improvements
Date: Sun, 23 Feb 2025 17:22:28 +0000
Message-ID: <cover.1740331076.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix accept with the first patch, and make multishot handling a bit
more saner. As mentioned, changes in Patch 3 will be used later to
further cleaning it up.

Pavel Begunkov (3):
  io_uring/net: fix accept multishot handling
  io_uring/net: canonise accept mshot handling
  io_uring: make io_poll_issue() sturdier

 io_uring/io_uring.c | 40 +++++++++++++++++++++++++++++++++-------
 io_uring/net.c      | 15 ++++++---------
 2 files changed, 39 insertions(+), 16 deletions(-)

-- 
2.48.1


