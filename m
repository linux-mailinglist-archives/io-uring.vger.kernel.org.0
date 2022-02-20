Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B854BCB44
	for <lists+io-uring@lfdr.de>; Sun, 20 Feb 2022 01:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiBTAWi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Feb 2022 19:22:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiBTAWh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Feb 2022 19:22:37 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACA737BFF
        for <io-uring@vger.kernel.org>; Sat, 19 Feb 2022 16:22:16 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id om7so11683970pjb.5
        for <io-uring@vger.kernel.org>; Sat, 19 Feb 2022 16:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VhvKjJherFft0gV1QcNLzSP7VXoiwHsr5iY7gxVXAMk=;
        b=LTM/DZUoJQFs1QHm0h9N7/6U71dr/BkAX+uf0Yqt/KWb4X+GiI2z7PPX3yXTHx00r5
         46AzwI5eG8rmwiYB/LftgfedSbS79Uh8b9W0iZjhM8g5qS65RsVN5zAnfllv3+CKhtBr
         TZlUiRfGKI9wCStl7IVUqsZw8EAsdQF5XRVMXkFJkAHI4cVfZDVPr4WcdRC58/lewDrM
         ztmeECXM+Mh6YdU/SCWqqonStnxab+AGSOJ/uq0xbQB2ZvLNegkQXG48eK0ufWiymflZ
         9CpKbfS7Xf/bqJaOoScAgh0J7sC+bNrj5IoKWHsRIR09eCaXfvDsb+t//sdu58i1sKP6
         UIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VhvKjJherFft0gV1QcNLzSP7VXoiwHsr5iY7gxVXAMk=;
        b=hGwJAyMlum6DmY5zTGrgUxK2gqewI8+CwE3YB3NlGt8ESLeoo+vrIp9gz94XHvZwtq
         TKRhCdFXugl1ey1TKVlMSk4tIZNzBtiqE4WGiPYkRySQMmxFJOq8yFAn125lDk61Fakq
         7u4zPgDkM84L3k6gifVdLv335/dkPj+4+FRmUyO/9n7eWgvHsm3dUaljLva0cbs7YunT
         QtL88xW0MPvsrZbQSOXargSQ5Y2vHP8jR8pomi567iDvSplsdCIpE/1Ujp1JxW89Ylvs
         K2bEIF0+5+DyxXS051zQS+nLQH/+MOQulPhHmFOvWUpdva23oZZYPtHpa1Bi6UC9/hyN
         meew==
X-Gm-Message-State: AOAM5329c/zydGCVKBaaclD/N3d2ZyxAWevSVoI2bFE+zeNJH5SShplx
        fLbmXZUObBWZtkTisLGviSR48A==
X-Google-Smtp-Source: ABdhPJyfEsE+Y7CWkAkNte94eZxgAngg7NETXMazpxEwXjmXPhn+/mgpnkpPE/znJp5/bufAeRxdCQ==
X-Received: by 2002:a17:90b:368c:b0:1b8:57c5:3fde with SMTP id mj12-20020a17090b368c00b001b857c53fdemr14862453pjb.244.1645316535534;
        Sat, 19 Feb 2022 16:22:15 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b14sm103316pjl.21.2022.02.19.16.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Feb 2022 16:22:15 -0800 (PST)
Message-ID: <f070354c-b65b-f8b3-e597-2e756bcfa705@kernel.dk>
Date:   Sat, 19 Feb 2022 17:22:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v1] io_uring: Add support for napi_busy_poll
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
 <cbf791fb3cd495f156eb4aeb4dd01c42fca22cd4.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cbf791fb3cd495f156eb4aeb4dd01c42fca22cd4.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/22 2:42 PM, Olivier Langlois wrote:
> One side effect that I have discovered from testing the napi_busy_poll
> patch, despite improving the network timing of the threads performing
> the busy poll, it is the networking performance degradation that it has
> on the rest of the system.
> 
> I dedicate isolated CPUS to specific threads of my program. My kernel
> is compiled with CONFIG_NO_HZ_FULL. One thing that I have never really
> understood is why there were still kernel threads assigned to the
> isolated CPUs.
> 
> $ CORENUM=2; ps -L -e -o pid,psr,cpu,cmd | grep -E 
> "^[[:space:]]+[[:digit:]]+[[:space:]]+${CORENUM}"
>      24   2   - [cpuhp/2]
>      25   2   - [idle_inject/2]
>      26   2   - [migration/2]
>      27   2   - [ksoftirqd/2]
>      28   2   - [kworker/2:0-events]
>      29   2   - [kworker/2:0H]
>      83   2   - [kworker/2:1-mm_percpu_wq]
> 
> It is very hard to keep the CPU 100% tickless if there are still tasks
> assigned to isolated CPUs by the kernel.
> 
> This question isn't really answered anywhere AFAIK:
> https://www.kernel.org/doc/html/latest/timers/no_hz.html
> https://jeremyeder.com/2013/11/15/nohz_fullgodmode/
> 
> Those threads running on their dedicated CPUS are the ones doing the
> NAPI busy polling. Because of that, those CPUs usage ramp up to 100%
> and running ping on the side is now having horrible numbers:
> 
> [2022-02-19 07:27:54] INFO SOCKPP/ping ping results for 10 loops:
> 0. 104.16.211.191 rtt min/avg/max/mdev = 9.926/34.987/80.048/17.016 ms
> 1. 104.16.212.191 rtt min/avg/max/mdev = 9.861/34.934/79.986/17.019 ms
> 2. 104.16.213.191 rtt min/avg/max/mdev = 9.876/34.949/79.965/16.997 ms
> 3. 104.16.214.191 rtt min/avg/max/mdev = 9.852/34.927/79.977/17.019 ms
> 4. 104.16.215.191 rtt min/avg/max/mdev = 9.869/34.943/79.958/16.997 ms
> 
> Doing this:
> echo 990000 > /proc/sys/kernel/sched_rt_runtime_us
> 
> as instructed here:
> https://www.kernel.org/doc/html/latest/scheduler/sched-rt-group.html
> 
> fix the problem:
> 
> $ ping 104.16.211.191
> PING 104.16.211.191 (104.16.211.191) 56(84) bytes of data.
> 64 bytes from 104.16.211.191: icmp_seq=1 ttl=62 time=1.05 ms
> 64 bytes from 104.16.211.191: icmp_seq=2 ttl=62 time=0.812 ms
> 64 bytes from 104.16.211.191: icmp_seq=3 ttl=62 time=0.864 ms
> 64 bytes from 104.16.211.191: icmp_seq=4 ttl=62 time=0.846 ms
> 64 bytes from 104.16.211.191: icmp_seq=5 ttl=62 time=1.23 ms
> 64 bytes from 104.16.211.191: icmp_seq=6 ttl=62 time=0.957 ms
> 64 bytes from 104.16.211.191: icmp_seq=7 ttl=62 time=1.10 ms
> ^C
> --- 104.16.211.191 ping statistics ---
> 7 packets transmitted, 7 received, 0% packet loss, time 6230ms
> rtt min/avg/max/mdev = 0.812/0.979/1.231/0.142 ms
> 
> If I was to guess, I would say that it is ksoftirqd on those CPUs that
> is starving and is not servicing the network packets but I wish that I
> had a better understanding of what is really happening and know if it
> would be possible to keep 100% those processors dedicated to my tasks
> and have the network softirqs handled somewhere else to not have to
> tweak /proc/sys/kernel/sched_rt_runtime_us to fix the issue...

Outside of this, I was hoping to see some performance numbers in the
main patch. Sounds like you have them, can you share?

-- 
Jens Axboe

