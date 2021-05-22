Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE3038D2B5
	for <lists+io-uring@lfdr.de>; Sat, 22 May 2021 02:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhEVA5K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 May 2021 20:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhEVA5J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 May 2021 20:57:09 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DDBC061574;
        Fri, 21 May 2021 17:55:45 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d11so22595077wrw.8;
        Fri, 21 May 2021 17:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=i/GOtIqm3vBucvrsX3tS6msGOS9XSleUkpRlxKUqD2g=;
        b=M+Mi6AB2pb+oOt0WQZWG30i2xOFUcV0gt4INvkS0RZW/tsw37tCS40ko24eykPiKbo
         tjRSxQMBeQ7eZYoIq1fEOju+LyWtqXjp5LljBbZZKYiJbthZidGrV0ignzsyEw8Fr4Rh
         4YTvZnxvQVNBFV+LjElzvR6b+kmGymWvu5MWd1bGh1ZllheUHBDxd69PpNZcJuncE19I
         xe+v+1afcJxQ51XGBi6kA+lorFbtu8qrKfVuF0fyZuRZf3my3o+vTdu1FBm99gkmNh4K
         yV1XRSr/M5bJwo2T44M6nRVC63ayWp5GYNXy+HL/jOdWIUiUqcd1exH+PPyM+6t9CZU5
         rhDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i/GOtIqm3vBucvrsX3tS6msGOS9XSleUkpRlxKUqD2g=;
        b=mcW3GmebeQgAhSdz0E1whDLvEtsuLI40tasNXn6ZG4tHQhXuPf8teSQTIEANHrA+oH
         szVsWPo1P0On4KnXmiXuvA/uzuKXTKqsiwKUKmbjQ+pbdCUJEQtVzp+77SenzwLiBfnT
         DTOR960iUEyunzE+MdUzD8SU0iQh8uHcxVpbmfclWUJx22lnlsC4WU9x4uvqRXfsEkGg
         WZT9HdzlweM5bko2SlK6LsTFfTqbGVv0u61hMCDNAtN7jdY1pO75eh1wUJOVHVQ+bwef
         YHl0rrSZPp4Dgo6oJL+DOMR/Aaq/5+ssJBw6YtgSGzuucZr3Yj5ktYuYKx6/podPexxH
         zo8A==
X-Gm-Message-State: AOAM531mYD5y7C/l58p62tJ+/nV+wVUOS/9XKJnKNQ1+q2IviODufnJl
        hHhTJvr0jWm2vmZ8XN9VEKw=
X-Google-Smtp-Source: ABdhPJxlUx6PN+TeZgFX8NVmu3QEZaU92AaeCE17BO1Qek84diFfFougBMPiD4riu61hf0jGbah7fw==
X-Received: by 2002:a05:6000:244:: with SMTP id m4mr11884612wrz.225.1621644944518;
        Fri, 21 May 2021 17:55:44 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.182])
        by smtp.gmail.com with ESMTPSA id a123sm1047247wmd.2.2021.05.21.17.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 17:55:43 -0700 (PDT)
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogW3N5emJvdF0gS0FTQU46IHVzZS1hZnRlci1mcmVl?=
 =?UTF-8?Q?_Read_in_io=5fworker=5fhandle=5fwork?=
To:     "Zhang, Qiang" <Qiang.Zhang@windriver.com>,
        syzbot <syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
References: <0000000000008224bf05c2a8a78b@google.com>
 <DM6PR11MB42024E7A188486B8850905D6FF299@DM6PR11MB4202.namprd11.prod.outlook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <b6a339b4-e25c-1466-3db4-f96739365ca6@gmail.com>
Date:   Sat, 22 May 2021 01:55:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <DM6PR11MB42024E7A188486B8850905D6FF299@DM6PR11MB4202.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/21/21 9:45 AM, Zhang, Qiang wrote:
[...]
> It looks like 
> thread iou-wrk-28796 in io-wq(A)  access wqe in the wait queue(data->hash->wait),  but this wqe  has been free due to the destruction of another io-wq(B).
> 
> Should we after wait for all iou-wrk thread exit in the io-wq，  remove wqe from the waiting queue (data->hash->wait).   prevent some one  wqe  belonging to this io-wq , may be still existing in the (data->hash->wait)queue before releasing. 

The guess looks reasonable, it's likely a problem.
Not sure about the diff, it seems racy but I need to
take a closer look to say for sure


> look forward to your opinion.
> 
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -1003,13 +1003,17 @@ static void io_wq_exit_workers(struct io_wq *wq)
>                 struct io_wqe *wqe = wq->wqes[node];
>  
>                 io_wq_for_each_worker(wqe, io_wq_worker_wake, NULL);
> -               spin_lock_irq(&wq->hash->wait.lock);
> -               list_del_init(&wq->wqes[node]->wait.entry);
> -               spin_unlock_irq(&wq->hash->wait.lock);
>         }
>         rcu_read_unlock();
>         io_worker_ref_put(wq);
>         wait_for_completion(&wq->worker_done);
> +       for_each_node(node) {
> +               struct io_wqe *wqe = wq->wqes[node];
> +
> +               spin_lock_irq(&wq->hash->wait.lock);
> +               list_del_init(&wq->wqes[node]->wait.entry);
> +               spin_unlock_irq(&wq->hash->wait.lock);
> +       }
>         put_task_struct(wq->task);
>         wq->task = NULL;
>  }

-- 
Pavel Begunkov
