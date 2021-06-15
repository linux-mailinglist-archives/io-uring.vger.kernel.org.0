Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91483A8B60
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 23:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhFOVwh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 17:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhFOVwg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 17:52:36 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB39FC061574
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:50:31 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id i8-20020a4aa1080000b0290201edd785e7so163361ool.1
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VjVUDE45YcB13x3lqnLE37CRRkJRaS0DAF/jKxUqNJ0=;
        b=f3c4QkRRN1rPClwcatS6ahHYdeL4QsGOjHAYozqJCYgeiYnlsk7wNVblLEkp9oT0y+
         D3SCZoqjuIRPbUfNnPyMPXlcqbPk6S5tpT39FJ/OwH37FeFhD0cqsXmu7joApcJNIzrs
         RsyI0iCkdOjB6GNFw5ETHoy0nNoLo1PDVXI3FE9+eN0IRu/aEPr6RMdVaAVpZclshJUP
         YxdpxOjvaKHq0wYNBCt829lRQt30WiBVkl7SHhdeJ40AGHgmLF6l5hE787DykSqXy2cQ
         Z24522T0yJuHZ9q6UCuYZzFf8WIEN2OS4otA9cid2cdKqiqACCInfTbog3qgFBy2tqSj
         bErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VjVUDE45YcB13x3lqnLE37CRRkJRaS0DAF/jKxUqNJ0=;
        b=kaa1gE5bF6Vd9GoW6agqKv9Gi/c9mhTRFZz5Ri1vWmr4ZUcUMHpwi8Xp5N8Tw7bio3
         K2Xjcig00UphAe0C5rV418qRiHr3t/PkQiatZnSk7e6l9t18TdMu9KNkgkgLuqLvDqBg
         8WPm4kxvOqO5ncSZh3m61HzV2iGQyp8ZUns8O3o8TUhT2S/Rd2DHymCeyKtiJz0S9KIU
         Xm/C4fTVm0+hbQKYCq8RGQxVG/abgz7yFBqJugTlaHGMnGM72hC45ZZnyqIqBwqEeB/b
         Z8kq70vIXDXw62YFrHn+EsShhKdniIdZdK06yvYdShlCNmhj7FGkjx3RsBPrq7sVQ1Yw
         GrLA==
X-Gm-Message-State: AOAM530UJjXaMTlAe+0cwP2MEmNFD8Q21/MWBcBktiSzSh44VtyFzi4v
        Qy1PVgNFH0SYS5YbMXR9DP+tlA==
X-Google-Smtp-Source: ABdhPJzrrDhUduWQRSmbGUiuNv5PDxIJys0Vu+3cVi8sxub54zf7YHRejioPq7SE10Wazk2WrfpBEQ==
X-Received: by 2002:a4a:55c1:: with SMTP id e184mr1082080oob.74.1623793831032;
        Tue, 15 Jun 2021 14:50:31 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id x35sm59041otr.7.2021.06.15.14.50.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 14:50:30 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] io_uring: minor clean up in trace events
 definition
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
 <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
Date:   Tue, 15 Jun 2021 15:50:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/21 3:48 AM, Pavel Begunkov wrote:
> On 5/31/21 7:54 AM, Olivier Langlois wrote:
>> Fix tabulation to make nice columns
> 
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

I don't have any of the original 1-3 patches, and don't see them on the
list either. I'd love to apply for 5.14, but...

Olivier, are you getting any errors sending these out? Usually I'd expect
them in my inbox as well outside of the list, but they don't seem to have
arrived there either.

In any case, please resend. As Pavel mentioned, a cover letter is always
a good idea for a series of more than one patch.

-- 
Jens Axboe

