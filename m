Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97474B961D
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 03:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbiBQCwh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 21:52:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiBQCwh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 21:52:37 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495BB1162B3
        for <io-uring@vger.kernel.org>; Wed, 16 Feb 2022 18:52:23 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 12so220886pgd.0
        for <io-uring@vger.kernel.org>; Wed, 16 Feb 2022 18:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j6m+l1oUecnNNLOok0/YBcj8+iHstx9eNeTw7wBI+vA=;
        b=1NIhBqfb2bt9IE2LPyzVew1RAtL5yrCM88EQpdmg6GEr8qnOkpIWCQ89qbETK3wn41
         405LfItUQrIwoslP8n9/+YWIZ8h07NA8EsHoSRppWXR20HRyv5w/21fyTrXSvRVAN8Y7
         OA5NYmoCc5xvn/zNbOGlCKoNQn+lLaqk/EM8oTUGT8tt6yVjkqfhZh3B0yxDqNF7fpW8
         +qDsvS3dKCxFJqyolz+geks4B1IuZCkWgZcOjtXovaSco6y/Zk6tprtJRVnq4prlsggc
         wsi4mUiJ+iiDJfN6TG9wrURJIjEV1r0soDnfP80XcpxiCpCfD0I77qRSeiutRLYLim/7
         g/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j6m+l1oUecnNNLOok0/YBcj8+iHstx9eNeTw7wBI+vA=;
        b=VWW7c2yExZHoI4lmpBDVIzLxEAGATjbHbpxd2ugkVBkbN+5fLzAxUaQtmFeApjpM6N
         HE8SA26lGpbQQa5Wwl8QjobEyuKnO5kJUIulPos2u4OiWQ8bI6enzoF1B77YptKwpsuk
         NKeTHueK2ZA+C5zLVIdoXnNj1JQ4Qw9115BCHu5NcG3taMJvDZT5r8xqXPzatE+PfqpX
         PVXTCLj1Y7bkAiY2b8ORLDny3o9M42HUwXM8PCND+UofN2x6vRdkCUoZgoS5Va85LBXX
         b9RJXf5kPKFVQQUiO1NpQTjx5DrcWAAkB0ShcR2E9RcwHszz//UGI3svxL4hikSGrhy5
         sqQQ==
X-Gm-Message-State: AOAM530ykhkHwkB6WLb6gkkRsr2/vwAgkae2tQMwnYzbWtouEdiKgyWE
        fxZLLaOSVppU/eY1c8WD1ASu/A==
X-Google-Smtp-Source: ABdhPJw5EWuYRb71wLCJIIGBT4noHs4G6tbIHUSogiGVkMhwAu8zdLPxq3GuTH+vZb/3vCh0Kw73mQ==
X-Received: by 2002:a62:63c2:0:b0:4e1:604:f07 with SMTP id x185-20020a6263c2000000b004e106040f07mr851283pfb.56.1645066342700;
        Wed, 16 Feb 2022 18:52:22 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b8sm1263990pfv.74.2022.02.16.18.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 18:52:22 -0800 (PST)
Message-ID: <384cd4ed-6727-d7d0-b267-6a19f58df7eb@kernel.dk>
Date:   Wed, 16 Feb 2022 19:52:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC 03/13] io_uring: mark iopoll not supported for uring-cmd
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, hch@lst.de, kbusch@kernel.org,
        javier@javigon.com, anuj20.g@samsung.com, joshiiitr@gmail.com,
        pankydev8@gmail.com
References: <20211220141734.12206-1-joshi.k@samsung.com>
 <CGME20211220142233epcas5p3b54aa591fb7b81bfb58bc33b5f92a2d3@epcas5p3.samsung.com>
 <20211220141734.12206-4-joshi.k@samsung.com>
 <Yg2wA2xxrDthoCDi@bombadil.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Yg2wA2xxrDthoCDi@bombadil.infradead.org>
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

On 2/16/22 7:16 PM, Luis Chamberlain wrote:
> On Mon, Dec 20, 2021 at 07:47:24PM +0530, Kanchan Joshi wrote:
>> From: Anuj Gupta <anuj20.g@samsung.com>
>>
>> Currently uring-passthrough doesn't support iopoll. Bail out to avoid
>> the panic.
>>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> 
> Jens, can you fold this in to your series?

Yes, we really need to spin a new series with the bits combined. I've
got some ideas for that...

-- 
Jens Axboe

