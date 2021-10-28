Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B282643E834
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 20:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhJ1SVz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 14:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhJ1SVu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 14:21:50 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB92C061570
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 11:19:22 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id r194so9338172iod.7
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 11:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dBEp2bY5XgbQx+AlPLriHdh7rYkxDGtgG0m0TlyKu1A=;
        b=7ZjCk8hPK1+yi2Ct3lbNf3uPqmpiaYLAAff15RR2gxv+pmTrS/mYdwKZbL/49UWahv
         fC4yBeBVXdARLaiQy1pSTTU1tXoYdzxYVMTH4q01qxaKWsniSpWyosnw++4byf4hf7V1
         10SMafIsaHtBBpJ4IhZbzebFKzTdyrRMaA8APPZfSS+rFW4uKTmWdY7H9v23xVe51Vo5
         k8e2UsRPYeDwF6Ev0hAFKmjzGL1bJ0bkCrWKQUukPwv6cpTH2J2HdAi7NcLnXSC9knN3
         /e5vs8cu5j1SleRcBNnV24pE3VByA9IWbU0xLxWS16AnEjoJCY+yvBm+fPyOaoECkc4t
         4o3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dBEp2bY5XgbQx+AlPLriHdh7rYkxDGtgG0m0TlyKu1A=;
        b=qf/fU7wTwdtec1vt2LY28lTf1qGg/wfyXOXez+jRdiG6V69oo2inyj2DNmFDDD7Po3
         O98XuDjosXC4VhIde5yHUIZz1ICfgCbKC624V+gueX0j/FEoWmI+rAxnhGcIpVRCZHHQ
         sjnwZ3mYrmqQoRDISi4zHvklcSjJtlQpLZe3oCnfoZWX+PrfuSMof+QF9wNGs77Lpp2Q
         Ukakl5GtB1BaOIGgZCx1Hu5+5sZkFt1Buht9NSQvyTDefKIIjdxqIi90xWQwFrSNPv/y
         d1+O2qmssvC6iCMLkAHHbKorwElqpf82M6j2nDR574CwbNFKNjQJOe108UfNLBwP+HeI
         u18A==
X-Gm-Message-State: AOAM531rEZO+jtHYjfrHviqeQmDiuF1wT8wAocbJRl5D+2LBtz3TgvOi
        YbPCB0yaz8otw18FKIMboBaIWEymDhtJYw==
X-Google-Smtp-Source: ABdhPJw8GG8od0kOp4pXJQkLf7v2cAb0xFRRqPNgOSd2dhbOoei9VYzBML8gz9WyhX263/uPMexLtg==
X-Received: by 2002:a05:6638:dc6:: with SMTP id m6mr4454308jaj.48.1635445162153;
        Thu, 28 Oct 2021 11:19:22 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v4sm1884099ilq.57.2021.10.28.11.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 11:19:21 -0700 (PDT)
Subject: Re: [PATCH v3 0/3] improvements for multi-shot poll requests
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <924b097b-144a-d4ff-0b46-0dded1daa824@kernel.dk>
Date:   Thu, 28 Oct 2021 12:19:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/24/21 11:38 PM, Xiaoguang Wang wrote:
> Echo_server codes can be clone from:
> https://codeup.openanolis.cn/codeup/storage/io_uring-echo-server.git
> branch is xiaoguangwang/io_uring_multishot. There is a simple HOWTO
> in this repository.
> 
> Usage:
> In server: port 10016, 1000 connections, packet size 16 bytes, and
> enable fixed files.
>   taskset -c 10 io_uring_echo_server_multi_shot  -f -p 10016 -n 1000 -l 16
> 
> In client:
>   taskset -c 13,14,15,16 ./echo -addr 11.238.147.21:10016 -n 1000 -size 16
> 
> Before this patchset, the tps is like below:
> 1:15:53 req: 1430425, req/s: 286084.693
> 11:15:58 req: 1426021, req/s: 285204.079
> 11:16:03 req: 1416761, req/s: 283352.146
> 11:16:08 req: 1417969, req/s: 283165.637
> 11:16:13 req: 1424591, req/s: 285349.915
> 11:16:18 req: 1418706, req/s: 283738.725
> 11:16:23 req: 1411988, req/s: 282399.052
> 11:16:28 req: 1419097, req/s: 283820.477
> 11:16:33 req: 1417816, req/s: 283563.262
> 11:16:38 req: 1422461, req/s: 284491.702
> 11:16:43 req: 1418176, req/s: 283635.327
> 11:16:48 req: 1414525, req/s: 282905.276
> 11:16:53 req: 1415624, req/s: 283124.140
> 11:16:58 req: 1426435, req/s: 284970.486
> 
> with this patchset:
> 2021/09/24 11:10:01 start to do client
> 11:10:06 req: 1444979, req/s: 288995.300
> 11:10:11 req: 1442559, req/s: 288511.689
> 11:10:16 req: 1427253, req/s: 285450.390
> 11:10:21 req: 1445236, req/s: 288349.853
> 11:10:26 req: 1423949, req/s: 285480.941
> 11:10:31 req: 1445304, req/s: 289060.815
> 11:10:36 req: 1441036, req/s: 288207.119
> 11:10:41 req: 1441117, req/s: 288220.695
> 11:10:46 req: 1441451, req/s: 288292.731
> 11:10:51 req: 1438801, req/s: 287759.157
> 11:10:56 req: 1433227, req/s: 286646.338
> 11:11:01 req: 1438307, req/s: 287661.577> 
> about 1.3% tps improvements.

In the spirit of moving this one along, I've applied this series. Still a few
things we can do on top, but I don't think that should hold it back. If you
planned on sending an update to inline that check again just do it on top
of the current tree.

-- 
Jens Axboe

