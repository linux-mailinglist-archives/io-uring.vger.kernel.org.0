Return-Path: <io-uring+bounces-8474-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31BE1AE66B5
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 15:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2D4A7AAFA2
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 13:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A885628ECE2;
	Tue, 24 Jun 2025 13:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m6vxqhTl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABE06F06B
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 13:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750772360; cv=none; b=EXhg2wUWev2w8N7t1GJ2R0jpck6XYs4FLmzEwrRm0foRFkQCVTEaAlaQrP+Oq/EqqsbtL926LwXyR6SnQg2GXtvUyVLqmw4Vh8Nlmqvi5OGsGi8dJAHEaEgLqcj4w8Q/kFOYTI6PnYlUEXU1brkTOHSJ1EJOD+uSxf9ggMoPrAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750772360; c=relaxed/simple;
	bh=Cpx+tCyB9yivcE1LX9MSrfO8HLQJVGxcbZejq6CWOHw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p+fzuSaWrwEzWvysDUsdDgZzpbWx+/f/8efG14IZjbFK2qMdkJmt+a1eRR20rVsb+umlcNcRttmRcKATwU8RDjJRttdh0lFqeuWflUaaHX8Q1efSGK3hPs9MnnWpHaQUDhbX3yIFajw4377RZdBMJ3zqFNFC03OdkA7g1GVeLIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m6vxqhTl; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6097d144923so10859238a12.1
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 06:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750772356; x=1751377156; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X+zlsb0fssXkSBXGVRdaQDZhaxel3cDRMduBlG+RwyY=;
        b=m6vxqhTlqzJfSHntphGzuYEoe8qLRkcbCbGu+wDrFYT/I7mHmbiLF+rHiAMNThsUAo
         tFnRh9cxEVUx1Y0iJrSvw/3RNe9hWXPtNSH5Jw8Jx0l8h7PkrUtr10xbX1lel2VqckKD
         HDgX1FVij+GhzXMYjaznMVWW1Rcdi4I2+5ug3JT+SdCWN6mkg2TNhz2WnJNYiSdXv6cz
         mwds2qOGt/WaqCnujvl/OPc0e6wdZTH+wDatylBLX86sPbsNkLl1jwZz5RmPRTuOGtCk
         YSYRqsG5OjPaxALeV6rzmeqI2nPNmpusY279lOuQ/bhZiKN8NWC3Ae1cdSFAv/JTmrf7
         w/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750772356; x=1751377156;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X+zlsb0fssXkSBXGVRdaQDZhaxel3cDRMduBlG+RwyY=;
        b=EZPABvJzie0kyBXix7zIzgS+VP/NasYCT9d0uosdwwdxcmMIB8/AJGalPGJz9cskEA
         ods/VJUFo9eOhaGhpLfWEBB1uJp23z0YXSAEuSR6GnM0BLqc7CLfJzfAKRDPWNgF8JK0
         MzZgt9RsAytxGUSkm3Bc9nw6LrXOTHuxe84krtdAz+vRFlle39u4xzvwBzE/RlcFhmAq
         JjEeJpiThPKA8DhBsD6DrFguvcO9Nwg0Hi/Bo46++p1LpaX/FMckrBhLgATL1J6hO2m7
         d8WJ1FHbZ1YgcCCKaN0HOpE6RYTwWHqgDzW2vi0YEHFCQBLY4ZQz/7X6wg5IArhxc3S0
         PNCg==
X-Gm-Message-State: AOJu0YyayU5NiD2R+cvy+/f4PplfffUdOgCUNJGPT9isI2bxXfUluPoG
	dbHIP1zZ1/8YhKjwSzI8SFftBbD3jvVJMcb7TEkZ7zpzk7KxFcv4QNh+v3mRbQ==
X-Gm-Gg: ASbGncs/VTEBDqo3muTTtI1w8jQEVoL37kPDGPXjA6XM0Naa4z3BhS4UPYkHhSU0JqA
	qgpGkLbWhNJn/4vC97RphSPx/JSHGr8urBmV3kBi46Bw1FunOcILhYOSPK5HRHIJSu8vLZ/cESj
	u37M7F9lf+lPt3s/qsPAlNkzGa9jGSB4unBJQiZULTVQkhSpk7me+iMHndQjDCrzwmhHXgoXI0l
	FhXEFhgpiVdOXYxp+lpwFFCCv2tf8ELQAp30cjtshvA1GGEyar9+R7YKs4V67FYubwRRIzz0iPL
	zY4kDiGm5mVIgUz/BbZavQs7ncJicfwrG2Bigbyq1DRfduLNwRBqBU36
X-Google-Smtp-Source: AGHT+IHwfbjMbV40onHy2VTXlruaDBpHVqUAorr7bXvI8kaVtBWlA1h3oBZlnaz4LwEOImLYz5PI7A==
X-Received: by 2002:a05:6402:909:b0:602:a0:1f2c with SMTP id 4fb4d7f45d1cf-60c190b6495mr2534093a12.9.1750772355617;
        Tue, 24 Jun 2025 06:39:15 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c2f196e13sm1052892a12.11.2025.06.24.06.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:39:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 0/3] io_uring mm related abuses
Date: Tue, 24 Jun 2025 14:40:32 +0100
Message-ID: <cover.1750771718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 uses unpin_user_folio instead of the page variant.
Patches 2-3 make sure io_uring doesn't make any assumptions
about user pointer alignments.

v2: change patch 1 tags
    use folio_page_idx()

Pavel Begunkov (3):
  io_uring/rsrc: fix folio unpinning
  io_uring/rsrc: don't rely on user vaddr alignment
  io_uring: don't assume uaddr alignment in io_vec_fill_bvec

 io_uring/rsrc.c | 27 ++++++++++++++++++++-------
 io_uring/rsrc.h |  1 +
 2 files changed, 21 insertions(+), 7 deletions(-)

-- 
2.49.0


