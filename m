Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2064B15D6
	for <lists+io-uring@lfdr.de>; Thu, 10 Feb 2022 20:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbiBJTHP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Feb 2022 14:07:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiBJTHP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Feb 2022 14:07:15 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABAA10B7
        for <io-uring@vger.kernel.org>; Thu, 10 Feb 2022 11:07:15 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id y84so8684378iof.0
        for <io-uring@vger.kernel.org>; Thu, 10 Feb 2022 11:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hG/KdDDxIcyXsyw/RMafLBe/uq6M82xYSQCLZJnYCEQ=;
        b=MhT9yp2Wge+NFj3sIIssuJKA1EFvLYafov3ukdfpfxkJjrAyJ1X6589ADOHOdM6Mig
         lWCvxNbvFzre/oFjaU9WOhIo/uduK4gomEJDVb34A7s5M3dGQrAZdmOdFbxJXx/f/JkN
         bZvr07+qfO2B7VnwJ7JS1t3MhBuwbPznM/VwRVW6fuk9kXhe+QR1izIygJqsaP63QXpI
         /6Aj5q/0fNCvycYCK20DCIwhgU++rozy43uBwMYMHn7lOZwZ9BCuzAnVg5qIcIDQU3Ko
         +F8s0+yHbCHq+FZIO6GEbHCc7syIkjhMgNdoXM5RuAWRgMz85gHGEk0T1dtxdOcoDpXw
         vGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hG/KdDDxIcyXsyw/RMafLBe/uq6M82xYSQCLZJnYCEQ=;
        b=6L20jcuDPhnQi1JxVNj8LPkR2xP5l66FzhnzH1FHz3DY0Fgj6Udwvbr+jbch1joX60
         QhTPHBxXxsFGJs0Kvbdc+kNZ/HZ/TDk3QB45rnD33phBCf47fU3/4hFirQweGYjqIJik
         JrKwIVLMySqWhxESNyM/Q7u5QcUcTL2/nh/+UYFGYmcgzCng34bHl2g5slET+QKKxeI0
         gkiQ3KSDFjwpLmu1KxYBpwiX7pr1CYSwnYY7elRIgv+4bOucubMJMqJoIfCNEUyTRpXY
         fQe1jFavMvkCwdkR5okCanDxnr1wmRMPp8me56nCE5E40e4zByEUobePqo29shoK3pM2
         wdIw==
X-Gm-Message-State: AOAM532nbygjMU//vTWfvtFKcdUJrV74BXTdVUHBMFxgVzmzPwLbcShh
        oWdaloOH3Qy38N4mBIvuiF7L5g==
X-Google-Smtp-Source: ABdhPJwGOIWKCswLNq3dImk+idWkmGGgawR3gp26wwxBe9YeZ5EJ7znDKL+IkSxmrLR0nh/ZL2oLAg==
X-Received: by 2002:a6b:d80c:: with SMTP id y12mr4395981iob.31.1644520034625;
        Thu, 10 Feb 2022 11:07:14 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h8sm5789399ile.22.2022.02.10.11.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 11:07:14 -0800 (PST)
Subject: Re: [PATCH v2 2/3] block: io_uring: add READV_PI/WRITEV_PI operations
To:     "Alexander V. Buev" <a.buev@yadro.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, linux@yadro.com
References: <20220210130825.657520-1-a.buev@yadro.com>
 <20220210130825.657520-3-a.buev@yadro.com>
 <6d505bdc-d687-a9e7-54a1-9a2e662e9707@kernel.dk>
 <20220210190311.driobrtfavnb7ha3@yadro.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b8082a03-ab50-8a28-b6fd-1bf6985713ec@kernel.dk>
Date:   Thu, 10 Feb 2022 12:07:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220210190311.driobrtfavnb7ha3@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/22 12:03 PM, Alexander V. Buev wrote:
>> On 2/10/22 6:08 AM, Alexander V. Buev wrote:
>>> Added new READV_PI/WRITEV_PI operations to io_uring.
>>> Added new pi_addr & pi_len fields to SQE struct.
>>> Added new pi_iter field and IOCB_USE_PI flag to kiocb struct.
>>> Make corresponding corrections to io uring trace event.
>>>
>>> +struct io_rw_pi_state {
>>> +	struct iov_iter			iter;
>>> +	struct iov_iter_state		iter_state;
>>> +	struct iovec			fast_iov[UIO_FASTIOV_PI];
>>> +};
>>> +
>>> +struct io_rw_pi {
>>> +	struct io_rw			rw;
>>> +	struct iovec			*pi_iov;
>>> +	u32				nr_pi_segs;
>>> +	struct io_rw_pi_state		*s;
>>> +};
>>
>> One immediate issue I see here is that io_rw_pi is big, and we try very
>> hard to keep the per-command payload to 64-bytes. This would be 88 bytes
>> by my count :-/
>>
>> Do you need everything from io_rw? If not, I'd just make io_rw_pi
>> contain the bits you need and see if you can squeeze it into the
>> existing cacheline.
> 
> In short - Yes. Current patch code call existing io_read/io_write functions.
> This functions use io_rw struct information and process this data.
> I wanted to use existing functions but may be this is wrong way in this 
> case.
>                                                                                 
> The second problem with request size is that the patch adds pi_iter   
> pointer to kiocb struct. This also increase whole request union
> length.
> 
> So I can see some (may be possible) solution for this: 
> 
>  1) do not store whole kiocb struct in request
>     and write fully separated io_read/write_pi functions
> 
>  2) make special CONFIG_XXX variable and simplify hide this code
>     as default

Option 2 really sucks, because then obviously everyone wants their
feature enabled, and then we are back to square one. So never rely on a
config option, if it can be avoided.

I'd like to see what option 1 looks like, that sounds like a far better
solution.

-- 
Jens Axboe

