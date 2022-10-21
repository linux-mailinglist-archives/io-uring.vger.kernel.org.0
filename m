Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9B46074CD
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 12:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiJUKPu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 06:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiJUKPr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 06:15:47 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE743DF07
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 03:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=rhBn358FG+NPHdWDZnRVsj24lAfjLHdW/V4wWFAek6g=; b=Z3aVr0s4LZ1lr3UM9QVZljoaXR
        zRc5xBlBapbiCdEcsz/GhBm0Q6fPOLk3ubYhgh+a+oD7J9jxDWw9LIDHTXyfgBpA/HcTwr6orH9D5
        IO/yXTJEkvdtAO1neqlm3eHE40nBm2wiMxGF3hlSSz59EmjmFyccVZCOkgHTcHsGMm96N7OeCnPUU
        7wztdQfF/rZDSvpqTIZ8Q/I5kIqMRRJMERT4dd39MZaxCpCkQNFG3x96lOGCExHasTIxN/fzvObWf
        mNDyn6+mz3qoeigw6lyhfaSoeNwLhOF+yI5kgGHeaIbMEKasnw/pI4v8jkDONdJ/jykBhHlIyzoSS
        05HkGzMsRTCtmtiviHzM1IHK53fAFKWzNkONFKMJmw5gSoG5YZhD7RQ4X+ZwZMBXAiDEjnNCWADia
        9s6TVQlw6CCVBhyo/llK+hT4dmHBLMzbKiHE+1khfk8Uh39Y8d3GkeUrYUd+2aFvCs9djLGV8V6um
        ixF9dtK3aqhxyGC8qsXBr9/H;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olp43-0058xG-51; Fri, 21 Oct 2022 10:15:43 +0000
Message-ID: <7b82ab4e-8612-02dc-865d-b5333e7ad534@samba.org>
Date:   Fri, 21 Oct 2022 12:15:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
 <3e7b7606-c655-2d10-f2ae-12aba9abbc76@samba.org>
 <ae88cd67-906a-7c89-eaf8-7ae190c4674b@gmail.com>
 <86763cf2-72ed-2d05-99c3-237ce4905611@samba.org>
 <fc3967d3-ef72-7940-2436-3d8aa329151e@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: IORING_SEND_NOTIF_USER_DATA (was Re: IORING_CQE_F_COPIED)
In-Reply-To: <fc3967d3-ef72-7940-2436-3d8aa329151e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel, and others...

>> As far as I can see io_send_zc_prep has this:
>>
>>          if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>>                  return -EINVAL;
>>
>> both are u64...
> 
> Hah, true, completely forgot about that one

BTW: any comment on my "[RFC PATCH 0/8] cleanup struct io_uring_sqe layout"
thread, that would make it much easier to figure out which fields are used..., see
https://lore.kernel.org/io-uring/cover.1660291547.git.metze@samba.org/#r

metze

