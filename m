Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7B160761A
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 13:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiJUL1N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 07:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJUL1N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 07:27:13 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1884225CE36
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 04:27:12 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id bk15so4294000wrb.13
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 04:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6EGHE7XAaLVZ/AspOBqL9+WxC2EzdwtbJgY13u/uqSU=;
        b=R5xP8KATZuDyzz95j5X+6NluNBu2skG7reVOkpjRQcBfS85yJ2fqJsB3RX1TuowaLF
         selZEmhE65mxBUc9atAo3RAgJFlKp/iHM6oJYPd9k1yD16iXWR7jMX01gcAJ1/abJ/nP
         1Z+ZFB5HxbZtRIl+R+OeqylTbjTeFLshL25BM07Q/ADM2PzlEUkxHySdCia08QOuQM5p
         CCBnBlMLaidFwSwwGc5l+NxK7Z09OWPU/Z9AY2GngNLytgCMRqNRvh+z8a9HUPVGZ4Qs
         NncZ8Dv1iqfbkTV/oLKGTKuR+Dw6HDvg85zRV+21cyFHb0Eq/9PkVYGJca5qzHU+6gAr
         kN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6EGHE7XAaLVZ/AspOBqL9+WxC2EzdwtbJgY13u/uqSU=;
        b=gBRE2bu8aYEwFUgaEi1NWoHSacd8L0ENx+I3znqItbjj8XJP/rq8b2gGAjPdqJTu0I
         DwyYVc5Yx3/5nx2oUY5toPmNpoyfpqMqdgqytJEg/bCEMpKFj2ZN77RiSnewgDcxqJFq
         qyCcwMVGLNTi8ppOoYuj7ppCxnF45uPlt+wve0iRELXRBGZVhs8ipjfH21zqMT4Tl5oa
         u8JggTJ4GjJvvwYt2ILkCezNSb01CejBHNxYbbF5kcQVkEkmNtrUjuG0wPLyS0Q4fthE
         LMmmTYLtVNERFqsJUt48+O1hnQGMIx/XVdpNP2ryggpMdoepgx90FOMr711E3A+hcgdh
         Rc0g==
X-Gm-Message-State: ACrzQf1q2n7Mf4x0dmth+mgNqBgqe8MVEjzgTTs7Oz1lpgJkiJEaAwJf
        DBTdTNsXQ8AH6WOx/LkuWFo=
X-Google-Smtp-Source: AMsMyM6SwKaU62KbiW35Wz1Rs+k/SBxOqLESKn79uRsa6EbJSbPcrVQGB15RGyNDpyJtu8qGEM4HCg==
X-Received: by 2002:a5d:414c:0:b0:22c:de8a:d233 with SMTP id c12-20020a5d414c000000b0022cde8ad233mr12153514wrq.194.1666351630593;
        Fri, 21 Oct 2022 04:27:10 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id t18-20020a5d6a52000000b0022af865810esm18734205wrw.75.2022.10.21.04.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 04:27:10 -0700 (PDT)
Message-ID: <585dfb72-1bcc-d562-68b5-48d1bacd3cac@gmail.com>
Date:   Fri, 21 Oct 2022 12:26:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: IORING_SEND_NOTIF_USER_DATA (was Re: IORING_CQE_F_COPIED)
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
 <3e7b7606-c655-2d10-f2ae-12aba9abbc76@samba.org>
 <ae88cd67-906a-7c89-eaf8-7ae190c4674b@gmail.com>
 <86763cf2-72ed-2d05-99c3-237ce4905611@samba.org>
 <fc3967d3-ef72-7940-2436-3d8aa329151e@gmail.com>
 <7b82ab4e-8612-02dc-865d-b5333e7ad534@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7b82ab4e-8612-02dc-865d-b5333e7ad534@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/21/22 11:15, Stefan Metzmacher wrote:
> Hi Pavel, and others...
> 
>>> As far as I can see io_send_zc_prep has this:
>>>
>>>          if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>>>                  return -EINVAL;
>>>
>>> both are u64...
>>
>> Hah, true, completely forgot about that one
> 
> BTW: any comment on my "[RFC PATCH 0/8] cleanup struct io_uring_sqe layout"
> thread, that would make it much easier to figure out which fields are used..., see
> https://lore.kernel.org/io-uring/cover.1660291547.git.metze@samba.org/#r

I admit the sqe layout is messy as there is no good separation b/w
common vs opcode specific fields, but it's not like the new layout
makes it much simpler. E.g. looking who is using a field will get
more complicated. iow, no strong opinion on it.

btw, will be happy to have the include guard patch from one of
your branches

-- 
Pavel Begunkov
