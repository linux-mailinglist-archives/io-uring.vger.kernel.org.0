Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBF22ECBD3
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 09:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbhAGIlF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 03:41:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49530 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726420AbhAGIlF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 03:41:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610008778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b/gjdBCSmSXKkH6UZrD67rlhCNa+Qh7NKibomcVRCXg=;
        b=GFScFeuiP0gYrwf89SQxpVvkN7S/XrYZeWaNuctCUhlzZJ+/mXobrRkvBx8ZLGeJ2LjUE1
        o8NCxu2SxB0siULJjJcvRpLvPqKmFDekYvvR/aQ7TGghoMG8YJwSnRG3gmgmKXTU4/xWiP
        SHXjJp5FcjJdGbwU/KVjm0uk6kOUJ0Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-Lyw5nquoOomh0xkNetIuZQ-1; Thu, 07 Jan 2021 03:39:37 -0500
X-MC-Unique: Lyw5nquoOomh0xkNetIuZQ-1
Received: by mail-wr1-f69.google.com with SMTP id r8so2327875wro.22
        for <io-uring@vger.kernel.org>; Thu, 07 Jan 2021 00:39:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b/gjdBCSmSXKkH6UZrD67rlhCNa+Qh7NKibomcVRCXg=;
        b=QVaKexbvgCqaGsdukJK4NgbrgNWNC6SpykPA1I0j0lo2Wt/9kqsTBU4SkolWWEm8gW
         ERskNQphT75uR87P/G5Vv5Grr3ReTEx/X8ru4bH07FPVuJbfJrQtnnuye+AUs77zQ7jS
         tajJNdQmEPnyTQ44HGo6wi2gDXbPB0i1DDt5wZk60OGaQVsRSd9JPBIK9AAmbps0vQaq
         WltTvG0MjUMDpE7tO9I0XOuHWq1a/QvT56OirrDMhHUnijJyf8pTsuWi14DW2XE53lhX
         cbsoa4qMLjoOG5tv829ZFW+Ck6+phyhGHhb3qf8Dqz6QIKWca+tNiaq8aaEd+tYO8jj3
         o5mg==
X-Gm-Message-State: AOAM530ACKX/KErXvjXYMtojaNovYIH2pPDEDjSDm2mq4XaCRyyNcCSx
        M/hITstvkVsBYzo6dc+P/3Dfoh41S4zeqienrdmmHNdfP0YPB/Jtpcqf+u8gOlk36CShmRHx0bm
        hZq3hHq9jwmVO2DcQHOo=
X-Received: by 2002:a5d:554e:: with SMTP id g14mr7962487wrw.264.1610008775833;
        Thu, 07 Jan 2021 00:39:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7UTbth5UPeghaUf4Y/9GWuz3fDS27vvZLBin1zacQw3Tp5n2al3IsoTK+x69AxDSZwlgDNg==
X-Received: by 2002:a5d:554e:: with SMTP id g14mr7962459wrw.264.1610008775620;
        Thu, 07 Jan 2021 00:39:35 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id h83sm6923737wmf.9.2021.01.07.00.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 00:39:34 -0800 (PST)
Date:   Thu, 7 Jan 2021 09:39:32 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Daurnimator <quae@daurnimator.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        Aleksa Sarai <asarai@suse.de>,
        Sargun Dhillon <sargun@sargun.me>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v6 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Message-ID: <20210107083932.ho6vo5g5hmdohwqt@steredhat>
References: <20200827145831.95189-1-sgarzare@redhat.com>
 <20200827145831.95189-3-sgarzare@redhat.com>
 <CAEnbY+fS8FXVeouOxN3uohTvo7fBi5r7TQCGBZUmG3MGJhBrYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEnbY+fS8FXVeouOxN3uohTvo7fBi5r7TQCGBZUmG3MGJhBrYg@mail.gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 04, 2021 at 01:26:41AM +1100, Daurnimator wrote:
>On Fri, 28 Aug 2020 at 00:59, Stefano Garzarella <sgarzare@redhat.com> wrote:
>> +               __u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
>
>Can you confirm that this intentionally limited the future range of
>IORING_REGISTER opcodes to 0-255?
>

It was based on io_uring_probe, so we used u8 for opcodes, but we have 
room to extend it in the future.

So, for now, this allow to register restrictions up to 255 
IORING_REGISTER opcode.

