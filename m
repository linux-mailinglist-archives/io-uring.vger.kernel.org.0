Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2346407A73
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 23:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhIKVMn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 17:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhIKVMl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 17:12:41 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185FDC061574
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 14:11:28 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id n10so7910862eda.10
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 14:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=c95lZrboz0+mI5bVFwgoSDlRH4yWpvuhOYfldiZhjTg=;
        b=RIq/fr+ABbxSq5x14EBZmG5tAdmRW3/EgdGOyf5QgKZYzhCLYO/eTe54hiFhgsDdNS
         VLf6ySz1N/gFGcFzPkbVJnBdm2Rqis27zbNkAXBqDQ7Zv3rjukLagXL2AsK6MfEA3A/t
         oOwo9//Le4wJ2Ac1yK3mPzW4Cau2/Nvx23ZTV09sJz5OKH1b8ZJDCxt+ZSRM4+Yjcc7E
         Xq4I8H0zKcj1UrC4tLma+nD9f12IaL0OfOVHd+cupjK7Y2v6OmDA3JJzmeHGBTeFCsma
         A4tVJNYX2BBvfoRQk6eVWuSs3mYTpV8FANI/+OjYNooNN461FhJy6jnvo0S/DE8UEPCD
         uClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c95lZrboz0+mI5bVFwgoSDlRH4yWpvuhOYfldiZhjTg=;
        b=q7VGTHTOyK21lLi9GmD4sInDOFH3DtUrPiyAK6Ef5tAjdJ0Sxod7yaGgeezDDHIYgk
         5QqRwDX+nIYlHlSs+j2Lq7wAZOmaIAWYPHT+6n3kJXEXLCo0FuSYS9uWqKJmXO3xqIQN
         x4SavjMkxZuPBToDh969O/mjMkAaIvqg5jqly+Rj8eNkea0+8ofYlgUTgJsZ4WIB/5VS
         d+Lbopzl1LNPvEQmWnRXVZkYyLBf7zymz8o9PU52js6O/bzIQqbgpk51B+PcTnLcfTCJ
         1b5BKKUvQ/rXBgkGzHp6JVlUHzwUC0xBQLwa+8ZKNliqW+VbjCEfdbsU2CwcPxF7QDHM
         DyrQ==
X-Gm-Message-State: AOAM533y8f99QaO9meg9bFMeCfQQSPnqe5mZ5o8OBXr/ONlWFqMzYWO3
        +tFTbSk/YLeOzZrRX14N8Dl869/n3Jw=
X-Google-Smtp-Source: ABdhPJwqyKzZg7iz8ZOuxgrlcR7WWyqOKgoPaZyT9hVliqf9sQJ1GRvP615GcnB3xz+5l4obirehPA==
X-Received: by 2002:aa7:cd13:: with SMTP id b19mr4946288edw.210.1631394686428;
        Sat, 11 Sep 2021 14:11:26 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.175])
        by smtp.gmail.com with ESMTPSA id t14sm1215192ejf.24.2021.09.11.14.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 14:11:26 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1631367587.git.asml.silence@gmail.com>
 <3a5f0436099b84f71fdc8c9bd9f21842581feaf9.1631367587.git.asml.silence@gmail.com>
 <1cc2816e-bf18-fbb9-b5ed-e8786babc4fc@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 3/3] io_uring: don't spinlock when not posting CQEs
Message-ID: <ddf1be22-4fce-8e50-851f-d898d1dcc502@gmail.com>
Date:   Sat, 11 Sep 2021 22:10:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1cc2816e-bf18-fbb9-b5ed-e8786babc4fc@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/21 9:12 PM, Hao Xu wrote:
> 在 2021/9/11 下午9:52, Pavel Begunkov 写道:
>> When no of queued for the batch completion requests need to post an CQE,
>> see IOSQE_CQE_SKIP_SUCCESS, avoid grabbing ->completion_lock and other
>> commit/post.

It does what it says -- skips CQE posting on success. On failure it'd
still generate a completion. I was thinking about IOSQE_SKIP_CQE, but
I think it may be confusing.

Any other options to make it more clear?

-- 
Pavel Begunkov
