Return-Path: <io-uring+bounces-2179-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F42990540B
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 15:46:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2436282C63
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 13:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 300197FB;
	Wed, 12 Jun 2024 13:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ietC4pvt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7794315444E
	for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 13:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718199993; cv=none; b=ULhkRru5fX0J3X85zQLuF7gA1sKBLp1bcs9sisMC+jH36w/boc6zB8T7coiP3De8ZA+48w8PwLq3KfIN44WP92YtWI8rJCEzUXTpzWvxZXFu0qxBQODl6Mov0iEMQdIfoqg52xgsFeg9tRWWmFHRsbTynjexTqopQzru7DOTf4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718199993; c=relaxed/simple;
	bh=tdQF4VIxPIkLWJ/BzFY5OIsItn0xOpcyor1R3gZ5i0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qDnJJp59kv6Oqc7V2sBOyqFLbU/lnYHcuU4Ud0KqcTHcY1mXLJoAZ0uzF7o+Dei/Q4fuyncPrlW9IbpXZuNvhf2zUbW3xkkJGPuYbrDKPhEJ/Nu0GxDDuGUd21G+HsMIJzjvStYbSN8d08lUIQitauSebQOs5LXKztOHzy8CFLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ietC4pvt; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-57a5bcfb2d3so4954030a12.3
        for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 06:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718199989; x=1718804789; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Emg07sc9J+iEjHnbore/cxFsPIXrz4tCs7X983cQPk=;
        b=ietC4pvtLan8iYihY2Sl0IuB6mqlR2+g3JtyxedKqC0uUcXTdd2rGH0Lss4XUNt/pV
         GLmtKZWL853rj58Clu7aPXzJnIl509InTXuiddqMW9XRdIRLrD7sm0JvfcrE2Nv7gzkJ
         8bQQ/XPyX+JaMenl/U4A30uERLxDjxHS6KAkN9+DPe59O1OX3gDnV43Zf1uQW6YXQmGS
         LioPWUZCEA+F7JS+hsN1ioR83GfP7951zmsg7Zk04SHT2x0rJFiy1xxcbn5JMuv5+l4U
         h+gmpTVDL8IWv/17odZ+gUJUhAT9jQLhLzxps7bqM0AHknxHrwkYSg+leAZ1XN9u3Kqe
         O6BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718199989; x=1718804789;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Emg07sc9J+iEjHnbore/cxFsPIXrz4tCs7X983cQPk=;
        b=X5nZLI6VOrfNjjD4Nn3F9aHNJrv3ypuShOsKu6DlPyv5XbxHG4MW3yM93IBqOtIlSF
         USVe6dae0gD3e2bELVjvHAxi15NlNEm+mg4Pbeu7stWPQaMStF3g17Culq3den0XkeoI
         leYy9FUQGKWX4Nx1T6yzCsffJkRUND3RStkXBzpwvOZHmXvJsHDsJd62vv/8S8lX6p+u
         Qli4HH6tBjvwCE98aFEuY4epe4e/TdoJb0HyAusdguYEV1o4xnIbknw1f2zPQZSdOguf
         m5m25J4mrXLNSEtqg8bYLf4oZk+GdbCBZdoLIlK3b6mtyRCvQEuynxQEXpedQZNxkEMc
         p1WA==
X-Gm-Message-State: AOJu0Yz2tAkCBo5DNgCdV1xvbSvRqlU9G9q5jKwMn941BLlg8hgfrpKu
	1023kFfpZk19WUE3DJXlMUxgQDywsMXiFovlx9jp+nYAyNWQjNz3HdOtCQ==
X-Google-Smtp-Source: AGHT+IFiMlTaI2+KFqJlOM7F7WWJdQfVceqWtz7bS8NKAB5B5/QiJbAqOB5Wb9JfVRQm2L+0U3zyNg==
X-Received: by 2002:a50:d6c1:0:b0:57c:8035:50ef with SMTP id 4fb4d7f45d1cf-57caab271f5mr1674771a12.35.1718199989306;
        Wed, 12 Jun 2024 06:46:29 -0700 (PDT)
Received: from [192.168.42.148] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57c81d8d79bsm5499054a12.45.2024.06.12.06.46.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 06:46:28 -0700 (PDT)
Message-ID: <0443edcd-941b-4347-9d8e-4d11edd99c66@gmail.com>
Date: Wed, 12 Jun 2024 14:46:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: don't lock while !TASK_RUNNING
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, chase xd <sl1589472800@gmail.com>
References: <77966bc104e25b0534995d5dbb152332bc8f31c0.1718196953.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <77966bc104e25b0534995d5dbb152332bc8f31c0.1718196953.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/24 13:56, Pavel Begunkov wrote:
> There is a report of io_rsrc_ref_quiesce() locking a mutex while not
> TASK_RUNNING, which is due to forgetting restoring the state back after
> io_run_task_work_sig() and attempts to break out of the waiting loop.

Jens, can you add while applying please?

Reported-by: Li Shi <sl1589472800@gmail.com>


> do not call blocking ops when !TASK_RUNNING; state=1 set at
> [<ffffffff815d2494>] prepare_to_wait+0xa4/0x380
> kernel/sched/wait.c:237
> WARNING: CPU: 2 PID: 397056 at kernel/sched/core.c:10099
> __might_sleep+0x114/0x160 kernel/sched/core.c:10099
> RIP: 0010:__might_sleep+0x114/0x160 kernel/sched/core.c:10099
> Call Trace:
>   <TASK>
>   __mutex_lock_common kernel/locking/mutex.c:585 [inline]
>   __mutex_lock+0xb4/0x940 kernel/locking/mutex.c:752
>   io_rsrc_ref_quiesce+0x590/0x940 io_uring/rsrc.c:253
>   io_sqe_buffers_unregister+0xa2/0x340 io_uring/rsrc.c:799
>   __io_uring_register io_uring/register.c:424 [inline]
>   __do_sys_io_uring_register+0x5b9/0x2400 io_uring/register.c:613
>   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>   do_syscall_64+0xd8/0x270 arch/x86/entry/common.c:83
>   entry_SYSCALL_64_after_hwframe+0x6f/0x77
> 
> Fixes: 4ea15b56f0810 ("io_uring/rsrc: use wq for quiescing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/rsrc.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 65417c9553b1..edb9c5baf2e2 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -249,6 +249,7 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
>   
>   		ret = io_run_task_work_sig(ctx);
>   		if (ret < 0) {
> +			__set_current_state(TASK_RUNNING);
>   			mutex_lock(&ctx->uring_lock);
>   			if (list_empty(&ctx->rsrc_ref_list))
>   				ret = 0;

-- 
Pavel Begunkov

