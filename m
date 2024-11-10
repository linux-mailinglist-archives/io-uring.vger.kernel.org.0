Return-Path: <io-uring+bounces-4580-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87FEA9C32F1
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 15:55:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 172721F20F8F
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 14:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AAD1C28E;
	Sun, 10 Nov 2024 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NOICgUNr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8DA4F21D
	for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 14:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731250541; cv=none; b=U3LkzLkL8XhA0YNq9WybdOEXiMyDP12xzZNB3+UjCiUTJ9q4qQcmZvefSqRE+py0OAcigZhbqThU8S8n3dhK9hYpWPpYE7vKJsfL/IngCpnMj8MqmY6hTpC/eNktS02DYeaZdEem8kvWQc6yhN4SBnBFLAp5laVGn5STnGU8CEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731250541; c=relaxed/simple;
	bh=ExemXL/DdS9n1Vxa03EDXEktjfxrGVHAUtWTs/1VnWU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P4JD3h4du6yguVxF7cIZhS4aTnuVAy5h8vzJrVlk0SZ54npT9MfzN2t3Frjck8mjq+QUY243WJLxuUueEDFifqyurNuAylLhGRJTSXzcPe7OGP0GP/3UtonUeDTwyWOvjuReU0PkGm/SH29ZO6IW53fk/feCnBS2rejGpdnDH0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NOICgUNr; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-37d8901cb98so2742120f8f.0
        for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 06:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731250538; x=1731855338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IiDt+EA95mhc6bee3L4p+1ghKjrrf4iH5mEMAw+jUV8=;
        b=NOICgUNrh1mmf7F9ygSHI4n/YkpeWCWW1O5tWNV5CenSEnkjXFNSvekQnWLQ2qwaTX
         h48uLaP3FaYLAO4jd3gUGrEoAZuS5VIonlOnD6K3K5iFA755ebDkUz9+aJU2pTGWKbiz
         7pqY85+z+9HFC8mxhKvibZl8jzzyNmBawvJYp1odZltZiA4qIpaUzIddQtOMLwThHWRg
         s2S113u/QCbs2zyBYA+cNtENoyxyocK8xxHT+KwtO08GwEDqdKlsUbvaP3RTmnAOVl0F
         0ReiIDCQPPeTXuriohQuuSabiGcD72QIgARpACKprPi0JpePXuKoYGI4WWXrLFEbq8nc
         i8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731250538; x=1731855338;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IiDt+EA95mhc6bee3L4p+1ghKjrrf4iH5mEMAw+jUV8=;
        b=eFyMWYjl7X1f4ZFnEjzD+bxyBhXxiPwdxEqrr5vUZtjyjAeN612f5wnq730kJvgwC8
         e83N/mF17SwzEli6hTVJVnWx6lV2qL/tZrts7dBpdXcLDkj9/Fl+8+lOIGMBYdBN/vey
         iGV1EiDe3mbRgrzOmesTuAqBK9r+zh5JOVPF8aod7tsrbO9qPE71bEs/UiyZ08HLMq9j
         YGOfc4MxtJ+UIJJnSeTeVen2xuQb0Q4MIOjyks15mIZ4+WaLIyIU0zG0stgPYwSbK5Fl
         t9x22x47DUIEATFc8J/Ethjl7PtpK35QsGV2UfqOrDkDg9EPVNGJHO/AzPEhqFnVF4og
         Lvlw==
X-Gm-Message-State: AOJu0YwUhB4GZ1Dll9OirK/AAc6tSWS7QG+v31FfSw4LxTrw/HOTw3zg
	9MueP5THLVGQH1p4UAPU4C0jPBSPFIFTKVif/dTbm90fcS3OWDY4IlpuaQ==
X-Google-Smtp-Source: AGHT+IHUnaGL8mfzk/jirbmLGNR5cZ+WdCrqOT9jazEtEwd/4fUUJqMmFJ3ml8z1DpI5WRboiQEEkA==
X-Received: by 2002:a5d:64c5:0:b0:37c:c9bc:1be6 with SMTP id ffacd0b85a97d-381f0f5e3a7mr7772764f8f.16.1731250537704;
        Sun, 10 Nov 2024 06:55:37 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa6beea6sm182445535e9.20.2024.11.10.06.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 06:55:37 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 0/3] request parameter set api and wait termination tuning
Date: Sun, 10 Nov 2024 14:56:19 +0000
Message-ID: <cover.1731205010.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A crude prototype for probing opinions on the API. Not suitable for
upstream in the current form. Not properly tested either.

Patch 1 adds indirection for new parameters and flags by allowing
the user to register a certain combination of them and requests to
refer to them an index passed in sqe->personality. The use case in
mind is the tuning wake ups and wait loop termination conditions.

Patch 3 is not complete, and I have doubts about the semantics of
Patch 2, but it showcases what/how the series is trying to target.
Note, these are made as hints and can be seamlessly deprecated and
removed from the kernel, in which case the user will get woken up
more often / earlier, which should be tolerated.

Jens Axboe (1):
  io_uring: add support for ignoring inline completions for waits

Pavel Begunkov (2):
  io_uring: introduce request parameter sets
  io_uring: allow waiting loop to ignore some CQEs

 include/linux/io_uring_types.h |  9 ++++
 include/uapi/linux/io_uring.h  | 14 ++++++
 io_uring/io_uring.c            | 91 +++++++++++++++++++++++-----------
 io_uring/msg_ring.c            |  1 +
 io_uring/net.c                 |  1 +
 io_uring/register.c            | 52 +++++++++++++++++++
 6 files changed, 139 insertions(+), 29 deletions(-)

-- 
2.46.0


