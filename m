Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF83C34485C
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 15:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhCVO6P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 10:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhCVO6I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 10:58:08 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7BBC061574
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 07:58:07 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id f19so14227940ion.3
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 07:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MnKWy4e716jN9BFkrglHVe+ZofZs4CThsMNsuF3GTbs=;
        b=BsBlGLL9K2MHVYH/l4f5/Glu4cbNC0DN3gaxdJBrZf1bJBKJjx/Zk4rm6OMpLFjuj3
         l2jBBe/6seovqKu1ynAp+nK3kpOiYkAO0QGtYBAtJ/MqGLxYKGElBTCjbQ/C45DYER+X
         tu3RSX9Z+5pYr2R+uSCkm4/odPnKzjNOSidnTFrPeVLoPh9gjTscVdoRreHSE/MGJgPK
         rLEQFpJhaeeVUDDp+YohHfEn1LnVFEBDW9gTAOpzpspB9Zu7MRJ9nS/eC6uvDu6WdU/+
         iWuogGgRtkQKJ9Uq3jNUXYMVWer5Aboxd0jsjn+OnU7FoDyog2Re1t4/eGrg0UBet66Y
         qk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MnKWy4e716jN9BFkrglHVe+ZofZs4CThsMNsuF3GTbs=;
        b=MFJ5ZdNa9JjXUYrjxpv2dSTEphlqtHQa1WZAX0+hv/luHiVR9PUoFKvt6h4CnBleJj
         C36CPnZKs/sPWUqp38ZHuYEQLABPW0wfi29kKx5KpKWolK66mgTN7+sLhwlu7O4YTkb3
         Ju0+o+9bufQp1H3kY7rmXEU+//ZuEozgFd+WSmQ45/f7oa0hrp1ezyws7VK1G98AjrUR
         NZrkulHzmwTPWNox4dig/F2DKIV/hvWoJ3NKzI/P55buHmOFp7sv/oNrfm9zfYjR49VE
         ZbmNdFxw4OB2QQIbg4mA7Ptqm6I5/W7Cf+QLdn7leLoKmKLD4SG4cWiZhVZB8w1yf2yE
         yatg==
X-Gm-Message-State: AOAM530f/E/et6SMRysIjBDVL5meVPRieQYqAU9HOGPmMIRnfS8pq2aG
        2/LwXFubDZJRlbM8G4fRZ8gLUqBS1zvj6Q==
X-Google-Smtp-Source: ABdhPJz+yNURMPJFh7IJ3RbW4n63ANmsxGInRNHkEtYUvuhcskpzELhtlYNftDF1WmsYE7YyfMcOkg==
X-Received: by 2002:a5d:9245:: with SMTP id e5mr111338iol.97.1616425087070;
        Mon, 22 Mar 2021 07:58:07 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 23sm7977190iog.45.2021.03.22.07.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 07:58:06 -0700 (PDT)
Subject: Re: [PATCH 03/11] io_uring: optimise out task_work checks on enter
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1616378197.git.asml.silence@gmail.com>
 <ff3273b5111fdb10eea0e3d4f81f620fb58c5a5b.1616378197.git.asml.silence@gmail.com>
 <e8da4108-21a1-62b4-5556-bc9208e930f3@kernel.dk>
 <75e9acac-7fb7-747c-9832-3abcd0dfdfd9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b27d9aa9-ce7e-d393-3a79-df99b717986f@kernel.dk>
Date:   Mon, 22 Mar 2021 08:58:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <75e9acac-7fb7-747c-9832-3abcd0dfdfd9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/22/21 8:53 AM, Pavel Begunkov wrote:
> On 22/03/2021 13:45, Jens Axboe wrote:
>> On 3/21/21 7:58 PM, Pavel Begunkov wrote:
>>> io_run_task_work() does some extra work for safety, that isn't actually
>>> needed in many cases, particularly when it's known that current is not
>>> exiting and in the TASK_RUNNING state, like in the beginning of a
>>> syscall.
>>
>> Is this really worth it?
> 
> Not alone, but ifs tend to pile up, and I may argue that PF_EXITING in
> the beginning of a syscall may be confusing. Are you afraid it will get
> out of sync with time?

Not really worried about it, just don't like that we end up with two
functions for running the task_work, where one has a check the other
one does not.

-- 
Jens Axboe

