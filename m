Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0B14346FC
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 10:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhJTIfV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 04:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhJTIfV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 04:35:21 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8CEC06161C
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 01:33:07 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g2so17142946wme.4
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 01:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lZ8ENIf9MXTy8wnB64cCcrxc7/hnuOb1GkiWcnZbMIk=;
        b=LCq0KGpE4jI/czeZvQ3+hd1BdWHU87EvSwmlCvI0DNF01aTiP5xlNxfKH58Py0YPKA
         +o92rX6VhiEJPtnmuRqWIaGf1zcKAwD0z5/8mwa5j+F3IeQ9c6YvErtJ+Ip9Q/a4WyvH
         FCTGWE1uK3Goo1VlTtXnMDgjZy1iCn+KLn8/T0ns0SW4oI7yOxOQ3jVMBYIfX1s+8Fs5
         jtZHngBFK6Qjq2HyEe+vK9YRUecFbOxuc0cat69WLqCYeih9ta0QTlDirvkqKrgXsXup
         QAPqseyko1YiICUlwJYEWCV7LjCJNQpl5dcvHcvVtbkob02A4Uyz00o/gIhL80ebP8jn
         5FFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lZ8ENIf9MXTy8wnB64cCcrxc7/hnuOb1GkiWcnZbMIk=;
        b=kr7s2ftdXrZxgFhBalmMSkaVS71MI6QjhvgfK629K042GabeiEnUnhThtvTYvKwhC5
         jj3QXVo4Q/CnfcmUhjD9GL4NVydub5JQ3nITOpHvZIZ8AbOvuZZLgvFRuwpiX7J8D1Qp
         oXqqY1EZ0OitFHlrKkJsf0epFoAiJGRQgkvT6e8mzjOlr2akcUJ/VAuqMUCdvvb5/hb6
         7Q4PqY/JSg7D3tpfItTf27vWvQfSx0+/I62RqPyk2huSDul3OKiGd5YdLaFoLGqeI19f
         an+lnIXcWkETms7oXVq+nI5tUVP038E6uKzfuXVLVBoCajFy3UO+phdtAORX8toGCszg
         o7CA==
X-Gm-Message-State: AOAM531eVavQMsIpDv1Rt9u+XEPFZFPazCh5bx80LfGXBrTibfBjme+J
        aziSWkNXsQNvDjCfc7Ccg8c=
X-Google-Smtp-Source: ABdhPJzfc+wfDEsnMC3b+Mt9r7yYXx4l6Kh2eg30vu0JZfkvJHoD/W0MYZJ23UDCXVEfpSPb4CeWfw==
X-Received: by 2002:a05:600c:1548:: with SMTP id f8mr12061882wmg.35.1634718784917;
        Wed, 20 Oct 2021 01:33:04 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.145.194])
        by smtp.gmail.com with ESMTPSA id w2sm1313026wrt.31.2021.10.20.01.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 01:33:04 -0700 (PDT)
Message-ID: <37deaffe-8df5-230d-114a-99f63ae5782f@gmail.com>
Date:   Wed, 20 Oct 2021 09:33:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 5.15] io_uring: fix ltimeout unprep
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Beld Zhang <beldzhang@gmail.com>
References: <902042fd54ccefaa79e6e9ebf7d4bba9a6d5bfaa.1634692926.git.asml.silence@gmail.com>
 <0370d998-3fcb-d4f0-266a-3032ecff8aa8@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0370d998-3fcb-d4f0-266a-3032ecff8aa8@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/21 02:48, Jens Axboe wrote:
> On 10/19/21 7:26 PM, Pavel Begunkov wrote:
>> io_unprep_linked_timeout() is broken, first it needs to return back
>> REQ_F_ARM_LTIMEOUT, so the linked timeout is enqueued and disarmed. But
>> now we refcounted it, and linked timeouts may get not executed at all,
>> leaking a request.
>>
>> Just kill the unprep optimisation.
> 
> This appears to be against something that is not 5.15, can you please
> check the end result:

Yeah, it was 5.16 for some reason. Looks good, thanks!


> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.15&id=46cb76b2f5ff39bf019bf7a072524fc7fe6deb01

-- 
Pavel Begunkov
