Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F3C4A9183
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 01:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239553AbiBDAQB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 19:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355764AbiBDAQB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 19:16:01 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F8BC061714
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 16:16:01 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id h23so3634409pgk.11
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 16:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=efrA0nfqvc7zMWFpa4GfAQVSk6pSwKEuqGuv155lv+c=;
        b=2UU6nQWbWC914x6PRqAMumJXJg4W3WmyOnfnZSyol+FxNCbDYQzadR09gqiqt6GG2H
         CD4RIO5d/AuIiiH9NzLcvz6R+7udRd7g2D/Aym1TvvbLj/NdGyCZJqLkbvJAMr2LWb+5
         y6O7cwvwt4m+dpjcj9CuGoz2JssjDeaqsvNxLv7TxnsRfRojbeqfTUhuDDm5hHQ1VsUu
         owlauUw0v7OhCE6NpQNzotpt9irqvO1TpLS8L2qQ6hfFwSFH1Uwz0Eg4Izc42UU/OAK5
         hV+XBvfNEI5RLILq4HSIi7/o9sQGx8zVfiGVKPxMnyFK0RUaI/axuR1vElqGyN7vMvCY
         Xghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=efrA0nfqvc7zMWFpa4GfAQVSk6pSwKEuqGuv155lv+c=;
        b=fObw9kNb0doB4o8rLSPhyhNpKn2kPOchlbSQZTYuIl9Xst3fW5JVf6sqzjMWsULViI
         EqxZnrDTxRLJZ9ugaIxBC73aPo8hFHu7zDiQ2tZmAjH5F7U810nhFEO+r19wJY1+K5XE
         hxf8ciyEW3mCpVoWJKN/PHIbC9xJGpmYRPZs8ycBpT72SL8XJB1ecCqSaYVJ6OB23KAT
         cJaS/wRZDW1dfZQiI7K/pup/GoBTmzbx66i7JXUgG59GYckuE3tj3fjSn2bsFzhdX7bj
         ZUG55m5V6he1l9x+ynwcsQHmflmBng7Ho+8uhSixwxLl0UX5IV/YVBmqgfSijHgTHQV0
         jvuQ==
X-Gm-Message-State: AOAM531siQlHQZrqEUr+Ys43goa2dcU4Kq/fpyaQGZ1KzsSR17a3Oe0y
        PaaPZp0cTLqOUARjzbrJCImQtLORvOAYJQ==
X-Google-Smtp-Source: ABdhPJzz1nkhO1leBcWbPYC4nAYL/DtPafSGAmRTfmi2eHCxdSjfEMkrBtLukAVutTBtSvPCLy8JBg==
X-Received: by 2002:a65:538e:: with SMTP id x14mr448133pgq.58.1643933759633;
        Thu, 03 Feb 2022 16:15:59 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id ck21sm110090pjb.51.2022.02.03.16.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:15:59 -0800 (PST)
Subject: Re: [PATCH v5 0/4] io_uring: remove ring quiesce in io_uring_register
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Usama Arif <usama.arif@bytedance.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203233439.845408-1-usama.arif@bytedance.com>
 <16997265-18fa-64db-32e2-4af7f4dc3e4c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c2f05b78-1f81-32f9-79df-06d35d9dbc7a@kernel.dk>
Date:   Thu, 3 Feb 2022 17:15:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <16997265-18fa-64db-32e2-4af7f4dc3e4c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 5:02 PM, Pavel Begunkov wrote:
> On 2/3/22 23:34, Usama Arif wrote:
>> For opcodes relating to registering/unregistering eventfds, this is done by
>> creating a new RCU data structure (io_ev_fd) as part of io_ring_ctx that
>> holds the eventfd_ctx, with reads to the structure protected by
>> rcu_read_lock and writes (register/unregister calls) protected by a mutex.
>>
>> With the above approach ring quiesce can be avoided which is much more
>> expensive then using RCU lock. On the system tested, io_uring_reigster with
>> IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
>> before with ring quiesce.
>>
>> The second patch creates the RCU protected data structure and removes ring
>> quiesce for IORING_REGISTER_EVENTFD and IORING_UNREGISTER_EVENTFD.
>>
>> The third patch builds on top of the second patch and removes ring quiesce
>> for IORING_REGISTER_EVENTFD_ASYNC.
>>
>> The fourth patch completely removes ring quiesce from io_uring_register,
>> as IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS dont need
>> them.
> 
> Let me leave it just for history: I strongly dislike it considering
> there is no one who uses or going to use it.

Are you referring to the 4th patch? Or the patchset as a whole? Not clear
to me, because eventfd registration is most certainly used by folks
today.

> Even more, I can't find a single user of io_uring_unregister_eventfd()
> in liburing tests, so most probably the paths are not tested at all.

That's definitely a general issue, not related to this patchset.
Something that most certainly should get added! Ring exit will use the
same unregister path for eventfd, however, so it does get exercised from
there with existing tests too.

But for this change, we definitely need a test that exercises both
register and unregister, trying to trigger something funky there.

-- 
Jens Axboe

