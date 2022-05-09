Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F55D51FDFC
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 15:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbiEINYL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 09:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbiEINYL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 09:24:11 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3132B164F
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 06:20:17 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id iq10so13157340pjb.0
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 06:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=zOTGa07wFO41kAbeqoRPySR+npoc6niQvNIM75IIO14=;
        b=Z17MKSpLb2yQOZ5PGPsj6uCNzO6Vw++GHCRCFILsfFL0m2d5SnvGHHytvwnGwbv7N9
         UWs4mA8aMepW1bxLEiudMQ+kmyc7B/+vMDyi5BIlwP3Y92jKg/shjRLIgx9hroit9JA/
         ZvcO7B8BaPuVq+0fbuqvPsn2tghagj7zn2eFmMNmwVJqHq7OoX4HJwfPDhN+Mxgue0Tz
         GkwVQGcJsjqCy1B5CvCK8T/l8zebZ4wpyHbXFBuDNvQXBJrnE45tnVMoyf0nUAxxkdkZ
         PBNJWNysWytlkQo2tKs0tiCiKTNhSStXgALds+66Q7kTUAsBVt5+eRVmKBFnOetPyZjI
         vGTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zOTGa07wFO41kAbeqoRPySR+npoc6niQvNIM75IIO14=;
        b=2Y2rIXtPYfobIiLO4Fxhxloxm9OcfQnUiZ23+vc5vx1NdVpODVhQAE4r3RdCodyT0j
         SPzNnfpASLnsEvq2AUBYmwyl24CZlORm6zIancJDRGk/q0awwv5aqVvbhGO5jYRcKvo9
         PhvYQA21XxsK8CoA0L1DVnfWi4VcgAzUJXLuih9+TBoWAhpX9JXg7BG6GJqjfYxDbswo
         XkxSAMIzc3r2tldlZLy23hOk1Cx1wh3qcmA4ff9tM5JRKBE4PISFGwnHNFmSVafhQMhU
         pP/fDpgDPdwIz/7ZCsMtHa/sspjJW7kajnNVFZMSg4P0kPv/4JTk8LcFkke28l1DxNz5
         Tw0A==
X-Gm-Message-State: AOAM532XsL5w1mRBFEHMsuD7AmIry9nRn14q/BP4G40ezHDVlk5bY9Cr
        f54abLblwqflOTyWiSE/aEs=
X-Google-Smtp-Source: ABdhPJzO+/LpbQdmgBRQfKGj7BJAN39uLsQAAJRhWoq6tcfVeNgxVTyi2Ef48dkB4nboHfC+aSxZiA==
X-Received: by 2002:a17:90b:1d8a:b0:1dc:588b:cd5d with SMTP id pf10-20020a17090b1d8a00b001dc588bcd5dmr26878833pjb.229.1652102417400;
        Mon, 09 May 2022 06:20:17 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id n10-20020a170903110a00b0015e8d4eb1cesm7105956plh.24.2022.05.09.06.20.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 06:20:16 -0700 (PDT)
Message-ID: <a5ec8825-8dc3-c030-ac46-7ad08f296206@gmail.com>
Date:   Mon, 9 May 2022 21:20:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCHSET 0/4] Allow allocated direct descriptors
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220508234909.224108-1-axboe@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <20220508234909.224108-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/9 上午7:49, Jens Axboe 写道:
> Hi,
> 
> Currently using direct descriptors with open or accept requires the
> application to manage the descriptor space, picking which slot to use
> for any given file. However, there are cases where it's useful to just
> get a direct descriptor and not care about which value it is, instead
> just return it like a normal open or accept would.
> 
> This will also be useful for multishot accept support, where allocated
> direct descriptors are a requirement to make that feature work with
> these kinds of files.
> 
> This adds support for allocating a new fixed descriptor. This is chosen
> by passing in UINT_MAX as the fixed slot, which otherwise has a limit
> of INT_MAX like any file descriptor does.
> 
>   fs/io_uring.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++---
>    1 file changed, 94 insertions(+), 6 deletions(-)
> 
Hi Jens,
I've read this idea of leveraging bitmap, it looks great. a small flaw
of it is that when the file_table is very long, the bitmap searching
seems to be O({length of table}/BITS_PER_LONG), to make the time
complexity stable, I did a linked list version, could you have a look
when you're avalible. totally untested, just to show my idea. Basically
I use a list to link all the free slots, when we need a slot, just get
the head of it.
https://github.com/HowHsu/linux/commits/for-5.19/io_uring_multishot_accept_v5

(borrowed some commit message from your patches)

Thanks,
Hao

