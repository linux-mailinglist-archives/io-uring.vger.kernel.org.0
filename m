Return-Path: <io-uring+bounces-541-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC25284BAE3
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:27:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A938F288A12
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9221AB7E2;
	Tue,  6 Feb 2024 16:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NlYIkPF5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEDE134CCA
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236851; cv=none; b=VP8xKGceniuYuDsJyIWIVUpRXqf888jQ5lhvETJ1lRkF84XWQlWENJC4bF8uFFn7y8882fZXm8oq5e5MSdLZORqHsIQf4SvlgdmpUdtEvu+Gt5vRKDsftYwApwBDuAK9o+47wMn0/7C3ID/j2KYgDuH9dKsT6OAkvee/0TL0beg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236851; c=relaxed/simple;
	bh=Ij/EvQIaWuRqRKkKXUt1QY7yol0GLlQ6hlDSiFH+x1A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=JYzn5xtRaHuP3cZemK/SgJESQkOww/I1TsvYAFhfxMGyCumao4jLDWXThQ/gge8o9fdopbv9C5plTJlqkrC1VLe9vQZshPd3zGczdzqmWz061omVhxCz7WEdEYgEbkj/VBWbi5cGj/5ECHYluKg//6ycWMQDAvDe6Hi3zRz5o7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NlYIkPF5; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7c3d923f7cbso16619539f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236848; x=1707841648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=5QTKV5gfppSZpuUUYZV5nNsxxWuqBdShUozA3rjk79s=;
        b=NlYIkPF59xvMBms610Je1EjBcpS3h3/v5Hz+zP6Ck/4o/x42EBuQ9hW0m6lbvpUiU5
         4fmQE/PVwwoOPaMMolVWxgSooXhcH7JIfL8UiBLB3n6JAl2B3owqkdwBfieukMhJJDMd
         rxCdcgZMhSjPHwHoaybmOpZgVjlbBNkw965i8NmW/gMhW0Z6AuKN//LiP39uGOHqhP71
         gm7b0eq9XLc4XkeHNCmeG+b1hnxMrXLRGgzX8X2QHwDhpDaihdiz1QQzscxfsTs/swW0
         0PgaGvGCOQyTbyfJpHYpLcsZ37sJD1F1SLm8fksmgXu/pQ2PAodMkS99it0dGjkBfJmu
         BEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236848; x=1707841648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5QTKV5gfppSZpuUUYZV5nNsxxWuqBdShUozA3rjk79s=;
        b=p9ps0fyoTxy7/Dw6++8Fdyx809AsBu8w6zVSVDSv4EsJYG7jaoWHsTksG7FgiYqn//
         YadKbUB1n926+5rAMUViSGEW2kXB5E/OrjR61htGqxL49KSJxrq/bcRUB7wwlFeFuZm2
         Rm6P8JZ1InFt5TmEzXXdhPQ/jJKaplkPi5lgP5iobaAEa7eHvVC0PeOXVvu8p7Q/0RPV
         wxbRRp1P2LD6EIfWuh8XI8WNhTx8e3QRkxNJhyztNHuUUCSHqMjrC5+SuC/jOpI3jcvz
         SCDYM1so3jZGrT3C2SvHAlqrJJp9tcADtAH1+f1GC+IOPSToTv10jqvaxeBMlySwBt43
         3KjQ==
X-Gm-Message-State: AOJu0YzKy9lSgLwDUoGot1GX7ovV/IhJXYbf1sPiexn2G/ihDlwRgWNJ
	cFx23jheyWBbSu9K7MB7A0EQ46eK8K03R3r60AHSwkOsWNEQAvf5pPPKMr6ems761LI2chF9Fp1
	cFkI=
X-Google-Smtp-Source: AGHT+IHiJ6IT7neA8A9em0GfCpArvMGMo1tud/rFFJ+VjDorNfVRfaWZ9fyGjB7C1hu1g+EWkhKntQ==
X-Received: by 2002:a05:6602:2bcf:b0:7c3:eaf9:2cd with SMTP id s15-20020a0566022bcf00b007c3eaf902cdmr3509731iov.2.1707236848433;
        Tue, 06 Feb 2024 08:27:28 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a6b6601000000b007bffd556183sm513309ioc.14.2024.02.06.08.27.27
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:27:28 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET next 0/10] Various network improvements
Date: Tue,  6 Feb 2024 09:24:34 -0700
Message-ID: <20240206162726.644202-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series was mostly driven by a report on how the unfair handling
of task_work can negatively impact performance as a whole.

- Improve how we recycle/put ring provided kbufs. Not related to
  the issue at hand, but it does improve that side.

- Improve how we deal with non-local task_work. Don't have unbounded
  looping, and handle them in issue order, like we do for local
  task_work.

- Decouple SQPOLL task_work from actual task_work.

-- 
Jens Axboe


