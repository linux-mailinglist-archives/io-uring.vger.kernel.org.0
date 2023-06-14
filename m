Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEA673047F
	for <lists+io-uring@lfdr.de>; Wed, 14 Jun 2023 18:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjFNQDZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Jun 2023 12:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbjFNQDI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Jun 2023 12:03:08 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6689326BE
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 09:03:07 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-7748ca56133so55528839f.0
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 09:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686758587; x=1689350587;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8tLibdYBUKAWWQv2DAGVSJ8/abABpHUo1vn9fk5r1JQ=;
        b=JXkCCli1V4QsfgCsPfy6RJSwPu3cZyPh/H8CfYtwyxoi86yIFio69/mF0qpDT0Mx6N
         PzL3nF95SlvDNtla3o/kaeCoHKgcOu4B+wSncVH9idgSqIlA3k3YEYi2YSGrTBMdfuY2
         Hm40g8BUJFnYkW2wsLE32lC/tQDAzJB1KOC6abP+vbwCIJfiuAv7GCaTpQrxP37b2BQQ
         cubphfYhuXN4nVQeoHto7xNgle9/xm/hkN9z6xve+ZYgCypYf0MFyx4VudkrPahQn9Eu
         L4ebsbrplGuGl1fap3y7h+ty/V7rIUA4a/Th2tcLWL6/WOIZ32s2iS3P5Nf+pIMhsaQv
         mswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686758587; x=1689350587;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8tLibdYBUKAWWQv2DAGVSJ8/abABpHUo1vn9fk5r1JQ=;
        b=bKtExAfDSghBN0ZSRSng7UiXQPWwFOVfZf3DSVQQgaCnREmdhqTBH4+EiEM7UL5GZr
         sl37IcMZvNHgrOLUycLJNEjHuBH7wBmji7hKqQ/HN9rVA1WrmD92yXIltCC/ux3NQJEz
         1x7G1ZCu+6es3z/iW+/HWkL7VYaB0yJz7IuipyBpoOB2iX8kzfVTp+hch8laqERvwW2X
         5Q3QW/e/Iwu/rYdFbiM1qD1sp21W5tfpc9zpF9kpK1qfIIHWRNf3GQc4LCDQYa85Spn0
         W0d9ZdCB0t7tO8EGh3yb3LBenKkiGNhJVMTGcPi5lqO2B/QxjILqj9GZVo0Kf15m7wjT
         H97Q==
X-Gm-Message-State: AC+VfDw1R2bks6exZPUtbqQU1ogmG9Pzi2zFsuhqj28jSrtderY0opAc
        XQVcO8yd+X2s5lADlxlG6VdBSckK2cNitTNoHEE=
X-Google-Smtp-Source: ACHHUZ7PhRm6EuYLmiO5Wta3Dyi2vIguAlroFaeDWEK6oCuEuD/kUIkQFR7zg3A430d8XZHatkDxSw==
X-Received: by 2002:a05:6602:1789:b0:777:b456:abbe with SMTP id y9-20020a056602178900b00777b456abbemr9929158iox.0.1686758586678;
        Wed, 14 Jun 2023 09:03:06 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k4-20020a02a704000000b004168295d33esm5071241jam.47.2023.06.14.09.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 09:03:05 -0700 (PDT)
Message-ID: <fee91f15-ad08-1687-3f3e-43a91ec45d40@kernel.dk>
Date:   Wed, 14 Jun 2023 10:03:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: io-wrk threads on socket vs non-socket
Content-Language: en-US
To:     Marek Majkowski <marek@cloudflare.com>, io-uring@vger.kernel.org
References: <CAJPywTLDhb5MkYS7PTi7=sXwm=5r9AbPKz3fDq4XGbqKvA-g=A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJPywTLDhb5MkYS7PTi7=sXwm=5r9AbPKz3fDq4XGbqKvA-g=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/23 8:09?AM, Marek Majkowski wrote:
> Hi!
> 
> I'm playing with io-uring, and I found the io-wrk thread situation confusing.
> 
> (A) In one case, I have a SOCK_DGRAM socket (blocking), over which I
> do IORING_OP_RECVMSG. This works well, and unless I mark the sqe as
> IOSQE_ASYNC, it doesn't seem to start an io-wrk kernel thread.
> 
> (B) However, the same can't be said of another situation. In the
> second case I have a tap file descriptor (blocking), which doesn't
> support "Socket operations on non-socket", so I must do
> IORING_OP_READV. This however seems to start a new io-wrk for each
> readv request:
> 
> $ pstree -pt `pidof tapuring`
> tapuring(44932)???{iou-wrk-44932}(44937)
>                 ??{iou-wrk-44932}(44938)
>                 ??{iou-wrk-44932}(44939)
>                 ??{iou-wrk-44932}(44940)
>                 ??{iou-wrk-44932}(44941)
>                 ??{iou-wrk-44932}(44942)
> 
> I would expect both situations to behave the same way.
> 
> The manpage for IOSQE_ASYNC:
> 
>        IOSQE_ASYNC
>               Normal operation for io_uring is to try and issue an sqe
>               as non-blocking first, and if that fails, execute it in an
>               async manner. To support more efficient overlapped
>               operation of requests that the application knows/assumes
>               will always (or most of the time) block, the application
>               can ask for an sqe to be issued async from the start. Note
>               that this flag immediately causes the SQE to be offloaded
>               to an async helper thread with no initial non-blocking
>               attempt.  This may be less efficient and should not be
>               used liberally or without understanding the performance
>               and efficiency tradeoffs.
> 
> This seems to cover the tap file descriptor case. It tries to readv
> and when that fails a new io-wrk is spawned. Fine. However, as I
> described it seems this is not true for sockets, as without
> IOSQE_ASYNC the io-wrk thread is _not_ spawned there?
> 
> Is the behaviour different due to socket vs non-socket or readv vs
> recvmsg?

What kernel are you using? tap just recently got FMODE_NOWAIT support,
which should trigger poll instead of needing to spawn an io worker.

Also, as usual, a test case would be appreciated. Particularly if this
is on a current kernel where we would not expect to see io-wq activity
for a read of tap.

-- 
Jens Axboe

