Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA3425FE7D
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 18:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgIGQRm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 12:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730470AbgIGQOk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 12:14:40 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9373BC061573
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 09:14:30 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id w186so8216246pgb.8
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 09:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XySz5GlPVo4bk2oWrD8T6y+si3nn7gzpWvKHRuLUnfI=;
        b=F5Nxg9BcaKU0vM48XrnAU8LYqPqx3oWSqzhNqVoQnGo9/xI86XJxyw8lBhnLQDddJJ
         DdleGYNiuOynJh58kTcfcQjsmFDi+KxjtEU1pSB2ich1J9mfPfSROxuNLgALqD3aNJBb
         +OTmlzC3oDkF4eP1jBHftizlAP48YdwsMqd5tL7EC/icxWMepafKl3hcThj5+Js3MEhS
         iA3CN9G0Y22Yiyp6Jn7GatvAbKzPzaSfdNAplmnV4fXxxr8cfMsckJ8CUbIOW7r/6V7B
         FAyGNQxbxEy415eUqSkEIW6bDkEckv1NmasoT6wsgBuZspXTwDOk99UGAp8V8n1i6WYw
         gjnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XySz5GlPVo4bk2oWrD8T6y+si3nn7gzpWvKHRuLUnfI=;
        b=aVLtOa7RKymKde6BonetMruCASJcFebEule5kaKTvZMY0vcerV2LZsEVyBWWeU4jjf
         x9N5fIRBP4DSBGuSi1FZaWYeUm9iECqtYZrq6hpB1J5jPrymaRH2+hUnRS6jij+Rt51c
         h3bi5/PyPDKIh+6WdYlGyp38pSeVmzvKlhamRkCkT3iR2YAADRJ53drCyBSO+kydSkui
         CZDQeyRwwsc6mtkO1b80tM4P8DvWTsSIZZmgRFrdPbfgQzLgYZF03QUlKY31+jHfq9zq
         FleqZB/RTJUjysKlKHHk7FJMwFXfzt4YVGhkA+TbeNABuGckooeE7AoSBS3jY0xeXQ80
         m4kw==
X-Gm-Message-State: AOAM532f5hq/h6vCw/lCVBc8dF046mKRG7giJg7cU16rm4GpbtqgtViO
        B6JrWP/GefSm9tC7fuj/W6tSrQCwgzyADsel
X-Google-Smtp-Source: ABdhPJzwQJGM87TsdRKzY07IUc2WqcwoXv7y5bvP/JjqRLuS2z2Lr8fjDZZDtgfag6/2436TXUhy5w==
X-Received: by 2002:a63:d409:: with SMTP id a9mr16644439pgh.312.1599495269663;
        Mon, 07 Sep 2020 09:14:29 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e1sm12932807pjv.17.2020.09.07.09.14.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 09:14:28 -0700 (PDT)
Subject: Re: [PATCH 8/8] io_uring: enable IORING_SETUP_ATTACH_WQ to attach to
 SQPOLL thread too
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <20200903022053.912968-1-axboe@kernel.dk>
 <20200903022053.912968-9-axboe@kernel.dk>
 <c6562c28-7631-d593-d3e5-cde158337337@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <13bd91f7-9eef-cc38-d892-d28e5d068421@kernel.dk>
Date:   Mon, 7 Sep 2020 10:14:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c6562c28-7631-d593-d3e5-cde158337337@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/20 2:56 AM, Xiaoguang Wang wrote:
> 3. When it's appropriate to set ctx's IORING_SQ_NEED_WAKEUP flag? In
> your current implementation, if a ctx is marked as SQT_IDLE, this ctx
> will be set IORING_SQ_NEED_WAKEUP flag, but if other ctxes have work
> to do, then io_sq_thread is still running and does not need to be
> waken up, then a later wakeup form userspace is unnecessary. I think
> it maybe appropriate to set IORING_SQ_NEED_WAKEUP when all ctxes have
> no work to do, you can have a look at my attached codes:)

That's a good point, any chance I can get you to submit a patch to fix
that up?

> 4. Is io_attach_sq_data really safe? sqd_list is a global list, but
> its search key is a fd local to process, different processes may have
> same fd, then this codes looks odd, seems that your design is to make
> io_sq_thread shared inside process.

It's really meant for thread sharing, or you could pass the fd and use
it across a process too. See the incremental I just sent in a reply to
Pavel.

That said, I do think the per-cpu approach has merrit, and I also think
it should be possible to layer it on top of the existing code in
for-5.10/io_uring. So I'd strongly encourage you to try and do that, so
you can get rid of using that private patch and just have it upstream
instead.

-- 
Jens Axboe

