Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2B6616402
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 14:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiKBNp5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 09:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiKBNp4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 09:45:56 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882162AE09
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 06:45:54 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id r2so1894598ilg.8
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 06:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ngdo2CMrv6JEncfuBpCr4UI7hYK2vVJFbMPMw7migeM=;
        b=CXRqmhR2CRTL0WcQ9GEoYgVBh/VA4y/CABSYMI+Avs+V3gPsLj1q75GbD9TxLjGUb8
         jvtU7uIVjFAWJVKGt1iEZF3jjYLF8oN6rFoGQ50aVm1dqnwjjp6BosYv29yDznX9cIOG
         VU/eXQ88mogsJU2ctJlzIg9IFc7ikeoqfwWKg4YMxgZJiqYrm2siO9Wg3Gijg9vkDDRu
         2HIbid6DJggNi3KcjZF+uYR/rj8iur053u4H+ATt21NP8aw3AaFnLI71ygvdWYqL9AZB
         3vrrimUahXzU0A20PKZZA4lPVyeOZAcJclozxKIH6kaEvBLrgtJiJsnim4YHWMpkqOOD
         2ndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ngdo2CMrv6JEncfuBpCr4UI7hYK2vVJFbMPMw7migeM=;
        b=0bihmYmHPV+RQaoChu6wSD8ub0v9Z+FZWbKsL3v5TvQF9n4FlZlPgKgTvbCYRlv9WX
         FZuwkIP6mUqi5cEFcZ/LklsZ6YTMYxTmWXuRhcgho1dXu5W14wL7kLYQlJfG8ovD7z2d
         1SwFI88IpkmjaF6XX9201hWsQhSI3Hn5dbeCJUhl9t23lmT0oT3j7YZl3yriPPpZ0t4V
         fPAFqHcSqQdorqEMWjX3P5NlcILaN7icI6aTPpBktINZoXvQhQhPagesqejo2yETz923
         LAqYAyojTPZlrboYfpjtDkHfDisyH7oGp5c9Ix+FxpIJrisnEm0CerG6i+HiRCqoYtOe
         nGvA==
X-Gm-Message-State: ACrzQf0roXqzToBXhIe0vZHYiciYSUKPtqnVqIGorzOf/rNBp+Hk+TdO
        DGfqan6FLInkAhiRvmj90EewNQ==
X-Google-Smtp-Source: AMsMyM52SYD/WY15E2JQex7tTnOAw+fSp+DPogQzrMfpMEb6urWQc8uCAkh2CCRuhvM+8ZXqcM0rSQ==
X-Received: by 2002:a92:cb88:0:b0:2fc:1695:df02 with SMTP id z8-20020a92cb88000000b002fc1695df02mr15968208ilo.92.1667396753775;
        Wed, 02 Nov 2022 06:45:53 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k15-20020a056e02134f00b002ff54e19cb0sm4618324ilr.36.2022.11.02.06.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 06:45:52 -0700 (PDT)
Message-ID: <a3b03991-f599-375d-6eaa-704af9aa88c0@kernel.dk>
Date:   Wed, 2 Nov 2022 07:45:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH for-next 07/12] io_uring: split send_zc specific struct
 out of io_sr_msg
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221031134126.82928-1-dylany@meta.com>
 <20221031134126.82928-8-dylany@meta.com>
 <76be6e82-7aa4-b35e-5a8c-ee259af8ec41@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <76be6e82-7aa4-b35e-5a8c-ee259af8ec41@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/2/22 5:32 AM, Pavel Begunkov wrote:
> On 10/31/22 13:41, Dylan Yudaken wrote:
>> Split out the specific sendzc parts of struct io_sr_msg as other opcodes
>> are going to be specialized.
> 
> I'd suggest to put the fields into a union and not splitting the structs
> for now, it can be done later. The reason is that the file keeps changing
> relatively often, and this change will add conflicts complicating
> backporting and cross-tree development (i.e. series that rely on both
> net and io_uring trees).

Not super important, but I greatly prefer having them split. That
way the ownership is much clearer than a union, which always
gets a bit iffy.

-- 
Jens Axboe


