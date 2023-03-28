Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210766CBCF8
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 13:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjC1LCZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 07:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjC1LCY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 07:02:24 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D8272AA;
        Tue, 28 Mar 2023 04:02:23 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id eh3so47858231edb.11;
        Tue, 28 Mar 2023 04:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680001342;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=axpoybQQ1eolP+A6M+WQNX40O8YR2DJMUCqnnCxrUf8=;
        b=ckfOH7kGvUu5YH1SokhfwdPc5RgbATWcnJAernVcWFB9gyodZO4ltAiv8iLSFhAeZ0
         KsRzQRa+fHWvFSNMa4jmf07JIHLXaaWp1wBh0AHu4Fo6rFDV7vtiQYsjfFIIFOCo5hnL
         Iybt0t1aAooWXq2Qq3VrzKqFTu7Y+grHJWI9s8sdTi9mF0BrvVa1XNWSuwrtCf+cofwN
         BzeTm1Aq+FrumSaHFv0q1wTtcVg+eO+rigSknNJYeDI0zWDLddzt6SFNd1oTX7XSqhP9
         AuI1XjW/SOADge0DEyxWflKzWn2P5/iLPHq7STktdiRdq5o0Xg8uQw6kDVvP+ShU3GHe
         LGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680001342;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=axpoybQQ1eolP+A6M+WQNX40O8YR2DJMUCqnnCxrUf8=;
        b=rJFdn1bHhC/zKuwFlDf08sgr+fFLYxEAn2sOZ93k31LoGWulPW/LoFu5kRv0yF8TvP
         MrVMSIqCj4wuG+QWlUQUeVQZn+pEyde22Tfkr2nZK+fUInvcc9UyxpY9ZT/7s3+Zz1g/
         ZDWvdaYhO7btYZGQEvMcqE1xxsQztpdx0mBfWN5ZFCJUZXV2vsJaCjacYdkI2QOEcu5V
         5Y1QhNX9DQ/GgZ2enK93tgU38OxLYi/8RXRErmytOU7rhZSfMYElFDt8sC5bvMUpHGit
         HdAZjFVAGGxhixzz41qFOe3rcu7oJr9ZrKNu4SWELlZvO/7A1zKwssHQWiUmJWTG6pXi
         129Q==
X-Gm-Message-State: AAQBX9fXZLG0nukoI1HpMPSuvYflrK6ApgGW/lN5i7VdvE2+VIPPQnyB
        x+bPqZ7IKUHj6N8HWK7wBpUlATqNifQ=
X-Google-Smtp-Source: AKy350buuJkASEhzhucKvQ0e8T7XBUdauZOL5pzq2Q4/2ikSEfYutc0lUH2G/72z0X4ZV7wZOu0mOQ==
X-Received: by 2002:a17:906:9442:b0:8aa:c090:a9ef with SMTP id z2-20020a170906944200b008aac090a9efmr14086554ejx.55.1680001341824;
        Tue, 28 Mar 2023 04:02:21 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:d7])
        by smtp.gmail.com with ESMTPSA id cw21-20020a170906479500b009442efdaf20sm2853824ejc.156.2023.03.28.04.02.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 04:02:21 -0700 (PDT)
Message-ID: <518a18e9-3998-ec2a-14e2-6308bb5c797b@gmail.com>
Date:   Tue, 28 Mar 2023 12:01:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
 <845ff5cb-b0ff-8ea0-e2ff-a5b216966dfb@gmail.com>
 <ded5b188-0bcd-3003-353e-b31608e58be4@linux.alibaba.com>
 <5160ca98-af64-5916-53f6-b8ed39c9a1a6@gmail.com>
 <ZCI8YWTV4h0K64AZ@ovpn-8-20.pek2.redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZCI8YWTV4h0K64AZ@ovpn-8-20.pek2.redhat.com>
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

On 3/28/23 02:01, Ming Lei wrote:
> On Mon, Mar 27, 2023 at 05:04:01PM +0100, Pavel Begunkov wrote:
>> On 3/21/23 09:17, Ziyang Zhang wrote:
>>> On 2023/3/19 00:23, Pavel Begunkov wrote:
>>>> On 3/16/23 03:13, Xiaoguang Wang wrote:
>>>>>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>>>>>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>>>>>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>>>>>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>>>>>> and its ->issue() can retrieve/import buffer from master request's
>>>>>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>>>>>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>>>>>> submits slave OP just like normal OP issued from userspace, that said,
>>>>>> SQE order is kept, and batching handling is done too.
>>>>> Thanks for this great work, seems that we're now in the right direction
>>>>> to support ublk zero copy, I believe this feature will improve io throughput
>>>>> greatly and reduce ublk's cpu resource usage.
>>>>>
>>>>> I have gone through your 2th patch, and have some little concerns here:
>>>>> Say we have one ublk loop target device, but it has 4 backend files,
>>>>> every file will carry 25% of device capacity and it's implemented in stripped
>>>>> way, then for every io request, current implementation will need issed 4
>>>>> fused_cmd, right? 4 slave sqes are necessary, but it would be better to
>>>>> have just one master sqe, so I wonder whether we can have another
>>>>> method. The key point is to let io_uring support register various kernel
>>>>> memory objects, which come from kernel, such as ITER_BVEC or
>>>>> ITER_KVEC. so how about below actions:
>>>>> 1. add a new infrastructure in io_uring, which will support to register
>>>>> various kernel memory objects in it, this new infrastructure could be
>>>>> maintained in a xarray structure, every memory objects in it will have
>>>>> a unique id. This registration could be done in a ublk uring cmd, io_uring
>>>>> offers registration interface.
>>>>> 2. then any sqe can use these memory objects freely, so long as it
>>>>> passes above unique id in sqe properly.
>>>>> Above are just rough ideas, just for your reference.
>>>>
>>>> It precisely hints on what I proposed a bit earlier, that makes
>>>> me not alone thinking that it's a good idea to have a design allowing
>>>> 1) multiple ops using a buffer and 2) to limiting it to one single
>>>> submission because the userspace might want to preprocess a part
>>>> of the data, multiplex it or on the opposite divide. I was mostly
>>>> coming from non ublk cases, and one example would be such zc recv,
>>>> parsing the app level headers and redirecting the rest of the data
>>>> somewhere.
>>>>
>>>> I haven't got a chance to work on it but will return to it in
>>>> a week. The discussion was here:
>>>>
>>>> https://lore.kernel.org/all/ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com/
>>>>
>>>
>>> Hi Pavel and all,
>>>
>>> I think it is a good idea to register some kernel objects(such as bvec)
>>> in io_uring and return a cookie(such as buf_idx) for READ/WRITE/SEND/RECV sqes.
>>> There are some ways to register user's buffer such as IORING_OP_PROVIDE_BUFFERS
>>> and IORING_REGISTER_PBUF_RING but there is not a way to register kernel buffer(bvec).
>>>
>>> I do not think reusing splice is a good idea because splice should run in io-wq.
>>
>> The reason why I disabled inline splice execution is because do_splice()
>> and below the stack doesn't support nowait well enough, which is not a
>> problem when we hook directly under the ->splice_read() callback and
>> operate only with one file at a time at the io_uring level.
> 
> I believe I have explained several times[1][2] it isn't good solution for ublk
> zero copy.
> 
> But if you insist on reusing splice for this feature, please share your code and
> I'm happy to give an review.

Absolutely, I was not available the last week, will be catching up to
all that and prototyping it. Let me just note again that my point was
not in internally using splice bits but rather in having a different
uapi, i.e. mediating with the io_uring's registered buffers.


> [1] https://lore.kernel.org/linux-block/ZB8B8cr1%2FqIcPdRM@ovpn-8-21.pek2.redhat.com/T/#m1bfa358524b6af94731bcd5be28056f9f4408ecf
> [2] https://github.com/ming1/linux/blob/my_v6.3-io_uring_fuse_cmd_v4/Documentation/block/ublk.rst#zero-copy

-- 
Pavel Begunkov
