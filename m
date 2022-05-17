Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A746552A752
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 17:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbiEQPr4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 11:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350840AbiEQPqJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 11:46:09 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65FD50B20
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 08:44:30 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id b11so8938285ilr.4
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 08:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=H9k9Sr43MqoxRLdYlWNJSzdgGdipZqOCDZw/qBl8pIw=;
        b=BT7baiOAImd6aKD65pbOLDn43AgH5KjXPsUq+eDhp0yvoae4f7MoO8hU3i3dEmazh3
         jwj1XnFNRrPvy/uVq/SErBhexEVOETsY5OBeT/W78VH5MGdhyYHYx4++rTpFyw6S1Ord
         twTNqColQC+gkqrvn4bLUdgfaHuuZPxq4XDJ4y1i9Jdvsj4+jE3vg64NYJhoXRn5cAJV
         bRBiwDqIVtibUaIOZaFNYbgFprF+wxlIyHTmCEJl8tomUrOlRwDH6p16pDbEIMimvC12
         S4iZH+BxHvZtoFg+XRCs52I056lzUD8BHROuvYVM56T+/3VLyjx2IECK+nZpn4009yby
         F92Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H9k9Sr43MqoxRLdYlWNJSzdgGdipZqOCDZw/qBl8pIw=;
        b=Dc0EcHRK+FLOiIzAu/Ud6e37kxoh3GwdCsF019bHchEuqdLu3zV7CnBgqzE701OwFG
         wcRvWwBG+k1ShUJJQvJ/xWl+1qUsrtY+xIu1SVPxHZfXBUq3NdCxdKKk5DnEbbIeMCQx
         8fGy6gY2aTEJtQfFP+5pophYvcwBnNhnlIKEmXavHuYhQXI0e59rtIvVzqTjTo7dOhKC
         slhgPrhGk7o1tUZBGer+LhIzVf/NYqVAK2ouhuwSeZr53VDwkhv3HUERHmInzaFUxsD0
         TuiQRocbBUykc4KpY3jBHNSgOlmdpAnmLRuDqI7K1j/DDkexyPvzDhWLGiHOHp4/ONyI
         KMkA==
X-Gm-Message-State: AOAM530kJLxf6yKTWz2Mt7VFfqLFEKCYwr5hXu6PmkLVdRGTyTMi9IeZ
        MDrSq4q1K/E27MVDYLCwJYgZVw==
X-Google-Smtp-Source: ABdhPJwbE0Dtu7zrDOp7K+RLcx1mKqdGqyIMEiuN1gZYUdScn2ulsODmEGvykcoToUjdkvNtILT3Zw==
X-Received: by 2002:a92:cbc4:0:b0:2d1:2f29:8b8e with SMTP id s4-20020a92cbc4000000b002d12f298b8emr4016973ilq.307.1652802270076;
        Tue, 17 May 2022 08:44:30 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d31-20020a02605f000000b0032b3a781763sm3612286jaf.39.2022.05.17.08.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 08:44:29 -0700 (PDT)
Message-ID: <0634b2e1-d93b-e9c8-ee3f-a1b9432a9e24@kernel.dk>
Date:   Tue, 17 May 2022 09:44:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET v6 0/3] Add support for ring mapped provided buffers
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220516162118.155763-1-axboe@kernel.dk>
 <06535662-787c-d232-aaf5-3f5829ca48a7@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <06535662-787c-d232-aaf5-3f5829ca48a7@icloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/22 8:20 AM, Hao Xu wrote:
> On 5/17/22 00:21, Jens Axboe wrote:
>> Hi,
>>
>> This series builds to adding support for a different way of doing
>> provided buffers, which is a lot more efficient than the existing scheme
>> for high rate of consumption/provision of buffers. The interesting bits
>> here are patch 3, which also has some performance numbers an an
>> explanation of it.
>>
>> Patch 1 adds NOP support for provided buffers, just so that we can
>> benchmark the last change.
>>
>> Patch 2 just abstracts out the pinning code.
>>
>> Patch 3 adds the actual feature.
>>
>> This passes the full liburing suite, and various test cases I adopted
>> to use ring provided buffers.
>>
>> v6:
>> - Change layout so that 'head' overlaps with reserved field in first
>>    buffer, avoiding the weird split of first page having N-1 buffers and
>>    the rest N (Dylan)
>> - Rebase on current kernel bits
>> - Fix missing ring unlock on out-of-bufs
>> - Fix issue in io_recv()
>>
>> Can also be found in my git repo, for-5.19/io_uring-pbuf branch:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-pbuf
>>
>> and there's an associated liburing branch too:
>>
>> https://git.kernel.dk/cgit/liburing/log/?h=huge
> 
> should be the buf-ring branch I guess

Oops yes indeed.


-- 
Jens Axboe

