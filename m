Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40E6596CE4
	for <lists+io-uring@lfdr.de>; Wed, 17 Aug 2022 12:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbiHQKi0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Aug 2022 06:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238472AbiHQKiW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Aug 2022 06:38:22 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED1BE00D
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 03:38:20 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id z14-20020a7bc7ce000000b003a5db0388a8so1570749wmk.1
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 03:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=qBctm9nCq4hT7sOxaaYlnfPMd36MhZ2tginN2BPae00=;
        b=jxT+fPXFc/b4RWW+8jWrBV0szLJPdD6AbcQF+KOcvDnjZ9oc569TdIrGpxEI7Qatoa
         Y7IwjYWYbCXD+yz1VnrbJSZLeKyvZ0Qay82iTeNnWnguY2VkOLtuwV+Ff0+QGC/LkzfO
         c6LXc4OaIkJnXDv7LY4yOPUY8mbBNs9uM0G5PJA8ZNY+12/fFn258E5i51O1B4Zk/aCn
         Qk+cmhosL8waGkGKRYYYJ3QpApdFK+Lcs7kSVmNriXbg9mi98etN/3IuEO/yQxLuSakv
         D1beXjFWO3U8RVW7qGOvpjzfw0hDnYXKRDPXX2kPkAu41791vb+5imGrbHGj6it8kdfJ
         lY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=qBctm9nCq4hT7sOxaaYlnfPMd36MhZ2tginN2BPae00=;
        b=K20a0IHLZ9rzjyC21n/orh3rQjkplaITkt2J1nfOUwR2lXPmWdYVFaAegmuAUMAP1F
         L+7DnhmgUqWjNc9eSQ434uzWnbzRLjD3p0upGbdGOQCzFQAQwqy6BMq8fBsuVJbk/OLP
         mN9mwQZd0FNhjF6YteyscniWFauj7BjhzuxONNqfqXut2CQokstTOhXFhhku9/F6g0df
         WSpcg+DFbd4Jb6Y2E0U47lB06GCS6bz6Ymvp1eEc/SBGrugftW7tPk6jAzpwvJyyULm4
         e5JJxNDRCJFpFWpIjzKMKflVmFj0977qaiDYNYP1zNT2ZG/UqlaUa6yAO3foT6suPUsN
         2IEg==
X-Gm-Message-State: ACgBeo0yWybk19es4Lm4V1QpX99FxsBnHHdFl9ExLmI80qBYD0sR0jTJ
        PUdZII1aVU8iG9nei0SJEjY=
X-Google-Smtp-Source: AA6agR5pLeq+AduqKJTZgpvRZ+uAFhu54Vk6tjboWV90ZIaAbSYfLnVmc98SYJ5EZ/dZGj1fb+6Wqg==
X-Received: by 2002:a05:600c:1912:b0:3a5:f4fc:cd40 with SMTP id j18-20020a05600c191200b003a5f4fccd40mr1719452wmq.205.1660732698672;
        Wed, 17 Aug 2022 03:38:18 -0700 (PDT)
Received: from [192.168.8.198] (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id j4-20020a05600c300400b003a601a1c2f7sm1639046wmh.19.2022.08.17.03.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 03:38:18 -0700 (PDT)
Message-ID: <987c9e7a-7f23-f17a-0696-42272137bfd3@gmail.com>
Date:   Wed, 17 Aug 2022 11:36:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Adding read_exact and write_all OPs?
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <b9c90ccb-c269-7c78-8111-1641af29b0eb@gmail.com>
 <e42348ef-af67-d0d5-9651-89ca9e5055de@kernel.dk>
 <b56b820d-9b76-8185-197e-4d5fb00b6318@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b56b820d-9b76-8185-197e-4d5fb00b6318@samba.org>
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

On 8/16/22 19:46, Stefan Metzmacher wrote:
> Hi Jens,
> 
>>> In application code it's quite common to write/read a whole buffer and
>>> only then continue task execution. The traditional approach is to wrap
>>> read/write sycall/OP in loop, which is often done as part of a
>>> language std. In synchronous context it makes sense because it allows
>>> to process things like EINTR. But in asynchronous (event-driven)
>>> context I think it makes a bit less sense.
>>>
>>> What do you think about potential addition of OPs like read_exact and
>>> write_all, i.e. OPs which on successful CQE guarantee that an input
>>> buffer was processed completely? They would allow to simplify user
>>> code and in some cases to significantly reduce ring traffic.
>>
>> That may make sense, and there's some precedence there for sockets with
>> the WAITALL flags.
> 
> I remember we got short reads/writes from some early kernel versions
> and had to add a retry in samba.
> 
> But don't we already have a retry in current kernels?

Right, both short reads and writes will be retried when possible. Not
all file types are covered but fs and block should be fine. We also try
to handle short send/recv.

> At least for the need_complete_io() case?
> io_rw_should_reissue() also seem to be related and also handles S_ISREG,
> but it's hidden behind CONFIG_BLOCK.
> 
> Are there really systems without CONFIG_BLOCK?

-- 
Pavel Begunkov
