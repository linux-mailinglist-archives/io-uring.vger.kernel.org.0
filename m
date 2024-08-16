Return-Path: <io-uring+bounces-2789-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ED64955072
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:01:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50D761C20BD8
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 18:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6BDA1BDAB5;
	Fri, 16 Aug 2024 18:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="zNmD+SQO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B9B817
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 18:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723831309; cv=none; b=uOibv5iA4N+33UNula1/6mpCNq5glUn3bUUnTtMb7/TyFjjTx9PnblZJs9vLSGRp6ddnforEj/vbd0q0KJq6KfKZI1xdSpjEZPPRcFxM3n41hUDbdzxZyJ1GwLwvJRMe1reQGpQMbInY1L3OFnGuEQ1fDtFKhb0XE3Uyn46dW6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723831309; c=relaxed/simple;
	bh=Xe4r4pHVFc1hqfFZsFiGiJ0rpvn+zfqVZ6R/5LeDJuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mfM42bWb3YeBoxV8lVz2JK+ohp/XFxOsG9vcbokRfVKqvzjIwnS9Jl3745VrKUuKpFH3VeCXkGqNrIJORTHKZBnSIZ0Blq6kj4N2yV8Ea5t4aGDk9upf0xjAW3Z5I261/ZGHDdx7JnGXhMTGu0pf9wIcd1+I/P3d5/H3y7xGp8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=zNmD+SQO; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-712603f7ba5so1851266b3a.3
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 11:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1723831307; x=1724436107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MjE/mEbyS8Wu1zJQ1nwtyYxi+IRiHIDhj9GCiSAYEVQ=;
        b=zNmD+SQO+n2QYkdg7HQ5yWmDQ/6FAvwm5rINUINRpjTRATDXJPz91uClPFIZVrbk6Y
         G2VlOE3QvX70cBXiNdk5eQkE/lJDi6zlB9AEB3Swk/jk+2iQTUmEr6BShgbXgChbChSu
         evCyj2CMS608qJ7drptSXTaYmYnBXBbHoQIRRkK/mH1XX6cbaCPqhbg2FcTHwlR5YIPT
         PmBP1ZhB8BhnZC1UVrMuciExz1YzPlRelw00lAJcTYQPnqFBOoJOH3NGj5BCa4nxJ/q1
         NyrmM63UT6zGSb8EjH0oIwKW/lXYkrMElsfy0wZqDGHpM+YIQ1lH3ij4/5oPNxAAS0Ux
         6WXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723831307; x=1724436107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MjE/mEbyS8Wu1zJQ1nwtyYxi+IRiHIDhj9GCiSAYEVQ=;
        b=GBJVrF+zctrEyZDD7G4SHsdQHEWgvxcSgYpwBZZNmpmVskc9IGaAGA3L/nBWI+5HyM
         Z4NTdXMUC8v7+1scggP31PoZGaS8hcP8rS8cPd+FoV7ndQW1vpU0z4HlTjgeriPuISMd
         XQTODc67HMXjsyRToN0LSXeDUWkBhFkKRlN3WDN2YK64/rlIbcgWlhf/wY6HBYE3p9r6
         3QaTB1w3+DKI8yuwu83HsYQZ8SL1q/TWMQ7uNp8e8YN9Rh6ZITN5pI+7ISN5ZwiBeHLG
         qZwWKQuV8iV4qWw8ypFFktw+EvMQOlvt2o7oYbH7C1wQBH8JyFxKWWQGPq9h6/2umTOc
         RQyQ==
X-Gm-Message-State: AOJu0YwZZQhGSZ9drNrPU6QV8FvRhR7O+Abl2Sql+ctUMLjjtDHbOxGq
	E5XLSKqmpXK8c97ME+/gOLhQqbU0yNEfKay8Z8RcL/4+F62bUo0zExxUMZsydleT/ru8TOSiTSU
	i
X-Google-Smtp-Source: AGHT+IH+1ZdhSnd3TfQqmJ269MtzbpilwHXsWmfx33EuRA/rpwuUVljWiKduQSKecvGMBO1AmLzbvw==
X-Received: by 2002:a05:6a00:995:b0:70e:98e3:1aef with SMTP id d2e1a72fcca58-713d7d105c1mr428401b3a.29.1723831307493;
        Fri, 16 Aug 2024 11:01:47 -0700 (PDT)
Received: from localhost (fwdproxy-prn-034.fbsv.net. [2a03:2880:ff:22::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127af1a7aesm2989113b3a.171.2024.08.16.11.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 11:01:47 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 0/3] io_uring: add option to not set in_iowait
Date: Fri, 16 Aug 2024 11:01:42 -0700
Message-ID: <20240816180145.14561-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring sets current->in_iowait when waiting for completions, which
achieves two things:

1. Proper accounting of the time as iowait time
2. Enable cpufreq optimisations, setting SCHED_CPUFREQ_IOWAIT on the rq

For block IO this makes sense as high iowait can be indicative of
issues. But for network IO especially recv, we do not control when the
completions happen. When doing network IO with the new min-wait feature
that lets io_uring wait for a certain number of completions before
returning, this manifests as high iowait time.

Some user tooling attributes iowait time as 'CPU utilisation' time, so
high iowait time looks like high CPU util even though the task is not
scheduled and the CPU is free to run other tasks.

This patchset adds a IOURING_ENTER_NO_IOWAIT flag that can be set on
enter. If set, then current->in_iowait is not set. By default this flag
is not set to maintain existing behaviour i.e. in_iowait is always set.

Not setting in_iowait does mean that we also lose cpufreq optimisations
above because in_iowait semantics couples 1 and 2 together. Eventually
we will untangle the two so the optimisations can be enabled
independently of the accounting.

David Wei (3):
  io_uring: add IORING_ENTER_NO_IOWAIT flag
  io_uring: do not set no_iowait if IORING_ENTER_NO_WAIT
  io_uring: add IORING_FEAT_IOWAIT_TOGGLE feature flag

 include/uapi/linux/io_uring.h | 2 ++
 io_uring/io_uring.c           | 8 +++++---
 io_uring/io_uring.h           | 1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.43.5


