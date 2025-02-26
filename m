Return-Path: <io-uring+bounces-6780-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA12A45D5E
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 12:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD8E77A3A1E
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 11:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861C02153E9;
	Wed, 26 Feb 2025 11:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h1OpsNGu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18A819C54E
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740570037; cv=none; b=fbdLxbtBWg9KcnoQG0eyGJhVmQnsNyb8NkKl8pOPss0wSVRE1psUi4p2SN0nvoi3VSqa7gHb4uoCkmzgDHMx6BXtMY5p2TvApRcaKiYjnNVfQri86xpWmA5vEgPrMpbsl8VApxpodcCNomYtPTIL4VskCaoc87b8LhMD2yWsIrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740570037; c=relaxed/simple;
	bh=zlyTxSXytOuQOIaY5WdjnFQ1wF5aHkyxeBsh6bSxMb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WXjX+QNVB9007yjf3Uqm1Diu3GnvvaJGrJg93d4e6wgA7HFdlr0AuncGJ1N0HMGywz1Xajrq2i3zhKpZhsbzoofhrfsomtqg+HHCSbrAzpijnGXCQ6P/XDzc1TvMgh/u2pvCzRmlRqcuUpW/EbWP1VWRXyyopLFjGLrWWZ6pFL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h1OpsNGu; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5e02eba02e8so9042189a12.0
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 03:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740570032; x=1741174832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Krgs17rcE68Ye7wdOUwfuN1m2ZTYyLZnvxQ7FEosM2c=;
        b=h1OpsNGuSXcFUniOviDIfybp6LlWZU5Hj8+NpNNQsgl/byNXb0PiOxt83egnZ094F5
         vnbvGtYhpiN46Nzs0xtyJedayQYWrp/Z/XjPZ6YsX/wcr7Jg4F5X4Ztgnl9del0AJI8Y
         3JJP5NUDY/bBdZlD1vWY0BTHCKB+kNpBwc/FiYhygRPZl7So48HJ6jTBMN6JC6eViDZ4
         yfOrdP0foy5GjGRVIy2uyqL0bz37cBJcMJRlZZFmzz88LOd1FL/2arihO0uR3jrG4D4P
         eTHkXZcdUS9uLxrSUwkFy1439Q7eRu72eLqaN/OkqoJcMluePTj5Sb4T/TyBkI6a639V
         3gdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740570032; x=1741174832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Krgs17rcE68Ye7wdOUwfuN1m2ZTYyLZnvxQ7FEosM2c=;
        b=HgDJ1otRQdqNY9M7Cd5WCQI2F4uFfHkRUV9qJ6c8VFZICBOXkgqjyeueEOQ12plHwG
         WxfoS7iAyOUKXMOnQcw/vyse+Vv8MVrHSxtbp0HTfE8yOynnnwrVeVnbf72Al9/vLu6j
         e9xExGtFwvINWAP/PQ0let+JvH1Y5w+tzXO1sKq57Ch2P68Psx2ejJbqGc74pm09fGKN
         dwSO2/G6G/t48FTWpHGOWA84hLSHK34kxP289U6aM7Ux4uiTvk1nU5pxJQ0VOIJMOKMC
         RM6yM9rekSmPnh9ureQbvhKPKSighFGWZvdSqeH7jqgO7QMyFrxLzB1nnMgTOMGyR6pb
         R6SQ==
X-Gm-Message-State: AOJu0Yz6iauCu5Q5Vi6dnrjqtqBvO6NDhooZpl/szr0kIzkQIoFcAPwW
	snj++kgtY+XmVgN4OJCPBIEh5DM8sPfex41xjZuAVo6CpMOioyo1Dzx8aQ==
X-Gm-Gg: ASbGncthwEfCv2Jb1wdxraZBYRLAR9BWN+JfarTZ4KJ+D+gHiN5bWBdIKbW/Kb0k1jA
	nO2rkzhPByt5UQZYhe2tjM70tv4hS62+5ikWRIlUQFrpP8FZlyyi7quCBUj1m1fFO2BmMKtUd1A
	ev7kC9Uv30DyCQrAu9YB9Z7xYAnLoH6LFT3irzqG3ITb8F+wsuN8ym+r1N2eo7+nvkeOgFt2yvL
	Y9zjcGETma4QfEZe/3DUVJsxH3c44JTv5EhWfil0RnkPAe+N3kyFjEaiLLVQHxUaLKrbMvDecrU
	Adh9B5GIxw==
X-Google-Smtp-Source: AGHT+IE35xasQ8XgtOe61WAymLnfQIu1W8PTs9HUCRtrjWhnrxc5ZHdnx9zMlO7tpQkS2P3Yd0zeqg==
X-Received: by 2002:a05:6402:4603:b0:5de:c9d0:673b with SMTP id 4fb4d7f45d1cf-5e4a0d45e89mr3063950a12.1.1740570032294;
        Wed, 26 Feb 2025 03:40:32 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7b07])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e45b80b935sm2692418a12.41.2025.02.26.03.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 03:40:31 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/7] improve net msghdr / iovec handlng
Date: Wed, 26 Feb 2025 11:41:14 +0000
Message-ID: <cover.1740569495.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Note: depends on ("io_uring/net: save msg_control for compat")

Continuing refactoring how iovecs are treated, this series adds
some more sanity to handling struct msghdr in the networking code.
We can do some more cleaning on top, but it should be in a good
shape, and it'll be easier to do new stuff with that in.

Pavel Begunkov (7):
  io_uring/net: remove unnecessary REQ_F_NEED_CLEANUP
  io_uring/net: simplify compat selbuf iov parsing
  io_uring/net: isolate msghdr copying code
  io_uring/net: verify msghdr before copying iovec
  io_uring/net: derive iovec storage later
  io_uring/net: unify *mshot_prep calls with compat
  io_uring/net: extract iovec import into a helper

 io_uring/net.c | 180 ++++++++++++++++++++++---------------------------
 1 file changed, 81 insertions(+), 99 deletions(-)

-- 
2.48.1


