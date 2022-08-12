Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E089859130B
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 17:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237449AbiHLPdU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 11:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237828AbiHLPdQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 11:33:16 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73B78286D
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 08:33:14 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id cb12-20020a056830618c00b00616b871cef3so789405otb.5
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 08:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8oBDJVuwdOZLiHkVSEyTUsR1EYdyGI8V8r2xjpxsCpI=;
        b=C92dLihkrorWY0llEIothn8Rp6jZeUNFzjy1OD4l3C18FBf/GDWXmwdB4tmv0s9ZlE
         lf8qjKvw7SXysD4wSKV1jKUa10Q9bgy5FXb3w/a0D55h1aRHLDLWt3DuznYUBRmTkJxc
         xQGvxWkXqkwjJEAGj67/VHgEGctBB8LNHXhNxWJ2J2YFA9Z0MS/nEiRgsm+q+pVfI9F/
         xLY2/oSHEd8a69/HX/7DCjzxQf+PBq7OelImPzooymXTbXEQFOX0De6FXhI5Ce1oDAK+
         AZoM8jJCtXNRxgga3QHoIZ/fa8agJOUbhjwKOsKLOCh31vXKpHeRf7NdSapHa8zjlEec
         Cx2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8oBDJVuwdOZLiHkVSEyTUsR1EYdyGI8V8r2xjpxsCpI=;
        b=jcyLdpskMDSrWk3oq9crinPLYDf55YHvZxS2OLiqRC3bSSQvHVcw1eClhqG5qFVyqw
         LbFuhnovn69GXTWM17mvgZ0F3nErluyu9/kpYXFvs7xCnTA58QI6v9832ktis/ph3oAD
         Lpdp9AESVnLoqhvXgJDdjL8okMrc+C4X4ATIusVWm13gVhj2LeDJfCHFyOFRCb+feZgp
         eNaEKTrcfCbCwCkTBsFkHl1Wv8yWlYbANViuHYf5nRTPvYZXWCAHW8Npn77Xqn/EcHCo
         TksMz/iYazt7MtktOqmeiM9nIst1IXIto0LGjfaSNNj9h81bGGwb/yvsO9B4tQrjZ76M
         YV7w==
X-Gm-Message-State: ACgBeo3etTmdhQh4jAw9jkNvlGUCy3DFv3EJm0jEuCJpSEbZeuDHZolP
        0Xn/0MPRdG3R6h8hO/zIXChw7J4/03hHrrcUX+88XIRd1w==
X-Google-Smtp-Source: AA6agR5I0iDZFKln5Ym4BHnUkvpsHxSDWcP6J5PeV4EgR0S6ivgDbvMq9hfwQW6L28PQ3IdUDXiJrgW5DGY2PTn1vqs=
X-Received: by 2002:a05:6830:33e4:b0:636:732d:5a48 with SMTP id
 i4-20020a05683033e400b00636732d5a48mr1635676otu.69.1660318393736; Fri, 12 Aug
 2022 08:33:13 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com> <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
In-Reply-To: <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 12 Aug 2022 11:33:02 -0400
Message-ID: <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
Subject: Re: [PATCH liburing 0/5] Add basic test for nvme uring passthrough commands
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Ankit Kumar <ankit.kumar@samsung.com>,
        io-uring@vger.kernel.org, joshi.k@samsung.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 11, 2022 at 9:51 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 8/11/22 6:43 PM, Casey Schaufler wrote:
> > On 7/19/2022 6:52 AM, Ankit Kumar wrote:
> >> This patchset adds test/io_uring_passthrough.c to submit uring passthrough
> >> commands to nvme-ns character device. The uring passthrough was introduced
> >> with 5.19 io_uring.
> >>
> >> To send nvme uring passthrough commands we require helpers to fetch NVMe
> >> char device (/dev/ngXnY) specific fields such as namespace id, lba size.
> >
> > There wouldn't be a way to run these tests using a more general
> > configuration, would there? I spent way too much time trying to
> > coax my systems into pretending it has this device.
>
> It's only plumbed up for nvme. Just use qemu with an nvme device?
>
> -drive id=drv1,if=none,file=nvme.img,aio=io_uring,cache.direct=on,discard=on \
> -device nvme,drive=drv1,serial=blah2
>
> Paul was pondering wiring up a no-op kind of thing for null, though.

Yep, I started working on that earlier this week, but I've gotten
pulled back into the SCTP stuff to try and sort out something odd.

Casey, what I have isn't tested, but I'll toss it into my next kernel
build to make sure it at least doesn't crash on boot and if it looks
good I'll send it to you off-list.

-- 
paul-moore.com
