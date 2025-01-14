Return-Path: <io-uring+bounces-5860-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EACE0A10F8D
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 19:14:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A5B9188B52B
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 18:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94C071FDA93;
	Tue, 14 Jan 2025 18:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TtUt0xtu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BDF1FC7FD
	for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 18:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736878207; cv=none; b=E2aelWcWIqUnGHnB1dZDKeZMzKcUTzj99TJp0fF5FntdS1+WbY5ZJEP7TQsVbAA9JqlMrwp5pK9pCHhzZf9QGO6fILJCTcn3KJ71raRLncWOeGrdt6bcXtJO5VxLsB+KW2935A2LtjoPT8ITMuoti3Ej441+8j5ebrRUKtp2h7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736878207; c=relaxed/simple;
	bh=xt2EUpR+Drgf9WZVcSI4e/bScCfCLpE0kwHYQgg2tlA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iAllNM/lemtpvzs/AOy24OH+okjqja4UPg0Jbr+0wo8C+QMAWxbuOI2wn5ChYBUg6MrYq7dG6zkcDkSQJSaNOhmDhGP6z2rZg5ZpRh8VSpD1j/k4rZZK55DSdjikBULK5eFti2FN+uEWu2mxA5MUc+PfFjrh0BQJBG4oXjoM+y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TtUt0xtu; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a9628d20f0so37584545ab.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 10:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736878205; x=1737483005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gaooOFOGtKSVaMzqMlIyw6V93Yl6VrFQA2qk2SuiUTE=;
        b=TtUt0xtuXiHuJP68t7ijiM7HYbc7asuyQ5pGEpIIs8tdrVYj2NmppEcTVP/bgitnZq
         xtD+WvLdP6yOkq+lDyhxUNAhhydjF+0L0LBnVTsBoGFYV4PUZc4Dg+GS4Uu7JPDAp+l6
         RjpQuXfnZdsfCR3a+4ph0FcnorA733EAqIi46Lid/UjYQhBer9Rs+IK9RpLHx0pA0mOV
         R9mO7Az7a4/z/WGTUtxs/ewr+VTMv1EjOEIvm7gB2qUbybbIpN6QPALVjwel5QX3csSH
         Ob54G3ptt2K3I6jHdrnR6Mw0boubc9ILcSjo/J2tCHnCSICMKMDFQypSZDSuoSwAZXCs
         bYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736878205; x=1737483005;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gaooOFOGtKSVaMzqMlIyw6V93Yl6VrFQA2qk2SuiUTE=;
        b=RDAwQxvzZ7ZHYeFA8hwtW6hDd8WuyPvppBO2Cix06BKr/lnsSsAuk9y7dJPV2Dbvh0
         S9c5hC2gSDNKsCZ9iinzhle3CcJ0tVGl/YZk0AkdL73xFDSkeY5R5iO9jBC8Phkp+QVX
         sjz8VmAW+89J1YEciDuzUoG732Me0gSSwPHSO/1N2Lj2d5YdlwVdw+8lg/DJ5Auyx+N7
         8PUAU9eXQAp6iI9gqxhrxbTERbNRkNdTxV+i7Mhl/P+qe9NyH/BPbKQj1qwUrmnQTPzB
         b1FbAoBxTHf66cC8kMKb9KDu4svkrEdM9RaF5PZXi//AT206XNYqIgizoS4OeRZ3P+Vu
         TJ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXI0qNcd4VIEDdqcnQ2bPs9r5Aw4Itd+BdDt7JqCb9sjpuaJn0XN6M8wavsnMsNAwyO8yQEH94FMw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxABKMSDjpYg4dAlDp6gTRFf9mFO6XToew+Bb41dxuamFgmFQuT
	B5LKLx9HSo4Wb5WSNc+1Xz8kIDT0xAaksc3N0JWX8rfNcV9JJ8kacnfhVdG0TVI=
X-Gm-Gg: ASbGncsUaxDBtd2Fh06KTYXbWozRc50wVMsz0zPMCk/H3yFwdsbe6YF6zyS3RHmCjjv
	4GoNTre90L/Bw1UTeOo1vvVdwGkvijbeoJ64rcaw/jbjHw2TRqz8fHtbQiZYyxv+Cq/aU3JaYt/
	9/i78T/LsWpw6SzUsIs7O8UWkOJs1po6ayg2xJ2PRH6Xzu08BBL22ts0LNVOcB9OHbggnMILN+a
	IQO+09MqkSgJpRyUGv+8KVE6m+Y6K7FjxLpsoIgC/lqfTs=
X-Google-Smtp-Source: AGHT+IESxb4ZBWnQjANqv633zPRNwgXlL5qp0koS0neZNYlYqJdfFfgNSI/Dd5CsOfd6P4zPzpKMpw==
X-Received: by 2002:a05:6e02:1f8a:b0:3cc:b7e4:6264 with SMTP id e9e14a558f8ab-3ce3a892c05mr203910065ab.0.1736878205032;
        Tue, 14 Jan 2025 10:10:05 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce6c1fc60dsm18220165ab.7.2025.01.14.10.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 10:10:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 Jann Horn <jannh@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20250114-uring-check-accounting-v1-1-42e4145aa743@google.com>
References: <20250114-uring-check-accounting-v1-1-42e4145aa743@google.com>
Subject: Re: [PATCH] io_uring/rsrc: require cloned buffers to share
 accounting contexts
Message-Id: <173687820427.1326090.9681462149230294879.b4-ty@kernel.dk>
Date: Tue, 14 Jan 2025 11:10:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Tue, 14 Jan 2025 18:49:00 +0100, Jann Horn wrote:
> When IORING_REGISTER_CLONE_BUFFERS is used to clone buffers from uring
> instance A to uring instance B, where A and B use different MMs for
> accounting, the accounting can go wrong:
> If uring instance A is closed before uring instance B, the pinned memory
> counters for uring instance B will be decremented, even though the pinned
> memory was originally accounted through uring instance A; so the MM of
> uring instance B can end up with negative locked memory.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: require cloned buffers to share accounting contexts
      commit: 19d340a2988d4f3e673cded9dde405d727d7e248

Best regards,
-- 
Jens Axboe




