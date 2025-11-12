Return-Path: <io-uring+bounces-10536-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C9AC524E6
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 13:46:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75283189EC96
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 12:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C522D32BF31;
	Wed, 12 Nov 2025 12:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ChbOL6ls"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB6B3203BE
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 12:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762951577; cv=none; b=EOQH30/yJkpFQAS67rfyYGjhihLucNScn5rzux7JOewwN7Oxt4u0Drk7sH1yVjQtB2iDFT6Q1XvPXt+oLEF/+rGSXzYjlVz15QUyvT1PdF9OQVX0iFyLzQIy5ItJz1M0dANIDeuW3E5QvZWjvnfcW7FV7lyVBGh7oTavOhwQvrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762951577; c=relaxed/simple;
	bh=kpQ1pDeLfa+JOTFpxxJlaoKeowBX2W4zQ6POz1oguqg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RUYe6qCpcAygxps0few1XGXiYR3dbUcX4ro/LGeYwe5LQ3Hu2Lh5+mip+EZzl1FudU8ZB1NFJiE0a9pFsFSnBkp556kepZCdhYjBiUhKA3A3z3RwXJ2e6AwKx9z5gWofiFEJkFfN8ShJmVzoDYDTbtBczffXGEoSaaxhjrUsGIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ChbOL6ls; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4775ae77516so8258885e9.1
        for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 04:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762951574; x=1763556374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LM+MHNNKUeBTdIvaqNtF++kHoQZr9vCjj363HZqaYKg=;
        b=ChbOL6lsPxnI72TWe8f+GGkLWjtJy5bahImWPQ6xPXLNjv+22ji/xSw96saMPqewW8
         a436vhvYHlyHjW1h/DylaZvBYglYAyz1J0ysChK4YbyaVk39+r6wN5Uv0QaXZnIAcZ5i
         83x7fQaSYTnEYlG3Vft4c6J+sjj/MElGu2LCeyDtgG79z+0KTez4A3TNyu0u0Jq15rQW
         rJdfC2rrBwgESg0d5r4wY02tAcM6IxXAFm949pRyPD8TFqd980oYCpyYd9oKUoJiDlm3
         cn9CwQnDTEIBaG8U71pV+JD/ReMA6f8Fgj5cXAgIdWLRaZothF7ZSRLTBiN/G3XlJ9Dw
         lcjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762951574; x=1763556374;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LM+MHNNKUeBTdIvaqNtF++kHoQZr9vCjj363HZqaYKg=;
        b=US+qAJb0QUsAgHwWDaWU8+dKji1YALESiwwUam6G39aQynkU9lr0mqyNDL6tD4cxMS
         uHSNddmTf43QwtFIjddRuv7iRVpxAeFY/sV6dzOKjz4qFlFBUAnLdLmx3/NMGCA8Wtt0
         IjxlWlN23Bx07/qzlHdfh3ImcTkKBv2LhmeLzi9zljRAIcMhe59nLBADkC3oqRehcqc6
         yMOIyzaryLshnmwrc0Q3FyBbM1S80q7e95rkAQKZmCymG1sUyqX0tYcp+SAiGReBUQRU
         f4AuViz4d/sT2KErf/cuZMOnwrMlBCQV7VpIoCURuh3aVx1/ghUOPCjsJ5iDWS6+XRph
         t5qA==
X-Gm-Message-State: AOJu0YxC4s45Pr2AW4u2KvH90Lartyzqu7BiFMh1ZfzhH8goag0wyyys
	+o8TnEGwNaJTDPAssqqFba/SFdPpEWtCjE4HHgX6KH8ShdLO0MZnpurdrSRKmA==
X-Gm-Gg: ASbGncuilDD7J/BFo0DSL486lQrsOkuE/ViQaJeSliL4qVB6inqiKR3aHMPgJM53UUf
	o37hTTTcq7bwf8O8ISb0NQEMgRo834OkAJhBYPpwNuqatrJ7HVsJ8p5b1F0xs/qfh/lBkd9q9X4
	S4XFaNQ0nID/4334bfkJQhb58C7sR83Qva7suF/rMEz8dXbSQc55PT6dkgbpjMNIqRmYQAQn6AM
	XEXCgCq9aLYNspkk62yM5rJV9nqFlFM75/FDbkTdEOKX6IQJ4WVt5q5HxoREPbKdLyaUhQSbI8Y
	scW//w7hxtQdxIa1FSvx4e3xd9d1alJ48X8CH+BwMYVxackTpS6WsAxqkDgvpcENiiFNj9Z9LQh
	seKnwY20IYtBhyWJMk9v53cWj1i+QTFODjD11bu3sCgXvEtFodivosGXk0JE=
X-Google-Smtp-Source: AGHT+IHUoC6sfbG2jjhen7ng/1j96RFavv7CufSjf63+gOKHffjtc5nq368pEO6ZpvqqNBz8FC2yag==
X-Received: by 2002:a05:600c:4455:b0:46f:b42e:e39e with SMTP id 5b1f17b1804b1-477870bedccmr25857165e9.39.1762951573613;
        Wed, 12 Nov 2025 04:46:13 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2601])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e58501sm33846795e9.10.2025.11.12.04.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 04:46:13 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/7] further ring init cleanups
Date: Wed, 12 Nov 2025 12:45:52 +0000
Message-ID: <cover.1762947814.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are several goals for this patch set. It deduplicates ring size and
offset calculations between ring setup and resizing. It moves most of
verification earlier before any allocations, which usually means simpler
error handling. And it keeps the logic localised instead of spreading it
across the file.

Pavel Begunkov (7):
  io_uring: refactor rings_size nosqarray handling
  io_uring: use size_add helpers for ring offsets
  io_uring: convert params to pointer in ring reisze
  io_uring: introduce struct io_ctx_config
  io_uring: keep ring laoyut in a structure
  io_uring: pre-calculate scq layout
  io_uring: move cq/sq user offset init around

 io_uring/io_uring.c | 137 ++++++++++++++++++++++++--------------------
 io_uring/io_uring.h |  19 +++++-
 io_uring/register.c |  65 +++++++++------------
 3 files changed, 119 insertions(+), 102 deletions(-)

-- 
2.49.0


