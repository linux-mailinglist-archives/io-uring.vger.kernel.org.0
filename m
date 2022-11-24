Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D24637F95
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 20:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiKXTSS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 14:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiKXTSR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 14:18:17 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7B6623B5
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:18:16 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id g12so3725855wrs.10
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tMk82ti8LzzHiPHRGvDqOW4IO8EpX39SI0ESwh1YXFQ=;
        b=oCL6Bp7k1DjUOc1mx8CBK4ULieohJsILcTIEBZGIvjISRapcCE9TeDhTmudLwv8zYJ
         ywCM3dZoi2C8gVkbv05Gb4xyDZDPcUeAFcXAaoFPh99Q6jH1PjTJds0YV1tOTfI7Z6ct
         3YLp1fy4nGk0+RvBqpcjae8Hwk2AFRSk1wk7v8UOO+GQRLSy26Su5cMvyv+r8Wg1jY+g
         6h/HoLOe+ry9I0+1XNvMJpumnFcmQNiBoenKCHCJnrxYBC738BzEq1HYfZflxWYJTuEA
         c2KNG+Da402QKqjCtGGkmn7wv6acurOn66HMPZHgMGdQDzLTmWgsApTVVTrJz3eVcLwp
         u8yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tMk82ti8LzzHiPHRGvDqOW4IO8EpX39SI0ESwh1YXFQ=;
        b=pzoj2z41FXJCvJ1of0LiajuT7//RK9aNLGUj4hyaAuvaCZ72zaF91rlCwV+K+tzjow
         5tKPiJrlYQsopIk4IJyUN8i7udVsYdcWuWpidM1aqf4EEbfCmtYu1g14+WvGcIHjCmtb
         +ghn1RZNhhi9+Uv94YB7bqXRyl07g4SXMQcoTycJSsMd0I4XLUvB9nhSTEPO/kJugj5x
         GkvjHfbtfg/iCEt05X9OvlVGF9zXoYazustUFWXjBSZc8pJUTatNivIZD1VCXSkOVYCx
         5IFmBzPUbYobRb7zsMcg9sxHdVb3QQ/uywEYUxDT+JgQ1xbBHfj3sLW6kWapikGqbL3V
         QgtA==
X-Gm-Message-State: ANoB5pknBV2kT8ZCCAMVsVvcLC+TqyNt9rsNcvUdOk2mcfWHWXBzImRO
        5ioPvjamu+BwlcDoSkS0/LtgVTz6wNw=
X-Google-Smtp-Source: AA0mqf6smPgusrWfptSY6TJ3DkLuOg/DjdwsJZ5mZIMsybxbjnPcbOZZJQiD29xFZmum5pKnWp2kwg==
X-Received: by 2002:a05:6000:1046:b0:241:fa2d:debc with SMTP id c6-20020a056000104600b00241fa2ddebcmr3570446wrx.12.1669317494518;
        Thu, 24 Nov 2022 11:18:14 -0800 (PST)
Received: from [192.168.8.100] (188.28.226.30.threembb.co.uk. [188.28.226.30])
        by smtp.gmail.com with ESMTPSA id d5-20020a05600c3ac500b003cfe6fd7c60sm2664151wms.8.2022.11.24.11.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 11:18:14 -0800 (PST)
Message-ID: <40e17ac2-8c02-9d04-fab0-d7e29db89bab@gmail.com>
Date:   Thu, 24 Nov 2022 19:17:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] io_uring: kill io_cqring_ev_posted() and
 __io_cq_unlock_post()
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <c09446bd-faca-13cc-97af-c06fa324e798@kernel.dk>
 <c03977b8-85a1-5984-ebda-8a0c7d0087d2@gmail.com>
 <bd80da09-a433-1ea6-6a0c-bbb335b5187d@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bd80da09-a433-1ea6-6a0c-bbb335b5187d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/22 18:46, Jens Axboe wrote:
> On 11/24/22 9:16?AM, Pavel Begunkov wrote:
>> On 11/21/22 14:52, Jens Axboe wrote:
>>> __io_cq_unlock_post() is identical to io_cq_unlock_post(), and
>>> io_cqring_ev_posted() has a single caller so migth as well just inline
>>> it there.
>>
>> It was there for one purpose, to inline it in the hottest path,
>> i.e. __io_submit_flush_completions(). I'll be reverting it back
> 
> The compiler is most certainly already doing that, in fact even

.L1493:
# io_uring/io_uring.c:631: 	io_cq_unlock_post(ctx);
	movq	%r15, %rdi	# ctx,
	call	io_cq_unlock_post	#


Even more, after IORING_SETUP_CQE32 was added I didn't see
once __io_fill_cqe_req actually inlined even though it's marked
so.

> __io_submit_flush_completions() is inlined in
> io_submit_flush_completions() for me here.

And io_submit_flush_completions is inlined as well, right?
That would be quite odd, __io_submit_flush_completions() is not
small by any means and there are 3 call sites.

-- 
Pavel Begunkov
