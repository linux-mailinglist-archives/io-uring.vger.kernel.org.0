Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F46376A585
	for <lists+io-uring@lfdr.de>; Tue,  1 Aug 2023 02:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjHAA2I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 20:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjHAA2F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 20:28:05 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB09A133
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 17:28:04 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1bb91c20602so6730615ad.0
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 17:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690849684; x=1691454484;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kgTPGRyN87jS4tKnavcsDkYQESfL6L9Gm+lJJwkfY6Y=;
        b=GY9k3M7paXDJczrN/BFVTsqxlkIUdb1LPq8BsiItzAevEc5PYKZlKFO77ItwWaX9i/
         GTqX1DY9tNt6R+FZVS/tFuqhhkD9jqmnFOhKLJJTpSqNNmsoVePK1v7OnUQ0Qq41BB96
         sYGS2Jj9N6mu4AGNWz/T1YDoYxdKXWvp9Pl0DhAXJ5L7sHHS1Jr8xIUOkB45OZ1pHeZX
         Tje4wfSKCtxM5M+XS+Ixaqy7Xp1jzZiE7k1sXga/MTgUUN7ZFxD2rjDpIiM5S5mWac3b
         tpsBMLD16Xd0M8m+gUYNNeEDEvVgnZ3l3wXeL1R/TOgkyRFQOxuNK9jcvHGeMr23iACu
         2fLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690849684; x=1691454484;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kgTPGRyN87jS4tKnavcsDkYQESfL6L9Gm+lJJwkfY6Y=;
        b=SNr1wj3YTRoZ53PKuJOP91iCVDgiA2aoYDhShsPZuqLEp/MDgjLuXIFc1l4+jcQa1i
         4fuOwGWYYPFS2o7phzuC/dR997bh/SYRuQgeXdxxwnrbUi04HLYsisJ8+GNsC8HKsXcs
         JVQeaoJDlVrh47fNj4DmBuQ94AAspn8IlAq9eJ1SvIwu9ZcQcVgkSHnOv1ZCkC0Hkx8g
         tOca2Kn+VBjmRVFYF1UgLEk2YVHLqhl7JEa4KsiY4Jtn2AdgTggbOLl2rC4xnXINnz0J
         3RwaINTg+mcoFt3jnFsXAv1vcUmAntAopr8vLjUl425/CgVhl6hZsh7Fvb0yHg1AoMK0
         i+Ow==
X-Gm-Message-State: ABy/qLZEhYZa7GrlMREdXrjCHh7WRNnfSQv0XgmuXwZ61vm4SyvhDaLI
        FFvg2PIoaoCER9fo2TZkn8Xfyg==
X-Google-Smtp-Source: APBJJlHorFCBxkYMkXwavHDSuWz+Ga2gEYmSGDJBNf+qMXKtQJQrj6fk7GhUaxAhGoaFTo8aVGMKQg==
X-Received: by 2002:a17:902:ea04:b0:1b8:17e8:547e with SMTP id s4-20020a170902ea0400b001b817e8547emr10130894plg.1.1690849684276;
        Mon, 31 Jul 2023 17:28:04 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jg19-20020a17090326d300b001b8013ed362sm9130054plb.96.2023.07.31.17.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jul 2023 17:28:03 -0700 (PDT)
Message-ID: <22630618-40fc-5668-078d-6cefcb2e4962@kernel.dk>
Date:   Mon, 31 Jul 2023 18:28:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Christian Brauner <brauner@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, Hao Xu <hao.xu@linux.dev>,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <ZMcPUX0lYC2nscAm@dread.disaster.area>
 <20230731-gezeugt-tierwelt-f3d6a900c262@brauner>
 <20230731152623.GC11336@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230731152623.GC11336@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/31/23 9:26?AM, Darrick J. Wong wrote:
> I've watched quite a bit of NOWAIT whackamole going on over the past few
> years (i_rwsem, the ILOCK, the IO layer, memory allocations...).  IIRC
> these filesystem ios all have to run in process context, right?  If so,
> why don't we capture the NOWAIT state in a PF flag?  We already do that
> for NOFS/NOIO memory allocations to make sure that /all/ reclaim
> attempts cannot recurse into the fs/io stacks.

I would greatly prefer passing down the context rather than capitulating
and adding a task_struct flag for this. I think it _kind of_ makes sense
for things like allocations, as you cannot easily track that all the way
down, but it's a really ugly solution. It certainly creates more churn
passing it down, but it also reveals the parts that need to check it.
WHen new code is added, it's much more likely you'll spot the fact that
there's passed in context. For allocation, you end up in the allocator
anyway, which can augment the gfp mask with whatever is set in the task.
The same is not true for locking and other bits, as they don't return a
value to begin with. When we know they are sane, we can flag the fs as
supporting it (like we've done for async buffered reads, for example).

It's also not an absolute thing, like memory allocations are. It's
perfectly fine to grab a mutex under NOWAIT issue. What you should not
do is grab a mutex that someone else can grab while waiting on IO. This
kind of extra context is only available in the code in question, not
generically for eg mutex locking.

I'm not a huge fan of the "let's add a bool nowait". Most/all use cases
pass down state anyway, putting it in a suitable type struct seems much
cleaner to me than the out-of-band approach of just adding a
current->please_nowait.

-- 
Jens Axboe

