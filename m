Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1A66B0E8D
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 17:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjCHQXz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 11:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjCHQXu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 11:23:50 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35170B8579;
        Wed,  8 Mar 2023 08:23:49 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id o38-20020a05600c512600b003e8320d1c11so2286085wms.1;
        Wed, 08 Mar 2023 08:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678292627;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y4IZ92EpBEKYcl2ZJKg5u1/HykSPMLGytpx3Q6cANxw=;
        b=KXeejlC+4XVExK3kgXB+euBTRMQEj40ANiAPfPW+XYr+wRhSgvqApNVIjjHpJGF0L+
         bbso+oH9rZGiInEKaP+TezjfMPqwSIZqy1Llp1GQMQ5AtDutB6TVvDjZc0pt+DXzhx4K
         eqbJ7zSNsyX6gvU1htknTH7LJdMCJzfnTju34WT3C+TkrIsoPf0kuGMe3Gai+4Ng1GAw
         LPAkOiIuJamrMoLxnlhb2OMCTDpyDjgAJk+n6+EXbjkFq2EnAEs4BaoxZbPj/P8/55Eu
         I3LHOwSX21UdYcHn/vA65H62F6o62ltFmRzIVHXnT3+maGDjfPM9ZQXk9AGkypVMcqPS
         iL0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292627;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4IZ92EpBEKYcl2ZJKg5u1/HykSPMLGytpx3Q6cANxw=;
        b=2IITwvrJY6vFjypdSw2TQAJgcE3L+VTMcMh1Z5iUPaAxxLKpzhu5tqTwtJHdwxy+0O
         M8wm2AWyT1UaZAFBY3smuONjbiP7CEAKpXJu2vR5KabqhfOjQzpox4F5S7Gigeqme7Gl
         UEzTJhhLBf51VSPLm0dI6NWDFlyty5ezVyxyF/WFeq+9MfvgMwKM6TqOdeZWGWxdqMdJ
         BgfAxn69cHp8Do9DTWk8klgQxKgBl9WLQA2CE2E1uGYDGwJ3aKHqhb9gYpLNwbH8FuQS
         AEP2FnsZ5WKjEH7oms8xSXHZj9kty2TWh/0p+E8vB8wUICQAflf4J0afpZFtU9ehTNvx
         y6wA==
X-Gm-Message-State: AO0yUKW3VR7rTlkxM7rtwH25lPBsLmQIpCaLfzBiCLWpmDcQ6ltQfFQ+
        4lq9YfcMprstRSZ3f8CfhMgAy+U3mAE=
X-Google-Smtp-Source: AK7set9rIk17PWmTxE+WV4EzbQdNDEsZpNTjws7HY60vQ/y94IIfjoh2KD1fUbA5J632E/xYAXub9w==
X-Received: by 2002:a05:600c:4e8b:b0:3d2:392e:905f with SMTP id f11-20020a05600c4e8b00b003d2392e905fmr16807225wmq.24.1678292627409;
        Wed, 08 Mar 2023 08:23:47 -0800 (PST)
Received: from [192.168.8.100] (188.30.85.94.threembb.co.uk. [188.30.85.94])
        by smtp.gmail.com with ESMTPSA id l10-20020a7bc44a000000b003e21dcccf9fsm19880128wmi.16.2023.03.08.08.23.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 08:23:47 -0800 (PST)
Message-ID: <7cdea685-98d3-e24d-8282-87cb44ae6174@gmail.com>
Date:   Wed, 8 Mar 2023 16:22:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH V2 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
 <7e05882f-9695-895d-5e83-61006e54c4b2@gmail.com>
 <ZAff9usDuyXxIPt9@ovpn-8-16.pek2.redhat.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZAff9usDuyXxIPt9@ovpn-8-16.pek2.redhat.com>
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

On 3/8/23 01:08, Ming Lei wrote:
> On Tue, Mar 07, 2023 at 03:37:21PM +0000, Pavel Begunkov wrote:
>> On 3/7/23 14:15, Ming Lei wrote:
>>> Hello,
>>>
>>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>>> and its ->issue() can retrieve/import buffer from master request's
>>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>>> submits slave OP just like normal OP issued from userspace, that said,
>>> SQE order is kept, and batching handling is done too.
>>
>>  From a quick look through patches it all looks a bit complicated
>> and intrusive, all over generic hot paths. I think instead we
> 
> Really? The main change to generic hot paths are adding one 'true/false'
> parameter to io_init_req(). For others, the change is just check on
> req->flags or issue_flags, which is basically zero cost.

Extra flag in io_init_req() but also exporting it, which is an
internal function, to non-core code. Additionally it un-inlines it
and even looks recurse calls it (max depth 2). From a quick look,
there is some hand coded ->cached_refs manipulations, it takes extra
space in generic sections of io_kiocb. It makes all cmd users to
check for IO_URING_F_FUSED. There is also a two-way dependency b/w
requests, which never plays out well, e.g. I still hate how linked
timeouts stick out in generic paths.

Depending on SQE128 also doesn't seem right, though it can be dealt
with, e.g. sth like how it's done with links requests.

>> should be able to use registered buffer table as intermediary and
>> reuse splicing. Let me try it out
> 
> I will take a look at you patch, but last time, Linus has pointed out that
> splice isn't one good way, in which buffer ownership transferring is one big
> issue for writing data to page retrieved from pipe.

There are no real pipes, better to say io_uring replaces a pipe,
and splice bits are used to get pages from a file. Though, there
will be some common problems. Thanks for the link, I'll need to
get through it first, thanks for the link


> https://lore.kernel.org/linux-block/CAJfpeguQ3xn2-6svkkVXJ88tiVfcDd-eKi1evzzfvu305fMoyw@mail.gmail.com/

-- 
Pavel Begunkov
