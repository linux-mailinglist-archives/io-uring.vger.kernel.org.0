Return-Path: <io-uring+bounces-7004-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9225BA56D77
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:22:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 046001891944
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2501123A99D;
	Fri,  7 Mar 2025 16:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hzLr9QQO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AC2238179
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 16:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364520; cv=none; b=OR1BB+PKrXode9CyKdxEjrsyZyEknGq6nJl+6ktLEl/xjWcnP9aUPUrT/s/j502ybLFoRj/VsvdS6SzMhVo3LyqveWp+H4ulPLhNDDLhaJKtDM2HCEPpF22F/iWiBPV5iuL36n/FOemiYEQwLDtIkdHKtjz++N0z0IsnqgJ2DGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364520; c=relaxed/simple;
	bh=hUPDR8f2e+lDM5w1EoSdb8Aphr9tOvKIHyT5nnqfnHY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HuQ7lx4nz3mEeUsqW9Kc4yUsAf2vulAVVnu5OWU7cM0/fK08RcxiW7qq7RdAyOHvCP3AXNxLvz1ldfqTmITncamPRupF+vrJBrO5djJ4pPwupAOVUeoRS8Kgh811gAZJbcABUIQxH2/cMvXKyZXewb6V+3UvKBE8tBPoL/M1Pj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hzLr9QQO; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-abec8b750ebso350100366b.0
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 08:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741364516; x=1741969316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=66vJPulE1k9A7YiJQoS+ci0DvGy5Zq5WuIFmXX+AfKk=;
        b=hzLr9QQOWrjDyjTtadxHtEc33vrcyvX2OjyKqmwfxyJOeY6T4n+o8dk2Hcgezu5AWJ
         uoOzwvMQeceAn3BnmFxCjAwUP0BGPvqCe0/2dH15RilAZOdGXEb4PMUZN4dwwpbFSBcC
         rJ2qNJjSxnOlPQgli4JhO+Njk9zV2JHmprE3fdOgcQYpVAhnjyygbnWJknW7y4OKly9z
         KkwOjgjU3gzucls1XllxbPDy7SqSxuU6KPYO/Weky0tflKi0uI4lMjyBp0jsvtHX2dfy
         ylGnuLZqKaskxFb67mM4UP0RkwsOcDxbPTpSMZXrxtjt7Gtp4LktsKj1hqq5PEsfq0Q6
         s0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741364516; x=1741969316;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=66vJPulE1k9A7YiJQoS+ci0DvGy5Zq5WuIFmXX+AfKk=;
        b=Em6IttJQrYG/a87pZ6PHiLIfhWLpOK+7HiceGNfWfhOte1+simolqyVuqGOel7cg7B
         bZVvVv/Od2blufdkDS1ICWcT+5e1kP31fc8WQHbuYNierktHwjvbMECvQkFcRS+OVO+/
         SEtcRg+t1RcAB9aY9VpvSKkvOz4Ai4coLQ8mKpEy0zPXIzKrMScEFY6zqHZD8g/36xB/
         zNEVWr7V7lfWmcivROBuWRHuACZkxA2gSjbSQB/ZFr8wXIqGHkkiVK+utSIvevGKKv55
         WQHRFAUCUyjoUg4YFbnKg8s2WQozgYjHh543WgR53U71r0bKmnXG3a6wPCDOkcFpiWO1
         qJ6A==
X-Gm-Message-State: AOJu0Yx0vJ0AaEM8LYtpF7vu+CMKpATj/sz9d1jiFCw/V5IJ6VxalKeR
	UqWwxFG62r35/jM9xxGFmC6SpP44cvkhXKGsax80W33k5TBrvEL/b4jrjQ==
X-Gm-Gg: ASbGncu5hPQ40fLI+KEs/6hfFc5zUKdgY1RzFpz32m1ipLibebKnT6jUBlT0+e8P+zR
	0kDafzYyD7XvMrvDdPK+Gd4ofFKTUhKAGIhCequMnfnqkdhegk/QxxTtL45KEVEkLExXqryMZvm
	luQWqhdThKQim8NknRRTzc+I/8x9Sf2igPvYqRVMTy51XMHg3vZy8VYlzwj4QOs9C+DGXtQHzol
	CdIZaFMNSpC/Qw6uDl7it+qt7f0rJwojw71l9JJP7LpXUOa5gzpjOuLKPn6e2lnLobFEmr+6mkz
	8bBQyz/6Ahh9Wxl+i9KyrzM1KPK4
X-Google-Smtp-Source: AGHT+IH9qw8Ziza1WGNgPF1WvtYtSxFPCXDFdJZWqEzgA66v5aUKkkjJBQ7tjWiswaQeFEBxdlhFTA==
X-Received: by 2002:a17:906:6a03:b0:ab7:cb84:ecd6 with SMTP id a640c23a62f3a-ac253086697mr447601266b.56.1741364513906;
        Fri, 07 Mar 2025 08:21:53 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac239438955sm300566166b.19.2025.03.07.08.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 08:21:53 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 0/4] vectored registered buffer support and tests
Date: Fri,  7 Mar 2025 16:22:42 +0000
Message-ID: <cover.1741364284.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It should give good coverage, I plan to extend read-write.c to
use it as well.

Pavel Begunkov (4):
  Add vectored registered buffer req init helpers
  test/sendzc: test registered vectored buffers
  tests/helpers: add t_create_socketpair_ip
  tests: targeted registered vector tests

 src/include/liburing.h |  31 +++
 test/Makefile          |   1 +
 test/helpers.c         | 111 ++++++++
 test/helpers.h         |   5 +
 test/regvec.c          | 604 +++++++++++++++++++++++++++++++++++++++++
 test/send-zerocopy.c   | 138 ++--------
 6 files changed, 776 insertions(+), 114 deletions(-)
 create mode 100644 test/regvec.c

-- 
2.48.1


