Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65A23EB661
	for <lists+io-uring@lfdr.de>; Fri, 13 Aug 2021 15:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240188AbhHMN5J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Aug 2021 09:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240181AbhHMN5J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Aug 2021 09:57:09 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E132C061756
        for <io-uring@vger.kernel.org>; Fri, 13 Aug 2021 06:56:42 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d1so12116035pll.1
        for <io-uring@vger.kernel.org>; Fri, 13 Aug 2021 06:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fuv7XNX1kRU3NHTjxzKEeK1xu1WKXKc1A49QEj2NUzM=;
        b=ZBQCQ57JlZfCp4iUgCva2CiXIM/FbV3h3xGg/b2HFsofVIEJRswSEvpHzafhIjwXzl
         xIWY1a04/QpCJM/EN/ASXV6NGdTHIdxFDBRI0i6HVjJTKTFufVoTMUaAsCPgjONDFF86
         +CfafjGOdbw4sx2XKKUO8D0YAHZ1/fuqPMg+Iv4esiBRsVK2UDC2KZMoszolFWNGdvHB
         NRo6RuMY8ansYcPT/YvgAiFn5xO/WyJbneW/AxxGmQ1Glu34rqUKE7J54rxUEXz3+ktQ
         pIBKajYobPB0tRDq7ZZPpHA6t0zZww6DemRLjXAc0SqvfktWfWr+tiz2gDOg89xJnvkx
         IIBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fuv7XNX1kRU3NHTjxzKEeK1xu1WKXKc1A49QEj2NUzM=;
        b=mA3vA/62qGmrlpOW4SKcNrYIlP3kj1vf68qIU6S8OravE1L99Ngrl8gbuJ4qGzzvMA
         6SU4GXgkZgJauj2+IgKHBRIPrjpiZ0E4PqPMHwskR2jFXwwUCiKGQ7Tla1asy6InSTct
         WaJw5I79oQVYh3Z322WGEMK8+9/oYjo7N4xtu0YY8ylDU6b5T5PqIpsf0d5oYuX3JIpn
         UYB6cPKJnaBn6EenVPwPMrO24DwrDWeiw9qxs7trdlBC9JSJW5qCoeWyejBZnuFp9TVU
         y1HCZYor+nSGfZNgKpjfr/R1BLIEkYHsGZVly3DpQA/WZ0DzLZY4MAzbSfP5JmFMRFfI
         8r1A==
X-Gm-Message-State: AOAM531jU8y5UGLfz1Lxmieo414MO9mBSfUJTgSPJayvRQgFAeDC6srk
        yy6gqdKKtza08X7byVnWKMHNBg==
X-Google-Smtp-Source: ABdhPJw71Ouq55se08gw12pJ05f4Xcn+58aJ3u4tQFOtHeEpCE68u2HVtlVrT2EpMT7ADLoAk18WxQ==
X-Received: by 2002:a17:90a:4a88:: with SMTP id f8mr2852330pjh.226.1628863001847;
        Fri, 13 Aug 2021 06:56:41 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id u21sm3179455pgk.57.2021.08.13.06.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 06:56:41 -0700 (PDT)
Subject: Re: [PATCH for-5.15 0/3] small code clean
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210812041436.101503-1-haoxu@linux.alibaba.com>
 <577c70e9-e40d-c3df-2072-e0bcfe5f75dc@kernel.dk>
 <1d285d12-e40a-9472-bc78-9cb630c6595a@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <90fce498-968e-6812-7b6a-fdf8520ea8d9@kernel.dk>
Date:   Fri, 13 Aug 2021 07:56:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1d285d12-e40a-9472-bc78-9cb630c6595a@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/13/21 1:58 AM, Hao Xu wrote:
> 在 2021/8/13 上午1:28, Jens Axboe 写道:
>> On 8/11/21 10:14 PM, Hao Xu wrote:
>>> Some small code clean.
>>>
>>> Hao Xu (3):
>>>    io_uring: extract io_uring_files_cancel() in io_uring_task_cancel()
>>>    io_uring: remove files pointer in cancellation functions
>>>    io_uring: code clean for completion_lock in io_arm_poll_handler()
>>>
>>>   fs/io_uring.c            | 15 ++++++---------
>>>   include/linux/io_uring.h |  9 +++++----
>>>   kernel/exit.c            |  2 +-
>>>   3 files changed, 12 insertions(+), 14 deletions(-)
>>
>> This looks good, except 3/3 which I think was rebased and then not
>> re-tested after doing so... That's a black mark.
>>
> Actually I re-tested it after rebasing code and addressing the conflict
> But the liburing tests results seems all good. Anyway, I'll check the
> code more carefully when resolving conflict.

Probably would only complain if you had PROVE_LOCKING enabled in
your config.

The last patch broke !CONFIG_IO_URING too, I fixed that up.

-- 
Jens Axboe

