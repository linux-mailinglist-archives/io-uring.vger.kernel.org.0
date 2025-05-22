Return-Path: <io-uring+bounces-8080-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03BEAAC0F79
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 17:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEC0A4E1414
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 15:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA45E28FAB5;
	Thu, 22 May 2025 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j/60D1fH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139A928FAB4
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 15:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747926550; cv=none; b=Vh/xANfuRBhrn1UDrGzzCQlANYXwGw0wUTqCp2MY/iaEBGchPYGIow67XDpEfUEAhLTAbvX1dqNXv7pYbpdtOPUwmJLwex2HS1sNFnEGzkwCqwAiVoQIMEOu5N5so5RjK2O43is6DOGAWCiEg9rXR6nBsSgYZZPFsRhSVAMcrdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747926550; c=relaxed/simple;
	bh=WznFwBeUQZADdPkpKI4GrzYIdw/FtjPOShVX4OOZNz8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D7azFUbtbGyUvrl4b8QeRP9zer0jZPc/PL0BzJ+lli2m6+24l1Ad3u5o/5tMPw0SPb9gNIBjh9IvHTPlz2iZVNINhJqzK7TflUBa+uCq3Nj3l7PuEI8VRgYQc07dm3+TEaEaHmq73AT0RDCWIyBoL9q/IT/2jSaEqA7M+x7hQmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j/60D1fH; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-60119cd50b6so10696810a12.0
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 08:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747926547; x=1748531347; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vx5TJkM3JkH4ATf1GXyEN1qkZQqFYBlG2C9p676wH4U=;
        b=j/60D1fHlbkDHl10hzLGR0u3DXl2ptiHTbp9u8pXyo+Fz3C5U5fML88ZHhSRCSs2c9
         L6X2gWuYwG2ZJ7K1/IJ6NDHXvN01quR6Iac+CImzJVOish+LVQPKFjQHRBS13QIhfw1j
         Gr+jOFUuSfHVeXJ3O/oQUDT/c3pC1aqLX5rrIIl7zmqrbtB6OCtNZ32sHfGaCszCXu67
         nrWh39ezIZFIGqS/57sgdVvQkWrNNqJm4+8vVDlbgt0nq8OwDWxwNgusvION3EhwhgrH
         NspFNtYOYmx3AAN3pMKhmL6BPeCThegybVmOfUdgmb4jhChXPuIjzRPdfc04IZoNV1pv
         bgwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747926547; x=1748531347;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vx5TJkM3JkH4ATf1GXyEN1qkZQqFYBlG2C9p676wH4U=;
        b=BFQzv3bgk7BN44TwTca5TQXkkXRv2REUVJscZK7oVMX7jBoCbDofV9LLvZFFEMwJff
         08gF2NH1nuwMHn0qcwt+CFvcaEFpczK0OKc9wqcCaBKPpzhHq6Rp1FsAluMqpvR10Z0y
         WMKjy06qsDKrXzuxlxQCjVfZsuUclK3M03F5qPiaFNEf3ZfzqKySGJBkSY/INP9F8PEx
         W9H0AUlgaXzhUwGl53V0NlX4Z1dyCIyq2eYcIyZBJvS4Aom6fkKuHKOVrQ5UauEhTy/N
         V9GSqNS2I5UYmHt0Aexn3VPXjVNzhFyCkQ3pbbw3W9rA8yjlXaZJPGr4Uq6zo80g/y82
         PZ8Q==
X-Gm-Message-State: AOJu0YxDn+FnjMUFwy1Jz2g+sNKNF0pO7Yh82uJVtu/57AI0L01p4udH
	hQUiKKoT4bc/C194bsgWacvsDzrqWxmf72ImitPfCfo2UeJpv8eSpPmHOJlu7A==
X-Gm-Gg: ASbGncsRR1K6d5jyIX3Y0E0PGbQbpADtTSHKK3zpVV79aNpI2bx/MR9P1nBboHnYaV4
	eecT1DjDx1mdSmwhEPloISzPJZOmnqesCQvpa82i2xZTDiW95gZ/FK8bYeXm+1DiwFl6aAj88JS
	VidQwbHW9FkQdn7RCSkaFiIFp3/GGBibN41E4aGkgrMRhxdzJ9nT4lOQ5OuCuV6qPz+cfLnChgJ
	S69NiJSopgdS7zO4vBrugQwUBEHIDqcHSQ/z3qlCsu6+S7Gx94sYq3KqZkwK0JNPj2TgzVqImtj
	2YgDcLHg8LtRAOcDgAmM+3cKdk3qkCLEBbg=
X-Google-Smtp-Source: AGHT+IFRHt5jLQilASj/ju0WYCBoN5qLQ6eoQ7X9D2AwL2wcUp268NGrry/657d4tLg8kNNTReebbA==
X-Received: by 2002:a05:6402:3589:b0:602:262f:1de7 with SMTP id 4fb4d7f45d1cf-602262f24d8mr7528664a12.2.1747926546458;
        Thu, 22 May 2025 08:09:06 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:30e5])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005ae3953esm10684305a12.73.2025.05.22.08.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 08:09:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [RFC 0/2] mock files for advanced io_uring testing
Date: Thu, 22 May 2025 16:10:05 +0100
Message-ID: <cover.1747922436.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are core io_uring features that are hard to test without having
some specific file types. That includes various read/write and polling
edge cases, but the problem got even more distinct with the introduction
of commands and io_uring adding new features for them.

For improving testing we need a finer control over file behaviour. Add
special / mock files we can create and configure. First, the file is
implementing a set of io_uring commands that uses various cmd io_uring
features.
Chase also suggestedd adding read/write/poll file operations and varying
their characteristics: pollability, nowait support, whether the IO is
async, etc., which will be added in the future.

Liburing tests:

https://github.com/isilence/liburing/tree/mock-file-tests
git https://github.com/isilence/liburing.git mock-file-tests

Pavel Begunkov (2):
  io_uring/mock: add basic infra for test mock files
  io_uring/mock: add cmd using vectored regbufs

 init/Kconfig         |  11 +++
 io_uring/Makefile    |   1 +
 io_uring/mock_file.c | 207 +++++++++++++++++++++++++++++++++++++++++++
 io_uring/mock_file.h |  34 +++++++
 4 files changed, 253 insertions(+)
 create mode 100644 io_uring/mock_file.c
 create mode 100644 io_uring/mock_file.h

-- 
2.49.0


