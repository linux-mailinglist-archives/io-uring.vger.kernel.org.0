Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FCD7B5DFF
	for <lists+io-uring@lfdr.de>; Tue,  3 Oct 2023 02:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbjJCAMx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Oct 2023 20:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjJCAMx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Oct 2023 20:12:53 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E35A7
        for <io-uring@vger.kernel.org>; Mon,  2 Oct 2023 17:12:50 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 46e09a7af769-6c6591642f2so54582a34.1
        for <io-uring@vger.kernel.org>; Mon, 02 Oct 2023 17:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696291969; x=1696896769; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3ZYFOCnJg3JB+NMDyiBkV1Ci3jAh1uzwfMkuIhs6hs0=;
        b=ZxK+ppqIAwBoLU4Zrlxbxl99bJyWSPO4YXpbA+aA5+U6dM6VaTw63DAV7ypdcRALLK
         yBwp4EY5sxDocSj8s/C6z13uZXD3A09KH5mBLmmig3gV6XiG29EY/mB2Tf1PfFWxRSUR
         FoX8DYHyYO1FWJEzZC/67CVuBck8rz8XOvIjFo9SAm1AosXqQmPdB7nVsSZsBzJKPV3i
         v8vB26ygaMFeX9CQ5p4xdisvL+xmkVDrCap42GCGd2AfyEQo6GlFFwQrWKv78ZHFv/Nz
         lmla6ezeiAA8EGRBRUkUSKsVFQ/GJFfKq3Ctl140G0Vgwic81uR3FlsWTKJuBAhFENrQ
         BsKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696291969; x=1696896769;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZYFOCnJg3JB+NMDyiBkV1Ci3jAh1uzwfMkuIhs6hs0=;
        b=i+1l0zJEjGprhqnLP6kqjYR1r088swlaQXgQQZB95MBvUFXss5pzaD4YE/ZYEiIH87
         bbjdKVWggh1zQtotmoLIaL4SZD54/Ur0NI+bHnVJyAwcIbJ/qWe8GAZ4tJsaIBTi4ycZ
         0ikonlP8VXO8M6g8rsbbaa1bf6WMgaD2AfD8+LyoAMVcIn5PdvwOndtuCYi7hpxGlH1c
         MjWZJ7ZdyxeQ5/Y+JcPBXNhZy5v/wKoNZImSSwB+ygwBEGtlQm/TQYV3cdYP2dAmEIeg
         WSJGkRrYunG17GrKDKItvx6RGobprsP8fa8FxL2f9KN58Ya6vrFv3vNO8X6b4V4fvvBZ
         SzUA==
X-Gm-Message-State: AOJu0YxNTPybi9ZDbaBTzZQ/FOFE9nOECPJkw65jHD7QK2kU44Fe0H1m
        m7a70CYWIfNkvvMrBAumjynaIg==
X-Google-Smtp-Source: AGHT+IF9baUR9p6DAKFjII/kVTO/AjJMvz3lg30gHWN7cn7bssakhG73wKi092cOJs92S3iO0TpdEQ==
X-Received: by 2002:a05:6358:c610:b0:147:eb87:3665 with SMTP id fd16-20020a056358c61000b00147eb873665mr10087049rwb.3.1696291969642;
        Mon, 02 Oct 2023 17:12:49 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id f17-20020aa782d1000000b0068bc6a75848sm71459pfn.156.2023.10.02.17.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 17:12:48 -0700 (PDT)
Message-ID: <fa467e6b-12be-4234-914f-02ec5c787412@kernel.dk>
Date:   Mon, 2 Oct 2023 18:12:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in __io_remove_buffers (2)
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     syzbot <syzbot+2113e61b8848fa7951d8@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000af635c0606bcb889@google.com>
 <7567c27a-b5d0-41fc-a7e5-d65ed168b39c@kernel.dk>
In-Reply-To: <7567c27a-b5d0-41fc-a7e5-d65ed168b39c@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/23 10:43 AM, Jens Axboe wrote:
> On 10/2/23 8:38 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    ec8c298121e3 Merge tag 'x86-urgent-2023-10-01' of git://gi..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=16ef0ed6680000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3be743fa9361d5b0
>> dashboard link: https://syzkaller.appspot.com/bug?extid=2113e61b8848fa7951d8
>> compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>> userspace arch: arm
> 
> I tried the syz repro in the console output, but can't trigger it. It
> also makes very little sense to me... For when there is a reproducer,
> the below would perhaps shed some light on it. We have bl->is_mapped ==
> 1, yet bl->buf_ring is NULL. Probably some artifact of 32-bit arm?

I think this is 32-bit and highmem... The page being mapped into the
kernel is a highmem page, and this won't really fly with having a
permanent ->buf_ring address which we get from page_address().

-- 
Jens Axboe

