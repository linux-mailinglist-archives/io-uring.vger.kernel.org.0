Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6EB14F6337
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 17:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbiDFPgL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 11:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbiDFPf4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 11:35:56 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02A548BAA3
        for <io-uring@vger.kernel.org>; Wed,  6 Apr 2022 05:49:55 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id s11so1839153pla.8
        for <io-uring@vger.kernel.org>; Wed, 06 Apr 2022 05:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=tzLq5MPRziWr19rGDTjDvJ6kUvJxN81sPnqKnJVnHNI=;
        b=S7CYRB2sjl9kK1+2v2oWmf7Z6tvPKr/e8AZTMD2Pp7lGJsLt/0nHs12GBlrw09Y8W/
         bGUzJyWOxIIBIsiNK5D5W2tmuH41LsLkVziSDXYNW96cqxPlayYLHO0Cllxr8+7jc/Zg
         3XI98irNcQyzGY0XQy0YAGAVQrSA85qMFS8rvtxNz9yCsta0aY1zPPUJP4CLV6ossnBC
         Ybq6ziXqn0/e7rHyqtBl3OaLUAbOD8GthiIrLeWhzamnvCtLYM6zPuKjeBksmDtxc7ZC
         Bo+IJ4xSoMokQvsg1sTUf6gu1NPCqJ6UTF9QqceJRqIM5rVa8ptF/ob8FB/UzkMgHbKV
         ibnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tzLq5MPRziWr19rGDTjDvJ6kUvJxN81sPnqKnJVnHNI=;
        b=SjWjwgwmU0hadfBuIA9gXuM2b4icV33HXeHZ2F/7beeJM6LtY/vyKqqpLaHLYx7HuG
         GicIBXB6z9v4fSyyRMbT7a9CA4kD9TU5fAef5LgQwebjnobfEFwVKWHvUSu0kq+vCc/8
         dYhFUavUX2tIrXHnWc3Vw9/9YyBrpYeVvbqLnuQNDMnGBGbaHPBATaDJcN5AeWI86wOf
         oumdlQexmFpC3mAWnv0oCEjYYIwDIt6TjMUAdFbUDTR0lU1g44Mkdvhg8scYJxxCWhRe
         P4px+8sULyQP+pXP0cLDiL76cm7s5M+zVVMrNTepI6IHT4VG/mEhaY4hl+3GEK2Eg26z
         SVZw==
X-Gm-Message-State: AOAM533Wjsn6LDgaEgaaig0Audb763WDDOqu+axpFMw9uwFF5ltRB4nO
        VXcbyPZGn5oNOCuHDcmz3R1QLO3EDedYRw==
X-Google-Smtp-Source: ABdhPJwXcZ1wTsIvXoELNWuDLnGSTcSV5BKun4Zh1p9GL8JMfBqVhMqarzMX7XfA4FfqEtDSn55lZg==
X-Received: by 2002:a17:902:d4c1:b0:153:d493:3f1 with SMTP id o1-20020a170902d4c100b00153d49303f1mr8488651plg.102.1649249276231;
        Wed, 06 Apr 2022 05:47:56 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f6-20020a056a00238600b004fae79a3cbfsm20702507pfc.100.2022.04.06.05.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 05:47:55 -0700 (PDT)
Message-ID: <10f1d5cd-d76f-e6b6-76e9-c7d92fecf9e7@kernel.dk>
Date:   Wed, 6 Apr 2022 06:47:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 0/2] io_uring resource handling fixes
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1649245017.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1649245017.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/6/22 5:43 AM, Pavel Begunkov wrote:
> Two small fixes for rsrc infrastructure
> 
> Pavel Begunkov (2):
>   io_uring: nospec index for tags on files update
>   io_uring: don't touch scm_fp_list after queueing skb
> 
>  fs/io_uring.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)

Thanks, applied.

-- 
Jens Axboe

