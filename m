Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF5B3E8807
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 04:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhHKCd7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 22:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbhHKCdz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 22:33:55 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B07C061765;
        Tue, 10 Aug 2021 19:33:33 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id oa17so1115555pjb.1;
        Tue, 10 Aug 2021 19:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=s24fzyQ4FJbikEBM8s45g+D56igUWfa9JClS4iJGsHE=;
        b=FMDs7XJvjhq2sYpVsw/05AD+vy8QFSfUSmuAggboSWy9qbLptqzeSIC8MsnC+Ykaw6
         xi2OlFyDIyq2eV9ZD/VWPiawnTUFWD/E7c/Hdnoww6iI31gP74BGHDbsXNeWsqNswCDp
         ucyybQTgjwHGiMCYm375ogXG9DM2JKzC+WXGascno0Urye06rw+MWrLKpkKfAxCr5NB7
         OPllQa4lKT5uVlYNafCF/IViBuY0KyDdDoMyG1pWM2e8rFmOmpuh4XTHuxo+9kTqgPzO
         qtXsSm3NbFHW1UvOyIgPNkc0A9Z+pZUw4wgMojr2ZdQhAvJDttKSm9FyBA5kKMMgNEFi
         pakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=s24fzyQ4FJbikEBM8s45g+D56igUWfa9JClS4iJGsHE=;
        b=laUYoXFAiCuIh+APm+Wo6cdkagzCd8lRO+MqcRYT+7Uud0U6jxKq3mfuJl8085Nioa
         pcB9PCAYn434UURZau6NIZ40W/AFyESUNka0nE3IzUf3B+SOzsqqWYzKP/y1dfmSPkiS
         ZtqwFlgeGCfdNie/kTLNx+QfxIgU1q0fACz27orVrdLDhjZz89O9TodgcJRTGvzDIKfb
         8w1s3ta0Px1APLH141cSETxBeM1CDDZuIbRhD++pklLxa082GOvOekr69iRSkeEs+ojN
         S3WSs1dWP8eiPUPWt+9k1ZTVQwkorC6uhZrVxydnwez42YlroI9pJprHNyinMpgGgLKJ
         dxcg==
X-Gm-Message-State: AOAM530LWjrwEkifg1x6jEY/oYJEG7hA7a1/hz7dFdGsUFY1NVT46Gpr
        6zQ4TbLvvSVZXajDNM7ZVSE=
X-Google-Smtp-Source: ABdhPJx90m4uEbdPnwRdO1lsgwv+KMKqHhDYoPC+NN2umPIBnP30JAQq2aNN8AGefqgzqHTltpYvjA==
X-Received: by 2002:a65:644e:: with SMTP id s14mr99294pgv.410.1628649212059;
        Tue, 10 Aug 2021 19:33:32 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id y62sm785144pfg.88.2021.08.10.19.33.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Aug 2021 19:33:31 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <bbd25a42-eac0-a8f9-0e54-3c8c8e9894fd@gmail.com>
Date:   Tue, 10 Aug 2021 19:33:28 -0700
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FD8FD9BD-1E94-4A84-88EB-3A1531BCF556@gmail.com>
References: <20210808001342.964634-1-namit@vmware.com>
 <20210808001342.964634-2-namit@vmware.com>
 <fdd54421f4d4e825152192e327c838d035352945.camel@trillion01.com>
 <A4DC14BA-74CA-41DB-BE08-D7B693C11AE0@gmail.com>
 <bbd25a42-eac0-a8f9-0e54-3c8c8e9894fd@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



> On Aug 10, 2021, at 2:32 PM, Pavel Begunkov <asml.silence@gmail.com> =
wrote:
>=20
> On 8/10/21 9:28 AM, Nadav Amit wrote:
>>=20
>> Unfortunately, there seems to be yet another issue (unless my code
>> somehow caused it). It seems that when SQPOLL is used, there are =
cases
>> in which we get stuck in io_uring_cancel_sqpoll() when =
tctx_inflight()
>> never goes down to zero.
>>=20
>> Debugging... (while also trying to make some progress with my code)
>=20
> It's most likely because a request has been lost (mis-refcounted).
> Let us know if you need any help. Would be great to solve it for 5.14.
> quick tips:=20
>=20
> 1) if not already, try out Jens' 5.14 branch
> git://git.kernel.dk/linux-block io_uring-5.14
>=20
> 2) try to characterise the io_uring use pattern. Poll requests?
> Read/write requests? Send/recv? Filesystem vs bdev vs sockets?
>=20
> If easily reproducible, you can match io_alloc_req() with it
> getting into io_dismantle_req();

So actually the problem is more of a missing IO-uring functionality that =
I need. When an I/O is queued for async completion (i.e., after =
returning -EIOCBQUEUED), there should be a way for io-uring to cancel =
these I/Os if needed. Otherwise they might potentially never complete, =
as happens in my use-case.

AIO has ki_cancel() for this matter. So I presume the proper solution =
would be to move ki_cancel() from aio_kiocb to kiocb so it can be used =
by both io-uring and aio. And then - to use this infrastructure.

But it is messy. There is already a bug in the (few) uses of =
kiocb_set_cancel_fn() that blindly assume AIO is used and not IO-uring. =
Then, I am not sure about some things in the AIO code. Oh boy. I=E2=80=99l=
l work on an RFC.

