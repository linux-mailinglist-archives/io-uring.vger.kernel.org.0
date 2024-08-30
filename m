Return-Path: <io-uring+bounces-2986-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D0E28966771
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 18:55:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C7FDB27D56
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 16:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFBA01B6544;
	Fri, 30 Aug 2024 16:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TJA3dRoE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E34814F131
	for <io-uring@vger.kernel.org>; Fri, 30 Aug 2024 16:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725036922; cv=none; b=iBWKyhW0oRJXceM6noX1ePZMmRTxNWIpiU80l33zk6vRfZfW06M1ADkWEqF20lPV0B9zpKOsW5Uns0neo+GoVSG/WHvAgxPZaCzeUGg+PXZjI4eCnoRUYl9L558Mo0qsS1oGVw8bPtDLS0VICsGKI+NVP5Z28/ZOWXHBvtYkiPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725036922; c=relaxed/simple;
	bh=6zpi/TYP8yGa1IvLoDo4stK81uYEqYHBSW+1d73uN3k=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=SzEASV/FGQAIdhCWrPaWlIaX5vIuyTKX7rLBgmZDDxkf5TCn5P1vZVXeZbYOBCc3YC7VDP2QHilukSaR/rRyoYXcNd3x/e8jspPneOKryhs4XHQNtTcJyWVXKc6v+R3R7rz1mKqKwUCnCMfmtgnLhJCNm09D2yQxuGsjb+BqUFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TJA3dRoE; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-82a20efed34so98418739f.2
        for <io-uring@vger.kernel.org>; Fri, 30 Aug 2024 09:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725036919; x=1725641719; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6hrAG2KtEto6bWP35aE6ctwzQM58ooV7bJU4yMwEtAY=;
        b=TJA3dRoE0Ij9/D6d2Bx6dqkd3hsEiQTgsJBUqlkQZv1xkF6dCN0a3msaXO9Z/ovlBW
         Ux1x7zpSl7fMKLE2lNkuowKiFq2P6XbVEDazydHwrC9foxsVaZi8rTklo7HpCSYwQFd0
         jwQJiZI0294HUsJOudo+T6gAjQri1SOd+oLg5DuL7MJhbExQu4/1knu/IRvJ1BusYUV8
         ATEPLDAYardjM6KbopEB7244/5kuiPkstug7jpwzTYNVTKmCw+WgoKcTOUDF66g3eFiJ
         CM4nfBjLOjzv3IWnoffflxWt2m7IoWEmveGo2d2IoG5x0EtjsWikzOhrp684eXtavLvh
         Y1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725036919; x=1725641719;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6hrAG2KtEto6bWP35aE6ctwzQM58ooV7bJU4yMwEtAY=;
        b=AWYN5ypy6wehFxDHSQVgxPyKIAV3dmqRA+Wf6EgR84kreIMkrdOpqmOvTKLNKWq3Xm
         0YSbehmCsaHAK/xbjweYo2a9TJPx6onD1NFIvsiYVar3mkdB0Pwn7xB6UZ11xRgRjbv/
         2RUz6LUdlGAygXVBGkAmSSUDLBOFakkCt3kZAh8c+Pj8Sop9HrqLh9Hy5yxwxq1gSZvX
         PsfJMeTESoiqaebNmJ7hwTbrZMu8KKJXS6YETYHU4/xQe2c1sUGrLxuiMpbwvN67IGam
         m6J5nb63ZN4EiIIfsWROsc2giKC3smrrCHoy6l2CAjyvzT0EH1Q/hrFAVF/f9d4y8Nmy
         1kSw==
X-Gm-Message-State: AOJu0Yz+cTHJdMZZ2Mec/Dq18x259vxk15ArHxJj0CVeEGJ89TCSWLhl
	yI25KRlgs4uiwAOeYZQ3z091zXvcw4yiEHeUWTLJw7qLw34zH5nf6xXpIYmdvGD8S10JnmzdbqQ
	s
X-Google-Smtp-Source: AGHT+IEU6c7UXqO3rcFpTvsDi0elRKrnw2SuYvLEcWgXT5B2DQtzgERghZ16bcFNlFVSGDZcVhypMg==
X-Received: by 2002:a05:6602:60c2:b0:82a:185f:593e with SMTP id ca18e2360f4ac-82a342975b1mr9971139f.9.1725036918813;
        Fri, 30 Aug 2024 09:55:18 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ced2eab5casm829862173.127.2024.08.30.09.55.18
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2024 09:55:18 -0700 (PDT)
Message-ID: <d3a6dcea-3f5d-495b-bfb5-055881159eb4@kernel.dk>
Date: Fri, 30 Aug 2024 10:55:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: add GCOV_PROFILE_URING Kconfig option
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If GCOV is enabled and this option is set, it enables code coverage
profiling of the io_uring subsystem. Only use this for test purposes,
as it will impact the runtime performance.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/init/Kconfig b/init/Kconfig
index 5783a0b87517..3b6ca7cce03b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1687,6 +1687,19 @@ config IO_URING
 	  applications to submit and complete IO through submission and
 	  completion rings that are shared between the kernel and application.
 
+config GCOV_PROFILE_URING
+	bool "Enable GCOV profiling on the io_uring subsystem"
+	depends on GCOV_KERNEL
+	help
+	  Enable GCOV profiling on the io_uring subsystem, to facilitate
+	  code coverage testing.
+
+	  If unsure, say N.
+
+	  Note that this will have a negative impact on the performance of
+	  the io_uring subsystem, hence this should only be enabled for
+	  specific test purposes.
+
 config ADVISE_SYSCALLS
 	bool "Enable madvise/fadvise syscalls" if EXPERT
 	default y
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 61923e11c767..53167bef37d7 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -2,6 +2,10 @@
 #
 # Makefile for io_uring
 
+ifdef CONFIG_GCOV_PROFILE_URING
+GCOV_PROFILE := y
+endif
+
 obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					tctx.o filetable.o rw.o net.o poll.o \
 					eventfd.o uring_cmd.o openclose.o \

-- 
Jens Axboe


