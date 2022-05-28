Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47688536CE1
	for <lists+io-uring@lfdr.de>; Sat, 28 May 2022 14:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355880AbiE1M2A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 May 2022 08:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiE1M17 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 May 2022 08:27:59 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6C71EADD
        for <io-uring@vger.kernel.org>; Sat, 28 May 2022 05:27:57 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b5so6356105plx.10
        for <io-uring@vger.kernel.org>; Sat, 28 May 2022 05:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=57VJcSXuTJ2kRJVhQxljnyZPJF8iC6WYxJP01pNTqP8=;
        b=k82bWvMIfQnKVjr/OrOhScbcodSltSfgMMMRoDSPDjK7wgfT8nhrqLQjbMZhdvw0xX
         qg7tNFDNlG28kuvTbA6ECP4apUWZ9TXuXpjcjE4iYFCmwZcK1fjEBDZtKGXfntwVlCTV
         j8v0jWgRotsKYzduc2R9EycxwOk90pqqHYxtwoTD2CzUFqMgwvZ+RssJFAsE+uXs6G3o
         DK8/w/hUpNRjI6q+ElWUaCiNuJwQd9HyqfrWbHden0qTw/iRBEbl+2As7jSc47u7m9Gf
         oFlw8SLu1DNIyxLnmRr1lPMYoWeEpL13LeTkZRpd+Q6ZRDEuZOydjmqAcdRAcFTUnWk7
         Jp8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=57VJcSXuTJ2kRJVhQxljnyZPJF8iC6WYxJP01pNTqP8=;
        b=VY+t6XztOQ3hEppXESOfrHVYVyovC2Gnf8OTVpE2rYqjDnR+GcBcR4mbILuQ1tROkh
         BhO2rTovPCugPaw75EcfGHAr1gu01r2PCwVNxja5aEDuZ4cDrxGlDmrh70Bi6RUQdWZu
         PGL2hreXsgvYwBz0t+eh32PVxqEv12/IH0GMa7UqFtyO4uEptxtPfs2HEQPn6Tch0lpJ
         d1aVBLtxPvKJgPchbWpyP0dNZThiqdaVOK/HILqg3LqC3XqmYpWb9Na5BdKCwqdewYDk
         DNCq/V1ekef1QjjcwDRiYiU+ssXQ1r7wuRObLCmhi/7jHDg6eB1atxXef1ZR6kh5G+z4
         /Xhg==
X-Gm-Message-State: AOAM5310f3ThfWa1U3IVLkXevTZyjIYOZ82q9ymqldxuWSS9q3fNaJS/
        93jMH94KBq8WEOpjrn01arh2QA==
X-Google-Smtp-Source: ABdhPJxYXDElLQABttfZzaL8eQlu/55ktV5cp2gIJiRLPsxMCbJbUyYENk11hqOQV+HB0lBh3Cdp/Q==
X-Received: by 2002:a17:902:7c0e:b0:161:f9f6:be5b with SMTP id x14-20020a1709027c0e00b00161f9f6be5bmr38055134pll.156.1653740876675;
        Sat, 28 May 2022 05:27:56 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a204-20020a621ad5000000b0051b291c2778sm1721992pfa.134.2022.05.28.05.27.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 May 2022 05:27:56 -0700 (PDT)
Message-ID: <10cf6738-bce8-a64c-7917-460d4e5972c5@kernel.dk>
Date:   Sat, 28 May 2022 06:27:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slot
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220526123848.18998-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220526123848.18998-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/22 6:38 AM, Xiaoguang Wang wrote:
> One big issue with file registration feature is that it needs user
> space apps to maintain free slot info about io_uring's fixed file
> table, which really is a burden for development. Now since io_uring
> starts to choose free file slot for user space apps by using
> IORING_FILE_INDEX_ALLOC flag in accept or open operations, but they
> need app to uses direct accept or direct open, which as far as I know,
> some apps are not prepared to use direct accept or open yet.
> 
> To support apps, who still need real fds, use registration feature
> easier, let IORING_OP_FILES_UPDATE support to choose fixed file slot,
> which will return free file slot in cqe->res.

This looks good. In retrospect, the direct open/accept/etc really
should've just returned the direct descriptor in cqe->res, so we would
not have this odd "0 for success when you pick a slot, <slot> in
cqe->res if io_uring picks it". But this is consistent with the alloc
case.

Do you have a liburing test case too? I think we should just get this
done for 5.19 rather than spread it over multiple releases, since 5.19
introduced the alloc as well.

-- 
Jens Axboe

