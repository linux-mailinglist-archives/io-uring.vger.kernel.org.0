Return-Path: <io-uring+bounces-10931-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 87026C9F5E2
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 15:53:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id D94823001876
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 14:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336E9306B00;
	Wed,  3 Dec 2025 14:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NTetPt92"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D94305960
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 14:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764773595; cv=none; b=uF19p+NMmOvajueWxELIbhMyYrvtSssDWcRfZsJGTtfoxfR7Pxh+TYyPRVvxO8EGxzjMyH8BsEveEAPW3l7r7OACXqa+4G7lr3/9iWdCAUjHckOk4Oo9+sgs7QgTqQ+9cWcZ/xx7P317dztBkM6a2Rnwoq3lGBe2xYfwmAgrF2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764773595; c=relaxed/simple;
	bh=EQj1PgeGKoR7tLgBd1GYdrPiLxDloL4ro/O0IZw+H38=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MAs+bTJ5BfBTBMNZs/TdTbTnrMCVXKkJvfAWLVywMNOeqyCtsZQnG4QOAkvtT3s0WqUnSa52CExU2bb4sn3aoKFKc3VFAI08s50c2j6NX2HDyQURQXN9Xm3DqZjN9jyUhVfj93Djx7gsHEgpNH8KjrtWlI6ElmMsPimlQCjWhN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NTetPt92; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-657490df6f3so2904138eaf.2
        for <io-uring@vger.kernel.org>; Wed, 03 Dec 2025 06:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764773593; x=1765378393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5d0U/THdr3iaRa9VAO/BAER+fK2Vx1LwhQXgCZqY2EI=;
        b=NTetPt92z9OVAACblkTemPvrzXWkbiOUNWD1r8EEP0skbktZgQp5EsB4rfhj0gux5n
         40gHz+Yd/zfS7UPt7rISP2VzXuDYRVT0J+ZSiCGB0G7YqZ8cB1GyaTzI2OI8XHgGH4XH
         VYiZtk1exAFxPKRSxT611nu55XqbT+FgvZ0+B0bVjPjvs5zzSXzPYRAvnHzU0VZxGej9
         X3maEJcmoGtKoILh70IqHHnUIARrHfgdnbe+vUhu7olwqKqtpauMNZlsJidYrVm7WbSh
         KOaNUdO+UPTAZXEbNVqtfuzYEIGK4Dw03g8I8CUkIT687xLnyz2fCLq7e2sJyqwxUk/d
         QUPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764773593; x=1765378393;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5d0U/THdr3iaRa9VAO/BAER+fK2Vx1LwhQXgCZqY2EI=;
        b=Ys3czu6+ygxF2ViEFhjZpeuNcfwt2qqLIaQ0xJ5HEHvdXAs7Di6xaOxL+jmSSBCcT1
         Pk5SoSVcvg42lHr4Kg5KAtmWyoRXYenpZmBwhXrLPdGWddp15ORkQKQUW2C4mgJGsTSW
         J1EiPl1gt1BBT1u8R76qfR27lZL0Y6p83OLgOmyGuFgceZWrzk+vtsTfA4YWJw6J7VL7
         yW/FRQhZ2us+xPv/4ZRk1xpCmwki6lq9Y1aX4AiazXpr54xpWeh2/C4JL/5Q+sgHK8gL
         PhUKm9Cts+mHf3ixaPdbdV0KWxDBqVJDGJH3qQrQALvyA74Rd5q6/m3OtRvgA1nK/xzD
         spvg==
X-Forwarded-Encrypted: i=1; AJvYcCVwr8aFXqkUMOsIIj7ngK5u/Y2Vt0uW2ATVCCNy/11TSisslInZw2KOu1n1fFV/n7Z79CiUJ9Uhaw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7l+QEacUfq79JJZ5npDAqdhnwtgF/8mSmf9YcvCpAkmBF6Eb2
	GkCiuSyWwN3lN9MmalQ7TvCecYiVLnotqARSGzxxF0XL/sPLqvDBz/nKGWL6HRsquWA=
X-Gm-Gg: ASbGncuTN7Ke698xjxZlh6ERDJZVWdTCBpgNERFUl+drsvK1YQ4ZzKTFKtXXQI77hVi
	ocEt4k1Fmde/RdqYdaIRaZxDgOqQi7mPh+UMuf5R/InHbKiR5PvnkbjjX+KhgSdKkwdY65Goz/H
	1nv1c5Xo41ddq8AUyT57O6o4bSUjmlE2d0UFTxPsjYwZt0o3P79veZVDIDLY8T4wv3WZfggQ/Un
	ErFNouU8uQkcm8XAJdBa+yYCYukLmDWCuK7/oLoqOD+0bYvfgRJUjW3RAJDxZF7LFcms/I93KN8
	w/y7Y05awDFd+XYqrvrYFMZLNqhgKvUesRxpYCjrPs6Zb6/vg0mDa9dz2FNYcifHPC1aDak38D/
	E1+WC53K61TRVGSMKmeL2sJ2S/dCFA8lvVGUbsCvKbLm7I6sIk0dqf8Nh42I/bsa9Qx+nF4lh/F
	cvugtjO5/MYsKM
X-Google-Smtp-Source: AGHT+IGpd/ficKucFCwXBOsQW4CEtfw9SGISZeBp8Z4F0yU4cb8sV2LTHq2SyttrVzg9NFF/v7JaLQ==
X-Received: by 2002:a05:6808:d4a:b0:450:d504:9281 with SMTP id 5614622812f47-4536e578935mr1331499b6e.59.1764773592689;
        Wed, 03 Dec 2025 06:53:12 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65933cc55bfsm5953139eaf.9.2025.12.03.06.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 06:53:11 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Uday Shankar <ushankar@purestorage.com>, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20251202205745.3709469-1-csander@purestorage.com>
References: <20251202205745.3709469-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/io-wq: always retry worker create on
 ERESTART*
Message-Id: <176477359158.834078.5263900730628607784.b4-ty@kernel.dk>
Date: Wed, 03 Dec 2025 07:53:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 02 Dec 2025 13:57:44 -0700, Caleb Sander Mateos wrote:
> If a task has a pending signal when create_io_thread() is called,
> copy_process() will return -ERESTARTNOINTR. io_should_retry_thread()
> will request a retry of create_io_thread() up to WORKER_INIT_LIMIT = 3
> times. If all retries fail, the io_uring request will fail with
> ECANCELED.
> Commit 3918315c5dc ("io-wq: backoff when retrying worker creation")
> added a linear backoff to allow the thread to handle its signal before
> the retry. However, a thread receiving frequent signals may get unlucky
> and have a signal pending at every retry. Since the userspace task
> doesn't control when it receives signals, there's no easy way for it to
> prevent the create_io_thread() failure due to pending signals. The task
> may also lack the information necessary to regenerate the canceled SQE.
> So always retry the create_io_thread() on the ERESTART* errors,
> analogous to what a fork() syscall would do. EAGAIN can occur due to
> various persistent conditions such as exceeding RLIMIT_NPROC, so respect
> the WORKER_INIT_LIMIT retry limit for EAGAIN errors.
> 
> [...]

Applied, thanks!

[1/1] io_uring/io-wq: always retry worker create on ERESTART*
      commit: 777dfd696d3db9b7b08a41c3c03554ce0ba6c94e

Best regards,
-- 
Jens Axboe




