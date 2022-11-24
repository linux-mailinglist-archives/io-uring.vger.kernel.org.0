Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEBF637F9D
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 20:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiKXTUH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 14:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKXTUF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 14:20:05 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3AF6B393
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:20:03 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id l39-20020a05600c1d2700b003cf93c8156dso1877942wms.4
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZC3PxzZ2550wfTE7kgfkeLaApDG+JgCLwh18/yTTt4=;
        b=fBVlOIfo4AwOukJCvJUYcvzQtN12uf7VaL09uY5GXsL+aYfMhsx01c3lHmae2CMoSH
         4fxuu/vVJnKGkWh1Y+5xh9WvqWwVNASbIv2PJQQIR140hGrAVF4cKQjZfsWbcy0iuZF0
         N+/d6qTkYQFSDkShHjdPyFNz6xhQpBN+NmIHpdKtA3rA5q475R+ufFHsfYjGPjDfkixY
         aYLJjox0N/3sQgl1UpSw7Rg7rUrDUNLqMFMyT5jsmnqXv723EmDUWONTEM5NOV7s6O9W
         MjLE6RWL6FiFYrLkZwhAY4f6wjTFmztQlBx67wRDsWlyboy05ArC68Nx/x97ypfh6Obr
         rIPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZC3PxzZ2550wfTE7kgfkeLaApDG+JgCLwh18/yTTt4=;
        b=Zrfhh71O5lz0KpyqFrAUvALZ7EisKmNcohDR/XQklrEmyXqFLC0D0EKIdAUAJ2Pnzs
         oQG3dNFaUrTSd10MWOxpJZwjaC1Z6tZNevEaisGam3yQgrWWkvKX1SiJGytLdIrVU+Qd
         8/VZcsgTCPlbHTRxF+yRx+CPiukmn5yWHr823eMeP5C/h46VOeahW/9uW6tfEKeDokqo
         0LqBIjyR+7ONqJuvWjjfO0Z4ai2FHjwQCAvzdLAIzo0sX29pQoAteKP20ZLBZlgIZN2G
         B/WH0XjfA31bzFEqX7PRGPhZXWGFfAjbj2+iD3bx/ohUDDYujnTojq/WLUpbHPPTQuov
         oerw==
X-Gm-Message-State: ANoB5plssjRsJza6Kt7cXIaInFwTmuN+r714XfA1/B+nBnPnYAk5U7MI
        RHz0brkDUu/wIn6xxqVBPzuC0kZXTXM=
X-Google-Smtp-Source: AA0mqf6RObt/SDQ2Jbx8gcGvedMe+q00ruaYAseEoPQ18ri3c/YtIR5JAEbTps482rIUosDLHaH3mw==
X-Received: by 2002:a1c:c918:0:b0:3cf:f2aa:3dc2 with SMTP id f24-20020a1cc918000000b003cff2aa3dc2mr15443029wmb.175.1669317601658;
        Thu, 24 Nov 2022 11:20:01 -0800 (PST)
Received: from [192.168.8.100] (188.28.226.30.threembb.co.uk. [188.28.226.30])
        by smtp.gmail.com with ESMTPSA id l11-20020a1c790b000000b003b4a699ce8esm6452558wme.6.2022.11.24.11.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 11:20:01 -0800 (PST)
Message-ID: <58d31c08-82f2-fcbf-8c3a-8bed05465b2a@gmail.com>
Date:   Thu, 24 Nov 2022 19:19:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] io_uring: kill io_cqring_ev_posted() and
 __io_cq_unlock_post()
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <c09446bd-faca-13cc-97af-c06fa324e798@kernel.dk>
 <c03977b8-85a1-5984-ebda-8a0c7d0087d2@gmail.com>
 <bd80da09-a433-1ea6-6a0c-bbb335b5187d@kernel.dk>
 <40e17ac2-8c02-9d04-fab0-d7e29db89bab@gmail.com>
In-Reply-To: <40e17ac2-8c02-9d04-fab0-d7e29db89bab@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/22 19:17, Pavel Begunkov wrote:
> On 11/24/22 18:46, Jens Axboe wrote:
>> On 11/24/22 9:16?AM, Pavel Begunkov wrote:
>>> On 11/21/22 14:52, Jens Axboe wrote:
>>>> __io_cq_unlock_post() is identical to io_cq_unlock_post(), and
>>>> io_cqring_ev_posted() has a single caller so migth as well just inline
>>>> it there.
>>>
>>> It was there for one purpose, to inline it in the hottest path,
>>> i.e. __io_submit_flush_completions(). I'll be reverting it back
>>
>> The compiler is most certainly already doing that, in fact even
> 
> .L1493:
> # io_uring/io_uring.c:631:     io_cq_unlock_post(ctx);
>      movq    %r15, %rdi    # ctx,
>      call    io_cq_unlock_post    #

wrong one,

__io_submit_flush_completions:
	pushq	%rbp	#
...
.L1793:
# io_uring/io_uring.c:1394: 	io_cq_unlock_post(ctx);
	movq	%r12, %rdi	# ctx,
	call	io_cq_unlock_post	#


> Even more, after IORING_SETUP_CQE32 was added I didn't see
> once __io_fill_cqe_req actually inlined even though it's marked
> so.
> 
>> __io_submit_flush_completions() is inlined in
>> io_submit_flush_completions() for me here.
> 
> And io_submit_flush_completions is inlined as well, right?
> That would be quite odd, __io_submit_flush_completions() is not
> small by any means and there are 3 call sites.
> 

-- 
Pavel Begunkov
