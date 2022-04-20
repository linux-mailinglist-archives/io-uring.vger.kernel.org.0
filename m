Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0EE8508786
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 13:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378196AbiDTL7C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 07:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378385AbiDTL7A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 07:59:00 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A78427DE
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 04:55:52 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t25so1938757edt.9
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 04:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=IQz/9Cztb3dtBD/iYxQFv7GAyM6M/oTQq+RD8iPKxCE=;
        b=FpqCpA8wArrh/mBd08QxOvzIkoVBqNFoogbKyx2+tyULmQXfOtUOfyOd4SVqvzLbyY
         UVo3EVJYEeKcUOePcO0tFpO9DCahdznf6wHgQZwscpOzhvG/Tfeq+D6qUxmnDhU+bCkQ
         9CuJfa+7PYTObpSsVyTLJ3pcKRya0ITGgLcBKygTGNVo0bNDyhowHn74GIdsxSlhRZRE
         mW4y+AD6OSqvt8CE4+r4Sh9aCDNa5okDAAkal/68yZSh8dZUufk1aXwkbrzy5te0Rn4F
         yV4N80Ip/Egm3fE9JAiuL0vdpR5j6+erACiYbvC1wSaXD+eBZzAV/tiKLuAGg6JA8dg4
         WaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=IQz/9Cztb3dtBD/iYxQFv7GAyM6M/oTQq+RD8iPKxCE=;
        b=ZVXxBuczyjyqkMSuHnQGys6KHYibhC7GPUmZViBuGr1Y2HT/BH7yr4PQg2qawVjsYf
         FlZOPB1f9yVyFi40KFolzyl99bPKY462AzfcKrNVIjA6SOy3YCuoC84IRSkrI0Ab5UL7
         wkreHhO2y3WQ3E5aGa6yttbx+cLCxozDWd5Q3DdNFIG2XuG+0UlTa8/xNEoCThimPzE4
         i8wpvJ6A6Fe3SpTLKTLFuvlgs9ZpjfInrl29UV372cfKJX8A3SryZyne3O8obPYKFYyv
         O2LJPGOK1hBq/vPjh3euk1UFxsPrWOi6HAoZ/0SRv33mxtS0sHy5lCrBscfBObsS57p5
         HVBw==
X-Gm-Message-State: AOAM532afK3hZ7SAdypY4Z559gAEABh4YzFhtd3Tcd2XfUHKfHpxblj8
        2ghMlqplwtPWQwwZrQ4ZHeo16A==
X-Google-Smtp-Source: ABdhPJwqiRj27cL5G44dHK3Ul+gxNvcLtt7LGXJMM6y+F5RV5BgXZO67APQzFs+6KScFUCjHOjdLYw==
X-Received: by 2002:aa7:cc90:0:b0:424:1f9d:eb9e with SMTP id p16-20020aa7cc90000000b004241f9deb9emr2436130edt.109.1650455751171;
        Wed, 20 Apr 2022 04:55:51 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id d11-20020a056402400b00b00423e5bdd6e3sm4473531eda.84.2022.04.20.04.55.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 04:55:50 -0700 (PDT)
Message-ID: <1a7f2b1c-1373-7f17-d74a-eb9b546a7ba5@scylladb.com>
Date:   Wed, 20 Apr 2022 14:55:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
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
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <686bb243-268d-1749-e376-873077b8f3a3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 19/04/2022 22.58, Jens Axboe wrote:
>
>> I'll try it tomorrow (also the other patch).
> Thanks!
>

With the new kernel, I get


io_uring_setup(200, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, 
sq_entries=256, cq_entries=512, 
features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|IORING_FEAT_SQPOLL_NONFIXED|IORING_FEAT_EXT_ARG|IORING_FEAT_NATIVE_WORKERS|IORING_FEAT_RSRC_TAGS|0x1800, 
sq_off={head=0, tail=64, ring_mask=256, ring_entries=264, flags=276, 
dropped=272, array=8512}, cq_off={head=128, tail=192, ring_mask=260, 
ring_entries=268, overflow=284, cqes=320, flags=280}}) = 7
mmap(NULL, 9536, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 7, 0) = 
-1 EACCES (Permission denied)


