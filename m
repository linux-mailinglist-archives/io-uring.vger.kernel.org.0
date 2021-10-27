Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D611F43C379
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 09:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbhJ0HI3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Oct 2021 03:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbhJ0HI3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Oct 2021 03:08:29 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45819C061570;
        Wed, 27 Oct 2021 00:06:04 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id m14so1830898pfc.9;
        Wed, 27 Oct 2021 00:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=u5MIYd+O5hYq/ovFrZ8EB6uv6EHBwk1t2oUT+vqCmdk=;
        b=PKKiAviweRIkeGOXg+k99xLQYU0hND1oyvi/fu609NPXLjKQA9WeeWm1FPvARbPZjV
         HBiWY4HtSokG90jZcD7uSOIFen53hG6zyg7tJpMlcqQWbQmHu+KGmFRpqPEzxSs+k352
         7QrkbzYbHQgxNlQtb/cGajXtsYvno8yvaRaamGtOncoN0JVz62zxY7aBESSDPm4Ubpnj
         eoNVf+GBbghhIOO0tQHGbLSzv0iT7MtlKECa6JvIrGSZr93OulENxjbjwWThC9NZylSX
         2Br5WUupaHXhnljonHfbC6ZCRss3Zf07XEXpqSi8quxiNhnDHJN8NCXM/+IMof62QP1+
         Xd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=u5MIYd+O5hYq/ovFrZ8EB6uv6EHBwk1t2oUT+vqCmdk=;
        b=2coLuJ/UETliDMr+hxoZ+3SpdYztgZYRUxjk33OBDC9PfENgXIqb1KdGeU1FzC1aff
         EJOT1MWt9tzQriw1InxUq9xESLIiyMqBg5fPpwGZoY4koy0i9impg9aOBMi5/NNiFuBv
         n3eErQF7G2drbG5J/2TtDLqyvhIeWI4lZIxkvifuuPp3Yl/0qEEKaNTrQ/CULKPfG/xI
         fkbq8xxlzvnWOYT/W7QiPo5+JgVY4+tWqDXOBwY8gPI4KWNXJEtrq39Xv37xtdI4pvgU
         IWfWgBeGhaXqkA5mlhQXpwQWofppgwHaYHL44plNOv8pzEFE/lWQflF42ULc9JmUmXZ+
         I5Sg==
X-Gm-Message-State: AOAM530OXocCdpm3FhIga8d+eM0ysCe1LVQTVhhe+AIrsRKk9mKR8/Sb
        9FuI+0B1B7lkmuAfsjE59vVM+W5PzfX3pw==
X-Google-Smtp-Source: ABdhPJybHXPnSmGSka+1MoR/ets4gn1VHoOZag3l2n7NzsVqdTwcF4M/3GxCCZmmvvLX507ILpamrg==
X-Received: by 2002:a63:e446:: with SMTP id i6mr23180230pgk.288.1635318363356;
        Wed, 27 Oct 2021 00:06:03 -0700 (PDT)
Received: from [172.18.2.138] ([137.59.101.13])
        by smtp.gmail.com with ESMTPSA id a8sm7572790pgd.8.2021.10.27.00.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 00:06:02 -0700 (PDT)
Subject: Re: [PATCH] io-wq: Remove unnecessary rcu_read_lock/unlock() in raw
 spinlock critical section
To:     Jens Axboe <axboe@kernel.dk>,
        Muchun Song <songmuchun@bytedance.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20211026032304.30323-1-qiang.zhang1211@gmail.com>
 <CAMZfGtUXq=nQyijktRaP7xp=sAmVCryTjU4Jo5Z=ufed8arnKQ@mail.gmail.com>
 <0efbce2d-1f63-82a7-6479-d8ef062aa90d@kernel.dk>
From:   Zqiang <qiang.zhang1211@gmail.com>
Message-ID: <c4bcf2fa-b72a-5e3a-efe9-544457a9816a@gmail.com>
Date:   Wed, 27 Oct 2021 15:06:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0efbce2d-1f63-82a7-6479-d8ef062aa90d@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 2021/10/26 下午10:47, Jens Axboe wrote:
> On 10/26/21 4:32 AM, Muchun Song wrote:
>> On Tue, Oct 26, 2021 at 11:23 AM Zqiang <qiang.zhang1211@gmail.com> wrote:
>>> Due to raw_spin_lock/unlock() contains preempt_disable/enable() action,
>>> already regarded as RCU critical region, so remove unnecessary
>>> rcu_read_lock/unlock().
>>>
>>> Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
>>> ---
>>>   fs/io-wq.c | 2 --
>>>   1 file changed, 2 deletions(-)
>>>
>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>> index cd88602e2e81..401be005d089 100644
>>> --- a/fs/io-wq.c
>>> +++ b/fs/io-wq.c
>>> @@ -855,9 +855,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
>>>          io_wqe_insert_work(wqe, work);
>>>          clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
>>>
>>> -       rcu_read_lock();
>> Add a comment like:
>> /* spin_lock can serve as an RCU read-side critical section. */
> Note that it's a raw spinlock. Honestly I'd probably prefer if we just leave
> it as-is. There are plans to improve the io-wq locking, and a rcu lock/unlock
> is pretty cheap.
>
> That said, if resend with a comment fully detailing why it's OK currently,
> then I'd be fine with that as well.
>
Thanks Jens Axboe, Muchun

  I  will  add a comment fully detailing and resend.



