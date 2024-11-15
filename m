Return-Path: <io-uring+bounces-4740-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D0C9CF961
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 23:13:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14304B330CB
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 22:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 651361E1C07;
	Fri, 15 Nov 2024 21:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KeMjRVLJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA551E47DB
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 21:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706394; cv=none; b=Mkit8MNtrysaab7HRlmyK5tD1P4DZ0QMmx6OnzTCIh8WzuYtUftLszHTjoEtlu2UQNC61ktqd/58uRSa/yeq1ukChdFv1ZXBAjA2bDD8jQYtnDkK071PHG9swpJs7jlnLvG5v8ehtWq8zEwZUBA0U5aKNsFykTiN4alo9DUOGkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706394; c=relaxed/simple;
	bh=1+6l2ZXfz6GzSzg3LgNYkXvZuGg7yAjLnUpOTc4Z6jo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IoVmHfrDjREbioDEfeeOFsTZvDi+xKR/LwD0fr2e4K8dn24WBWQd70g4+gGTrNGnppQ0TJXdE9XURk/tDyRIClhLYjtIk2jxfFFiScytOh9b/bc3lAg10Nc8qEPcqOYfy/Y6CbUhSGXxUhvygfMJNKCQ/wYzSI5zd3MZYbJe00U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KeMjRVLJ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4314b316495so9463285e9.2
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 13:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731706390; x=1732311190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5eGT372J+YEQAG736trUY249sxegky00bSNVff3Vzuc=;
        b=KeMjRVLJ8yoTpFJiLHaCldZAKZ9OO0fE3OVzPaVpf/6BS5qURlSL0jRGLnPPtkCL3N
         XSwREPF+eWua23p+Ku2y+rOSGzB+w7F54ljxj5wXxFOMSUVAz0dJzdBBWC4XNBKKXhCq
         GcuVcDFC4/GY4m3xvhE7T1M/OGmERmpe2cwEG0O7apvXnfuyMZcPKD9f9yW16TgMLoQ0
         JL6zZQjZ1WFnbwqaQD8TDBt1YhrdInINMC9uXnaoXlIN5ImRy8e2sCd6+Suq6uniWF+f
         dtVBg5BUxBokoh6Nx5yCH7eB7RNgX/2/H2b/IfeqxLT0e/dWtHk18wMfZfuH6L9h25yL
         NRig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731706390; x=1732311190;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5eGT372J+YEQAG736trUY249sxegky00bSNVff3Vzuc=;
        b=ODw7D+rO5RAtavymskjmCVCVToO/AQ48aPsv6utYhBP9PY2R2kU5G+KgjrV1OyP6N+
         weI0atjZFifNvOAt2BMmCAKw6jbJ56YT1WzhYehIUlqVJVDkKNttQpp0fp+2S6JPM6aG
         6iZp09cbMGndar5nl80oO0huiINqTWn55q1vRr/m+ziGSCRIl6uxp7L4JShteTwvQtbo
         2bfitvB2SoFVyZ3Ul7z0wCgB8sSk+EaBwa28lYKPii37iEjHj7AllwJL9CEU7Jv3YpQ5
         r8k0Uzk1wPDPTop06hNDUjH4EKTsW/RIFQxrdjdsm54xyDZjdxEs5Ggwy8gvvp3GyBnC
         12+Q==
X-Gm-Message-State: AOJu0YzBGRtr1GpXP/yGia6mlqVr8j0rlIECt9Crd/afIPTc3PPo3ikp
	834JF6muOBjBmiPMncrHOnkrG91Y81rFOTj/enLdi8X18zS5lmyd9aVHjA==
X-Google-Smtp-Source: AGHT+IHp6IqOEdoxpQVO1V4v+AV2U3zXqKXLoXax4ufjfcKef5Tdg+Z5sgMikUmwBjfIIClP9apAYg==
X-Received: by 2002:a5d:5e0a:0:b0:382:2349:b2b5 with SMTP id ffacd0b85a97d-3822590f8b3mr3636204f8f.21.1731706389638;
        Fri, 15 Nov 2024 13:33:09 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382247849b0sm3397258f8f.97.2024.11.15.13.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 13:33:09 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 0/8] update reg-wait to use region API
Date: Fri, 15 Nov 2024 21:33:47 +0000
Message-ID: <cover.1731705935.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reflect changes of the kernel API for registered waits and fix up
tests. The only thing that changed for the user is how we register
the area, which is now more generic and called areas. It should
also be done now while the ring is in the disabled state,
see IORING_SETUP_R_DISABLED.

In the future we might want to improve the liburing API for
regions, i.e. adding a structure and a bunch of functions
setting up the region in different modes.

Pavel Begunkov (8):
  queue: break reg wait setup
  Update io_uring.h
  queue: add region helpers and fix up wait reg kernel api
  examples: convert reg-wait to new api
  tests: convert reg-wait to regions
  tests: add region testing
  tests: test arbitrary offset reg waits
  Remove leftovers of old reg-wait registration api

 examples/reg-wait.c             |  45 +++-
 src/include/liburing.h          |   7 +-
 src/include/liburing/io_uring.h |  27 ++-
 src/liburing-ffi.map            |   3 +-
 src/liburing.map                |   3 +-
 src/queue.c                     |   4 +-
 src/register.c                  |  13 +-
 src/setup.c                     |  29 ---
 test/reg-wait.c                 | 377 +++++++++++++++++++++-----------
 9 files changed, 332 insertions(+), 176 deletions(-)

-- 
2.46.0


