Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B37420550F
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 16:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732740AbgFWOoq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 10:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732738AbgFWOoq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 10:44:46 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E25C061573
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 07:44:45 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i4so20824756iov.11
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 07:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bx+eV0slVCRzS+cNSzjyTkyojk/xXAzX8isdXQftOVg=;
        b=caYTTWK/2MFNzc00X91UI9Qe3mRp6hNvUfI+Z8MTuGj1FVq0Dy7PpkEptQoALQAEiK
         WID8skvuFdz3f6qPk7qlDbtfIUJJkUrNEmLUq77J39dkkZ8asorsaW5dvQ8uW1ziFtoD
         f6HO3KDvOtCmjL6Hn3HpV80jgf6JQMQRyKHX11AqrPoIRc9uac84Qzf1chT7ru1MYAJA
         iGu3Hz+y7ezVvauGr542Yne3SyMoExcU0FfqyaFAwv6VInjcC34MQKcJ3HIlCrOY7iSY
         gHQwZK7BlI2ZCJTwYuyCRF9UooY43hV2rI0b8pugVWiDx2sMoB7lVTuHMygY9NycfF89
         FC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bx+eV0slVCRzS+cNSzjyTkyojk/xXAzX8isdXQftOVg=;
        b=WNG83pIm7Kpv2oNI6u67IPB4ZDMYBDl1bHgGC7C8j1brk58hrh8F9HwoWKXIXZvHSk
         DfwSIe8LeKyGDadoHhHUMO+1iSWBPjyPQ23P30Wpg6EKj4VsQYYUmtLmbRNv2A5LrlkP
         H3G7jeBcAYScr/Op9QRUnfxEMVi5zVCOLiYe72eUMeYvfz0mZgIN1XOqvgA55RJSMype
         Ua3YZULWPK52B/s/KufGmkDQlSonBmIXt05YqOGZKg8uBnFbPTGDNXauZXDxiEHhWrdy
         RMD8otHvaRW9jMAMwqSYN9VC5XX4ABqJ7a+rDlH8nRbsN6srEhEOOIgR97MZO3rdfVhy
         uIdw==
X-Gm-Message-State: AOAM5307M74IgzKQ106uqNT2jN+IzPx2mVAMPU0cIMJR119Z/8oIBy6Q
        27wk4dPsxPTvYpD95VnUorkg7w==
X-Google-Smtp-Source: ABdhPJyzn2vPQE5lF/ZPZgSLINybKNbpUxO3rGsKVjm8fxKPo8iRQrKvKkrNNjqjpB+VDFRRh3JifA==
X-Received: by 2002:a05:6602:1601:: with SMTP id x1mr26494531iow.129.1592923484387;
        Tue, 23 Jun 2020 07:44:44 -0700 (PDT)
Received: from [192.168.1.56] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p2sm10139913ioh.1.2020.06.23.07.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 07:44:43 -0700 (PDT)
Subject: Re: [RFC] io_commit_cqring __io_cqring_fill_event take up too much
 cpu
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Dust.li@linux.alibaba.com
References: <20200622132910.GA99461@e02h04398.eu6sqa>
 <bb4b567f-4337-6c9d-62aa-fa62db2882f3@kernel.dk>
 <c0859031-f4df-8c38-d5e1-aba8f82a9f98@kernel.dk>
 <d6038ea3-952a-3438-cd37-4bf116de4871@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <34ecb5c9-5822-827f-6e7b-973bea543569@kernel.dk>
Date:   Tue, 23 Jun 2020 08:44:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <d6038ea3-952a-3438-cd37-4bf116de4871@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/20 6:32 AM, Pavel Begunkov wrote:
> On 22/06/2020 20:11, Jens Axboe wrote:
>>> I think the solution here is to defer the cq ring filling + commit to the
>>> caller instead of deep down the stack, I think that's a nice win in general.
>>> To do that, we need to be able to do it after io_submit_sqes() has been
>>> called. We can either do that inline, by passing down a list or struct
>>> that allows the caller to place the request there instead of filling
>>> the event, or out-of-band by having eg a percpu struct that allows the
>>> same thing. In both cases, the actual call site would do something ala:
> 
> I had similar stuff long ago but with a different premise -- it was
> defer-batching io_put_req() without *fill_event(). It also helped to rework
> synchronisation and reduce # of atomics, and allowed req reuse.
> Probably, easier to revive if this sees the light.

I'm going to polish this series a bit, then post it for review.

>>> if (comp_list && successful_completion) {
>>> 	req->result = ret;
>>> 	list_add_tail(&req->list, comp_list);
>>> } else {
>>> 	io_cqring_add_event(req, ret);
>>> 	if (!successful_completion)
>>> 		req_set_fail_links(req);
>>> 	io_put_req(req);
>>> }
>>>
>>> and then have the caller iterate the list and fill completions, if it's
>>> non-empty on return.
>>>
>>> I don't think this is necessarily hard, but to do it nicely it will
>>> touch a bunch code and hence be quite a bit of churn. I do think the
>>> reward is worth it though, as this applies to the "normal" submission
>>> path as well, not just the SQPOLL variant.
> 
> The obvious problem with CQE batching is latency, and it can be especially
> bad for SQPOLL. Can be reasonable to add "max batch" parameter to
> io_uring or along a similar vein.

Yeah, we need some flush-at-N logic, which probably isn't that critical.
32 or something like that would do nicely, it's small enough to not
cause issues, and large enough that we'll amortize the cost of the
lock-and-commit dance nicely.

-- 
Jens Axboe

