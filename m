Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05732521D74
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 17:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242359AbiEJPJC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 11:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345473AbiEJPIp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 11:08:45 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ECA33403A
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 07:35:38 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id a10so1246212ioe.9
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 07:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Q2KH7jTZBIBZhvzmYBshrWkNr2V+owGJwqefWyYk5j8=;
        b=O3L35Wzrzn/NVWRf3erThoEvB4SX8YJYuv87w515bB1TEgYTUIifU+K/kooL+1TWUk
         qx1C8bLKtvNJmk8NkpGgdr4+YVo22DiAoIOd/lS78K6NwS/dnzfPltVTLjoO3RMIKl7e
         tqKIKZBj213gMXNDSpf8EoLymrR68MOPkx9xg+zKtOVgXNAsKXWoANsMNDwNTihpve4e
         qd3AYAoRVZgqdwLi/eetdHLOvW9EjSR/z2iGSjfdKkJpzAUtYymrSamZ1XwTlyXjez3/
         l+qrjEXN3NzOPeUIRhBFxG46BgaijjMEne2uypS/+jvXG6GGvMTbDvaPKzyd3KAhgrUF
         3yDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q2KH7jTZBIBZhvzmYBshrWkNr2V+owGJwqefWyYk5j8=;
        b=S12Rk889At4TaUOEfGfWOVNLqCjP1VKtvHSV4VCd/WYM86k18CvmNvwphfuzNgpUq2
         f4qyUn5ankPI56KiXYEgK+CYQspdNvTbKX5eODFiZoRST55r5eNJw5DZrRHcRkbYJgN6
         9gs5rWymrJE3/+z2t0Lyew4QfaNjpJZ8dex1IMgw5+bbRj3LgtaxybsKURbwwJXItcN/
         8yk5DugRr8U4pOHgY+dSegXTcScpboz4DGG0YuiVERj577SNt0nFB2chG3VL6hULYPoB
         Tpl6jFwJuD2i7/jYaU+C8i9tqa6BaY7AgMq1JJMZhBCikIILDNect4Hs9qp1EHlbwFZQ
         FGJQ==
X-Gm-Message-State: AOAM530pTb8CsfgmphMXWHS2DCoY60aNEAF6wzQtdoYXixCKUM2Jxzjw
        5feuU86+lSqmNPGCuMELkeKtNA==
X-Google-Smtp-Source: ABdhPJxYZYINodWtjarzTaNgG21II+gn273WefdihpfHl3jOR98mh7p8OLBueLwj4xnN9DdmxzD3Gw==
X-Received: by 2002:a05:6602:1642:b0:65a:c4a2:85ca with SMTP id y2-20020a056602164200b0065ac4a285camr8450754iow.111.1652193338168;
        Tue, 10 May 2022 07:35:38 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e16-20020a02cab0000000b0032b3a781789sm4417229jap.77.2022.05.10.07.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 07:35:37 -0700 (PDT)
Message-ID: <8608a963-1969-7979-5438-f545f5534aea@kernel.dk>
Date:   Tue, 10 May 2022 08:35:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 1/5] fs,io_uring: add infrastructure for uring-cmd
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Stefan Roesch <shr@fb.com>, Anuj Gupta <anuj20.g@samsung.com>,
        gost.dev@samsung.com
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df@epcas5p3.samsung.com>
 <20220505060616.803816-2-joshi.k@samsung.com>
 <1af73495-d4a6-d6fd-0a03-367016385c92@kernel.dk>
 <CA+1E3r+airL_U0BzmLhiVPVkWdbiAXxxyHXONy9bGx4uuJFhdA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+1E3r+airL_U0BzmLhiVPVkWdbiAXxxyHXONy9bGx4uuJFhdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/10/22 8:23 AM, Kanchan Joshi wrote:
> On Thu, May 5, 2022 at 9:47 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 5/5/22 12:06 AM, Kanchan Joshi wrote:
>>> +static int io_uring_cmd_prep(struct io_kiocb *req,
>>> +                          const struct io_uring_sqe *sqe)
>>> +{
>>> +     struct io_uring_cmd *ioucmd = &req->uring_cmd;
>>> +     struct io_ring_ctx *ctx = req->ctx;
>>> +
>>> +     if (ctx->flags & IORING_SETUP_IOPOLL)
>>> +             return -EOPNOTSUPP;
>>> +     /* do not support uring-cmd without big SQE/CQE */
>>> +     if (!(ctx->flags & IORING_SETUP_SQE128))
>>> +             return -EOPNOTSUPP;
>>> +     if (!(ctx->flags & IORING_SETUP_CQE32))
>>> +             return -EOPNOTSUPP;
>>> +     if (sqe->ioprio || sqe->rw_flags)
>>> +             return -EINVAL;
>>> +     ioucmd->cmd = sqe->cmd;
>>> +     ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
>>> +     return 0;
>>> +}
>>
>> While looking at the other suggested changes, I noticed a more
>> fundamental issue with the passthrough support. For any other command,
>> SQE contents are stable once prep has been done. The above does do that
>> for the basic items, but this case is special as the lower level command
>> itself resides in the SQE.
>>
>> For cases where the command needs deferral, it's problematic. There are
>> two main cases where this can happen:
>>
>> - The issue attempt yields -EAGAIN (we ran out of requests, etc). If you
>>   look at other commands, if they have data that doesn't fit in the
>>   io_kiocb itself, then they need to allocate room for that data and have
>>   it be persistent
> 
> While we have io-wq retrying for this case, async_data is not allocated.
> We need to do that explicitly inside io_uring_cmd(). Something like this -
> 
> if (ret == -EAGAIN) {
> if (!req_has_async_data(req)) {
> if (io_alloc_async_data(req)) return -ENOMEM;
> io_uring_cmd_prep_async(req);
> }
> return ret;
> }
> 
>> - Deferral is specified by the application, using eg IOSQE_IO_LINK or
>>   IOSQE_ASYNC.
> For this to work, we are missing ".needs_async_setup = 1" for
> IORING_OP_URING_CMD.

Agree on both, the op handler itself should alloc the async_data for
this case and that flag does need to be set.

-- 
Jens Axboe

