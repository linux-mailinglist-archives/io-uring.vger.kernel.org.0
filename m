Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48095577F8
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 12:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiFWKfl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 06:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiFWKfh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 06:35:37 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D704A3E3
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 03:35:35 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id p6-20020a05600c1d8600b003a035657950so248165wms.4
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 03:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BKA2F3tX06TYb4NK5mnAOXWxcPMd42XpOCojCSwuSo8=;
        b=i1/hOqmgNdhjOiUS9D+P9K4VlkimOMP3VZ+TFm4d4Pka7ZCJM1LPwydSApsseL66HK
         Sjw4BFoaboOxCAW/V3kAr0VXKpGFYgZYAYUE0W2GDH0hzwqWSeYCa6UtBaR2DKgf1q1w
         c2uQSJJWpKVn2dJXLK5LnbhwtDHT3MIW2xrP1wCqPvROME5zKgg8G9MGLiTh/MzEthx6
         W63Bn6TNhlFuDjJcRtDNZx3yy4H73HEl4kJ5xyj8Kjn1duToJedqU9+4kwPJ5WiwAGml
         3xPrPc4z4hjAIIc3BaZ+blP1rleGeZZy/JrNP8q5ZIb9cBma7Om/FytK3w83DaYHg6kz
         vp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BKA2F3tX06TYb4NK5mnAOXWxcPMd42XpOCojCSwuSo8=;
        b=7l0F5n4M9GGSTm1hJqiWRhPMsWdrRckQim4hPnk00Xs0Tmd25wIB1+4nXEufwSgTYS
         sXOt9Gc5+ln8GMhAJBYDS34G3XA7jcbLt4dlVAGNfEEgJyQWFjnisXEE/AKYgTrTLFSq
         x7In/OZP98VmvnkW8SCCHrHOfYKqaz0ahrLXhBTFM5U5O8oTGZ1u7fG2alifUC9mcjO/
         I1pTgYtRbYV4q02kcSX+v4weKnAoLdmIt+7bY24bZTV4jRaHHC88lcA8ZOlA67CsYHGY
         LOkLT7YgU2mBQT1VTESF+oiiZp1W3ZCfrBAEs4QlvASDir5LFwqioqbdgNkiEoHEkjab
         pJXA==
X-Gm-Message-State: AJIora9PUJzId+1zaHewCg8BTSyXLntgLY+1noxJ/mgPDPrJ4vXcylWw
        u0RkxIVdKXpM/M65A0bk9ZM=
X-Google-Smtp-Source: AGRyM1uCP51jWmeH3AEHooPngNlsd9HcUEdJIue8IHLeGr9MrKZG63jOvPHlmCbXYxbVzG9VKIl1NA==
X-Received: by 2002:a05:600c:1c0e:b0:39e:f120:c216 with SMTP id j14-20020a05600c1c0e00b0039ef120c216mr3359928wms.163.1655980533985;
        Thu, 23 Jun 2022 03:35:33 -0700 (PDT)
Received: from [192.168.43.77] (82-132-229-4.dab.02.net. [82.132.229.4])
        by smtp.gmail.com with ESMTPSA id cc3-20020a5d5c03000000b00213ba3384aesm21837676wrb.35.2022.06.23.03.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 03:35:33 -0700 (PDT)
Message-ID: <42611180-e6a0-e700-d0ac-b007d8307ea4@gmail.com>
Date:   Thu, 23 Jun 2022 11:35:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: dma_buf support with io_uring
Content-Language: en-US
To:     "Fang, Wilson" <wilson.fang@intel.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>
References: <BY5PR11MB399005DAD1BB172B7A42586AEFB59@BY5PR11MB3990.namprd11.prod.outlook.com>
 <BY5PR11MB399055971B9A3902CC3A3121EFB59@BY5PR11MB3990.namprd11.prod.outlook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <BY5PR11MB399055971B9A3902CC3A3121EFB59@BY5PR11MB3990.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/22 07:17, Fang, Wilson wrote:
> Hi Jens,
> 
> We are exploring a kernel native mechanism to support peer to peer data transfer between a NVMe SSD and another device supporting dma_buf, connected on the same PCIe root complex.
> NVMe SSD DMA engine requires physical memory address and there is no easy way to pass non system memory address through VFS to the block device driver.
> One of the ideas is to use the io_uring and dma_buf mechanism which is supported by the peer device of the SSD.

Interesting, that's quite aligns with what we're doing, that is a
more generic way for p2p with some non-p2p optimisations on the way.
Our approach we tried before is to let userspace to register dma-buf
fd inside io_uring as a register buffer, prepare everything in advance
like dmabuf attach, and then rw/send/etc. can use that.

> The flow is as below:
> 1. Application passes the dma_buf fd to the kernel through liburing.
> 2. Io_uring adds two new options IORING_OP_READ_DMA and IORING_OP_WRITE_DMA to support read write operations that DMA to/from the peer device memory.
> 3. If the dma_buf fd is valid, io_uring attaches dma_buf and get sgl which contains physical memory addresses to be passed down to the block device driver.
> 4. NVMe SSD DMA engine DMA the data to/from the physical memory address.
> 
> The road blocker we are facing is that dma_buf_attach() and dma_buf_map_attachment() APIs expects the caller to provide the struct device *dev as input parameter pointing to the device which does the DMA (in this case the block/NVMe device that holds the source data).
> But since io_uring operates at the VFS layer there is no straight forward way of finding the block/NVMe device object (struct device*) from the source file descriptor.
> 
> Do you have any recommendations? Much appreciated!

For finding a device pointer, we added an optional file operation
callback. I think that's much better than parsing it on the io_uring
side, especially since we need a guarantee that the device is the
only one which will be targeted and won't change (e.g. network may
choose a device dynamically based on target address).

I think we have space to cooperate here :)

-- 
Pavel Begunkov
