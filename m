Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FAE3E89D8
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 07:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhHKFlx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 01:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbhHKFlr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 01:41:47 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F92C061765;
        Tue, 10 Aug 2021 22:41:01 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a8so1638049pjk.4;
        Tue, 10 Aug 2021 22:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PDAPRfbqp4fZ98UOjrZjCjbxbDFL6OvNQRqjjMYSxcw=;
        b=gXLhznkg1MxvrIQH7DIRn1pqa7BxmUfyes/6MFhc3ym+nOtRiv9Q7QA6ozHrI1yJaJ
         5FNddLeUwCb1HnfmpRQjzNncZT/h9RuKlIDe1k6bmsZpAxPpv4W52l9VPepArBUOi9Xx
         OB/yHhXpaKsCp7qMYK0DMtqZzkF9jok2IBh9xXvkodOkOw9lH69R70gwaQCb04Os/Gjp
         nLmTgxgQyoHvb2lXSvBTODAsPobQrSvpyNjpRjD3Lud7tV1OHi/KBTPoBINPi+9gy1Ud
         32NYc03yVofpX6Evq4Nvw/LToXxFpcI9alx7h1WVlfd897K9rsmUxDQp+4GrHefb3hVz
         VqJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PDAPRfbqp4fZ98UOjrZjCjbxbDFL6OvNQRqjjMYSxcw=;
        b=ldsmtPKUU7o5CcMRg7trpahFVK5IdIeO4mOy/RlGRlfEYU0nF3F1bAQA7jww6jG1e0
         jKCtEtZB/0aProjAEP+ynY7lJZ09t82WUXcWLVxYKuOrtLrJ/WVt4n7lUzk8JMLmlNs/
         TMpgkYx1NnOFGBTRvNdzZeHL/bc0b0jbKbH4GREp7fM9MhDj9MQL+AWVMKUXrB9wvmFz
         Zk4TRtMW44VEhendOeRx9TWmFwHQWLZ5AO6ynjd10U6+cRgqwnT5DcljOK3Dl+5wQYK9
         p5qif5qJyktbjpHJ3skL4vRp0UF+/WoqyhnbpBW1FmkKVZ3D/VqAIJsJ70Ehzgmc/bD8
         BkGQ==
X-Gm-Message-State: AOAM532fiN0ABMWoony73jovjGD5uq1ihQOdZOmuhmT8jT+3uyV3T5OQ
        B11Z5HgNObw+OCt7jWjlvlI=
X-Google-Smtp-Source: ABdhPJyIYCLHlhXE0eYEnV0QrziIHArVxeEgRjQZ79sa8FUAsW/VGtw/K9Tgkz34UlZlFaRtJ1x6mA==
X-Received: by 2002:a17:902:7001:b029:12c:4e36:52c5 with SMTP id y1-20020a1709027001b029012c4e3652c5mr2840928plk.9.1628660461178;
        Tue, 10 Aug 2021 22:41:01 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id q12sm4236344pjd.18.2021.08.10.22.40.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Aug 2021 22:41:00 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: I/O cancellation in io-uring (was: io_uring: clear TIF_NOTIFY_SIGNAL
 ...) 
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <1bf56100-e904-65b5-bbb8-fa313d85b01a@kernel.dk>
Date:   Tue, 10 Aug 2021 22:40:58 -0700
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <29430B77-37C2-4E65-B279-2590CF825FB3@gmail.com>
References: <20210808001342.964634-1-namit@vmware.com>
 <20210808001342.964634-2-namit@vmware.com>
 <fdd54421f4d4e825152192e327c838d035352945.camel@trillion01.com>
 <A4DC14BA-74CA-41DB-BE08-D7B693C11AE0@gmail.com>
 <bbd25a42-eac0-a8f9-0e54-3c8c8e9894fd@gmail.com>
 <FD8FD9BD-1E94-4A84-88EB-3A1531BCF556@gmail.com>
 <1bf56100-e904-65b5-bbb8-fa313d85b01a@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> On Aug 10, 2021, at 7:51 PM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> There's no way to cancel file/bdev related IO, and there likely never
> will be. That's basically the only exception, everything else can get
> canceled pretty easily. Many things can be written on why that is the
> case, and they have (myself included), but it boils down to proper
> hardware support which we'll likely never have as it's not a well =
tested
> path. For other kind of async IO, we're either waiting in poll (which =
is
> trivially cancellable) or in an async thread (which is also easily
> cancellable). For DMA+irq driven block storage, we'd need to be able =
to
> reliably cancel on the hardware side, to prevent errant DMA after the
> fact.
>=20
> None of this is really io_uring specific, io_uring just suffers from =
the
> same limitations as others would (or are).
>=20
>> Otherwise they might potentially never complete, as happens in my
>> use-case.
>=20
> If you see that, that is most certainly a bug. While bdev/reg file IO
> can't really be canceled, they all have the property that they =
complete
> in finite time. Either the IO completes normally in a "short" amount =
of
> time, or a timeout will cancel it and complete it in error. There are =
no
> unbounded execution times for uncancellable IO.

I understand your point that hardware reads/writes cannot easily be =
cancelled.
(well, the buffers can be unmapped from the IOMMU tables, but let's put =
this
discussion aside).

Yet the question is whether reads/writes from special files such as =
pipes,
eventfd, signalfd, fuse should be cancellable. Obviously, it is always
possible to issue a blocking read/write from a worker thread. Yet, there =
are
inherent overheads that are associated with this design, specifically
context-switches. While the overhead of a context-switch is not as high =
as
portrayed by some, it is still high for low latency use-cases.

There is a potential alternative, however. When a write to a pipe is
performed, or when an event takes place or signal sent, queued io-uring =
reads
can be fulfilled immediately, without a context-switch to a worker. I
specifically want to fulfill userfaultfd reads and notify userspace on
page-faults in such manner. I do not have the numbers in front of me, =
but
doing so shows considerable performance improvement.

To allow such use-cases, cancellation of the read/write is needed. A =
read from
a pipe might never complete if there is no further writes to the pipe.
Cancellation is not hard to implement for such cases (it's only the mess =
with
the existing AIO's ki_cancel() that bothers me, but as you said - it is =
a
single use-case).

Admittedly, there are no such use-cases in the kernel today, but =
arguably,
this is due to the lack of infrastructure. I see no alternative which is =
as
performant as the one I propose here. Using poll+read or any other =
option
will have unwarranted overhead. =20

If an RFC might convince you, or some more mainstream use-case such as =
queued
pipe reads would convince you, I can work on such in order to try to get
something like that.

