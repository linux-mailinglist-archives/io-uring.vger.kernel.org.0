Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EDA7072D5
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 22:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjEQUQd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 16:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjEQUQc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 16:16:32 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743C62D55;
        Wed, 17 May 2023 13:16:31 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-3063433fa66so805269f8f.3;
        Wed, 17 May 2023 13:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684354590; x=1686946590;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c86qGK32nsVnfDBPzlK095zL52GuJJiCp8X2BQjYCGc=;
        b=oqWa+B8kyAPsW4QlrTWMBcnQ6qkKfyZxb5J3HvGcGebHHd+vNY2EihBHc4ILA6LgDu
         0ArlwQwQLtzk0wpNADCyH+akhsJqxocIQ0Agr6IgmSGMql2O9O6/gbK2eRqs2hIDy+Nr
         NXHS8rM1Z4TUlhIPw4456fbpBwDnjjak0XYrlwioSBnQmL6/i2/ECjf/Imqfa+mbRkDD
         Wa2518d6D5x885Dy3INmBmHpi4pUmwjxIOrU0XAO+alj4JNf/kEUROiFadVsaJQo1Y7a
         NRs5Sf0Zao8aNFwS21uCHcSWYVNVpvhGwuR6zzjzCdDNlUhot9fz+0ij3fxJ4/2ZszJp
         9vkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684354590; x=1686946590;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c86qGK32nsVnfDBPzlK095zL52GuJJiCp8X2BQjYCGc=;
        b=hw/UN6XRyWdpNq1F9dXZeq8UG5BrwZkhiLsfwYj6MOstEOog20jx0NtHtOSNbQpMLd
         Bq4EyljpzljDdWkZXaPjXGoA1ED+LTZdPg/PjY/XP+p/mH34b/VWr9AUieJbppvvol/3
         o6BQe93geS758UcDzBqrLzA7k+FLyR6ratr8UcZsW7FofyiTO/9SMgJ5AdS16x91g1aY
         c8gD3OPFWjgG7SR1gKdLPI+Qzb/4MwYm/WZbQFKnZjstxg/IRiUREG631EYm1FDDx0rr
         8pT0qW+d4L9CzdlFW2qAVQO27xJzn5py1RhC01mKPIQPTJOuzIWkU5xO58GxvudzCp8U
         xvUA==
X-Gm-Message-State: AC+VfDybyzHeU8K8bpjwxvKsTqGLkyaRPAV30B5oJuOfUXdME4uP4W+n
        Ur6TYW/KE4BMDTOQVHENS58=
X-Google-Smtp-Source: ACHHUZ4KIAlW/zpvww/YX9ZRyQer1/jw0BjA72Duf6MXqTA5icpc5wNDFZ2Dj7eyKkkedJ9UQ0itRA==
X-Received: by 2002:adf:db4e:0:b0:309:4123:4968 with SMTP id f14-20020adfdb4e000000b0030941234968mr1415027wrj.13.1684354589699;
        Wed, 17 May 2023 13:16:29 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.236.195])
        by smtp.gmail.com with ESMTPSA id h14-20020adffd4e000000b00304aba2cfcbsm3762683wrs.7.2023.05.17.13.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 13:16:29 -0700 (PDT)
Message-ID: <b28c60cb-a923-967c-887a-71a6590363f1@gmail.com>
Date:   Wed, 17 May 2023 21:11:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH for-next 2/2] nvme: optimise io_uring passthrough
 completion
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, kbusch@kernel.org,
        sagi@grimberg.me, joshi.k@samsung.com
References: <cover.1684154817.git.asml.silence@gmail.com>
 <ecdfacd0967a22d88b7779e2efd09e040825d0f8.1684154817.git.asml.silence@gmail.com>
 <20230517072314.GC27026@lst.de>
 <9367cc09-c8b4-a56c-a61a-d2c776c05a1c@gmail.com>
 <20230517123921.GA19835@lst.de>
 <61787b53-3c16-8cdb-eaad-6c724315435b@gmail.com>
 <20230517135344.GA26147@lst.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230517135344.GA26147@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/23 14:53, Christoph Hellwig wrote:
> On Wed, May 17, 2023 at 02:30:47PM +0100, Pavel Begunkov wrote:
>> Aside that you decided to ignore the third point, that's a
>> generic interface, not nvme specific, there are patches for
>> net cmds, someone even tried to use it for drm. How do you
>> think new users are supposed to appear if the only helper
>> doing the job can hang the userspace for their use case?
>> Well, then maybe it'll remain nvme/ublk specific with such
>> an approach.
> 
> New users can add new code when it's actualy needed.  We don't
> bloat the kernel for maybe in the future crap as a policy.

Let me put it for you this way, it's an absolutely horrendous
idea to leave the old innocently looking name, i.e.
io_uring_cmd_complete_in_task(), and add there a bunch of
restrictions no new user would care about, that's called
shooting yourself in the leg.

So, we need to rename the function, which, again, for absolutely
no reason adds dependency on ublk. Why doing that instead of
waiting until ublk is converted? That's a big mystery.

-- 
Pavel Begunkov
