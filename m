Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3224958177A
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 18:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiGZQc4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 12:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiGZQcz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 12:32:55 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496701FCE8
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 09:32:55 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id o12so13665809pfp.5
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 09:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Q2k1kEviqAYXAPb0SUGNzYqIe1apn6sRvNjZUZMY8To=;
        b=icVq//Jmpn4y1Wrg0zf4++WT3bJ7g5Zmh94r/9FQd5iorTVIl2z1Jxs1a7CP8eLg4Z
         NMF17567C6C+3DGy8a9PYlf1Y2vUnhpjX5vuol2yClrUE4lHAnEG7rwQlLObFdjrKdoz
         IbKC6pEmKQmS+8//+CMK4AqUrpUL2zMi4zzG/CIUJ1aW77whvloTfIbXOHSl3sE0oMaG
         6+Zo2mazyehds4gTa/O1VyTKanxSuOFvWYmsEpKFhYxX3SDzKGrJ+mEJ6rLIolKmtFnP
         Y19P/BVP08SDDBE5rz21geI/U20zFANES21nPmEkFpnuD9oTxvvsVLX5xqet3GkJckhS
         rcdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q2k1kEviqAYXAPb0SUGNzYqIe1apn6sRvNjZUZMY8To=;
        b=CpsEF6SsHH/z3vw26xfIhPCldyZvzL/xQwLawiPdBXlsBM8Daw316WY4yKROWDiNin
         5fxeU/hMQ64T3DCYd40geRByFRJ7CfqsB74Gtpnxt2FeSROukD3JdYAFopcJT+g2XVlr
         dTAE/7LgoRlb9JhUYgcNRkNdCtvAhaH2bGz2uBN0E9Hnb9W2awvmKAtBpxuF5GvbqZFS
         9Lfz2mcfgZ6HIUL6UsT+86iRE3Cuy6zuWItzDJn8S71S+Cd7Njh1Q5b3YpTPhpxr4i4l
         cgmwUwOz98p2DSBoVnNQaPlvJGxZ6aqxKNDm4WOyfXLZHw4E0q2a14JbfcVThbStyvoT
         yT6A==
X-Gm-Message-State: AJIora90jbpHiInKN1W3lFwr4eqsbE1ThfXVixD1Ufppu9YZhH7KFeRt
        sBc1uJ/t/MktFHqnts/fP84HmF1+kJU=
X-Google-Smtp-Source: AGRyM1t6gKb4Ypx04e0uDTwrosNG8u+YV7eyS0ZsqeB9oGYWz/3XX0dNQnpdJKgfLSJJZpaVmTlG5g==
X-Received: by 2002:a05:6a02:44:b0:41a:a606:1910 with SMTP id az4-20020a056a02004400b0041aa6061910mr15130608pgb.121.1658853174650;
        Tue, 26 Jul 2022 09:32:54 -0700 (PDT)
Received: from [192.168.88.254] ([125.160.106.238])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c10d00b0016bfe9ab1f3sm11781382pli.36.2022.07.26.09.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 09:32:54 -0700 (PDT)
Message-ID: <e1d3c53d-6b31-c18b-7259-69467afa8088@gmail.com>
Date:   Tue, 26 Jul 2022 23:32:51 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 0/5] multishot recvmsg docs and example
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20220726121502.1958288-1-dylany@fb.com>
 <165885259629.1516215.11114286078111026121.b4-ty@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gmail.com>
In-Reply-To: <165885259629.1516215.11114286078111026121.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 7/26/22 11:23 PM, Jens Axboe wrote:
> [5/5] add an example for a UDP server
>        commit: 61d472b51e761e61cbf46caea40aaf40d8ed1484

This one breaks clang-13 build, I'll send a patch.

-- 
Ammar Faizi

