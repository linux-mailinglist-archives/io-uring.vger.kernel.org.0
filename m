Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E682DF0B2
	for <lists+io-uring@lfdr.de>; Sat, 19 Dec 2020 18:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgLSRfE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 12:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgLSRfE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 12:35:04 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E8DC0613CF
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 09:34:24 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g24so5604359edw.9
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 09:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=shUmj5zgRVy6+hOA2E6+OmiDd1gsiM7ehjUkpW8qFKY=;
        b=Gkm2C4FI4fst7Loi/gYYiqsDDCUAUvJ0Qjk6HEWRPLE0dLWBPWuuE8kwZwrnuVf+vI
         RtCnejfQyDjzQVml0RJdpjrjP9vudzQX1fZS3QDFX7okUQ4w80l1REgI0HG5uvnS5lF7
         DiQz1o7BbD+WaLGFBM5bJ1spnET68YeXDsxLxV3yWLap/Ebn4QN6MQ4vnBHy9OafN179
         t2QgLgAALUncbwyf8xaOAMYQWDVfnf3witLIl99eXOm4Mo5sCNjvJwC40PR943lwBF6j
         TC4VGkz7JLjuPQfYsftKCI37nqCAqlZ6Uc5sfwmfHgUCr7FgC/tbu4G+HWGctvQL9emY
         cEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=shUmj5zgRVy6+hOA2E6+OmiDd1gsiM7ehjUkpW8qFKY=;
        b=kdlZpObuWOXEqPSL1JPJZMFAnGLwKce9NQEyoyIRYSASwfgTvUeBNWawtDXQIarqjm
         19bAdct/RLlrz9PN67EOi+IjHDrhn1ch+SAbarXZkgQuNUVB2Mq9lcPXY6NXjCCq4kL+
         Xz9wOy9piuH4hD16/wFtO59T0nYvKwPu5eoTfeZmfgfYrPztT6cxGUo3D/KRc9ZIzgH7
         0uFYcM9i2QgubER72jP2xKvCvDFzqKA9+L4ugsuXq+jrv/f6s2007RroDUg12MsaapDw
         /RYwR3LZ6M5n+9a+Jy3cPpbZSlHQNEiFAFv2gHbUf74pbhniWTkig+xJrS10xzPX1uHl
         i3rw==
X-Gm-Message-State: AOAM530UkyAA4xZvGsa0bm4uh13XAZhrK8Xb4ajik//gKDVUfiZYAF+b
        1KXX/eauQtOTHWsSmIdwKWkzbbfBO4ZoDw==
X-Google-Smtp-Source: ABdhPJw8qkoaka6hVXDBjm6ohaLbM2zC70k0syKrMIskXtqqoIc5hXny2PjeCQ28O61ZlDmNJKWStQ==
X-Received: by 2002:a50:9991:: with SMTP id m17mr9616142edb.48.1608399262372;
        Sat, 19 Dec 2020 09:34:22 -0800 (PST)
Received: from [192.168.86.157] (ip-95-222-154-235.hsi15.unitymediagroup.de. [95.222.154.235])
        by smtp.gmail.com with ESMTPSA id n8sm7028162eju.33.2020.12.19.09.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 09:34:21 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Norman Maurer <norman.maurer@googlemail.com>
Mime-Version: 1.0 (1.0)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
Date:   Sat, 19 Dec 2020 18:34:20 +0100
Message-Id: <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com>
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
Cc:     Josef <josef.grieb@gmail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
In-Reply-To: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: iPhone Mail (18C66)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Thanks a lot ... we can just workaround this than in netty .

Bye
Norman=20


> Am 19.12.2020 um 18:11 schrieb Jens Axboe <axboe@kernel.dk>:
>=20
> =EF=BB=BFOn 12/19/20 9:29 AM, Jens Axboe wrote:
>>> On 12/19/20 9:13 AM, Jens Axboe wrote:
>>> On 12/18/20 7:49 PM, Josef wrote:
>>>>> I'm happy to run _any_ reproducer, so please do let us know if you
>>>>> manage to find something that I can run with netty. As long as it
>>>>> includes instructions for exactly how to run it :-)
>>>>=20
>>>> cool :)  I just created a repo for that:
>>>> https://github.com/1Jo1/netty-io_uring-kernel-debugging.git
>>>>=20
>>>> - install jdk 1.8
>>>> - to run netty: ./mvnw compile exec:java
>>>> -Dexec.mainClass=3D"uring.netty.example.EchoUringServer"
>>>> - to run the echo test: cargo run --release -- --address
>>>> "127.0.0.1:2022" --number 200 --duration 20 --length 300
>>>> (https://github.com/haraldh/rust_echo_bench.git)
>>>> - process kill -9
>>>>=20
>>>> async flag is enabled and these operation are used: OP_READ,
>>>> OP_WRITE, OP_POLL_ADD, OP_CLOSE, OP_ACCEPT
>>>>=20
>>>> (btw you can change the port in EchoUringServer.java)
>>>=20
>>> This is great! Not sure this is the same issue, but what I see here is
>>> that we have leftover workers when the test is killed. This means the
>>> rings aren't gone, and the memory isn't freed (and unaccounted), which
>>> would ultimately lead to problems of course, similar to just an
>>> accounting bug or race.
>>>=20
>>> The above _seems_ to be related to IOSQE_ASYNC. Trying to narrow it
>>> down...
>>=20
>> Further narrowed down, it seems to be related to IOSQE_ASYNC on the
>> read requests. I'm guessing there are cases where we end up not
>> canceling them on ring close, hence the ring stays active, etc.
>>=20
>> If I just add a hack to clear IOSQE_ASYNC on IORING_OP_READ, then
>> the test terminates fine on the kill -9.
>=20
> And even more so, it's IOSQE_ASYNC on the IORING_OP_READ on an eventfd
> file descriptor. You probably don't want/mean to do that as it's
> pollable, I guess it's done because you just set it on all reads for the
> test?
>=20
> In any case, it should of course work. This is the leftover trace when
> we should be exiting, but an io-wq worker is still trying to get data
> from the eventfd:
>=20
> $ sudo cat /proc/2148/stack
> [<0>] eventfd_read+0x160/0x260
> [<0>] io_iter_do_read+0x1b/0x40
> [<0>] io_read+0xa5/0x320
> [<0>] io_issue_sqe+0x23c/0xe80
> [<0>] io_wq_submit_work+0x6e/0x1a0
> [<0>] io_worker_handle_work+0x13d/0x4e0
> [<0>] io_wqe_worker+0x2aa/0x360
> [<0>] kthread+0x130/0x160
> [<0>] ret_from_fork+0x1f/0x30
>=20
> which will never finish at this point, it should have been canceled.
>=20
> --=20
> Jens Axboe
>=20
