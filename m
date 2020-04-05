Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9DF19EE63
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2020 00:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgDEWZ1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Apr 2020 18:25:27 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32889 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbgDEWZ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Apr 2020 18:25:27 -0400
Received: by mail-pf1-f194.google.com with SMTP id c138so6625192pfc.0
        for <io-uring@vger.kernel.org>; Sun, 05 Apr 2020 15:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cFxnzicbTNriCHPsByY/bK8OrcBXIbAjDImLG9uKDHI=;
        b=0pe+lrybOo2YgT9yCQps0gWWq3ki7vxmyt08By4lugK5SHWVsNdFFpSeiHvBjxbSt3
         HSL+dRjJa91sswyq/tiH9GdEtbmss6uF+kvAcKXfDqBxWD3alZ9h304v5mACEJX76OWM
         FioQ0Q7ZsUSQyqlwXeHh7N8zNNwik3Dfb+c5jvtbPeYhrtEMDQe1voy4a089bP7rR6tc
         1LVWBhRsN/xWuz3RBv50y12nzdzzvsoKZ4cVgbZkgbZNMCUsXBabQINt+fmnBWLZ8XGy
         WwySddGN41jMoooef/49pREiEI9jtz1Ehw2KOgcRRt7A2IoGPFaxRokASj0Yd36FzPEN
         YVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cFxnzicbTNriCHPsByY/bK8OrcBXIbAjDImLG9uKDHI=;
        b=tpTsTl/fkt/K/5H2ZnQ3L6PH1Ij0znCmPc9ouARkPUkp7CRISvEfhcmZp/fkTfw8wD
         kRVm7knwE07xsGnimM2XtQgfl2BYa68J67/QZoaoPb274KDT/KPMq2M0bgAE5tv3PC8K
         gZ6bpV40iskFFQXHoCiNVx+0QcOsJOZTgCgRbT9jiXHWMsci7Wv9/Ko9FqslxWxQ2G1R
         BXzwTkv12GI9rq6JesmXQPE1TZBflPaE7wy1hPsV8ithGidG7Iy4gpEtnkRBB0I+cYL6
         vWUqec0nTr6bccZYa9vkpa+5KEo9Hp+9HIsMm7VhN25NAxnYJCY47bAiv3QE4kJsSBV/
         q/qQ==
X-Gm-Message-State: AGi0Pua18g8BjNDSPLvF0va9pAqftMc2nWUg/BpQ4YNJOrfgxcX4uxM5
        EcV5JzH2PivRi/a78wIvA+4GOw==
X-Google-Smtp-Source: APiQypIow71tF5ScnG1EOIJX/No5w6Re3/mkxeNwSVY2lMJtseTyTGqKyq+NGrokxUi/qfabcRtOOw==
X-Received: by 2002:aa7:9d0a:: with SMTP id k10mr19320976pfp.266.1586125525864;
        Sun, 05 Apr 2020 15:25:25 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:5d19:ea24:5c10:884d? ([2605:e000:100e:8c61:5d19:ea24:5c10:884d])
        by smtp.gmail.com with ESMTPSA id s3sm8253831pjd.21.2020.04.05.15.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Apr 2020 15:25:25 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix ctx refcounting in io_submit_sqes()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <8b53ce4539784423b493fdbfae9bd4c720b24d2a.1586120916.git.asml.silence@gmail.com>
 <331eb009-a8c3-98c7-4cec-d91a821f22be@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3d0b7db2-59ae-b33c-694e-87d3d659c25e@kernel.dk>
Date:   Sun, 5 Apr 2020 15:25:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <331eb009-a8c3-98c7-4cec-d91a821f22be@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/5/20 3:13 PM, Pavel Begunkov wrote:
> On 06/04/2020 00:08, Pavel Begunkov wrote:
>> If io_get_req() fails, it drops a ref. Then, awhile keeping @submitted
>> unmodified, io_submit_sqes() breaks the loop and puts @nr - @submitted
>> refs. For each submitted req a ref is dropped in io_put_req() and
>> friends. So, for @nr taken refs there will be
>> (@nr - @submitted + @submitted + 1) dropped.
>>
>> Remove ctx refcounting from io_get_req(), that at the same time makes
>> it clearer.
> 
> It seems, nobody hit OOM, so it stayed unnoticed. And neither did I.
> It could be a good idea to do fault-injection for testing.

Actually think we just hit this, was testing with memcached (as per fixes
posted recently), and a bug on the user side ended up with 196G of slab
and running into OOM off request allocation.

But yes, would be nice to have specific fault injection testing to
avoid finding these in prod testing.

-- 
Jens Axboe

