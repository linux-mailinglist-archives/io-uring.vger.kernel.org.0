Return-Path: <io-uring+bounces-533-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DAEE84BACD
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50B1A1C23418
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B418134CCA;
	Tue,  6 Feb 2024 16:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DRowvDeX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8B312E1ED
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236650; cv=none; b=gbwT1iK9Dvft15RhlJ1fZq4sViH++gSX/yzDOf0qmDI23uo9sVuWGgk6npbOv/XXSkjBLuONvGg1aoPau1BZvrUHQedrL4XJhHb8YdeXbYtI7kjt5VgA7VVG26GO/RMjPknWPCj8ZXifTt5dLUqNio5gKRayldzbw0AQc3nQOGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236650; c=relaxed/simple;
	bh=LJSWVpNcUw7fMdRtiSt27KpwkwsGZxsHWfLgRooeQEo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=KYzk0u3Jf4DlP9x7Tk6IELTFKDjHgDKIe0oDBZ9W07mrQcZDyy7vLy5nOKBiSvLvgbenD8Vh1UHcQZbw+gOEKlbmtT8rooaDrsgWGdwoshHkR70gMVG4aJpy1n75wdoxXKSEzV8ZmUFqHQeE64Wbypuh+xmiJdV0HYBXvnjNVWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DRowvDeX; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso98689039f.1
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236646; x=1707841446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=FmLwNg6DUwFcYg4CbEE7vZwAp5ucxMOhQWD6a5wwF3c=;
        b=DRowvDeXuCvgtC9HKin6v+M8yy5Oyd6twrEWpWas87Fh1Ef2eUkolcHmREQdrfDEr/
         lzV5WvntYr6aYlS61mHqYXUDlua4RO+1gM+ek4Mu36QQXlyGOQvFjR5bcieNQ2/evm/y
         oCdBvQqkEDejm48mkLGY6wvfVQ/ud/Blfo8XUqzy5Wk0VoutF2G+GH1Cth0rZO8hFSzJ
         WzRMv10UqVcl/B9cg7G0Ya1wfqYrlWJoLz3sZ/hIKFNGU5DrPdBQrPQDmUDcfABlaJ72
         //ZAm40IZ/m9OvZ78BwKA28lpmVSqbkZDOvwyU9RGWDauJYCC6TvuOGjmt6FEAX8REbF
         c9IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236646; x=1707841446;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FmLwNg6DUwFcYg4CbEE7vZwAp5ucxMOhQWD6a5wwF3c=;
        b=wwRMKOAEpH0yYbSqL7E42yPqbN8ywAqcZW5kCa+ykhcJSHyd6Mn7j7ufaF5vQJghDt
         cBwGunMoVhtEtsW51zuqupa9bCj9h/ghx/ozVLRo9QXzfdQ0kOVRvBP/xsFnbHi64c26
         IZLrgFKyf+/Bfo52MNHw5xiVW2MpD37mQOM9VJGxHRl4bTpNDEQ0HnR914em7j6JabU4
         0IvB1cZ1mzQTmLDyglzWscnDoa6R6JNYISeOecbmD1pgyCheiZkFigGR+NHlRxkkeCsd
         jYDBIC1PE6xL6h4SXKZLTC2wepnGcfLd9kvnF+Xu5i35uwNYeUz3jE5F57zcD4HW2G5Y
         pm8A==
X-Gm-Message-State: AOJu0YxdHM4Pa6Y5IjkLbIMR1Yc2ELgzS9TFRfGbU1KgexjYgVxAC6HA
	/nsC1qV+m7lzNFY25pU5/ZLKUFu+AE+UGC+d+HkdPO3/vFmHX/P6yNV10RSrtgalUlLVamTFiUk
	a5po=
X-Google-Smtp-Source: AGHT+IFZ0Q1mqj/teZg1rBZhoDfEtEk/jX8qFUIHLAkbqRYZ8Ikoil556bsFPBrtxVo2StbZcTqMRA==
X-Received: by 2002:a05:6602:123a:b0:7c0:2ea0:b046 with SMTP id z26-20020a056602123a00b007c02ea0b046mr3667731iot.1.1707236645759;
        Tue, 06 Feb 2024 08:24:05 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v17-20020a6b5b11000000b007bfe5fb5e0dsm520031ioh.51.2024.02.06.08.24.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:24:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET next 0/6] Misc cleanups / optimizations
Date: Tue,  6 Feb 2024 09:22:46 -0700
Message-ID: <20240206162402.643507-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Nothing major in here:

- Expand io_kiocb flags to 64-bits, so we can use two more bits for
  caching cancelation sequence and pollable state.
- Misc cleanups

-- 
Jens Axboe


