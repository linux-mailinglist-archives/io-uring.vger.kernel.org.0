Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC1B6B0BD5
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 15:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCHOuJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 09:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjCHOth (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 09:49:37 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1069E584B4;
        Wed,  8 Mar 2023 06:48:16 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id k37so10009673wms.0;
        Wed, 08 Mar 2023 06:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678286894;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ezEn3QXBh0CD7oJkz7CA1kkMvWThcfVYzM3zG0nOgUc=;
        b=De3DAeye/y9cDLD5yRVC73zY8Q/p5QduRZsgKkWuMmgPxHsodKwMAjlaAiGf9CmR7u
         7GRo1bx95hn9/WdPpfhRAqBwzpEYVyOZxIcirr60jLlWzbGd5lr8cmIoSm/TBmQPsZRD
         ek5VO1s53L0i10b/CFQF2p4JYLf76O47lH4z4hu9drkKgpJ/1iQ+oK2EItPKYVcpcllO
         vWXNps+BWtSyy7frYQDH+tLSqX1+xz10IbIFClGqg/TW/EBLGAFHVVIKwRVkV/hPZ07l
         9BdIxwdmKGsr1Dp0KPsI2P/5TFV3YQquayWf1VPosvMCxzFQp+p4YybQfIRYnPd1GwEK
         T2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678286894;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ezEn3QXBh0CD7oJkz7CA1kkMvWThcfVYzM3zG0nOgUc=;
        b=Hul0t8opoc8L+iSKlbPc0imtWgfi6dtJwdUgfxgiW2+owVgnp8bcARdwawgjiKiOdX
         0Fupfew6214J08D7aNykaYX7JolaX0xG57blmwk1RpwAh0fDj/lEYq5o8QV1aRm/2aC2
         0C0a4nGN1WgLlO/cZeYd1hTJ8R5amRAxxkg3Jbo7MOnuKXVQ4P96s0frfgHRE8G9Gg1z
         csbqXWHoByNiBbSMki6dt/fAIEMonMFt0pQk8i5G4Fn5FngTOAo1LOMb1BBAfysRk9a4
         mbklCjdbOPSD0rdxDjoy08hY8lbxEA3zCy1WX1Fg3fY5w5BUbRPFTxSdij5GlPFdLKnF
         SC2Q==
X-Gm-Message-State: AO0yUKU05hx4OFfbjVpdDxbXU4oeCyRqWEIHJiwvjUjK15hvC7j3zRG5
        9Th+E610Xr7ZDcgQ1y3Ks5Y=
X-Google-Smtp-Source: AK7set8m9oGDlCmEVV2wj5VyOJCYXmUEku/BHPJAV/Csw9F/BFe6ZGEOk4sxHWl5s7q+6GzNwZ2n/g==
X-Received: by 2002:a05:600c:474c:b0:3eb:2de8:b74e with SMTP id w12-20020a05600c474c00b003eb2de8b74emr17285159wmo.27.1678286894307;
        Wed, 08 Mar 2023 06:48:14 -0800 (PST)
Received: from [192.168.8.100] (188.30.85.94.threembb.co.uk. [188.30.85.94])
        by smtp.gmail.com with ESMTPSA id k7-20020a05600c080700b003e21ba8684dsm16223045wmp.26.2023.03.08.06.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 06:48:14 -0800 (PST)
Message-ID: <effb2361-b66e-2678-ef86-5f9565c4ad9a@gmail.com>
Date:   Wed, 8 Mar 2023 14:46:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH V2 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
 <7e05882f-9695-895d-5e83-61006e54c4b2@gmail.com>
 <ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com>
 <ZAfurtfY4lXa8sxX@ovpn-8-16.pek2.redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZAfurtfY4lXa8sxX@ovpn-8-16.pek2.redhat.com>
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

On 3/8/23 02:10, Ming Lei wrote:
> On Tue, Mar 07, 2023 at 05:17:04PM +0000, Pavel Begunkov wrote:
>> On 3/7/23 15:37, Pavel Begunkov wrote:
>>> On 3/7/23 14:15, Ming Lei wrote:
>>>> Hello,
>>>>
>>>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>>>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>>>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>>>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>>>> and its ->issue() can retrieve/import buffer from master request's
>>>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>>>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>>>> submits slave OP just like normal OP issued from userspace, that said,
>>>> SQE order is kept, and batching handling is done too.
>>>
>>>   From a quick look through patches it all looks a bit complicated
>>> and intrusive, all over generic hot paths. I think instead we
>>> should be able to use registered buffer table as intermediary and
>>> reuse splicing. Let me try it out
>>
>> Here we go, isolated in a new opcode, and in the end should work
>> with any file supporting splice. It's a quick prototype, it's lacking
>> and there are many obvious fatal bugs. It also needs some optimisations,
>> improvements on how executed by io_uring and extra stuff like
>> memcpy ops and fixed buf recv/send. I'll clean it up.
>>
>> I used a test below, it essentially does zc recv.
>>
>> https://github.com/isilence/liburing/commit/81fe705739af7d9b77266f9aa901c1ada870739d
>>
[...]
>> +int io_splice_from(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_splice_from *sp = io_kiocb_to_cmd(req, struct io_splice_from);
>> +	loff_t *ppos = (sp->off == -1) ? NULL : &sp->off;
>> +	struct io_mapped_ubuf *imu;
>> +	struct pipe_inode_info *pi;
>> +	struct io_ring_ctx *ctx;
>> +	unsigned int pipe_tail;
>> +	int ret, i, nr_pages;
>> +	u16 index;
>> +
>> +	if (!sp->file->f_op->splice_read)
>> +		return -ENOTSUPP;
>> +
>> +	pi = alloc_pipe_info();
> 
> The above should be replaced with direct pipe, otherwise every time
> allocating one pipe inode really hurts performance.

We don't even need to alloc it dynanically, could be just
on stack. There is a long list of TODOs I can add, e.g.
polling support, retries, nowait, caching imu and so on.

[...]
> Your patch looks like transferring pages ownership to io_uring fixed
> buffer, but unfortunately it can't be done in this way. splice is
> supposed for moving data, not transfer buffer ownership.

Borrowing rather than transferring. It's not obvious since it's
not implemented in the patch, but the buffer should be eventually
returned using the splice's ->release callback.

> https://lore.kernel.org/linux-block/CAJfpeguQ3xn2-6svkkVXJ88tiVfcDd-eKi1evzzfvu305fMoyw@mail.gmail.com/
> 
> 1) pages are actually owned by device side(ublk, here: sp->file), but we want to
> loan them to io_uring normal OPs.
> 
> 2) after these pages are used by io_uring normal OPs, these pages have
> been returned back to sp->file, and the notification has to be done
> explicitly, because page is owned by sp->file of splice_read().

Right, see above, they're going to be returned back via ->release.

> 3) pages RW direction has to limited strictly, and in case of ublk/fuse,
> device pages can only be read or write which depends on user io request
> direction.

Yes, I know, and directions will be needed anyway for DMA mappings and
different p2p cases in the future, but again a bunch of things is
omitted here.

> 
> Also IMO it isn't good to add one buffer to ctx->user_bufs[] oneshot and
> retrieve it oneshot, and it can be set via req->imu simply in one fused
> command.

That's one of the points though. It's nice if not necessary (for a generic
feature) to be able to do multiple ops on the data. For instance, if we
have a memcpy request, we can link it to this splice / zc recv, memcpy
necessary headers to the userspace and let it decide how to proceed with
data.

-- 
Pavel Begunkov
