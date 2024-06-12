Return-Path: <io-uring+bounces-2196-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 515FD905B9D
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 21:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65A851C21C04
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 19:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F230E7CF1F;
	Wed, 12 Jun 2024 19:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Cet2BGJd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47111C14
	for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 19:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218963; cv=none; b=IooejkiNKb1Cw+Zh04IaWPekyjorymyU/YGK+wALS8H0ChptSo/4d3azzv16TOuylz7FQAsnA2Vscxjfzpr8evwptJ3n7CyL9uYVfcik1WLYatOJZX4gFBZEOng4owFabvKuIOt8AH/uiPKODw8m9gOOVs3hiuoRn4O3WwMvcnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218963; c=relaxed/simple;
	bh=0Hb5sKC0H1KXhLwy447YjjF/Zl7QiNlFuZjhzm7z8TY=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=n41zynOHc//+xZIlmFWoWgujgJiMyBB6cR/Pj2K4E8GkJ4z898lPMFU86GKSqRh4YfDvv1THJwrSWMMcFsfHH21sPU2TAD9GHA89Wodnrp5ZCpA8wXoQS8lxuO/5tsAH0YvlRZJ0iF0HozwL7rhzhhnx6P18YaDrCg6S/SFPaus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Cet2BGJd; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3d21a80b8ceso8727b6e.3
        for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 12:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718218959; x=1718823759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ArlGUkzh+3jQsYWK1Fh0I06nwWSly40SZGgiBcghKVU=;
        b=Cet2BGJdzlDvbD4QP/nPLesVVrsvIfzZAJqRwfWln/ztTCcG/UszdOgRLwqeIlKzyx
         aPIgSJHhK8q90o61RbUruiIg1GYDT17kzEE6FDvy9+QOC0OrZ0c4NyRWCD3/l5Jqgy4b
         lqGl+x+BkuzAfoRDIsw5Br25U4WBITu20pBSiypRTQXNkTo8XUrTlaI5kjbbux8h+Yrm
         0ZVGtzlmS6lNj87LHKDRjsFmHMcpnCUpkFvzFEm3QVAnw+vQ9pi21aj5VyGJlcLA+DJN
         2MV/gatwl1B52M49BbTUkdqc8+SY5SFW/u9UtotgJ3uzyFqeyqy/Act+F7NjOeNE/Uvt
         HhHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718218959; x=1718823759;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ArlGUkzh+3jQsYWK1Fh0I06nwWSly40SZGgiBcghKVU=;
        b=Gs3riAEE1D5F24SDZKemGlcAFOADxm/OzpfRC36u9tr6fw+EKpJjYQRFomfL0f9J9Z
         z942aM8UKQ1Pa484xww53D7e+9radyxuCzNSNCBLEd1dF6A2h0zP2qXOBga5R8UVqfi9
         7DqD4vDZypxXYLIz73Z7Wg/62q4kCX8QcKSgIekjYEmYb2r4NGKjtfEZCS8Gfz1rpUaJ
         HIqLlCjR/IK2qRmEy8FeUdME7drUhQKGku5Ne6svRdXoh0BkKOUC2v0Xiodjr01CnfpD
         X9R5ZiluwN98RXR1NfSGbUVxKmq9PogRvQmRvXjx9+myKURhD7mfk0L9nPolIj/dC53O
         lQwQ==
X-Gm-Message-State: AOJu0Yxb64OMxi8aCGI90V2K5UKffB5AgnM+/ErQ7sMfXvClHxbCDAkO
	R34Y3ZYy6v+3sRKssz4ZKushS9lCybbp9arTK5ee73oz5FFPbXgO+NWp/l3Tc//CFP050WdPSfU
	/
X-Google-Smtp-Source: AGHT+IHt7rYK2QsEzc8ZKMN7RLf4zuNIwdBy7Sth0q3SfvV9BccKNtWwb5FWEfs9oCnF1sHF0vt+Vg==
X-Received: by 2002:a9d:7598:0:b0:6f9:8f84:9bcd with SMTP id 46e09a7af769-6fa1be4199bmr2905897a34.1.1718218959218;
        Wed, 12 Jun 2024 12:02:39 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6fa50fb74fcsm254366a34.43.2024.06.12.12.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 12:02:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <77966bc104e25b0534995d5dbb152332bc8f31c0.1718196953.git.asml.silence@gmail.com>
References: <77966bc104e25b0534995d5dbb152332bc8f31c0.1718196953.git.asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: don't lock while !TASK_RUNNING
Message-Id: <171821895843.90478.1098881039048016326.b4-ty@kernel.dk>
Date: Wed, 12 Jun 2024 13:02:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Wed, 12 Jun 2024 13:56:38 +0100, Pavel Begunkov wrote:
> There is a report of io_rsrc_ref_quiesce() locking a mutex while not
> TASK_RUNNING, which is due to forgetting restoring the state back after
> io_run_task_work_sig() and attempts to break out of the waiting loop.
> 
> do not call blocking ops when !TASK_RUNNING; state=1 set at
> [<ffffffff815d2494>] prepare_to_wait+0xa4/0x380
> kernel/sched/wait.c:237
> WARNING: CPU: 2 PID: 397056 at kernel/sched/core.c:10099
> __might_sleep+0x114/0x160 kernel/sched/core.c:10099
> RIP: 0010:__might_sleep+0x114/0x160 kernel/sched/core.c:10099
> Call Trace:
>  <TASK>
>  __mutex_lock_common kernel/locking/mutex.c:585 [inline]
>  __mutex_lock+0xb4/0x940 kernel/locking/mutex.c:752
>  io_rsrc_ref_quiesce+0x590/0x940 io_uring/rsrc.c:253
>  io_sqe_buffers_unregister+0xa2/0x340 io_uring/rsrc.c:799
>  __io_uring_register io_uring/register.c:424 [inline]
>  __do_sys_io_uring_register+0x5b9/0x2400 io_uring/register.c:613
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xd8/0x270 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x6f/0x77
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: don't lock while !TASK_RUNNING
      commit: 54559642b96116b45e4b5ca7fd9f7835b8561272

Best regards,
-- 
Jens Axboe




