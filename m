Return-Path: <io-uring+bounces-6975-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F1AA54A35
	for <lists+io-uring@lfdr.de>; Thu,  6 Mar 2025 13:01:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16E22188C594
	for <lists+io-uring@lfdr.de>; Thu,  6 Mar 2025 12:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97D82E3397;
	Thu,  6 Mar 2025 12:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1vNJX1Vf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3CC146588
	for <io-uring@vger.kernel.org>; Thu,  6 Mar 2025 12:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741262478; cv=none; b=Xj3rZHhGD1RaH2njNizwOSASO6a1wJIUVwAcDDiBCtV3NOQqZeZ124B7EXibOZtQecjgUAGxP36zP6yoU/LUIsp59qBIHZMN9ZvxwbVrLnx/CAYXxpJGfpsQzkPoSZJf81T8niImrlNEPjXt2fMcy+0SDqfCFBObFTM8wixmb/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741262478; c=relaxed/simple;
	bh=iC1jYxYMIAu+rffyHVJNq4TOKaY/46NRUkuetE8Q7Ik=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Ol6FnC05gKRQelovMMIxQi7NXmtW6AbhBcbv2iMzr9rTN1NXFs7ya08ZPPPCBoHpHBUTkbfviEbUWKneZ4tc441ttRS9dJFxwGbd11XaglOggDwzUys0ivezS2EvhhEl+lDM2nnet89LMotnEUOMxe4E58m4kNJG4x+Lup+peb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1vNJX1Vf; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-85afcb0c18fso17442239f.1
        for <io-uring@vger.kernel.org>; Thu, 06 Mar 2025 04:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741262475; x=1741867275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ITbED93/HzIf/Rof2gN6HyN5ImdgN239fWnc4trnt4I=;
        b=1vNJX1VfPfcbZXiSKOIkr1kf05GFcTMREWQIlUKIYxYJFurzQZrE/iZoz1qz06jSuO
         pwrT046QgQ6jfjB3xggOyiSOao4XJiT5BdWPUUFODZgmbysdK4abpXalrcjhyr/sPfiO
         3CFjZBc6P103RZyxOVXzcL6dSnaiNhPslKlJCUV548jljm6YULsBZ6PikeCmRknqsaTy
         OSHP6xW4eFUSQE9M09xvP3rqXvDMEWC3K3w9JfKNGufJmxSpZ+jvfk08jt95YcR5q+gp
         FXre53JLnQuazX2PpDqrfTSu1R8XuNCvb4eWE2jtTLpxxqTF5WUmxpRbHQvHsPPnprKM
         w7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741262475; x=1741867275;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ITbED93/HzIf/Rof2gN6HyN5ImdgN239fWnc4trnt4I=;
        b=ZxohPif5dQNaWUiZ0lHpF0p8zw5QOQ3wZWOYKhGClwTBmG7Z6gcBHAFehwpfTWsZvj
         VM/N5ljgWV9XfYWeqXSPq8nBmzqS/k+Uy5wA7WxRwqiTR4/CXbunLW3nL+fby6EZH6dk
         ojxP9gb+DzvatU6dC2Wrjfe8Y/+Qj5UXmi5zCox4EMndjB8x04kUwBLT8S1dk4ClDs1P
         dURk35Acr4a8Z8Vz6cfbS1GeuI9re27ObHx9IMpqhYATBPRfxcC3kZmbTRqgZUH/x2ga
         yVt7Lbaoc+sXhBgnD+2DgXlLeNAJB+yVgZRBvVgUh+ipv4DPTOAGimvyTKidPkn8O580
         yLIQ==
X-Gm-Message-State: AOJu0Yw6PKRhqD8/cwq/Gfi/be8CzrNrsGpun1aa/vFo1IBaCMXeBX9w
	2SoUNKJ8ZRBWtP5qReqpRQH0tB7yEUrW2ae21vM3qSUOOWYPJyNP+uXIt8fduZnfxTcWc4unUOK
	U
X-Gm-Gg: ASbGnct7gvC2XO1ZePk1CNKO3hure3YFRCV6Re5PfKRmJgIrO1U9h6+KVxvqKTt9Bhr
	oOF3LBfO/4m5NO0vAVuE3u+9zNm+K7HMELuvSkgeypzNOFoA4yBJSZ4pexrQfjOWh1cc001sZoB
	oJQz06H8mtzOUXNTsxaQCWnOnb38lRdgxxxj2BJZAIyDwOPClWxJ1ngL07PK0FYWP9pSkd2Gc0y
	DeL7Tg2iuEplZd2FYFPCSrjFQVA62bZEVVOBuIoOMDYPzn9/m9tRZCSrvPqs2FqdtNu0NwpjjqF
	OrhZitd8mdzVeMLLZ1pdiPNElblqdAVVcAy5
X-Google-Smtp-Source: AGHT+IER97nZiHm1TTnixUYS/C6YBAFMBdcCRcKROQmkr4gp5LuA1dpRWzpgOqaKTSD4YP+zdKdJwA==
X-Received: by 2002:a05:6e02:218f:b0:3d1:883c:6e86 with SMTP id e9e14a558f8ab-3d42b8a65edmr78241625ab.8.1741262475116;
        Thu, 06 Mar 2025 04:01:15 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f209df53desm307188173.12.2025.03.06.04.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 04:01:14 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Andres Freund <andres@anarazel.de>
In-Reply-To: <cover.1741102644.git.asml.silence@gmail.com>
References: <cover.1741102644.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/9] Add support for vectored registered buffers
Message-Id: <174126247411.11491.2089976822738509043.b4-ty@kernel.dk>
Date: Thu, 06 Mar 2025 05:01:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 04 Mar 2025 15:40:21 +0000, Pavel Begunkov wrote:
> Add registered buffer support for vectored io_uring operations. That
> allows to pass an iovec, all entries of which must belong to and
> point into the same registered buffer specified by sqe->buf_index.
> 
> The series covers zerocopy sendmsg and reads / writes. Reads and
> writes are implemented as new opcodes, while zerocopy sendmsg
> reuses IORING_RECVSEND_FIXED_BUF for the api.
> 
> [...]

Applied, thanks!

[1/9] io_uring: introduce struct iou_vec
      commit: 32fd3277b4ae0f5e6f3a306b464f9b031e2408a8
[2/9] io_uring: add infra for importing vectored reg buffers
      commit: 1a3339cbca2225dbcdc1f4da2b25ab83da818f1d
[3/9] io_uring/rw: implement vectored registered rw
      commit: 7965e1cd6199cf9c87fa02e904cbc50c45c7310f
[4/9] io_uring/rw: defer reg buf vec import
      commit: 5f0a1f815dad9490db822013a2f1feba3371f4d1
[5/9] io_uring/net: combine msghdr copy
      commit: bc007e0aea60926b75b6a459ad8cf7ac357fb290
[6/9] io_uring/net: pull vec alloc out of msghdr import
      commit: 8ff671f394f97e31bc6c1acec9ebbdb108177df9
[7/9] io_uring/net: convert to struct iou_vec
      commit: 57b309177530bf99e59da21d1b1888ac4024072a
[8/9] io_uring/net: implement vectored reg bufs for zctx
      commit: 6836bdad87cb83e96df0702d02d264224b0ffd2d
[9/9] io_uring: cap cached iovec/bvec size
      commit: 0be2ba0a44e3670ac3f9eecd674341d77767288d

Best regards,
-- 
Jens Axboe




