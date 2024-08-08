Return-Path: <io-uring+bounces-2667-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B02D94B4C0
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 03:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD3DD1C20FCA
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 01:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEFAC29A2;
	Thu,  8 Aug 2024 01:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lVctir/C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611238827
	for <io-uring@vger.kernel.org>; Thu,  8 Aug 2024 01:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723081710; cv=none; b=TgAEXsuUlZvxh+IKsy2h5sH66zrgbCHoCg7onBt84b0201U3vOQ+oFM93uBGaLxw/E1EhdPetQq752kvmiMVo4Bz57UGFM6Hp4JT3gO4m8+fF43DjrevNmCEKO43t0W3gs9PJRNoREkE7unWt34V2MaDvuYyx/3Mg72qKIf+4bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723081710; c=relaxed/simple;
	bh=xSSvutlKO45xrO72i8+aAp6H3tQ4UExzUaOYq4XdA+8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pYON3A2FWjQ2tzVn1dPHYQaD+KkMEwC3c/L5FyAU5A/RvjTDmwpK83Do5uMtkWnwZ/TkjnY1PWFLFIB66TttZvqMHoY3lkQczKt89ATy6sKFmLzA+PD7TXHjEayjLF7h+BchuTYVFHb+rktCKDJNCoYy5Bc6vWQjrM5rTVVt25w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lVctir/C; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-70d39a836ccso37692b3a.0
        for <io-uring@vger.kernel.org>; Wed, 07 Aug 2024 18:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723081706; x=1723686506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=NSDbh/MWSs+C0XzX9WmM5SkuG0oiuq5+DxRDAKUe9lY=;
        b=lVctir/CtR+YU2TBKbgcCs3dtNIV4W3xIUisEGqcaYkCVkRaSSSFSvOybM3Ef8pbUU
         iGdlxI9MXbpLoFZPq7b7410l9PXbN4XSB3+0oavBCj6oHvig8ZCz2iannEFnX7kJUt3W
         XwbdXhsOW9v8rTmVWoD97SkxJC7zQZcZiZzgTUAdFewNsaElFPYKCGgOMD5xr9PX0jrC
         +2wDfJrz7kiwKzYp5Eec0po3BCkM+JA4HJGCQC2IwYIwo4lRTwuQMU3BgpNgbKccroZi
         IyqjRYdnNctHdbYyRKpEbm8OEuvGFWKMPI96pvyYGcZVyOHPvSyMXREZQGFe0cnreFo3
         XGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723081706; x=1723686506;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NSDbh/MWSs+C0XzX9WmM5SkuG0oiuq5+DxRDAKUe9lY=;
        b=MUbBokWIPLGiPUHTQfy6FcNu0Znfcie9IycBIpJZELtDpX3XZlN4qfIQYEoRk4alVD
         nZhgFurnV9fbvk/x0IM0xImIJR2qnM6LvMKuLjWQf40P6GMDu0ev8ex1YRa4wAewuuO9
         781pjjZu92I53e0cPff7lWW8ZQCL+ywLG0mvKQwQd69AljTUpyf1AfhW/YGNF7hGz0cO
         Ef+8vfLHQ6ti8YSIP3aKvlOM7YYtn9/tbitWtUUGC7xOTm9BPkGarE0Yj90qh5Lc87cj
         2Cgv+DnyUWHuaIzcoKNUxdFp8+p1YJgz49vfJp8Fo8MRAi4CS1IB8e/8KfD8xGtvMNjx
         YLCw==
X-Gm-Message-State: AOJu0YwFCRUmZr51taKfZcXhqFw+Gpc+lySwjcjkneCNBbYWKr6Oixxj
	r44L3xpAYStwkzMqiQ2QpMp/SSufr5f75ICSFDy76MJQLod5leWBUSKxF2ZxeNnaD4oa8dq9+n1
	0
X-Google-Smtp-Source: AGHT+IGcTpu8s4GeQGCkh7zE2INZHxwXX+0QRnPekp3qtsP6ZM39pKP5mzK6vUdC8oOcjdDPPNJEiQ==
X-Received: by 2002:a05:6a00:a8d:b0:70b:705f:8c5d with SMTP id d2e1a72fcca58-710caf37c8emr334532b3a.4.1723081705958;
        Wed, 07 Aug 2024 18:48:25 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710cb20a104sm150771b3a.21.2024.08.07.18.48.25
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 18:48:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCH 0/3] send/recv bundle fixes
Date: Wed,  7 Aug 2024 19:47:26 -0600
Message-ID: <20240808014823.272751-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Just three minor fixes for 6.11, all marked for stable as well. Two
of them fix a missing REQ_F_NEED_CLEANUP being set for recv and send,
and the last one fixes non-bundle sends potentially picking more than
one buffer. Only bundle sends should do that.

-- 
Jens Axboe


