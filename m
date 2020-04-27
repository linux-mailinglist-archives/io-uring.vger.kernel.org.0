Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2623C1BAF14
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 22:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgD0UNX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 16:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726748AbgD0UNW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 16:13:22 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFE7C03C1A7
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 13:13:21 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h12so247725pjz.1
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 13:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pR3kteFnkwSeWnYo3zmPG42eO8gLN75E8zh/Lytmcss=;
        b=X30MjfD2pcrZdg/csE29+RnQMgN/Tx9Jq3MxwVazvhXHpvNw9wYewYDsApFQiK44/c
         KAmPujAsMO48SwgGs0B0kEkoT9xMwc1ijVSlwlq9k/QRjDJ9rdJ3tOboJfkhgj3RX8xs
         WWbz0lZip5fhM1yypLELtlV9xuZftAdzSWG7hDFg9ZEj6/ssvTfMnR6ptcVV9YSdyOc5
         ZJG1n5fRV+gdPg4EiwYgYElYu10cZTUcYMx+dDuwojLKF8hol7cT2HNXVmCwq/bQ4q1w
         SngfvwupqaDeHnsQuuWIfnDCUz8WgSYK1/6K6yxtNnTxoAzop8iAjlYJn97xmd7uuIea
         vyug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pR3kteFnkwSeWnYo3zmPG42eO8gLN75E8zh/Lytmcss=;
        b=b2Nd6iKOsIrKqLh5VrW/hHV7COglyTUNRaxk9bzOJQS6/b9NLQtOc+2ZoQmEYmpZ/E
         JEfIEzdz3gGvXy/4FVAwjiOV4iprOXdfuaf6gIVEac7VKBOrxN1VD3FnSM+tlNGlomCa
         QOW905m4ZlgHENNdqrYeZ1E9qhjE2t+lJOrh9wdvLCbbKzQmsJpUv+WKzSqIrV9PkR51
         MgJH55YNDE2qV4Ka45xOuoMPO6BIkkSWEMUCLLenSfvp9jiME22g0aSyRwuIPaKKo9Pa
         vfHsmHvGBoM99j0I6UQe3ySaeFEdHLyooLMSB7pXzhU5ZTkDyM2w+Bgn5VyfW8w75o5o
         n06w==
X-Gm-Message-State: AGi0PuYZtGnLRpiE3fx32KZ1pnDtSIA6QgP5vIPEzqmvud1rWlMV/wCp
        ytQTc882jW2qu1U8u8bxdas5bFiLyKd9tA==
X-Google-Smtp-Source: APiQypKZwo4DH1PFNPp9oLk8VHPEhy4uATbvVBY6LPpPSmU+M/2Rc7zRonJad7UtQIOOLpJGBJ3hbQ==
X-Received: by 2002:a17:902:c281:: with SMTP id i1mr25095107pld.327.1588018400353;
        Mon, 27 Apr 2020 13:13:20 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a129sm13152689pfb.102.2020.04.27.13.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 13:13:19 -0700 (PDT)
Subject: Re: io_uring, IORING_OP_RECVMSG and ancillary data
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jann Horn <jannh@google.com>,
        Andreas Smas <andreas@lonelycoder.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <CAObFT-S27KXFGomqPZdXA8oJDe6QxmoT=T6CBgD9R9UHNmakUQ@mail.gmail.com>
 <f75d30ff-53ec-c3a1-19b2-956735d44088@kernel.dk>
 <CAG48ez32nkvLsWStjenGmZdLaSPKWEcSccPKqgPtJwme8ZxxuQ@mail.gmail.com>
 <bd37ec95-2b0b-40fc-8c86-43805e2990aa@kernel.dk>
 <45d7558a-d0c8-4d3f-c63a-33fd2fb073a5@kernel.dk>
 <CAG48ez0pHbz3qvjQ+N6r0HfAgSYdDnV1rGy3gCzcuyH6oiMhBQ@mail.gmail.com>
 <217dc782-161f-7aea-2d18-4e88526b8e1d@kernel.dk>
 <20200427201043.GA6292@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a16d1b24-454e-f96a-4faa-23f68ecaaa6b@kernel.dk>
Date:   Mon, 27 Apr 2020 14:13:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427201043.GA6292@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/20 2:10 PM, Christoph Hellwig wrote:
> On Mon, Apr 27, 2020 at 02:08:25PM -0600, Jens Axboe wrote:
>> Possibly... Totally untested, maybe I forgot to mention that :-)
>> I'll check.
>>
>> The question was more "in principle" if this was a viable approach. The
>> whole cmsg_type and cmsg_level is really a mess.
> 
> FYI, I have a series in the works to sort out the set_fs and
> casting to/from __user mess around msg_control.  It needs a little
> more work, but hopefully I can find some time the next days.

That'd be great - looking at it right now, I'd need to refactor
____sys_sendmsg (and ditto receive side) to poke at cmsg before
allowing us to proceed. I'll wait for you to post your series and
base it on top of that, if appropriate.

-- 
Jens Axboe

