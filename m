Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618B16E69A6
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 18:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjDRQgh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 12:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjDRQgg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 12:36:36 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B147FAF1E;
        Tue, 18 Apr 2023 09:36:34 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id xi5so74754602ejb.13;
        Tue, 18 Apr 2023 09:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681835793; x=1684427793;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=firv3UGoqvxYldJ99Jk2hJXEsEXc9axyjdwnWEFhPRU=;
        b=UJTmwTLfK7gzjWpk59vzvefvASBiulJ0QkWTf9/qX8GjD3/AoUPvgl1CYbUl+TC4Iv
         jAHDd7WOsIsQ8NxHPjR2p4CZJoSUw+iYbhCR7kkNe0qJ2iOp5jen5CpS0t2P3gABceHe
         x6WFwuQNVSyFUIe7effWCKF3PQ317mgoIdSb2h22Ao2QxGIf4vH5FHyBBq7tUQuoDBil
         KcJux8IYwGER7tKimpE0+WKeEpcJiZnBiqnRkr8tMf1G5uF6okVXObvMyJAXoVt42cmF
         5A8DBppQvHpu4bMZ1Qm9dqkn0pEkU3Au9pu1rHjOgxgoQdCmupH9GRp2DdN/ygDJuUq7
         xs4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681835793; x=1684427793;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=firv3UGoqvxYldJ99Jk2hJXEsEXc9axyjdwnWEFhPRU=;
        b=A0qSgciqXTOn0JT0oQMeOZNQHo88MatMZ3uwjqfK7mxmgCWc7mlfqPB0iLdiZp2UaG
         a0G3+qiekjszzPg7hTjqGKAJZBndnI4IIBxg3QMx6r4lAIxFkgM5/bhOM9o1+Si4Ygf4
         Qv/lmHFEdAb85rWdD8CplmwqAmv8Txv13a1w2ZBSrml5xtG402furnt2KFFeNKjKxPnG
         VCOPombfYV3OMVescXu6mq6uXttW/bmxk5WupRJXtmItH4fnc/rpzCwt1k5IzsMENmcS
         trltwpWF4+J8uo8LUXT5hoxi1MI7pskQAU0K6+ecRhgDzQiscbZNWgK5tlGgQCZvb647
         Y/IQ==
X-Gm-Message-State: AAQBX9dYTZYehLPTAIgUjJ9qJGxe9kDTeG0Vh6vdIawMfVrgkkC/VcKk
        /boOTL/yDJLIwgAVd/92OBVHbMGMjmg=
X-Google-Smtp-Source: AKy350bSVkwIygyfzsyibROo0o2+stVppG2cHS69Tg/Fd9UOby1gJOwpgHPMrBPqoP43v/jaT+hzUw==
X-Received: by 2002:a17:906:6dc4:b0:94f:ab46:77f9 with SMTP id j4-20020a1709066dc400b0094fab4677f9mr5288124ejt.15.1681835793029;
        Tue, 18 Apr 2023 09:36:33 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:5697])
        by smtp.gmail.com with ESMTPSA id rp26-20020a170906d97a00b0094f3132cb86sm4836485ejb.40.2023.04.18.09.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 09:36:32 -0700 (PDT)
Message-ID: <16b33cfe-acb2-760e-7e87-8a837f84fc66@gmail.com>
Date:   Tue, 18 Apr 2023 17:35:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5/7] io_uring: rsrc: use FOLL_SAME_FILE on
 pin_user_pages()
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
 <c19b3651-624b-f60e-3e63-fe9fadc6981f@gmail.com>
In-Reply-To: <c19b3651-624b-f60e-3e63-fe9fadc6981f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/23 17:25, Pavel Begunkov wrote:
> On 4/17/23 13:56, Jason Gunthorpe wrote:
>> On Sat, Apr 15, 2023 at 12:27:45AM +0100, Lorenzo Stoakes wrote:
>>> Commit edd478269640 ("io_uring/rsrc: disallow multi-source reg buffers")
>>> prevents io_pin_pages() from pinning pages spanning multiple VMAs with
>>> permitted characteristics (anon/huge), requiring that all VMAs share the
>>> same vm_file.
>>
>> That commmit doesn't really explain why io_uring is doing such a weird
>> thing.
>>
>> What exactly is the problem with mixing struct pages from different
>> files and why of all the GUP users does only io_uring need to care
>> about this?
> 
> Simply because it doesn't seem sane to mix and register buffers of
> different "nature" as one. It's not a huge deal for currently allowed
> types, e.g. mixing normal and huge anon pages, but it's rather a matter
> of time before it gets extended, and then I'll certainly become a
> problem. We've been asked just recently to allow registering bufs
> provided mapped by some specific driver, or there might be DMA mapped
> memory in the future.
> 
> Rejecting based on vmas might be too conservative, I agree and am all
> for if someone can help to make it right.

For some reason I thought it was rejecting if involves more than
one different vma. ->vm_file checks still sound fair to me, but in
any case, open to changing it.

-- 
Pavel Begunkov
