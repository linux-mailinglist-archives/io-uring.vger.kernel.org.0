Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AAC3BE98C
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 16:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhGGOTa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 10:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbhGGOTa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 10:19:30 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D78C061574
        for <io-uring@vger.kernel.org>; Wed,  7 Jul 2021 07:16:48 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d2so3321703wrn.0
        for <io-uring@vger.kernel.org>; Wed, 07 Jul 2021 07:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FfJ1vxhfNVZqu07P7NnULJh86Bf/KV4lG0lRsRID+l4=;
        b=WOXUTmDy87JSHUkp+esFIxeuHCg7tf74c8lU7RlyShcb/YSL+d5nBGykegYTiI5PtV
         M6SycCckhpsJbVAERJSH/2lDDf98QsRWDny2RFZo/x3Pz7ZTfApBvtLCk0T6E5Ww4ROS
         xC2nsFzxhAdBjh76kBDjjnMVJqe96qEe0PaOtUAZTjNLIGvkew+QdnQgSO6pkP97VZNZ
         4Erl+iB4j7U9NJfUd2+8CzFqFeQ772KO642/kX0Ds+C/uq6aRNP1QJpmCI4LwhCxCLNp
         3qNuYT3EuAGKaIbuN4e09N/Veste9kQgbQAmjqJtUUFH9SRKyIZlKtyHvwpMnhib2rgx
         R7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FfJ1vxhfNVZqu07P7NnULJh86Bf/KV4lG0lRsRID+l4=;
        b=VSojWS6TBrkUzh+t5r7E2e51UXLe5hqlkUggRKJdik8ojpZVvWLzQXa2cm2oHy+zUM
         LKb3/gwkXvd1sXG1h3wH+QDLGLav+sDuUtEHSlumCw/I5/w0RPC4WYTt5StyoaFEYF/z
         KFjcXeN7z8m8Oeq7Tzr0jX3cthIxJeiHruuEGyqAAE7kTSn5eL9rGSODeTTwrbOB3O4P
         WqyhSswf3QAVqp5tomDA6rOJTBBzRmdc/KSZKXbdOOnqsRJyLbDCaYqydQG+4cMQZY7t
         wqlL0aNDsgQoaBQSSE5xD5f91l2GFBNUVSAibSMHbPErRmQ2SCYR0JO80Bv9Gq3e5osW
         ks+w==
X-Gm-Message-State: AOAM532nhRYy6d/RBMSyeGusSck/Sy7cK107uIVEaZKAcnlMpusxTQyp
        QuP+lAVm9GLbrAhcI0e5H+s=
X-Google-Smtp-Source: ABdhPJyvJriJ6KqxZPe+hWzzeUS8N4+OoBEqgXcIVfsusp/bfUKzZPhPgcjShJ6qN5eZtPaEW0n4gg==
X-Received: by 2002:a05:6000:11cf:: with SMTP id i15mr8568334wrx.212.1625667407417;
        Wed, 07 Jul 2021 07:16:47 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.234.206])
        by smtp.gmail.com with ESMTPSA id q7sm17542323wmq.33.2021.07.07.07.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 07:16:47 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <6a7ceb04-3503-7300-8089-86c106a95e96@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: Question about sendfile
Message-ID: <4831bcfd-ce4a-c386-c5b2-a1417a23c500@gmail.com>
Date:   Wed, 7 Jul 2021 15:16:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6a7ceb04-3503-7300-8089-86c106a95e96@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/3/21 11:47 AM, Hao Xu wrote:
> Hi Pavel,
> I found this mail about sendfile in the maillist, may I ask why it's not
> good to have one pipe each for a io-wq thread.
> https://lore.kernel.org/io-uring/94dbbb15-4751-d03c-01fd-d25a0fe98e25@gmail.com/

IIRC, it's one page allocated for each such task, which is bearable but
don't like yet another chunk of uncontrollable implicit state. If there
not a bunch of active workers, IFAIK there is no way to force them to
drop their pipes.

I also don't remember the restrictions on the sendfile and what's with
the eternal question of "what to do if the write part of sendfile has
failed".   

Though, workers are now much more alike to user threads, so there
should be less of concern. And even though my gut feeling don't like
them, it may actually be useful. Do you have a good use case where
explicit pipes don't work well? 

-- 
Pavel Begunkov
