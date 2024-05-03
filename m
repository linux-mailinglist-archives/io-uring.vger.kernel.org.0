Return-Path: <io-uring+bounces-1739-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 079C28BB826
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 01:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3936F1C20D3C
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DFF883CA6;
	Fri,  3 May 2024 23:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ntOEVPHh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129DC83A0A
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 23:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714778484; cv=none; b=lzDwf0ZU7RrLw3ZvCPDWm6egwNnNoOUyDv9SwuJ3ojXPcsu3Fimiac0RtGQSoV6byMYxgkEEa+0UHt6h7kcNnG7JHvskM5kxu4380Zl0rHmtZq0QpfgiVJTxvTWAayWsMMq3bNVvlnGVUlpPCBf9LA+0qhypsCmAYDGLerXZxmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714778484; c=relaxed/simple;
	bh=JFz4W1O7PBh1TWuHYSTsZl3JZ4bwL07AsyYT8GjzFs0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=j2lkeuKfJgFx4TWv6LK/pbaWUtbw/UIziDkFE4h3HICqHCal8qNmqqUBduPZlprM5qoNHbouQzY41y6QF7I88rxZEzZkRuiu4t1U8qqbB5J0vOSRAtKmD0ech9js5FsYXD8xl/pUnniGR7D7Vlo9gFaG+rQa/lHIN6mvGc2R0AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ntOEVPHh; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e5c7d087e1so1584435ad.0
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 16:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714778482; x=1715383282; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lCOduIamhHxZX+BXYRZ0ol9/CGuEvzTDNoGxS5VMHo0=;
        b=ntOEVPHh9wQQzNj9KqcqfsASxKaadnZuiscTwQrWdFDuofhnkIfBJ54oPxkIx0JL5x
         pddkw4+fWFhdwLNEAnaigxQeWxcqzmiDOhpZzpadJw1IrS3Jl2h/LZ8zvSueYiaZyaWb
         hplNmCIWOB/rdmooPDncIw362fcNi4jT6CvI9PM+xhWJTiTg79ryAsTOT7v1Nw5eDUCL
         ss9Kzy325MEqQh8so6wY7A02zYkWM6jbhQ62Ho1hq8TT2QcROuq9TPPzmvskSfh3bczi
         XPt42ajp60bqHnNmfXgBtpC5m5jti9a09FiiXcsjhdOyfBkjtT6ESAFZhaEOQVQhV2bC
         gAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714778482; x=1715383282;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lCOduIamhHxZX+BXYRZ0ol9/CGuEvzTDNoGxS5VMHo0=;
        b=mNt2UvZ/luCk5mizd+aU03gLN51j/nAAZCbfdFSMJRLyRHINq8LudOhx02WO9yNIJF
         KCCJ0kv/cPuAmctQVenlnGtcun5G5ZzQB2J5ELxm4Jg9bKmRyK4EcU9dyy2qXjXri0Nj
         P7kmgykA/J6ZLWmg0HqYWjG3/ZYmdmBfjT9fvmfCAHUT/lTeWkwliLL5XZqbco/UfpHW
         G8eyJUwMqfiMtPsFK8NDM3YHYHSyNx+6w9ZKvnaJMqMzNDNcVp3YKyogOWLcUjQlngYf
         QmenuvnrCCNi0aKcvec/OTrDVUZ3IrVj1SKf4OxJRyVDPHG/a8uvbLZSH1qVD0smJUUp
         sDGQ==
X-Gm-Message-State: AOJu0YznxHFVqhqKd/0YBMhU0vNSGVsAEwAC/K+GMSPpOuwXzZf7SUYn
	yxq1GxpZdKzhOOWpqSWWpQmqC/lXIBaojlMwvjJwVCFjdlURTui9y8/MYX0DJeaCrkvX8JYEM61
	Rs1tswLhXzGM7eJJuly08Sqwo5mCXQe+8
X-Google-Smtp-Source: AGHT+IGErYnITxOf0CvAioqSn/pD7q+jGCjfw3FqlJTu1zVkC6du6QDpoeBsQbzxptXgai/nKdO02AVoy0TYoPZajXs=
X-Received: by 2002:a17:90a:4bc8:b0:2b2:812d:dccc with SMTP id
 u8-20020a17090a4bc800b002b2812ddcccmr4088510pjl.13.1714778481971; Fri, 03 May
 2024 16:21:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Alexander Babayants <babayants.alexander@gmail.com>
Date: Sat, 4 May 2024 02:21:10 +0300
Message-ID: <CAB92dJbb3aMD14sHwQGDQYofj3H5hH84QTXuzQZ44TZQp0j1Ew@mail.gmail.com>
Subject: Submitting IO events with IORING_FEAT_NODROP and overflown CQ ring
To: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi!

Per io_uring_setup(2):

> IORING_FEAT_NODROP
...
> If this overflow condition is entered,
> attempting to submit more IO will fail with the -EBUSY
> error value, if it can't flush the overflown events to the
> CQ ring. If this happens, the application must reap events
> from the CQ ring and attempt the submit again.

But I'm not getting -EBUSY on a 6.2 kernel when submitting to the ring
with a full CQ ring and an overflow flag set. I'm not an expert in
uring code, but it seems the error was removed in commit
1b346e4aa8e79227391ffd6b7c6ee5acf0fa8bfc. Could you please check if
I'm right and if that change was intentional?

-- 
Regards,
Alexander Babayants.

