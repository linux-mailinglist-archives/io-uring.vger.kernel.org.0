Return-Path: <io-uring+bounces-6277-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3544EA29B24
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 21:26:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B94761646B8
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 20:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B596C211A0B;
	Wed,  5 Feb 2025 20:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gYsdX4yU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F021519AD
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 20:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738787208; cv=none; b=ldU2mMeZwvnTSHlrK1YidFHH22BYHtZZUfBBKpg7AMtHBnTyyJqJGes+xl58PFjGxUoNYf2c4f+N1VdRCzkgXSyYYPbFZamzcZb+5kMu0RwVQI4wpo7IGn7UGy1Kv6iO54eWrGHJW7GJIgGH/sjkUrXNlfnpdkwf37KYo1c6x48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738787208; c=relaxed/simple;
	bh=0Wi+xdg2kXt2Rgl6bfYdfPn0TSKssWbgIfhyB4VzSww=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Eo+vd8tpgtVIIs97MoADkH6xnWjgHy5DWJKEUVJUm8yrl/iXdv2wkFtfwK/Wvp3RYKozZ6qiqNnFociE0KK+YCaqzbHoDrQ2wGZl2hnLih77ouf4/M5DnGy/G6vuFg7f/KUVUxpxt2WmB/kOp3lJEsseu6Sfwh5dszS/KJoq3T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gYsdX4yU; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3cfae81ab24so371155ab.3
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 12:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738787204; x=1739392004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=QmvjPdH25/Gihmizh0kj7rQ7rvt5HY4qZ/gISNPtCYI=;
        b=gYsdX4yURh3n0RT2fVU1cAWkKapR68omag4lira6xJ3cBna0MkmvtaofwL5qwIdJsk
         IAnxk6D8wd+UwDoC69U1lkkLbMIhIaYxjIIF1Pwp51yGTBo+pZkoORL3CQxlGdpknjis
         4k/LvpdCPzbxHaFB3a2sMu8S456tgl+GBLnjdUpLJU4AVJmzucHVoUntj13gjq2wBUID
         AjeLKhKDhPut28Ipkl1T7g3J1B/Nj2lGRBma0WWeAHmRup4niha1rdrMlxNeo7UEPzDa
         PIF3xzYbHXjT2RGHyZ4Ho3WS5Gp2t4a4D37+If8ROfXy/Iu3OEYedEnpaSeVinopcwzZ
         oKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738787204; x=1739392004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QmvjPdH25/Gihmizh0kj7rQ7rvt5HY4qZ/gISNPtCYI=;
        b=nEka+VvUmuev/Nys/otUHTfyy1WCItc7BziFjqYDahHEJA2i2KjIxQxmeL10abO1oS
         tA5EiWVOFVlAUUsaGW6ChG1X0iO5Hl2/AasJB6hqwX6CchJXUkX8ZXbvkSzcUPud6Smb
         W0mvFYyb0/YklNsjwr7iJY7RqfIiu/ZULaaRH3MpORPevzA+x+GYtJOjzei0Ib75Qimn
         Wp/HD3+FYQPJIORQ3HhoB0gnorDQgPlEpIvCa9sYyxPmOc/V12KStRmsC9PRkUAmm+TY
         cHKNZIGGKnC9lx2UXCYyKunY/MmPsvtfmeASufyM11SOsf/xFFsQW7xz1IgfZJwH/Q+l
         A1lQ==
X-Gm-Message-State: AOJu0YxZo7yWerID0FpHxhEHf5UzKNY6LEo4sVvKqUtQ4pkMBvbCQzh5
	neudcf/qehUzRKCoZHGnCdCk2Dj+bmcGbunPXGvBnw7unlkaqYg4uJPXTay6WPUSVPWjCbZplE+
	g
X-Gm-Gg: ASbGnctnlHM1af1+y3bKNMaIOuBXqOks8zsHg6pWesjCPDBWbI2PP98Ob5nA5otzOSF
	ZcZhXj27DFX4XQtCizlAD5lxB1RZOKJtsy/yMPegUFbz5c5OkbjssSPIdqeERLDA/7NZkXik71+
	wwcTaehX8aXdPGeBkV+lnAVL0JXYtu27pGQ/14GzO6dgp/7Zo2lGyjEMT4VGi53UvZ7RV55+AuQ
	z2xQQPuw15/FXVMGFE/ysrt6LwfKsP3jiFPyaw4cjGXvGhbb1CaTXICRNa3utsycX0HlNtrnrBg
	DZR6csZsJy1eumCnUUw=
X-Google-Smtp-Source: AGHT+IEDPmQpOKQf0urJlfW63hPrIcL6evcfnnN/NusmMLvuz+YEYciu8K9+ZIzRDJ2Cl13IpRnOCQ==
X-Received: by 2002:a05:6e02:3993:b0:3cf:b9b8:5052 with SMTP id e9e14a558f8ab-3d04f40271fmr47632195ab.3.1738787203709;
        Wed, 05 Feb 2025 12:26:43 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec7458ed51sm3352071173.23.2025.02.05.12.26.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 12:26:43 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/6] Cancelation cleanups
Date: Wed,  5 Feb 2025 13:26:07 -0700
Message-ID: <20250205202641.646812-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

While adding another cancelable request type, I noticed that there's a
bit of boilerplate code for supporting that. This patch series gets rid
of the generic hlist_head based cancel implementations and adds a
generic one instead that both futex and waitid can use. The pending
epoll wait implementation will be able to use it too.

 io_uring/cancel.c | 41 +++++++++++++++++++++++++++++++++++++++++
 io_uring/cancel.h |  8 ++++++++
 io_uring/futex.c  | 42 +++---------------------------------------
 io_uring/waitid.c | 42 +++---------------------------------------
 4 files changed, 55 insertions(+), 78 deletions(-)

-- 
Jens Axboe


