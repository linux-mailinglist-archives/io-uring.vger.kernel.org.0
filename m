Return-Path: <io-uring+bounces-807-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCF2186DA55
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 04:45:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B6CF1F23BB3
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 03:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F83716FF42;
	Fri,  1 Mar 2024 03:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qV4ea8Vc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF7B46425
	for <io-uring@vger.kernel.org>; Fri,  1 Mar 2024 03:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709264745; cv=none; b=Fntvl9jqutOfqEyKi5reafW+GU1tOMY2s98tXoLElGKAGe7O++JoXZzralVauY25ouWbvpgqDT1N3s51cluWXg7ptOF0vvEMPBVLhUbHG4E8Glz8BgPvAvPB8HzyUD5Fjm2VSFnW++roj6a64XXecEaU14gszDByp3t4yeQ2wDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709264745; c=relaxed/simple;
	bh=GWg9Ph6B43PJ4z2u13UcBBvD5kSkaPCdsM4Ltp6soBI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=a8qge0M7q8jBRN3XCnUp/eIGGbcM/aXuh0/ZN5Xgr6EXPrHFvf1NdWinSF3EOV46W46g0iEaCLUhNEBHAAn0kPKki4cYjDY8j9blD1oWjv18OK4SG2dF/qY4R1hpGbf9+N4PXYcCHb3bFuMuwQLUTCAHI28omgyALJNXdQ+rgIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qV4ea8Vc; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3be110bbff9so429674b6e.1
        for <io-uring@vger.kernel.org>; Thu, 29 Feb 2024 19:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709264740; x=1709869540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+EbIhSHCE575NmleSsCYAMs8fWOG3Nl6sXfcx77q5BQ=;
        b=qV4ea8VcANip1RO5K5nJr9lyhgzp6H3JbSSA17YMNu3vzcZxiYWSDlIKG8rQTdRWz6
         tgVKbvK+01Y3ku+WFhVfPpoYZAjjct/GJ1GyjbszVBJWZ/vOUsTJpwkmXlulkdP8r6ae
         QpYMNGJaRkXXTG1xs75sK8eXqGnomoPQ7HEqZ2BJZKrAcxOpK4xsjzX/2Qzrloot6JeP
         1IYwdhVoiVezE4UojlNKfmIiBX/KxqwSaJgXb7hQfGNzTzziKmuz26yYFVs4YEV/HeIR
         Wr8osNksKk8n0ePS8EK7uIIlQUTElOXGdJL/GsLIu78LO+2qI8g8h5YFVtrCMXLpbQpH
         IKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709264740; x=1709869540;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+EbIhSHCE575NmleSsCYAMs8fWOG3Nl6sXfcx77q5BQ=;
        b=kich6WnEUm0SEWtPoCYIkIo7NvaCNmW9z235VejA1qwcG9X0OFH1XnJqEwki8F47Ls
         mk/gyUAqVA1PHudzuqZ6f6Dy2zv+TH6s4d5UIVBx/kJ7VeWUvwAOVwsHf/BIZw/fvx3a
         5G+dzTmOSxhKTdpIVmqSLvPAnvQgtq3EJXEgJsxw7O0iDon2YzY6KZOqpKiD+cbhnn7K
         Y/swatBI28ZDgBN+axVBlVaKOD3YesViyPUG/518g/rVcr1T4EB3NQziPpBvTBimLsdg
         el8GKGAZ0d9Q4dI5tZNb+SH5x/gvONEptMy4MeF1aQnwGxGFMPUR5HsweRxbYi41WaTn
         hWQQ==
X-Gm-Message-State: AOJu0YzqXGUWv890DQya4IE+Xn5s1cHn8+SGAwemFkyygQQvLOClDIjn
	fcQiwgK8HKplRkyRLtHyWxf4vxqnHQyM3zvtOsx0NtXgaBW2U/XZoA6FH3emDd4=
X-Google-Smtp-Source: AGHT+IE3EdSmR6I59tuvpaR+ZtFW1ogV3CNwhJv/Rh0kBxXqHzJY/am+xZnf8qK7N6bwbS6m7+OHAQ==
X-Received: by 2002:a05:6870:1b89:b0:21e:be91:ae48 with SMTP id hm9-20020a0568701b8900b0021ebe91ae48mr533341oab.1.1709264740328;
        Thu, 29 Feb 2024 19:45:40 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u23-20020aa78497000000b006e5092fb3efsm1982407pfn.159.2024.02.29.19.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 19:45:39 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: dw@davidwei.uk
In-Reply-To: <935d517f0e71218bfc1d40352a4754abb610176d.1709224453.git.asml.silence@gmail.com>
References: <935d517f0e71218bfc1d40352a4754abb610176d.1709224453.git.asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: get rid of intermediate aux cqe caches
Message-Id: <170926473933.979762.1143968313009681859.b4-ty@kernel.dk>
Date: Thu, 29 Feb 2024 20:45:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 29 Feb 2024 16:36:37 +0000, Pavel Begunkov wrote:
> With defer taskrun we store aux cqes into a cache array and then flush
> into the CQ, and we also maintain the ordering so aux cqes are flushed
> before request completions. Why do we need the cache instead of pushing
> them directly? We acutally don't, so let's kill it.
> 
> One nuance is synchronisation -- the path we touch here is only for
> DEFER_TASKRUN and guaranteed to be executed in the task context, and
> all cqe posting is serialised by that. We also don't need locks because
> of that, see __io_cq_lock().
> 
> [...]

Applied, thanks!

[1/1] io_uring: get rid of intermediate aux cqe caches
      commit: a7fa76c8565aa6cbeb5030a6597d85643de0a306

Best regards,
-- 
Jens Axboe




