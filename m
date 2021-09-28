Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB65441AC06
	for <lists+io-uring@lfdr.de>; Tue, 28 Sep 2021 11:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbhI1Jhk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Sep 2021 05:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239794AbhI1Jhj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Sep 2021 05:37:39 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B34C061575
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 02:36:00 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id s21so16839553wra.7
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 02:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d3dDuoz7QRp1L24B9tvnlz/IL+bXDC1QsMPQByrWDR0=;
        b=P418vOPC2VYjSYrn91iy2saSiFS6Nib+l7mjYXgfyATIV+PbKG+5m++VwdFf9qGtDI
         jK1XlJDCw8EITEvh5XMzEWMVHJ7I74ylXMyeusqiHu2se6oGJZqysKW+uwIEDg9AQBEO
         +C+jHUU6EmYp9tJNji8fyuogoyLXWeS+TNfOcxwtyee8n4N/Mdyg1eHeS+mnls2oa2np
         mZt7vt8uxEucDTcQQeQ6mIqnmiF1Xny7Al/xGT4Wvh4jCMTOCs7qs7m9yQQiml3YstpS
         uQX09mKXAUiKAstSNm5MfVRoLHDW8P7FSTzff6BOmdeXl36mdszwiLHPrkv6QNvuGcCR
         gOQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d3dDuoz7QRp1L24B9tvnlz/IL+bXDC1QsMPQByrWDR0=;
        b=PPYnPURkcxkYypG5l5PBxhnPgHJushmm1vHZDlw8DH/A20uwBCnrUYKhjhC7Rt9wd8
         LYRMjruEDlYnZ45z1fHNGWoytoM3zUrTH/5xnfUJPBcq2zG3gB4JfTi3tAXkUSRUqJ2d
         XPHKyqeIinOcTIp1Wpc9t+EOpwtzoM3yOFlkBb+pIfLcdD/ZuvKwckFQicTBU4Yd62Vy
         +cglKHgIPhhCOEh3kFunxkuaQkLJl7Vho0vBvIcgIvWw+Zu4B3jA6ihw/ZRTa9mGik3z
         7ntkRnA8+8fkARKs0+vDvFcpUhxlixy1sUMs9Wai7sInpLoMWB1IUlkCLEZ7az2Rlwi4
         XIig==
X-Gm-Message-State: AOAM531dJn7ngDlj7KUh2Hqm5p27fDvwLi75PkNyU+aQcNLmaHfy/EhQ
        c12pQ4l/jc752w40KRu2sN1NtoUjIgc=
X-Google-Smtp-Source: ABdhPJyhmVvsr4R2CZvWKZUznyU8wInUNxX3fZ7CoxoVfphfj0yR4I0/FBi2JHSpH8eN0dQhbNaL0g==
X-Received: by 2002:adf:e94d:: with SMTP id m13mr5406057wrn.28.1632821758289;
        Tue, 28 Sep 2021 02:35:58 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.229])
        by smtp.gmail.com with ESMTPSA id y7sm2095318wmj.37.2021.09.28.02.35.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 02:35:57 -0700 (PDT)
To:     Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>
References: <cover.1632516769.git.asml.silence@gmail.com>
 <b37fc6d5954b241e025eead7ab92c6f44a42f229.1632516769.git.asml.silence@gmail.com>
 <CAFUsyfLSXMvd_MBAp83qriW7LD=bg2=25TC4e_X4oMO1atoPYg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v2 12/24] io_uring: optimise batch completion
Message-ID: <f1193cda-2663-a830-6458-a20fe4157327@gmail.com>
Date:   Tue, 28 Sep 2021 10:35:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAFUsyfLSXMvd_MBAp83qriW7LD=bg2=25TC4e_X4oMO1atoPYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/25/21 8:58 PM, Noah Goldstein wrote:
> On Fri, Sep 24, 2021 at 5:45 PM Pavel Begunkov <asml.silence@gmail.com>
[...]
>> +       if (unlikely(!nr_events))
>> +               return 0;
>> +
>> +       io_commit_cqring(ctx);
>> +       io_cqring_ev_posted_iopoll(ctx);
>> +       list.first = start ? start->next : ctx->iopoll_list.first;
>> +       list.last = prev;
>>         wq_list_cut(&ctx->iopoll_list, prev, start);
>> -       if (nr_events)
>> -               io_iopoll_complete(ctx, &done);
>> +       io_free_batch_list(ctx, &list);
>>
> 
> If it's logically feasible it may be slightly faster on speculative machines
>  to pass `nr_events` to `io_free_batch_list` so instead of having the loop
> condition on `node` you can use the counter and hopefully recover from
> the branch miss at the end of the loop before current execution catches up.
> 
>         return nr_events;

May be. We can experiment afterward and see if the numbers get better

-- 
Pavel Begunkov
