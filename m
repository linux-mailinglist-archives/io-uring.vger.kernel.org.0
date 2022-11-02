Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FBA6161D1
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 12:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiKBLdm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 07:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiKBLdl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 07:33:41 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FF824BF9
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 04:33:40 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id t1so6786117wmi.4
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 04:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BFJT5ArWtVNrlEr9QK2DOmcXi6YDrVPdBxfc7FnJAyM=;
        b=eFdoIVhSSUNPZf5dmDqsoKIEgrzd0yr0/2EJNEURLIDEZpjTy1FKcjLfhuklbI35Zj
         ZLyCauClxW/YNa4rKOVBcz6z+/qfAtPg+ZL52LCc/axwdrBRVGB0mcbLk4qMNVxiJa0x
         tfaloyvw9rYSKh5agpLAJSWc1AH5G1pfdXp+9jKL4u0Wi3j/WozC8F5b24+vnIjFdhcc
         RhxdnSuNpPWzjSiEhALj137Hgb0h7q+zR6XhZvMa8VZ6lCZmdoPqluqAbckMFClTV1Bx
         Px0+KRB0EVzakhAyzRRJO3uxjdXhhXDyWesAIj3coSwyavdlI4zrDcgEixybkJjS914P
         lgNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BFJT5ArWtVNrlEr9QK2DOmcXi6YDrVPdBxfc7FnJAyM=;
        b=BJGCX2uyeNL+hYbdWWsjpcu4JkSSjfAB6Igtk575L6qAtBEZjFPWuuwiqoGlpCgKIn
         Lw5PsL3P52fDYNPbZk2DY4NA5EPJM2/xx9trD5ZOON9LALm2CukG/ElV2Loti2NLvbI6
         YFw5fVuxOefep8Ks947u4qBrVIrMu4olowLjx5ToXE5v/UK01XIDE+1GlBe84xYhPwRg
         4ATPuDTRpr1AioXAkbhs5WuHkhX1u/KJODx3DB/j7GF6VcPXecHUh11S1vbaKFW5GNnA
         Tu2vjwpuAxg5m+rRTxHMxfIlZ6oOKTP5QlTpIFH8HSOZQxhMvU0QYAInN/+Jdmf3DD89
         Vupg==
X-Gm-Message-State: ACrzQf0nwb0nPJYielXGZU/urDZGtP99Ubj+MJN3uuL/pCriTLIMWxFq
        OqICPChOOjQtATedqW4znMifcKnF4PQ=
X-Google-Smtp-Source: AMsMyM5c5VZ10HhQ0SVZTQ5r09+kjfXLks9BSq+PTpX//NgQU1F0hZ9mTmRIpbYPGlmI3F29SxEb9Q==
X-Received: by 2002:a05:600c:746:b0:3cf:705c:d8d9 with SMTP id j6-20020a05600c074600b003cf705cd8d9mr10968546wmn.42.1667388818975;
        Wed, 02 Nov 2022 04:33:38 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:2739])
        by smtp.gmail.com with ESMTPSA id b6-20020adfee86000000b0023677fd2657sm12614522wro.52.2022.11.02.04.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 04:33:38 -0700 (PDT)
Message-ID: <76be6e82-7aa4-b35e-5a8c-ee259af8ec41@gmail.com>
Date:   Wed, 2 Nov 2022 11:32:41 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-next 07/12] io_uring: split send_zc specific struct
 out of io_sr_msg
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221031134126.82928-1-dylany@meta.com>
 <20221031134126.82928-8-dylany@meta.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20221031134126.82928-8-dylany@meta.com>
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

On 10/31/22 13:41, Dylan Yudaken wrote:
> Split out the specific sendzc parts of struct io_sr_msg as other opcodes
> are going to be specialized.

I'd suggest to put the fields into a union and not splitting the structs
for now, it can be done later. The reason is that the file keeps changing
relatively often, and this change will add conflicts complicating
backporting and cross-tree development (i.e. series that rely on both
net and io_uring trees).

-- 
Pavel Begunkov
