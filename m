Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD4336945F
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 16:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhDWOIo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Apr 2021 10:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhDWOIn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Apr 2021 10:08:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4B8C061574
        for <io-uring@vger.kernel.org>; Fri, 23 Apr 2021 07:08:06 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id g9so32537943wrx.0
        for <io-uring@vger.kernel.org>; Fri, 23 Apr 2021 07:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fSB6zQz12rtFDp7ngrYkiLWnY/jTl3s/1vVAXAMJDuU=;
        b=gtUNwkzwkpvQs0cphUSpGDhDssHDls9kutqvbHg06YYvuZ/wb19KEtNnQReODShxyt
         YWofwt+0HEtl+sa5o7mU+Q5JUUivkbDwSrRl4EF9H9u2u76NedDgeEYUFjvwlVJmxe7W
         7Z9Lv07/yzAUjmZk20I8GbOrmgRG+DWeWadh9odelw5A71AYBhPtiqwAz+LCeNvJtEYj
         1F13+AV0HuAuNlpurk5wEuJ4FJ4CqMXXO1YQ0AtZSgE3mTmZR8VwiLQtRqwm0AlgnEG6
         0RhZJch6/Hq1nri9dMqlIPqeLMVOyEotcrLh084S5TKYmeTRNG4IOlefhkMgqxC0BQ7C
         8yUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fSB6zQz12rtFDp7ngrYkiLWnY/jTl3s/1vVAXAMJDuU=;
        b=b61lWUJs4IVkse9dgyreMAMZ473bMf9xhLiTJIdk8zH0XwjM2UcT2Wy2fI9/WxO9DJ
         94wu7RAZfBYQUq/izx3HSWWVz5IuXbLe2AryZ5dCHA81fCxlPCB9zjj28LxMpAka95fN
         tpv0bhGlT4QedHgd0bCmnFIY5tVKMh5i0oiY5FhGdSc+8trQvJzLe1tD4iFuursfk0kw
         VFHSQk/BZuVfdUjVlALSpsAloUu/tT0hrJXvllDxSXD/sxwU9Tu/jMGckocmrj8xlV6X
         INlIgj0y6d7f0uR/KH80h+fuhAzKJOyK8Wrwp0l/cbzQ3Pnzx0lthefXfQaF1T379oOO
         Vtmw==
X-Gm-Message-State: AOAM531nWWmoAkzD+UjQJ9Ertg5Rvy5xQgj2qb2LP1MHCVvpWM5xMizI
        n6Ffa7ixnilFfEFot0KdyR0MH1k9ZPpv2A==
X-Google-Smtp-Source: ABdhPJzRBumdDMj7u9atL2oLfz1QXeRP8dRJtwmE/ZZj6LHP4BGwnC3/P/ZrUdAK1/9qxQgg3sRRqQ==
X-Received: by 2002:a5d:4912:: with SMTP id x18mr5235681wrq.198.1619186884880;
        Fri, 23 Apr 2021 07:08:04 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id u14sm9045012wrq.65.2021.04.23.07.08.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 07:08:04 -0700 (PDT)
Subject: Re: Emulating epoll
To:     Jesse Hughes <jesse@eqalpha.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     John <john@eqalpha.com>
References: <YTBPR01MB2798B37324ED46A33DCD21B0BF489@YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM>
 <98e1c6bb-1706-e1b3-b7f1-c5418ee880be@gmail.com>
 <YTBPR01MB2798DCE96EF944CDB61D844DBF489@YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <6f67c019-782e-152c-3432-075ba923209e@gmail.com>
Date:   Fri, 23 Apr 2021 15:07:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YTBPR01MB2798DCE96EF944CDB61D844DBF489@YTBPR01MB2798.CANPRD01.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/21 6:48 PM, Jesse Hughes wrote:
> Awesome, thanks for the info and your hard work Pavel!

fwiw, there are also specialised send[msg],recv[msg] requests
supported, not only read/write, see IORING_OP_* opcodes

> 
> On 4/20/21 5:37 PM, Jesse Hughes wrote:
>> Hello,
>>
>> I want to start by saying thank-you for working on io_uring.  My experience using it thus far has been great.
>>
>> I'm working on an open-source database product (KeyDB, a multi-threaded redis fork) and we're considering rewriting our IO to use io_uring.  Our current implementation uses epoll, and processes IO on (mainly) sockets as they become ready.
> 
> Wonderful, always interesting to learn about emerging use cases
> and new apps using it.
> 
>>
>> If I'm understanding the literature correctly, to emulate epoll, we should be able to set up a uring, put in a read sqe for each incoming socket connection, then (using liburing) call io_uring_wait_sqe​.  Correct?  Is there a better way of doing that?
> 
> In general, the best way to do I/O is to issue a read/write/etc. sqe
> directly as you've mentioned. io_uring will take care of doing polling
> internally or finding a better way to execute it.
> 
> However, to simply emulate epoll IORING_OP_POLL_ADD requests can be
> used There is support for multi-shot poll requests, which Jens added
> for coming linux 5.13
> 
>>
>> Our end-goal is not to emulate epoll, but that seems like the quickest way of getting something working that we can do further experiments with.
>>
>> For reference, if anyone's interested, our source repo is at : https://github.com/EQ-Alpha/KeyDB

-- 
Pavel Begunkov
