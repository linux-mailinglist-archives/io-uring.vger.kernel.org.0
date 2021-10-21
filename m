Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10774364C0
	for <lists+io-uring@lfdr.de>; Thu, 21 Oct 2021 16:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhJUOwC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Oct 2021 10:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbhJUOvz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Oct 2021 10:51:55 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C315DC061220
        for <io-uring@vger.kernel.org>; Thu, 21 Oct 2021 07:49:39 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id a17-20020a4a6851000000b002b59bfbf669so194754oof.9
        for <io-uring@vger.kernel.org>; Thu, 21 Oct 2021 07:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pXRyX3KX9bGPC/zOdp5JyDWEDq6qDJEPkNeWuxj85DU=;
        b=qpoaEHVcuMdRoQ2K1TFK/LXtRMSNK0w0iKW5JKkc0bgEUsiCOVKXh1n2w8lBABl0+R
         XCMuggKNwSRmPuC3aPUwuK+pOk5qe0rR164WOTgDEXTvkK2wjXnMdLuQxXeTFDkA+SLD
         D9MBsVP8HLNKzlxCZXLCqWmEITqL8bk4WWk5HrrDsCYOV+xnWB5v+DQBXpWioJ1B8WvF
         buLjD1slvjJc0BbpGWSon7bxO0k64g22dO6GdOcBxjy+4b6ZmgM0ktq6j1K7r42Hkwg+
         ZGpQG/87ZpaWRmMYLBO2WUOAWYjOQTLQp9gBnu9xcZOM07+n3J4zYc9XUlCxunx7DNm8
         DunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pXRyX3KX9bGPC/zOdp5JyDWEDq6qDJEPkNeWuxj85DU=;
        b=IJ7JUp22ZnH67cp8+v5fyvJFa81iC18V+bacAkV1Ekt0X3XMGmfJ9H2Bf8rerOm+LJ
         /jxmtk7osLVxZPLo82ViENo/4QS796vfcniq/mCDBlapu3M34CeZh0jIIEt+5xqxDGNM
         XQa0ni2bnMO7nDbakhWsCuFKb34+bSELorGQxWSUIcYSnZW5wR+kLymylyK54IG+a+aa
         EkwoMGU7p0ODLlzpPG/EiOzf3nt7Z6rUaCmJn9I8kl5baNBxcuhTiLP6dPhG7jAv1kXK
         GA7kGfjG7zmuWCFxl2i2dnLgtELh/xZBwW9fqTpMZGwojMFL6DS9yuJoJOGUlo3nrOhG
         n6KQ==
X-Gm-Message-State: AOAM531Ov75gPYJazqbPE1Y28/xeAYWCctv+LjGS+Dx8fAOr6iRD7sQz
        iXSIUq/IVMK/8k+Hjaqx7hedIQ==
X-Google-Smtp-Source: ABdhPJwJVQavZx+exAzpmAAl57JfWF1VhiNBElrroIeHF/zpNATchxS3HE/i56a28pS3PE/b07naTA==
X-Received: by 2002:a4a:a78d:: with SMTP id l13mr4698773oom.54.1634827779076;
        Thu, 21 Oct 2021 07:49:39 -0700 (PDT)
Received: from ?IPv6:2600:380:783a:c43c:af64:c142:4db7:63ac? ([2600:380:783a:c43c:af64:c142:4db7:63ac])
        by smtp.gmail.com with ESMTPSA id v13sm1129954otn.41.2021.10.21.07.49.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 07:49:38 -0700 (PDT)
Subject: Re: [RFC] io_uring: add fixed poll support
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20211009075651.20316-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <25be94cc-efe2-c35a-1e72-2c113b856c32@kernel.dk>
Date:   Thu, 21 Oct 2021 08:49:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211009075651.20316-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/9/21 1:56 AM, Xiaoguang Wang wrote:
> Recently I spend time to research io_uring's fast-poll and multi-shot's
> performance using network echo-server model. Previously I always thought
> fast-poll is better than multi-shot and will give better performance,
> but indeed multi-shot is almost always better than fast-poll in real
> test, which is very interesting. I use ebpf to have some measurements,
> it shows that whether fast-poll is excellent or not depends entirely on
> that the first nowait try in io_issue_sqe() succeeds or fails. Take
> io_recv operation as example(recv buffer is 16 bytes):
>   1) the first nowait succeeds, a simple io_recv() is enough.
> In my test machine, successful io_recv() consumes 1110ns averagely.
> 
>   2) the first nowait fails, then we'll have some expensive work, which
> contains failed io_revc(), apoll allocations, vfs_poll(), miscellaneous
> initializations anc check in __io_arm_poll_handler() and a final
> successful io_recv(). Among then:
>     failed io_revc() consumes 620ns averagely.
>     vfs_poll() consumes 550ns averagely.
> I don't measure other overhead yet, but we can see if the first nowait
> try fails, we'll need at least 2290ns(620 + 550 + 1110) to complete it.
> In my echo server tests, 40% of first nowait io_recv() operations fails.
> 
> From above measurements, it can explain why mulit-shot is better than
> multi-shot, mulit-shot can ensure the first nowait try succeed.
> 
> Based on above measurements, I try to improve fast-poll a bit:
>   1. introduce fix poll support, currently it only works in file
> registered mode. With this feature, we can get rid of various repeated
> operations in io_arm_poll_handler(), contains apoll allocations,
> and miscellaneous initializations anc check.
>   2. introduce an event generation, which will increase monotonically.
> If there is no new event happen, we don't need to call vfs_poll(), just
> put req in a waitting list.

This also needs a respin, and can you split it into two patches?

-- 
Jens Axboe

