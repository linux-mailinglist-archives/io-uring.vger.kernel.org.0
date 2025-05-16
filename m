Return-Path: <io-uring+bounces-7996-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF52ABA163
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:58:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC790501922
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFB821504A;
	Fri, 16 May 2025 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lC9xzada"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751D12063D2
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747414527; cv=none; b=oHWr3PO53Kqv/IgxGoYwwwSbbWADxjfTLW/UHoGCAD0fe2YOli1y7HbnW2msbSWUh+AudqKkP6PZo8F6bWCuBi1MnH0mOJeWigeL+5j7Ug5LjBokIEWWciVkjN1sp/l3x+nOZzyhm8db+YDUN5r5wudZrFC/Ge0hBQKThi1Pp4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747414527; c=relaxed/simple;
	bh=V0r5iml6KGVliJIksi3RWGM6u2JCugpq/6N4PBbxopE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aEHVaj4gxOIKznnX5y3afM+EwShR2gaXz+jhXC/SbmTFaTJGjJezQP8HpxlglZI7DE5Vy5UzZHBsIyfQB/624IRAWcrIdIuSQr2y/trWhiNocdPtiseHiKyTYB2OKi6k7ZT+DezFkuOYIGUI+ClGGkqfo1/mdwAY/2IP5OvWg60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lC9xzada; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3da831c17faso7428135ab.3
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747414523; x=1748019323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5IFrASazkto6jySbEFyUfA14GZ+ofQRsZb/j8usSlgw=;
        b=lC9xzadaTSoDLbLB7k+dYR2QMNp7umT2nT230F7Vwha9y8p08mi6kiw+fA9xwxFkQZ
         kzstp+P0+HFWyeirvg+OUsmMxCV6hoqWn6caEKatm1mT+bAtSGupim2fViKXCYApQXB/
         kW+aT9uONg1o/BiR3UpfHWIup88OV+1MiW3PXzYyGRmBP2E+lYU1OU6HkBUUqgsXJjd9
         XCH90VuaJE8nn5jK1gI4KYtpzHFeYpsezSXWTRnhxuYmVrQcr5WpcJiTG5xCtY2gA7li
         lKUvRunNDPLhA6JUq9vI6nLXSPHEQE8TafIwBppVF5C+5udC1qdDScwoDB8jGyAxoxEh
         LAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747414523; x=1748019323;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5IFrASazkto6jySbEFyUfA14GZ+ofQRsZb/j8usSlgw=;
        b=g1mk8hKsAs073xMX78ZDVy74tjmnN1Ajids1WgzD/Pdqm2uRbDn1vhn2ODf5tiWisB
         R9nV/Wt7CHjru9noOd49h3DdJ4Ii6fs/sw3nFrxlqQ3SZd6XE6WrXt2XkN3THDuurie0
         CmnA6y3hkIKyCkIMBaloZu3MgZH5eumtBGS6kELy9fp54KhTlaKx3PHAlcF1OlT+W4BY
         FvsbJkIV3p/VGK3lxS7GD47Bx+phNVkqhl9Ik7DgM0fAfTAk0FbwkqA6YLJguSkxw2mN
         uY0s6cMv3RPU2v6E3azT5jT6AptyVdK0jbbz1iGYlR5cwW3QXCYCbvt5R0u4Kwx1L3Cl
         N3EA==
X-Gm-Message-State: AOJu0YwiYs9eUJ7YPmlqsgC63QtlO4sEMsXMPR/HpAXwTkTpVUuSajbW
	QDju8ql1PXWCdkg9uHMKJZxbIxN9n5mVhHtb/fI+U/5AfjempMNPe3S50OuyOEAmQSYKihDTHBO
	BpEal
X-Gm-Gg: ASbGncuCfNNJ0WWWJwTvuSh7NewPBWYJi9LRHhqsFUmNT7KG0q7GDmx9rn5jBITvI9N
	rhpJqX44eCzy3+jOevt+cTtfmxmSMoYikVzwMLftm6f9baP9GUMZHpgGv8Igv1l/kZRgdmtsPRE
	+9vh3QLD/3vxqhGUVYbg/VLhCgpVEewZOHFdrF29yrM9EXTjrNoKE6qkYKLaFGiyciGoa7EFity
	5bsGwgJgIWoWt28n/1Dm4Zo1NX5ZTVRGv+udS2tloU+XM/xuUPGdlSR6E+yMieHigjrjoHnkDy+
	7EqcaXDuFKcFiDJ/Dn+FlVxZXrRbtwK+ibpkkSG1neSX6iLsMNYFrgo=
X-Google-Smtp-Source: AGHT+IHZAZSrKILrDDLUtl19NA4C5GImq5MEY4FvuKnIbn5DfTSjCHRTvSLo4VDYZTQtjiw3OYonyg==
X-Received: by 2002:a05:6e02:2704:b0:3d6:cbed:330c with SMTP id e9e14a558f8ab-3db84312f2emr44292545ab.11.1747414522884;
        Fri, 16 May 2025 09:55:22 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc38a87csm480344173.10.2025.05.16.09.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 09:55:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com
Subject: [PATCHSET v2 0/3] Allow non-atomic allocs for overflows
Date: Fri, 16 May 2025 10:55:09 -0600
Message-ID: <20250516165518.429979-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is heavily inspired by the series that Pavel posted here:

https://lore.kernel.org/io-uring/cover.1747209332.git.asml.silence@gmail.com/

since I do think that potentially increasing the reliability of overflow
handling is a worthy endeavour. It's just somewhat simpler as it doesn't
move anything around really, it just does the split of allocating
the overflow entry separately from adding it to the io_ring_ctx context.

Further cleanups could be done on top of this, obviously.

 io_uring/io_uring.c | 75 ++++++++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 28 deletions(-)

Since v1:
- Include patch from Pavel open coding io_req_cqe_overflow()
- Fix silly thinko in __io_submit_flush_completions()

-- 
Jens Axboe


