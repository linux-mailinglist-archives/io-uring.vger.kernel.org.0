Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8EA6A10A6
	for <lists+io-uring@lfdr.de>; Thu, 23 Feb 2023 20:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjBWTje (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Feb 2023 14:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjBWTjd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Feb 2023 14:39:33 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10A7193C6
        for <io-uring@vger.kernel.org>; Thu, 23 Feb 2023 11:39:27 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id il18-20020a17090b165200b0023127b2d602so395549pjb.2
        for <io-uring@vger.kernel.org>; Thu, 23 Feb 2023 11:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677181167;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iV6+ABNw2LaFR5D/DxEZrmLkc9SRilZ6PWsjEGStGCw=;
        b=sBG7+vBYyqyalaoPM3ZXPaCc3FADhm8+Yfpm6ndnrdjye2FAMRmntVLXdjDwSWOMoO
         qGGuSHefrmJQfnAAHz27M+QYIJ6DyIJNIjmP+5N4OoudjYSBOQB7bHN5PjPMtQ4a3tT5
         ANbaGKwW+MIpEMOcHnREE4eQRgGZ4OjBG/gMthLBn8LEmJu9wcUdgFyCWLjH4OMcikiz
         02wZMzr7MVpqfTIyPe6gLfusCIKTQ9HakewpoJZftr+kn7jNNSe6FPkN4UKujsKMVXwO
         2fnnoZb5eZGP1Tnoj7AoXdbcF2Ikk/fj7bj4i8HJH4Nr/VinaXObVnuNieY6fs8GpHGd
         SGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677181167;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iV6+ABNw2LaFR5D/DxEZrmLkc9SRilZ6PWsjEGStGCw=;
        b=skS1thr8Qav/Rk5wOVwfe5fcNWKSm0Yo9xALVFXhXDN0x1wvL/nXc0IzAXGaw+1POv
         wqu4OJbmbPR1p0fCS29gZ5sXYt8SaeZukx6ecxR4jL/XkZwRpXmAyrUBzu1tCmN6Y6f0
         xaO/vcXfLYtF8OPk5s5UP1wDw3DpArCU+eymqJwNVUBkc+gOYyVQx2MN7IY5jsQhca/y
         U5LEuNOcwMGjWhgiwApa7Jzg0RIichnvQCWe/2HVpTgkk29T4Pgsk2/KAMx/98VvbyF0
         bHFybXalfWQAloiopfV4zBOpX8hogEqc8RFgu93zzmXmq+gwc278HD7teOO3JMV305gt
         GXyQ==
X-Gm-Message-State: AO0yUKUWeLzEpAd56FwPB5dGkEf/GUX7xoKMBgmNg9PYjwFqZpSBir/G
        IeDfJrdPw/ayZLw85BUPHg9JmQ==
X-Google-Smtp-Source: AK7set/7Nmr+XZFIt6SS8Fn1mam7b5auOrye6DpeaNoap2+z1n3Qkk/h8VyR03b8wm7aneUvjDIEcg==
X-Received: by 2002:a05:6a20:7d87:b0:bc:6c4f:308a with SMTP id v7-20020a056a207d8700b000bc6c4f308amr16468942pzj.0.1677181167222;
        Thu, 23 Feb 2023 11:39:27 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y27-20020a637d1b000000b004facf728b19sm6325210pgc.4.2023.02.23.11.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 11:39:26 -0800 (PST)
Message-ID: <8404f520-2ef7-b556-08f6-5829a2225647@kernel.dk>
Date:   Thu, 23 Feb 2023 12:39:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v3 1/2] io_uring: Move from hlist to io_wq_work_node
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Breno Leitao <leitao@debian.org>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com,
        kasan-dev@googlegroups.com
References: <20230223164353.2839177-1-leitao@debian.org>
 <20230223164353.2839177-2-leitao@debian.org> <87wn48ryri.fsf@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87wn48ryri.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/23 12:02?PM, Gabriel Krisman Bertazi wrote:
> Breno Leitao <leitao@debian.org> writes:
> 
>> Having cache entries linked using the hlist format brings no benefit, and
>> also requires an unnecessary extra pointer address per cache entry.
>>
>> Use the internal io_wq_work_node single-linked list for the internal
>> alloc caches (async_msghdr and async_poll)
>>
>> This is required to be able to use KASAN on cache entries, since we do
>> not need to touch unused (and poisoned) cache entries when adding more
>> entries to the list.
>>
> 
> Looking at this patch, I wonder if it could go in the opposite direction
> instead, and drop io_wq_work_node entirely in favor of list_head. :)
> 
> Do we gain anything other than avoiding the backpointer with a custom
> linked implementation, instead of using the interface available in
> list.h, that developers know how to use and has other features like
> poisoning and extra debug checks?

list_head is twice as big, that's the main motivation. This impacts
memory usage (obviously), but also caches when adding/removing
entries.

-- 
Jens Axboe

