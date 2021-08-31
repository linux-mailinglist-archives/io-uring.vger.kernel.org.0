Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428383FCBFA
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 19:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240375AbhHaRBr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 13:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239848AbhHaRBr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 13:01:47 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93B0C061764
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 10:00:51 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id g9so25827021ioq.11
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 10:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qv4RMWAj89d/SB72/jq79MHsjy8/XPQt56R/2jJNyPE=;
        b=ajfATbVquuKx+94apQEbcqlRYktsqplx1Hb2vOZyYtGJUWAf2SXM3iyif7/yuuGy0h
         +egsmMCbVu8bPNWqVuKTyigmjFXVp0Ju73jvOnhvsQy4l8WjgvS9Qmt6gZxe02kkkg7S
         TpcCWTK0Ihm8Elh8G9Sdo/iFL0T6wCPgdXTmzd/R6fLM0jc+SZwP0tEMa3qSvWfd+wTg
         CAZSQ/+z5fEDKLlJcvtohUkc74o1QT8PvS4FF3RVywi0aBbiYiFhe9fg+9IvQEPesDuv
         AybJoUF1J8UrMGbqYIw5MSfvsduCa/HZPfPZO6Ei4uzdd/6q+iVShmQTH6g2GvwDppvK
         b+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qv4RMWAj89d/SB72/jq79MHsjy8/XPQt56R/2jJNyPE=;
        b=UHdWwfhy4trp61g2D1tixTb7Asjyvy2cvHWdalmVQCwxDKTnROUHA+EqSMUiCCx0Ri
         BOkWEW9o3dyJKK+fcRez9RkaGHttL353HNLT9BOa9egklxBbU9SixjAvkvaxGtHju7Wh
         pEuPBO7xrF9rFRy3Ajv4XoFxHxHUuglnitfE5eQl38i9nzuD1eVKoyimZ3CnRjQASYxo
         DO1fiQKOLXSTS2p/mEbFcdhgCNdnStqLakPqqLAnd2OFAcIedWPQHm0x4cs4D9pRGGGY
         +SG93WF1/PrsiWtLSDCNqZYe/WaFcUVCtG/81LZ+/1j2b3rTv6ze5rK+2wlX6ucP4BZo
         pB3g==
X-Gm-Message-State: AOAM530j5cb8JFgCZqAvW4yuKxriCU0QUyzdg8N3DTzs7KD5JX5GyB62
        c27rGnj9iNPEflB966JYeBwjYCMVGcTUXw==
X-Google-Smtp-Source: ABdhPJzGyXTl6YLa8BFGcSrsOc6XcFD3pNLBItfmlG4QACLNhGBY6E/jvqw0fcTmWGZzwNehvbW0Vw==
X-Received: by 2002:a5e:8349:: with SMTP id y9mr18131017iom.34.1630429250763;
        Tue, 31 Aug 2021 10:00:50 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g14sm10272896ila.28.2021.08.31.10.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 10:00:50 -0700 (PDT)
Subject: Re: [DRAFT liburing] man: document new register/update API
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <17729362b172d19efe3dc51ab812f38461f51cc0.1630178128.git.asml.silence@gmail.com>
 <18f42215-e1e1-fcb4-1d3a-cae75812a0b6@kernel.dk>
 <32a0e756-dca3-7a01-7132-c0e96cdac2e7@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f854e24f-0be4-6142-85d7-176e197684ed@kernel.dk>
Date:   Tue, 31 Aug 2021 11:00:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <32a0e756-dca3-7a01-7132-c0e96cdac2e7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/21 10:38 AM, Pavel Begunkov wrote:
> On 8/28/21 8:35 PM, Jens Axboe wrote:
>> On 8/28/21 1:18 PM, Pavel Begunkov wrote:
>>> Document
>>> - IORING_REGISTER_FILES2
>>> - IORING_REGISTER_FILES_UPDATE2,
>>> - IORING_REGISTER_BUFFERS2
>>> - IORING_REGISTER_BUFFERS_UPDATE,
>>>
>>> And add a couple of words on registered resources (buffers, files)
>>> tagging.
>>
>> Just a few comments below.
> 
> Thanks for taking a look, not going to pretend that I'm good at it :)
> 
> [...]
> 
>>> +.PP
>>> +.in +8n
>>> +.EX
>>> +struct io_uring_rsrc_register {
>>> +    __u32 nr;
>>> +    __u32 resv;
>>> +    __u64 resv2;
>>> +    __aligned_u64 data;
>>> +    __aligned_u64 tags;
>>> +};
>>
>> Move this up to where it's initially mentioned?
> 
> Do you mean a couple of lines up? like this? 

Yeah, just move it where it's first described.

-- 
Jens Axboe

