Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB71D67EEBF
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 20:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbjA0Trr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 14:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbjA0Trc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 14:47:32 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D5F59249
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 11:44:59 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id nn18-20020a17090b38d200b0022bfb584987so5716020pjb.2
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 11:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4FpsNM4Bdeby2MkenGuWGLbgk6pVqfQ79XLW3mUcsw8=;
        b=F2vvZ4cY3XujJxcvSFPPFbA0T4QFWceX/SZWDjzEBQBsDpjiwkvUCKcwp/10z9aejk
         1W3DC675aeH2QMNG4B6W+Ub7kYV/QhY72iMcK3/Lxu/VhH2YP3UvGbqkf4MqZh23IT0L
         dvjoOW5AA+2ue6XtiKzFEjeejdjicP8045Bab1vFTCB1zUGCD6ynMyjklQzhxyvlUlsz
         cpZDKjezmKc1h5jiNlaWflutTuEikyY8MKuKbiN81Haplm1kSBz0SjvaJLoOYwttQWZL
         wslXyaI3KJ+FVgMR+y1Ix6z7zlYgL0I9fU6526Y6hvZ+FcaeLl/tFjJuMJBXPQIvCPcB
         PCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4FpsNM4Bdeby2MkenGuWGLbgk6pVqfQ79XLW3mUcsw8=;
        b=VFOjD063zrASOol6crG/LIDYRz+dYSPywDaT2Z8HrqxmQUwMSpR/1YbMn3W9nPGbkA
         5ks2aILDZBKf3KvJcNxgkxvGFhFEWpco58pr8sauatHAB+gLGXrm1IuWoaJkKexp4D2s
         XHRAvv+h562+W1O7oLTVdQOU555D1wNmHX6nZ/ih2sH9m2xDCeJRJSFh52v+iuoH4bRi
         MnNpM/3JjVqxTrgRMSJqQJrqQql3fIrO+58MfJUM7gCCWTgTtdFf3R2oLdRdzgTRqlqA
         hxkEqjfbZ1I4BnVYJob+4yOwJUeH+JdnALe7bSii6mYRRHxyMTWzRkTbTTk0hKTeCMsZ
         syBw==
X-Gm-Message-State: AO0yUKVlFvqErGpNFAcs/kY5vBvhzLtDeUnayquM8V+UdGEIFDmVUitS
        ilCYnllycmNHlQ6WD9bgn+DzCA==
X-Google-Smtp-Source: AK7set/JiYkD1dPFXX0spEZ4uMEWwjgdpN2oFU19P2Z0/IgGbk/hInjo9DftHh34XEOc/4I/lRZl0g==
X-Received: by 2002:a17:902:d4d1:b0:196:1f80:105a with SMTP id o17-20020a170902d4d100b001961f80105amr3004568plg.5.1674848620397;
        Fri, 27 Jan 2023 11:43:40 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c12-20020a170902d48c00b001894198d0ebsm3254490plg.24.2023.01.27.11.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:43:39 -0800 (PST)
Message-ID: <24fbe6cb-ee80-f726-b260-09f394ead764@kernel.dk>
Date:   Fri, 27 Jan 2023 12:43:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v1 0/2] two suggested iouring op audit updates
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1674682056.git.rgb@redhat.com>
 <da695bf4-bd9b-a03d-3fbc-686724a7b602@kernel.dk>
 <CAHC9VhSRbay5bEUMJngpj+6Ss=WLeRoyJaNNMip+TyTkTJ6=Lg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhSRbay5bEUMJngpj+6Ss=WLeRoyJaNNMip+TyTkTJ6=Lg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/23 12:42 PM, Paul Moore wrote:
> On Fri, Jan 27, 2023 at 12:40 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 1/27/23 10:23 AM, Richard Guy Briggs wrote:
>>> A couple of updates to the iouring ops audit bypass selections suggested in
>>> consultation with Steve Grubb.
>>>
>>> Richard Guy Briggs (2):
>>>   io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVISE
>>>   io_uring,audit: do not log IORING_OP_*GETXATTR
>>>
>>>  io_uring/opdef.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> Look fine to me - we should probably add stable to both of them, just
>> to keep things consistent across releases. I can queue them up for 6.3.
> 
> Please hold off until I've had a chance to look them over ...

I haven't taken anything yet, for things like this I always let it
simmer until people have had a chance to do so.

-- 
Jens Axboe


