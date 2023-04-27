Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5D46F0790
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 16:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244020AbjD0OfK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Apr 2023 10:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243466AbjD0OfJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Apr 2023 10:35:09 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF92B133
        for <io-uring@vger.kernel.org>; Thu, 27 Apr 2023 07:35:07 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-760dff4b701so50022839f.0
        for <io-uring@vger.kernel.org>; Thu, 27 Apr 2023 07:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682606107; x=1685198107;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C354NTiGocVM+FyDfk+2FbHTWl2OmrzzBUVpzCd4GkI=;
        b=Ct0ovBegLxj1cb7gOD12n5RcVAHsXsM8Ryt9OzBPN24nAl4zPDf9kscEimMFprl37e
         QMuuNDkSlf5UBa+qaf9Skvv651AJRtswcyhcsOJOgWQgOGDkSVET/pF6A1IGKPhyjz30
         DdKFyWNwiReDEpfz4oxZsTtelryUmfhb0JkSRZVvhszin9368ypMKr6wDMda/m1zIBic
         wI2SQ11g7WC2WXaMgscKArZ9Hk+AS8AeoEwu+Jgo9bQ454ghhZFBxvQRAZ7zWQNGPBsU
         RF7Pqgl55d/irUL9o/U/HJ9zWiWrQhOQ6keukNfxmvzkz8FPF/+dgVuzpVxvKWLCfoil
         fYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682606107; x=1685198107;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C354NTiGocVM+FyDfk+2FbHTWl2OmrzzBUVpzCd4GkI=;
        b=ix3YD06o6GJPk6q6Xs0cG97wXxmcWUaaDqXckOjHzCMqqRJeiJmpywkuyhvsLJdcS2
         sK2038pm8ZbyYapKcVFs3DKQqqt335yw+5exukUHXTufkT7pWNFPswDKTMJUr5/Treb7
         5h5L45M2cGCh6IsM36jwbQ0eb23aEkpsT+1qOQcuS2Q5AqLawQ8N0IMXCQiFdiLGrzx3
         6BQjnaSAvNcwcaDBvTqd96G0CBHvzx00inD/lF3XmBaHAbcJiRRpYgt7LyqZ31CG44mu
         HHQQn++XlDcNLWwnoTcHWxpvT81QQmnhZXWl3A6g0jII/v9plAsxcVos1icuOXSmYxvB
         oA/A==
X-Gm-Message-State: AC+VfDwPjmoigyikfEdR4fnyk3yf1dMknm3nbFC2vpHUjKzjgAiCyRuS
        nI/skHvtDsUQ5isx3TWJnWNW2g==
X-Google-Smtp-Source: ACHHUZ49iHnoNPmYMgQmhF9w48A3JY0MEyHT2PJ08hMqcrwE6j5zJwyhW1NVxukGbltrqPHR2mLGwg==
X-Received: by 2002:a05:6e02:d82:b0:327:b69c:c202 with SMTP id i2-20020a056e020d8200b00327b69cc202mr973179ilj.3.1682606107306;
        Thu, 27 Apr 2023 07:35:07 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l17-20020a05663814d100b0040bbf478147sm5704032jak.163.2023.04.27.07.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 07:35:06 -0700 (PDT)
Message-ID: <6fdccc0d-a309-ee23-bfa8-bf03dc7c6ee1@kernel.dk>
Date:   Thu, 27 Apr 2023 08:35:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] io_uring/kbuf: Fix size for shared buffer ring
Content-Language: en-US
To:     Tudor Cretu <tudor.cretu@arm.com>, io-uring@vger.kernel.org
Cc:     =axboe@kernel.dk, asml.silence@gmail.com, kevin.brodsky@arm.com,
        linux-kernel@vger.kernel.org
References: <20230427143142.3013020-1-tudor.cretu@arm.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230427143142.3013020-1-tudor.cretu@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/23 8:31?AM, Tudor Cretu wrote:
> The size of the ring is the product of ring_entries and the size of
> struct io_uring_buf. Using struct_size is equivalent to
>   (ring_entries + 1) * sizeof(struct io_uring_buf)
> and generates an off-by-one error. Fix it by using size_mul directly.

Looks right, so we're doing one entry too much. This is probably a
remnant of when the initial version had it done a bit differently, but
we overlaid the tail with the first entry reserved field.

-- 
Jens Axboe

