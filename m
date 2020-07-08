Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BD4218C86
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 18:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgGHQIQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 12:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730234AbgGHQIQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 12:08:16 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B46C08C5DC
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 09:08:16 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lx13so32488806ejb.4
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 09:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=HqpBY7r7cMmdxSomsxil1bu4vGv+J4OJWZNNfUv/dZM=;
        b=TsT/rSU0rnR5xGbl/M/14iPag3TvmnldihTNk7Rpc2tIBuwM43sdJZ88gwylItA8dw
         /LLoBTgoMlE+BsqiKmvh+AI0PumbsszW+VZ9ulB7aPx6Psu5d6WMhG5N6pxxZ6ovCTnH
         gjoyIJ437nkHN8N2u6yxBGsHzFdWPsMRNJek0HPE07ZtzHWYEDKQmYO3OGVavyM/QT7d
         C72+HVsc59mvH5AOpq1JAH0Gi5IQ64VxOEze5O8GWkXkrohOcVXhZ0WJb7X7OFcOzK+b
         XyuDNiMz+T1LPbEw2AltMBvRMQBrMRfg5deI9GOpksLfLBTdwXZ5ZF6Wtneai1XkZVuA
         CPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=HqpBY7r7cMmdxSomsxil1bu4vGv+J4OJWZNNfUv/dZM=;
        b=E8VGOqJMlcQioTS2IjlXu9sazqyWiAiQ/DKSV+wA/eRuANH2qDie1LeEO2aOctDYjb
         YbLwAW+hvQcD+NP5487gqYvLvnB63pdFxvQfNBUXPxwfVjuFCgo4qulW9v/NHVP4BFts
         bywDlFDbX7l4dWdEGzPhb8K+e5UgdXsbXr1PCDOnkQJXuKbREz14vAd6vXyNNowkgwf+
         Ys3HJ+FpJC/6Z0+krU4FkWSZDiQqG7uOB4KwAz0XA4HDr/qUXoO3Wsf5bAisF9yDvuRz
         TtNm1+pJKm2lGWKtwMrz2YchbGg1WHtVZiA88KEhyVJWugcuAwnysYV94a8jtgVwbWyP
         J+gw==
X-Gm-Message-State: AOAM533e7iPuIq3gpEfqmrWbVNJ9kDwQYGxKcOKuD8wI1BA4wqbb9Dut
        pBLrRLViLcWB7cNx/jBkmDbeUg==
X-Google-Smtp-Source: ABdhPJzFmbEoWRJtTJrtEq1GYcXtnsEsi025KjmbmGjkw8A5ckMUVYg/t+96wXuRw5d3teUIwmknUg==
X-Received: by 2002:a17:906:7855:: with SMTP id p21mr41176812ejm.492.1594224494867;
        Wed, 08 Jul 2020 09:08:14 -0700 (PDT)
Received: from [192.168.2.16] (5.186.127.235.cgn.fibianet.dk. [5.186.127.235])
        by smtp.gmail.com with ESMTPSA id b98sm8352edf.24.2020.07.08.09.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 09:08:13 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   =?utf-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Date:   Wed, 8 Jul 2020 18:08:12 +0200
Message-Id: <36C0AD99-0D75-40D4-B704-507A222AEB81@javigon.com>
References: <33b9887b-eaba-c7be-5dfd-fc7e7d416f48@kernel.dk>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, damien.lemoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
In-Reply-To: <33b9887b-eaba-c7be-5dfd-fc7e7d416f48@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: iPhone Mail (17F80)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> On 8 Jul 2020, at 17.06, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> =EF=BB=BFOn 7/8/20 9:02 AM, Matthew Wilcox wrote:
>>> On Wed, Jul 08, 2020 at 08:59:50AM -0600, Jens Axboe wrote:
>>> On 7/8/20 8:58 AM, Matthew Wilcox wrote:
>>>> On Wed, Jul 08, 2020 at 08:54:07AM -0600, Jens Axboe wrote:
>>>>> On 7/8/20 6:58 AM, Kanchan Joshi wrote:
>>>>>>>> +#define IOCB_NO_CMPL        (15 << 28)
>>>>>>>>=20
>>>>>>>> struct kiocb {
>>>>>>>> [...]
>>>>>>>> -    void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
>>>>>>>> +    loff_t __user *ki_uposp;
>>>>>>>> -    int            ki_flags;
>>>>>>>> +    unsigned int        ki_flags;
>>>>>>>>=20
>>>>>>>> +typedef void ki_cmpl(struct kiocb *, long ret, long ret2);
>>>>>>>> +static ki_cmpl * const ki_cmpls[15];
>>>>>>>>=20
>>>>>>>> +void ki_complete(struct kiocb *iocb, long ret, long ret2)
>>>>>>>> +{
>>>>>>>> +    unsigned int id =3D iocb->ki_flags >> 28;
>>>>>>>> +
>>>>>>>> +    if (id < 15)
>>>>>>>> +        ki_cmpls[id](iocb, ret, ret2);
>>>>>>>> +}
>>>>>>>>=20
>>>>>>>> +int kiocb_cmpl_register(void (*cb)(struct kiocb *, long, long))
>>>>>>>> +{
>>>>>>>> +    for (i =3D 0; i < 15; i++) {
>>>>>>>> +        if (ki_cmpls[id])
>>>>>>>> +            continue;
>>>>>>>> +        ki_cmpls[id] =3D cb;
>>>>>>>> +        return id;
>>>>>>>> +    }
>>>>>>>> +    WARN();
>>>>>>>> +    return -1;
>>>>>>>> +}
>>>>>>>=20
>>>>>>> That could work, we don't really have a lot of different completion
>>>>>>> types in the kernel.
>>>>>>=20
>>>>>> Thanks, this looks sorted.
>>>>>=20
>>>>> Not really, someone still needs to do that work. I took a quick look, a=
nd
>>>>> most of it looks straight forward. The only potential complication is
>>>>> ocfs2, which does a swap of the completion for the kiocb. That would j=
ust
>>>>> turn into an upper flag swap. And potential sync kiocb with NULL
>>>>> ki_complete. The latter should be fine, I think we just need to reserv=
e
>>>>> completion nr 0 for being that.
>>>>=20
>>>> I was reserving completion 15 for that ;-)
>>>>=20
>>>> +#define IOCB_NO_CMPL        (15 << 28)
>>>> ...
>>>> +    if (id < 15)
>>>> +        ki_cmpls[id](iocb, ret, ret2);
>>>>=20
>>>> Saves us one pointer in the array ...
>>>=20
>>> That works. Are you going to turn this into an actual series of patches,=

>>> adding the functionality and converting users?
>>=20
>> I was under the impression Kanchan was going to do that, but I can run it=

>> off quickly ...
>=20
> I just wanted to get clarification there, because to me it sounded like
> you expected Kanchan to do it, and Kanchan assuming it "was sorted". I'd
> consider that a prerequisite for the append series as far as io_uring is
> concerned, hence _someone_ needs to actually do it ;-)
>=20

I believe Kanchan meant that now the trade-off we were asking to clear out i=
s sorted.=20

We will send a new version shortly for the current functionality - we can se=
e what we are missing on when the uring interface is clear.=20

We really want this to be stable as a lot of other things are depending on t=
his (e.g., fio patches)

Javier=
