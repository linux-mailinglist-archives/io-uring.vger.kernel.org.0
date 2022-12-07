Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0998364631F
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 22:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLGVNx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Dec 2022 16:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLGVNv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Dec 2022 16:13:51 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61AA51C32
        for <io-uring@vger.kernel.org>; Wed,  7 Dec 2022 13:13:48 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id vp12so16955077ejc.8
        for <io-uring@vger.kernel.org>; Wed, 07 Dec 2022 13:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GVmk0V/c6A5gg1HniZi1GtaKlAlez6hB53lCGYzEsjs=;
        b=CH2deRm5ezuYfJiKFIaEHYzKHoCQCxoudVnIVajYmUCYpa5OoGCJXoctkeKVR39kgR
         C78mopKzvXaoLKe3JPApuORb29p7u5pAZbJq6ohaHaYQSCGA+L18j6jbhq5UdVmfXRr0
         yvSo/nWen/e6NfbxYUdtcSqS0I3kUyNIsUZIxnKwNvZPDTLW8gWZVZs8qeY2mnIrwrpq
         gqr2CFqgkxB7DLjeg+t8ZiT7ZVB4csH0objJa72y7WXr2Kby3SA7JjKsvZDRO3Ct5fMa
         zQYkARcBn/B+pm8NAMPTG5vNym7uUn5S7Lp42G7GrbtQK9PnNZ9ZLulnxaX7dPpF1o82
         TmCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GVmk0V/c6A5gg1HniZi1GtaKlAlez6hB53lCGYzEsjs=;
        b=6D1VGE7v84yatHgYnsW/2Bjur7BAwXK4KmeWQiISab0TcMl93eCIycEGWDbF0QYH5F
         yOBkQLQwZ0XjgWRECeuV4r3HpUursZrPyn4KNg3oNIfFdxoc5Ude9nAjt3mxYNS/sEpZ
         8hbJJb98plmlnujI25yep/3MKvaR11MDjHyYi8rtLDkNVVkCevMIrZe3vkwspjRynJEh
         IOVJOztb4b391cQCkCQU7asnPQmoFcEMvUoJfcpkB1djRuqjNylcDAHFWHJD0bn/fEjh
         7YnQug/lIqhv5OGz9EZbextgzBHeCJ/jbJSjN96KlbZ5eMocTnSKsi/iHh0PyHITSW9d
         ramA==
X-Gm-Message-State: ANoB5pneTMXSRp6EgPHo/dPXG9MC119wn+tnEfG3ud0gR6iTczx3E3dT
        tLwQsVMLNmGhkwnetPJMJq28SQ/STc8=
X-Google-Smtp-Source: AA0mqf5uN9ceKar8Jn2lRzprZu2K/0aenSvA7a9L0i264eFKveRb5kpVTEbrornDqER3hu9mlLeB3Q==
X-Received: by 2002:a17:906:164d:b0:7c0:b602:f9a1 with SMTP id n13-20020a170906164d00b007c0b602f9a1mr23204974ejd.88.1670447627272;
        Wed, 07 Dec 2022 13:13:47 -0800 (PST)
Received: from [192.168.8.100] (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id o6-20020aa7c7c6000000b0046b7d8a3f5asm2651561eds.16.2022.12.07.13.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 13:13:46 -0800 (PST)
Message-ID: <b6f19a3c-fdf3-0c97-1f9b-79260fa09c6c@gmail.com>
Date:   Wed, 7 Dec 2022 21:12:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH for-next v2 01/12] io_uring: dont remove file from
 msg_ring reqs
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1670384893.git.asml.silence@gmail.com>
 <e5ac9edadb574fe33f6d727cb8f14ce68262a684.1670384893.git.asml.silence@gmail.com>
 <bc422c44-b723-8b6e-0d21-980539cd4f6d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bc422c44-b723-8b6e-0d21-980539cd4f6d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/7/22 13:52, Jens Axboe wrote:
> On 12/6/22 8:53 PM, Pavel Begunkov wrote:
>> We should not be messing with req->file outside of core paths. Clearing
>> it makes msg_ring non reentrant, i.e. luckily io_msg_send_fd() fails the
>> request on failed io_double_lock_ctx() but clearly was originally
>> intended to do retries instead.
> 
> That's basically what I had in my patch, except I just went for the
> negated one instead to cut down on churn. Why not just do that?
I just already had this patch so left it as is, but if I have to
find a reason it would be: 1) considering that the req->file check
is already an exception to the rule, the negative would be an
exception to the exception, and 2) it removes that extra req->file
check.

-- 
Pavel Begunkov
