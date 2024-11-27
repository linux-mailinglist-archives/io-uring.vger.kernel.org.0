Return-Path: <io-uring+bounces-5083-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5BEA9DAC1E
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 17:57:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 025A9B22CD6
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 16:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C479200B8B;
	Wed, 27 Nov 2024 16:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EVkoPE+I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE99425760
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 16:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732726662; cv=none; b=nbXzLfbBblhUpkWQcm7O/S35deubbTyYm04+vqm1k0lF++DAJ4CMZOF8JmRHpvii1vLwbp/QWsWE++35b8mCmSAxwJVzLEYBWVJoxjsIGL3ZAWytiM89yBqtnYcflndJHT/Qy/QOLqWB66ggYrNryIhJwOXBT51e/T4eYHa0F7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732726662; c=relaxed/simple;
	bh=zV8DAPljRgz7vNiJSquCmNtThDdjwLeq0i5+TJ0owsw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=h1Y0lBGuAMfhqVpsVGX2D3tg2hU8RjJM3CrBP/4TYMmNfy3ANWwYr+kfBhMyQ1rvsC2LQtew4mpHimis4eL7ClAwyQ734Tkv60gvHc/pYehAT2aXbuR0dgo6Wn/5YIoVOOrMiEYYgTprWYSIKDDnrRCsqjXsJHTX2zOhwy51oUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EVkoPE+I; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5cfc18d5259so11243a12.1
        for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 08:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732726659; x=1733331459; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zV8DAPljRgz7vNiJSquCmNtThDdjwLeq0i5+TJ0owsw=;
        b=EVkoPE+IPINN8wKj4d/569SiywVT16o+D18gx7jrLqvQPthBkjH3UgrFFd+WIbIzIF
         GMXKVV6uN/CLTNvvvBlh1+ecOXRDOpu+pJSu9idq79IfsiPuapeRhkLYdR0dm2i5ivRQ
         29eRQ8SU9vi547Ta7tkK+6tyZg4K4EAcOmt6chpl9M8Mvt8Re/yHe5oMM9gtdNYz6luy
         ptk3MPB8Z/7Xj3c8FvCHrdTbjBri/lPB+TdBUumM7PPcsGKmprBGQrS6kUnNtsLWMPPO
         K6qnYrsd/0DYTMpKfXgwqn3fdhigmlgZ2rfO9yxAmfHdjSGR6GSb7Q4lGNbXQcfgedar
         rv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732726659; x=1733331459;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zV8DAPljRgz7vNiJSquCmNtThDdjwLeq0i5+TJ0owsw=;
        b=K7HrhHq2kgDj+Dj8SYdNQKjYD8xcpwejjsYEAbIRUXDhCPNlZIBnFIsLutcsov9NPV
         w1J9ixWqleLMIPE72SgvJoJGSxT9w+zU8sfP8RO50R6nm9vXpKdrwEp4iHQ8z7xA0FXb
         C60XkCL8wO+OqHQtnhGUapZ5Q5ZLoZqTyvY6eSpX1jxppKGs9FXXLuM6JjLqvyF0eeHv
         mmKkKIAwJbdqNuPk1hHCj/XbmR5qUozZueFdnQcoRakjg2e9W8Ih2LHHsEMX73939gOX
         CBAHWjKg1vWzfnZgFP1Aj78/hRAmxTLhLm/3fUKzOHrjAHgBSyeG60XU8QW6vdblWNiV
         E2kQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhivs4kQ1OCanFIXdGSxjeKGgNmavaKIWUN9/AxvnHawiV/VdVvhwX3BMKwin2ejrpYNSkg6WBdg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8WcakVJmIQxi/kugqP6BhwL3XJj3mdEXl4ckIN20pNwTEeB5+
	6pF88ppie9eXG5uYj3SYAhrKYp19JyzxJAvr1yrh/2RseRAYThHjg1evCINN2vM2V1czYNmJ1G9
	Z0p0jwIN780ZDVHUPvsmqyYP/tILpq8C1WA9K
X-Gm-Gg: ASbGncuG90tf2p5uqvNU33ibXEFapySuHb017QeB98CRmTBuPy6XdSutpmMw4a4DnhG
	hstZcDS17HRKT1EDHCwWhj3gqlhFH5dlmPZ2ZEVzaYu7YN10ydaqSJiI48fM=
X-Google-Smtp-Source: AGHT+IGQ9jgicjt+kWH1dNUS0ZsDi3II7a3kom0Ep+yb8h5w/6qbGHt84K1Y7lvl5V6Y3Mq5BRi1R/n3oXlcmdvRKJo=
X-Received: by 2002:aa7:cd50:0:b0:5d0:f39:9c7 with SMTP id 4fb4d7f45d1cf-5d083570c07mr73959a12.7.1732726658907;
 Wed, 27 Nov 2024 08:57:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Wed, 27 Nov 2024 17:57:03 +0100
Message-ID: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
Subject: bcachefs: suspicious mm pointer in struct dio_write
To: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org
Cc: kernel list <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi!

In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
to an mm_struct. This pointer is grabbed in bch2_direct_write()
(without any kind of refcount increment), and used in
bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
which are used to enable userspace memory access from kthread context.
I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
guarantees that the MM hasn't gone through exit_mmap() yet (normally
by holding an mmget() reference).

If we reach this codepath via io_uring, do we have a guarantee that
the mm_struct that called bch2_direct_write() is still alive and
hasn't yet gone through exit_mmap() when it is accessed from
bch2_dio_write_continue()?

I don't know the async direct I/O codepath particularly well, so I
cc'ed the uring maintainers, who probably know this better than me.

