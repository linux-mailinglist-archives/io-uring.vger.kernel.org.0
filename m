Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE36F215981
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 16:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgGFOdm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 10:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729193AbgGFOdm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 10:33:42 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03707C061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 07:33:42 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id r12so25860375ilh.4
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 07:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fmUO+MRhKaF9iDr809BkP0BZ1FEwKum+d6TqO74BCHY=;
        b=IgeFwe3MEabbYSbiAs+p2J1s7Hx8+qkGi0XKQXS+TMUtSUDcHZAsfvxQjSInnGs/hG
         n6Fz7r5BjsVqrvUpgJdUSa9Ot7cb3E6+iRdD+agLt9B0IjYMp38UYZJEIF9y1vE2HjAp
         Kbh529x6F3DrjiKAglmQCbHz0hx2QoAmqXWuzy5jvlhkcptALLA19v/KuTWX5paTji/t
         nnKCxKV6cikD2Rff9ULQNZcyBUKvKrKkgmgVI2AKCBdtELl8UVLddf8bUulVaSn76hIL
         edeo419KBLPKXNwu7YGkq7y+OUUCily9z0J0WPonnjRVbqCDElrL1f6uf/ihcltKINg7
         tOpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fmUO+MRhKaF9iDr809BkP0BZ1FEwKum+d6TqO74BCHY=;
        b=RW3i8YzwRD6TkMdQLefxuCtU6W3cRpQQq5OW/iurrK90N4ONYcGaCN8VdZ7YOpFOOi
         YzOBLHEQGV/tMvVfITZyjlQbTFMI1fsJL/5DuZ46ZsXnL2kLyLJW7qvrTw5UBclFPFFy
         kcvg0zIzWhCsfdG8iNWNB0qmJKJV6qMu+iNc3dNNdVjJRqadL7o/qxmPPA+TIIHA+5ai
         JqEfHIbupRV/F3wfG7ayG+OMGmfF/5EWUpEH7vFPFPEzWkUrTL7E/qgq1AA7IyflzNTA
         OYPZv5xjnLhbE1flHk/V+82IaZUp81xWDQepMuFZb1LwMamebtqV3thdqdPSok9o5xkf
         0w8Q==
X-Gm-Message-State: AOAM533wyjWEh8JSY0IU8Htm0EgUV/hVM40FMcSZDMP+VXTYUosPN3h/
        /oyjlkDsjdHT3aKLu5/2DjnAsg==
X-Google-Smtp-Source: ABdhPJwOtHmNnHmEW2Bjrz3fklq2Hr32zEZPkqI1YmYfRyWomLR+5Awwy7juGYxR0E2eZ/0IStYegA==
X-Received: by 2002:a05:6e02:10d4:: with SMTP id s20mr31143956ilj.203.1594046021328;
        Mon, 06 Jul 2020 07:33:41 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y6sm10971417ila.74.2020.07.06.07.33.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 07:33:40 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200705210947.GW25523@casper.infradead.org>
 <239ee322-9c38-c838-a5b2-216787ad2197@kernel.dk>
 <20200706141002.GZ25523@casper.infradead.org>
 <4a9bf73e-f3ee-4f06-7fad-b8f8861b0bc1@kernel.dk>
 <20200706143208.GA25523@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ee671380-86f0-d50d-7fb4-2e1901c4173c@kernel.dk>
Date:   Mon, 6 Jul 2020 08:33:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200706143208.GA25523@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/6/20 8:32 AM, Matthew Wilcox wrote:
> On Mon, Jul 06, 2020 at 08:27:17AM -0600, Jens Axboe wrote:
>> On 7/6/20 8:10 AM, Matthew Wilcox wrote:
>>> On Sun, Jul 05, 2020 at 03:12:50PM -0600, Jens Axboe wrote:
>>>> On 7/5/20 3:09 PM, Matthew Wilcox wrote:
>>>>> On Sun, Jul 05, 2020 at 03:00:47PM -0600, Jens Axboe wrote:
>>>>>> On 7/5/20 12:47 PM, Kanchan Joshi wrote:
>>>>>>> From: Selvakumar S <selvakuma.s1@samsung.com>
>>>>>>>
>>>>>>> For zone-append, block-layer will return zone-relative offset via ret2
>>>>>>> of ki_complete interface. Make changes to collect it, and send to
>>>>>>> user-space using cqe->flags.
>>>
>>>>> I'm surprised you aren't more upset by the abuse of cqe->flags for the
>>>>> address.
>>>>
>>>> Yeah, it's not great either, but we have less leeway there in terms of
>>>> how much space is available to pass back extra data.
>>>>
>>>>> What do you think to my idea of interpreting the user_data as being a
>>>>> pointer to somewhere to store the address?  Obviously other things
>>>>> can be stored after the address in the user_data.
>>>>
>>>> I don't like that at all, as all other commands just pass user_data
>>>> through. This means the application would have to treat this very
>>>> differently, and potentially not have a way to store any data for
>>>> locating the original command on the user side.
>>>
>>> I think you misunderstood me.  You seem to have thought I meant
>>> "use the user_data field to return the address" when I actually meant
>>> "interpret the user_data field as a pointer to where userspace
>>> wants the address stored".
>>
>> It's still somewhat weird to have user_data have special meaning, you're
>> now having the kernel interpret it while every other command it's just
>> an opaque that is passed through.
>>
>> But it could of course work, and the app could embed the necessary
>> u32/u64 in some other structure that's persistent across IO. If it
>> doesn't have that, then it'd need to now have one allocated and freed
>> across the lifetime of the IO.
>>
>> If we're going that route, it'd be better to define the write such that
>> you're passing in the necessary information upfront. In syscall terms,
>> then that'd be something ala:
>>
>> ssize_t my_append_write(int fd, const struct iovec *iov, int iovcnt,
>> 			off_t *offset, int flags);
>>
>> where *offset is copied out when the write completes. That removes the
>> need to abuse user_data, with just providing the storage pointer for the
>> offset upfront.
> 
> That works for me!  In io_uring terms, would you like to see that done
> as adding:
> 
>         union {
>                 __u64   off;    /* offset into file */
> +		__u64   *offp;	/* appending writes */
>                 __u64   addr2;
>         };
> 

Either that, or just use addr2 for it directly. I consider the appending
writes a marginal enough use case that it doesn't really warrant adding
a specially named field for that.

-- 
Jens Axboe

