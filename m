Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 859DA14F950
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 19:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgBASGc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 13:06:32 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:38418 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgBASGb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 13:06:31 -0500
Received: by mail-pj1-f52.google.com with SMTP id j17so4476246pjz.3
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2020 10:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YM7OE381VqIjGjP2Ax6Y838mESKdbZMTtSQQr2vp+VI=;
        b=XUaElgP+haths9oiwwZQtGBJha2YkgB1HJxIkcEJnXz5CNqh8BZKprdgon/zOZf418
         MpdEl7scEYt4VwQBo11bOS++5qzxFp+RG9unOso3j7wLm3iY04Y2rOo8pPH2qDBsqcGS
         rS87VPKQrLO6jGPIMowPMoqDo4RsCasC4PXprMX6P2oR+c+7GDq3Zvcu8uRx/IUjKW2T
         ESFPoLeVanenoRNjZbM8JkzD4H7IzJ8N/W0kRQwEWaUcW6Yjr+W1qSwTR/XmmoxsTNE3
         ZH6tYuuAUo+e2poQPYGiuVTBTbODOQ7dvUYNnNokt2CIMGxMskYWeOCLA7cVLQrqQEh1
         gZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YM7OE381VqIjGjP2Ax6Y838mESKdbZMTtSQQr2vp+VI=;
        b=HMrttjJrNKHU2AAz6rfGmkrnzGHOX1Tp1xhnWzbku3ndxc1CM4aOfkpemrhSvZ6A7Q
         MwbluvSzM3F/3/u7Ml7nPo4VXMQ7akJnJYLnEOkP4Gtpzh3nwmtgssy0BDUCV9vjWTgL
         r0YtOsOULftIHg4u66f9kZWkWySpQulIXUU8dx4VNcUy3mIOCsK/KxegMPooDSdC5PrZ
         jiCCNpMw6LdmdTPeyHPiK7Nw+YSwhUnVgj65rAO5AQlhufBp5JlcUvrTsqkr2/vP7GBI
         XZy8uX5PYZuSnsihhlBwSoRJ1fcWzqcyC5hVlbx4HqkOsrmEpUOHaJJjD52EloHeONKF
         TQMw==
X-Gm-Message-State: APjAAAVssyd8dnI6Pfoljslxu6ShSghddnMiAyPeCEMwL1/ugMJm6p1c
        jGJxEEvJDoOiOMChht1SJ7GEFCBsCeM=
X-Google-Smtp-Source: APXvYqx9PwzLsBHsNl6UpSG9dlmXNpIu2q82ILtHF5IQNxz76wgZaTULNlaniJV/U/lAJZ2WaA/wqQ==
X-Received: by 2002:a17:902:6504:: with SMTP id b4mr15870045plk.291.1580580390776;
        Sat, 01 Feb 2020 10:06:30 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id j125sm14605757pfg.160.2020.02.01.10.06.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 10:06:30 -0800 (PST)
Subject: Re: What does IOSQE_IO_[HARD]LINK actually mean?
To:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org
References: <20200201091839.eji7fwudvozr3deb@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8df72d47-f3ef-d7b8-d1f7-da58b2d58a7e@kernel.dk>
Date:   Sat, 1 Feb 2020 11:06:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200201091839.eji7fwudvozr3deb@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/1/20 2:18 AM, Andres Freund wrote:
> Hi,
> 
> Reading the manpage from liburing I read:
>        IOSQE_IO_LINK
>               When  this  flag is specified, it forms a link with the next SQE in the submission ring. That next SQE
>               will not be started before this one completes.  This, in effect, forms a chain of SQEs, which  can  be
>               arbitrarily  long. The tail of the chain is denoted by the first SQE that does not have this flag set.
>               This flag has no effect on previous SQE submissions, nor does it impact SQEs that are outside  of  the
>               chain  tail.  This  means  that multiple chains can be executing in parallel, or chains and individual
>               SQEs. Only members inside the chain are serialized. Available since 5.3.
> 
>        IOSQE_IO_HARDLINK
>               Like IOSQE_IO_LINK, but it doesn't sever regardless of the completion result.  Note that the link will
>               still sever if we fail submitting the parent request, hard links are only resilient in the presence of
>               completion results for requests that did submit correctly.  IOSQE_IO_HARDLINK  implies  IOSQE_IO_LINK.
>               Available since 5.5.
> 
> I can make some sense out of that description of IOSQE_IO_LINK without
> looking at kernel code. But I don't think it's possible to understand
> what happens when an earlier chain member fails, and what denotes an
> error.  IOSQE_IO_HARDLINK's description kind of implies that
> IOSQE_IO_LINK will not start the next request if there was a failure,
> but doesn't define failure either.

I won't touch on the rest since Pavel already did, but I did expand the
explanation of when a normal link will sever, and how:

https://git.kernel.dk/cgit/liburing/commit/?id=9416351377f04211f859667f39a58d2a223cbd21

LSFMM will have a session on BPF with io_uring, which we'll need to have
full control of links outside of the basic use cases.

-- 
Jens Axboe

