Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A950D3F3722
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 01:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbhHTXAx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 19:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhHTXAw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 19:00:52 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3600C061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 16:00:13 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k5-20020a05600c1c85b02902e699a4d20cso6925985wms.2
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 16:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+YxkoU+emqDLZSRsd89nqBlX18VB1WbWCyHYOeweU3o=;
        b=EOkTeWel0WgV9b07YkUSzv9fBeRoWHBNPZe1XePUwIG3DYOIYzjjhXQkUfAMbNXb4D
         ZIzR07H14HftSBwJ7aiSbK25rRJmiAk9fL0jqZhgLDnC2Ed2a/i+Hl7UcKKXY0qRK6Bn
         w3SeN1toIqg8Z818Qyw7N7fhrYiROlaseXqXVLn7EwVFsufm2ziqPA7tF4AEGXfFF+WK
         0m5Y3DokTC51AE966dAxekaMX3hL5oqwksScyvThIDU7IWR9ybAVCAt2mvUpY+WDpdbJ
         iGlzTxdToQCz0lD6g3QphAk4M/fnPO+XA+XV2Kc0EWIu4NJCQ/XWTtXg7vV7A3TlLxbJ
         b46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+YxkoU+emqDLZSRsd89nqBlX18VB1WbWCyHYOeweU3o=;
        b=U0rvF7s/ZJxcN+x4PHGP03wqVV823nRtWwgxflgST5SXD6M9cX/bGkfsxBg+NsWKJO
         nMs94nNgTSzAj438kfZgQyUXu2Av9+Cf9Muq/GTrYCIEpwXeGwh16RJA6xh6wHsIb9eD
         Veneaj8HqsvdsVEApEKJiLzmnW0OJTsBWHgMQYT4XMPndrxhgzCT1zZh/WBuKHimI0PO
         +x4GL+6VuQMzt4RFU1YqE+i2eC+KeO+Zf0cwFyZL8nSvYL0YNom3HdLhAIeQw0TEQKgQ
         +mjUl/1woUDkW2x6HHKL2PzvLo8iamcfbC90mzwHODEi+J8q+SIe+yJyLWicR2QjsZka
         LqUA==
X-Gm-Message-State: AOAM531UYBqiiC3CbEg7Hih7kwJz42oatSWMPrXeXS/9lWd4aMjgzs1q
        Ni/wHpvI5Y/U4X6g1aUtof0=
X-Google-Smtp-Source: ABdhPJxHWUuSrVdSAjopJ2MUZO+4OgZE+RyQN/qaoQB8rP+Bxwn6RNRP+875YT0WKPTiQKpkLV/vAg==
X-Received: by 2002:a7b:c041:: with SMTP id u1mr5671228wmc.95.1629500412513;
        Fri, 20 Aug 2021 16:00:12 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id c7sm6041962wmq.13.2021.08.20.16.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 16:00:12 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210820184013.195812-1-haoxu@linux.alibaba.com>
 <c2e5476e-86b8-a45f-642e-6a3c2449bfa2@gmail.com>
 <4b6d903b-09ec-0fca-fa70-4c6c32a0f5cb@linux.alibaba.com>
 <68755d6f-8049-463f-f372-0ddc978a963e@gmail.com>
 <77a44fce-c831-16a6-8e80-9aee77f496a2@kernel.dk>
 <8ab470e7-83f1-a0ef-f43b-29af8f84d229@gmail.com>
 <3cae21c2-5db7-add1-1587-c87e22e726dc@kernel.dk>
 <34b4d60a-d3c5-bb7d-80c9-d90a98f8632d@gmail.com>
 <5900a96e-541c-4dba-eb42-dc8c30f6d5ea@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH for-5.15] io_uring: fix lacking of protection for compl_nr
Message-ID: <a9f1d79b-9aa8-ea22-691e-5676230f7563@gmail.com>
Date:   Fri, 20 Aug 2021 23:59:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <5900a96e-541c-4dba-eb42-dc8c30f6d5ea@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 11:46 PM, Jens Axboe wrote:
> On 8/20/21 4:41 PM, Pavel Begunkov wrote:
>> On 8/20/21 11:30 PM, Jens Axboe wrote:
>>> On 8/20/21 4:28 PM, Pavel Begunkov wrote:
>>>> On 8/20/21 11:09 PM, Jens Axboe wrote:
>>>>> On 8/20/21 3:32 PM, Pavel Begunkov wrote:
>>>>>> On 8/20/21 9:39 PM, Hao Xu wrote:
>>>>>>> 在 2021/8/21 上午2:59, Pavel Begunkov 写道:
>>>>>>>> On 8/20/21 7:40 PM, Hao Xu wrote:
>>>>>>>>> coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
>>>>>>>>> may cause problems when accessing it parallelly.
>>>>>>>>
>>>>>>>> Did you hit any problem? It sounds like it should be fine as is:
>>>>>>>>
>>>>>>>> The trick is that it's only responsible to flush requests added
>>>>>>>> during execution of current call to tctx_task_work(), and those
>>>>>>>> naturally synchronised with the current task. All other potentially
>>>>>>>> enqueued requests will be of someone else's responsibility.
>>>>>>>>
>>>>>>>> So, if nobody flushed requests, we're finely in-sync. If we see
>>>>>>>> 0 there, but actually enqueued a request, it means someone
>>>>>>>> actually flushed it after the request had been added.
>>>>>>>>
>>>>>>>> Probably, needs a more formal explanation with happens-before
>>>>>>>> and so.
>>>>>>> I should put more detail in the commit message, the thing is:
>>>>>>> say coml_nr > 0
>>>>>>>
>>>>>>>   ctx_flush_and put                  other context
>>>>>>>    if (compl_nr)                      get mutex
>>>>>>>                                       coml_nr > 0
>>>>>>>                                       do flush
>>>>>>>                                           coml_nr = 0
>>>>>>>                                       release mutex
>>>>>>>         get mutex
>>>>>>>            do flush (*)
>>>>>>>         release mutex
>>>>>>>
>>>>>>> in (*) place, we do a bunch of unnecessary works, moreover, we
>>>>>>
>>>>>> I wouldn't care about overhead, that shouldn't be much
>>>>>>
>>>>>>> call io_cqring_ev_posted() which I think we shouldn't.
>>>>>>
>>>>>> IMHO, users should expect spurious io_cqring_ev_posted(),
>>>>>> though there were some eventfd users complaining before, so
>>>>>> for them we can do
>>>>>
>>>>> It does sometimes cause issues, see:
>>>>
>>>> I'm used that locking may end up in spurious wakeups. May be
>>>> different for eventfd, but considering that we do batch
>>>> completions and so might be calling it only once per multiple
>>>> CQEs, it shouldn't be.
>>>
>>> The wakeups are fine, it's the ev increment that's causing some issues.
>>
>> If userspace doesn't expect that eventfd may get diverged from the
>> number of posted CQEs, we need something like below. The weird part
>> is that it looks nobody complained about this one, even though it
>> should be happening pretty often. 
> 
> That wasn't the issue we ran into, it was more the fact that eventfd
> would indicate that something had been posted, when nothing had.
> We don't need eventfd notifications to be == number of posted events,
> just if the eventfd notification is inremented, there should be new
> events there.

It's just so commonly mentioned, that for me expecting spurious
events/wakeups is a default. Do we have it documented anywhere?

-- 
Pavel Begunkov
