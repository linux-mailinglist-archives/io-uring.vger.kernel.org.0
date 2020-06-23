Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8127120528C
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 14:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgFWMeQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 08:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729574AbgFWMeQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 08:34:16 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C12CC061573
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 05:34:16 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h15so385068wrq.8
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 05:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R++gJrIRD9BexNSw9Q5JV3heI6aDrr4zaYoT3rHkFA8=;
        b=M3U4V9TN2awa/kjG68pd06W5v9lra067I8ePlPLgbz6TMYpT133zh7JdWSXN3OpXmw
         rjO5Tqjzy8E/xRp+ehWCJCqvdJW6oNJFQ1zhoX+fNWQmMNkxtnb6bJJbAGSsDa14j3OV
         Ae0y9FM+EuPgjLYnVVYhzl8Ae793C8JdusnctHBwpwQvS16cwYLzacHegpAIOCIFdCE2
         fF7NTB8lcNM2CeQknuk+yOxlxWuDmNlTXAjjggZtddz5c8tvDlFAPQP/WoW9sGPKY4S0
         Bhb0FIxPypsgf+XdOwwrFGKsqr9pz70RzVssQ8jgmleoYYHLgLTsYcfbPHJJKk/fs7Tb
         dy1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=R++gJrIRD9BexNSw9Q5JV3heI6aDrr4zaYoT3rHkFA8=;
        b=IZEYzJuK2tE62YKt1aSYriCCE6p5jiEV1R4VMWjzxXRbbjvgkX9PI816Hw/+uN3Cwq
         QCjIqztgiDB+Y//rEc6g8N38Gf1Y/mtJmPNonMFQ8hTEVAykg7P4UqmY1DidU6nSybME
         puX3QGc0xamC3VmOjc9mf7F6RQ5+x3PyTzMj4ERoTyusJLlyuyZ3GKH9LonuZX/R4WCo
         L4VqtW4mJ7xr0eiJOAdde2cTkwSE36ZwZScQ+eOOJNBSBfif4tCmwZwsnYBaukP5D4/m
         G/+Nfk6lIGv5aSKq2kO4eBbe9lK+7zPSOuThsK1jy/clEqsmlT/CnRFcGt/bQQGr98qU
         C/6g==
X-Gm-Message-State: AOAM532X01cd+uVGap8avLvKSYB5WVDJeobZPp0b3GzarGYr5w6X8EPA
        SyXJOF9CjQbK7zUu7pmjlVthT7wy
X-Google-Smtp-Source: ABdhPJyf1k3/7DHmQNwl6iplzm1LtZAV1wC1Ss1joryj8NSqqaW1pFXRMlkOX0NM6RH9PsaBuw4mWg==
X-Received: by 2002:adf:a514:: with SMTP id i20mr24640395wrb.112.1592915654604;
        Tue, 23 Jun 2020 05:34:14 -0700 (PDT)
Received: from [192.168.43.181] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id r3sm2491759wrg.70.2020.06.23.05.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 05:34:14 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Dust.li@linux.alibaba.com
References: <20200622132910.GA99461@e02h04398.eu6sqa>
 <bb4b567f-4337-6c9d-62aa-fa62db2882f3@kernel.dk>
 <c0859031-f4df-8c38-d5e1-aba8f82a9f98@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC] io_commit_cqring __io_cqring_fill_event take up too much
 cpu
Message-ID: <d6038ea3-952a-3438-cd37-4bf116de4871@gmail.com>
Date:   Tue, 23 Jun 2020 15:32:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c0859031-f4df-8c38-d5e1-aba8f82a9f98@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 22/06/2020 20:11, Jens Axboe wrote:
>> I think the solution here is to defer the cq ring filling + commit to the
>> caller instead of deep down the stack, I think that's a nice win in general.
>> To do that, we need to be able to do it after io_submit_sqes() has been
>> called. We can either do that inline, by passing down a list or struct
>> that allows the caller to place the request there instead of filling
>> the event, or out-of-band by having eg a percpu struct that allows the
>> same thing. In both cases, the actual call site would do something ala:

I had similar stuff long ago but with a different premise -- it was
defer-batching io_put_req() without *fill_event(). It also helped to rework
synchronisation and reduce # of atomics, and allowed req reuse.
Probably, easier to revive if this sees the light.


>> if (comp_list && successful_completion) {
>> 	req->result = ret;
>> 	list_add_tail(&req->list, comp_list);
>> } else {
>> 	io_cqring_add_event(req, ret);
>> 	if (!successful_completion)
>> 		req_set_fail_links(req);
>> 	io_put_req(req);
>> }
>>
>> and then have the caller iterate the list and fill completions, if it's
>> non-empty on return.
>>
>> I don't think this is necessarily hard, but to do it nicely it will
>> touch a bunch code and hence be quite a bit of churn. I do think the
>> reward is worth it though, as this applies to the "normal" submission
>> path as well, not just the SQPOLL variant.

The obvious problem with CQE batching is latency, and it can be especially
bad for SQPOLL. Can be reasonable to add "max batch" parameter to
io_uring or along a similar vein.


-- 
Pavel Begunkov
