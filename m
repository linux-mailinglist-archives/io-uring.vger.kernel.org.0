Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5A9772DCF
	for <lists+io-uring@lfdr.de>; Mon,  7 Aug 2023 20:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjHGSY4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Aug 2023 14:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjHGSYw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Aug 2023 14:24:52 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852EA1BDB
        for <io-uring@vger.kernel.org>; Mon,  7 Aug 2023 11:24:49 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-56462258cdeso614236a12.1
        for <io-uring@vger.kernel.org>; Mon, 07 Aug 2023 11:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691432689; x=1692037489;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mej/dF0Vnebbhga39zP85nVDdH0RakMMocs90Ke6UAs=;
        b=KAVjOdWMdfRv6P+ijaKuyP3SvgPpqCl8BYXY/Asl+KeOOG5+wZOEbGWl4fxWQvA5ul
         0ms2gMXSHU32pBvme1edeYAae2+sNIAHjB2qQ0gq2mOiV9bAelMFeIkiVbZAxvW04pca
         S1cY5TD2uZzxMq930Bhef1CFyQvV2ZETN7/NV2ma5nH+8KE0Xb3IzUjBUtpqYKbNFc77
         7c6ONE7xlXDBCxxZZ7PCmNxkXyi8yjVuNvixChX5sY+8fO1TJi4zytvH2hi1HBMONHAl
         Ad1Z16517bBnT4F5EewerDYDcXDQVm8UTEZBg9cEZD2oG5bjabwSBhGZdXc2xBUdyprW
         6Rww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691432689; x=1692037489;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mej/dF0Vnebbhga39zP85nVDdH0RakMMocs90Ke6UAs=;
        b=C34n1U4bOAzB1bGTt3Qzo4i5an4t0gifSwWMlRJcldKsiS8TtkstaIDsmx6DO7tZyn
         icReMG+7IMvXULIyFCWVWMxSuEkkdi/z9qExYqdJDT2GkP/njAVgYWT/BfZHOIjM4T6f
         C8k5/h5SeCTasFPPsfISKWnnO9SJC269pGO1fpjPX7vYby8fZpGu3gjJAQ793QyME5Oy
         nECaoZ/Y9teSxr7EWLrKBlWJ9skrJ+ExutacJR+OQAjHp/HAjvF1oCfI4w71gvV1q3q2
         3d3+bw3mdjKuNcaDjdvN0Aqhu1bomfpFTc10bwGu7AziN8QSDhrruQW6sgKRMAeBgLaG
         OzdQ==
X-Gm-Message-State: ABy/qLbgD0qfJxZrrwBnNdXiaDEhFFWmfNzgOlUtszy1Egyid0nIHBTo
        dRqYx7VVp2Ko7L52V0coXXgOEw==
X-Google-Smtp-Source: APBJJlGYSCF/0nBPdSQztJd0Z08KqsM5481fJyQ9qxtNitlZNym4LXDHAhybVuig2bhgszxPx+vtOA==
X-Received: by 2002:a05:6a21:3293:b0:13e:1d49:723c with SMTP id yt19-20020a056a21329300b0013e1d49723cmr29227393pzb.2.1691432688928;
        Mon, 07 Aug 2023 11:24:48 -0700 (PDT)
Received: from [172.16.7.55] ([4.14.191.206])
        by smtp.gmail.com with ESMTPSA id bu25-20020a632959000000b0055386b1415dsm5333312pgb.51.2023.08.07.11.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Aug 2023 11:24:47 -0700 (PDT)
Message-ID: <c4c3ae81-33aa-26ba-3a24-33918e0446e4@kernel.dk>
Date:   Mon, 7 Aug 2023 12:24:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH] io_uring/parisc: Adjust pgoff in io_uring mmap() for
 parisc
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-parisc@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
References: <ZMle513nIspxquF5@mail.manchmal.in-ulm.de>
 <ZMooZAKcm8OtKIfx@kernel.org> <1691003952@msgid.manchmal.in-ulm.de>
 <1691349294@msgid.manchmal.in-ulm.de>
 <f361955c-bcea-a424-b3d5-927910ab5f1d@gmx.de>
 <b9a15934-ea29-ef54-a272-671859d2bc02@gmx.de> <ZNEyGV0jyI8kOOfz@p100>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZNEyGV0jyI8kOOfz@p100>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/7/23 12:04?PM, Helge Deller wrote:
> The changes from commit 32832a407a71 ("io_uring: Fix io_uring mmap() by
> using architecture-provided get_unmapped_area()") to the parisc
> implementation of get_unmapped_area() broke glibc's locale-gen
> executable when running on parisc.
> 
> This patch reverts those architecture-specific changes, and instead
> adjusts in io_uring_mmu_get_unmapped_area() the pgoff offset which is
> then given to parisc's get_unmapped_area() function.  This is much
> cleaner than the previous approach, and we still will get a coherent
> addresss.
> 
> This patch has no effect on other architectures (SHM_COLOUR is only
> defined on parisc), and the liburing testcase stil passes on parisc.

What branch is this against? It doesn't apply to my 6.5 io_uring branch,
which is odd as that's where the previous commits went through.

-- 
Jens Axboe

