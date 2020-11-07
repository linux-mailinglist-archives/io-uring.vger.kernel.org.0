Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9732AA7DF
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 21:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgKGUSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 15:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGUSq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 15:18:46 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95210C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 12:18:46 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id v5so4614290wmh.1
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 12:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=32Q+7Q1BMg/ogRgKA0AcQchIkQ5K8lVA16rhMAcibyU=;
        b=BDYQ0K4O7gnU1koUQxIFdvCt8KSF9ZUMB5ECu4Hj/c58dt3JpTUh2ygranBWC8/fsQ
         6RGkGirav1o87u3v2YvwW+iHxtP3bl9oxUqFq4nyEm/EoOYnXz4KYOav/YYMgHawB2JT
         2EmTIRxl87LMiBdvKtUR0YeVxL7CIDIHuCKNnn23YqKF36J7HghuC50V9+D63NkyipPy
         HBSxdYg8h8Z21wVViHpuWoxLybL3LxeR0Cp5xJKNo4KCzjIJvW4/9ukFcvN/UJQH/g/N
         bXs/FUELp+PSltZwlVP1EfQ83RZX35bl9lp8Ugu7XYfkjYuDNXYez8cX5b4w7bo0Qdia
         9//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=32Q+7Q1BMg/ogRgKA0AcQchIkQ5K8lVA16rhMAcibyU=;
        b=oBtclyXeDmKebm6KUTv2QuFX/1nl7WtmaXWSeAFwLwUvAxJ9QguoE6ylDbB+klsP0S
         3SRtMdnYV10vzYfDNXNCGvKYHibUGfLk3gs/BwRW/s0L3RNsaOR0f+3Rw/jZlu4rym0w
         jf2dDTN/Oe2Dy4cznBoN3p9rRKs3vRNbsD9xJJrIWPSUyb3Vo7WM6NNlJkdWPvse6Bcz
         FQfF5Dfd0FNfIwC8HBivtqeyXWYOhpk2CL3hwmy7eDYbgVypdWzRb9qnoFdUYo5ORmrL
         7719x7RQKr2mV6PR1pr/WyEHuhfyKzcmM1kZgdhepe7Wc/5fmkAQ1shoWOZkHe/6mbVD
         tMrw==
X-Gm-Message-State: AOAM531lQODFc2XW2Cxud4myl8r3ReSjD3F9chX6yVucEDr9CmLVoQ7u
        4mPIMkR6t1hYS3TevAMFGNlXj8mK1xwD5Q==
X-Google-Smtp-Source: ABdhPJxj7el6dmr97/fMWS+hg+EeZ6+rVbWym7GJBwrJp4IQPwO3SM3QbOUN10cNnHVDuwUfQmv2CA==
X-Received: by 2002:a1c:80d3:: with SMTP id b202mr6397384wmd.139.1604780325066;
        Sat, 07 Nov 2020 12:18:45 -0800 (PST)
Received: from [192.168.1.84] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id v12sm7861077wro.72.2020.11.07.12.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 12:18:44 -0800 (PST)
Subject: Re: allowing msg_name and msg_control
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring@vger.kernel.org
References: <CAM1kxwhuVfkofDXKaeW4J6Khy2Jp3UcXALQ4SdP9Okk_w7zjNg@mail.gmail.com>
 <7da29ea8-47b6-a122-c16e-83a052e4d0d9@gmail.com>
 <CAM1kxwhUve61-6L=Vb40xXWip8m578ZYO-Mpb6Ys9x5aiK6LPg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <903acded-1136-7867-f808-3361aa946a5e@gmail.com>
Date:   Sat, 7 Nov 2020 20:15:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwhUve61-6L=Vb40xXWip8m578ZYO-Mpb6Ys9x5aiK6LPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/11/2020 17:12, Victor Stewart wrote:
>> Don't know these you listed, may read about them later, but wouldn't [1]
>> be enough? I was told it's queued up.
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/net/socket.c?id=583bbf0624dfd8fc45f1049be1d4980be59451ff
>>
> 
> Hadn't seen [1], but yes as long as the same were also implemented for
> __sys_sendmsg_sock(). Queued up for.. 5.11?

Seems for some reason it's only for recv.
It's for 5.10.

> 
> UDP_SEGMENT allows you to sendmsg a UDP message payload up to ~64K
> (Max IP Packet size - IPv4(6) header size - UDP header size).. in
> order to obey the existing network stack expectations/limitations).
> That payload is actually a sequence of DPLPMTUD sized packets (because
> MTU size is restricted by / variable per path to each client). That
> DPLPMTUD size is provided by the UDP_SEGMENT value, with the last
> packet allowed to be a smaller size.
> 
> So you can send ~40 UDP messages but only pay the cost of network
> stack traversal once. Then the segmentation occurs in the NIC (or in
> the kernel with the NIC has no UDP GSO support, but most all do).
> 
> There's also a pacing patch in the works for UDP GSO sends:
> https://lwn.net/Articles/822726/
> 
> Then UDP_GRO is the exact inverse, so when you recvmsg() you receive a
> giant payload with the individual packet size notified via the UDP_GRO
> value, then self segment.
> 
> These mimic the same optimizations available without configuration for
> TCP streams.
> 
> Willem discusses all in the below paper (and there's a talk on youtube).
> http://vger.kernel.org/lpc_net2018_talks/willemdebruijn-lpc2018-udpgso-paper-DRAFT-1.pdf
> 
> oh and sorry the title of this should have been sans msg_name.
> 
>>>
>>> GSO and GRO are super important for QUIC servers... essentially
>>> bringing a 3-4x performance improvement that brings them in line with
>>> TCP efficiency.
>>>
>>> Would also allow the usage of...
>>>
>>> 3) MSG_ZEROCOPY (to receive the sock_extended_err from recvmsg)
>>>
>>> it's only a single digit % performance gain for large sends (but a
>>> minor crutch until we get registered buffer sendmsg / recvmsg, which I
>>> plan on implementing).
> 
> and i just began work on fixed versions of sendmsg / recvmsg. So i'll
> distribute that patch for initial review probably this week. Should be
> fairly trivial given the work exists for read/write.
> 
>>>
>>> So if there's an agreed upon plan on action I can take charge of all
>>> the work and get this done ASAP.
>>>
>>> #Victor
>>>
>>
>> --
>> Pavel Begunkov

-- 
Pavel Begunkov
