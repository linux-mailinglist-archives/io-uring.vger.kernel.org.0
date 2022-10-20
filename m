Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3838660606F
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 14:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiJTMlp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 08:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiJTMlo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 08:41:44 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8543FE903;
        Thu, 20 Oct 2022 05:41:43 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id bg9-20020a05600c3c8900b003bf249616b0so2071366wmb.3;
        Thu, 20 Oct 2022 05:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8EllZcT8J+eAyQkPvu8Kw7IL2qqWhHd8MYZfSohvEhQ=;
        b=D8vjWSesFwAWDtsz3YRspZbZkuyxK51VONAkKaVzJx6q3nXkjRlq3YaSsipnyjqV4q
         17rXacA3rV2/kxuhtzAP5HGgM7SGmNMPpTb8e6oOqosHDkwvAdpNwDNegC93YX2gnP4g
         074eqIKTHpOxdNg0B+kqrYZmTiq8VR4eBa9g/0oKKplx0qg947/MdvItRBbEPQu7k0x7
         XFffhxu4WP/xudR9IN0u3jksks4n9VueZbu0eo2TmpAx49pf4NxD+mt5CTqU8bRjD52Y
         jA+raCgbC35SlaEfothPpnvrJARa8n0LTLwoiWJSOEaV8xdH18R9r860GsIwIeBYWqmF
         glRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8EllZcT8J+eAyQkPvu8Kw7IL2qqWhHd8MYZfSohvEhQ=;
        b=nN5UGS7hqjkxttepXUBlnlpfEaj8dc6UTKoJo/asCVPryGnw9+ncBd+JtRPO6BwrBt
         IWesKZEL/FC4pdnr+bHgsWPXlyLXjnYmtFCD9TjLK181hR8mRc0P2kGqqZGu0ndIvSJp
         xxgJxZNHGdzP85XvHRxlbDnm4VKsIHIVEw7kLM76ewQtwrPIjwF3xAjl8EQVUvGy1oU3
         t7RC8LjG45PbvWVtNpiSUGlIv+0fvKwqb+BrKhlZfptD2SqP+sECawZuLwF+fp4V88Z4
         i13GmCm1AycIg/0weDB7k3wh+BG5VYWmnqJuS2CgUNSBIS1COFhyGRhNYuV/U5IHBCZd
         E2gA==
X-Gm-Message-State: ACrzQf0DkvJvFn0llK6hA9yMyLypVm6WI/tKvRdylW6XB8+4uMXPfh3H
        DNSoIg9ocZMcKyXMjGM+J9s=
X-Google-Smtp-Source: AMsMyM6UqjVECVgb9wk+WJzGBpm0dyaknZSMK23Z4eQ7BQhJsL2bnYiRnoX0ZebaT/CtRzPCX8OJuw==
X-Received: by 2002:a05:600c:3b99:b0:3c6:8b8e:a624 with SMTP id n25-20020a05600c3b9900b003c68b8ea624mr9274665wms.113.1666269702341;
        Thu, 20 Oct 2022 05:41:42 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:93dd])
        by smtp.gmail.com with ESMTPSA id m24-20020a05600c461800b003b4de550e34sm2476285wmo.40.2022.10.20.05.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 05:41:41 -0700 (PDT)
Message-ID: <dd22bf6a-8620-49c1-ec27-195e39cb4c33@gmail.com>
Date:   Thu, 20 Oct 2022 13:40:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [RFC for-next v2 0/4] enable pcpu bio caching for IRQ I/O
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <cover.1666122465.git.asml.silence@gmail.com>
 <Y1EHjbhS1wuw3qcr@infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Y1EHjbhS1wuw3qcr@infradead.org>
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

On 10/20/22 09:32, Christoph Hellwig wrote:
> On Tue, Oct 18, 2022 at 08:50:54PM +0100, Pavel Begunkov wrote:
>> This series implements bio pcpu caching for normal / IRQ-driven I/O
>> extending REQ_ALLOC_CACHE currently limited to iopoll. The allocation side
>> still only works from non-irq context, which is the reason it's not enabled
>> by default, but turning it on for other users (e.g. filesystems) is
>> as a matter of passing a flag.
>>
>> t/io_uring with an Optane SSD setup showed +7% for batches of 32 requests
>> and +4.3% for batches of 8.
> 
> This looks much nicer to me than the previous attempt exposing the bio
> internals to io_uring, thanks.

Yeah, I saw the one Jens posted before but I wanted this one to be more
generic, i.e. applicable not only to io_uring. Thanks for taking a look.

-- 
Pavel Begunkov
