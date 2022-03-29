Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2624EB181
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 18:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbiC2QKq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 12:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239519AbiC2QKi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 12:10:38 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27E410E56E
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 09:08:22 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id z6so21580621iot.0
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 09:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=+GC1GiG/TGBWL9zFzZy6/tU/okjinSTLLjQKuupyq6o=;
        b=twHiCp3fxjz96ot0qtlGr0tQg8+hHRgb7zX7TEUQphgnepHV6Caoj6hD68YlgmHWHn
         uojAC57W84iX8oPyIHn7yE/fnm2l8bppiNNeI9DeJSy0kb/U2OvVtWUOtt4CziXZiwko
         PkACg+dwfBHCy4Lu+TqpzzCvD0zgx9sfdp6aNrQS5lcibz0dd9LDiReWOb84rhXgkeBZ
         ZjdblBGK2oKZifyU2Sg70wPBSgULI9LQc3DuvnZFpqSvgfzJJDEd+y5hIBmC5bltTBxH
         S8Axq8b15Rt+2NbB3hrPPJt7WrEg5TPou9apvW481VGQpKVcaIJ7DF2vbBahUW7i4gGX
         i76Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+GC1GiG/TGBWL9zFzZy6/tU/okjinSTLLjQKuupyq6o=;
        b=CQRMbtBIjgam9wEmO8OvV4/sQX6G+0ab1uyMt7YEHDJb5DAk9AWDgHHDsINo4H2NQu
         0qx6u5PIPpzaWRZTO7Otms3yt5n+tqgPyo+iL8sDBPiLt7f3FuuT7S53r8nj8CO29Dw9
         8KPJ6guQjF0moPSTqlZl4jDdrkEmRIvnyUFPV9508iDJmL4kjw9ENr9fH4Fhr2tPxa5U
         +UPd5zyk2mQcHRpdwckTFUXQVH6Tli7RgH4H6Rubu3EezIJpFgUP5/9GrTWWiU43T2Qw
         48HD1oYHMDW2L1zo1BuLCplTl1hjYqPjLpvhnkkZbB7OYRhT1cqJGSNC9w9NTasmrFJo
         iJZg==
X-Gm-Message-State: AOAM532MOad5Q1BfaVbshXBxOESSkUyf0S1NXzz0c30qASEb5BSYx+Wy
        cuwkdpysUvQD89nUyN0Z3e1l+6IfWXSQusB3
X-Google-Smtp-Source: ABdhPJz5PzE3Tua5rizVt6wjKYLyMg/q/JizEfhFYDM+EfvMPFA4eW+id6Eg02Vo6Jmlu6qQv+d34Q==
X-Received: by 2002:a05:6602:15d1:b0:649:1ed6:edcf with SMTP id f17-20020a05660215d100b006491ed6edcfmr9931070iow.74.1648570102277;
        Tue, 29 Mar 2022 09:08:22 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k5-20020a6bf705000000b00649a2634725sm9678211iog.17.2022.03.29.09.08.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 09:08:21 -0700 (PDT)
Message-ID: <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk>
Date:   Tue, 29 Mar 2022 10:08:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>, io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/29/22 7:20 AM, Miklos Szeredi wrote:
> Hi,
> 
> I'm trying to read multiple files with io_uring and getting stuck,
> because the link and drain flags don't seem to do what they are
> documented to do.
> 
> Kernel is v5.17 and liburing is compiled from the git tree at
> 7a3a27b6a384 ("add tests for nonblocking accept sockets").
> 
> Without those flags the attached example works some of the time, but
> that's probably accidental since ordering is not ensured.
> 
> Adding the drain or link flags make it even worse (fail in casese that
> the unordered one didn't).
> 
> What am I missing?

I don't think you're missing anything, it looks like a bug. What you
want here is:

prep_open_direct(sqe);
sqe->flags |= IOSQE_IO_LINK;
...
prep_read(sqe);

submit();

You don't want link on the read, it just depends on that previous open.
And you don't need drain.

But there's an issue with file assignment, it's done with the read is
prepped, not before it is run. Hence it will fail with EBADF currently,
which is the issue at hand.

Let me write up a fix for this, would be great if you could test.

-- 
Jens Axboe

