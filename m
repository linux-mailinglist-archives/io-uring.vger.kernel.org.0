Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7991F7C7D
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 19:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgFLRbd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 13:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgFLRbc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 13:31:32 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB0CC03E96F
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 10:31:32 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gl26so10839937ejb.11
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 10:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/uzv+12SAg4H2RbDNstYrTdOYvnkYeAi5VlKl20OwAw=;
        b=lSWd4WJv0++sFRzTCO+hnBsPHDrlYuWYKbOsEHLi+acooDbI04LAVE6C49D6C9ajep
         vg/T29K800FgJQI1FBON0F9e71o14pUXuAk9qh9fYiWcFN24/CVYEvIkt6x4pRfNX4vP
         kPOlOtF34UKUzJ6k+Vf2vA/jm89VX0J1taz4ZENTJ0NQPhpg9LH5yW/ADeAxIkhlBEVv
         FQweLx9qTLAIugKCEX+JOmpmpXEy28FyQFSQFZRsZwK6V83YW8BAfjQjaBir4baCqkc9
         fTtL8hMu12TMjz0HDutB4W2WBhQG3Jfo4uh9Pi1vdC60Dsd9AQyOpZWAl0q3GAQhKb9U
         nh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/uzv+12SAg4H2RbDNstYrTdOYvnkYeAi5VlKl20OwAw=;
        b=hirMqqs34Ux2nVapu9JvRmyrpSb0CDQaZLBaebW70JedOrRjDdFNGxQYOdipycHN8e
         t4Qt0M106318qEzgjmIgZVQQ8HZDiOwRLQfgLI0sN1zLlvNUHw+jr1eZ02KC23iVB4L+
         tCnJBFDF4EzztO1pKjRGKi5DCWwC2T/iRnDx5731L2LMC99ZMaASR1cZGipjLvJ2rNej
         DWD0QCOEQtnmDV0LFro30efjvIiyIBOi1KAoG/idXcthsWBGQh0lU8lV6Fh0EN4qSVXY
         NJ/1enMymAoC+3KipYREVPu3WbtxUARF1YvWvbK8V8aB9GpyEClWX9mJjkgxKi1iSOAM
         dw/g==
X-Gm-Message-State: AOAM5314yMSvTTaLE8QFiaeilOnfM+aRagDuCPRCN792/8F63jXgqpkP
        CTl7yr/yBdapJ9v9DbTFgpUbiVYL
X-Google-Smtp-Source: ABdhPJyW8YLqTbm4tTLAElYWZml/DV59hmbvHAf5swmjD5RXvR5LmvMbVGGiCOdwUkF+kjxzahrLrg==
X-Received: by 2002:a17:907:35c9:: with SMTP id ap9mr13682475ejc.81.1591983090657;
        Fri, 12 Jun 2020 10:31:30 -0700 (PDT)
Received: from [192.168.43.114] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id rp21sm3902418ejb.97.2020.06.12.10.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 10:31:30 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <12b44e81-332e-e53c-b5fa-09b7bf9cc082@gmail.com>
 <6f6e1aa2-87f6-b853-5009-bf0961065036@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC] do_iopoll() and *grab_env()
Message-ID: <5347123a-a0d5-62cf-acdf-6b64083bdc74@gmail.com>
Date:   Fri, 12 Jun 2020 20:30:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6f6e1aa2-87f6-b853-5009-bf0961065036@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/06/2020 20:02, Jens Axboe wrote:
> On 6/11/20 9:54 AM, Pavel Begunkov wrote:
>> io_do_iopoll() can async punt a request with io_queue_async_work(),
>> so doing io_req_work_grab_env(). The problem is that iopoll() can
>> be called from who knows what context, e.g. from a completely
>> different process with its own memory space, creds, etc.
>>
>> io_do_iopoll() {
>> 	ret = req->poll();
>> 	if (ret == -EAGAIN)
>> 		io_queue_async_work()
>> 	...
>> }
>>
>>
>> I can't find it handled in io_uring. Can this even happen?
>> Wouldn't it be better to complete them with -EAGAIN?
> 
> I don't think a plain -EAGAIN complete would be very useful, it's kind
> of a shitty thing to pass back to userspace when it can be avoided. For
> polled IO, we know we're doing O_DIRECT, or using fixed buffers. For the
> latter, there's no problem in retrying, regardless of context. For the
> former, I think we'd get -EFAULT mapping the IO at that point, which is
> probably reasonable. I'd need to double check, though.

It's shitty, but -EFAULT is the best outcome. I care more about not
corrupting another process' memory if addresses coincide. AFAIK it can
happen because io_{read,write} will use iovecs for punted re-submission.

Unconditional in advance async_prep() is too heavy to be good. I'd love to
see something more clever, but with -EAGAIN users at least can handle it.

-- 
Pavel Begunkov
