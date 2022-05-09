Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B76A5201D3
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 18:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238762AbiEIQEv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 12:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238782AbiEIQEs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 12:04:48 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DCB4348C;
        Mon,  9 May 2022 09:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=K4xQBj4Av+1aVjNhecQZcLi4H026zPkK8lu/o3+s21g=; b=rOjuL7YPniMy57b1u6dI1Hc5gO
        rKc00pRpI9pgmRtNEEcVp95ObH3NAvHKO0BxqgakABdsxT9w+vcSkLYMwRjeF2Rt45LH5W1qKAuIZ
        ee+AO/YgQEUbFIHFmMFnIqyY9ChcwENCGmSHKicuGx7ma8Eo8+/LYP6uojVxFJ2e0tYnpVbdQnl0O
        dSaNJ0/D4luEL4aN9muESKMxTtgGFq9TtirNLRMve3iMs5/T6IrrvEKXu4E4UHYhdpG9273XhLFVO
        V3RsnWiOJ/sGCXTDhAGHTasPCLV5P0mqttJVyO3vg1+8boxC98anD2srszHHJ8zSGlIWP+W+fdPuq
        9i0DKLEQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1no5oR-00CbQM-Sb; Mon, 09 May 2022 16:00:44 +0000
Message-ID: <8e3ecd00-1c73-7481-fec2-158528b2798f@infradead.org>
Date:   Mon, 9 May 2022 09:00:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC PATCH] ubd: add io_uring based userspace block driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <20220509092312.254354-1-ming.lei@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220509092312.254354-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/9/22 02:23, Ming Lei wrote:
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index fdb81f2794cd..3893ccd82e8a 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -408,6 +408,13 @@ config BLK_DEV_RBD
>  
>  	  If unsure, say N.
>  
> +config BLK_DEV_USER_BLK_DRV
> +	bool "Userspace block driver"
> +	select IO_URING
> +	default y

Any "default y" driver is highly questionable and needs to be justified.

Also: why is it bool instead of tristate?

> +	help
> +          io uring based userspace block driver.

-- 
~Randy
