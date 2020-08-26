Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6B925375A
	for <lists+io-uring@lfdr.de>; Wed, 26 Aug 2020 20:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgHZSjZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Aug 2020 14:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgHZSjY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Aug 2020 14:39:24 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539F1C061574
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 11:39:24 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id kx11so1261078pjb.5
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 11:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=XRZ08mqaA1trXAX5OPK/y6iaeuYuufA1Jd6B8CaPQ+k=;
        b=cjmXZKySG4MyYZ0qnLkMHD4BjnP06M2vDKL0emTQkqwGLZKrsd/3V5ZRFTepjrT6EE
         N0rpdOeeUKI1GvRP+XMv9PbWY6BWfolnTIMCKwBUmXBHiBFwkD1cFmJ+NkcfwgoNfNXe
         DIENROgc8GDdMPAaUenRxRt8BQ/69hjQc3C2iZU1qMDqninmPXK+y9rfTAqvkg+BRmBC
         u/9m6I8KgkHo0qFPQNfCiPZLxs6/yG6nzg4Kq28cg/gJFVp2kpktgTIh/xk+A53k7VNf
         0LEfpge1+RqnWUJhOhWJJK0VnR9YuxicdBLaRvboR2YyfdsiVu03aaTt6xLv/lj1T15E
         fYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=XRZ08mqaA1trXAX5OPK/y6iaeuYuufA1Jd6B8CaPQ+k=;
        b=WZ8HAkeX7NdTW6+FtBqHXdcGzKr9b1ZseBPHBtfmI66qVnXmgdlzjfbLSSicl1Y63i
         gagqimHJtDy4trc5lDpUU/x+oyseVTjUzU7/FphULCnyIdixHU1XE3I/+2TNeGVbhtDz
         E0FTZUYla+0pJCKwXFAp67++byRDGLExmcCNkFDnPAmvy0LnI9I9CHNAj+OrmHxAWnXf
         XA1vz+V9QkgAjVvRoeoimYoy0b688+B6hX5S8nEvDZrBX4PU/rVYvZZmrRf0eukSA896
         6ia2A3D1paGiMN/OvCC1qCwfDaSHswJvMBw6oKvf6lYR1BpjCycLLcVKmopTnbEHqsYO
         8JVQ==
X-Gm-Message-State: AOAM531+K+ut0HslJ37G/aBGyjgJ2haN92dLfni1MfC6IrHt7+babh+Z
        TbnGE7ktiFsKGsVsyqJdJTg3Dg==
X-Google-Smtp-Source: ABdhPJwT0AwovtRGjE68IVxonYsvHhrTb/hUXUH7yFJZnA8gXN/N8Q/RqAMwJ8wfJgQ2P8bCWqCDaw==
X-Received: by 2002:a17:90b:3641:: with SMTP id nh1mr7076324pjb.157.1598467163664;
        Wed, 26 Aug 2020 11:39:23 -0700 (PDT)
Received: from localhost.localdomain ([2600:380:6c53:6b25:d996:188:9b44:7529])
        by smtp.gmail.com with ESMTPSA id t19sm3851444pfq.179.2020.08.26.11.39.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 11:39:22 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Jens Axboe <axboe@kernel.dk>
Mime-Version: 1.0 (1.0)
Subject: Re: io_uring file descriptor address already in use error
Date:   Wed, 26 Aug 2020 12:39:21 -0600
Message-Id: <27657840-4E8E-422D-93BB-7F485F21341A@kernel.dk>
References: <CAAss7+r17LPZwun2ex4puSS_gkZz42p9s0Ta57yyD6XKV814oQ@mail.gmail.com>
Cc:     io-uring@vger.kernel.org, norman@apache.org
In-Reply-To: <CAAss7+r17LPZwun2ex4puSS_gkZz42p9s0Ta57yyD6XKV814oQ@mail.gmail.com>
To:     Josef <josef.grieb@gmail.com>
X-Mailer: iPhone Mail (18A5351d)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On Aug 26, 2020, at 12:26 PM, Josef <josef.grieb@gmail.com> wrote:
>=20
> =EF=BB=BFOn Wed, 26 Aug 2020 at 15:44, Jens Axboe <axboe@kernel.dk> wrote:=

>>=20
>> On 8/25/20 9:01 PM, Josef wrote:
>>>> In order for the patch to be able to move ahead, we'd need to be able
>>>> to control this behavior. Right now we rely on the file being there if
>>>> we need to repoll, see:
>>>>=20
>>>> commit a6ba632d2c249a4390289727c07b8b55eb02a41d
>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>> Date:   Fri Apr 3 11:10:14 2020 -0600
>>>>=20
>>>>    io_uring: retry poll if we got woken with non-matching mask
>>>>=20
>>>> If this never happened, we would not need the file at all and we could
>>>> make it the default behavior. But don't think that's solvable.
>>>>=20
>>>>> is there no other way around to close the file descriptor? Even if I
>>>>> remove the poll, it doesn't work
>>>>=20
>>>> If you remove the poll it should definitely work, as nobody is holding a=

>>>> reference to it as you have nothing else in flight. Can you clarify wha=
t
>>>> you mean here?
>>>>=20
>>>> I don't think there's another way, outside of having a poll (io_uring
>>>> or poll(2), doesn't matter, the behavior is the same) being triggered i=
n
>>>> error. That doesn't happen, as mentioned if you do epoll/poll on a file=

>>>> and you close it, it won't trigger an event.
>>>>=20
>>>>> btw if understood correctly poll remove operation refers to all file
>>>>> descriptors which arming a poll in the ring buffer right?
>>>>> Is there a way to cancel a specific file descriptor poll?
>>>>=20
>>>> You can cancel specific requests by identifying them with their
>>>> ->user_data. You can cancel a poll either with POLL_REMOVE or
>>>> ASYNC_CANCEL, either one will find it. So as long as you have that, and=

>>>> it's unique, it'll only cancel that one specific request.
>>>=20
>>> thanks it works, my bad, I was not aware that user_data is associated
>>> with the poll request user_data...just need to remove my server socket
>>> poll which binds to an address so I think this patch is not really
>>> necessary
>>>=20
>>> btw IORING_FEAT_FAST_POLL feature which arming poll for read events,
>>> how does it work when the file descriptor(not readable yet) wants to
>>> read(non blocking) something and I close(2) the file descriptor? I'm
>>> guessing io_uring doesn't hold any reference to it anymore right?
>>=20
>> Most file types will *not* notify you through poll if they get closed,
>> so it'll just sit there until canceled. This is the same with poll(2) or
>> epoll(2). io_uring will continue to hold a reference to the file, it
>> does that over request completion for any request that uses a file.
>=20
>=20
> okay, btw according to the man page IORING_OP_POLL_REMOVE it's unclear
> to me what value user_data contains in the cqe
> I'm guessing user_data is always 0 right? just tested it with liburing
> I got always 0(user_data) even if there is no polling request

The user_data is *always* passed straight from the sqe, so it is set to what=
ever you put in there. That=E2=80=99s a key component of the protocol, allow=
ing you to tie a completion event back to your submission. And also allows y=
ou to do a directed cancel event for a given pending request.=20

