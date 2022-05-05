Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999E451CAC9
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 22:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385220AbiEEUsZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 16:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358434AbiEEUsY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 16:48:24 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C29153B44
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 13:44:43 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id x18so5481601plg.6
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 13:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EJXLCiD9UDZlUYXKklp0jgNiM5rwP1N2foOUIK+GKBY=;
        b=7i/BmXtCmZ4oyXj60UgpglyLR8gU7E2SF8NgOJE4KvXOUgeuv6c4DY1BcwiW+rVfu0
         TUnwLJi7DGAAgAsiodnsjDtEUpvaW4uhXuyBAJPWmVSZYMI1dGUeihQCDLlTD/rxlxYy
         BfAB1QB7RV3EI1H8DSNmbL1kfH4NxBofrZgqdfl7ThZxmmRvUt7gy0CLNWhuQbQpT0ik
         cgaFoHhxFq7G80NaaidLdyCTvUN6fUmraGbGcnPGrd2FdtVlYJdBxvk8FNOHXIk5tj4o
         PxK1HQlIS8VivfIaLVGOJ+0y7B8j3oX/dCjq6hBZOHmF0CE1+nN+yr5ENYoBo29wVdYm
         8nDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EJXLCiD9UDZlUYXKklp0jgNiM5rwP1N2foOUIK+GKBY=;
        b=fLcV611wVrkE7Za/tyUrCWB8c0omFgway1a/tR3UnDWj8AuVzgerOSouCZ0SL5WPJI
         g0VWxvn2HqjFXJwKDowZBY5jV4ONVNhgaxAalKrOa2gzGkfAFQ/oPbwDh6fXyKhJByj7
         eDm3ujVxSB7APB8QCmSWwJK5U9NQcneI1+0tQlVVx01rj4cfYwUb7R4EnUVMMPZGoG+u
         mVZDJJmhkN7XulYljFykztJKS0h3frwhGDaLFzXGeNhZ7nqu67oXsAJM3hpX6GApLDh0
         peZbDtop+w6lIdgBUh46il6kzfiDGU82RGDl3rjehwbIVWT4PAny29pqwTrVNtifyFhO
         uiiQ==
X-Gm-Message-State: AOAM533XiIgXz6eVhXuACcQ9kf3DIIUQRVV3HQtBNT4kLiJAIt+L0pBz
        d88J3OnECwD82wkwmTSatlZAlw==
X-Google-Smtp-Source: ABdhPJyBxT9jGHq/XhhcjPyUc3/uizRAZtCuOS91jlBx4ShXxBud24XZyQhZ6ZTmhPEF1Ahsn7i2Fg==
X-Received: by 2002:a17:90a:4f0b:b0:1d9:acbd:1204 with SMTP id p11-20020a17090a4f0b00b001d9acbd1204mr8262151pjh.201.1651783482938;
        Thu, 05 May 2022 13:44:42 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id q21-20020a170902789500b0015e8d4eb1dcsm76060pll.38.2022.05.05.13.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 13:44:42 -0700 (PDT)
Message-ID: <06a03ddf-215a-b558-4ff6-bae46c33d51d@kernel.dk>
Date:   Thu, 5 May 2022 14:44:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 3/5] nvme: refactor nvme_submit_user_cmd()
Content-Language: en-US
To:     "hch@lst.de" <hch@lst.de>
Cc:     Clay Mayers <Clay.Mayers@kioxia.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>, "shr@fb.com" <shr@fb.com>,
        "joshiiitr@gmail.com" <joshiiitr@gmail.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061148epcas5p188618b5b15a95cbe48c8c1559a18c994@epcas5p1.samsung.com>
 <20220505060616.803816-4-joshi.k@samsung.com>
 <80cde2cfd566454fa4b160492c7336c2@kioxia.com>
 <ce25812c-9cf4-efe5-ac9e-13afd5803e64@kernel.dk>
 <93e697b1-42c5-d2f4-8fb8-7b5d1892e871@kernel.dk>
 <0b16682a30434d9c820a888ae0dc9ac5@kioxia.com>
 <70c1a8d3-ed82-0a5b-907a-7d6bedd73ccc@kernel.dk>
 <20220505195039.GA7032@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220505195039.GA7032@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/22 1:50 PM, hch@lst.de wrote:
> On Thu, May 05, 2022 at 01:31:28PM -0600, Jens Axboe wrote:
>>>> Jens Axboe
>>>
>>> This does work and got me past the null ptr segfault.
>>
>> OK good, thanks for testing. I did fold it in.
> 
> It might make sense to just kill nvme_meta_from_bio and pass the
> meta pointer directly with this version of the code.

Do you want to do an incremental for that? Looking at
nvme_execute_user_rq() and nvme_uring_task_cb() there's a fair bit of
duplication of the meta copy.

-- 
Jens Axboe

