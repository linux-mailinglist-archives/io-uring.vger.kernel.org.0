Return-Path: <io-uring+bounces-641-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AFD585AC61
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 20:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A00AF1F226C9
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 19:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7D2D56445;
	Mon, 19 Feb 2024 19:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lU3AFtEU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD75F56448
	for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 19:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708372109; cv=none; b=jee+7gw8zEMNMjReO96xi+ZblOx+nq8Qv7N5mH35J8tZXVCV1Kyko8kGuTHwTW/zpFB6U99V/U8ne+RX6TmBtxzkvlpoRgnDnFBpZ49vs9NMf0MO7Bd5rFB9zPuYkNctfbCy0/ehjK5PN1kD0+W4WS230K2DdRnKchkmdJICITo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708372109; c=relaxed/simple;
	bh=ZlovF/E6dExG0QjXH9GL3i62dvwDxWjaVwesc1GWcng=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=h8iZwteYturdVip9PQYFp5DwwPvXa6ENbQdTCqkzBpVOBGjZyid4WRP2a9SMvc5tz7KWLpz/3WbNSi7AEPEnC4AqnDf1Xu7Jm0CJduy+5ZKVqcux0zBjzwwAzgWX6OScWkj1p8A+aLINiX1UZbaOIUNmTaLgJpcYKxXJYv4OMJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lU3AFtEU; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7c3d923f7cbso49022439f.0
        for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 11:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708372105; x=1708976905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=hRb77MmXkctjtDmFuDvxasWorC2l2dlu1FQdHw8/Hxc=;
        b=lU3AFtEUcuHf5fJEqIA5HcTMlNdt5Q+ucBAPYSCG1pdwcGzKo1WpWYR3oUUScj4/mV
         SO9x+Tg2rGuTUxfW8bios8YkGJdL7Xb2IxNXY/YqwhcV8hKONFkjspx/k5CyMgJ68nzr
         nMxY6p04DZ2nQNND5lw6CVVTMZm+3F88w8Uw8zsuNmis4pV75i7DmvRacke1OKHT1Ntn
         fm/Oo1C8iq6ExVAwVxaXwJp8TyxfocOQxSuJthnHE8PPfIaOUIxzJteUpJXCDd/kzpiW
         QjPIHp9+l05/sypjMmmwvCV+z+NSWIpq7tYLxkWi+YdgqeyF3IP401ZAzP5LG2shzl0F
         3Wag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708372105; x=1708976905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hRb77MmXkctjtDmFuDvxasWorC2l2dlu1FQdHw8/Hxc=;
        b=teX/K0vdf0wsngd0EIAfVJqbz568yp9ZxS3G89z8XBeqTUcom2UAGcGxPDu4a+2408
         nQLGLMk3e3Wrf+NJpic4Rbvn4Gt5ma3zYSScVC0E+LFdWGM2hzBQFuP64WUvB6YVIw2g
         ZX27hKpvQ8+E7yOhLT81NvwdGIJ5U0CNSOM4MDJ2wWh2H97eF2OGLMgls8y+l4aqIYSj
         LcdqqRBR/odho2cH3FULMEsEsZraKsJ0QhHGBQN+OH5wYP5I4swYWUJTIenhfDoyIA27
         id7Hy31HUIKafm0s7FGteNMu/5xwUYrkqcmyBWcKA9D6+jwaNoHWZX5m4ECv4SMIhs7E
         ZJfg==
X-Gm-Message-State: AOJu0YzC3aVQuSgB2VMUA9pa8qe2DIg0ZxObK2QBDIG5HOX5wZxAHLCe
	QQcUhQhcEpy8Gpvudby32USOmK8hwSrT/WbkfUu6jEgfeoe8lGWGzFL0S0uP7+xc7OxYVQ2TMvZ
	A
X-Google-Smtp-Source: AGHT+IGmv3itBs67nnkjaPlfDp/CxFxTkDBR/r9ylmCa38HgeBvTLp//7Y2zNoec0BjF9YpXS4Sftw==
X-Received: by 2002:a05:6e02:2144:b0:365:2f19:e58e with SMTP id d4-20020a056e02214400b003652f19e58emr3098530ilv.3.1708372105081;
        Mon, 19 Feb 2024 11:48:25 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j15-20020a056e02220f00b003639d3e5afdsm620302ilf.10.2024.02.19.11.48.24
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 11:48:24 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Support for provided buffers for send
Date: Mon, 19 Feb 2024 12:42:45 -0700
Message-ID: <20240219194754.3779108-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

We never supported provided buffers for sends, because it didn't seem
to make a lot of sense. But it actually does make a lot of sense! If
an app is receiving data, doing something with it, and then sending
either the same or another buffer out based on that, then if we use
provided buffers for sends we can guarantee that the sends are
serialized. This is because provided buffer rings are FIFO ordered,
as it's a ring buffer, and hence it doesn't really matter if you
have more than one send inflight.

This provides a nice efficiency win, but more importantly, it reduces
the complexity in the application as it no longer needs to track a
potential backlog of sends. The app just sets up a send based buffer
ring, exactly like it does for incoming data. And that's it, no more
dealing with serialized sends.

In some testing with proxy [1], in basic shuffling of packets I see
a 36% improvement with this over manually dealing with sends. That's
a pretty big win on top of making the app simpler.

This also opens the door for multishot send requests, which is an
interesting future venue to pursue!

You can also find the patches here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-send-queue

[1] https://git.kernel.dk/cgit/liburing/tree/examples/proxy.c

-- 
Jens Axboe


