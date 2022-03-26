Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA894E8444
	for <lists+io-uring@lfdr.de>; Sat, 26 Mar 2022 22:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiCZVIV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Mar 2022 17:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiCZVIU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Mar 2022 17:08:20 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F86FBC2
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 14:06:43 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id c11so9210138pgu.11
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 14:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=M+xvy2nlSV5fJLgiFY/rh6JCFdCzk9wIdCTEfc1Pz2g=;
        b=IFziY0hTwuZskAeJISWgfqMQ9NxT+HLWqJJTZ/d8/yzPkcZU6Hc9y04c0D9GriI5po
         9pa26U2mo+4V5H/t4NkZah8AzUo0yF1UmQuemgFJZVl+RLR9OIwXKnkoaqeBv9EHUCX9
         f0oNf62P0y+RWdLNrVUh48z595zGM/7EKLAzGtkE2b82owPWjHLFPyWJ2JK1mmyq+2eA
         t6q/PDtALCiWE7bUn8T/ye1KsKWqrQNJvo1rBL/Cm9H+l3BT+/W12DxwOGyB3/ZkN6YJ
         2YM5/6u+fHspZx2eEhQ6hA7VqgK9lTYvduStiA4v6+n1Nun4KEcxtn7jY7ASIsSu2Jdn
         Uw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=M+xvy2nlSV5fJLgiFY/rh6JCFdCzk9wIdCTEfc1Pz2g=;
        b=jjEA7vPrWMEuuNTUyGgrGWDOTWax5hwrPKbpSiJltGDR5O8xYSfPDirQ4mYN7znvAk
         drk+Mb5rw8UzAzXDb+oHi60i9I0rnAeoZ+xLCupgxfKvD77avHurvGWK4K8gR/p4pg0E
         R0eQLP1w0ffSP1GT9OGKl/cpDclN3gSNUQL/A1ZYq3sU0geB87hBVOdEQvRjvOPnryd6
         c3Uk3jHLP8HTyVc3ZpjShnfrNxZENeQHaFDUDwsxV6rIzFJowrhEJeg2i3oX+059/9DG
         VyLNp1x88ClY75WUJi1qG6MYfw/slCNfBJoO/VchhNNHTQFl1OOmOSJocrrNd+83SDUo
         Q61Q==
X-Gm-Message-State: AOAM53266KatNBofmBRjR38OJhxM93pCSh2SrlToFRQxakxSy9zb9k39
        nJPCBWVnO4sRk2zEpPqbqgePjhPFpI1aER+N
X-Google-Smtp-Source: ABdhPJwjy5tJkn9xp0ZC0MJayAPz7ZafL4VUPTKtIt74JD4vPkgMj2KQnqDfOT5gNCj/SndwqENm/g==
X-Received: by 2002:a63:ea45:0:b0:380:c32f:2a0d with SMTP id l5-20020a63ea45000000b00380c32f2a0dmr4541723pgk.315.1648328802895;
        Sat, 26 Mar 2022 14:06:42 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 124-20020a621682000000b004f6a2e59a4dsm10659160pfw.121.2022.03.26.14.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 14:06:42 -0700 (PDT)
Message-ID: <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
Date:   Sat, 26 Mar 2022 15:06:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
 <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
 <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk>
In-Reply-To: <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk>
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

On 3/26/22 2:57 PM, Jens Axboe wrote:
>> I'd also like to have a conversation about continuing to use
>> the socket as a proxy for NAPI_ID, NAPI_ID is exposed to user
>> space now. io_uring being a new interface I wonder if it's not 
>> better to let the user specify the request parameters directly.
> 
> Definitely open to something that makes more sense, given we don't
> have to shoehorn things through the regular API for NAPI with
> io_uring.

The most appropriate is probably to add a way to get/set NAPI settings
on a per-io_uring basis, eg through io_uring_register(2). It's a bit
more difficult if they have to be per-socket, as the polling happens off
what would normally be the event wait path.

What did you have in mind?

-- 
Jens Axboe

