Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA0E6CA9E7
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 18:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjC0QFF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 12:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjC0QFE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 12:05:04 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B18BF;
        Mon, 27 Mar 2023 09:05:03 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b20so38382337edd.1;
        Mon, 27 Mar 2023 09:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679933102;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j2eNrnZLsC/sH8bLS1Gd4Au+GF568VY/ybvODVTAJAA=;
        b=bDoL5S1ZgFx4UpAC0ek0FAoxVtZEPzhrh9PAhynArKTRR6vDQVnkINfV2+MWQeQ9Gq
         ci3iV7xP9ysML9c7L08N+7jAEq8pkG1YvKcjk7EtW+F31wQhXJMFgSwbNZzQxv7/+6/k
         qvJRM+7gTJuceDvUun+X9PT0Ta66mziFW1fwCEw1Lub4iImHgBHyseR7We0U2MX7iVr7
         1jgnjfdW1ld72hlYsQGcIvS7I9BrDN6LIYhZ+Pyh3KMY4843giUVKvUGsEyMKxKPpp0d
         bMoSGXi7s1cgWCBq7cDHeQrwIm4TbgOx8qvsQ+NJSJTJzsXGaVneuPoNc4cdxE+/UplJ
         boWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679933102;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j2eNrnZLsC/sH8bLS1Gd4Au+GF568VY/ybvODVTAJAA=;
        b=57xqBpYllIdmYPFQXr7xH4y8Ezw+pvrVuTRdQ1iDC2VDRpBYmEmP6Ntby9pSOoznOE
         ogRjuQPwVIdy5wTkicOw55Gf1uUwz6WwFa79HpMk2XJ4eFi4jAorl2CZUVlGVWLaRSeX
         d5y558jYf3IRKQGdqcg8/SNZtIdrRl9dLttlkFwAnUOlM3nbJy+99/XLa5L2KfZAwpEF
         NCE/R+PJ4hslp1kWJ4oaOHGoN1vD0piG33UmqRubntGUrFR69oxRQ7Mj1PWgZuAJFLYI
         4AvPVdHB68WghqBNwNOiTEAC3NKoNYNqLs1sbhG3eMJhNFaEgYFYT6bJ6kVJnNg+GXPc
         vlNQ==
X-Gm-Message-State: AAQBX9eGADd4VgmwUjX/VnrEtCO/T4FXayXAiC+Coo//ZdCUon1g+yWc
        cDvvHn0aq0pyJPN/yh263DQ=
X-Google-Smtp-Source: AKy350YE+6n8JJYVVf7QDhetMimnyyNnluuj62XuXTw+L0IqYQc7JwnMPdfi72GokouzyrhMvVzfyQ==
X-Received: by 2002:a05:6402:184f:b0:4fc:494a:98f5 with SMTP id v15-20020a056402184f00b004fc494a98f5mr14382724edy.29.1679933101942;
        Mon, 27 Mar 2023 09:05:01 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:e437])
        by smtp.gmail.com with ESMTPSA id a25-20020a50c319000000b004bc15a440f1sm14945021edb.78.2023.03.27.09.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 09:05:01 -0700 (PDT)
Message-ID: <5160ca98-af64-5916-53f6-b8ed39c9a1a6@gmail.com>
Date:   Mon, 27 Mar 2023 17:04:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
 <845ff5cb-b0ff-8ea0-e2ff-a5b216966dfb@gmail.com>
 <ded5b188-0bcd-3003-353e-b31608e58be4@linux.alibaba.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ded5b188-0bcd-3003-353e-b31608e58be4@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/21/23 09:17, Ziyang Zhang wrote:
> On 2023/3/19 00:23, Pavel Begunkov wrote:
>> On 3/16/23 03:13, Xiaoguang Wang wrote:
>>>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>>>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>>>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>>>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>>>> and its ->issue() can retrieve/import buffer from master request's
>>>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>>>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>>>> submits slave OP just like normal OP issued from userspace, that said,
>>>> SQE order is kept, and batching handling is done too.
>>> Thanks for this great work, seems that we're now in the right direction
>>> to support ublk zero copy, I believe this feature will improve io throughput
>>> greatly and reduce ublk's cpu resource usage.
>>>
>>> I have gone through your 2th patch, and have some little concerns here:
>>> Say we have one ublk loop target device, but it has 4 backend files,
>>> every file will carry 25% of device capacity and it's implemented in stripped
>>> way, then for every io request, current implementation will need issed 4
>>> fused_cmd, right? 4 slave sqes are necessary, but it would be better to
>>> have just one master sqe, so I wonder whether we can have another
>>> method. The key point is to let io_uring support register various kernel
>>> memory objects, which come from kernel, such as ITER_BVEC or
>>> ITER_KVEC. so how about below actions:
>>> 1. add a new infrastructure in io_uring, which will support to register
>>> various kernel memory objects in it, this new infrastructure could be
>>> maintained in a xarray structure, every memory objects in it will have
>>> a unique id. This registration could be done in a ublk uring cmd, io_uring
>>> offers registration interface.
>>> 2. then any sqe can use these memory objects freely, so long as it
>>> passes above unique id in sqe properly.
>>> Above are just rough ideas, just for your reference.
>>
>> It precisely hints on what I proposed a bit earlier, that makes
>> me not alone thinking that it's a good idea to have a design allowing
>> 1) multiple ops using a buffer and 2) to limiting it to one single
>> submission because the userspace might want to preprocess a part
>> of the data, multiplex it or on the opposite divide. I was mostly
>> coming from non ublk cases, and one example would be such zc recv,
>> parsing the app level headers and redirecting the rest of the data
>> somewhere.
>>
>> I haven't got a chance to work on it but will return to it in
>> a week. The discussion was here:
>>
>> https://lore.kernel.org/all/ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com/
>>
> 
> Hi Pavel and all,
> 
> I think it is a good idea to register some kernel objects(such as bvec)
> in io_uring and return a cookie(such as buf_idx) for READ/WRITE/SEND/RECV sqes.
> There are some ways to register user's buffer such as IORING_OP_PROVIDE_BUFFERS
> and IORING_REGISTER_PBUF_RING but there is not a way to register kernel buffer(bvec).
> 
> I do not think reusing splice is a good idea because splice should run in io-wq.

The reason why I disabled inline splice execution is because do_splice()
and below the stack doesn't support nowait well enough, which is not a
problem when we hook directly under the ->splice_read() callback and
operate only with one file at a time at the io_uring level.


> If we have a big sq depth there may be lots of io-wqs. Then lots of context switch
> may lower the IO performance especially for small IO size.
> 
> Here are some rough ideas:
> (1) design a new OPCODE such as IORING_REGISTER_KOBJ to register kernel objects in
>      io_uring or
> (2) reuse uring-cmd. We can send uring-cmd to drivers(opcode may be CMD_REGISTER_KBUF)
>      and let drivers call io_uring_provide_kbuf() to register kbuf. io_uring_provide_kbuf()
>      is a new function provided by io_uring for drivers.
> (3) let the driver call io_uring_provide_kbuf() directly. For ublk, this function is called
>      before io_uring_cmd_done().

-- 
Pavel Begunkov
