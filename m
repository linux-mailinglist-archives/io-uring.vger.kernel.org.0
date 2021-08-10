Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDC93E5528
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 10:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237640AbhHJI21 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 04:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237236AbhHJI20 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 04:28:26 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F63C0613D3;
        Tue, 10 Aug 2021 01:28:05 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id a5so4278083plh.5;
        Tue, 10 Aug 2021 01:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=HSJnHTb+KtNoZOu+K6uvBKzNTHh865MwVRa5OZlz+SI=;
        b=ZpkIsEKzP762UvIzvFogLouIJggyiA+RmOPIC3HcxU+YuL/b8ytCX9EzQFik1ULum4
         frdBgfN9G7Z27bVbv62Ho2+evnVLu0WnZ8nCD5EKG7YKmMScB/lf+PCbXlhOi/qfqY9O
         KN1jEdR0RQO374w7PWLaIx7ti1GsXcjGHTMrysuTT4aI5rWktGlis7K0R9WafFzXqZ34
         AJaqwvTWFjdGpxC+bxEWJ1Y+/cHokXqtdhDzOAV5NjV7BodMnaW/FAC95pg3li7hDVnl
         jvyLnA5qtTJSl3AActcIq2hjxMygyVFPLK3Lcn36t4I6w3ASYmuSCghzqPfSwBzULUw6
         TTug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=HSJnHTb+KtNoZOu+K6uvBKzNTHh865MwVRa5OZlz+SI=;
        b=W5k3RFyiq2+t7FalzciX6WPWMnM4ux3MDkfn2kzi/XTECAddoN2mCADSXtTNaTCPMK
         wdf1Pmpply8cHTngbVI2X4VacWR+YWjBMwmapwhr3Dh8tr1agstb6eTcjGRG5ZVfvc4/
         rltnBrJzOKn5MPZlZrYd7NoH4WBPIDhdxsL7Apo3zNU+G1uZ5LCwgoR3fQ+30dbXHf1v
         a7WxHDttxksOjJojnQlx3HTJ8jLEeYb1o1tt3TYKjXApOC0wAm91jLtSYBcU3fEPMhHz
         EM36y9k0znhgO9ycz4cX9pYG7t6XHw27kSn5n6tq6A9Lg7GlDrI4wyeK4ZzazcdK5dOp
         7S4w==
X-Gm-Message-State: AOAM530ooI/r9puhcOh5v/vGkpnyqd+IEfrgzQ7J/iCkzaU4guyS7JyM
        qEv9XP6e/mXoLiC7hXmG1r1rDs72rEbIyw==
X-Google-Smtp-Source: ABdhPJy0ybSZxC1IIck/rRE1GSqHiEd1SfjmrT7uy6nlv6STfldQbWMwbpSk38uvGAeTfio6T22dFw==
X-Received: by 2002:a17:902:ce8f:b029:12c:c4e7:682d with SMTP id f15-20020a170902ce8fb029012cc4e7682dmr24160105plg.58.1628584084422;
        Tue, 10 Aug 2021 01:28:04 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id i24sm23417732pfr.207.2021.08.10.01.28.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Aug 2021 01:28:03 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <fdd54421f4d4e825152192e327c838d035352945.camel@trillion01.com>
Date:   Tue, 10 Aug 2021 01:28:01 -0700
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A4DC14BA-74CA-41DB-BE08-D7B693C11AE0@gmail.com>
References: <20210808001342.964634-1-namit@vmware.com>
 <20210808001342.964634-2-namit@vmware.com>
 <fdd54421f4d4e825152192e327c838d035352945.camel@trillion01.com>
To:     Olivier Langlois <olivier@trillion01.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> On Aug 9, 2021, at 2:48 PM, Olivier Langlois <olivier@trillion01.com> =
wrote:
>=20
> On Sat, 2021-08-07 at 17:13 -0700, Nadav Amit wrote:
>> From: Nadav Amit <namit@vmware.com>
>>=20
>> When using SQPOLL, the submission queue polling thread calls
>> task_work_run() to run queued work. However, when work is added with
>> TWA_SIGNAL - as done by io_uring itself - the TIF_NOTIFY_SIGNAL =
remains
>> set afterwards and is never cleared.
>>=20
>> Consequently, when the submission queue polling thread checks whether
>> signal_pending(), it may always find a pending signal, if
>> task_work_add() was ever called before.
>>=20
>> The impact of this bug might be different on different kernel =
versions.
>> It appears that on 5.14 it would only cause unnecessary calculation =
and
>> prevent the polling thread from sleeping. On 5.13, where the bug was
>> found, it stops the polling thread from finding newly submitted work.
>>=20
>> Instead of task_work_run(), use tracehook_notify_signal() that clears
>> TIF_NOTIFY_SIGNAL. Test for TIF_NOTIFY_SIGNAL in addition to
>> current->task_works to avoid a race in which task_works is cleared =
but
>> the TIF_NOTIFY_SIGNAL is set.
>=20
> thx a lot for this patch!
>=20
> This explains what I am seeing here:
> =
https://lore.kernel.org/io-uring/4d93d0600e4a9590a48d320c5a7dd4c54d66f095.=
camel@trillion01.com/
>=20
> I was under the impression that task_work_run() was clearing
> TIF_NOTIFY_SIGNAL.
>=20
> your patch made me realize that it does not=E2=80=A6

Happy it could help.

Unfortunately, there seems to be yet another issue (unless my code
somehow caused it). It seems that when SQPOLL is used, there are cases
in which we get stuck in io_uring_cancel_sqpoll() when tctx_inflight()
never goes down to zero.

Debugging... (while also trying to make some progress with my code)=
