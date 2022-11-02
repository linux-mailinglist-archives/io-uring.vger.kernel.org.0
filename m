Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B21D616481
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 15:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiKBOK1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 10:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiKBOK0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 10:10:26 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88EF296
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 07:10:25 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j15so24741484wrq.3
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 07:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mQe/fKA/HgxB539+yucLTUNn329ZibbQwj51bVR85m4=;
        b=d5VqVvGCP9nV9xlX81cHWFznocuAjpS5PCqPzPxfk38YNrbJOFEb3FjYix4BuoJbpB
         l87QoPw8sNBkmlndspUFUaodwhsoWbUXFsrkcFDEpulmt6fvT1uRTPo+RJSAOYyBDvkf
         Crt023oHSLTC9uyzZlJKFmNlXx5rZs1aIDUKxkXJlNG9gPxRYRizXqU3oXAb73F2XALR
         mEM7OcVupp0PbD2o1hhmQDi1JRXhiw842iSsJEUf9MdRj76BRBh4Z75bdfucVP4kjYps
         A8yRWfk1UB+k9FrRjd441o39s0ceVqhKiky1KPQrDdSmdX5GjI4aHTNbguETIKeCIPIq
         LvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mQe/fKA/HgxB539+yucLTUNn329ZibbQwj51bVR85m4=;
        b=kP+xtk5tLdmkCrNbS4QJOF6ZG0zD5F002WyQCFCje/fGvd5iVq1Mp9Urp8DnwVv/TO
         r4ZeY5BUssx3F93WKyeJy053DUHt0rbuIxGxCZxhNqWFrfDmU6dNxZQJKzgohCE6/wKJ
         +nDQid7csJ9mql5GFpIuw8JK9nCw+7WrgWXe/0cfKeHx+2eK2vYkFZt8F+fr/vcbN6Fd
         17t0iIcRuYFT+V5RrZaPCmunFIg7MA70OuzYtlw+L0JofPzYyKcVuycjnaXmlX8hLH27
         i6QZRkWq3z3Mck2VkmSTznC+WFxDhnIVGlgHJwxZmjTIj3cP+EuLbvrdQNuoPaM8oH3g
         zNBg==
X-Gm-Message-State: ACrzQf33bBlNVT9C42oT64FVMjpBuT+samkDuKthkYUtuw5FEydNRQ1q
        bsyeiJRmTjC7vfeN5cOehic=
X-Google-Smtp-Source: AMsMyM7QcOBSEAI2qXpDnbzXcnV0l1+OzKZ1UrlFRg1V+iBO3Dne8s+mHwhEBzpcNVAzfY8S96g2cQ==
X-Received: by 2002:a05:6000:a11:b0:236:7685:e7 with SMTP id co17-20020a0560000a1100b00236768500e7mr16010077wrb.359.1667398223361;
        Wed, 02 Nov 2022 07:10:23 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:7fe])
        by smtp.gmail.com with ESMTPSA id l13-20020a05600c2ccd00b003a2f2bb72d5sm2291681wmc.45.2022.11.02.07.10.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 07:10:22 -0700 (PDT)
Message-ID: <d2e90603-192b-402b-e5a0-9ce4668714cf@gmail.com>
Date:   Wed, 2 Nov 2022 14:09:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-next 07/12] io_uring: split send_zc specific struct
 out of io_sr_msg
To:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@meta.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221031134126.82928-1-dylany@meta.com>
 <20221031134126.82928-8-dylany@meta.com>
 <76be6e82-7aa4-b35e-5a8c-ee259af8ec41@gmail.com>
 <a3b03991-f599-375d-6eaa-704af9aa88c0@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a3b03991-f599-375d-6eaa-704af9aa88c0@kernel.dk>
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

On 11/2/22 13:45, Jens Axboe wrote:
> On 11/2/22 5:32 AM, Pavel Begunkov wrote:
>> On 10/31/22 13:41, Dylan Yudaken wrote:
>>> Split out the specific sendzc parts of struct io_sr_msg as other opcodes
>>> are going to be specialized.
>>
>> I'd suggest to put the fields into a union and not splitting the structs
>> for now, it can be done later. The reason is that the file keeps changing
>> relatively often, and this change will add conflicts complicating
>> backporting and cross-tree development (i.e. series that rely on both
>> net and io_uring trees).
> 
> Not super important, but I greatly prefer having them split. That
> way the ownership is much clearer than a union, which always
> gets a bit iffy.

I'd agree in general, but I think it's easier to do in a few releases
than now. And this one is nothing in levels of nastiness comparing to
req->cqe.fd and some cases that we had before.

-- 
Pavel Begunkov
