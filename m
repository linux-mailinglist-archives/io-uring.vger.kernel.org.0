Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA6A1C3F79
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 18:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbgEDQMM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 12:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728655AbgEDQMM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 12:12:12 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881E9C061A0E
        for <io-uring@vger.kernel.org>; Mon,  4 May 2020 09:12:10 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id i19so12872544ioh.12
        for <io-uring@vger.kernel.org>; Mon, 04 May 2020 09:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=03zROLnx2fSxbZ/3k0dXZwjojIAg6i8ytOSzzMhfDBY=;
        b=Ou6U7n84j8PoYdi8hmYMprEa6GXpDHf1drLqeqUfCgIbWCZq0oCnWEQeRs4IGgpqxN
         0GZ6etqprwmnb/7RVOjVX1nfVjb+ZF1KjnHQikTb3f35qU30fjSa6zgsvecUNB3LEv5Y
         zJf2ZKxwM0Bsxnb5CNnf0AqcJK9/hVs0B9yVlqq5446BKpuRuZtkbObeQO8Xvp9d0J/I
         v7unq/Aqq4w/4G/cl3Cs4nHyvqH55IHWK/xxalztY3hkbr+Em579DPIo7pu4IyUBxh4e
         P93V5tZD7bBTEr0l79MECXRq1gwIxJtUzLjGEqMGNP+3UBGsIB+iu/VEIo9cqM+CfgyI
         Phow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=03zROLnx2fSxbZ/3k0dXZwjojIAg6i8ytOSzzMhfDBY=;
        b=RF4488L34s3AnuOcpBPC/JSi1bNKcmYUJ5tPgvuhikvw/CesiYKiHzfbA+7bXzrXDe
         W8giIZVSrNgnfkbYZsOepXOejCu1+nNITu0/ZoVATpM1R9flPGnTFhKxkA+Yecn34ojd
         fnlqbsE/qGXbCIif7U8INoKj2uv8PrCDSM6moeBwfIDBjhdB7J/Fn8dSXMRrhDH5tIj8
         YrAuXMuN0n7v6vjHh+US3Rq95lnrhTcc43XDb3WSrKHmrQMVlWYUIDXCkSVMqrSnuSaQ
         OQ4MISR0NjYmVsg7sh/IwkkZqcxCvhzibqjG1FyTgvsY9TuDfBH5avzfJVC9ebWZtiu/
         4auw==
X-Gm-Message-State: AGi0PuZG5ok8+j9sLAvRrilYip892PUKZf/FKnHwF1ccCNOh5S3yYn1s
        G+Y1Tziankykp+6WvGifxyFB0eOfAkE2rQ==
X-Google-Smtp-Source: APiQypJ1mjDPnLS48YNSQ9Py1yTU8TmEUdDm53R94aBVtwczLUifpGDNvorOAHJzyzV9NLJUhhxbDw==
X-Received: by 2002:a5d:8b02:: with SMTP id k2mr16052502ion.39.1588608729001;
        Mon, 04 May 2020 09:12:09 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c12sm5296238ilo.31.2020.05.04.09.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:12:08 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: use proper references for fallback_req
 locking
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <1588207670-65832-1-git-send-email-bijan.mottahedeh@oracle.com>
 <05997981-047c-a87b-c875-6ea7b229f586@kernel.dk>
 <07fda8ac-93e4-e488-0575-026b339d2c36@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <84554b60-2ec5-9876-79ce-5962ae5580e4@kernel.dk>
Date:   Mon, 4 May 2020 10:12:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <07fda8ac-93e4-e488-0575-026b339d2c36@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/3/20 6:52 AM, Pavel Begunkov wrote:
> On 30/04/2020 17:52, Jens Axboe wrote:
>> On 4/29/20 6:47 PM, Bijan Mottahedeh wrote:
>>> Use ctx->fallback_req address for test_and_set_bit_lock() and
>>> clear_bit_unlock().
>>
>> Thanks, applied.
>>
> 
> How about getting rid of it? As once was fairly noticed, we're screwed in many
> other ways in case of OOM. Otherwise we at least need to make async context
> allocation more resilient.

Not sure how best to handle it, it really sucks to have things fall apart
under high memory pressure, a condition that isn't that rare in production
systems. But as you say, it's only a half measure currently. We could have
the fallback request have req->io already allocated, though. That would
provide what we need for guaranteed forward progress, even in the presence
of OOM conditions.

-- 
Jens Axboe

