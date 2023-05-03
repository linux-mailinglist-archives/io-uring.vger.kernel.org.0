Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE73D6F5A75
	for <lists+io-uring@lfdr.de>; Wed,  3 May 2023 16:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjECOzi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 May 2023 10:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjECOzf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 May 2023 10:55:35 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0765C5255
        for <io-uring@vger.kernel.org>; Wed,  3 May 2023 07:55:33 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f315735514so27863155e9.1
        for <io-uring@vger.kernel.org>; Wed, 03 May 2023 07:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683125731; x=1685717731;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+nnZS5JtLAMXiGp3ERLdrcF9KzlUBHSDU8R5RX3cSK8=;
        b=oS4++amt2CWgXctFlOnTrcZ++kiQ26st9L3BnNUnzz+DueH7ZJysPY6S0FQy7vWJQm
         BJxA71HBzwNoV1bCcjRSxGnGlMM7/N2F2KN3dH+8VtDCqzA09boTU/krzxDykCPg1w6t
         qUfMIneUom1vrDpMcq+u/8u44OOz8zHuZLAT22vBdVEqBMIqsLWfSZp9Lt3gv0jBis74
         xr29MbYOPVxSp8+OO2Xa2VZ04NW7OWwJaXJgKZUsbeL7Li1hQmgarjzLhSvxnSL9wPYD
         FEZVL1vJtnOanHg90xgOfyDpvxF094d2BEE3D/s3pS9zD8xJdKqJwJdCyvS4EO68CBXg
         KNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683125731; x=1685717731;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+nnZS5JtLAMXiGp3ERLdrcF9KzlUBHSDU8R5RX3cSK8=;
        b=YHOzNCoX1/FyxHW1/uTPQ+fhGg7fb6DlDuDiM0w9TXIkDTRvCJESXk7nt5bSJcFgaO
         rG2cm6n3tPdVae8A7i0JRQN12P4BMVQstJzz1W9YvS2g8z3i0t41GaR1H64dXyu6VaBK
         k5rxZMppAB2tmk+VjK3Gh38rgDXVpM0JVzCx0iU7wGxxu3b9Ua/rst9qoghuKZ3nbciC
         Hd8zoAQXTssa3ZvYQtVF7RyjRkATqSLLVqSx1Z0ME0AoAfoug52luoAaRV0I9W3PFcXM
         8Gx9XtJnKtyzDXIqS2nRH0XDTecwQPcCNvT3SoSzM3KEPhna2zzdiU8GgxENo2Gokb25
         AIjQ==
X-Gm-Message-State: AC+VfDzrBgbkGegCjskteFsXnn6NtcT0FiIxJjNArMFyMXsAU5dlUu5h
        RmESjaTnP3VbAfWnn8e09Mg7ykfOw0U=
X-Google-Smtp-Source: ACHHUZ5IAe8RaXZ3CGnQBMQjg91+J/Umbp0Rm11/drU/iuISSRia32hxBfOZ+z28TL10ZQotgWkNtw==
X-Received: by 2002:a1c:e90a:0:b0:3f1:65cb:8156 with SMTP id q10-20020a1ce90a000000b003f165cb8156mr1722545wmc.0.1683125731173;
        Wed, 03 May 2023 07:55:31 -0700 (PDT)
Received: from [192.168.8.100] (188.30.86.13.threembb.co.uk. [188.30.86.13])
        by smtp.gmail.com with ESMTPSA id f6-20020a5d6646000000b002f6dafef040sm34007790wrw.12.2023.05.03.07.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 07:55:30 -0700 (PDT)
Message-ID: <4527d9f3-d7d5-908e-bf34-5c2a4e4e9609@gmail.com>
Date:   Wed, 3 May 2023 15:54:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC 7/7] io_uring,fs: introduce IORING_OP_GET_BUF
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <cover.1682701588.git.asml.silence@gmail.com>
 <fc43826d510dc75de83d81161ca03e2688515686.1682701588.git.asml.silence@gmail.com>
 <ZFEk2rQv2//KRBeK@ovpn-8-16.pek2.redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZFEk2rQv2//KRBeK@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/2/23 15:57, Ming Lei wrote:
> On Sun, Apr 30, 2023 at 10:35:29AM +0100, Pavel Begunkov wrote:
>> There are several problems with splice requests, aka IORING_OP_SPLICE:
>> 1) They are always executed by a worker thread, which is a slow path,
>>     as we don't have any reliable way to execute it NOWAIT.
>> 2) It can't easily poll for data, as there are 2 files it operates on.
>>     It would either need to track what file to poll or poll both of them,
>>     in both cases it'll be a mess and add lot of overhead.
>> 3) It has to have pipes in the middle, which adds overhead and is not
>>     great from the uapi design perspective when it goes for io_uring
>>     requests.
>> 4) We want to operate with spliced data as with a normal buffer, i.e.
>>     write / send / etc. data as normally while it's zerocopy.
>>
>> It can partially be solved, but the root cause is a suboptimal for
>> io_uring design of IORING_OP_SPLICE. Introduce a new request type
>> called IORING_OP_GET_BUF, inspired by splice(2) as well as other
>> proposals like fused requests. The main idea is to use io_uring's
>> registered buffers as the middle man instead of pipes. Once a buffer
>> is fetched / spliced from a file using a new fops callback
>> ->iou_get_buf, it's installed as a registered buffers and can be used
>> by all operations supporting the feature.
>>
>> Once the userspace releases the buffer, io_uring will wait for all
>> requests using the buffer to complete and then use a file provided
>> callback ->release() to return the buffer back. It operates on the
> 
> In the commit of "io_uring: add an example for buf-get op", I don't see
> any code to release the buffer, can you explain it in details about how
> to release the buffer in userspace? And add it in your example?

Sure, we need to add buf updates via request.

Particularly, in this RFC, the removal from the table was happening
in io_install_buffer() by one of the test-only patches, the "remove
previous entry on update" style as it's with files. Then it's
released with the last ref put, either on removal with a request
like:

io_free_batch_list()
      io_req_put_rsrc_locked()
          ...

> Here I guess the ->release() is called in the following code path:
> 
> io_buffer_unmap
>      io_rsrc_buf_put
>          io_rsrc_put_work
>              io_rsrc_node_ref_zero
>                  io_put_rsrc_node
> 
> If it is true, what is counter-pair code for io_put_rsrc_node()?
> So far, only see io_req_set_rsrc_node() is called from
> io_file_get_fixed(), is it needed for consumer OP of the buffer?
> 
> Also io_buffer_unmap() is called after io_rsrc_node's reference drops
> to zero, which means ->release() isn't called after all its consumer(s)
> are done given io_rsrc_node is shared by in-flight requests. If it is
> true, this way will increase buffer lifetime a lot.

That's true. It's not a new downside, so might make more sense
to do counting per rsrc (file, buffer), which is not so bad for
now, but would be a bit concerning if we grow the number of rsrc
types.

> ublk zero copy needs to call ->release() immediately after all
> consumers are done, because the ublk disk request won't be completed
> until the buffer is released(the buffer actually belongs to ublk block request).
> 
> Also the usage in liburing example needs two extra syscall(io_uring_enter) for
> handling one IO, not take into account the "release OP". IMO, this way makes

Something is amiss here. It's 3 requests, which means 3 syscalls
if you send requests separately (each step can be batch more
requests), or 1 syscall if you link them together. There is an
example using links for 2 requests in the test case.

> application more complicated, also might perform worse:
> 
> 1) for ublk zero copy, the original IO just needs one OP, but now it
> takes three OPs, so application has to take coroutine for applying

Perhaps, you mean two requests for fused, IORING_OP_FUSED_CMD + IO
request, vs three for IORING_OP_GET_BUF. There might be some sort of
auto-remove on use, making it two requests, but that seems a bit ugly.

> 3 stages batch submission(GET_BUF, IO, release buffer) since IO_LINK can't
> or not suggested to be used. In case of low QD, batch size is reduced much,
> and performance may hurt because IOs/syscall is 1/3 of fused command.

I'm not a big fan of links for their inflexibility, but it can be
used. The point is rather it's better not to be the only way to
use the feature as we may need to stop in the middle, return
control to the userspace and let it handle errors, do data processing
and so on. The latter may need a partial memcpy() into the userspace,
e.g. copy a handful bytes of headers to decide what to do with the
rest of data.

I deem fused cmds to be a variant of linking, so it's rather with
it you link 2 requests vs optionally linking 3 with this patchset.

> 2) GET_BUF OP is separated from the consumer OP, this way may cause
> more cache miss, and I know this way is for avoiding IO_LINK.
> 
> I'd understand the approach first before using it to implement ublk zero copy
> and comparing its performance with fused command.

-- 
Pavel Begunkov
