Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295D8408217
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 00:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbhILWud (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 18:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236546AbhILWuc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 18:50:32 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BF0C061574
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 15:49:17 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id m4so3112949ilj.9
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 15:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AJrC16PRsHHg5tAzb/rAVTdnbMY9m3dUA/sB9NSaV1w=;
        b=GDtZPoLVej6DIsmOHmNxiH9fqIqIBKe4sJn+9ozqyEexLv7RWLQjDLLQ9USK2b8vt0
         hCd/yRDfMQ0rcGOMjeAEnhcip1w2vdkTFvbNhfZbHNzRRfYZ+w/Fy9s4h89V+hgteonA
         LOTi64X0FPKiFUC+aprSkxqpkMUTJ4Zk783rT5S879wTnLPclP3roeUyjIBrAYs4KmFd
         q1ub+S9nmCMtjm11ZsMx/c6bzO6vXx6ghaE4S6dbyJQaJnxjs8+HMbllzUD2cxftqo39
         uDjwPyy+utYHZ+MqhBHj0HOGJBmGhwqfLNzuEdR1uJ38AMhE/NPVUmwjDNlc1b6lRYPg
         8vJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AJrC16PRsHHg5tAzb/rAVTdnbMY9m3dUA/sB9NSaV1w=;
        b=V66Ec5n0PoOfGldYe/LZOsrjs9iG4UCp49/GDeA8wRENed0TWppud64qZxsQ42MQnD
         V1eN5myCA78+RWCZU1Fc28m/2JaOtoQnsdIF/K+jwRXyzHEZue2qyne0pQih0DMU82Mt
         Ut2mhxZBTCqzCpSHSqBkDl89B59ylg4seb62dAwdqEhVAjAuUW3Ha5/HpOe9shXB+PRj
         7exqJS12I/9k0OIChlU74IHnScXBk9ds6EcRqRmqJzQXScLZ/DAHYjw/rXWWJc8e59iQ
         aKj5ND/1KjiI6rCJv6VhZfgVk4QvQ9FYZgujccNeLheAEtMNDZf34HTW9Yr+nQcEbWLb
         cFjA==
X-Gm-Message-State: AOAM5314PBtTrKJnSXOvKFIaOxgCc50QY/QTf/GxYRsuaVXCcINvdjnY
        Ws7IMKcxZN+o1uhPyLxo91OXew==
X-Google-Smtp-Source: ABdhPJxOeGSjU740gKaUYJ/WU89BmB0xx4i1LJSwutClSky6n4Lu/orWfB4i1btgj747QZtef9HTtQ==
X-Received: by 2002:a92:c84c:: with SMTP id b12mr5890537ilq.105.1631486956825;
        Sun, 12 Sep 2021 15:49:16 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p19sm3537811ilj.58.2021.09.12.15.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 15:49:16 -0700 (PDT)
Subject: Re: [PATCH] io-wq: expose IO_WQ_ACCT_* enumeration items to UAPI
To:     "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     Eugene Syromiatnikov <esyr@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
References: <20210912122411.GA27679@asgard.redhat.com>
 <a6027db7-3ebc-6f12-2b58-4b068a346ee2@kernel.dk>
 <20210912222434.GD18053@altlinux.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7d702960-bb2b-4abb-29b4-4f169db7ecf2@kernel.dk>
Date:   Sun, 12 Sep 2021 16:49:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210912222434.GD18053@altlinux.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/21 4:24 PM, Dmitry V. Levin wrote:
> On Sun, Sep 12, 2021 at 12:29:41PM -0600, Jens Axboe wrote:
>> On 9/12/21 6:24 AM, Eugene Syromiatnikov wrote:
>>> These are used to index aargument of IORING_REGISTER_IOWQ_MAX_WORKERS
>>> io_uring_register command, so they are to be exposed in UAPI.
>>
>> Not sure that's necessary, as it's really just a boolean values - is
>> the worker type bounded or not. That said, not against making it
>> available for userspace, but definitely not IO_WQ_ACCT_NR. It
>> should probably just go in liburing, I guess.
> 
> If IO_WQ_ACCT_* were just boolean values, no enum would have been
> introduced in the first place.  What's the benefit of hiding
> the API in the implementation, or burying it inside liburing?

Because it's easier to grok internally with an enum instead of
using 0/1. And you could argue that's the case too for an app,
and as I said, I'm not against making them exposed, but the _NR
part is strictly internal.

Just add separate defines or an enum in io_uring.h:

enum {
	IO_WQ_BOUND,
	IO_WQ_UNBOUND,
};

and be done with it.

-- 
Jens Axboe

