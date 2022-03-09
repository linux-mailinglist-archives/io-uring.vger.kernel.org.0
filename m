Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CB14D3C6A
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 22:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbiCIVxx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 16:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237779AbiCIVxx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 16:53:53 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C37F01
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 13:52:53 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id b7so1460871ilm.12
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 13:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=jZGatg/Ds+RAis6/y4myHd6+vkGlqCBy/DO3ck8shFg=;
        b=AOUPu/4Agy90q90iBeGdT3kNk7gKtFsVpQtAxM4ZK8GrV6OQYCP08ecTR9JcqF177w
         I46hR0zMVatmiA5luGmM9YJ5aphyjr5Vcx+xu2nmxYpPbipdyhuy4Z6Y5b/rS3mU5XQK
         WL9lkOocpGLDQhQ9eCOa+9w0ypNOvnVsnFZY3Jo8t6As5KCmuJ8L5G7lMndq4fqfPu8W
         ZAsnV1VrlyO2fFpaHwG17ICR6SFNi0cCs4j/8b21CXE4+Vy26OBHSigP6cwWt+2UZEfU
         Ju2KLiErq7KQxz5NexHfnFX2Gflw6VKSwkWkouVLyTvcYjJdtajGRKkkq6Hk7f8BYewI
         BWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=jZGatg/Ds+RAis6/y4myHd6+vkGlqCBy/DO3ck8shFg=;
        b=6OmLjSAg+9IjWWEv+27gj6WzVmYTZ6iQHNeXOvLHGERlsok+J0Hez7fjGT1/+exELB
         21z3VwQU3cyMdlBNqhqm8mpazebN98Z1/6EK3DfV9ifzNVM4MeyRRTaOd367pAKyHUsv
         uSGUmqT8fFTlSAPSwteJXrxPbQ+zUHg5Z4b5s7m8nA16SujiNvS+9M0NawBoiXgQchSy
         r2VPfFH4bkfmZPzM3WZwG3tdVK0nU7U7vq0EMqDRUwVOhcHnSlmf7YTf6zMfeg0SOUPe
         Gp8eoNwIrLJXGe8ZHF1Rss/cm4wFnFkFKUs2RYDw0h3gcUCdhLmICqivQ7l3iSMz9izC
         yuFQ==
X-Gm-Message-State: AOAM533ufCbm9wjDPOsd0HqVqM0EkoIpAIbFgye/0bujVJLeWf7bd+4e
        3oCMdy9dXMUSzztO14dul6opv6Pcomy/3fVe
X-Google-Smtp-Source: ABdhPJxkQ3FnMS34asW7+SLTaOSrEEn6LLcoNn3xderAmcVozIdT9zWSMcHP+I3HCaV1Adctev1WKQ==
X-Received: by 2002:a92:cc41:0:b0:2c6:7ca2:e5ce with SMTP id t1-20020a92cc41000000b002c67ca2e5cemr984415ilq.133.1646862772548;
        Wed, 09 Mar 2022 13:52:52 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p22-20020a5d8d16000000b006115627b87csm1627269ioj.55.2022.03.09.13.52.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 13:52:52 -0800 (PST)
Message-ID: <df67892c-427b-f4c1-72c2-7fd5c567eed2@kernel.dk>
Date:   Wed, 9 Mar 2022 14:52:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCHSET 0/2] Provided buffer improvements
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
References: <20220309183259.135541-1-axboe@kernel.dk>
In-Reply-To: <20220309183259.135541-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/22 11:32 AM, Jens Axboe wrote:
> Hi,
> 
> One functional improvement for recycling provided buffers when we don't
> know when the readiness trigger comes in, and one optimization for how
> we index them.

I'll spin a v2 with this, a few changes are needed.

-- 
Jens Axboe

