Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1504F5087C5
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 14:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349813AbiDTML7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 08:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348502AbiDTML6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 08:11:58 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9238C3FDB9
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 05:09:12 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so4784870pjb.2
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 05:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=u5pYgQJD0ceZLePnwuz+54HN/dfMnFT1Zj/nVYOeiFM=;
        b=xT1Gr6vNUGbyYKGQJTWfc4IHBN80Cvcd7uoM1Fwa8ZA8KSaW35pgTqfqgxiGspJ1PC
         gHKc7MnLS6S7OEAqyzVZjoPD9gzzosL3cxRYtqSfttoOEHoCuQZ+pS0XWcafIwlHRXx3
         seLIryQIA8iedYuy/xIM6J8cDg4BxbnIVpWA60JqzIbD9Eq8lWIBmyPgb9H7NWtLzACe
         xjJptGq0Cxk8Ib1RDTR9Pz/qH2AX0A95/rn4tMm47tmqJ3yccWZTnr8Yth7Tc6bUOQjS
         ON9xdPKiLOggBYf10gHeOGdWq/o2q+cT24Y7QHzEx6a1X/6FOJSgzBYOut90+0sZCHXP
         Asig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u5pYgQJD0ceZLePnwuz+54HN/dfMnFT1Zj/nVYOeiFM=;
        b=eh9XbUxHlcu1dTW8X1yrPL9L9tBtUd/5nXVxPNOoU3iE2NkFCYBP8UgLYTkGAR07dk
         +CrXp+efT7kuZcaB1yiqveToAZf0R7aZ5SXQ/p9AhqnPlrj14OubDyAnKPCotrPB5NZb
         d8UY1B/qU3gwfVrdMSQg1OBfHTSKE+BM/jSRiTo0osfqyKKBSe1S9gUc3+MGsF/6uRN6
         RHgN8zLYlgS3U9OMDYoVW8ab9FVjMnLjH1NwcZrD6oEudzUEjS2v2QpXf7YVQitfoUgW
         GhZ+qt4yVWa3CPW3jMbq+QsbLGxf19mUKh1px3weMY03KrQ641VkoDvIaOgfBY+j/8Bw
         Kk4A==
X-Gm-Message-State: AOAM533iNf7s008Y450fALeJqK269ViV7B9Dw8XNtUMf+6KbApPgUlzj
        /Pw0/uRiv8OjA1g7i2qu8QqXPQ==
X-Google-Smtp-Source: ABdhPJyVXujvlshGUYRhnWvgyQKqnRehdhjMEdv6c89bPTNpNC4oWqVUqq5iRM7iNYzcl+qwOCO8wQ==
X-Received: by 2002:a17:902:6b0b:b0:156:4ab0:3ddc with SMTP id o11-20020a1709026b0b00b001564ab03ddcmr19555337plk.22.1650456551932;
        Wed, 20 Apr 2022 05:09:11 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x39-20020a056a0018a700b004fa7e6ceafesm21375835pfh.169.2022.04.20.05.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 05:09:11 -0700 (PDT)
Message-ID: <1c65ed64-b528-5b0d-48d3-a948acb4520b@kernel.dk>
Date:   Wed, 20 Apr 2022 06:09:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
 <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
 <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
 <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
 <4008a1db-ee26-92ba-320e-140932e801c1@kernel.dk>
 <96cdef5a-a818-158d-f109-e96f0038bf14@scylladb.com>
 <686bb243-268d-1749-e376-873077b8f3a3@kernel.dk>
 <1a7f2b1c-1373-7f17-d74a-eb9b546a7ba5@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1a7f2b1c-1373-7f17-d74a-eb9b546a7ba5@scylladb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/22 5:55 AM, Avi Kivity wrote:
> 
> On 19/04/2022 22.58, Jens Axboe wrote:
>>
>>> I'll try it tomorrow (also the other patch).
>> Thanks!
>>
> 
> With the new kernel, I get
> 
> 
> io_uring_setup(200, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=256, cq_entries=512, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|IORING_FEAT_SQPOLL_NONFIXED|IORING_FEAT_EXT_ARG|IORING_FEAT_NATIVE_WORKERS|IORING_FEAT_RSRC_TAGS|0x1800, sq_off={head=0, tail=64, ring_mask=256, ring_entries=264, flags=276, dropped=272, array=8512}, cq_off={head=128, tail=192, ring_mask=260, ring_entries=268, overflow=284, cqes=320, flags=280}}) = 7
> mmap(NULL, 9536, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 7, 0) = -1 EACCES (Permission denied)

That looks odd, and not really related at all?

-- 
Jens Axboe

