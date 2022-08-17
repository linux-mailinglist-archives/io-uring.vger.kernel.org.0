Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A53596E9E
	for <lists+io-uring@lfdr.de>; Wed, 17 Aug 2022 14:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiHQMqF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Aug 2022 08:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiHQMqE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Aug 2022 08:46:04 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96A68A6D6
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 05:46:03 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id f8so2388402wru.13
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 05:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=HexOByiYqenVHa9X8Ku80nTExtFJvXKuqmJB+Inzpyc=;
        b=VFAceZqS70r+SVfIBnBokfRK0NQquai7/O3dqiRLz94g0U4BEFIL9C5QVNnrWaBp/t
         dL+vOI9HhDguu0lfcttZMPdsJMT4kBej7e9UNvedVQpfpXNrlibiF7WlK/uGUU2Uzq3D
         2J86fqNMdLrv6E8zVaFNoVZfTRPA4n/bn5XTZmT6g4joGg5XFB296WzpsNxTqrLgIwSJ
         R5F3hW9qha4PzjTUcntfUerX+hTRkSph2R94dFMtUliePE/VE9ifZU3I2MaHqi9CG0Cq
         DkSB35xhxfpAieDimZhE9B2H+Fgw27ErYAC+LHLNBqmu2mKB/qCBZv5nhVEusIGU7C2l
         TAlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=HexOByiYqenVHa9X8Ku80nTExtFJvXKuqmJB+Inzpyc=;
        b=6FgIfGAMlyWxuwJmm7kODQMc8Zjz8hHv3DeAUUF0MMHJ/RDaPLKLN4+Z+KQDrY6DVi
         OlPBMr3UuLvjmfcrvjn3gV41i+R+GiD0JPWhZCcZpf0myg+2h7rdPSk0+ivXJO0ZWqFO
         ptV9qZk6saDSOF/ioCGWtfja6hXZ4t7S7rA6xqwojijyMCDPSg9DkOGOZPL8VENqpsLy
         4VOV3UlFcQHW2HQ7JxJx8r7tDqE4lMj3p6pwMo3JqrIvOyD9pyYbplJ2iovOfAjTOjao
         ZGkzomCZUeb2Y17OITJF8BAlRPkxZir3BSh01NjLmeLyzde5vqyJWcV44YpwF10VUKq4
         orwA==
X-Gm-Message-State: ACgBeo3ZK+zegguVLdNgHbWJJUeE5dQT4Ko/y3CJ7rK4w0eMvSvdIEKe
        WLzpVNnDJ4daQToe6B89amQ=
X-Google-Smtp-Source: AA6agR4ZZjYrKUHwBfFuPyI1WTVQLJqk9ftqnTmL+8imhLGwmdyFf24UuO1zVwfD8frknOd9fJF9Ug==
X-Received: by 2002:a05:6000:144c:b0:222:c5db:6caa with SMTP id v12-20020a056000144c00b00222c5db6caamr14114296wrx.421.1660740362165;
        Wed, 17 Aug 2022 05:46:02 -0700 (PDT)
Received: from [192.168.8.198] (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id p22-20020a05600c359600b003a35516ccc3sm2783954wmq.26.2022.08.17.05.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 05:46:01 -0700 (PDT)
Message-ID: <82c718c2-9403-38b4-7cf4-5f8aa369b041@gmail.com>
Date:   Wed, 17 Aug 2022 13:44:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC 2/2] io_uring/net: allow to override notification tag
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "metze@samba.org" <metze@samba.org>
References: <cover.1660635140.git.asml.silence@gmail.com>
 <6aa0c662a3fec17a1ade512e7bbb519aa49e6e4d.1660635140.git.asml.silence@gmail.com>
 <4d344ba991c604f0ae28511143c26b3c9af75a2a.camel@fb.com>
 <96d18b77-06d8-3795-8569-34de5c8779f1@gmail.com>
 <4bd2100042b18eda569fc31f434f48cc922a7b84.camel@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4bd2100042b18eda569fc31f434f48cc922a7b84.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/22 13:04, Dylan Yudaken wrote:
> On Wed, 2022-08-17 at 11:48 +0100, Pavel Begunkov wrote:
>> On 8/16/22 09:37, Dylan Yudaken wrote:
>>> On Tue, 2022-08-16 at 08:42 +0100, Pavel Begunkov wrote:
>>>> Considering limited amount of slots some users struggle with
>>>> registration time notification tag assignment as it's hard to
>>>> manage
>>>> notifications using sequence numbers. Add a simple feature that
>>>> copies
>>>> sqe->user_data of a send(+flush) request into the notification
>>>> CQE it
>>>> flushes (and only when it's flushes).
>>>
>>> I think for this to be useful I think it would also be needed to
>>> have
>>> flags on the generated CQE.
>>>
>>> If there are more CQEs coming for the same request it should have
>>> IORING_CQE_F_MORE set. Otherwise user space would not be able to
>>> know
>>> if it is able to reuse local data.
>>
>> If you want to have:
>>
>> expect_more = cqe->flags & IORING_CQE_F_MORE;
>>
>> Then in the current form you can perfectly do that with
>>
>> // MSG_WAITALL
>> expect_more = (cqe->res == io_len);
>> // !MSG_WAITALL,
>> expect_more = (cqe->res >= 0);
>>
>> But might be more convenient to have IORING_CQE_F_MORE set,
>> one problem is a slight change of (implicit) semantics, i.e.
>> we don't execute linked requests when filling a IORING_CQE_F_MORE
>> CQE + CQE ordering implied from that.
>>
>> It's maybe worth to not rely on the link failing concept for
>> deciding whether to flush or not.
> 
> Is the ordering guaranteed then to be <send cqe>, <notif cqe>?

Not yet, need to send this patch

https://github.com/isilence/linux/commit/9a1464905be3fc0cee4f68b01e43c5ad14a05b06

> If so I would put the IORING_CQE_F_MORE more as a nice to have for
> consistency with other ops
> 
>>
>>
>>> Additionally it would need to provide a way of disambiguating the
>>> send
>>> CQE with the flush CQE.
>>
>> Do you mean like IORING_CQE_F_NOTIF from 1/2?
>>
> 
> Apologies - I missed that
> 

-- 
Pavel Begunkov
