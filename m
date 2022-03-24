Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A446C4E6587
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 15:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351204AbiCXOnp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 10:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351156AbiCXOne (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 10:43:34 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94906AC92F
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:42:02 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id r2so5570870iod.9
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 07:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VPYhxgpxmJ4G+10kLqzcunuZ/z+E9aGtwng7G2zhNHY=;
        b=cniLj4VMGaTGM6opObTUM8BgeMFKISLcAsZ+97xKz4umyWIQ74RsLf/z3g/NE9D1l1
         Xdpg92WzgQITcCAflBzHr9ZKJMeaZbi7GQ8/tCfrakbtpcChL3huvCWBYlUcoTcyPO6J
         n4RG9jXYekc9MQJZWLlbxueLxfwJ2ZIZz6w4crKvwwtZc0+MBECSrtAgmD/PYzeB1wb8
         cFGn6Td0ApqO8nBJPWqbdklT03CyI/vHuHIml7yH5oRG7CmObffU/KBrajWI9mw4aCDM
         uiFSonSWIBnYbh8fp6DYwlP1D9xsnqx6kX1siXk7BSZpiQ7o9iPkobYJrjUZZnmMPaAP
         /3VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VPYhxgpxmJ4G+10kLqzcunuZ/z+E9aGtwng7G2zhNHY=;
        b=63dI+P7W+Qsns2/XkUnCPj/KkhrmK/KG8lYFLXxG1nFBkMATXD3emZLBsgNdYLkS41
         eOj4K5Xb70Mvuv835rZ4GeuBPpDnp+3dsO787q40rsLZZIIKkhww8Eg2+Ob1/bUymRTP
         26lcCDlazKYGoZdEvB3e/ql7Y+qC2NuFs4RwWbRwaCK/jrBlOx8T5Z4P/VS9x3qcVsoW
         gTD12e/FLN9aQk09BYBUQ2XwbMp4Riy9Of51DD2WMouLfTbTvpaQpiOGZnLl7u27k04W
         hS3k2gnKDSbiXTO8RElLqQddlBBuXTnfxHuyg8spfGM28pYqLdFAqc+6CXoST39raPij
         fe/g==
X-Gm-Message-State: AOAM532LusR7+dSAG8eWjz0Z/80t5MKrrScyouhJcBg7tsXapA1VeFZm
        0Sfx3Euba1MBPo7qUz70eLEVcw==
X-Google-Smtp-Source: ABdhPJyq8MYZcF9MAWVkeDLEwbB9Qyx8Oiu+OHDK2pmtnck+pTbYWQ+wzPjhvmV/DEOVZK9v4b3VHQ==
X-Received: by 2002:a5d:9d84:0:b0:649:d9ea:5390 with SMTP id ay4-20020a5d9d84000000b00649d9ea5390mr2845248iob.116.1648132921822;
        Thu, 24 Mar 2022 07:42:01 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k2-20020a056e02156200b002c7881bf27asm1614417ilu.27.2022.03.24.07.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 07:42:01 -0700 (PDT)
Message-ID: <a545c1ae-02a7-e7f1-5199-5cd67a52bb1e@kernel.dk>
Date:   Thu, 24 Mar 2022 08:42:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] io_uring: allow async accept on O_NONBLOCK sockets
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-team@fb.com
References: <20220324143435.2875844-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220324143435.2875844-1-dylany@fb.com>
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

On 3/24/22 8:34 AM, Dylan Yudaken wrote:
> Do not set REQ_F_NOWAIT if the socket is non blocking. When enabled this
> causes the accept to immediately post a CQE with EAGAIN, which means you
> cannot perform an accept SQE on a NONBLOCK socket asynchronously.
> 
> By removing the flag if there is no pending accept then poll is armed as
> usual and when a connection comes in the CQE is posted.
> 
> note: If multiple accepts are queued up, then when a single connection
> comes in they all complete, one with the connection, and the remaining
> with EAGAIN. This could be improved in the future but will require a lot
> of io_uring changes.

Not true - all you'd need to do is have behavior similar to
EPOLLEXCLUSIVE, which we already support for separate poll. Could be
done for internal poll quite easily, and _probably_ makes sense to do by
default for most cases in fact.

-- 
Jens Axboe

