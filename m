Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496F74E83E6
	for <lists+io-uring@lfdr.de>; Sat, 26 Mar 2022 20:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbiCZTtE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Mar 2022 15:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiCZTtD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Mar 2022 15:49:03 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E45E1DB3C5
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 12:47:26 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id u22so9226854pfg.6
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 12:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VDTMS6NJ1Skbe4AB/nPMpt2yXiidvym7ixgm+g6mZmc=;
        b=GyOicVuhcBZeulP1ZpaZ4cPG8RK5hfjIQcwA5YyKAsTMrvVilU929i9KKDyibQTlC8
         Ji/ygLls6oRmcbR+iEMIJ1cbvm1TC32RBdc/sUOxmA4LpqwvZoGA/h6uH11BsNM4zxtn
         mmNTDigF6wwbcrMJ5PFyyiEALkeFowMIvtlRhLCMcbuiwIe+/s47agwA1S2MC8jFtlQv
         WvKB6ehj4NHqm1ChchSBlWrMCMKkGKi0JgMf1AxpHrPg99piNlacKNehshHGdnoyZ1zz
         PGsN0r+dXtAu3JRl0J2oEH9rOEtyF7RKyRnwfbAcH8Me9rSSRcYvdKKyFxTb8Y2Wy1M9
         RRlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VDTMS6NJ1Skbe4AB/nPMpt2yXiidvym7ixgm+g6mZmc=;
        b=RZiw2+AzJ+z77etz7eyJrekK2031o4jmidp2Ade05uh3pX3iDvci5Ay9MX5kj6kpqu
         zhAjEVhVqCCZ9lEDYiPHcCGmpLqZGBTyE2WF/9v2YlvgXh2OUjmol/ZcbeoaRLYHT9hM
         k2DX33DmWSAXcRsJYmwYTYpbNdZxA555nrrheZ5Bush2/if8/LE7FPgsyxEz6n5tvCS1
         PUOjyHNDS3wVRTvgksXarcK6HPBowefRckzfhiQgfDFDshNRUDttiXxgwVaVg3aFNbTW
         xQ73hcwut7/Dt5UMllWw9oH2siVuiO5wmpbXW/U/5GuHUq4+y+cJDicwAZnb54PBKAhn
         S6AQ==
X-Gm-Message-State: AOAM533fSGhPBGpUj9EOzMlaaKoZLs//OIloLhaEYrXQQydjORgOzJ0P
        uE2zf5S11J3fqWPX1kP30gaQf8PvGyyaPdKb
X-Google-Smtp-Source: ABdhPJx6RabHyTjHM9ytTQ5EZwtKDlmGpXS2cHtC/OY5e/XBsKosKKgv+SYlY8LGN71iRzqizGh6CA==
X-Received: by 2002:a63:e30a:0:b0:385:fcae:d4a9 with SMTP id f10-20020a63e30a000000b00385fcaed4a9mr4524159pgh.85.1648324045892;
        Sat, 26 Mar 2022 12:47:25 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7820e000000b004f7134a70cdsm10357360pfi.61.2022.03.26.12.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 12:47:25 -0700 (PDT)
Message-ID: <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
Date:   Sat, 26 Mar 2022 13:47:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
 <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

On 3/26/22 1:28 PM, Jakub Kicinski wrote:
> On Fri, 18 Mar 2022 15:59:16 -0600 Jens Axboe wrote:
>> - Support for NAPI on sockets (Olivier)
> 
> Were we CCed on these patches? I don't remember seeing them, 
> and looks like looks like it's inventing it's own constants
> instead of using the config APIs we have.

Don't know if it was ever posted on the netdev list, but the
patches have been discussed for 6-9 months on the io_uring
list.

Which constants are you referring to? Only odd one I see is
NAPI_TIMEOUT, other ones are using the sysctl bits. If we're
missing something here, do speak up and we'll make sure it's
consistent with the regular NAPI.

Adding Olivier who wrote the NAPI support.

-- 
Jens Axboe

