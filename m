Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833E21A5DB0
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 11:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgDLJPG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Apr 2020 05:15:06 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:46148 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgDLJPF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Apr 2020 05:15:05 -0400
Received: by mail-lj1-f182.google.com with SMTP id r7so5928515ljg.13
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2020 02:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WtMQ9A1/Pkp9JSQsFgnCgOSWfvnws7Dmpty3lG3WeP0=;
        b=B4Z6g2uIuGFffLDLnBq9oqmF36FlDzPFw2DbkSYBoL73fX37pg2Jk7/yWLGHh3w3ix
         5z1zgvV3gyEO8oFwuq0bUhDCbfKJpPMiMNGxfCitjF7We0U1dg6aOmEu3ENajLvwBTjN
         DN83fauYGDq89K9M9izTk8IyjXIucYHKb0EcGw0dd7bdDZZriLcxtgD3lLK1kbsYVuKs
         lN7yfLm7t9wY8D1aZjxdlVikB+M9/hYEQ29bg1kEI9iQobkZhlqOJlwdnCHzyZYJCAlO
         WNG7FAVxA6yr2+J78f2s+zJl/4FQb55jD+fKuF7PEl5sSUvYp/sepQzKkuvBkUOpqVE7
         D5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WtMQ9A1/Pkp9JSQsFgnCgOSWfvnws7Dmpty3lG3WeP0=;
        b=cVO38yWQZpurhx8dXgqdgrkZLb2Jm9BoZ/Jc39BbPJQ1ALjR5+TBcloZUY5BvPJSCo
         6o5TRvunIOGhNslRUw9nUTgYEW2drU5xfZQbLDPatQnH8nrGjUEbbI7vd//dSdoX80k6
         9K9v9hMVVz6jJj6Co4ldP9YiVf0eGnlX1/gYDqfgjGmSwSydofKHr1EXDOvv/P7v1j70
         xtW/2V1Lej5MPyLUIqT/O9pCfx9Eo9jyb/BxJOrCAHFRBdMfJjaDUcdqgc2Em94+HYWI
         seDgJIylLXy/4V7EKr1yxlDGrltZtDcqxJ4N5/jDRCuT+11Itx/NDwxWSMEGrGGf3gg4
         E3dg==
X-Gm-Message-State: AGi0PuYdvaqoZ815iNrhMAwFG1MxIgKOQTAq0bI+0x5UkNhxspGKNZaR
        3/bSyxjM7hRhi+eca41sE0my4F+Q
X-Google-Smtp-Source: APiQypIaFEHCpgpCZQm2ByiIfZjxrBvZ7OTkpC8sCnrTDIs2Q3gleRUK+PbsnB5bVLQ9iH1QnWOdOg==
X-Received: by 2002:a2e:9815:: with SMTP id a21mr7802248ljj.180.1586682903664;
        Sun, 12 Apr 2020 02:15:03 -0700 (PDT)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id w27sm6885940lfn.45.2020.04.12.02.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2020 02:15:02 -0700 (PDT)
Subject: Re: Odd timeout behavior
To:     Jens Axboe <axboe@kernel.dk>, Hrvoje Zeba <zeba.hrvoje@gmail.com>,
        io-uring@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>
References: <CAEsUgYgTSVydbQdjVn1QuqFSHZp_JfDZxRk7KwWVSZikxY+hYg@mail.gmail.com>
 <e146dd8a-f6b6-a101-a40e-ece22b7fe320@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <fe383a44-bcfb-d6fa-2afe-983b456e7112@gmail.com>
Date:   Sun, 12 Apr 2020 12:15:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e146dd8a-f6b6-a101-a40e-ece22b7fe320@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/2020 5:07 AM, Jens Axboe wrote:
> On 4/11/20 5:00 PM, Hrvoje Zeba wrote:
>> Hi,
>>
>> I've been looking at timeouts and found a case I can't wrap my head around.
>>
>> Basically, If you submit OPs in a certain order, timeout fires before
>> time elapses where I wouldn't expect it to. The order is as follows:
>>
>> poll(listen_socket, POLLIN) <- this never fires
>> nop(async)
>> timeout(1s, count=X)
>>
>> If you set X to anything but 0xffffffff/(unsigned)-1, the timeout does
>> not fire (at least not immediately). This is expected apart from maybe
>> setting X=1 which would potentially allow the timeout to fire if nop
>> executes after the timeout is setup.
>>
>> If you set it to 0xffffffff, it will always fire (at least on my
>> machine). Test program I'm using is attached.
>>
>> The funny thing is that, if you remove the poll, timeout will not fire.
>>
>> I'm using Linus' tree (v5.6-12604-gab6f762f0f53).
>>
>> Could anybody shine a bit of light here?
> 
> Thinking about this, I think the mistake here is using the SQ side for
> the timeouts. Let's say you queue up N requests that are waiting, like
> the poll. Then you arm a timeout, it'll now be at N + count before it
> fires. We really should be using the CQ side for the timeouts.

As I get it, the problem is that timeout(off=0xffffffff, 1s) fires
__immediately__ (i.e. not waiting 1s). Currently, it should work more
like "fire after N events *submitted after the timeout* completed", so
SQ vs CQ is another topic, but IMHO is not related.

And still, the described behaviour is out of the definition. It's sounds
like int overflow. Ok, I'll debug it, rest assured. I already see a
couple of flaws anyway.

BTW, I don't see why this offset feature is there in the first place. It
can be easily done in the userspace on CQ reaping. It won't help
multi-threaded apps as well.

-- 
Pavel Begunkov
