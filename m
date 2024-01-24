Return-Path: <io-uring+bounces-481-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5318283A495
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 09:53:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B74B28402F
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 08:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B892A17988;
	Wed, 24 Jan 2024 08:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D2S6SlR8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C70017BA4;
	Wed, 24 Jan 2024 08:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706086383; cv=none; b=dCUourwbR1ryOb/MwM0yxyvfgsgSX6JQ78IIWg8WmiWLQ+gUBhIcG7j8psi+QH8X18Q4Jj3fKH0vcbxCbowGsEc8fBjUM6UVlpNTpURyjWq0oPtUqdp5gXDjHHvxJcABJ3CH7PewsSuwHAgQ+tkmE+Z35BY+bE2beCFgobfmFHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706086383; c=relaxed/simple;
	bh=ALiLSmHR7ixWCL+Ps8AusrKLdltVu/WoJeQS9e5pEuo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F9jyGHGHK+aB7xgCdVCgZJ5n9VMbC1e0GZ4NHnyQvlB+sPibTyurQLJWXb+AWomurc6zCfSVZWv9Bfdw4nMXdmgt8gegAbf3BxQ6XaX4vZRDtomnALOFh3wfhyT4CA5XT9BkhC4lhT8WCwMkxr4Pt5X6Cgh2sLuFsmXpg2MYhp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D2S6SlR8; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-55a5e7fa471so4605966a12.1;
        Wed, 24 Jan 2024 00:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706086379; x=1706691179; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q79dc6M6aA9dlwyZRuq5WIblH8nBswmidnsr0jpaUK8=;
        b=D2S6SlR8jLSQwnj0RM+hpbmcpt+Wl87iHAx14retynHKpVJY74I1hYlMHV0eLPYhrK
         qZovSBS9LG7NDipAQtfNeoD6Vd1B2NA7MM8xF5+2spTRt1ctchgOOg0XIo3TBV7APmSj
         FG6w984g+9FOOc03w1i8gY9EyF5kJ7ELKlELXergm6ydn+++R0iCki0UmLUJio/2uuUk
         /idpOConevlI+9npzIwoE/3uah4SM8GPnZHF19sdzcyOqAFXSmMTNrlut4GgL8v9jvyQ
         qVEGgBSvH87mK5kp326QRHSVXzC6Pk3jGMtY+5JpLLFxaaOhdRSLra+4mSe83E7bnB1I
         DFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706086379; x=1706691179;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q79dc6M6aA9dlwyZRuq5WIblH8nBswmidnsr0jpaUK8=;
        b=BrJvrVl+goW1tvL+er6S9sL0KqXk9C1eDAQ4L9l8HbyIQG9OTxELaoOA4TVFSHoNOV
         kPxdEo0RbtwN7emV2pdMB3sd9WFZ7n0DZxpdfpsc+g2Ae6Nj7hzDKH7nW5zjkj4RlwXD
         QE/mH/mM/ilnrMHE+aqBbdZRYlIP4WKHfUEtRolmuC00OwL+ZssG06oKJqrMi4J6nG0a
         02uRWdzNNn32VJHhKkxcj0iJI9I6JReZeQjGE/AFLBYc+A+9J/49SC5dLo5vNSaCT1iN
         ZmW3LgN5+sfJN5zFbJ7/0tQnTG9kTdFRa/tLtWMunzqdb91O4GGcX8jJiPMN8AJugkBC
         PVgA==
X-Gm-Message-State: AOJu0YwDM3+lfHl8Xk8ChSIfkRu6CHrkt1guF+AgoV+rSn4nW2I5wpXt
	EKTwfjxCVCgpnNQkpoBHXqhjNkRnM7LAMqxg+YRIrdctKJLvVQ3fjur4WkEMnYCmYPRGUV8Ioa5
	oN1KCHCuauwoGLGr6MlRz35hXrG8=
X-Google-Smtp-Source: AGHT+IE4vczDA9qOOeeDJ08Jpe4BrohKBQ1HqQmNzWxQ30H/5wtfZN4cE3h3wbu8yzNPSAcbhqfO2n7nI6nWJEEVnWU=
X-Received: by 2002:a05:6402:3108:b0:55c:20f7:4ef8 with SMTP id
 dc8-20020a056402310800b0055c20f74ef8mr1458462edb.23.1706086379336; Wed, 24
 Jan 2024 00:52:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240124083301.8661-1-tony.solomonik@gmail.com>
In-Reply-To: <20240124083301.8661-1-tony.solomonik@gmail.com>
From: Cedric Blancher <cedric.blancher@gmail.com>
Date: Wed, 24 Jan 2024 09:52:23 +0100
Message-ID: <CALXu0UdfZm-UJcPqF5H6+PXPp=DC2SA-QFbB-aVywmMT5X3A6g@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] io_uring: add support for ftruncate
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com, axboe@kernel.dk, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Jan 2024 at 09:33, Tony Solomonik <tony.solomonik@gmail.com> wrote:
>
> This patch adds support for doing truncate through io_uring, eliminating
> the need for applications to roll their own thread pool or offload
> mechanism to be able to do non-blocking truncates.
>
> Tony Solomonik (2):
>   Add ftruncate_file that truncates a struct file
>   io_uring: add support for ftruncate
>
>  fs/internal.h                 |  1 +
>  fs/open.c                     | 53 ++++++++++++++++++-----------------
>  include/uapi/linux/io_uring.h |  1 +
>  io_uring/Makefile             |  2 +-
>  io_uring/opdef.c              | 10 +++++++
>  io_uring/truncate.c           | 48 +++++++++++++++++++++++++++++++
>  io_uring/truncate.h           |  4 +++
>  7 files changed, 93 insertions(+), 26 deletions(-)
>  create mode 100644 io_uring/truncate.c
>  create mode 100644 io_uring/truncate.h
>
>
> base-commit: d3fa86b1a7b4cdc4367acacea16b72e0a200b3d7

Also fallocate() to punch holes, aka sparse files, must be implemented

Ced
-- 
Cedric Blancher <cedric.blancher@gmail.com>
[https://plus.google.com/u/0/+CedricBlancher/]
Institute Pasteur

