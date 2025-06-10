Return-Path: <io-uring+bounces-8293-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B42AD3B3B
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 16:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B67B73A80A2
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 14:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09BB619CD0E;
	Tue, 10 Jun 2025 14:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uXRrrlKv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786D11A239A
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 14:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749566041; cv=none; b=bHwcesh4iSvRna9QS6bm5JgVSiA6C/Zqik2HJ7rx0c+P+Wtt1eHOI2QSQVdFFOqonhHI91hTTEiKfrtu/w+AmazIW7NtHLXlcVRG7sRpr/sePqtM+xwBv+n4rHcFobvhI7GuqnCvo2si5+o6HLzuJ7d6RwZTCfkuWw73i4jg1bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749566041; c=relaxed/simple;
	bh=pAKxeGee5hYim+nL+Rs/49E6KsFoJV+dqj4fAlLpzDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LNbQt0SSWEj6S81bInfqJz02PgLLzvcuIHF0IzgDY9SmJGLTnFjswozkEoet1KwfpNaEDLgydAONsi1ejKCRZGClrXrjz4/HcXtNpCWIJUqsy14gpF2niOHxisi+lbtJmeGCOa7s//iYfQ3G9FCJ27S/SceyWTkNQm0pg6VVHbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uXRrrlKv; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-8731c3473c3so144776539f.1
        for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 07:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749566038; x=1750170838; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ekBoU2yYMPWW4Dnqk5aHWEL3RevwpBEXg8v1UkgbqYY=;
        b=uXRrrlKv/v4gNahOzqz2E5Iuz1IU2B8im4X3TOliFz27x8J95njyKsICvm7Jt7dmot
         SgfCoyEbVWFMRM3nuxgoEsK0i47H/4nhMq+U2vyQQEevJRw9LBfpGGLSeh4DopgaosNC
         ndZ1nW+4su8sHsK9iPHhSlYKQ4PMoIrr55X+d0q1tO+LVjrp/M0zSYA5XuIaroLl9VcW
         /pXA5UUumzzQurtNSsajRB+kO7Ux9vJeEfH9VXX2NbLRCO8sE7s20TzYgpSYUSLh1vve
         hn5NYbcmA7Sp0No/VO3y6pjFzZqbitveFRSk4N9Yd9wkWarSQcgwoCgbMEHZxRV+R+F1
         DxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749566038; x=1750170838;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ekBoU2yYMPWW4Dnqk5aHWEL3RevwpBEXg8v1UkgbqYY=;
        b=Mr9gN1rxGaG30XyRoOJv/vdpYEhG0ZzTOYlJqSpZGxLpsrF6aWJaUn5QdUgbzRqDEN
         kWP/MC1jttZsZEAZR34wS4Hy+Vwzfb0orUwDapCpKrSIbJkFIQJ2Y8SIAMCc0oywQNtV
         TFbgQ8s6vs4tVAKeo9iun2n5WK1aqlGI14UdIVP8gExKZjDLmgA5ononSDTFtJmrS9A5
         KdXb+fd+c9cb/5uEUyH5Quj2Mwr3imLv4rt7g4/12XjEmIzQMHb7RJ48Q8Kz71eh6lY6
         h8K+rohLgJTwnEj+6p2v+W0yLNYuAKpA/3JLRf+ZYD0RcR44rYZaAy1uuZ0hucFUdlqS
         k6qA==
X-Gm-Message-State: AOJu0YxEikn6AOExjKY8yZhL1PgU1ErOwHVMEFe6TG9KzeA+NNZwZXcx
	dGmE2r9+oekLKiqobvkkWAg6H+mdJBGbr3krBphuuaNOEJc7nDLJFeOxrwCuhooItAw=
X-Gm-Gg: ASbGnctXSvqsVG6MO4ABEU+SUfg3R1F6imkWdr+l0bz67DX28FEvOz9yIzV2aN5c0qz
	Tr2GvHsNTKOX2Ro7UO4Fg2AINzhLvO4oCOIToUbjOJUbrPk/gh8oue5Emopc1c273JQpKOOXkoI
	B1xyBOzgXD26lembP8Wmaj/mQtnp9LlYzTWmIDVcbffAWDeCJM2woU/dILe841wxSb+fURLtt8+
	NZruhrgVlSdyQpiUDXEy9crVpfgnmdTyhRVldIy7A9Rf3TBBS5zmwH8JL3Np65ebfKDnmw23qsz
	8/GaZSSyinxigWa7ZnF1470SGhfUdMuiIXOP70tx4tRZvQDwiTXjl7MGi4w=
X-Google-Smtp-Source: AGHT+IFtnHWEz/+j2BG9QS02+XZtsC51R6Y1Jc7tbT048c7lAH39CFIlkqW/kelKNrFEkzXDFWCCdQ==
X-Received: by 2002:a92:c242:0:b0:3dd:89dc:ab07 with SMTP id e9e14a558f8ab-3ddce3ef67fmr186968655ab.8.1749566038458;
        Tue, 10 Jun 2025 07:33:58 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-500df6102e3sm2315805173.128.2025.06.10.07.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 07:33:57 -0700 (PDT)
Message-ID: <ab764b69-6b94-4163-b114-f4889a043040@kernel.dk>
Date: Tue, 10 Jun 2025 08:33:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix use-after-free of sq->thread in
 __io_uring_show_fdinfo()
To: Penglei Jiang <superman.xpt@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+531502bbbe51d2f769f4@syzkaller.appspotmail.com
References: <20250610111721.37036-1-superman.xpt@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250610111721.37036-1-superman.xpt@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/10/25 5:17 AM, Penglei Jiang wrote:
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index e9355276ab5d..2911352bbae1 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -141,19 +141,23 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>  
>  	if (ctx->flags & IORING_SETUP_SQPOLL) {
>  		struct io_sq_data *sq = ctx->sq_data;
> +		struct task_struct *tsk;
>  
> +		rcu_read_lock();
> +		tsk = rcu_dereference(sq->thread);
>  		/*
>  		 * sq->thread might be NULL if we raced with the sqpoll
>  		 * thread termination.
>  		 */
> -		if (sq->thread) {
> +		if (tsk) {
>  			sq_pid = sq->task_pid;
>  			sq_cpu = sq->sq_cpu;
> -			getrusage(sq->thread, RUSAGE_SELF, &sq_usage);
> +			getrusage(tsk, RUSAGE_SELF, &sq_usage);
>  			sq_total_time = (sq_usage.ru_stime.tv_sec * 1000000
>  					 + sq_usage.ru_stime.tv_usec);
>  			sq_work_time = sq->work_time;
>  		}
> +		rcu_read_unlock();
>  	}

Don't think this will work, if we're racing with the mmput and then end
up doing that inside an RCU read locked region...

> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 03c699493b5a..0625a421626f 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -270,7 +270,8 @@ static int io_sq_thread(void *data)
>  	/* offload context creation failed, just exit */
>  	if (!current->io_uring) {
>  		mutex_lock(&sqd->lock);
> -		sqd->thread = NULL;
> +		rcu_assign_pointer(sqd->thread, NULL);
> +		put_task_struct(current);
>  		mutex_unlock(&sqd->lock);
>  		goto err_out;
>  	}

You do this in both spots, why the put_task_struct(current)? That seems
like that would be very wrong and instantly break. Did you run this
patch?

I do agree that there's an issue here though, let me take a closer look
at it. This would have been introduced with the getrusage change though,
no? This one:

ommit 3fcb9d17206e31630f802a3ab52081d1342b8ed9
Author: Xiaobing Li <xiaobing.li@samsung.com>
Date:   Wed Feb 28 17:12:51 2024 +0800

    io_uring/sqpoll: statistics of the true utilization of sq threads

as that is the one that added prodding at sq->thread from fdinfo.

-- 
Jens Axboe

