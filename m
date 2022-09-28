Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94A85ED9B8
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 12:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbiI1KDj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 06:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbiI1KC7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 06:02:59 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE9488A30
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 03:02:53 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r7so18996870wrm.2
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 03:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=zmrFumSdah2tM4qIKcM/gS7Q02O9zdVrWghWPBq9UM0=;
        b=fgTXediJ2alMkpkHG5+F5MCmc5zSrDKyZ7N1UZYsJthLWsQ+n4SwjHlD6LecTgMWOQ
         lZ/0xczf4yOZSOY4L2hBRlxv9YvSIOQZWJVn/9XbEE8ZWhGVioIKz1QFmt7yhoZe7mW5
         sf5hdBL57QyCloOMnbVVu7D0DX466mxxJWGPfgXoQAqU5hbK+Hpm1vuyfqPTezyIOTd2
         9ksLW3SMOhIXjmgmVcHrL8r93kQz2Cim8qknHXMGQ5cwg5iyeFiaviHwbHGY9JbPhQOX
         kP4WCnDXuP79y7FgIScW2PO3n7D22kXFXgy+jVeiAhx751sOFen0Kc0wjQlDHYxDa3Fm
         N/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=zmrFumSdah2tM4qIKcM/gS7Q02O9zdVrWghWPBq9UM0=;
        b=7hvnLQP5ZM34bf1ktJPoGOVY3FIqU0mhUtmj7XpalY80QtUED7nt6dSqDDcclLzYHa
         mk8RHNZOe/cbsm6M1bN2bGVLVW74AFNPJtUdpNQYW8bUBunfyFHwJKHtTG6cP0QkOBfj
         MOmLGCBE/de7KCfZZ06Fkyt1ZBtYRpdOQZICfqWAnhI7JWTd2r58BzYreypvAQpypAQs
         BpvZZnbxXswlhWlmTT6BmL4csIc6R+LNrdNKrP2UA7rWBVCn+GT2H3OMrDTSb+NPl1/w
         wRhV5so/+oryeK7v/MJd5gP39U74RjOFc7ToAQjzo+qh2Zmxz3ogkYccaQvqD88BgSCa
         oGXQ==
X-Gm-Message-State: ACrzQf3ecOOm6G6umVNNnlp6JoeXegVfStUBQcSe/FKQpikUaXXl+pcC
        QBlAOJ9jXnZKRW7/7xvSAbaPiqsnDTE=
X-Google-Smtp-Source: AMsMyM4o9QMXmYN57stt6o0ZafQUuQoWAHS/bdxE1j0j3rBu/6JI0ikP0tXX7q5Hflp3x+8Ztsdv+Q==
X-Received: by 2002:a5d:64c7:0:b0:22a:6a2e:c4f1 with SMTP id f7-20020a5d64c7000000b0022a6a2ec4f1mr19483164wri.269.1664359371696;
        Wed, 28 Sep 2022 03:02:51 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c3b1100b003b476cabf1csm1682689wms.26.2022.09.28.03.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 03:02:51 -0700 (PDT)
Message-ID: <ff41b5f7-93a5-26ee-bae5-80fc828e1a45@gmail.com>
Date:   Wed, 28 Sep 2022 11:00:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: Chaining accept+read
Content-Language: en-US
To:     Ben Noordhuis <info@bnoordhuis.nl>, io-uring@vger.kernel.org
References: <CAHQurc-0iK9zawpc_k_-wSUVMp_+v14K+t-EJEDXL0pYkzD80A@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHQurc-0iK9zawpc_k_-wSUVMp_+v14K+t-EJEDXL0pYkzD80A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/22 10:50, Ben Noordhuis wrote:
> I'm trying to chain accept+read but it's not working.
> 
> My code looks like this:
> 
>      *sqe1 = (struct io_uring_sqe){
>        .opcode     = IORING_OP_ACCEPT,
>        .flags      = IOSQE_IO_LINK,
>        .fd         = listenfd,
>        .file_index = 42, // or 42+1
>      };
>      *sqe2 = (struct io_uring_sqe){
>        .opcode     = IORING_OP_READ,
>        .flags      = IOSQE_FIXED_FILE,
>        .addr       = (u64) buf,
>        .len        = len,
>        .fd         = 42,
>      };
>      submit();
> 
> Both ops fail immediately; accept with -ECANCELED, read with -EBADF,
> presumably because fixed fd 42 doesn't exist at the time of submission.
> 
> Would it be possible to support this pattern in io_uring or are there
> reasons for why things are the way they are?

It should already be supported. And errors look a bit odd, I'd rather
expect -EBADF or some other for accept and -ECANCELED for the read.
Do you have a test program / reporoducer? Hopefully in C.

-- 
Pavel Begunkov
