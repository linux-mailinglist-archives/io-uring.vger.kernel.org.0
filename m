Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CA721A744
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 20:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgGISua (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 14:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgGISua (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 14:50:30 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FFFC08C5CE
        for <io-uring@vger.kernel.org>; Thu,  9 Jul 2020 11:50:30 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id k6so2931556ili.6
        for <io-uring@vger.kernel.org>; Thu, 09 Jul 2020 11:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GrXsYtapGjnrw/pbMa/SCV0S2qwzLccMpD6Nkl4dtwc=;
        b=aTdn7W3aKnzYYH25d4xjro+x9lOU10DgL79FjCdBUV3lL6pn85CVhfX8oebWA0SyrF
         3wGWR1q8CnliJkzDuNjGG/kheGgTY670srmrNmeU8Sd//u0Cqy5TRJdSLMmFzFQvbUVN
         skPESlg+HSvgUiQ2ZKBZHwolc061Tr+bJQC0Ee46M0Sf7+ZPeR9oP3FT+S05JYsHN3/U
         GvmgVIoRagYR2ZWEo6Yp32ZFfGKmxTXy8DKs3G93V5ovP5hUsX+3cK3lAKwd/PSsHh0P
         vcqI44/2+bWLTeneFWA/73vV+9RRdw5nkSCAyE26a+UBNA+vanzGfU8UsLBJOzlUo1gU
         XfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GrXsYtapGjnrw/pbMa/SCV0S2qwzLccMpD6Nkl4dtwc=;
        b=cG51t3Srbu683V2CwlEpzM0Y6JXTWMGgADquc9XidVkXuEjUhg0RrkVdmr2U/IbZLj
         FpMH396Y/7B4AnfpRNWSe7PnQReYQZgx6y6T2VTSDtxLwDxEv/TOvxetoGNojzdh87Ev
         RreVWJF6nn5CJ3LiQXu9iSofSvKnqiNRmmki/cpbwxe4CKDKDcALO4o41qd8VrsXvn4e
         KAcvMLQNklr4dGrcjwrFMjYhMNV/scJQL9O/yCXKmLciGeztoAnjq1V5te+OqNb1ox49
         260A1nR0WUidYYzmOZ1W3UTatvFvpUldfYndwD2YLAmPDTGPrrGk3Dh9hHQaAvnOeOZV
         dfyQ==
X-Gm-Message-State: AOAM5336WL7nWAd/8bhiQdOdWPkq0iJ/DcgDRidYUcLdCW63PW8SUm0L
        qLlHQS5nr1aXOHvVl1UQaeCuLw==
X-Google-Smtp-Source: ABdhPJwZ1xv9Tc5lZjBW6qZNaPGzm4EqCDdfI87OUCyodp+1AZC+XJpssQOpb7cvyN7mY5Sa1ZtECw==
X-Received: by 2002:a92:c806:: with SMTP id v6mr47666474iln.10.1594320629560;
        Thu, 09 Jul 2020 11:50:29 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h1sm2629701iob.8.2020.07.09.11.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 11:50:29 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org,
        =?UTF-8?Q?Matias_Bj=c3=b8rling?= <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org>
 <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org>
 <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk>
Date:   Thu, 9 Jul 2020 12:50:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/9/20 12:36 PM, Kanchan Joshi wrote:
> On Thu, Jul 9, 2020 at 7:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 7/9/20 8:00 AM, Christoph Hellwig wrote:
>>> On Thu, Jul 09, 2020 at 07:58:04AM -0600, Jens Axboe wrote:
>>>>> We don't actually need any new field at all.  By the time the write
>>>>> returned ki_pos contains the offset after the write, and the res
>>>>> argument to ->ki_complete contains the amount of bytes written, which
>>>>> allow us to trivially derive the starting position.
> 
> Deriving starting position was not the purpose at all.
> But yes, append-offset is not needed, for a different reason.
> It was kept for uring specific handling. Completion-result from lower
> layer was always coming to uring in ret2 via ki_complete(....,ret2).
> And ret2 goes to CQE (and user-space) without any conversion in between.
> For polled-completion, there is a short window when we get ret2 but cannot
> write into CQE immediately, so thought of storing that in append_offset
> (but should not have done, solving was possible without it).
> 
> FWIW, if we move to indirect-offset approach, append_offset gets
> eliminated automatically, because there is no need to write to CQE
> itself.
> 
>>>> Then let's just do that instead of jumping through hoops either
>>>> justifying growing io_rw/io_kiocb or turning kiocb into a global
>>>> completion thing.
>>>
>>> Unfortunately that is a totally separate issue - the in-kernel offset
>>> can be trivially calculated.  But we still need to figure out a way to
>>> pass it on to userspace.  The current patchset does that by abusing
>>> the flags, which doesn't really work as the flags are way too small.
>>> So we somewhere need to have an address to do the put_user to.
>>
>> Right, we're just trading the 'append_offset' for a 'copy_offset_here'
>> pointer, which are stored in the same spot...
> 
> The address needs to be stored somewhere. And there does not seem
> other option but to use io_kiocb?

That is where it belongs, not sure this was ever questioned. And inside
io_rw at that.

> The bigger problem with address/indirect-offset is to be able to write
> to it during completion as process-context is different. Will that
> require entering into task_work_add() world, and may make it costly
> affair?

It might, if you have IRQ context for the completion. task_work isn't
expensive, however. It's not like a thread offload.

> Using flags have not been liked here, but given the upheaval involved so
> far I have begun to feel - it was keeping things simple. Should it be
> reconsidered?

It's definitely worth considering, especially since we can use cflags
like Pavel suggested upfront and not need any extra storage. But it
brings us back to the 32-bit vs 64-bit discussion, and then using blocks
instead of bytes. Which isn't exactly super pretty.

-- 
Jens Axboe

