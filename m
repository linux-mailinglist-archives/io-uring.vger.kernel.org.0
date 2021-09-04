Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729654008DF
	for <lists+io-uring@lfdr.de>; Sat,  4 Sep 2021 03:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350793AbhIDA6g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 20:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350743AbhIDA6f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 20:58:35 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439FEC061760
        for <io-uring@vger.kernel.org>; Fri,  3 Sep 2021 17:57:35 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 17so685811pgp.4
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 17:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xz8nnMXJDbBJ194DuFd2giPN2/XCiMv/EpcFRaBE6MY=;
        b=E1TWI6Ez3mIdBOoL2FupyZ48lierRN65SgA5BnsjL+J1/Fk0hqr7Cooy/423gpEEx4
         wJ9hhxRfBm5TTDdegOPMDKBlcmU2UA7U85KarR38qj8SXMGSZGfAk/RrOwwwd6nW/mkd
         M/k2tDotI/DtUQS+byWW1drSD5ELfWG1CuXoQONM0hEtVsZ0MbWXgCT/0Q3ehGBK/NDy
         XHSzqjUz4PyjSnwpiP7JCC5H3PtYRZjouVN16PB2uRHF0LwIxp0O++1jvZA97uouBYFF
         iv/LCi8oOo/4OyAAyGCCy3gWsSB5ydaRJq63kd1KDp6A+WkxoF2GSTnsJ5wmU+iqJiv0
         i3yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xz8nnMXJDbBJ194DuFd2giPN2/XCiMv/EpcFRaBE6MY=;
        b=h08nbUF3u8dZuV1hC5w7jgCwH/uurI6BXkO9C9i4WjKvQrxljqFg7pSQWagSaSEzeA
         gIZqF5t4z8Yd6b8ZpVQRmVU0A+MtS0iYNJ0sy66bCca+040oFS9qm8MrUFF5Uz/Jiaj0
         +LaBSHtOb3WqDwLvRhdlWnNlLYw4cK/Ie1be6WR6c/PZbn7xthJT7Dfy00lNQxCQZ945
         +UZDlCC/zBT/BD7p8KjhabsgzNjzWJ3JdRG53hpoWXk+0pWk1ykf76m66JRLfVUKsliQ
         tAdMXBnE4Y5/SiqzG4W+Vat/0inVAP1QpiNWNqm2SVaKtiAXB3nZQFQc9hFAnin2cT8a
         3nmg==
X-Gm-Message-State: AOAM5314YFbie4MrDQJLI33THs9zuC48Cz+UxRFgTcTV5b+lJLsWrmMX
        RXSsReYz6oFd1caYRwrAwOQ4RQ==
X-Google-Smtp-Source: ABdhPJxIsJlvuvYIM8B6AsXvLN1fN3cBDhbb0TBx4LLOltAWG1KofE7Ic2zbjANygN590SztlOa0pQ==
X-Received: by 2002:a05:6a00:1c65:b0:412:f893:fc6d with SMTP id s37-20020a056a001c6500b00412f893fc6dmr1288038pfw.8.1630717054524;
        Fri, 03 Sep 2021 17:57:34 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id p10sm527113pge.38.2021.09.03.17.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 17:57:33 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] iter revert problems
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
References: <cover.1629713020.git.asml.silence@gmail.com>
 <65d27d2d-30f1-ccca-1755-fcf2add63c44@kernel.dk>
 <YTKZwuUtJJDQb8F+@zeniv-ca.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <72e3c837-8e44-8bc3-36c2-4a8682892a62@kernel.dk>
Date:   Fri, 3 Sep 2021 18:57:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YTKZwuUtJJDQb8F+@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/21 3:55 PM, Al Viro wrote:
> On Fri, Sep 03, 2021 at 02:55:26PM -0600, Jens Axboe wrote:
>> On 8/23/21 4:18 AM, Pavel Begunkov wrote:
>>> iov_iter_revert() doesn't go well with iov_iter_truncate() in all
>>> cases, see 2/2 for the bug description. As mentioned there the current
>>> problems is because of generic_write_checks(), but there was also a
>>> similar case fixed in 5.12, which should have been triggerable by normal
>>> write(2)/read(2) and others.
>>>
>>> It may be better to enforce reexpands as a long term solution, but for
>>> now this patchset is quickier and easier to backport.
>>>
>>> v2: don't fail if it was justly fully reverted
>>> v3: use truncated size + reexapand based approach
>>
>> Al, let's get this upstream. How do you want to handle it? I can take
>> it through the io_uring tree, or it can go through your tree. I really
>> don't care which route it takes, but we should get this upstream as
>> it solves a real problem.
> 
> Grabbed, will test and send a pull request...

Thanks Al! We should mark these for stable as well.

-- 
Jens Axboe

