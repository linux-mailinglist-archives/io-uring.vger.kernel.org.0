Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA655552D0
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 19:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377325AbiFVRsy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 13:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377457AbiFVRsv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 13:48:51 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FB433A23
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 10:48:50 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id 19so18368089iou.12
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 10:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=K33HT2mPY+fGTrIPZFvTbbrKHvQd+MDPdPT18kII9zE=;
        b=Ao7+gzlvHWxGjPdlUKlFNuOf60PUjSnZBFyOEOMkLAVA5CoIPb/X8SGUosUCR9WlYq
         INAarl+juxAtsT+HHoSFksJDHJbu+c/KtOQCi5z37mdjzZ28X1dvq2zRa70JSrLSq2RT
         kKp0oDEe2kVM0Q9Xd4fzG2KWGLTVP+dEyv7JF5kJxVTBbqcQHMLHODm7lI3b7KLeQNQ6
         Z42imq7r1b5gg2aaeNL/usxzpYd3H1cpCBLha07VY6k29mYp8qU2K6J/lxzCgGkJb3fJ
         OIBHzR7fPXJwHqULlPRAlspSUDzZu2n1w+cPVVX/KC03P77w2iUpdfTdBfolcjmZUVsx
         FqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K33HT2mPY+fGTrIPZFvTbbrKHvQd+MDPdPT18kII9zE=;
        b=sOPJcoiAzoXen9NAJqJ5Udi7Ri1O7EsA8JJENVW+BtRdEVkI5MGY1Gy294yGCUcsfo
         UHFfouyK/9HAZxkItXm5eg9tSaW/9xhQKsjwovlrC/olKmGWdAvANhFEKLU40fXLy+lA
         skIkyrecOVItODA5TygObyYKwYgvawBvkpiWNeUymHgyADljpcHIf/ZTjWLQaszTNqTO
         Gonh87Hgk9CexRIrr2rG4mF6jybuw3c5KaWeZrS9hJnacLwr2HpOlmGmflBmotT7hYOm
         yaojqq9AvkqGayE+xf9EocQKYhbaS02TrsYHK6NcX47bJnCu9xGxLWvM4RvS5M2msjEC
         MGRw==
X-Gm-Message-State: AJIora9dTxU+ZTuBXCoNXvaPug9zFW9HKYePjHD70URnyhm38NOuNvEH
        o+zK1InHCsRJkT0wLMbdcXpJig==
X-Google-Smtp-Source: AGRyM1sC06YOI0pAbSLw8GZ1EDu2DiPuOR/0WHjkpZYlg+mBcVKXdWTaEGajo0LeU6wcx88JArRttg==
X-Received: by 2002:a05:6638:264e:b0:333:e9ca:a674 with SMTP id n14-20020a056638264e00b00333e9caa674mr2943481jat.85.1655920130068;
        Wed, 22 Jun 2022 10:48:50 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o3-20020a92dac3000000b002d92692f387sm2740361ilq.43.2022.06.22.10.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 10:48:49 -0700 (PDT)
Message-ID: <40f6127c-3211-5152-f767-3c63174349a5@kernel.dk>
Date:   Wed, 22 Jun 2022 11:48:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: kbuf: kill __io_kbuf_recycle()
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220622055551.642370-1-hao.xu@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220622055551.642370-1-hao.xu@linux.dev>
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

On 6/21/22 11:55 PM, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> __io_kbuf_recycle() is only called in io_kbuf_recycle(). Kill it and
> tweak the code so that the legacy pbuf and ring pbuf code become clear

I have applied this one as I think it makes sense separately, but I'd
really like to see the ring provided buffer recycling done inline as
that is fast path for provided buffers (and it's very few instructions).
Care to do a patch on top for that?

-- 
Jens Axboe

