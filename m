Return-Path: <io-uring+bounces-7315-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0ABA76BBD
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 18:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E7C1167794
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 16:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F3EA2147F9;
	Mon, 31 Mar 2025 16:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UKH1oXeU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE872144A3
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 16:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437808; cv=none; b=R0u7Q0RaYR2Xgttdgy7ywEjPr/PkBOh5PJwl1zLmBzyNHOBRjgai0ILNRT2eHuBaiwdJxhH2aFuQLst5bAO+ekNMCVGY4Ohdt0wEE0jv2yqYzdLa2T96wuygPWPvYuOFIdcPX96bZ4KL/vkDoxgB1QjGzoQNJKpD4OWoIk+/nFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437808; c=relaxed/simple;
	bh=tBA6v1T6wi9svaNrjhnj+TH1q6xXTNhE+2vlfx5Ffc0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hj5af56KgcI05pcZrDfwhrQ0lJy8IeBbNPaOf1Ft6ttwIeqSY7KxkKdDcp74DlvQj0M0X1GbmEWlbs95zm/5Hp+g6sIcIxSEuCHLjmFzpqv6rsiFnlzMABE/fCMXvQvH1kKJtnKWmDYqF2tGUV5RERLv+RQBKVjZKPQIULQAJ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UKH1oXeU; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e535e6739bso7564818a12.1
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 09:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743437804; x=1744042604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wIA6B09dPiryEmy9yz7vdyFzsCRX9NLTjrGFRm7mMzI=;
        b=UKH1oXeURx76BmGj7fH+yxAGCqvoqUQnKqLR2k5b6K29I9Kh9aTNCwBu4uzqWRy2+k
         ROWb4hBzfCb7x8Xu8Wei+wqHKqqR9X9QJvg3e89teoYEFV96CFjwDZeX8wAj1ZXsNTxL
         MNl2TSPsKedlpl3zpzubdePr7yZvaLm9HC8EfbF80EOmQXnn+lt+/hswgMENxCd1b2b+
         VJys0c1BeS/uXzNHnH/bplVgNiQ5l+LRZpIfrOQoKeW8YxdQDPQsFl37R3vofq89YRtd
         v4CRA+KmSFgfRED/f3Lw572EXvzTMJ/I9KT67J/gwJ/BB+Q9PORNEE09f7Bt+6iN68Mq
         ShqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743437804; x=1744042604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wIA6B09dPiryEmy9yz7vdyFzsCRX9NLTjrGFRm7mMzI=;
        b=GWvQUmUxQ2Ss5HDDupDTAOkMMu9vOFf5XNcIAYYaR9CCit+P/YWf3OCjZqtOs4GmuI
         HGebBlRkXdU8BvBRRQDztdvvzJIz9KIEuocYNMfaNKe9/QsTYscTf7KgWA2DoHF293JV
         rcx9bpLDdcK+Z57xWXgbn2hF/mcBqvZ23jVgcI3a0XihBO0VRDsDnP4uEbkD4SBPGIu2
         k1ER4ZfUY/zlX7ZGMwcYNRCM/b32or2GQ0cs26Ep0uy+0I9qZT1gNA0kuJNEE800FHyX
         gR9HhPVvZWRMTY1r9h+u4Agqn6cvJsX1EZX2b/U+XRMLsogzdJ0hot7RdQFqVfZ+FvHR
         oF1A==
X-Gm-Message-State: AOJu0YxFaIH0N5LTAOPnNW3E6RtEpzcUhUYrCs2mySMs12qqy67ZYYHn
	YLqcnJwlQOBZ4oDIgv/ru+bMCuRG6zY4xi1Nw/UDjGmPjHSxprKXUTg6pA==
X-Gm-Gg: ASbGncuoolkIATiGAK4zQszC98ZZzlp819KcXf/5UnWWv3aRzdUQwtuS2/Mrpt6Rkb2
	DRorRvUubtTnJthYWUKi2aEj+wnrVEnrSvBy4tyHFNh5DzEwDG1nR4u8e1ACOSQD2MvuOmY3Lhw
	XHqLaWtTWZZWb5DeS+fRwIXqkhYE3u1FkpxIJBJO+FmvY8YUJ7IIOOZyHPUcVFySt1rXE09efwf
	O4FQeaGeKgSczWPqMNJ0j5DfeYS5LOzPpGbhtxvAqXoX7/otZJY1phlSUEDQlcWtOJex/3gc3AS
	XuneWoYMgb9Ol09vVJF/1TsTDwE3
X-Google-Smtp-Source: AGHT+IFTVE8Su9dYF6HcC6mHJqcKE8SVbCszAw4wy3qN3y21YZb3cJ5DVdjjE5mvb6Hbyjs1mexFew==
X-Received: by 2002:a05:6402:1d4b:b0:5eb:cc22:aa00 with SMTP id 4fb4d7f45d1cf-5edfd13c985mr9268357a12.19.1743437803515;
        Mon, 31 Mar 2025 09:16:43 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:f457])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc16d2dd0sm5861458a12.21.2025.03.31.09.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 09:16:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/5] various net improvements
Date: Mon, 31 Mar 2025 17:17:57 +0100
Message-ID: <cover.1743437358.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 prevents checking registered buffers against access_ok().
Patches 4-5 simplify the use of req->buf_index, which now will
store only selected buffer bid and not bounce back and forth
between bgid and bid.

Pavel Begunkov (5):
  io_uring/net: avoid import_ubuf for regvec send
  io_uring/net: don't use io_do_buffer_select at prep
  io_uring: set IMPORT_BUFFER in generic send setup
  io_uring/kbuf: pass bgid to io_buffer_select()
  io_uring: don't store bgid in req->buf_index

 include/linux/io_uring_types.h |  3 +--
 io_uring/kbuf.c                | 15 ++++++--------
 io_uring/kbuf.h                |  3 ++-
 io_uring/net.c                 | 38 ++++++++++++++--------------------
 io_uring/rw.c                  |  5 ++++-
 io_uring/rw.h                  |  2 ++
 6 files changed, 31 insertions(+), 35 deletions(-)

-- 
2.48.1


