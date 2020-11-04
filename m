Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887AE2A66BB
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 15:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgKDOuy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 09:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKDOux (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 09:50:53 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54593C0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 06:50:52 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id r9so22449558ioo.7
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 06:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cqKEUNRdf1aVoSk/dtFXrESUyAjdMTBoegTb2fvEPE4=;
        b=2INzsgwaJgJxQCOkCys+L8m7OtTL2xVimMOy1NUfS26vqF9v2BXNs7QXyjoGq34o2b
         Q3MX5NAdBeJtclH30I8QAjtMWshWa2uRTE/r6ote7k1MRbKSfKUTuUeODqd0wY35fRk7
         M44YxE+xBvnoXNn6ltAK2i1kk5snDDYZT2xl6So07YvbjuMwPtHsvgO8vmtVZCz6W1t6
         rHqnhFxHD5n/9sphbKu/FNBDmYvUBZr+6tr89QLWR0GwkoN77JPL2U8xzNwJ48Lg3blW
         ez1Tx6kjv0ZvtF/xoFM4IqKdcL6wc/vbV8HsvEmY7wW5Y4Q4ZKSJLmdVS+A9inmS7XWM
         NgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cqKEUNRdf1aVoSk/dtFXrESUyAjdMTBoegTb2fvEPE4=;
        b=hU3QO8XvmGXxR6drsB5812TB8h/D8YxVY/txVM9Ra/g2TV50BMRo8WlvUCguz6nnp4
         VhhAXTJi9mGkbolYEC9jSxC+NHvwAjn6WYZbf7lxXqaDfUQwnrEKDB3vzOWGfnMD/ofP
         0d0YB6lIbG2utWg8YgWzqH7HlpBCIpKcNzVdmYET+njt0XqnHj3Tt8wPfpJVahhDvmxa
         5V5a+0e/6AEljuY67d4I7/CksugbmFibl/F0EwkoynES7UqSAizFCEYFDkkmdALwrOO1
         n71WtFXezbM96oxNc2r5ugHAzhLTpzHn6Xag3suyDsKNptha3wukTOjF9zaAqIz9dimZ
         tpDg==
X-Gm-Message-State: AOAM531jIoZ62F0aHGZ5ZcU3YYHnLNpDpHhXTge58FIQfhF+DWD8Blbe
        JX24liIhQokZeUMBGuA4bWzS46mCq0tDuA==
X-Google-Smtp-Source: ABdhPJyEqv7I8HSn+zQ7jwSSwbKb3IRn4/jqTBKgGaPUAJhd9cJ16V0r3197JusUfDeJEIxJOEm9hg==
X-Received: by 2002:a02:6d5d:: with SMTP id e29mr16937409jaf.7.1604501451343;
        Wed, 04 Nov 2020 06:50:51 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm1264040iot.21.2020.11.04.06.50.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:50:50 -0800 (PST)
Subject: Re: io-uring and tcp sockets
To:     Stefan Metzmacher <metze@samba.org>,
        David Ahern <dsahern@gmail.com>, io-uring@vger.kernel.org
References: <5324a8ca-bd5c-0599-d4d3-1e837338a7b5@gmail.com>
 <cd729952-d639-ec71-4567-d72c361fe023@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f2f31220-3275-9201-0b58-a7bef4e2d51d@kernel.dk>
Date:   Wed, 4 Nov 2020 07:50:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cd729952-d639-ec71-4567-d72c361fe023@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/20 4:21 AM, Stefan Metzmacher wrote:
> Hi David,
> 
>> New to io_uring but can't find this answer online, so reaching out.
>>
>> I was trying out io_uring with netperf - tcp stream sockets - and
>> noticed a submission is called complete even with a partial send
>> (io_send(), ret < sr->len). Saving the offset of what succeeded (plus
>> some other adjustments) and retrying the sqe again solves the problem.
>> But the issue seems fundamental so wondering if is intentional?
> 
> I guess this is just the way it is currently.
> 
> For Samba I'd also like to be sure to never get short write to a socket.
> 
> There I'd like to keep the pipeline full by submitting as much sqe's as possible
> (without waiting for completions on every single IORING_OP_SENDMSG/IORING_OP_SPLICE)
> using IOSQE_IO_DRAIN or IOSQE_IO_LINK and maybe IOSQE_ASYNC or IORING_SETUP_SQPOLL.
> 
> But for now I just used a single sqe with IOSQE_ASYNC at a time.
> 
> Jens, do you see a way to overcome that limitation?
> 
> As far as I understand the situation is completely fixed now and
> it's no possible to get short reads and writes for file io anymore, is that correct?

Right, the regular file IO will not return short reads or writes, unless a
blocking attempt returns 0 (or short). Which would be expected. The send/recvmsg
side just returns what the socket read/write would return, similarly to if you
did the normal system call variants of those calls.

It would not be impossible to make recvmsg/sendmsg handle this internally as
well, we just need a good way to indicate the intent of "please satisfy the
whole thing before return".

-- 
Jens Axboe

