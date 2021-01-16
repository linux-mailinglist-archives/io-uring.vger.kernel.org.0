Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142952F8ECD
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 20:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbhAPTCj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 14:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbhAPTCi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 14:02:38 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3E1C061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 11:01:58 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u11so2112959plg.13
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 11:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=64L94+9s7oVCOzcVgijK0NOtkTNLhEaHQXusYg1drSU=;
        b=OnACbrX5tpJuYDPxnUzVjQQf6/ok7Ir+aIpxTqhB+Fsr7bdBj3UI6DsD4yHuZFitk4
         TF44KwA1EtolFfn4D4I34dZ/oCEmsN8/F4so0EU2k54jbLGGS1lfPyRZwndPGAplmjDI
         fOpEdDTpTZY5ohYovK8knZKl54Bn4qxRzCabd62RWca0rSdWKvMsZepRn5TWSwfmQIum
         X2Jx+RqAYULiB27Wyvbs8qwI8u9yNaCb4fxDES7d/l5UsJfj3TuHpnlAvjvI+ph0v41V
         Ng40onisZJvAWci1oClZMYT82yhMRtNctYB/Re8KK5pQMI823JBXp3JUXpXEEbHEokcp
         q/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=64L94+9s7oVCOzcVgijK0NOtkTNLhEaHQXusYg1drSU=;
        b=Yl3+G2FGkN4TI/phY5bfs2Q8Jz51gtYHcVXMHZ/S62WowYVD8Xkb3IOIWoORCd6FGi
         iIA7AzyLnuBZV/oxEUHQWXz9lBNUkF9zQoRFd32Pf7V/kqqWDd8hRoBCOGU8w8t/qruZ
         bhlzqGNIhS69MuyZO0IJ6L16hXGbD+1YBJEATqdtc4vQYbLrQSlPUOJbJ/P/mxbPBPTc
         d1RsgUIrgStT99PE+JI/Oa5d7/b3jyHxGaVCQBkFP/7/LxlGiqOvm4Ayri5vfc3D35BJ
         gCZ4nri60tQN3q2M2hbtk2PtXEUoauSqfUVUHbWhC6aSdeTcJdtWYNDSOIKYMllg9nvG
         98Dg==
X-Gm-Message-State: AOAM531BDwrpmmW9OwvMOfwrKVgCpCJwR/ADkYhUvZNYooTRqaMNe2Tf
        z77dCSA8ChQiOwQCjf3wimFVYA==
X-Google-Smtp-Source: ABdhPJxCdcJsZ+SCmwGzpJGXQ/MgC9l7T4d+9KFdgKyAJ97pFY5pehBL1EF938tb7DaRg9Y+MqT/0A==
X-Received: by 2002:a17:902:b18c:b029:da:fc41:baf8 with SMTP id s12-20020a170902b18cb02900dafc41baf8mr18574994plr.58.1610823718039;
        Sat, 16 Jan 2021 11:01:58 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id gz5sm11424912pjb.15.2021.01.16.11.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 11:01:57 -0800 (PST)
Subject: Re: [PATCH 0/2] syzbot warning reports
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>
References: <cover.1610774936.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fc01d795-af6a-e5b8-194a-c9cff08b8d17@kernel.dk>
Date:   Sat, 16 Jan 2021 12:01:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1610774936.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/15/21 10:32 PM, Pavel Begunkov wrote:
> Two more false positive WARN_ON_ONCE() because of sqo_dead. For 2/2
> issue, there is an easy test to trigger, so I assume it's a false
> positive, but let's see if syzbot can hit it somehow else.

I'll apply these for now, also makes it easier to point syzbot at
a branch.

-- 
Jens Axboe

