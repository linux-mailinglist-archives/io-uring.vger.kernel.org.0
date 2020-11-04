Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C602A681F
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 16:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbgKDPw1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 10:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgKDPw0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 10:52:26 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB127C0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 07:52:26 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id z2so19697878ilh.11
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 07:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OTLYCjwMAsn9AO1HrLXJkQq9aed52dXLy8xQPyTdetg=;
        b=zfmZntu6tr9tsNvVz5iTaSVM9osvog/MXufO0IZls2Nn7POPT+rtDrnPpYhZskbLDe
         HCx3S7qk6lVJ54ca+fUQXsoRAr+iVY2ULWNwjDsfBT9Hb8y84zJsQ8V0XSZ9JRJZxQho
         HvHDk8gq/m6MNrrhSEyZTBWXeMktw42UliIXdqL+XwXnVpquhN4rGkklURdtou2sQ+Rv
         0LgH6C0U8yVw/llHZNZqKUwboxJj8WHEGudwqpGZEhGUvs1Jgq+sD+oj4VMKorKGB+V/
         F+86/UTb61xkODnpPEQe5myyKkalvLYnD/e3QbzMOHtfYWjArRQF5MNyoCUKzXDPO/1F
         N7uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OTLYCjwMAsn9AO1HrLXJkQq9aed52dXLy8xQPyTdetg=;
        b=D6agH2iWT+jhpYg1rDwl4hl/1jOgFfGo6KRkE0T1Rcjuzb5qGHoIzfNYyEAedQ0yRb
         k5qh+e8w4A+Eqjkae1OWlXxc0/f91FnZgJqlhV6/cUuvg+4woLeUzSr/fs9x3ITNS82i
         K3L4ZFvN+PT0ztiBpkGNM2NIcrmT7Ud8DAyorhuitdG7BEG5kb3LfWqgPpVaoIDLRQjt
         qSWTFRLs0XRITEEQM1z0SqYdQWG3mDDHMk8TXRW4uTSWDdub1nBe4f2LclkPPims80aK
         nOeonjUjhVjMjTZxpRE1fjfJvARfNwNd8Sf1OrT69CQx+p4S4FMVho/pfm4SRuoovfCW
         6MnQ==
X-Gm-Message-State: AOAM533A9TC7ARWblRZ7GJvVAZiVQ5yJEnV+2i2fqS3s3NmfBCR58tLw
        GEewGMT2Qw8UefTHOYyrwIOgV50fqz2yIg==
X-Google-Smtp-Source: ABdhPJwEq6xadMg19OVjdsmbMgojOeJCjUZcxE1gflIZdQclRckDWOQkSF0mRUnj5JN0fpIfybpKFg==
X-Received: by 2002:a92:8bcb:: with SMTP id i194mr14563433ild.163.1604505145778;
        Wed, 04 Nov 2020 07:52:25 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m15sm1608036ila.32.2020.11.04.07.52.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 07:52:25 -0800 (PST)
Subject: Re: [PATCH 5.10] io_uring: fix overflowed cancel w/ linked ->files
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <9d97c12a0833617f7adff44f16dc543242d9a1f7.1604496692.git.asml.silence@gmail.com>
 <dcbb9f34-9943-8a80-14c0-a968e02254b6@kernel.dk>
 <f0fb77b2-fd84-0a62-3499-567d575f31ff@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8e23fda5-072f-2943-9937-2626e304013f@kernel.dk>
Date:   Wed, 4 Nov 2020 08:52:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f0fb77b2-fd84-0a62-3499-567d575f31ff@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/20 8:41 AM, Pavel Begunkov wrote:
> On 04/11/2020 15:25, Jens Axboe wrote:
>> On 11/4/20 6:39 AM, Pavel Begunkov wrote:
>>> Current io_match_files() check in io_cqring_overflow_flush() is useless
>>> because requests drop ->files before going to the overflow list, however
>>> linked to it request do not, and we don't check them.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>
>>> Jens, there will be conflicts with 5.11 patches, I'd appreciate if you
>>> could ping me when/if you merge it into 5.11
>>
>> Just for this one:
>>
>> io_uring: link requests with singly linked list
>>
>> How does the below look, now based on top of this patch added to
>> io_uring-5.10:
> 
> Yep, it looks exactly like in my 5.11!

OK great, thanks for checking. Pushing it out.

-- 
Jens Axboe

