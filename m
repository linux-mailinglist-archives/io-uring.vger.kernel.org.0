Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0333447ED
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 15:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhCVOtw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 10:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhCVOtX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 10:49:23 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE229C061574
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 07:49:22 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id k25so2088146iob.6
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 07:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zbmqmyP4vA69N/YXo4MMAZFgfhUCEg914AmEuMVnxP4=;
        b=ZnypxfODvzxR31UKGqi06d1fFdGF15NlAaZAObOg2So+kEhARUeuljNu4VcPpQYK3N
         45bzdq67oaIlIWKIE82Qt/NQOhwrYJT72Mspp19ridM8/CyvKtc6CqDczpAj0ZU0wiQ1
         cHt4IKxbnugj5a2YVSQKCRvKVPDSD1oMYa8H2lvpzVHO53oCkwD5r3dP5j5E3q8sR9Ws
         PT/9kRKKhLQ15AWNxkSeAIFiqwv1HoqKDIdhKSVg6xhMj8OgqxpLmO1ZrE4brh/YnM1F
         Vc6UFmbqlcvM7YxRVzzjuyraCLKHBVG3OWU9RPC/hom/oyVa20SWUlHXeJZY3GQHCCFp
         wqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zbmqmyP4vA69N/YXo4MMAZFgfhUCEg914AmEuMVnxP4=;
        b=aAtJus6EmV5zBgK7ZHeI2Bc4dfT1h8xwtuHE/TtfSSUR/TeGnPFwXN/LsaMcH5vk8J
         MXP5c/L2eoNHWtVdNRFYXnPxLi7DZkvDpHrrHEV9CkBfnUcDoqciVxuWPd2rYAzcQYUn
         t1l4w1Thn7bkXaW0T4AacW9FnMD2OMqLWX7Oa5kcS+GB2BZgb5mpyO/L4fCpvEdvglfE
         +d8HISwpQmYRq0wGnfaYoUZTu92nhb22KBMJmJdLOkvYkhr18FRZo5RQCnFnJ1UMcbja
         Ff4dKn7ttAdwXQujccDabYudRqwoY4WBJjV0IvkwJDyDdRU+1IAscaVauezW1JYjVRf/
         TCNQ==
X-Gm-Message-State: AOAM532Cuc8QEUbU4LzrgqPhtEvWmxO8ZKL9Q9gCd/v7h7fCnr37aJud
        hq43aBASXgNgLRx4PETHoyWuO+OeObfe2w==
X-Google-Smtp-Source: ABdhPJwrqmoIazQd1kNxOBHagoHgpZk1uPjZ4TWiP8NljLKfK8UIyGfj+CU9imjzs3MiO6VcvbOblg==
X-Received: by 2002:a02:7119:: with SMTP id n25mr11688793jac.48.1616424562309;
        Mon, 22 Mar 2021 07:49:22 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k12sm7704852ios.2.2021.03.22.07.49.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 07:49:21 -0700 (PDT)
Subject: Re: [ANNOUNCEMENT] io_uring SQPOLL sharing changes
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Hao Xu <haoxu@linux.alibaba.com>
References: <ca41ede6-7040-5eac-f4f0-9467427b1589@gmail.com>
 <30563957-709a-73a2-7d54-58419089d61a@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1afd5237-4363-9178-917e-3132ba1b89c3@kernel.dk>
Date:   Mon, 22 Mar 2021 08:49:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <30563957-709a-73a2-7d54-58419089d61a@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/21/21 11:54 PM, Xiaoguang Wang wrote:
> hi Pavel,
> 
>> Hey,
>>
>> You may have already noticed, but there will be a change how SQPOLL
>> is shared in 5.12. In particular, SQPOLL may be shared only by processes
>> belonging to the same thread group. If this condition is not fulfilled,
>> then it silently creates a new SQPOLL task.
>
> Thanks for your kindly reminder, currently we only share sqpoll thread
> in threads belonging to one same process.

That's good to know, imho it is also the only thing that _really_ makes
sense to do.

Since we're on the topic, are you actively using the percpu thread setup
that you sent out patches for earlier? That could still work within
the new scheme of having io threads, but I'd be curious to know first
if you guys are actually using it.

-- 
Jens Axboe

