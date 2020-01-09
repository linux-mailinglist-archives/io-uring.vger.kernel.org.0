Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82862135E10
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 17:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgAIQTb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 11:19:31 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37865 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729722AbgAIQTb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 11:19:31 -0500
Received: by mail-pj1-f67.google.com with SMTP id m13so1353299pjb.2
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2020 08:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/atdz/kfDUEeR7jOxD+lRMaL1oZCoJ+ayZt/VXNcDlw=;
        b=XvIXDIWxaXyiTZo0TgqlBOuCMUzrZqU3l14it/gGpXkJfyAGOuJ4kEplJ1L2CzUiRT
         2FxyI05lkm0cLJaRsdmsJuGP6K9+5BUDfysnkJMFwkYz9sopU7DbiDRS8yiZLJXRKn/m
         G+7j1mlA6IU9+AV7CtdMGfCtfVjSBw85qmNQh5LuThueXxCpEiVsn9EuMG8BOUw6q2GX
         /FrUFNPdczs7SYI8PgDy880OciEJ+J9PNbp83idE6YXj2kE3ECcxQrElxXEGv+gwURNq
         ezPZWMwZR9xG0zOa2aao1U+6knBtiDK70ZkMBwnvXndeLw9L1hHZ1uuLHDX9/78pI9qU
         anxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/atdz/kfDUEeR7jOxD+lRMaL1oZCoJ+ayZt/VXNcDlw=;
        b=Hcr5jYE9qcw84ZCNJ7CmqoQ7Iqfich+uzWxdF50igwWfv7AM1ZxY+cN0MWVhg7J9o2
         gkhcWZxZIDBQTYWeUP3yM6PeBGvJyNGF/OEDWKYDUUYvkdBjBEP4mhrRi/8WrFmrYeoO
         XZStp/TzdmMp6vULkclz7QtffmGigWzL0/0IIOf5EkfE+RFffO5p8Dp9G5FtmYbKVpvJ
         fEplssGv1w62Pa18OCWDycDMkTGq3bcrEzrC2x3wimDRXPFbnb8okl2lbfQN7UYjBX8h
         Tka8W1ObfkNSKDPo40cLQg2q2SMDU25GDjGwb+CwnnBBmbTr+WNnTrJu0KLa47z4zvbe
         l7pA==
X-Gm-Message-State: APjAAAVtmTqSiaDBy/Ch2/lt6Gb/E7iIuAeEDE34eU29S2GmyNNnFYN8
        e0uWcPAAxiWDdXYSWZj+Q+XqulPjieI=
X-Google-Smtp-Source: APXvYqxneciWIW5A9Xg3mbd0kd2M1dLE0WalEGeWanIg+9qJ39BjqGApf66V7kj8MLBB25+jjvKcmA==
X-Received: by 2002:a17:90a:cb8c:: with SMTP id a12mr6318936pju.71.1578586770003;
        Thu, 09 Jan 2020 08:19:30 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id r2sm7915363pgv.16.2020.01.09.08.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 08:19:29 -0800 (PST)
Subject: Re: [RFC] Check if file_data is initialized
To:     Dmitry Dolgov <9erthalion6@gmail.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20200109131750.30468-1-9erthalion6@gmail.com>
 <e6cd2afe-565f-8cde-652c-26c52b888962@gmail.com>
 <07aeb2b5-b459-746b-30a2-b63550b288df@kernel.dk>
 <20200109160449.jmhetf3p6f2lkp3d@localhost>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <87a1fbe9-9656-22f9-41fe-12eb8985c764@kernel.dk>
Date:   Thu, 9 Jan 2020 09:19:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200109160449.jmhetf3p6f2lkp3d@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/9/20 9:04 AM, Dmitry Dolgov wrote:
>> On Thu, Jan 09, 2020 at 07:51:28AM -0700, Jens Axboe wrote:
>> On 1/9/20 7:26 AM, Pavel Begunkov wrote:
>>> On 1/9/2020 4:17 PM, Dmitrii Dolgov wrote:
>>>> With combination of --fixedbufs and an old version of fio I've managed
>>>> to get a strange situation, when doing io_iopoll_complete NULL pointer
>>>> dereference on file_data was caused in io_free_req_many. Interesting
>>>> enough, the very same configuration doesn't fail on a newest version of
>>>> fio (the old one is fc220349e4514, the new one is 2198a6b5a9f4), but I
>>>> guess it still makes sense to have this check if it's possible to craft
>>>> such request to io_uring.
>>>
>>> I didn't looked up why it could become NULL in the first place, but the
>>> problem is probably deeper.
>>>
>>> 1. I don't see why it puts @rb->to_free @file_data->refs, even though
>>> there could be non-fixed reqs. It needs to count REQ_F_FIXED_FILE reqs
>>> and put only as much.
>>
>> Agree on the fixed file refs, there's a bug there where it assumes they
>> are all still fixed. See below - Dmitrii, use this patch for testing
>> instead of the other one!
> 
> Yes, the patch from this email also fixes the issue.

Great, thanks for testing, I'll add your Tested-by to the commit.

-- 
Jens Axboe

