Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D1D68C151
	for <lists+io-uring@lfdr.de>; Mon,  6 Feb 2023 16:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjBFP3g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Feb 2023 10:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjBFP3e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Feb 2023 10:29:34 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4493EEB58
        for <io-uring@vger.kernel.org>; Mon,  6 Feb 2023 07:29:33 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id o13so982136ilt.4
        for <io-uring@vger.kernel.org>; Mon, 06 Feb 2023 07:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lwFXeEE6OM+Eba5UlMJGqS1S5aU4oc1qRdddqki3enQ=;
        b=iV7stC/flzjebT0ar0vLBLMrRS1Zgfa4EWmzBHUBq2mPfhFfiy+qFMOXKaYBXaQQGk
         fnvpe85ijbA+XlWQ94UEI91LIJSirAEiQC26cj+atSqFnE+QYnQMMcNeGrLRqxpvDdHm
         cKXp4vB0mO9XeLLGwQUUZI3wbYEmaAULlVkLC9CsE5KkerWDgA26PhyGRIEL+ziV9klS
         ZTfXcOrK3NZsSTZLNj0UKWysqi5sQITOs//iVA4UDTrnHQxJv4D61/PAqTL+n/SAEbTK
         vTM7/bdyZpB8JbOAtwXYFZJf7rKJzqFufWbhQVhQXWcz2GzCGUsQMnEh2g1LeDK5qqvq
         LSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lwFXeEE6OM+Eba5UlMJGqS1S5aU4oc1qRdddqki3enQ=;
        b=eUd7bzAszCT6Waij9sU/58t8tFCMQmn6DT7wIohIpMhgok8teYnxXYT0zxdT1xZk0J
         RVUeabRn4pASXrD98tcNJvrKcIhiAakijiZk++QdxskqOm5GblXEKjkZnc0sAEwZVG9h
         Gt3X/R6wGRyCqUruYXxcZEJPyhpeoyqhURJog+zw9I5EfA1Q0y1j/8Hh+JR5pNTUoSer
         q5FkgqnspzxjnkuulIE/i5MrPOtbY70ykfdxfaxtQIEzUX/ApsyNOpqT3+6PpwDxfhxe
         iTBbwIQl5lGxygQZrmKpkWm/huI4Zjw1lKIuoUvGWLg1qIOtGdb7fgBiNHzPtCcb1Dax
         Q4pA==
X-Gm-Message-State: AO0yUKX/NEFXRdJN0w5NiQdOqexTP2vUJsOIXJlVK6McpeY7KAmDPvaG
        NEG4Z/lw0/BHD/t58w+k2vrdxQ==
X-Google-Smtp-Source: AK7set9Cjsl1WoBaQgY9HwcHawN0VOjEz2rxxQK8fWTRHIWybXhIiVYh55Tn13UNgbPNi4BUWsceWw==
X-Received: by 2002:a92:c266:0:b0:313:c42c:d34 with SMTP id h6-20020a92c266000000b00313c42c0d34mr3044228ild.3.1675697372596;
        Mon, 06 Feb 2023 07:29:32 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r11-20020a056e0219cb00b00313b9c65950sm1884967ill.30.2023.02.06.07.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 07:29:32 -0800 (PST)
Message-ID: <52d41a7e-1407-e74f-9206-6dd583b7b6b5@kernel.dk>
Date:   Mon, 6 Feb 2023 08:29:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 09/19] io_uring: convert to use vm_account
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple@nvidia.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/23 12:47 AM, Alistair Popple wrote:
> Convert io_uring to use vm_account instead of directly charging pages
> against the user/mm. Rather than charge pages to both user->locked_vm
> and mm->pinned_vm this will only charge pages to user->locked_vm.

Not sure how we're supposed to review this, when you just send us 9/19
and vm_account_release() is supposedly an earlier patch in this series.

Either CC the whole series, or at least the cover letter, core parts,
and the per-subsystem parts.

-- 
Jens Axboe


