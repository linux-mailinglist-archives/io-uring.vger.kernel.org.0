Return-Path: <io-uring+bounces-7487-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 372F8A9078B
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 17:20:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B40271906CDE
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 15:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F3502080D5;
	Wed, 16 Apr 2025 15:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lnvr2itt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C37207A18
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 15:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744816813; cv=none; b=CUWu4vFl77IUDpcqM0RGHX7g3PLS0eVT//ivcVPQfOzQMY+fvksXkdDRt0me/RK04VOYbCkJSaANYMZErQRCMjNLbYccC9C25gt2vmGzmua3RmN14j3Wd4C3Cx2ooVpH0tQ/9nXfv8L4cNCYz6ngRu0TCmxwEda0QkFPRmhPHGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744816813; c=relaxed/simple;
	bh=Q5lDnnGAJ+1slYiPymwywtu05p3TmNM0vuv4mO5lDxE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qK0cNWO2xtCk425+1e+kdTSIVgE7D05LpJhcL2+Z0KYiz2ZuLS/mBRijFRw2DoS4RDEfEFag6rA7LIWX0MsIOQiEUqVWkRnbsw00f3y3sPKR9I1aF69KHScMO9K2fKSC832QE7VOt9YzFFbCPPEw0MFRyJQ3s0EoMlZ/nXgtnAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lnvr2itt; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ac3eb3fdd2eso1280200066b.0
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 08:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744816807; x=1745421607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=seL6LAHibteAcqv/f3qdkug1yhJBJ1e/FeNjbuK5D1Q=;
        b=Lnvr2itt8PBTJW57pnrPjN2uEaEQXOMj+jMxg/Gvl6xjcWjtAgVlmCuLCkYsA1xHBS
         WvCD4gdKBbjsR0EW+XjQ02/PMkH102vd0t8bT9r5909euEHCICVHMNAukwlH0xPS+dqx
         phG2GQl0zvgBbzSZJ1zXEUl1/mOzkEMHjgunnQPNdWvHMuwc8uucriuZBuJzDNCSP7Hg
         RnFDv45jVJVVNud1pOEzkpSu0QXQcpuhlMNlD6r6ySzkQANZyEXN7T6Op0PFrLImbykA
         wrKnUvOi7eJgBLEO6RvSgO5Dx2ExvpADdAUTA7HkVsFjKjrtRuNN4FALNsZCr1S9nwkS
         llLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744816807; x=1745421607;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=seL6LAHibteAcqv/f3qdkug1yhJBJ1e/FeNjbuK5D1Q=;
        b=PLVYwGdlLvGJvt3ScdZAFBvvfxx/yrUJRggjnt29wwCk1Xz0HvDOgsHZKhFdlJ5Jr0
         rpnHqMDKSVwP1rYCPmkMg03R0yLIWKvipDiTgij4kcSrfENo8BsdYJQRw2NfXuX4su+z
         TNi6yt9H+FlTN3grgPV1WscY/PwKAqTfHDL3BPAXW2Tl9HV+Uu1y+ZgnJ0KLuHH4LS2H
         ybZruiMtNARtjErp7NyYdo9OniTTIGW+iGgvsbIX6T4yV67nzMYS8vVg7XfamH79T/m0
         3m2JYTcWudVwnr9K02Erik6ZDS0ESRvK64Mb5FyM8I3HroRzaE9lRjYvsmnoJshfRACN
         Fdvw==
X-Gm-Message-State: AOJu0YyuUaeq1+4D0CMdBGeGb4+O3OI1onyOWNBVeIEthUWdlUMNkHsu
	KYvYm+Orp3D1p0EATKX8dbHmRKP7cXkOthDEIuGuXpl8WG8xpvcRCHO9KAoj
X-Gm-Gg: ASbGnct1EvWhlTEg2aG0XPLcHPSjP96ICBrCUZ8gNNGyIvuKX57ucMHW6tHC9/8p+Bo
	hWHwbHio/PKIVlhEHZJh3oes065/RDWwfZ6VCFcUA+KHdeZt46PoyOkWLYno1iXYDeISM5SVXlb
	T7PbjLfBmPnck31Bu4D9beNsf3fefNuvVBIasYXcl32JKLz34b63VSRzyijF472PiI7jjWPm3vp
	3H4eK0ajpXJ5EXPmp6e0fwD3sqNuHE8oTsfPdcIzzEmGNywWcbmwv0aJvWPeoDM/eN7ttnc5lLy
	8kKej8S5yTIcmM2VZ7buWeOa
X-Google-Smtp-Source: AGHT+IEmBVln8cHAH2yoVw/HQ5bcB5AYOBlVPKbkld6LuzUfkZb1pDF1TDVlGqSoje/AfiFPj4tM0g==
X-Received: by 2002:a17:907:7213:b0:ac3:aae:40c6 with SMTP id a640c23a62f3a-acb42879791mr180258866b.8.1744816806925;
        Wed, 16 Apr 2025 08:20:06 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:1ccb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3cd61f75sm144579566b.35.2025.04.16.08.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 08:20:06 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 0/5] add support for multiple ifqs per io_uring
Date: Wed, 16 Apr 2025 16:21:15 +0100
Message-ID: <cover.1744815316.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Note: depends on patches queued for 6.15-rcN.

Patches 3-5 allow to register multiple ifqs within a single io_uring
instance. That should be useful for setups with multiple interfaces.

Patch 1 and 2 and not related but I just bundled them together.

Pavel Begunkov (5):
  io_uring/zcrx: remove duplicated freelist init
  io_uring/zcrx: move io_zcrx_iov_page
  io_uring/zcrx: let zcrx choose region for mmaping
  io_uring/zcrx: move zcrx region to struct io_zcrx_ifq
  io_uring/zcrx: add support for multiple ifqs

 include/linux/io_uring_types.h |  7 +--
 io_uring/io_uring.c            |  3 +-
 io_uring/memmap.c              | 10 ++--
 io_uring/net.c                 |  8 ++-
 io_uring/zcrx.c                | 90 +++++++++++++++++++++-------------
 io_uring/zcrx.h                |  8 +++
 6 files changed, 78 insertions(+), 48 deletions(-)

-- 
2.48.1


