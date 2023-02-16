Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F6B69953E
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 14:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjBPNKt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 08:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjBPNKs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 08:10:48 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BB14DE20
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 05:10:46 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id kk7-20020a17090b4a0700b00234463de251so5751274pjb.3
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 05:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a+xypixMughW65XcMfJ5RUjpJo+KQPzM3qaECKat7hU=;
        b=ivlYUmDaHL1V+ezqc3EoED3ts6xvzfnxGXCXrkQ9RnNTRZMUi5D0EQo9HRsJ7KcbDo
         9EPLWB/IV6o7KlSJAFrXeQ9VCZtjF37tf2BocQyvkLi0srPZrcO+txcf1LujOiKa+lQZ
         YjlCNWWu1duP4ZahZ9KH5qjwBUdwtROV34p433XAvkQGANrKZDt1vKW6mLImQVxb7wZT
         rg+iBB8lHUAOivOeGt0ME6T/Y1btoSyhPI1n4BXv46oHigHmwlJJsM8KoGa0AkB9jLpQ
         JLKrvR/435zo3OBOVtCDPY+kWSZG+7Tb2gWrTzkPhFsp3yILAVj/Nh/Bz1XKN6fJBBpm
         UJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a+xypixMughW65XcMfJ5RUjpJo+KQPzM3qaECKat7hU=;
        b=DV+UEuiYD4axHXeeoGvpHvRwlWMGjEIIYIyxBx0hMi/9FRoswzaCLlCQdIpjfIMH0q
         aDUoyYeDPZcyNzfhqx7SNgDl/7SzwDCLO2ITfMeK18NtL8hLYodoObXqy2OO/JG0Bp2O
         Atnk8zZiBSuCefx0kQZJAl6HRtTydXMnCjrsy+li0FfqiArFXoLcnEAWWajFAf6D54Rz
         irBWRuyexiQk/WZSmMR73CfK8ISLN5NgGph18NpiD2XiBroBkjy5mZyJw/H+NiIyrFkJ
         65P7l61kYkN7J40W4Av04obogFFrzidFT5DLIlxnHNA6SQ8JSFG7124ZJ39PJg8KCcmh
         mrOg==
X-Gm-Message-State: AO0yUKXNt0m8cOK1WwargCqqNuYsA6W/nmvBpG0fVyNoa9VyybSdLoy1
        uBJFn38CJ6PRWbdQRf3YJOKXX30KtpE7bfI9
X-Google-Smtp-Source: AK7set84QQW1gWwMw+9tWSZvR81EDhLx5/YUQLTX4RHZL97U/oxAMivJJPtVPGDoo6eOFa8MoRhEng==
X-Received: by 2002:a17:902:e5ce:b0:19a:f556:e386 with SMTP id u14-20020a170902e5ce00b0019af556e386mr1598882plf.0.1676553045941;
        Thu, 16 Feb 2023 05:10:45 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902a3c700b0019896d29197sm1287436plb.46.2023.02.16.05.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 05:10:45 -0800 (PST)
Message-ID: <8d2bc7cf-24f6-d413-bf43-adc818628c0e@kernel.dk>
Date:   Thu, 16 Feb 2023 06:10:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCHv2] io_uring: Support calling io_uring_register with a
 registered ring fd
Content-Language: en-US
To:     Josh Triplett <josh@joshtriplett.org>,
        Dylan Yudaken <dylany@meta.com>
Cc:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <f2396369e638284586b069dbddffb8c992afba95.1676419314.git.josh@joshtriplett.org>
 <be9f297f68ee3149f67f781fd291b657cfe4166b.camel@meta.com>
 <Y+4cG5yy8U0XGHP6@localhost>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y+4cG5yy8U0XGHP6@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/16/23 5:05?AM, Josh Triplett wrote:
> On Thu, Feb 16, 2023 at 09:35:44AM +0000, Dylan Yudaken wrote:
>> On Tue, 2023-02-14 at 16:42 -0800, Josh Triplett wrote:
>>> @@ -4177,17 +4177,37 @@ SYSCALL_DEFINE4(io_uring_register, unsigned
>>> int, fd, unsigned int, opcode,
>>>         struct io_ring_ctx *ctx;
>>>         long ret = -EBADF;
>>>         struct fd f;
>>> +       bool use_registered_ring;
>>> +
>>> +       use_registered_ring = !!(opcode &
>>> IORING_REGISTER_USE_REGISTERED_RING);
>>> +       opcode &= ~IORING_REGISTER_USE_REGISTERED_RING;
>>>  
>>>         if (opcode >= IORING_REGISTER_LAST)
>>>                 return -EINVAL;
>>>  
>>> -       f = fdget(fd);
>>> -       if (!f.file)
>>> -               return -EBADF;
>>> +       if (use_registered_ring) {
>>> +               /*
>>> +                * Ring fd has been registered via
>>> IORING_REGISTER_RING_FDS, we
>>> +                * need only dereference our task private array to
>>> find it.
>>> +                */
>>> +               struct io_uring_task *tctx = current->io_uring;
>>>  
>>> -       ret = -EOPNOTSUPP;
>>> -       if (!io_is_uring_fops(f.file))
>>> -               goto out_fput;
>>> +               if (unlikely(!tctx || fd >= IO_RINGFD_REG_MAX))
>>> +                       return -EINVAL;
>>> +               fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
>>> +               f.file = tctx->registered_rings[fd];
>>> +               f.flags = 0;
>>> +               if (unlikely(!f.file))
>>> +                       return -EBADF;
>>> +               opcode &= ~IORING_REGISTER_USE_REGISTERED_RING;
>>
>> ^ this line looks duplicated at the top of the function?
> 
> Good catch!

Indeed!

> Jens, since you've already applied this, can you remove this line or
> would you like a patch doing so?

It's still top-of-tree, I just amended it.

-- 
Jens Axboe

