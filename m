Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7447F57CBCD
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 15:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiGUNXC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 09:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGUNXB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 09:23:01 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8723F32BBE
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 06:23:00 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id b6so1032504wmq.5
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 06:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eW/ro4kIEf7izOlTIrHKJPYAI/YAcgwBIzh/sX0t66w=;
        b=R2F8ety4h4RL27pVrQb3djEptdcCG15AHYiHQ3BYuMsuiQLMTGrvknM+TT37Zw1/Vm
         541SDc9vHmk27vLR2mVrEk4sjUI3ckT8iWufBHqk0SdTdKVHnxL7cpw8B9kG1Xbh+D+K
         JNaQwkLDBFVCetGUooIqyVaNjfieRMTwLmyMhI3qvNjjbmCguEge273Oqy7A5czDptP3
         qplWlzTkhD6C6NxF4L0URRJE2khI40dU1bvwODHvj/nUiCEJ5inw6l+AEVtW0wnAC46N
         puid1DOKR+T7traSNlxd+rjcg4gJca6BEop+3OAdnuy5G6wCwXm+sqcMbGL/v9vD1l6U
         HGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eW/ro4kIEf7izOlTIrHKJPYAI/YAcgwBIzh/sX0t66w=;
        b=sjM0V09rspskHhHN/EPmhVre46FVLLJyeEpRQ0jcTX+pQ+XalHjG1L/D0N0nQi2emZ
         XEOArTVxrTyvX1Abmn2OWjNV9QQZjNkmMrsuMMB7EGelok8pzoICKP7EzpOvn2vav02v
         Cc1nstDZCB3YfAfa41B91rTumfx5ACnfNJ/0SQxBnq8qrAVqWl1gcfnX+xZbzYmjmzFQ
         WQIGBXtOlOdos5OBO2P/f1to9QhFEkotrlIeUZezX8AaYflumlhoEvnomrn9A6iZ9rrz
         BgaSY7Pc7bMDAO3ZZqzbrkdXDlSPCFIzPThjyHgg48IWINiL7tiVguSZfgzDjUVwi8lf
         F4aA==
X-Gm-Message-State: AJIora8lLbb5bYV98NY1qy0jqdFmXdRvtV6KZqz8bhzCLgBkdCchQnKj
        PIs9E9iHyr7wP1NqTNqhAKV75G/faoQcUQ==
X-Google-Smtp-Source: AGRyM1uztq3zuZgHiXk2N8aEfxQ2UPZ1awEvjiUhwUqUU4lwt98shSFPvXFD7IHhx8oPHfv8FzgUfA==
X-Received: by 2002:a05:600c:358d:b0:3a3:3819:c07 with SMTP id p13-20020a05600c358d00b003a338190c07mr948188wmq.76.1658409779034;
        Thu, 21 Jul 2022 06:22:59 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c093:600::1:a53a])
        by smtp.gmail.com with ESMTPSA id w10-20020adfde8a000000b0021e50971147sm1911021wrl.44.2022.07.21.06.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 06:22:58 -0700 (PDT)
Message-ID: <19c2edd0-2943-4c7b-9996-91e67adae725@gmail.com>
Date:   Thu, 21 Jul 2022 14:22:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Quick question about your io_uring zerocopy work
Content-Language: en-US
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     io-uring@vger.kernel.org
References: <ER6DFR.59DVNSZLHAFU2@crapouillou.net>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ER6DFR.59DVNSZLHAFU2@crapouillou.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/22 10:38, Paul Cercueil wrote:
> Hi Pavel,
> 
> Good job on the io_uring zerocopy stuff, that looks really interesting!
> 
> I'm working on adding a new userspace/kernelspace buffer interface for the IIO subsystem. My first idea (a few years ago already) was to add support for splice(), so that the data could be sent from IIO hardware directly to file or to the network.
> 
> It turned out not working really well because of how splice() works. The kernel would erase pages to be exchanged with the pipe data pages, so the speed gains obtained by not copying data pages were underwhelming and the CPU usage was almost as high (CPU usage being our limiting factor here).
> 
> We then settled for a dmabuf-based interface [1] which works great as a userspace/kernelspace interface, but doesn't allow zero-copy to disk or network (until someone adds support for it, I guess). The patchset got refused on the basis that (against all documentation) dmabuf really is a gpu/drm thing and shouldn't be used elsewhere.

The idea I've got is that passing buffers as dmabufs is the only viable
approach, especially since GPU <-> NIC transfers are of much interest
and there were attempts of exposing NVME's CMB as dma-bufs (not sure
where did it end).

> My question for you is, would your new io_uring zerocopy work allow for instance to transfer data from storage to the network, without triggering this "page clearing" mechanism that splice() has?

That's the plan. We prototyped it before but needs some more work
to be done.

> [1] https://lore.kernel.org/linux-doc/20220207125933.81634-7-paul@crapouillou.net/T/

-- 
Pavel Begunkov
