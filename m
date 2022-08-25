Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDD35A0CBE
	for <lists+io-uring@lfdr.de>; Thu, 25 Aug 2022 11:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbiHYJfe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Aug 2022 05:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240447AbiHYJfX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Aug 2022 05:35:23 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A00DA6AC8;
        Thu, 25 Aug 2022 02:35:22 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 2so17303297edx.2;
        Thu, 25 Aug 2022 02:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=osOTmUMJE5eAZr0y+yx/yWnfWqXTDop3ldRmjd8ZeNE=;
        b=l6fcAsPUMD8kdEebYviQOs+UIrhrqQ9HRv3lm97iu5Re0+P7hwUITn3bZ3yN/NQkKa
         o6a1iLkfTP6MpCLN+Zmb5CxjqYiQXGNPoR82S/mJSl951uWDNbx1yQQ5d2/bBXRZvgw+
         2hZkpe9IxCFy0LdoIPqljHi/GIWBlrpQlorxbXed/fIQMeCf8tD0c68A8tzNZ87B/fKn
         gTSY4f1Ysg3BIzWkRgqlO41bZmgIbkvWnxc+4fXEKBvgwGyUNgz0JvJVTQkgWTgKbTCo
         R4E5fGgyonS1WhGir4NQphOxX4dXdLf+JRtVt5qB8n8a4DKgVoqPuf7AacrRauGUyKQh
         aWkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=osOTmUMJE5eAZr0y+yx/yWnfWqXTDop3ldRmjd8ZeNE=;
        b=AgJ3wYeMvWoYfG6Jb0SwR9s2xY371QV/WLKZbLsJm8NWVyDN90y9AzRJ79a+ZHPdpj
         Lg3ga5xq90JaLZI1cEaoMCJwgiKGrgLc8qgTMFdz4mUJ/fdmfsxOhSG7w8QcpayvERh1
         YYSw3hbFFYM+aZQI1h6hcuWDdSIZS/jfFIeueXcHz8UIr6cY/9LklHmTV3nBGXkXRvh8
         MzkcBPzk4xILlukYKLsM9tE9Hrqr3VHA6JWORf9ghG+M/RgnymiDG7bBNd4eKi2AIhNh
         ij7vB1TSE7zd573knn/oD1wrgDQ+nWe73SRY0W6Pod+GvKnZqo//o7KVOl4UiUvItqxM
         /DDA==
X-Gm-Message-State: ACgBeo2oa5jI1/63709diInQch9ZqwVk4rI+hiLtUzfcjIPzUHJ66WA8
        lgUXIr/CGSkVn16xelB6OkQ=
X-Google-Smtp-Source: AA6agR5IxKeJ6DHqqH4+LmjOUqA+rls5nfC938/vmHHq1XXoUNK+72EIUheXJ6/NXHMhbY6SBrb+bA==
X-Received: by 2002:a05:6402:88e:b0:445:e4c2:b8bf with SMTP id e14-20020a056402088e00b00445e4c2b8bfmr2407316edy.50.1661420121124;
        Thu, 25 Aug 2022 02:35:21 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:bb7b])
        by smtp.gmail.com with ESMTPSA id e6-20020a1709061e8600b0072b7d76211dsm2206725ejj.107.2022.08.25.02.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 02:35:20 -0700 (PDT)
Message-ID: <6e899ca1-bebb-5f94-1fa5-090a37ea03f2@gmail.com>
Date:   Thu, 25 Aug 2022 10:34:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-next 2/4] io_uring: introduce fixed buffer support for
 io_uring_cmd
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
References: <20220819103021.240340-1-joshi.k@samsung.com>
 <CGME20220819104038epcas5p265c9385cfd9189d20ebfffeaa4d5efae@epcas5p2.samsung.com>
 <20220819103021.240340-3-joshi.k@samsung.com>
 <3294f1e9-1946-2fbf-d5cd-fcdff9288f72@gmail.com>
 <20220822113341.GA31599@test-zns>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220822113341.GA31599@test-zns>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/22/22 12:33, Kanchan Joshi wrote:
> On Mon, Aug 22, 2022 at 11:58:24AM +0100, Pavel Begunkov wrote:
[...]
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 1463cfecb56b..80ea35d1ed5c 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -203,6 +203,7 @@ enum io_uring_op {
>>>      IORING_OP_SOCKET,
>>>      IORING_OP_URING_CMD,
>>>      IORING_OP_SENDZC_NOTIF,
>>> +    IORING_OP_URING_CMD_FIXED,
>>
>> I don't think it should be another opcode, is there any
>> control flags we can fit it in?
> 
> using sqe->rw_flags could be another way.

We also use ->ioprio for io_uring opcode specific flags,
e.g. like in io_sendmsg_prep() for IORING_RECVSEND_POLL_FIRST,
might be even better better.

> But I think that may create bit of disharmony in user-space.
> Current choice (IORING_OP_URING_CMD_FIXED) is along the same lines as
> IORING_OP_READ/WRITE_FIXED.

And I still believe it was a bad choice, I don't like this encoding
of independent options/features by linearising toggles into opcodes.
A consistent way to add vectored fixed bufs would be to have a 4th
opcode, e.g. READV_FIXED, which is not great.

> User-space uses new opcode, and sends the
> buffer by filling sqe->buf_index. So must we take a different way?

I do think so


>>>      /* this goes last, obviously */
>>>      IORING_OP_LAST,
>>> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
>>> index 9a0df19306fe..7d5731b84c92 100644
>>> --- a/io_uring/opdef.c
>>> +++ b/io_uring/opdef.c
>>> @@ -472,6 +472,16 @@ const struct io_op_def io_op_defs[] = {
>>>          .issue            = io_uring_cmd,
>>>          .prep_async        = io_uring_cmd_prep_async,
>>>      },
>>> +    [IORING_OP_URING_CMD_FIXED] = {
>>> +        .needs_file        = 1,
>>> +        .plug            = 1,
>>> +        .name            = "URING_CMD_FIXED",
>>> +        .iopoll            = 1,
>>> +        .async_size        = uring_cmd_pdu_size(1),
>>> +        .prep            = io_uring_cmd_prep,
>>> +        .issue            = io_uring_cmd,
>>> +        .prep_async        = io_uring_cmd_prep_async,
>>> +    },
>>>      [IORING_OP_SENDZC_NOTIF] = {
>>>          .name            = "SENDZC_NOTIF",
>>>          .needs_file        = 1,
>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>> index 1a4fb8a44b9a..3c7b94bffa62 100644
>>> --- a/io_uring/rw.c
>>> +++ b/io_uring/rw.c
>>> @@ -1005,7 +1005,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>>>          if (READ_ONCE(req->iopoll_completed))
>>>              break;
>>> -        if (req->opcode == IORING_OP_URING_CMD) {
>>> +        if (req->opcode == IORING_OP_URING_CMD ||
>>> +                req->opcode == IORING_OP_URING_CMD_FIXED) {
>>
>> I don't see the changed chunk upstream
> 
> Right, it is on top of iopoll support (plus one more series mentioned in
> covered letter). Here is the link - https://lore.kernel.org/linux-block/20220807183607.352351-1-joshi.k@samsung.com/
> It would be great if you could review that.
> 

-- 
Pavel Begunkov
