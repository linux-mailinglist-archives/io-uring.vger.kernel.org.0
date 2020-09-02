Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AB925AED3
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 17:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIBP3D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 11:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbgIBP2m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 11:28:42 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2EFC061244
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 08:28:41 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o21so5014925wmc.0
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 08:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P3zUSIr0wfQXRIwehNFzK7fVC+di5Dg0yvMMMtaHIWM=;
        b=FMMUFUi0i2ZMk2g6EK6XqEjQQNX5RBLrrKtyJP1eItjdhAkzBzVj4grenmRIVDghH+
         gY7+uiLSiJtOaa2SDY6XAkiGJQV6uCk+yvyz4YvJwPkCoBMm5BSOBpu//WkA4NnyyStv
         4Ivc5R0f2Pb8v8Bn1emAxWFIpO6VLivenkCwVetPz5Wfzqp4r/FgTLeyJhLiqyBes8qG
         wbyvvhW3l2RfFz2NfnamnOshbTSw4NhPPz93hAG9/IpgDYS2rqXM0ap8SYL+MCAqLNt+
         HpuqneksuFPLim4ZKWvyhcg36bAyR3Z8k4jVog8uyPMCkk+GxWQLntPfxFgZlZ168do4
         XxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=P3zUSIr0wfQXRIwehNFzK7fVC+di5Dg0yvMMMtaHIWM=;
        b=lvABjguCjJAkiJ8e350Tz1AI6JGf5VvqADQiysSDW1PFD7SAsV3JvKbhEfIy4GbznZ
         5tXIswWae/mmmUTwJXhi99YobozML9LGo4uBDfoFaijIOX1m14vxwUa+aPnV3njAZIup
         ytuRYFMtn9qMdy7zqUmABu+V6WXnnTpLtkLhmc9o8deDghacTJReyc0LuaOLvO6/pFRl
         pd2titi92bmgrdW3GVZ/VeCAlINf+LdEu+wi5MzHGIwxoM5DQb1Xb5Hm6gY8dxJDFv5a
         QRSooXxBKrmHFz1PoxkMoA8AexMMYgKC08Jvge4few5tNQugCV3krXn1wfa+8ueG9bpt
         B1oA==
X-Gm-Message-State: AOAM532SGXGtIzs+X7itVgcSVwP8J1p1ghmrPfi0CxW0GN/QRKo6byjO
        H1xYFj2zJv47zTGToXfAp6Q=
X-Google-Smtp-Source: ABdhPJwUfXtR4RM0eLqZEy86NiXPKjQZuNUiHjUrq/JqFYh1t24kdPikwDni1pQuybbBzPh5AYt4Kg==
X-Received: by 2002:a1c:610b:: with SMTP id v11mr1225712wmb.181.1599060520163;
        Wed, 02 Sep 2020 08:28:40 -0700 (PDT)
Received: from [192.168.43.65] ([5.100.192.56])
        by smtp.gmail.com with ESMTPSA id 21sm16389wrc.55.2020.09.02.08.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 08:28:39 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring@vger.kernel.org
Cc:     Josef <josef.grieb@gmail.com>
References: <28EF4A51-2B6D-4857-A9E8-2E28E530EFA6@googlemail.com>
 <05c1b12c-5fb8-c7f5-c678-65249da5a6b1@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: IORING_OP_READ and O_NONBLOCK behaviour
Message-ID: <72c31af6-2c85-4105-65fb-87a860a65a78@gmail.com>
Date:   Wed, 2 Sep 2020 18:26:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <05c1b12c-5fb8-c7f5-c678-65249da5a6b1@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/09/2020 17:45, Jens Axboe wrote:
> On 9/2/20 4:09 AM, Norman Maurer wrote:
>> Hi there,
>>
>> We are currently working on integrating io_uring into netty and found
>> some “suprising” behaviour which seems like a bug to me.
>>
>> When a socket is marked as non blocking (accepted with O_NONBLOCK flag
>> set) and there is no data to be read IORING_OP_READ should complete
>> directly with EAGAIN or EWOULDBLOCK. This is not the case and it
>> basically blocks forever until there is some data to read. Is this
>> expected ?
>>
>> This seems to be somehow related to a bug that was fixed for
>> IO_URING_ACCEPT with non blocking sockets:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.8&id=e697deed834de15d2322d0619d51893022c90ea2
> 
> I agree with you that this is a bug, in general it's useful (and
> expected) that we'd return -EAGAIN for that case. I'll take a look.
> 

That's I mentioned that doing retries for nonblock requests in
io_wq_submit_work() doesn't look consistent. I think killing it
off may help.

-- 
Pavel Begunkov
