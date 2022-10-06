Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB805F6455
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 12:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiJFK03 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 06:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiJFK02 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 06:26:28 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F4E923CC;
        Thu,  6 Oct 2022 03:26:27 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id w191so1652443pfc.5;
        Thu, 06 Oct 2022 03:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=Dpy86RHsOIyY8RatM+wRIJiLlfwuHhPTmUB4qFPEGJk=;
        b=QyTJYnqNYvFxy+QOXNMXGWq5rkSrku5U4cGVmTMYztO94pjdDCtcniWrbsv3zVsVnA
         U7aPHSBXaSm+bS1jXS17QYABexfxn2vfK6RYxYy4DlugO+n6Sto76TArIGr5raIDr5aI
         PGMh+BveQvkSa6wGOrM8LU18VEdZcWWoWsdS3IozhgVpMe+5fHCSH6aWe2m033385AEZ
         VaraQ8XtmkD9max5LVhLT/zvqySD97JfN/9/yMQGCge26Qd4Eg3zsjrgvyS+GMaxzqSF
         a0WUx8Se//2ZG0xaHKWeNLhloxMVOCbe1KbvVRaMscJR0HIfkskOLXVihXPkdqUpbh0b
         6h4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Dpy86RHsOIyY8RatM+wRIJiLlfwuHhPTmUB4qFPEGJk=;
        b=Vfa5E60thYRW5F6XsiyvcCZYjcjMLycV8KOdygKmgnuiNk1vW0ap7Z5Tg5LWGBVF1i
         O/Sk/0M8Ta7TpTTSThUV7eynE/NAEv4WgReLbbiYtlJ0EeNsLVCtMMPY8Z9nC5QYGfFf
         yNTLlyB40dneg1TcHsC2cnKZua9j5vvId1Ed4W2AHI+e25eMrPfIy35rtqN/2uPZ1uff
         ezARWjU+s1fOd+5QCds3nVCb4fwmK7qHuLLi5gB3NL+aBAAa5yXiH8VowNmqKVQjcqIZ
         QjzjtwS939e1ciSwmHdB7NGa4PNySps9WevwJcI1Qiy08sFin2DD4BdxYs4A7sIe6HHk
         MDJw==
X-Gm-Message-State: ACrzQf1B0XLESxvGUkiKDTz9y5xgnSX3At5/dAxkrP43TihKNj/XOb9o
        Gq1syXCHxjMq2l4/A0tj6UXn5qqlm1AZyH5W
X-Google-Smtp-Source: AMsMyM60r7beaY8MBsKwg8FNKuPP0I9lUDdCdQls0RgHH1ZQtjQ3dyWhKvC9ux903RHdbZjhwBjDDQ==
X-Received: by 2002:a63:20f:0:b0:43c:1ef6:ebd6 with SMTP id 15-20020a63020f000000b0043c1ef6ebd6mr3906197pgc.217.1665051986555;
        Thu, 06 Oct 2022 03:26:26 -0700 (PDT)
Received: from T590 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i13-20020a170902cf0d00b001784a45511asm11977254plg.79.2022.10.06.03.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 03:26:25 -0700 (PDT)
Date:   Thu, 6 Oct 2022 18:26:15 +0800
From:   Ming Lei <tom.leiming@gmail.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "Denis V. Lunev" <den@virtuozzo.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        rjones@redhat.com, Xie Yongji <xieyongji@bytedance.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Message-ID: <Yz6tR24T8HPHJ70D@T590>
References: <Yza1u1KfKa7ycQm0@T590>
 <Yzs9xQlVuW41TuNC@fedora>
 <6659a0d5-60ab-9ac7-d25d-b4ff1940c6ab@virtuozzo.com>
 <Yz2epPwoufj0mug/@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yz2epPwoufj0mug/@fedora>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Oct 05, 2022 at 11:11:32AM -0400, Stefan Hajnoczi wrote:
> On Tue, Oct 04, 2022 at 01:57:50AM +0200, Denis V. Lunev wrote:
> > On 10/3/22 21:53, Stefan Hajnoczi wrote:
> > > On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > > ublk-qcow2 is available now.
> > > Cool, thanks for sharing!
> > yep
> > 
> > > > So far it provides basic read/write function, and compression and snapshot
> > > > aren't supported yet. The target/backend implementation is completely
> > > > based on io_uring, and share the same io_uring with ublk IO command
> > > > handler, just like what ublk-loop does.
> > > > 
> > > > Follows the main motivations of ublk-qcow2:
> > > > 
> > > > - building one complicated target from scratch helps libublksrv APIs/functions
> > > >    become mature/stable more quickly, since qcow2 is complicated and needs more
> > > >    requirement from libublksrv compared with other simple ones(loop, null)
> > > > 
> > > > - there are several attempts of implementing qcow2 driver in kernel, such as
> > > >    ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ublk-qcow2
> > > >    might useful be for covering requirement in this field
> > There is one important thing to keep in mind about all partly-userspace
> > implementations though:
> > * any single allocation happened in the context of the
> >    userspace daemon through try_to_free_pages() in
> >    kernel has a possibility to trigger the operation,
> >    which will require userspace daemon action, which
> >    is inside the kernel now.
> > * the probability of this is higher in the overcommitted
> >    environment
> > 
> > This was the main motivation of us in favor for the in-kernel
> > implementation.
> 
> CCed Josef Bacik because the Linux NBD driver has dealt with memory
> reclaim hangs in the past.
> 
> Josef: Any thoughts on userspace block drivers (whether NBD or ublk) and
> how to avoid hangs in memory reclaim?

If I remember correctly, there isn't new report after the last NBD(TCMU) deadlock
in memory reclaim was addressed by 8d19f1c8e193 ("prctl: PR_{G,S}ET_IO_FLUSHER
to support controlling memory reclaim").


Thanks, 
Ming
