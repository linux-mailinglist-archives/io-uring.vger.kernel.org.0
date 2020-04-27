Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3B61BADE2
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 21:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgD0T3e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 15:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgD0T3d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 15:29:33 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998A8C03C1A7
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 12:29:33 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id f7so9462219pfa.9
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 12:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cTBwovR0ZFaUHqJn7Qg2v5buHZ/B0I7wofADz36XXDc=;
        b=CzKYcd2wjfDPZLNTJdfR4aPlHAKl+2etaJDxRwXldnTP01Hpzo1u3UjTno3MFS9nJn
         Pd3cmrZWOSyyJTSmx8Ly+XYTT5wwZpqW2XGm50nh22bbw2mD6e160BdGDarbQodaSTzj
         veWd4zDSrhpPzgbih7Qw9+rljRozAWK0IGzdzYwb8hz6h84+lhq0j2exHC8T+1lAm+6R
         KGUzJ8dE7+uscTsjDlcdjOJIK3PNScz9GgeVfP9WTUtvt+tOtVFv+UmIR3gB7djdJORO
         BT/vKwak3EW3cp/cHsuSOyX4yH44ZLWNO8ygDbGziXmjEiEPVaSeQRxNKBGmI/CQnkMx
         yidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cTBwovR0ZFaUHqJn7Qg2v5buHZ/B0I7wofADz36XXDc=;
        b=V7GV0Z0Y8bjUHhuCGSRja8NtDoP82P3yaaDpk1XsEiWRLR+w0Bd5U6tXbuKjCOlERd
         HYpSQWXECDOjVk9/oZTtEsM1tPVTwK1m+GV2MVC2fxheHuqBn8V7QGc7O92/W5qQS4Pd
         2EjtiD/o8DmVS1blnSe1XTyAAheC8H0KUtV279LW9lm/98v6AiU53kVz1vFOHRnRZ2j4
         zDYZ7GZjJjIjQzqpSAwc1V2Ib02pVh5Ui+iW9PmV+bw2y6Pu42aEFcTPHEaXLChzQ+Ww
         /J6CPWXBV/6FYxA0BuOUsGRQ0z3xZZ0rHIaqj4fhxv0pZ4nfUJIhWRzb1W98r8PLivWn
         Sz7Q==
X-Gm-Message-State: AGi0PuY46PlcR80dojrGS67n/yB9J7xGfGrWJBEpkZkZpK3kN2T/astQ
        nbf83E8K7DHJMq1KSBIJHxUNyM2qgc1Vsg==
X-Google-Smtp-Source: APiQypKLNMUybciXFxjnHa2jRTMPZmtO/uxJFTFuly2Au6+LQranWLB64MlFfU5vI/Aezo2tjg8+MQ==
X-Received: by 2002:a63:c149:: with SMTP id p9mr23769611pgi.389.1588015772727;
        Mon, 27 Apr 2020 12:29:32 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id b1sm13018257pfa.202.2020.04.27.12.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 12:29:32 -0700 (PDT)
Subject: Re: io_uring, IORING_OP_RECVMSG and ancillary data
To:     Jann Horn <jannh@google.com>
Cc:     Andreas Smas <andreas@lonelycoder.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <CAObFT-S27KXFGomqPZdXA8oJDe6QxmoT=T6CBgD9R9UHNmakUQ@mail.gmail.com>
 <f75d30ff-53ec-c3a1-19b2-956735d44088@kernel.dk>
 <CAG48ez32nkvLsWStjenGmZdLaSPKWEcSccPKqgPtJwme8ZxxuQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bd37ec95-2b0b-40fc-8c86-43805e2990aa@kernel.dk>
Date:   Mon, 27 Apr 2020 13:29:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez32nkvLsWStjenGmZdLaSPKWEcSccPKqgPtJwme8ZxxuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/20 1:20 PM, Jann Horn wrote:
> On Sat, Apr 25, 2020 at 10:23 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 4/25/20 11:29 AM, Andreas Smas wrote:
>>> Hi,
>>>
>>> Tried to use io_uring with OP_RECVMSG with ancillary buffers (for my
>>> particular use case I'm using SO_TIMESTAMP for incoming UDP packets).
>>>
>>> These submissions fail with EINVAL due to the check in __sys_recvmsg_sock().
>>>
>>> The following hack fixes the problem for me and I get valid timestamps
>>> back. Not suggesting this is the real fix as I'm not sure what the
>>> implications of this is.
>>>
>>> Any insight into this would be much appreciated.
>>
>> It was originally disabled because of a security issue, but I do think
>> it's safe to enable again.
>>
>> Adding the io-uring list and Jann as well, leaving patch intact below.
>>
>>> diff --git a/net/socket.c b/net/socket.c
>>> index 2dd739fba866..689f41f4156e 100644
>>> --- a/net/socket.c
>>> +++ b/net/socket.c
>>> @@ -2637,10 +2637,6 @@ long __sys_recvmsg_sock(struct socket *sock,
>>> struct msghdr *msg,
>>>                         struct user_msghdr __user *umsg,
>>>                         struct sockaddr __user *uaddr, unsigned int flags)
>>>  {
>>> -       /* disallow ancillary data requests from this path */
>>> -       if (msg->msg_control || msg->msg_controllen)
>>> -               return -EINVAL;
>>> -
>>>         return ____sys_recvmsg(sock, msg, umsg, uaddr, flags, 0);
>>>  }
> 
> I think that's hard to get right. In particular, unix domain sockets
> can currently pass file descriptors in control data - so you'd need to
> set the file_table flag for recvmsg and sendmsg. And I'm not sure
> whether, to make this robust, there should be a whitelist of types of
> control messages that are permitted to be used with io_uring, or
> something like that...
> 
> I think of ancillary buffers as being kind of like ioctl handlers in
> this regard.

Good point. I'll send out something that hopefully will be enough to
be useful, whole not allowing anything randomly.

-- 
Jens Axboe

