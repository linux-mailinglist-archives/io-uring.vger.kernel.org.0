Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12495B9449
	for <lists+io-uring@lfdr.de>; Thu, 15 Sep 2022 08:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiIOG10 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Sep 2022 02:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIOG1Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Sep 2022 02:27:25 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5026A8C012
        for <io-uring@vger.kernel.org>; Wed, 14 Sep 2022 23:27:23 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id bz13so29193238wrb.2
        for <io-uring@vger.kernel.org>; Wed, 14 Sep 2022 23:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=tR/yc0qVr/pPmHhfdI0gHrbei1Gzu9NGG1oci8h9xR0=;
        b=Ck3Fh2gTt8ONtcrUimsop8mvMaN5nsAxP1hFUZdSpbh4qOm3OqvKnjBVKBV2NU48x9
         Zxl+dv4zw7A4nXMSBGXCJALvAR183MDCTlwgCzCRqTbIieclT5lHUNRgHdXDEpm1HfvU
         WaAslt/qhzSNqJPDJDYP3/3AEX3/isNWEn7FEAGSvWkkXYVcrACGIxGMtyGy9abAbBJB
         GP/l0wvddTVev0sfDej8Rlmy6BTU8PNZFxXpjnnc5IZ1bXDT2Mu9KfB5DFQ9E6tJzp4F
         YcHS+G/oulYrueYYfn/vHErc7tNsrr1ySsvLsumzj3s7qA/sorh/+A4JIdqGJHARtYIJ
         wZ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tR/yc0qVr/pPmHhfdI0gHrbei1Gzu9NGG1oci8h9xR0=;
        b=nIWRpa6UUo8QgbNdCwYqdIkPv4ZzVXbPtTlL14mcQcMvYVZQykPmJzRBWevDwEnFKF
         8167NlqK8Q2lkK5SlWxgwX6cTOrhdQTDVat73DjjT82sKu6O2rCFH0XUTLG/5i07jwU7
         32Dxs3j0coWvNtfIgOGxJwtmX/XXyMIrZ+t4h+3j6Hz5csf9kCMj6zFOZrHq1hmCrAO9
         OavztPwwE8hSn1Zzl2Wa5x+YVfIU9VZPxfoi0Jjrolunn2JXaB8Aee5f5Q+npdqbiXsR
         YvonDaj6H1jzRvTuI7pw6T0wNKw0Vz0WpGecVAwnEqnb06HkHr9LtFzLDnkgkmeY+7Uq
         G/LA==
X-Gm-Message-State: ACrzQf0eT0fuHFh4ZkKBBleYcmuy5cUOp41BupAfxk0ryTq0zgOz4pmf
        QDDRWSGtjvXoHNdJYsh5wIP9xQ==
X-Google-Smtp-Source: AMsMyM5jujrUocFcY/MzMzUAoDymbq2wVgR/kpk+SietGmAJg9k+8nlK433loz0NraJZPUNKoIF+Eg==
X-Received: by 2002:a05:6000:1a8b:b0:22a:cb74:eaea with SMTP id f11-20020a0560001a8b00b0022acb74eaeamr3012806wry.253.1663223241880;
        Wed, 14 Sep 2022 23:27:21 -0700 (PDT)
Received: from [172.16.38.121] ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id t16-20020a05600c199000b003b47b80cec3sm1566994wmq.42.2022.09.14.23.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 23:27:21 -0700 (PDT)
Message-ID: <f33df5e9-8162-16b3-c0e3-73aabea7471b@kernel.dk>
Date:   Thu, 15 Sep 2022 00:27:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] io_uring: rw: Fix an unsigned comparison which can never
 be negative
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20220915054909.81394-1-jiapeng.chong@linux.alibaba.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220915054909.81394-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/22 11:49 PM, Jiapeng Chong wrote:
> The parameter 'res' is defined as unsigned type, so the following if
> statement is invalid, we can modify the type of res to long.
> if (res < 0)
>   	res = io->bytes_done;
> else
>   	res += io->bytes_done;
> 
> io_uring/rw.c:265 io_fixup_rw_res() warn: unsigned 'res' is never less than zero.

This one is already fixed here:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-6.0&id=62bb0647b14646fa6c9aa25ecdf67ad18f13523c

-- 
Jens Axboe


