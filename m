Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9012B1F0FC8
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 22:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgFGUh7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 16:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbgFGUh6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 16:37:58 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37436C08C5C3
        for <io-uring@vger.kernel.org>; Sun,  7 Jun 2020 13:37:57 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id k8so11726963edq.4
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2020 13:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8ZIipCxC1jw2HQkvBuNwlbfm7OqUVInrBjIQtsBnLd8=;
        b=SxVBqBiN9dxloZF0LAvsFhB1xm6npQJnybbRfC298Vi1wXodApJZ+J4ZFbPtQFpq8y
         CbogiDz3D93ZTix96Md3CrWZkbiHvjQ/rUH/bMHDw52ORVP8czr8T2QGwVF+LobxNRao
         ckLKqCa6JO/RhJQ62M0Jv0xaV07OYAdvq7MmEIE3UDMSCtwAQMc5LhxMDNZIRzl59aqv
         bcAwemaQRg7Hzp8dVm1xFwgzqeye1vWXCVprsFPqEarOpLEqhkryfge5Mpqiu/pdh8OM
         Vzr+JzZFTvZnkwu7Sqq7M2n4p0s0oEqVtO48vHDaKiqo9SmUPkfYHgK94hRpkj0m+fIU
         k/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8ZIipCxC1jw2HQkvBuNwlbfm7OqUVInrBjIQtsBnLd8=;
        b=t9BOD5DpsnGd36PHPBVP5kFv9rQVBmPDuo59wz0jJcnheU1XK7V2B/K57uG+e5R38C
         EZgh8h98yh1jFnfDTVpPHV4jG+2hF6cwZzWRDb3O9DKoJF3sQNB6KoXHQAJzZ9s3qFRu
         yiUl+TDXyWnzG7c5UYsRdTtkwrzsLrG9snqy5dKy2q2w0K4sRCceSYGwcv0RitoSZbWj
         s94hlXaTZIcEUhyoiA87SiCD3gYSqpNFNyjqIDjU9c2p1ikO/ZjR5OjDcG239OKNYngv
         zcPkk4AGRG47cVM5IWv84URIkh8zz5vHUoU+NZ0J052MA+AUB5iWaUY9ZBLsAEG4G4t3
         9ByQ==
X-Gm-Message-State: AOAM532Dg2hrDx6OE7QwnbpliB5UAxIpx6zYI8vgxy+1LCROV0zqZSA9
        4tAvqW4acfCsPZ6gp42i3Y4Yqzrn
X-Google-Smtp-Source: ABdhPJwYdVRBcpl6U3kf5xQByOpr1kgV3Xvv9euCmgVc7oGku7ni7454Ck5KyafAba1sv25aMh5Dfw==
X-Received: by 2002:aa7:d613:: with SMTP id c19mr18945350edr.321.1591562275694;
        Sun, 07 Jun 2020 13:37:55 -0700 (PDT)
Received: from [192.168.43.135] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id u13sm9219699ejf.60.2020.06.07.13.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 13:37:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
 <20200601045626.9291-1-xiaoguang.wang@linux.alibaba.com>
 <20200601045626.9291-2-xiaoguang.wang@linux.alibaba.com>
 <f7c648e7-f154-f4eb-586f-841f08b845fd@linux.alibaba.com>
 <8accdc46-53c9-cf89-1e61-51e7c269411c@gmail.com>
 <9f540577-0c13-fa4b-43c1-3c4d7cddcb8c@kernel.dk>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v5 2/2] io_uring: avoid unnecessary io_wq_work copy for
 fast poll feature
Message-ID: <13c85adb-6502-f9c7-ed66-9a0adffa2dc8@gmail.com>
Date:   Sun, 7 Jun 2020 23:36:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <9f540577-0c13-fa4b-43c1-3c4d7cddcb8c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/06/2020 18:02, Jens Axboe wrote:
> On 6/3/20 7:46 AM, Pavel Begunkov wrote:
>> On 02/06/2020 04:16, Xiaoguang Wang wrote:
>>> hi Jens, Pavel,
>>>
>>> Will you have a look at this V5 version? Or we hold on this patchset, and
>>> do the refactoring work related io_wq_work firstly.
>>
>> It's entirely up to Jens, but frankly, I think it'll bring more bugs than
>> merits in the current state of things.
> 
> Well, I'd really like to reduce the overhead where we can, particularly
> when the overhead just exists to cater to the slow path.
> 
> Planning on taking the next week off and not do too much, but I'll see
> if I can get some testing in with the current patches.
> 

I just think it should not be done at expense of robustness.

e.g. instead of having tons of if's around ->func, we can get rid of
it and issue everything with io_wq_submit_work(). And there are plenty
of pros of doing that:
- freeing some space in io_kiocb (in req.work in particular)
- removing much of stuff with nice negative diffstat
- helping this series
- even safer than now -- can't be screwed with memcpy(req).

Extra switch-lookup in io-wq shouldn't even be noticeable considering
punting overhead. And even though io-wq loses some flexibility, as for
me that's fine as long as there is only 1 user.


And then we can go and fix every other problem until this patch set
looks good.

-- 
Pavel Begunkov


