Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC9B3FCB92
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 18:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240032AbhHaQjg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 12:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240075AbhHaQjf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 12:39:35 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68862C061760
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 09:38:40 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d26so122445wrc.0
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 09:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VLHWj68WkOTtqwAIIat8TMENu3QnqP3jtlzqVrgqOAs=;
        b=mnTn4t7VidYLRM1gu3jCPUYhNBkg7sn90Xpqwgir9f86f4xViu4K8cmUpAIQsvXMW2
         ddZTnzIuaKxPsQ4t3QpvIiq9au6ap3rhcVdxhaguJWGusQ9EnVu5pk3wQwR/BZvgNfwb
         I5ZK9hpij2yl7z6Pb+gqrQGYJLWkh56HJOLdylDULRC0zuM/+LH4stdOzINhdbWfLdCj
         XCx/766XLen2hgONopmL8kVirdm9UhMj5LR2C8W/+XhBVADUaChGEa3q3IjeT3/1UxOd
         DBY/W1b4am2PWD/LriFu+hY5ZdiYUZgZ9speuGFWzYGC6hdULCaK0rrwNe6lSvddgjaS
         f++w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VLHWj68WkOTtqwAIIat8TMENu3QnqP3jtlzqVrgqOAs=;
        b=Z+RgnJlPVmHbZyTuylOvNnQ+ggOxh9oVZYjCx1sQQ6cRULS+P5fMEbMNNWhmi+kq0S
         f/H25mABvIJC8xBrInNeWqUsxb2YyhyhS9NNy2u6TV4EM5LBNUbMseqMWtd/Bk5pMOxE
         MxRq4Es8J1o2iSIEUkDg60wmanhNehR4hqAT/y3zsGX5FKV+RtxX5K95iBWaySa4/L9e
         /0bk/FoQDndqnYhpUvWyqMeab2ZotfIE0abXFnjgLyG1OVAYBqqtMGeaoWJ8OJesx0yF
         BhLqrqINmI/sw4Ng3ZfNT5Aq6hpIxtBY3zRYtwFe1KfyRi/SDjrlOHTNfWk7r/LayCGN
         FdIQ==
X-Gm-Message-State: AOAM531pwzhJL9n1rEmwz9IYlEXin2FbAcOeeZnc8sk6PHikG9hB0kbN
        hAuvtZTIMVd0j6PYoH8xudcdvS6V55I=
X-Google-Smtp-Source: ABdhPJxe9Zfs9Yk4M15cls2w4Bzvf+6bUtqKwuODHLPJBH7rXqtuJ5q2Bzfrl1JQ7I+c/5FnrzU4wg==
X-Received: by 2002:a5d:438a:: with SMTP id i10mr32337301wrq.285.1630427918905;
        Tue, 31 Aug 2021 09:38:38 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id n1sm18439457wrp.49.2021.08.31.09.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 09:38:38 -0700 (PDT)
Subject: Re: [DRAFT liburing] man: document new register/update API
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <17729362b172d19efe3dc51ab812f38461f51cc0.1630178128.git.asml.silence@gmail.com>
 <18f42215-e1e1-fcb4-1d3a-cae75812a0b6@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <32a0e756-dca3-7a01-7132-c0e96cdac2e7@gmail.com>
Date:   Tue, 31 Aug 2021 17:38:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <18f42215-e1e1-fcb4-1d3a-cae75812a0b6@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/28/21 8:35 PM, Jens Axboe wrote:
> On 8/28/21 1:18 PM, Pavel Begunkov wrote:
>> Document
>> - IORING_REGISTER_FILES2
>> - IORING_REGISTER_FILES_UPDATE2,
>> - IORING_REGISTER_BUFFERS2
>> - IORING_REGISTER_BUFFERS_UPDATE,
>>
>> And add a couple of words on registered resources (buffers, files)
>> tagging.
> 
> Just a few comments below.

Thanks for taking a look, not going to pretend that I'm good at it :)

[...]

>> +.PP
>> +.in +8n
>> +.EX
>> +struct io_uring_rsrc_register {
>> +    __u32 nr;
>> +    __u32 resv;
>> +    __u64 resv2;
>> +    __aligned_u64 data;
>> +    __aligned_u64 tags;
>> +};
> 
> Move this up to where it's initially mentioned?

Do you mean a couple of lines up? like this? 

.I arg
points to a
.I struct io_uring_rsrc_register.

<struct definition section>

.I nr_args
should be set to the number of bytes in the structure.

-- 
Pavel Begunkov
