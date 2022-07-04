Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564D7565326
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 13:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbiGDLRw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 07:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiGDLRv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 07:17:51 -0400
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FDFFD39;
        Mon,  4 Jul 2022 04:17:50 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id c131-20020a1c3589000000b003a19b2bce36so2184757wma.4;
        Mon, 04 Jul 2022 04:17:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+VL49oyTMqtQVlCZQv7iwps6wPC1IEZF9C70oZ/eY/E=;
        b=Q8omAhSRJ21uiAi+lGUaC+NvDSw7+JaUdycofei5DDAqEnlZIvuVfuqE4deukVT438
         x9kHaB8TN9duz/3O4ZngUD2qyrjbf+7hbFHhVmymFMO1sc1pbiucPm/wAw0vcHPJmexp
         bUQ2DIKVuLUXPTHZ6ohMgGYI8Qv5B5YMJZ0kM7LKaKR8gVLZHE6TmxbraD6EFKgvP33G
         m4nhmxdf8JjF1s745fzaPNgJSjk70H5a+8SVMLI55i421xDwTaKlZ1X1LKSS1v27eRL9
         Ruirt9lAgxgYhJpprmBWFtLmsQXZ7CgM7UQYRqiHM45w378f1KAR2Ilt4MW1vWOdvHen
         xWQA==
X-Gm-Message-State: AJIora9VKjsLiQfQtt99KdY0voE1DsrUboeVmgNnssvTshM+5d6DuTq7
        sDTkO5WXFCFCmBAb+7ctzxM=
X-Google-Smtp-Source: AGRyM1sI+vQroUA/Vkxn7ULBTwqUFMiFSJmU+g7j2cR0l8XO+EmRduZcIIL8U0SLQVYARIbtVwn9JQ==
X-Received: by 2002:a05:600c:2246:b0:3a0:4d14:e9d5 with SMTP id a6-20020a05600c224600b003a04d14e9d5mr30579509wmm.70.1656933468513;
        Mon, 04 Jul 2022 04:17:48 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id ba15-20020a0560001c0f00b0021bae66362esm26953312wrb.58.2022.07.04.04.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 04:17:48 -0700 (PDT)
Message-ID: <da861bbb-1506-7598-fa06-32201456967d@grimberg.me>
Date:   Mon, 4 Jul 2022 14:17:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH V3 1/1] ublk: add io_uring based userspace block driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20220628160807.148853-1-ming.lei@redhat.com>
 <20220628160807.148853-2-ming.lei@redhat.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220628160807.148853-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> This is the driver part of userspace block driver(ublk driver), the other
> part is userspace daemon part(ublksrv)[1].
> 
> The two parts communicate by io_uring's IORING_OP_URING_CMD with one
> shared cmd buffer for storing io command, and the buffer is read only for
> ublksrv, each io command is indexed by io request tag directly, and
> is written by ublk driver.
> 
> For example, when one READ io request is submitted to ublk block driver, ublk
> driver stores the io command into cmd buffer first, then completes one
> IORING_OP_URING_CMD for notifying ublksrv, and the URING_CMD is issued to
> ublk driver beforehand by ublksrv for getting notification of any new io request,
> and each URING_CMD is associated with one io request by tag.
> 
> After ublksrv gets the io command, it translates and handles the ublk io
> request, such as, for the ublk-loop target, ublksrv translates the request
> into same request on another file or disk, like the kernel loop block
> driver. In ublksrv's implementation, the io is still handled by io_uring,
> and share same ring with IORING_OP_URING_CMD command. When the target io
> request is done, the same IORING_OP_URING_CMD is issued to ublk driver for
> both committing io request result and getting future notification of new
> io request.
> 
> Another thing done by ublk driver is to copy data between kernel io
> request and ublksrv's io buffer:
> 
> 1) before ubsrv handles WRITE request, copy the request's data into
> ublksrv's userspace io buffer, so that ublksrv can handle the write
> request
> 
> 2) after ubsrv handles READ request, copy ublksrv's userspace io buffer
> into this READ request, then ublk driver can complete the READ request
> 
> Zero copy may be switched if mm is ready to support it.
> 
> ublk driver doesn't handle any logic of the specific user space driver,
> so it should be small/simple enough.
> 
> [1] ublksrv
> 
> https://github.com/ming1/ubdsrv
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/block/Kconfig         |    6 +
>   drivers/block/Makefile        |    2 +
>   drivers/block/ublk_drv.c      | 1603 +++++++++++++++++++++++++++++++++
>   include/uapi/linux/ublk_cmd.h |  158 ++++
>   4 files changed, 1769 insertions(+)
>   create mode 100644 drivers/block/ublk_drv.c
>   create mode 100644 include/uapi/linux/ublk_cmd.h
> 
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index fdb81f2794cd..d218089cdbec 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -408,6 +408,12 @@ config BLK_DEV_RBD
>   
>   	  If unsure, say N.
>   
> +config BLK_DEV_UBLK
> +	bool "Userspace block driver"

Really? why compile this to the kernel and not tristate as loadable
module?
