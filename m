Return-Path: <io-uring+bounces-1463-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 513EE89C9D0
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 18:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6A8C1F21683
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 16:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25B614262C;
	Mon,  8 Apr 2024 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JFG4kU+4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278C3142652
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712594298; cv=none; b=dvr/takTggQd2xFv3qsN7o2RuYHRC49VieotGisPUAYcHzUzfR9K6vpNmgTvPrNj9vVHfP0dCm+rhv0gcW6W29y/3YIG9EeIc+4vklTr2xB9UGUJiSKhoGVY9TeQ/qZSDF97hk9C3F627NoKXnH9XRlRz63Yt4vZQX0gGmEd6s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712594298; c=relaxed/simple;
	bh=ispxYzUJStLkBU2HFTZgwlYsNli9zbySFg1z0Ugh6Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V84B2uPM+QpFB/P5Eyukn0LwfILv9kEz8f2fgLFZDfMMI6Lh3yAu+PFdcujYnL5oXuMy54zROi8lAvUTfDqxpNbxYJEw6OUhNxjAX/SpKlYMT2f+jVu/790zmAWuqOJpAtlNKaXbI/Xt4v+IHLLM/ICaGz1ivcXJ4CIoA0qMAXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JFG4kU+4; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a51aac16b6eso185332666b.1
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 09:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712594295; x=1713199095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UqyNwIG9uMEtpou9Qe4z8pwraUuQEl5oNldInBc0NG4=;
        b=JFG4kU+4rVikyz+0d6j+VXdtktFrmOtUV8mVsU+5etST7KP7bPkg+rMF9LqAYqisPU
         ABrKRcHUH/mn8EbX3BP6E8L7aAPeJFMmk+xMNTXgj69A6ujPRL+ZYX8X5wUfK9nvQ14z
         3Ld2IqQsUI3+u50J9ZSX4Wr4KesWd2oOklaPuT31JS05dyCIi3mq0mt3J6aoWSYO1H66
         R28MtbkUcdByQCA8/Bk3z/p/BuuQmZ17Igw0fT73QoUr1br3dyGmLr5iNSR4gRV0sN8X
         nUVDrEdyqUFLi6JXDzTmF/c41x1UJPIvlgUBs4mHHPeySCt59u5sxEGv4Ttn8trJYbZp
         SSLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712594295; x=1713199095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UqyNwIG9uMEtpou9Qe4z8pwraUuQEl5oNldInBc0NG4=;
        b=AJnpYWiCL8AKVeEZQT78mRmsSFvP3Q9UN5qY8QSMSLPMGKbC42QN4/p+RetpQWND40
         VDEVgbXA+r49mXduKg17MvwxE36dBkJVS91FIOyjB2vSdfmiLE6obgcr2wbjQ5kDLwL0
         TWn0pjji+d49tcGPoq9ooMgNRyyvm8kwepZ2Qz0Y6bfgvSQdu9XyghO3I9idLVKP6Dwk
         h3TCHp87zXNNdyoh6MwTGCgtsQMw6/eHGiNPxQNJqLm9oPGiFRSu6h3atxiuVKW5NVR4
         kPXyt34H5m/21f5Pk7KzBVtcmLtB8g9D4Gcm2yjRucVZxYX17iOqIilBC/pFE9bSc+fE
         3D2g==
X-Gm-Message-State: AOJu0YwZplUHxWmxUC8U4/x/RvM8FpqTlO/Fh4Aq93MFfbXVOZq/D6rZ
	MR263imw1KkFKTtfCsjdwzgblcjy8GHC20+iydzUr2B+obWTdI/f4V2dER8I
X-Google-Smtp-Source: AGHT+IGxzeAzrQe/2FURKVoHrJy9k+TVaU/YHqfEAsileenvPIezLuRCiAQqLBxLxk5HuXVQ/J5erw==
X-Received: by 2002:a50:cd97:0:b0:565:f7c7:f23c with SMTP id p23-20020a50cd97000000b00565f7c7f23cmr8845610edi.3.1712594295099;
        Mon, 08 Apr 2024 09:38:15 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a9-20020a05640233c900b0056db8d09436sm4143363edc.94.2024.04.08.09.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 09:38:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing v2 0/3] improve sendzc tests
Date: Mon,  8 Apr 2024 17:38:09 +0100
Message-ID: <cover.1712594147.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is enough of special handling for DEFER_TASKRUN, so we want
to test sendzc with DEFER_TASKRUN as well. Apart from that, probe
zc support at the beginning and do some more cleanups.

v2: don't forget IORING_SETUP_SINGLE_ISSUER for DEFER_TASKRUN

Pavel Begunkov (3):
  test: handle test_send_faults()'s cases one by one
  test/sendzc: improve zc support probing
  io_uring/sendzc: add DEFER_TASKRUN testing

 test/send-zerocopy.c | 332 ++++++++++++++++++++++++++++---------------
 1 file changed, 216 insertions(+), 116 deletions(-)

-- 
2.44.0


