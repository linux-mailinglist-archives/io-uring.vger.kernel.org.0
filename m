Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8155F7753
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 13:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiJGLV7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Oct 2022 07:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiJGLV4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 07:21:56 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151D1CA8B4;
        Fri,  7 Oct 2022 04:21:55 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h8-20020a17090a054800b00205ccbae31eso6936700pjf.5;
        Fri, 07 Oct 2022 04:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pamNmJzUJKJNy6FyTVxlPHnqdQUJnUaTsgljCI4D3ew=;
        b=WY2pgA5K9BMTRxxJmSjLCisnKuJse3zwFSQ/Hld3ttTFFoIdLw2C4Rq6zpdJ2uMpBS
         92ku71ANn3TWar6XapgZJKZirLm5iYBkoI90ktciHMEg9IQt1W5fdWr/Y2YGBEyrcLuA
         iKCSQmVjJELP0qYF+RFa3TiR9PKw8rzwo++viPDYqZdCxUxArjy8uVxVtonEdWO4Q6Dt
         yOHPv4CtciGDnlYsl02WQwMwXtpSz+IOUxfY8IyhDovTZ30pr7uh240wQWkPwRCCbDpZ
         v/GRk/XOOZwxgbtaueAHQqBR6SHXYCG+QUTuFo9c79IJKW4zesB8HYYcSUKn+Z6vEJaG
         1pFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pamNmJzUJKJNy6FyTVxlPHnqdQUJnUaTsgljCI4D3ew=;
        b=eazMLXM1KW1HXNYw27/BFgTVCisNyUDIq08sCeNNsWJ5H9TCnLwRu/RU8eamWS0svY
         /O7tiXN9c1IUwavOyLxOlpDlq2TV8sul1uqmU09N9PzkeU0x9ZIe57uUyqlum3wSdaHk
         GVeru/zZq/DtN6TDmYjWDZmvgnp03tsNBU6I8wQEj8s5UF6YqTCSyi62xs8NTWGpe1e0
         bg440B6lUvjx4x0OoyeaXBELsh266FecaBW/VtePYa0ChNIQqanxevOWJ0AdULVl+Xt8
         wKUoZ26yIQif5s2Sg3C9L+T6sSAJRsr8+dw8xlvgXy4PWE3VJMwlfA35tm7u6W1r597e
         6jaw==
X-Gm-Message-State: ACrzQf1TpCAopBEUC9x/7oGL3tdN+h3g7Ia145sT/yU0RoJ2USx2KnPs
        UTfVohXcWBQPPsOYuIFO2/w=
X-Google-Smtp-Source: AMsMyM7dU59UK/R1LAzJHYcDsG9br/NwyKNla0UMuFshhjVuUMXZeq14XRnK2QOrJpZgS4gwzJJkrw==
X-Received: by 2002:a17:902:c950:b0:17c:2248:11b1 with SMTP id i16-20020a170902c95000b0017c224811b1mr4356494pla.165.1665141714506;
        Fri, 07 Oct 2022 04:21:54 -0700 (PDT)
Received: from T590 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e14-20020a056a0000ce00b005626a1c77c8sm1348807pfj.80.2022.10.07.04.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 04:21:54 -0700 (PDT)
Date:   Fri, 7 Oct 2022 19:21:45 +0800
From:   Ming Lei <tom.leiming@gmail.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "Denis V. Lunev" <den@virtuozzo.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        rjones@redhat.com, Xie Yongji <xieyongji@bytedance.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Mike Christie <mchristi@redhat.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Message-ID: <Y0ALyTexTFGQ/8VU@T590>
References: <Yza1u1KfKa7ycQm0@T590>
 <Yzs9xQlVuW41TuNC@fedora>
 <6659a0d5-60ab-9ac7-d25d-b4ff1940c6ab@virtuozzo.com>
 <Yz2epPwoufj0mug/@fedora>
 <Yz6tR24T8HPHJ70D@T590>
 <Yz7fTANAxAQ8KT4v@fedora>
 <Yz7vvNKSNRyBVObo@T590>
 <Yz8eo0IWMAJOwKWn@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yz8eo0IWMAJOwKWn@fedora>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 06, 2022 at 02:29:55PM -0400, Stefan Hajnoczi wrote:
> On Thu, Oct 06, 2022 at 11:09:48PM +0800, Ming Lei wrote:
> > On Thu, Oct 06, 2022 at 09:59:40AM -0400, Stefan Hajnoczi wrote:
> > > On Thu, Oct 06, 2022 at 06:26:15PM +0800, Ming Lei wrote:
> > > > On Wed, Oct 05, 2022 at 11:11:32AM -0400, Stefan Hajnoczi wrote:
> > > > > On Tue, Oct 04, 2022 at 01:57:50AM +0200, Denis V. Lunev wrote:
> > > > > > On 10/3/22 21:53, Stefan Hajnoczi wrote:
> > > > > > > On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > > > > > > ublk-qcow2 is available now.
> > > > > > > Cool, thanks for sharing!
> > > > > > yep
> > > > > > 
> > > > > > > > So far it provides basic read/write function, and compression and snapshot
> > > > > > > > aren't supported yet. The target/backend implementation is completely
> > > > > > > > based on io_uring, and share the same io_uring with ublk IO command
> > > > > > > > handler, just like what ublk-loop does.
> > > > > > > > 
> > > > > > > > Follows the main motivations of ublk-qcow2:
> > > > > > > > 
> > > > > > > > - building one complicated target from scratch helps libublksrv APIs/functions
> > > > > > > >    become mature/stable more quickly, since qcow2 is complicated and needs more
> > > > > > > >    requirement from libublksrv compared with other simple ones(loop, null)
> > > > > > > > 
> > > > > > > > - there are several attempts of implementing qcow2 driver in kernel, such as
> > > > > > > >    ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ublk-qcow2
> > > > > > > >    might useful be for covering requirement in this field
> > > > > > There is one important thing to keep in mind about all partly-userspace
> > > > > > implementations though:
> > > > > > * any single allocation happened in the context of the
> > > > > >    userspace daemon through try_to_free_pages() in
> > > > > >    kernel has a possibility to trigger the operation,
> > > > > >    which will require userspace daemon action, which
> > > > > >    is inside the kernel now.
> > > > > > * the probability of this is higher in the overcommitted
> > > > > >    environment
> > > > > > 
> > > > > > This was the main motivation of us in favor for the in-kernel
> > > > > > implementation.
> > > > > 
> > > > > CCed Josef Bacik because the Linux NBD driver has dealt with memory
> > > > > reclaim hangs in the past.
> > > > > 
> > > > > Josef: Any thoughts on userspace block drivers (whether NBD or ublk) and
> > > > > how to avoid hangs in memory reclaim?
> > > > 
> > > > If I remember correctly, there isn't new report after the last NBD(TCMU) deadlock
> > > > in memory reclaim was addressed by 8d19f1c8e193 ("prctl: PR_{G,S}ET_IO_FLUSHER
> > > > to support controlling memory reclaim").
> > > 
> > > Denis: I'm trying to understand the problem you described. Is this
> > > correct:
> > > 
> > > Due to memory pressure, the kernel reclaims pages and submits a write to
> > > a ublk block device. The userspace process attempts to allocate memory
> > > in order to service the write request, but it gets stuck because there
> > > is no memory available. As a result reclaim gets stuck, the system is
> > > unable to free more memory and therefore it hangs?
> > 
> > The process should be killed in this situation if PR_SET_IO_FLUSHER
> > is applied since the page allocation is done in VM fault handler.
> 
> Thanks for mentioning PR_SET_IO_FLUSHER. There is more info in commit
> 8d19f1c8e1937baf74e1962aae9f90fa3aeab463 ("prctl: PR_{G,S}ET_IO_FLUSHER
> to support controlling memory reclaim").
> 
> It requires CAP_SYS_RESOURCE :/. This makes me wonder whether
> unprivileged ublk will ever be possible.

IMO, it shouldn't be one blocker, there might be lots of choices for us

- unprivileged ublk can simply not call it, if such io hang is triggered,
ublksrv is capable of figuring out this problem, then kill & recover the device.

- set PR_IO_FLUSHER for current task in ublk_ch_uring_cmd(UBLK_IO_FETCH_REQ)

- ...

> 
> I think this addresses Denis' concern about hangs, but it doesn't solve
> them because I/O will fail. The real solution is probably what you
> mentioned...

So far, not see real report yet, and it may be never one issue if proper
swap device/file is configured.


Thanks, 
Ming
