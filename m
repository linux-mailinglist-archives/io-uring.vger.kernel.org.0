Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1C21EEB58
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 21:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgFDTwO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 15:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728936AbgFDTwO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 15:52:14 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19C6C08C5C0
        for <io-uring@vger.kernel.org>; Thu,  4 Jun 2020 12:52:12 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b201so3777273pfb.0
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2020 12:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cD/9UyjX+yvIa+os6YZ+RyY2wWeU9kD6nVvkY0IT+ho=;
        b=Z/TKEiLxb0rZSqERy/jtpvWjeGMuJZGyVf0p71w/9BX8G71tGSkgs/ppD44UJGiL1o
         47KgB9juZjQT4ocJyt6BuoRkHdsk3tByWCBNQhV5+Ka2TLMGlljxVrhrzVYFHnEM0sZz
         Hu5lHMYi4yVDdxcvFusivhsBaPNxILGYm0u9+br4nagi49CfRQea9D/Nvo4jP1CgLm7X
         5X6PWRzH6rekKc//7uXv7xoS7zEft5/SUl7YiduHuavU4l3LWmHwHgBgh6rOw9fKGXYn
         TcfBV61UTUkmRPg2ct1F9bbgWUpsjvAbH1IDyF2M3T7TrxaGNd47BnD388aIIpnhVzJG
         +9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cD/9UyjX+yvIa+os6YZ+RyY2wWeU9kD6nVvkY0IT+ho=;
        b=IlQT+6KRS65IJur5Harnvagor2CTNp5s9Of/4ZXwRHBVy58ghEb4pDtY0zr5B/p74Z
         xpbQRHL1XPQR9CcVcOk6Qbo6dobcyxk/30Bv02Av88aUun2b1erQx3QQk1E4XnQon6VW
         sTEFQmgqFJ9PjWamT03/hWoD2EisdnR0Wi+Y84tYP94SWQOYk0hfKcjezXL+tdcsXRYD
         IMEcHPp1BQEdeF+or7jlbkJoYGn0jXF6AfbO2hywYrCK1DNB/vdVrMFB8okKjKn6xfxg
         PF62eK/AI2VNQ7GjMYIHFCYEaEXmSTE0YSHjwQMoQDSAFeM+2zB+IGLEO+lEp+YwwGpt
         xAtQ==
X-Gm-Message-State: AOAM532U0tu5Cea9uAnXrACN53KvovWaIsvdtV89eRKHlFWWhgg9V3Cf
        WGDommPTNW8hWKeyTWrwBt0TWg==
X-Google-Smtp-Source: ABdhPJwt4mb+Mqsjl089Zu3RO3ZQ3BtMjv/cnBMi6+AzhxmOwZT4urNEfERWgVO44nZz1CvK/wx4vw==
X-Received: by 2002:a63:6c8:: with SMTP id 191mr5865638pgg.22.1591300332353;
        Thu, 04 Jun 2020 12:52:12 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id nl8sm7267577pjb.13.2020.06.04.12.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 12:52:11 -0700 (PDT)
Subject: Re: [PATCH v3 0/4] forbid fix {SQ,IO}POLL
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1591196426.git.asml.silence@gmail.com>
 <414b9a24-2e70-3637-0b98-10adf3636c37@kernel.dk>
 <f5370eb3-af80-5481-3589-675befa41009@kernel.dk>
 <d1d92d99-c6b1-fc6e-ea1d-6c2e5097d83f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cc3197f9-e8b1-ac13-c121-291bb32646e3@kernel.dk>
Date:   Thu, 4 Jun 2020 13:52:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <d1d92d99-c6b1-fc6e-ea1d-6c2e5097d83f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/4/20 1:22 PM, Pavel Begunkov wrote:
> On 04/06/2020 20:06, Jens Axboe wrote:
>> On 6/3/20 12:51 PM, Jens Axboe wrote:
>>> On 6/3/20 9:03 AM, Pavel Begunkov wrote:
>>>> The first one adds checks {SQPOLL,IOPOLL}. IOPOLL check can be
>>>> moved in the common path later, or rethinked entirely, e.g.
>>>> not io_iopoll_req_issued()'ed for unsupported opcodes.
>>>>
>>>> 3 others are just cleanups on top.
>>>>
>>>>
>>>> v2: add IOPOLL to the whole bunch of opcodes in [1/4].
>>>>     dirty and effective.
>>>> v3: sent wrong set in v2, re-sending right one 
>>>>
>>>> Pavel Begunkov (4):
>>>>   io_uring: fix {SQ,IO}POLL with unsupported opcodes
>>>>   io_uring: do build_open_how() only once
>>>>   io_uring: deduplicate io_openat{,2}_prep()
>>>>   io_uring: move send/recv IOPOLL check into prep
>>>>
>>>>  fs/io_uring.c | 94 ++++++++++++++++++++++++++-------------------------
>>>>  1 file changed, 48 insertions(+), 46 deletions(-)
>>>
>>> Thanks, applied.
>>
>> #1 goes too far, provide/remove buffers is fine with iopoll. I'll
>> going to edit the patch.
> 
> Conceptually it should work, but from a quick look:
> 
> - io_provide_buffers() drops a ref from req->refs, which should've
> been used by iopoll*. E.g. io_complete_rw_iopoll() doesn't do that.
> 
> - it doesn't set REQ_F_IOPOLL_COMPLETED, thus iopoll* side will
> call req->file->iopoll().

We don't poll for provide/remove buffers, or file update. The
completion is done inline. The REQ_F_IOPOLL_COMPLETED and friends
is only applicable on read/writes.

-- 
Jens Axboe

