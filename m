Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4616DDE41
	for <lists+io-uring@lfdr.de>; Tue, 11 Apr 2023 16:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjDKOlU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 10:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDKOlT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 10:41:19 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB8AE1
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 07:41:18 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-760a1c94c28so178439f.1
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 07:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1681224077; x=1683816077;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n/FnNe6gGHiYX4mW0URPcwZFPNG4duBkLOZamx4qtC4=;
        b=xmJtVtjgPQmT1ogKqCCR1Mio/dOc/kXdrdryozEgU+EUOo596wfHrTRTpe58rCU+ck
         DtONu+tCp87Tm63513IkgyHJTOUSSVTG9146W0SssgEs97XSIhO8MFCwCngI2hkqbGir
         lGb2G/RpF8PzKUyX4YuF02wDZl4MVDneAb/kmdnib1csj4qo/zegf4p8LklnUubS+/Rt
         5eD4ijI15YvqAEnkts/9QjdNCM0WK9rs/gwVxblUmqF7QxYdgRU9ngZDCUivprys06TQ
         jGxhvCbhJ5zieMdk9AmZPqohfZk/MLWJbkEwoHuQoFud0DXFRxog7iZZY7vRNU3Z/F6Q
         NSVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681224077; x=1683816077;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n/FnNe6gGHiYX4mW0URPcwZFPNG4duBkLOZamx4qtC4=;
        b=H6EwMXsAZK9hpAIKjS2rg5lBELxhA1z0WFYffdwziGGkmfWrQGwLFt3eS+lM2JAk71
         hXcQeZgZ9jSVsWDhvvKRuAg46wifP0/fVyrT+9O7IKhsKyNjNSYwoX+WarQz3KgKStmz
         OaiRHepYSmYsiHQ4tUpJZSUp6Z9amNmQ49iBO8gqXCjZe6/Gp1tBSGTypkKbh0Jim7qD
         9jgzrsjroCYdqozxhShKgtPORGaUL62CPMg/hOkhvEfgeQkbi0IVaZ9VAoyd/bhOyILH
         1TwV31J9XimDcMeoxgxyzH899C7uKK+0diGedrHBd930L+EWTAFx7YV7xMFlINHZWgGT
         hXhw==
X-Gm-Message-State: AAQBX9d/PZIEtOelpWU+BjPuKO5n0RVkkknfZrkE8+1awtWQ2hLUTv4Q
        IKelSMCr9Obg3fD5g68F57rdew==
X-Google-Smtp-Source: AKy350bqIet+jHeVmNP8eeAveySST9WhBTl17M1vbaTgtBupFCT/VKMmZh0+xkyEsvrPTU6+2a+O3w==
X-Received: by 2002:a05:6602:160f:b0:758:6517:c621 with SMTP id x15-20020a056602160f00b007586517c621mr9503137iow.2.1681224077431;
        Tue, 11 Apr 2023 07:41:17 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a63-20020a021642000000b00406356481casm4165714jaa.122.2023.04.11.07.41.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 07:41:17 -0700 (PDT)
Message-ID: <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
Date:   Tue, 11 Apr 2023 08:41:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, Breno Leitao <leitao@debian.org>
Cc:     Willem de Bruijn <willemb@google.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, asml.silence@gmail.com,
        leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        matthieu.baerts@tessares.net, marcelo.leitner@gmail.com
References: <20230406144330.1932798-1-leitao@debian.org>
 <CA+FuTSeKpOJVqcneCoh_4x4OuK1iE0Tr6f3rSNrQiR-OUgjWow@mail.gmail.com>
 <ZC7seVq7St6UnKjl@gmail.com>
 <CA+FuTSf9LEhzjBey_Nm_-vN0ZjvtBSQkcDWS+5uBnLmr8Qh5uA@mail.gmail.com>
 <e576f6fe-d1f3-93cd-cb94-c0ae115299d8@kernel.org>
 <ZDVLyi1PahE0sfci@gmail.com>
 <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/11/23 8:36?AM, David Ahern wrote:
> On 4/11/23 6:00 AM, Breno Leitao wrote:
>> I am not sure if avoiding io_uring details in network code is possible.
>>
>> The "struct proto"->uring_cmd callback implementation (tcp_uring_cmd()
>> in the TCP case) could be somewhere else, such as in the io_uring/
>> directory, but, I think it might be cleaner if these implementations are
>> closer to function assignment (in the network subsystem).
>>
>> And this function (tcp_uring_cmd() for instance) is the one that I am
>> planning to map io_uring CMDs to ioctls. Such as SOCKET_URING_OP_SIOCINQ
>> -> SIOCINQ.
>>
>> Please let me know if you have any other idea in mind.
> 
> I am not convinced that this io_uring_cmd is needed. This is one
> in-kernel subsystem calling into another, and there are APIs for that.
> All of this set is ioctl based and as Willem noted a little refactoring
> separates the get_user/put_user out so that in-kernel can call can be
> made with existing ops.

How do you want to wire it up then? We can't use fops->unlocked_ioctl()
obviously, and we already have ->uring_cmd() for this purpose.

I do think the right thing to do is have a common helper that returns
whatever value you want (or sets it), and split the ioctl parts into a
wrapper around that that simply copies in/out as needed. Then
->uring_cmd() could call that, or you could some exported function that
does supports that.

This works for the basic cases, though I do suspect we'll want to go
down the ->uring_cmd() at some point for more advanced cases or cases
that cannot sanely be done in an ioctl fashion.

-- 
Jens Axboe

