Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BBD397766
	for <lists+io-uring@lfdr.de>; Tue,  1 Jun 2021 18:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbhFAQCz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Jun 2021 12:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhFAQCy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Jun 2021 12:02:54 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC9DC061574
        for <io-uring@vger.kernel.org>; Tue,  1 Jun 2021 09:01:13 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id h7so1787767iok.8
        for <io-uring@vger.kernel.org>; Tue, 01 Jun 2021 09:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WfmsydD/A8BiNqHr9XgI8dOVh8RAtY6UXqT7qqwK9X8=;
        b=Sy4bUKJmv2dkaIL+PnSyHaFU4M7Xr9P9mJvn6Azv/EzDtyYXU5e4kQOR/zL9HPytx0
         QcZQLccBYF3AOuCjlwiEYrfJFwxCg4R6vAfYO+mdPKzZ2hKkN8+kW/pNfZ7fha7bGtc0
         lReUE9y/DtyL5f1CPH7clx3gYrkTiss9eHWcVGYPQForWyzPVhp78WnxJWaFGW1TqTsF
         8lHVKPkfU5w2+/d1Zo4pnXdREZrzedwCTGDFvTon+M39PGpyV3qjMH5WbP/+KOd8yVkS
         9reEl/T7Ki7A5GhsHz7pTwnLguzyS4ZWpRxRhw497XP15S4nH6XiV3Ttf0fXoewKmIRj
         POzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WfmsydD/A8BiNqHr9XgI8dOVh8RAtY6UXqT7qqwK9X8=;
        b=XkPK0Iq+VdagaM7A9hqTBdragOZ7I8k9iw8rjW9FdYjFzmH5Lqrr7j50c++BpUDv/C
         jxNpDf7Mnoy9InHu4rFGH6p2rHswAIpCXOx9YIKqqMzSfE6PTNXdJOBCpr6ePkZL5Knx
         Vs55WwJ0QHhsE1hOr0ouVlpqVRR0b6tMxKS5cgbAeycWrEzqgtbaFpgkVjVIM4LKNm/o
         +G/9mCuIPOmM9L0Q4MUa8gNH3CnVmLvpZCmndthKm+dBpl5FrZjX46kJprjP/0Q6ocK5
         aYACfiH2K4QVF9gZu1o9PgzXKmCK0Tb3ZG6EfrphIi89IA448hdnYX283ILE/7OtzGZl
         TREA==
X-Gm-Message-State: AOAM531RJsXP+tmkce5yopt6vIa0a0cS33XHYmRSY+O9ziaqfkYhkdRp
        bJbD+sX78KgP+qzmEv0xJulcKg==
X-Google-Smtp-Source: ABdhPJy6KabpoFyW9fLH+Ch6zAs6yTCUjvg/QYLvTXzSZ2XwGs30TbFV6J3nia2b9uGkivg2kyHWQw==
X-Received: by 2002:a6b:690c:: with SMTP id e12mr21869176ioc.69.1622563272777;
        Tue, 01 Jun 2021 09:01:12 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o2sm9978840ilt.73.2021.06.01.09.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 09:01:12 -0700 (PDT)
Subject: Re: [RFC 4/4] io_uring: implement futex wait
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Andres Freund <andres@anarazel.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
References: <cover.1622558659.git.asml.silence@gmail.com>
 <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com>
 <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk>
 <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk>
Date:   Tue, 1 Jun 2021 10:01:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/1/21 9:58 AM, Pavel Begunkov wrote:
> On 6/1/21 4:45 PM, Jens Axboe wrote:
>> On 6/1/21 8:58 AM, Pavel Begunkov wrote:
>>> Add futex wait requests, those always go through io-wq for simplicity.
>>
>> Not a huge fan of that, I think this should tap into the waitqueue
>> instead and just rely on the wakeup callback to trigger the event. That
>> would be a lot more efficient than punting to io-wq, both in terms of
>> latency on trigger, but also for efficiency if the app is waiting on a
>> lot of futexes.
> 
> Yes, that would be preferable, but looks futexes don't use
> waitqueues but some manual enqueuing into a plist_node, see
> futex_wait_queue_me() or mark_wake_futex().
> Did I miss it somewhere?

Yes, we'd need to augment that with a callback. I do think that's going
to be necessary, I don't see the io-wq solution working well outside of
the most basic of use cases. And even for that, it won't be particularly
efficient for single waits.

-- 
Jens Axboe


