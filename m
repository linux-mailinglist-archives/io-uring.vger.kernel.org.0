Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF7D41FC11
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 15:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhJBNLU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Oct 2021 09:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhJBNLU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Oct 2021 09:11:20 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB56C0613EC
        for <io-uring@vger.kernel.org>; Sat,  2 Oct 2021 06:09:34 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id n71so14937459iod.0
        for <io-uring@vger.kernel.org>; Sat, 02 Oct 2021 06:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pozTXkfA/b5vec6jt8AcXXI+R00wOP2Yi0Wf3NhMmPY=;
        b=eGb8uXYGQep+IsbaRi/0ry8Dy76NA10noY/iJLzXtUgk4ASxZ00SQfZ6GUjXI+Hyfh
         XkVpsedrePQSrWuT7P6WQrGhrrXx/sR91YsIWNYN9WK1ZwDHPExmTUk4i+GrCEDLwAL9
         l5g0Oj2jGf1tdavxGuApOkvZnECd4im7/VNwPTH4Z2V2J6uYNjLlgHatbGxkdOJzHhRE
         b8la04RxD/I+fkcYCV9jqO+4dxjamrgGGo1BuwHrwcc3XhGa7TJLJo0prFNiu8bm2vYc
         6FhRd7X5HHxjZgEfiVLFEyF8BWr0Q5amHDwERahHdEDmQeJkcW0rm/mPfg17D/ZmSqpi
         5+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pozTXkfA/b5vec6jt8AcXXI+R00wOP2Yi0Wf3NhMmPY=;
        b=BeLxm1RZ13Grr21jBif7MJKt1rFSdHMU/Kiq5tJZSDX94AfYMae3a1it3YVfLuZ51C
         w6Ym+eNx6CQEhd4rHXw5XICm6j6Qm1rruuGFvLbZa4G62BGZZOdNjUAuOM9Rd6/AJuoQ
         /lGp5UVT3Ty9q9POqDGkNyxDtQWdh+0+dQf4JEdiQQvDIR8DB0ID4Au1E6HHJab0vYMU
         5gUlER8ZSF/nISTETy128pIUBKO6VReQfefyQc5pjYq9pwjdpI/3BbjTeMAyYz+/KMZh
         QVHzAHKFtX3CNOj97GnKpBTndqfGx8rr3QYyozLv5/EhZLnSPEFE38R0usx1fio5sqjC
         MALQ==
X-Gm-Message-State: AOAM5334gYNBsyM50YNW6PeOIjByRiGPBJlv9nlsvrJB5c1BbhFnnA0D
        kn9AhZTrBzZPvGkntoF3ksyGbz7Z1zEjTw==
X-Google-Smtp-Source: ABdhPJymzuTVuRaqSZ05AZBZjgzPDXIE0Ur3vHDegLjLgDmEhzvgHaqtv1wssM+Hho+DJ/qjLu9vTA==
X-Received: by 2002:a6b:b589:: with SMTP id e131mr2344038iof.100.1633180173595;
        Sat, 02 Oct 2021 06:09:33 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id l3sm5511399ilq.48.2021.10.02.06.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 06:09:33 -0700 (PDT)
Subject: Re: [RFC] io_uring: optimise requests referencing ctx
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <69934153393c9af5f44c5312b89d4beb9ce0b591.1633176671.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6c2d93f5-e8c3-ab87-72eb-e1b977c833f3@kernel.dk>
Date:   Sat, 2 Oct 2021 07:09:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <69934153393c9af5f44c5312b89d4beb9ce0b591.1633176671.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/21 6:15 AM, Pavel Begunkov wrote:
> Currenlty, we allocate one ctx reference per request at submission time
> and put them at free. It's batched and not so expensive but it still
> bloats the kernel, adds 2 function calls for rcu and adds some overhead
> for request counting in io_free_batch_list().
> 
> Always keep one reference with a request, even when it's freed and in
> io_uring request caches. There is extra work at ring exit / quiesce
> paths, which now need to put all cached requests. io_ring_exit_work() is
> already looping, so it's not a problem. Add hybrid-busy waiting to
> io_ctx_quiesce() as well for now.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> I want to get rid of extra request ctx referencing, but across different
> kernel versions have been getting "interesting" results loosing
> performance for nops test. Thus, it's only RFC to see whether I'm the
> only one seeing weird effects.

I ran this through the usual peak per-core testing:

Setup 1: 3970X, this one ends up being core limited
Setup 2: 5950X, this one ends up being device limited

Peak-1-threads is:

taskset -c 16 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n1 /dev/nvme1n1

Peak-2-threads is:

taskset -c 0,16 t/io_uring -b512 -d128 -s32 -c32 -p1 -F1 -B1 -n2 /dev/nvme2n1 /dev/nvme1n1

where 0/16 are thread siblings.

NOPS is:

taskset -c 16 t/io_uring -b512 -d128 -s32 -c32 -N1

Results are in IOPS, and peak-2-threads is only run on the faster box.

Setup/Test   |  Peak-1-thread   Peak-2-threads   NOPS   Diff
------------------------------------------------------------------
Setup 1 pre  |      3.81M            N/A         47.0M
Setup 1 post |      3.84M            N/A         47.6M  +0.8-1.2%
Setup 2 pre  |      5.11M            5.70M       70.3M
Setup 2 post |      5.17M            5.75M       73.1M  +1.2-4.0%

Looks like a nice win to me, on both setups.

-- 
Jens Axboe

