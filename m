Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D7621A13F
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 15:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgGINxK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 09:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbgGINxK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 09:53:10 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49785C08E6DC
        for <io-uring@vger.kernel.org>; Thu,  9 Jul 2020 06:53:10 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k23so2343942iom.10
        for <io-uring@vger.kernel.org>; Thu, 09 Jul 2020 06:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MdcBjmP7qGWR1MpBAxRS6pB+OY/RQLdcm4qT/nupz3g=;
        b=BjWZhcJGYeO/nZp2SRVBsmB5Ei77q8MrUISpXYS8soe+YNMxcSX6beIjMuI3Q05mxL
         gXY4Bw0kuYaA6GAj4ujXqufV5EipZgKw/jMhE5sCSyg9rMz64OM3LShd71rVSmg1N5ap
         /WH8FEF0+S2cFsHijeSnwEfnr6m/w8IkO0IUYeyKSmZA3K1VuSYheHIZc0bX4J+miskc
         s8hGdjjZJl4hLHqJ0RpwJ8bSXyqx7qO5aUtQg9kzDTIEpTDvUrAHjpbO0CVwFCvuc8+M
         MkAwSdB5SFIDB63Cth1qeUqZr5I+O4JOII0KIJ8lIg/eL3m9KP/hw51WcHviT92cRQky
         bimQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MdcBjmP7qGWR1MpBAxRS6pB+OY/RQLdcm4qT/nupz3g=;
        b=iyMLltSlLeTbqxlNcDOK5D3JGq95MMDV5EFULQ5ZZU9iU+f1lGNjX5vWkprrMpQ+j+
         ERZk+Z43YnQEAu9r3I+EMdzNJ4ZiaOJEIEAVZmQ31vx9as6iqilwtCEHtlo2T1xrkgk+
         yViZODle91XJV3jETwaseOkaDqgqvqnAZn8B2O09ePM6N1Yn2WeWj6pKW9oRQxdLVZb/
         qzUShFhp3Rq1SIMILAJRFjSwqrfPMr3qii41oiv1zAlqoKZiM0SYehUtpG8UvtyoIhiX
         beTJwrnXYivJtAr7itx1S9i3/BRxn8wlJQZ0KOUCSK3HBpbB50SaCc7E233jGoTx5MPZ
         goQw==
X-Gm-Message-State: AOAM533KZZo5R502a2JnNx+vVpFQCBSczVKq8+JwEOOhUrv6obqJHTMA
        S6sGmw4I6DBYMZqzvuugZXK/eA==
X-Google-Smtp-Source: ABdhPJy39Z382Q5bYeHMpva+0EOk6l7VKjY+mG3CJn9HtsoBPJfb2IFz340kCmDhMrghd/EAVUHtHQ==
X-Received: by 2002:a02:c6a7:: with SMTP id o7mr74870852jan.7.1594302789510;
        Thu, 09 Jul 2020 06:53:09 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 13sm1920029ilj.81.2020.07.09.06.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 06:53:08 -0700 (PDT)
Subject: Re: [PATCH 0/2] Remove kiocb ki_complete
To:     Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <20200708222637.23046-1-willy@infradead.org>
 <20200709101705.GA2095@infradead.org>
 <20200709111036.GA12769@casper.infradead.org>
 <20200709132611.GA1382@infradead.org>
 <20200709133249.GC12769@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cac3062d-3779-5c1b-b3f5-07823c198ead@kernel.dk>
Date:   Thu, 9 Jul 2020 07:53:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200709133249.GC12769@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/9/20 7:32 AM, Matthew Wilcox wrote:
> On Thu, Jul 09, 2020 at 02:26:11PM +0100, Christoph Hellwig wrote:
>> On Thu, Jul 09, 2020 at 12:10:36PM +0100, Matthew Wilcox wrote:
>>> On Thu, Jul 09, 2020 at 11:17:05AM +0100, Christoph Hellwig wrote:
>>>> I really don't like this series at all.  If saves a single pointer
>>>> but introduces a complicated machinery that just doesn't follow any
>>>> natural flow.  And there doesn't seem to be any good reason for it to
>>>> start with.
>>>
>>> Jens doesn't want the kiocb to grow beyond a single cacheline, and we
>>> want the ability to set the loff_t in userspace for an appending write,
>>> so the plan was to replace the ki_complete member in kiocb with an
>>> loff_t __user *ki_posp.
>>>
>>> I don't think it's worth worrying about growing kiocb, personally,
>>> but this seemed like the easiest way to make room for a new pointer.
>>
>> The user offset pointer has absolutely no business in the the kiocb
>> itself - it is a io_uring concept which needs to go into the io_kiocb,
>> which has 14 bytes left in the last cache line in my build.  It would
>> fit in very well there right next to the result and user pointer.
> 
> I agree.  Jens doesn't.

Stop putting words in my mouth, especially when they are totally untrue.

I was opposed to growing struct io_rw in io_uring, which is where the
extra append variable belonds, beyond a cacheline. You mentioned you
could probably shave some bits out of struct kiocb, which is how this
completion handling business came about. If kiocb was shrunk, then io_rw
has room for the needed variable.

At no point have I said that whatever we need to shove in there for
io_uring should be in the kiocb, that would not make any sense. I'm
just opposed to growing the per-op data field in io_kiocb beyond
a cacheline. And that's especially true for something like append
writes, which I don't consider super interesting.


-- 
Jens Axboe

