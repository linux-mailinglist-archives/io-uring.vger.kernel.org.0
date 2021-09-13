Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56539408682
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 10:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbhIMIcD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 04:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237811AbhIMIcC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 04:32:02 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059C2C061760;
        Mon, 13 Sep 2021 01:30:47 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id t19so19197086ejr.8;
        Mon, 13 Sep 2021 01:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S04yNFgZ4hxBAhctv/zD4ywMbFHZufB8ODvyMoyYBUs=;
        b=SSfu2QX7uPQFkLNNvYenowTcZkH/mds0SwrzE25hxOI6RojTHP0gx3m/GVFRvGn/cx
         a2yA4FoBB6tnGr1r9LbSSsEw1sbThjaQb1qWDlSc8pzFLd0wwgip3Mo2QS5orTdo+UD/
         H1IEZ6qFBNRbuI4+UW/ByscyoBNB8lHEFdJhfeL6fbzfhT0ftdYMv0HObUwTy+ZXDp+g
         xl4Mh9F/w3BU1M5syOPgl/nt87pjnsnfM3jHgBntJXq9cQSU8UnPOILpMuhhC52B1Sfx
         E2MdtCBiToOFF2PigOH8xZZcWahokDJI/5TNMSFZyNFQOUwc+LnIpmojzl8xZbXIhfua
         ipcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S04yNFgZ4hxBAhctv/zD4ywMbFHZufB8ODvyMoyYBUs=;
        b=L4m9Iiuz1o7tv7ykKY86pccVypF97zWEDrYMf8xls+sdnfSnxf4tZq8sO1JEgfOK96
         TJYcaVsNYjeS8zB0ESbgnvH6EJW2wbIT6n8RMTn3UwxWTu+EjbtCMvwKFtNulkcBckdB
         tDX7j3gpKVsZ/HKzpPdliYU+J57LxPaXdtMEHtrSjs5DrMWxXEB9DHJJKJZXhqLWbIpr
         K/ZM9ETYimTHkEMi9/O9Ib4sHb6VfBbO+dlPWIzRQyBSC5Dwq5lpOs3KIFhDJUmiq09A
         qqjJM+xRJOPhbtv3hdFPQL4dio3gOxVwPAf+6fWcAl4aA71gGqOp0OhPeL02sA2Tv3nH
         WugA==
X-Gm-Message-State: AOAM5303ivpHkvoqmYouloMeiC0p19nC0dMl7ovBsFZLV7ykj6lkkcod
        xUSvCBciOVhFbjkjPlBM1D8wbtsg5dc=
X-Google-Smtp-Source: ABdhPJxy609z7lNvG5cLClXJDmiweRbYipKNo16255Iydj1lvDaG4H74OPpBd38bmx4CLAwvvvSUJw==
X-Received: by 2002:a17:906:1d41:: with SMTP id o1mr11671160ejh.232.1631521845117;
        Mon, 13 Sep 2021 01:30:45 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id t14sm3115615ejf.24.2021.09.13.01.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 01:30:44 -0700 (PDT)
Subject: Re: INFO: task hung in io_uring_cancel_generic
To:     Hao Sun <sunhao.th@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CACkBjsbs2tahJMC_TBZhQUBQiFYhLo-CW+kyzNxyUqgs5NCaXA@mail.gmail.com>
 <df072429-3f45-4d9d-c81d-73174aaf2e7d@kernel.dk>
 <e5ac817b-bc96-bea6-aadb-89d3c201446d@gmail.com>
 <CACkBjsZLyNbMwyoZc8T9ggq+R6-0aBFPCRB54jzAOF8f2QCH0Q@mail.gmail.com>
 <CACkBjsaGTkxsrBW+HNsgR0Pj7kbbrK-F5E4hp3CJJjYf3ASimQ@mail.gmail.com>
 <ce4db530-3e7c-1a90-f271-42d471b098ed@gmail.com>
 <CACkBjsYvCPQ2PpryOT5rHNTg5AuFpzOYip4UNjh40HwW2+XbsA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <7faa04f8-cd98-7d8a-2e54-e84e1fe742f7@gmail.com>
Date:   Mon, 13 Sep 2021 09:30:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CACkBjsYvCPQ2PpryOT5rHNTg5AuFpzOYip4UNjh40HwW2+XbsA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/21 3:26 AM, Hao Sun wrote:
> Hi
> 
> Healer found a C reproducer for this crash ("INFO: task hung in
> io_ring_exit_work").
> 
> HEAD commit: 4b93c544e90e-thunderbolt: test: split up test cases
> git tree: upstream
> console output:
> https://drive.google.com/file/d/1NswMU2yMRTc8-EqbZcVvcJejV92cuZIk/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1c0u2EeRDhRO-ZCxr9MP2VvAtJd6kfg-p/view?usp=sharing
> C reproducer: https://drive.google.com/file/d/170wk5_T8mYDaAtDcrdVi2UU9_dW1894s/view?usp=sharing
> Syzlang reproducer:
> https://drive.google.com/file/d/1eo-jAS9lncm4i-1kaCBkexrjpQHXboBq/view?usp=sharing
> 
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Hao Sun <sunhao.th@gmail.com>

I don't see the repro using io_uring at all. Can it be because of
the delay before the warning shows itself? 120 secs, this appeared
after 143.

[...]

-- 
Pavel Begunkov
