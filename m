Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB888524CDD
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 14:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350833AbiELMbX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 08:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353748AbiELMbX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 08:31:23 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B06377C4
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 05:31:20 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id bo5so4667413pfb.4
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 05:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=V1HuJ2W+QpQjeVYmHeslUCmfHHxxZeV5A2pWY7A5hVk=;
        b=siY9VER8FhUdPqzbEapXlOZyiDnaxEEbWFUAXbsuczxV1CjKlCACfRcoxJZxEjH5ax
         OtB74BvnBXSR3hixQCbqilrcL4BIzvuUQ/zjU90yfV4XizL+XwlFzqLn+yZbmE/siryM
         2L8lZCuGuigKdL8yZnHj+CxNigRWpBSzu3azvZTsI+z76gDJMCMbBC2DoCI5eoqdtr+s
         KjP4XE74vj0wenQ0sQitM7Wa70MMHl2yv56Gd2DZwwv8ZbG0JY2VciwtOHNMpUJvZ298
         8VFT6px48AN4TZP8DUU12o5YL6v0vPWiWP36DogYa6Mmpf/bqw0eritNTtgCcS9xS7LG
         m1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V1HuJ2W+QpQjeVYmHeslUCmfHHxxZeV5A2pWY7A5hVk=;
        b=XQlYOhVy+4pFwtPh0/fBF0hNQO8M20MUdjmfsgYHSzxapN6+Mdd42og08a2g+9Ssx5
         UQ6e550PXsqLlbYKgmK8cMH5RCPGetryPtoz9tqsgvU8p2RT7VPrC4fHMLZhzTQP97Qh
         jmJjRNsCDlaNtZ/NqYbckX8rgC4XoJmGNdPXc5TmIgCzro9XWL1ThGjcpilmyvUJUCHO
         +HBdcX/bawp14/GOYKbubtutmSx2muI1lIbZmENg+c4bMo8AhaCOCHTWEw6D1fH+d4lG
         6AbpCHhhThSOkpOPpdv553t5TteENA0glgt1RpTQ61QagiCAviY4W3OSznUzQDozpq9p
         hxeA==
X-Gm-Message-State: AOAM531MXlwvyQ4ILtW/S5AWdKQrR/Gb0iPKnnxcE/pbt82FVKqtAKzY
        ajy3/jAGWQT+rq7LQnttU0EImg==
X-Google-Smtp-Source: ABdhPJyDYK6f9G0PNbHRaiWTYyPhkhEQVtpTNMumvuS/aIOGzhTfGpgapvmt00ZNfGM45MVGB9EMDw==
X-Received: by 2002:a63:4b17:0:b0:3c5:f761:c77a with SMTP id y23-20020a634b17000000b003c5f761c77amr24466913pga.117.1652358680329;
        Thu, 12 May 2022 05:31:20 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x20-20020a170902821400b0015e8d4eb238sm3773799pln.130.2022.05.12.05.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 05:31:19 -0700 (PDT)
Message-ID: <74e33b5d-71ce-1309-7897-e5e8ad2ed778@kernel.dk>
Date:   Thu, 12 May 2022 06:31:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v5 2/6] block: wire-up support for passthrough plugging
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        mcgrof@kernel.org, shr@fb.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220511054750.20432-1-joshi.k@samsung.com>
 <CGME20220511055310epcas5p46650f5b6fe963279f686b8f50a98a286@epcas5p4.samsung.com>
 <20220511054750.20432-3-joshi.k@samsung.com> <YnyaRB+u1x6nIVp1@T590>
 <20220512080912.GA26882@lst.de> <YnzI7CgI+KOHNKPb@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YnzI7CgI+KOHNKPb@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/12/22 2:44 AM, Ming Lei wrote:
> On Thu, May 12, 2022 at 10:09:12AM +0200, Christoph Hellwig wrote:
>> On Thu, May 12, 2022 at 01:25:24PM +0800, Ming Lei wrote:
>>> This way may cause nested plugging, and breaks xfstests generic/131.
>>> Also may cause io hang since request can't be polled before flushing
>>> plug in blk_execute_rq().
>>
>> Looking at this again, yes blk_mq_request_bypass_insert is probably the
>> wrong place.
>>
>>> I'd suggest to apply the plug in blk_execute_rq_nowait(), such as:
>>
>> Do we really need the use_plug parameter and the extra helper?  If
>> someone holds a plug over passthrough command submission I think
>> we can assume they actually do want to use it.  Otherwise this does
>> indeed look like the better plan.
> 
> use_plug is just for avoiding hang in blk_rq_poll_completion(), so
> I think we can bypass plug if one polled rq is executed inside
> blk_execute_rq().

Agree, and good catch. Do you want to send out a patch for this?

-- 
Jens Axboe

