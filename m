Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E262366D0D1
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 22:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbjAPVR7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 16:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbjAPVRx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 16:17:53 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57E42BEE9
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 13:17:45 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so35037806pjk.3
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 13:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BP/XPWh6h/rHZl5W/8uh2dLTYVSBxGvqrE0V5Dl9nkA=;
        b=uNWnRr46mhfCvPT81bc+Q5h9OmXG9KNlvWRD+u5M9s+QGLYtH4XxJlFK2Qxl60iypo
         mUs+hwS9PGwtvGNY2vjul1u8Z31PzteFrIXeVKq21GYRblZbPZtwusYIrUKXAyyedDFG
         tN6nUjqoiNyhs9Y9hUd8KeuSKfLpqAzL7zDuGGJCm2452qsvqmhMt3M9JBsfbsSoLxuo
         MT6IOpZZEpvdIkvJh/0//pGFBdEOf/qIK9J3aJ9RIOifLm4WuCMvwPJJAOXalske/UNn
         fYmESSIYXo/YyidsJ2WZjsjAqTA1Fs8VkEZRCqGSDxJbOjRd/bUvzdrw0k5GltefaujH
         9I5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BP/XPWh6h/rHZl5W/8uh2dLTYVSBxGvqrE0V5Dl9nkA=;
        b=Ue37e6h+JMo/vuwnST6IX3wyWIYo8KKTCCI1OzV93HWOOjHxsWv8ArPMsOQf7iPKwg
         C0Gzt1JLdyVtB5XmjfE6eVfGHwPved+s3ZIvqLcRBXPLwmyHsBqFUu1cUTFmPkWh9gtY
         sDxLaPsRghoeTAqgzEmyrdO+kknULXsWoedBWcNvdicb4GYjIUagE5S4AALAzWNSoSkA
         HQPh5MhjmYacbU0JUtC3Vdpg38IZO62Y8K4IykMTdcVIT/hDHR7JY/VBNHvY6bWIXDZK
         orTahMamKt9WWR3IrPtSGh/pQf9J+vENEyDC8U8QcsBvNQRPi2g+d/Tmnsv+4wPSWizA
         wwqg==
X-Gm-Message-State: AFqh2kouHd6TlMBOc7wayTloy3H1TsqLN99AOr4v66Jd6BCGfL8CGEKd
        71lnmHelZHlSDYzXTiFb55IMxsWTy/r2MSmS
X-Google-Smtp-Source: AMrXdXveetgG0ktvDz3eM/6wJuJ2UEYCL4utRLfMvoxDYxQDyhLS3+lRxmRPCR//MYf99AKv/rWycg==
X-Received: by 2002:a17:903:1303:b0:194:6d4b:e1da with SMTP id iy3-20020a170903130300b001946d4be1damr281503plb.0.1673903865153;
        Mon, 16 Jan 2023 13:17:45 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u18-20020a170903125200b00189adf6770fsm19753040plh.233.2023.01.16.13.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 13:17:44 -0800 (PST)
Message-ID: <af2174dc-e6ae-8d38-bcc4-3889209ebeee@kernel.dk>
Date:   Mon, 16 Jan 2023 14:17:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH for-next 1/5] io_uring: return back links tw run
 optimisation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1673887636.git.asml.silence@gmail.com>
 <6328acdbb5e60efc762b18003382de077e6e1367.1673887636.git.asml.silence@gmail.com>
 <3b01c5b6-9b4c-0f7e-0fdf-67eb7c320bf0@kernel.dk>
 <92413c12-5cd1-7b3b-b926-0529c92a927a@gmail.com>
 <427936d0-f62b-3840-6a59-70138d278cb8@kernel.dk>
 <cc292524-7dd9-c8d5-aadb-aba4b2af261f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cc292524-7dd9-c8d5-aadb-aba4b2af261f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/23 2:14 PM, Pavel Begunkov wrote:
> On 1/16/23 21:04, Jens Axboe wrote:
>> On 1/16/23 12:47 PM, Pavel Begunkov wrote:
>>> On 1/16/23 18:43, Jens Axboe wrote:
>>>> On 1/16/23 9:48 AM, Pavel Begunkov wrote:
>>>>> io_submit_flush_completions() may queue new requests for tw execution,
>>>>> especially true for linked requests. Recheck the tw list for emptiness
>>>>> after flushing completions.
>>>>
>>>> Did you check when it got lost? Would be nice to add a Fixes link?
>>>
>>> fwiw, not fan of putting a "Fixes" tag on sth that is not a fix.
>>
>> I'm not either as it isn't fully descriptive, but it is better than
>> not having that reference imho.
> 
> Agree, but it's also not great that it might be tried to be
> backported. Maybe adding a link would be nicer?
> 
> Link: https://lore.kernel.org/r/20220622134028.2013417-4-dylany@fb.com

Only the auto-select bot would pick it, but I'm guessing it'll fail
and that'll be the end of that. Normal stable additions need a
cc stable as well, the fixes is not enough to trigger that.

-- 
Jens Axboe


