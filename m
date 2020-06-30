Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACA820F4DE
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 14:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387736AbgF3MlH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 08:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732042AbgF3MlF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 08:41:05 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAF1C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:41:05 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w16so20383270ejj.5
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xKXXy0gWoAUoYS59GVmVmAf0UuN5mGs5Bnk4rnktNvM=;
        b=sw4TAOiKFatuneiUHTL8OlQIP4mgi/Rp7iY61DdTLO2BvZX2mjeqOA3jJ9eROYiq/5
         DrmzMjxHBsjAtfFVxFBTL9Dn/7MasPDUIXx1j/YLmY6QdkcavYFBSkItANDDVxxKcybs
         v1xZY74gc3T7JaXJ5nEejBY8OmVO/SVejxh56Z+2F21ocZOGGZ5XWodRyzQVMoSQs0+w
         b32zkcVioxncVT+GEBhVMQzfqTJWBNqFCpUmfjMD4mzNpVyqxEB1TWBeZt/Ifup468LI
         CDoSAbpjNslONFUPu+JJE7tmCai2InPPKuPDHpZ3XWHQn74Ve/KXtA/UylGow5W/DFXv
         7AHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xKXXy0gWoAUoYS59GVmVmAf0UuN5mGs5Bnk4rnktNvM=;
        b=aJkI5wbRWotdKyln/pPeifSydnbCmbOiX5bzwL1kKUtBY9HewocF0nBgoqSx8Xsz0f
         Wg2Q4wQUQp6xkW99zCXyRSuZxxgvxDqOB5OVZA2QEhk3vT5SWoPatYNY8kgIe8xOyYLL
         hybUrO/c9doeRcQpao+zPcqq2rtHs5XvvU/JrdMmt1/Lp1ClVszU4RRvUb96VORT1nYL
         d5bfJd71Jvui7lYTFXqf5jZEXUKU5TYAXm0lS+ivjbnFRh3D4+DIFMg8/2wUdRPlMRgo
         dBCWBxHJh5Uc8yrW6Zv/crwwKGU5cELLpJYZjWJ5xxIwp9IR6ZIpwrWGUYBSJ45hVZ4O
         Qo5Q==
X-Gm-Message-State: AOAM5316kf2YA0v2pVqT89ChdPqwF10PIaqea4KDvFUo5hkKxH3T9HMk
        kr68LfIZHqjUEdgKM2YDmbjgtBU1
X-Google-Smtp-Source: ABdhPJw1KjuKgdEQyl3Gwk48ptOyrPBTfijzn7bhf5kTvwi+JfNKVEEmk/F3S+JpkqsiovsSMGh//w==
X-Received: by 2002:a17:906:eb5a:: with SMTP id mc26mr13492365ejb.42.1593520863703;
        Tue, 30 Jun 2020 05:41:03 -0700 (PDT)
Received: from [192.168.43.125] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id cw14sm2634708edb.88.2020.06.30.05.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 05:41:03 -0700 (PDT)
Subject: Re: [PATCH 0/8] iopoll and task_work fixes
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1593519186.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <ef5d9a7e-9a51-7711-da14-fe47bee4f171@gmail.com>
Date:   Tue, 30 Jun 2020 15:39:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1593519186.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/06/2020 15:20, Pavel Begunkov wrote:
> [1-3] are iopoll fixes, where a bug in [1] I unfortenatuly added
> yesterday. [4-6] are task_work related.

I think there are even more bugs. I'll just leave it here, if somebody
wants to take a look.

- I have a hunch that linked timeouts are broken, probably all these
re-submits cause double io_queue_linked_timeout().

- select-buf may be if not leaking, then not reported to a user
in some cases. Worth to check.

- timeout-overflow test failed for me sometime ago. I think that's bulk
completion related. I sent a patch for a very similar bug, but it got
lost.


> Tell me, if something from it is needed for 5.8
> 
> Pavel Begunkov (8):
>   io_uring: fix io_fail_links() locking
>   io_uring: fix commit_cqring() locking in iopoll
>   io_uring: fix ignoring eventfd in iopoll
>   io_uring: fix missing ->mm on exit
>   io_uring: don't fail iopoll requeue without ->mm
>   io_uring: fix NULL mm in io_poll_task_func()
>   io_uring: simplify io_async_task_func()
>   io_uring: optimise io_req_find_next() fast check
> 
>  fs/io_uring.c | 79 +++++++++++++++++++++------------------------------
>  1 file changed, 33 insertions(+), 46 deletions(-)
> 

-- 
Pavel Begunkov
