Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C95250A37
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 22:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHXUoX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 16:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbgHXUoW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 16:44:22 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A14EC061574
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 13:44:22 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ds1so60321pjb.1
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 13:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rMo5GhUGgbB8ntX0Ys4+egTaRDOcEjLVx0XDFt+GTB8=;
        b=AydXAP8UqATK6wFfR6pvtPu+6AUdJZExSBOvUwcsH6oyHugrANwp2NVplJWPipCQad
         cpuca4rZnppTAePKZn54GndqjQlVdSE6kJDBkFMpa+wEXiG/7QGq9AZfANEodRDmSmjF
         y9D3+DOYuIue/VpDR/9ed8XOWzb+jjHTlHiQxw8Xbl0SD57BCFGkk/FZkVu/6rIr47YR
         wCcFqBkZR+L2UndJroknTC54r6SZC1PxvAVf0J65wvws8LrK9ZhSAdSREurxK0FxHNta
         90snx9w+JtE/7P5b5fJX6ZV+xRW9rvGSkW5UtTgthl9fmmhl3cjKvvtd2FF8NlUcYf33
         xQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rMo5GhUGgbB8ntX0Ys4+egTaRDOcEjLVx0XDFt+GTB8=;
        b=GPLM/dFk+sy+6vkcgiPb08DsSlJ4ep+XPAi/4xBs6Zdh18IxapYeWUezUOZ3Ea3P0S
         lqWiM7qB5R+ct9IVolxz+aDq72merbl2WU5XtWO13/53GPj52ftcIk/PqNI0OgiyVg7g
         jGj6d5rkL4iPD/riYGVIVAmiyLa89oKGM9YlMA/UEQ5x0pVqUW9htCt2+vAVyCiOQr3H
         TNVLAGbpuDZMAy8YwZ8/ZFEREw0zkAM3uxO3puZF8qYOU+rmVYdg7DhrmF7odMpjsx1C
         i0j0tZeTBRki9XSl1bG4hg4dJIY1bcAQzI9+rhsLdeXiFmroqaoahB4liApZujuEEjuU
         80CQ==
X-Gm-Message-State: AOAM533bLGHCxQrVSsLggsdsv98CWj0mCeLNBvVTk54JBUat7IL4k8Hs
        rTxImJ4jlgmkyZt60ijQDVMqx0Ycf+Hbx/ZE
X-Google-Smtp-Source: ABdhPJwMF3VUisg0r8bT1nMHATSAyFFmmjg3xmv/L2F4pDMBowOp6lZw3aTnOTCUMzvWovgNQRv0iQ==
X-Received: by 2002:a17:90a:13c4:: with SMTP id s4mr816717pjf.141.1598301860115;
        Mon, 24 Aug 2020 13:44:20 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21e8::193f? ([2620:10d:c090:400::5:b493])
        by smtp.gmail.com with ESMTPSA id 29sm404365pje.10.2020.08.24.13.44.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 13:44:19 -0700 (PDT)
Subject: Re: [PATCH 5.8] io_uring: fix missing ->mm on exit
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <25db35fc25aa7111f67a6747b1281c5151432f8f.1598300802.git.asml.silence@gmail.com>
 <392dc86b-52ac-1ca4-d942-51261d1f7a9f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <56724eaf-d143-82c8-31e1-4b5d4d29fe9b@kernel.dk>
Date:   Mon, 24 Aug 2020 14:44:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <392dc86b-52ac-1ca4-d942-51261d1f7a9f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/24/20 2:40 PM, Pavel Begunkov wrote:
> On 24/08/2020 23:35, Pavel Begunkov wrote:
>> do_exit() first drops current->mm and then runs task_work, from where
>> io_sq_thread_acquire_mm() would try to set mm for a user dying process.
> 
> This is a backport of [1] + [2] for 5.8. Let's wait to see if
> Roman Gershman can test it.
> 
> [1] 8eb06d7e8dd85 ("io_uring: fix missing ->mm on exit")
> [2] cbcf72148da4a ("io_uring: return locked and pinned page accounting")

Yes, would be great if we could test. And provide an email, too :-)

Once that's settled, I'll shove this to 5.8-stable.

-- 
Jens Axboe

