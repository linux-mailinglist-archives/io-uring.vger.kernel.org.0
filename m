Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF7325E88E
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 17:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgIEPCR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 11:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgIEPCP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 11:02:15 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6794C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 08:02:14 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 5so5846415pgl.4
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 08:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fHcPz13mY/Knfe5e3MLUo8yrh67NPuJtvf2Ig/oW8ls=;
        b=1Xy6i9sViU525yvoSKIGPku6NrHdUsRUJD0Rf+AqfqxS2CTbWLZzJ++yhXlx4vg1/D
         kFCV1gLMzSua8Xj0vSiLcFYZcZ0ExlNeyRpvkdXYDtfrliPGsx3Cz8zpTFh3BiVWw8b0
         Yz5qlzlJ7JnOYbZVTe69ky+Vl4rVUepRAz9ZeOosz+u/6QGWEgxQOk9fpoT+hhURjeJ7
         Z/Zw+Bjwv0Yt9phuxUgMPb99XC0y4Gw2Ppk6QjmHEBn05JvzKH+PjX1WDKBsTu3SK3sM
         UF7SQMKerJJtPhJNGK4ZUEsnH+WOfK5CX5KzN8p7HU2msTQCXo4vx9SMeyUUo/xk8QCN
         CxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fHcPz13mY/Knfe5e3MLUo8yrh67NPuJtvf2Ig/oW8ls=;
        b=ljRGabZSY2NF4iA/Lzl+PkyCf/PZGwOcmgA3sAuXCU1ok4ArHD/MpWDHf0Xq32/DMS
         m2gz5EoVb9Txdgml+A1oVJBgV31T1EL7KpQt01ThjTxej91ZYIUoNNgPhfzZw9sLO68Z
         iz9JbBooAx3p8ehP185GBPhKCP318hbRhuYQ8Te+JT+SMlPlOfd4l4JFfR+wk/At7iO9
         DYgPeKP4C8ayW9fe0MRw2YOcHCXAYqNy4+M6K+P9BnZ1edMNS1b50H1pfsm/NW4PDIqT
         Kjp7WA7uGs3zTgUoAD3FrXqzxXXvAV6Xnp7Zdg3E5eIRV7vg9PuzG/b+MrGbiiN4Rr+4
         igcg==
X-Gm-Message-State: AOAM532MAtuJScHDQvxU4I+eIXD/NlA2NXWRCjad8+BbfzvFHP4DMj1b
        dnDv/k1KxiuBsjq0cPQgedU6dJTPNB2iX3Ui
X-Google-Smtp-Source: ABdhPJzTnL/rtL5OjlvIPplLm5DZiP18YP+9FFiRA5P+SgjXiTYoC4qZoYgnj+Wtx34yE0PSFI89kA==
X-Received: by 2002:a63:5d08:: with SMTP id r8mr10790195pgb.174.1599318130032;
        Sat, 05 Sep 2020 08:02:10 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o6sm7814139pju.25.2020.09.05.08.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 08:02:08 -0700 (PDT)
Subject: Re: WRITEV with IOSQE_ASYNC broken?
To:     Norman Maurer <norman.maurer@googlemail.com>,
        Nick Hill <nick@nickhill.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <382946a1d3513fbb1354c8e2c875e036@nickhill.org>
 <bfd153eb-0ab9-5864-ca5d-1bc8298f7a21@kernel.dk>
 <fe3784cf-3389-6096-9dfd-f3aa8cd3a769@kernel.dk>
 <d8404079-fe7e-3f42-4460-22328b12b0fa@kernel.dk>
 <484b5876-a2e6-3e02-a566-10c5a02241e8@gmail.com>
 <a7285fbdffcf587a3fc4eb8e75f57da3@nickhill.org>
 <1BD1ED7B-92E9-4EA9-9002-8F4ECDC1F3C1@googlemail.com>
 <2AB36FB2-B50F-4313-9C57-5E131D16E337@googlemail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5f092e82-c820-ab40-1946-8ff5d6ba2702@kernel.dk>
Date:   Sat, 5 Sep 2020 09:02:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2AB36FB2-B50F-4313-9C57-5E131D16E337@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/20 8:28 AM, Norman Maurer wrote:
> I can confirm this fixed the problem for us.
> 
> Thanks a lot of the quick turnaround (as always!).

No problem, thanks for reporting! I've queued up a regression test
as well so this won't ever happen again.

-- 
Jens Axboe

