Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F556BFB86
	for <lists+io-uring@lfdr.de>; Sat, 18 Mar 2023 17:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCRQ0Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Mar 2023 12:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjCRQ0Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Mar 2023 12:26:24 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841B01E5E0;
        Sat, 18 Mar 2023 09:26:22 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id i9so6874490wrp.3;
        Sat, 18 Mar 2023 09:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679156781;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=81kSVCXo2l+iGQzzrYr4TaQEZz3kF+wE9kDj+1E81oM=;
        b=Slp3z6UrxbhWak4WgZuPC4GW2bvK27rn+5lOyl4O65UKCKgHyxydjs4MtEW72Coxrf
         U9/8ZlZUjMfLiLfPL8lhesoRxht4qpQu3TllojvTEjxJkigAbXxI8Iv5rrBCsOEbVgxx
         4S5CMkPCb0CzGmthRAPmz4p/c/33fROJvhfGHmgzT7nqOcPn2tvOgwIM5PUfrDG9OAde
         famHSlBKSaGS1Sii0ewlqWxg0ASk522zF6+zYU9L6GdOwo/5OH1RJdyx0xdGl1K1PPy8
         0MYYD58gGep3wxY93295/U7K3rglS68s9OB3J6kX/gIMoI2a1d9RoKKztJWatvuVlGmg
         IxFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679156781;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=81kSVCXo2l+iGQzzrYr4TaQEZz3kF+wE9kDj+1E81oM=;
        b=bDOOdKavXo6wSHWFZIPHAp5uhfmCb/8NW0ScZ+z0L2B0WaHiHOdVtJeCFmIqsEk0yW
         C0ZyOUK0gvRhtU701PulIBDTzkS8sKbEyi/sMKFurtn5wU3VqryuOx/jqU/59SOlrIRF
         kKP/PxgHXiE+CtUhkX0VO39dpSNtVDCHMfYrDZb/KX3wUlymWZ1gXnVWeo3epmtS6bmY
         OUYdDBSX9I8IyUhRZZVSaF5TKWYdTrvZl0QUyabiyn6zegFJ0851RUw0G8bD2w4PEbts
         NL4pExBUrX8zUvWhGjjb3x3+S54NHeMPQmd10NUKqd1x2WOGHZjFt+/g/lDEvctOW6Rv
         4kHQ==
X-Gm-Message-State: AO0yUKVXOrvUk8pGovxwLXdSPB/P7bkoXXDv3waOjwkHHc09zj9oJYRA
        brkRG/+YHPLYJspt7AVM6WQ=
X-Google-Smtp-Source: AK7set9kCMVLum56StrDOAPJ3t+x0kGga84vsEnNgeoRISTNk0EHGZIlrMWZjCp1JLrwQ8GFFD+I9w==
X-Received: by 2002:adf:decb:0:b0:2ce:a096:3ff2 with SMTP id i11-20020adfdecb000000b002cea0963ff2mr9348594wrn.63.1679156780856;
        Sat, 18 Mar 2023 09:26:20 -0700 (PDT)
Received: from [192.168.43.77] (82-132-228-239.dab.02.net. [82.132.228.239])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm462281wrs.37.2023.03.18.09.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 09:26:20 -0700 (PDT)
Message-ID: <845ff5cb-b0ff-8ea0-e2ff-a5b216966dfb@gmail.com>
Date:   Sat, 18 Mar 2023 16:23:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
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

On 3/16/23 03:13, Xiaoguang Wang wrote:
>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>> and its ->issue() can retrieve/import buffer from master request's
>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>> submits slave OP just like normal OP issued from userspace, that said,
>> SQE order is kept, and batching handling is done too.
> Thanks for this great work, seems that we're now in the right direction
> to support ublk zero copy, I believe this feature will improve io throughput
> greatly and reduce ublk's cpu resource usage.
> 
> I have gone through your 2th patch, and have some little concerns here:
> Say we have one ublk loop target device, but it has 4 backend files,
> every file will carry 25% of device capacity and it's implemented in stripped
> way, then for every io request, current implementation will need issed 4
> fused_cmd, right? 4 slave sqes are necessary, but it would be better to
> have just one master sqe, so I wonder whether we can have another
> method. The key point is to let io_uring support register various kernel
> memory objects, which come from kernel, such as ITER_BVEC or
> ITER_KVEC. so how about below actions:
> 1. add a new infrastructure in io_uring, which will support to register
> various kernel memory objects in it, this new infrastructure could be
> maintained in a xarray structure, every memory objects in it will have
> a unique id. This registration could be done in a ublk uring cmd, io_uring
> offers registration interface.
> 2. then any sqe can use these memory objects freely, so long as it
> passes above unique id in sqe properly.
> Above are just rough ideas, just for your reference.

It precisely hints on what I proposed a bit earlier, that makes
me not alone thinking that it's a good idea to have a design allowing
1) multiple ops using a buffer and 2) to limiting it to one single
submission because the userspace might want to preprocess a part
of the data, multiplex it or on the opposite divide. I was mostly
coming from non ublk cases, and one example would be such zc recv,
parsing the app level headers and redirecting the rest of the data
somewhere.

I haven't got a chance to work on it but will return to it in
a week. The discussion was here:

https://lore.kernel.org/all/ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com/

-- 
Pavel Begunkov
