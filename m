Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823464305A0
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 01:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241203AbhJPX2O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Oct 2021 19:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241073AbhJPX2M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Oct 2021 19:28:12 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E8CC061765
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:26:03 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ec8so54079832edb.6
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=oLDt9YO0peltku8K38kIEtLG2pmoKcgOtOdF1celThM=;
        b=gCOAqEBwBfSEmLi8txbmsXjPXF5pjRR4z09AtCUwuDgIm8zSHAABZRnSWcPfSzKbq0
         voXMEsOfHhtUtR6IrQwCCncuWj8CywvNfpIwj5yv71P29zXGbj8Zv5tonicsWxKIhldB
         FBMON73FVjUrjZ1ZRawr/+2/ofQlBGNoir62S45Xh8Zc3UcUjgPhvpy0QuSlSUbFFqMT
         FPz2nGcIC95cPcAi5yfcYmqbWdHBry2te5HD2dNyCaiZSriXnhn9tw4FsEJcl973t5Ck
         KCt2lWved3HfN2NpPdnPccyMblwC1TE2VKQKIyjTGnopeejWQPZXlrhOEjI9+iEGLjh9
         VAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=oLDt9YO0peltku8K38kIEtLG2pmoKcgOtOdF1celThM=;
        b=r2wAly3OEzNI3aJGxZ+VjjQbBJH/ot9ZrzBC/ljbAZdlAGzpPH5flh4pFig9Nm/F5W
         tdTDoPOKXupTFo6/T9gOd2PqUiEW9seljqBe3hyKNHCZnboUVlcK/cSAVRdIXn5w5Q9V
         3NK2w+E9Ah/+Wiv3z0DRKyct5vVdGKyvYFYfpx/hXEEYmH8NsKWYFN1FVvk1y+QZycap
         JGkl0u19COEV/CE6x3nvsWf2uP2RhKGXa4LFEy0tuo7uXZOSEQ5MKDSLPEdSMXvcC2dW
         B3e5XqSp8vYm8ByZB31rq/ifYWv2pZzGFDjAcfCbZgUwpVEyuR3p63ivtQBrRBEcpfbo
         LULw==
X-Gm-Message-State: AOAM532dU4xrK3kl1d//Un2/4tcmbhrD8EqqXV74DpCbOb6SdGcAPXPE
        s3QzeWwKcKFGi2LwzzwisCg=
X-Google-Smtp-Source: ABdhPJy4+RIljhCAwJan/m8cEVyn0kowbMHJH3f5+2kM3eZtcFC1Ee2CnmBmeeaSIdGOBmmOVRIHnw==
X-Received: by 2002:a17:907:75f5:: with SMTP id jz21mr17915575ejc.345.1634426761905;
        Sat, 16 Oct 2021 16:26:01 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.201])
        by smtp.gmail.com with ESMTPSA id oz11sm6586239ejc.72.2021.10.16.16.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 16:26:01 -0700 (PDT)
Message-ID: <869d5110-973b-6c70-604d-48d6108c0379@gmail.com>
Date:   Sun, 17 Oct 2021 00:25:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Content-Language: en-US
To:     Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     "open list:IO_URING" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
References: <cover.1634144845.git.asml.silence@gmail.com>
 <2c2536c5896d70994de76e387ea09a0402173a3f.1634144845.git.asml.silence@gmail.com>
 <CAFUsyfKyRnXhcxOVfSAxeyKsQqGXJ7PdDYw3TXC3H+q_yp5LMA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 8/8] io_uring: rearrange io_read()/write()
In-Reply-To: <CAFUsyfKyRnXhcxOVfSAxeyKsQqGXJ7PdDYw3TXC3H+q_yp5LMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/21 23:52, Noah Goldstein wrote:
> On Thu, Oct 14, 2021 at 10:13 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> -       /* If the file doesn't support async, just async punt */
>> -       if (force_nonblock && !io_file_supports_nowait(req, WRITE))
>> -               goto copy_iov;
>> +               /* file path doesn't support NOWAIT for non-direct_IO */
>> +               if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&
> 
> You can drop this 'force_nonblock' no?

Indeed

> 
>> +                   (req->flags & REQ_F_ISREG))
>> +                       goto copy_iov;
>>
>> -       /* file path doesn't support NOWAIT for non-direct_IO */
>> -       if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&
>> -           (req->flags & REQ_F_ISREG))
>> -               goto copy_iov;
>> +               kiocb->ki_flags |= IOCB_NOWAIT;
>> +       } else {
>> +               /* Ensure we clear previously set non-block flag */
>> +               kiocb->ki_flags &= ~IOCB_NOWAIT;
>> +       }
>>
>>          ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
>>          if (unlikely(ret))
> 
> ...
> 
> What swapping order of conditions below:
> if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
> 
> The ret2 check will almost certainly be faster than 2x deref.

Makes sense. Want to send a patch?

-- 
Pavel Begunkov
