Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AF3467AA2
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 16:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381900AbhLCP42 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 10:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239659AbhLCP42 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 10:56:28 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D665DC061751;
        Fri,  3 Dec 2021 07:53:03 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id c4so6595531wrd.9;
        Fri, 03 Dec 2021 07:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SlChr/C9B3f/kBuwxOD1vj3J8HLlstf4N3S7LZOUMRw=;
        b=k/LiumMTH3Bplh1A+Ww8rKdtzXe2p8H59v/wv9T6B98NqdnJ//ytQFh8I/Bv4VJl3p
         Er5LOSJebGhePqGJ6SOUJ1nqQgJ8Y8lKIyrkf6diXLjhVze5epmhGzCth8JZf6HlRy2D
         9WFcfBvgjqn4oKAHovlA4VgvHcKNMAqxDBXKRZqVWt+eccJw3oDKpYGShoJb8v1VAZVF
         utMQAjmM8G16WQztKN0U9k0xtPKUsVo4+Ir6aq2+OAPgfvsgno1BYFtKeG/Y0j5T+fNF
         PQjmn5rg6vOscXOjCtZySljDleJPK6HPg6LfIzucEas0E1jihRr/U3dxCDsJW15s1Dgp
         p5NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SlChr/C9B3f/kBuwxOD1vj3J8HLlstf4N3S7LZOUMRw=;
        b=xUDo6YAYvOyPGY3vBq1tOO8hnuXsvYutVpAtNo3syRCtX9pki4m69OPK2lvfjcMOre
         Bs0iEX8RPJfCpyA+N6wm4zD8nyDFuAQMOWqo7ORSqI73x5RYr8qG4rU6Oddbldkh6x+B
         aT2cdk2jhAAArjoIpOrz8xaIBSJy25TxiGt4ljhxKiGnGIhiWKKimf1tGDJ+rhFuX/0l
         mjWB6Mupp0SCQ2uDUqxAuVNo6cJzA/1YEGOI2VZveO9M95wpZzhtS+HT8x2Cou5VIlxc
         itfGVTizltgFFnsfjgjGauoMQxaSuJckeh0dDnMqw3lotpw+3i6nwfr6PM0TYUixvVpG
         N5nQ==
X-Gm-Message-State: AOAM5336T6SSKC5/GpOE1bgg8EYaJ46Bn/UDsUafW3v5iWLohQ7LZnj3
        brtJb0heDCOJkbWwtPKViGt0MsPjAsnNhQ==
X-Google-Smtp-Source: ABdhPJw7V1dnWzckIi4ZUDBC/Xt4+CKo4e/5BthhA1BaCuOD0ueFksCDLtSsh1SVY6EZADUL2UMISA==
X-Received: by 2002:adf:e0c7:: with SMTP id m7mr22965121wri.530.1638546782386;
        Fri, 03 Dec 2021 07:53:02 -0800 (PST)
Received: from [192.168.43.77] (82-132-231-141.dab.02.net. [82.132.231.141])
        by smtp.gmail.com with ESMTPSA id w2sm2942643wrn.67.2021.12.03.07.53.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 07:53:02 -0800 (PST)
Message-ID: <aaf8aa08-f4ee-0688-2af3-2c59bb76dda6@gmail.com>
Date:   Fri, 3 Dec 2021 15:52:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH bpf-next v1 1/8] io_uring: Implement eBPF iterator for
 registered buffers
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-2-memxor@gmail.com>
 <20211118220226.ritjbjeh5s4yw7hl@ast-mbp.dhcp.thefacebook.com>
 <20211119041523.cf427s3hzj75f7jr@apollo.localdomain>
 <20211119045659.vriegs5nxgszo3p3@ast-mbp.dhcp.thefacebook.com>
 <20211119051657.5334zvkcqga754z3@apollo.localdomain>
 <CAADnVQ+rdAh2LaHOHxqk7z4aheMQ2gjzMFegrehzEfE_6twBdg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAADnVQ+rdAh2LaHOHxqk7z4aheMQ2gjzMFegrehzEfE_6twBdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/19/21 05:24, Alexei Starovoitov wrote:
> On Thu, Nov 18, 2021 at 9:17 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
>>
>> On Fri, Nov 19, 2021 at 10:26:59AM IST, Alexei Starovoitov wrote:
>>> On Fri, Nov 19, 2021 at 09:45:23AM +0530, Kumar Kartikeya Dwivedi wrote:
>>>>
>>>> Also, this work is part of GSoC. There is already code that is waiting for this
>>>> to fill in the missing pieces [0]. If you want me to add a sample/selftest that
>>>> demonstrates/tests how this can be used to reconstruct a task's io_uring, I can
>>>> certainly do that. We've already spent a few months contemplating on a few
>>>> approaches and this turned out to be the best/most powerful. At one point I had
>>>> to scrap some my earlier patches completely because they couldn't work with
>>>> descriptorless io_uring. Iterator seem like the best solution so far that can
>>>> adapt gracefully to feature additions in something seeing as heavy development
>>>> as io_uring.
>>>>
>>>>    [0]: https://github.com/checkpoint-restore/criu/commit/cfa3f405d522334076fc4d687bd077bee3186ccf#diff-d2cfa5a05213c854d539de003a23a286311ae81431026d3d50b0068c0cb5a852
>>>>    [1]: https://github.com/checkpoint-restore/criu/pull/1597
>>>
>>> Is that the main PR? 1095 changed files? Is it stale or something?
>>> Is there a way to view the actual logic that exercises these bpf iterators?
>>
>> No, there is no code exercising BPF iterator in that PR yet (since it wouldn't
>> build/run in CI). There's some code I have locally that uses these to collect
>> the necessary information, I can post that, either as a sample or selftest in
>> the next version, or separately on GH for you to take a look.
>>
>> I still rebased it so that you can see the rest of the actual code.
> 
> I would like to see a working end to end solution.
> 
> Also I'd like to hear what Jens and Pavel have to say about
> applicability of CRIU to io_uring in general.

First, we have no way to know what requests are in flight, without it
CR doesn't make much sense. The most compelling way for me is to add
a feature to fail all in-flights as it does when is closed. But maybe,
you already did solve it somehow?

There is probably a way to restore registered buffers and files, though
it may be tough considering that files may not have corresponding fds in
the userspace, buffers may be unmapped, buffers may come from
shmem/etc. and other corner cases.

There are also not covered here pieces of state, SELECT_BUFFER
buffers, personalities (aka creds), registered eventfd, io-wq
configuration, etc. I'm assuming you'll be checking them and
failing CR if any of them is there.

And the last point, there will be some stuff CR of which is
likely to be a bad idea. E.g. registered dmabuf's,
pre-registered DMA mappings, zerocopy contexts and so on.

IOW, if the first point is solved, there may be a subset of ring
setups that can probably be CR. That should cover a good amount
of cases. I don't have a strong opinion on the whole thing,
I guess it depends on the amount of problems to implement
in-flight cancellations.

-- 
Pavel Begunkov
