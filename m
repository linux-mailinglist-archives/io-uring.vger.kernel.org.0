Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0D57696D8
	for <lists+io-uring@lfdr.de>; Mon, 31 Jul 2023 14:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjGaM4K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 08:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjGaM4K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 08:56:10 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3B6E46;
        Mon, 31 Jul 2023 05:56:08 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-991da766865so711102966b.0;
        Mon, 31 Jul 2023 05:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690808167; x=1691412967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ziq8GvakOgPiU2KBprCo4YVywArPvGqYAyVmhmNh8fY=;
        b=UcDTpgC20rz+CPCBA+mx0Y2sF8mKohFoZC/KF7TBEQXY5NABf8IGgsnLSiCSxf9gnw
         HEI06mujtUFBVtpqf+uD4rWOIKth0JsrU9sWfI+N/L1O3jQTF+683o7Nl4IdVs79CEJK
         TgqI2ooPTsOD4SmZyw2BXMCRYskfKuqSJal3u4fHlqho2In9wf2nYJ7Zg2bUCxn6thX0
         zSP2RrOhy696Wrzs7of4udkf1xMEQzRqcoiCPpo7DzVeUetvvQOj8+T2n/SrkC0WO6q1
         1Q6hEEkXx2EVdTIpripBB3k9shuiaiKyR6WxF0t8FnSGcFT68eT5CJDp1FaU2js9PxZE
         4obA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690808167; x=1691412967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ziq8GvakOgPiU2KBprCo4YVywArPvGqYAyVmhmNh8fY=;
        b=PFgajf7uyKmxiPYKiQeq4m2qrnoi0XVBNuguMnaQO7sabBMfXet7cwQykr09p/85cd
         eEHCiF0Scq3W4qKzadFvJpK2Z/wZMsHney/cfZTRnkNeeTdNupnjs887XjDZ1Tj6GI5T
         BTcDbOQRaX85pmz2e4caUshTZ2ia/GOahb2IoEzXBA34HTOuu68R/F3tpeea6iEOAZAr
         vtmvCbZm1DpEfXFMpwxXRKjFbnsGq0NbIb1SCu0336K27DBxCuFdc0GNJqQ0usdkyHip
         A6IuHX5/5XNGYbILzj2UHnYL0jy9aDa6LEKKMMyHtpqCvXQCrSdSem6FLwOyQPFuXIH7
         xRTA==
X-Gm-Message-State: ABy/qLb5MTpW2953pb0GZxne9IQRwhvc6tsaEec8su96S4qNZn3ibQNo
        r4zzHs3KTkjceg8ocjW2pS2TfRkL3Ng=
X-Google-Smtp-Source: APBJJlFs3w3m21J9qxYLgIZmFxZdxdMS8UQzoFRxPFirCiuOXaNldCtwsezfUSLaTZIjmHSecJoJEA==
X-Received: by 2002:a17:906:f252:b0:99b:dfd7:b0d3 with SMTP id gy18-20020a170906f25200b0099bdfd7b0d3mr6850941ejb.56.1690808167046;
        Mon, 31 Jul 2023 05:56:07 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:94b])
        by smtp.gmail.com with ESMTPSA id ci18-20020a170906c35200b0099bd682f317sm6059419ejb.206.2023.07.31.05.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jul 2023 05:56:06 -0700 (PDT)
Message-ID: <9a360c1f-dc9a-e8b4-dbb0-39c99509bb8d@gmail.com>
Date:   Mon, 31 Jul 2023 13:53:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: split req init from submit
To:     Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>
References: <20230728201449.3350962-1-kbusch@meta.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230728201449.3350962-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/28/23 21:14, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Split the req initialization and link handling from the submit. This
> simplifies the submit path since everything that can fail is separate
> from it, and makes it easier to create batched submissions later.

Keith, I don't think this prep patch does us any good, I'd rather
shove the link assembling code further out of the common path. I like
the first version more (see [1]). I'd suggest to merge it, and do
cleaning up after.

I'll also say that IMHO the overhead is well justified. It's not only
about having multiple nvmes, the problem slows down cases mixing storage
with net and the rest of IO in a single ring.

[1] https://lore.kernel.org/io-uring/20230504162427.1099469-1-kbusch@meta.com/

-- 
Pavel Begunkov
