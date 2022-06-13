Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D53549A30
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 19:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241860AbiFMRhy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 13:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241906AbiFMRhF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 13:37:05 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA412BCE
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 05:59:57 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m32-20020a05600c3b2000b0039756bb41f2so3045462wms.3
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 05:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zjRzt/R5VBlYISRn8Sv8w/unQqbKWqQTZybSiEHQ7qE=;
        b=XNFCF4dBzGG88s7o1h/YhJMGnVL4sxVlsUW9BgAMeEnz7z2OHCKYN8lrH22R5H5QYs
         gHKzMATxdDDpkn2yA+TRTT1L77I7qp+SoUlIjaQPUUd/ERrwBo031tRm/gD09T+Vvpih
         EEupJKMX8SyLlALTmosuSmrKhgZzXUzt6in6GwFFr0g0NRsvi9aTI9Kupy9X64yY9j9E
         G/GlOnrLAUM6CXF62b5lvR2KPhQrLzplfp0QNA0vDBCNSEsdzsY+eWT9Nc4yBuozk6mm
         TEGf2oIWiKOHIEdtUxs3pyXuVgce0bCt4sR7yPc7nHbY/aWdu3iAIXfTEoBvGBiBT0kP
         WYIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zjRzt/R5VBlYISRn8Sv8w/unQqbKWqQTZybSiEHQ7qE=;
        b=cZL18GBdchXKUdtx5Wgzz6DSlf5lK4TTH7oywooLJGEjZV2L9TzRGRXsK7wUA4rP7F
         s9HUlol/x3gmhDuBEc415K/JbEp/fi37fY/41O0uSjuiVUseArSwqSFbJUZQ4CNOVVSN
         AySCMXRw3fKabgPhgXpERepmP95ZDlkw8MSZBnQZvM54U+96Rquan0HOYdTfEhIIaGYc
         NCAalVijc36MhgLx7SxomqUCWLZB+7exIIIZbmjPsnqFTk2o1U3uBZfV336L9X3U8P24
         yDyxBJ5G62WU8UqMFy+zkHFwk5DDnRt2+PoV9FwobwAV+r5MlSilYPyqxpJl13RbFM9l
         4FMg==
X-Gm-Message-State: AOAM5328VoWZIcO77lkIl0gobdigOQLrlFovszaXcVtIkSYY8mj4Y/ml
        hJp77uvLysuyUIh44Dumwd740f+r/WxA6g==
X-Google-Smtp-Source: ABdhPJyphK23t8rFaJi3ytvXISTiaKkX9NDJ38C25IViC75fJCfOtv7BDUG+gRX84/tjXLzZeHDIQw==
X-Received: by 2002:a05:600c:d0:b0:39c:5927:3fa7 with SMTP id u16-20020a05600c00d000b0039c59273fa7mr14663605wmm.36.1655125195601;
        Mon, 13 Jun 2022 05:59:55 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c12-20020a5d4ccc000000b00219c46089f6sm8578104wrt.64.2022.06.13.05.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 05:59:55 -0700 (PDT)
Message-ID: <de5e6f02-dcab-07df-7cc4-7f12885083e6@gmail.com>
Date:   Mon, 13 Jun 2022 13:59:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 0/3] io_uring: fixes for provided buffer ring
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, Dylan Yudaken <dylany@fb.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220613101157.3687-1-dylany@fb.com>
 <f2fddce1-bc25-183e-6095-bb5a70a57319@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f2fddce1-bc25-183e-6095-bb5a70a57319@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/13/22 12:08, Hao Xu wrote:
> On 6/13/22 18:11, Dylan Yudaken wrote:
>> This fixes two problems in the new provided buffer ring feature. One
>> is a simple arithmetic bug (I think this came out from a refactor).
>> The other is due to type differences between head & tail, which causes
>> it to sometimes reuse an old buffer incorrectly.
>>
>> Patch 1&2 fix bugs
>> Patch 3 limits the size of the ring as it's not
>> possible to address more entries with 16 bit head/tail
> 
> Reviewed-by: Hao Xu <howeyxu@tencent.com>
> 
>>
>> I will send test cases for liburing shortly.
>>
>> One question might be if we should change the type of ring_entries
>> to uint16_t in struct io_uring_buf_reg?
> 
> Why not? 5.19 is just rc2 now. So we can assume there is no users using
> it right now I think?

It's fine to change, but might be better if we want to extend it
in the future. Do other pbuf bits allow more than 2^16 buffers?

-- 
Pavel Begunkov
