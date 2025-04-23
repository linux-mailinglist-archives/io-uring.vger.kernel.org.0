Return-Path: <io-uring+bounces-7671-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8A4BA994EF
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 18:25:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DC3D9C377D
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 16:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C26F17B421;
	Wed, 23 Apr 2025 16:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M1YavuLW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FE828EB;
	Wed, 23 Apr 2025 16:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745424454; cv=none; b=ghvkeCwT1oJQhhiWbOo7q0Qsp/69m4EMgoMfnXTfKI+fi7a5bbXXB3KvkLQOJI8sXMwQ9o6e/UPoJbkTiWXdA6oHyoPs2ghTmtIQYxvkeN9qSW7Y9sJgZrHY1ZowWxB8q7QhEebbmK8UTZ5f8e6es7Qu4t6aSHAu7tcPkhsuQVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745424454; c=relaxed/simple;
	bh=zK2xckH0k298gNDB5m7I40ePyWIZJZDP8UH/tnif+4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DhqtSEqeln2TBNHlGZijCj/KgFz8cxfoZhStps3UKnoZGRxKHugNmq/VN6DEvBNAiVzJN0e0/7EPEFyNKCM+6J4erAAZJxeF+y1805gassYa1Pwu7okU6tGiNrl7QGEfkTgEbvhqM9ssEmBgad5LjSHa4ZCR2dtTRxDLXlbfw/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M1YavuLW; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3fefbbc7dd4so3530778b6e.2;
        Wed, 23 Apr 2025 09:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745424451; x=1746029251; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jp3c2R+Dvzznb6QyRdQyTKPd8rsyETvRlusI2YyXXuU=;
        b=M1YavuLWC80Pb/qyGkDc7Z8an3CQ29M/4CtFE+BbUuN6OaqP/qe5uLOhaFHmo3F78r
         ERCB3/1aoXUw1dPy2H+BDAvBSBhZ2F9+o4t4BEXTqj8hzKz3Iud6xJfeXNZweF9GG/pr
         ZOO7RbbMESTgNdxxaH4hwME7m7HnnYRLEGEqNhl3eiQE+DKvcwaUSAQs+WJ0wrGHZRFY
         qnd1OY3yZmLgPRp36j7sVD/aOQuAPLtv2MNr7zqKESBW7UyosvjX7dgtg/PoL7cd0aTC
         /rv22uuhD2sMShoPFaZ7NWCLCyzrWpT4JYJqeYUM4ESBRNxTDK8/cDeND12vQHW33o3k
         AjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745424451; x=1746029251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jp3c2R+Dvzznb6QyRdQyTKPd8rsyETvRlusI2YyXXuU=;
        b=Onjvo5qmnnC3dwxqhhVV96okagLQKlIoJVKRLd1pYmefnol4GUmS8zC7nidjZEi3f/
         uOTP044CMC6QDWkY/tdsAj9SCVjH5Hhf4zP9mlijAL0cV0UJlt2e8XhYqNHfNb3KV5vS
         6+PwOzu5LYGrXoE2YHfdxPdO0A9q2cBKjXK1s/qijdT9sk0ZRJ0TCQ335HO8MI8cdeEj
         ozr1mDrVCRoq5N81Bkq9wecfdxEWRlkVhSX5voGangdCzlxaSueNpjQs9niY+6k0Dlof
         PaOVcxWtQtLTvk4n6KQn3x6+EA+Y28Jba94Zvd2Hwx9Ie8oSIPc2TlHhPtzKMSKpfif5
         FxLA==
X-Forwarded-Encrypted: i=1; AJvYcCVbzr7oVhEgrlNOdIn53kbqppqyeEpx8dijH0D2hD46QE0optjdqDfrpoDdQa0L5NK5C9f+tyOHGA==@vger.kernel.org, AJvYcCVqS6n49eDeo1fQDPDJ36dy/ZFAvZnQoweFKKynlHe7okDK7V82lJXJ1YyveIyT0KyMMoyAg4WcsumZsqmE@vger.kernel.org, AJvYcCXSNmuV2h+4Dc8vgIk65rFpEK5fksE29HH9LXuYeaO88I/MDiV+IJ3zEvSW0ol7KT6SMTDLEabluTdjez2xzg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTQdelyuXpSwGEOtpkWnxp4be90ZsxbF/cVPTdQFrevFA+x6Tn
	ae60RbbBci8gTc+EuqcGqvQybCf/oroQB2ACG9+Jg5Nk35galJzIYOb8dFUXL1t7b/nphEqY9QT
	owAsRYlss6McYMhm2mUhGgZXaz0c=
X-Gm-Gg: ASbGnctB55Dt/rNcU+Cx2BGDpafakIx2lbhBPGKSitMQaw+SFqUfpie0XtZWc6v9s8t
	As1QQX8+09Zh3N/EWQOhSA5CZrgB4YwyvNmXsGQrq0RYHTnkM7m0rhECXGzBjPZjaA80dKJyivO
	Z9Fw9oaerQHNsh0iqA6CvWVYE=
X-Google-Smtp-Source: AGHT+IH1ISvr9dZJpB5Px4chBc/FyF3c67oME1zTTLXitkE9Juv28cyF/3TrJNwl8N7dAJInbUFKI4JvrvIE4TqHCzQ=
X-Received: by 2002:a05:6870:b410:b0:2d5:ba2d:80dd with SMTP id
 586e51a60fabf-2d5ba2d8877mr5021109fac.12.1745424451426; Wed, 23 Apr 2025
 09:07:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422162913.1242057-1-qq282012236@gmail.com>
 <20250422162913.1242057-2-qq282012236@gmail.com> <14195206-47b1-4483-996d-3315aa7c33aa@kernel.dk>
 <CANHzP_uW4+-M1yTg-GPdPzYWAmvqP5vh6+s1uBhrMZ3eBusLug@mail.gmail.com>
 <b61ac651-fafe-449a-82ed-7239123844e1@kernel.dk> <CANHzP_tLV29_uk2gcRAjT9sJNVPH3rMyVuQP07q+c_TWWgsfDg@mail.gmail.com>
 <7bea9c74-7551-4312-bece-86c4ad5c982f@kernel.dk> <52d55891-36e3-43e7-9726-a2cd113f5327@kernel.dk>
In-Reply-To: <52d55891-36e3-43e7-9726-a2cd113f5327@kernel.dk>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Thu, 24 Apr 2025 00:07:19 +0800
X-Gm-Features: ATxdqUFKq1W7-Omh1z5DPQ-NHXJK1dKargy_MWbOfKOS25w3ULb7O98bWs12Xhs
Message-ID: <CANHzP_tGxKmcQpVZOt077a-MYb3YHLcZvZDcFxsha4BLt1y16g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault scenarios
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2025=E5=B9=B44=E6=9C=8823=E6=97=A5=E5=
=91=A8=E4=B8=89 23:55=E5=86=99=E9=81=93=EF=BC=9A
>
> Something like this, perhaps - it'll ensure that io-wq workers get a
> chance to flush out pending work, which should prevent the looping. I've
> attached a basic test case. It'll issue a write that will fault, and
> then try and cancel that as a way to trigger the TIF_NOTIFY_SIGNAL based
> looping.
>
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index d80f94346199..e18926dbf20a 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -32,6 +32,7 @@
>  #include <linux/swapops.h>
>  #include <linux/miscdevice.h>
>  #include <linux/uio.h>
> +#include <linux/io_uring.h>
>
>  static int sysctl_unprivileged_userfaultfd __read_mostly;
>
> @@ -376,6 +377,8 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, uns=
igned long reason)
>          */
>         if (current->flags & (PF_EXITING|PF_DUMPCORE))
>                 goto out;
> +       else if (current->flags & PF_IO_WORKER)
> +               io_worker_fault();
>
>         assert_fault_locked(vmf);
>
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 85fe4e6b275c..d93dd7402a28 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -28,6 +28,7 @@ static inline void io_uring_free(struct task_struct *ts=
k)
>         if (tsk->io_uring)
>                 __io_uring_free(tsk);
>  }
> +void io_worker_fault(void);
>  #else
>  static inline void io_uring_task_cancel(void)
>  {
> @@ -46,6 +47,9 @@ static inline bool io_is_uring_fops(struct file *file)
>  {
>         return false;
>  }
> +static inline void io_worker_fault(void)
> +{
> +}
>  #endif
>
>  #endif
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index d52069b1177b..f74bea028ec7 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -1438,3 +1438,13 @@ static __init int io_wq_init(void)
>         return 0;
>  }
>  subsys_initcall(io_wq_init);
> +
> +void io_worker_fault(void)
> +{
> +       if (test_thread_flag(TIF_NOTIFY_SIGNAL))
> +               clear_notify_signal();
> +       if (test_thread_flag(TIF_NOTIFY_RESUME))
> +               resume_user_mode_work(NULL);
> +       if (task_work_pending(current))
> +               task_work_run();
> +}
>
> --
> Jens Axboe
I understand some of what you said. I was indeed lost in appearances.
It's very late here now, and I'll take a deeper look tomorrow.
Thank you very much.

